!------------------------------------------------------------------------------!
! Procedure : output_tecplot
!
! Fonction
!   Write zone as a TECPLOT result file
!
!------------------------------------------------------------------------------!
subroutine output_tecplot(nom, defio, zone)

use TYPHMAKE
use OUTPUT
use VARCOM
use DEFZONE
use MESHBASE
use MENU_GEN

implicit none

! -- Inputs --
character(len=*), intent(in) :: nom       ! filename
type(mnu_output)      :: defio     ! output parameter
type(st_zone)         :: zone      ! zone

! -- Outputs --

! -- Internal variables --
integer          :: info
character(len=8) :: suffix

! -- BODY --

suffix = ".dat"

open(unit=uf_chpresu, file=trim(nom)//trim(suffix), form='formatted', iostat = info)

select case(zone%defsolver%typ_solver)

case(solKDIF)

  write(uf_chpresu,'(a)') 'VARIABLES="X","Y","Z","T"'
  call output_tec_ust(uf_chpresu, zone%gridlist%first%umesh, &
       zone%gridlist%first%info%field_loc, defio%dataset, zone%defsolver)

case(solNS)

  write(uf_chpresu,'(a)') 'VARIABLES="X","Y","Z","u","v","w","P","T"'
  call output_tec_ust(uf_chpresu, zone%gridlist%first%umesh, &
       zone%gridlist%first%info%field_loc, defio%dataset, &
       zone%defsolver)

endselect

close(uf_chpresu)


endsubroutine output_tecplot

!------------------------------------------------------------------------------!
! Changes history
!
! dec  2002 : creation de la procedure
! avr  2004 : cas Vortex
! oct  2004 : field chained list
! May  2008 : simplication (suppression of vortex solver)
!------------------------------------------------------------------------------!

