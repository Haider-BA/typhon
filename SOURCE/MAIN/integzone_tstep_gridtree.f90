!------------------------------------------------------------------------------!
! Procedure : integzone_tstep_usttree            Auteur : J. Gressier
!                                                Date   : March 2006
! Fonction                                       Modif  : (cf history)
!   Time Integration during one timestep of the whole UST grid TREE structure
!
!------------------------------------------------------------------------------!
subroutine integzone_tstep_gridtree(dt, zone)

use TYPHMAKE
use OUTPUT
use VARCOM
use DEFZONE
use MESHALE

implicit none

! -- Inputs --
real(krp)     :: dt              ! pas de temps propre a la zone
type(st_zone) :: zone            ! zone a integrer

! -- Outputs --
! retour des residus a travers le champ field de la structure zone

! -- Internal variables --
type(st_grid), pointer :: pgrid
real(krp)              :: curtime

! -- Body --


!! THIS ROUTINE SHOULD TRAVEL IN ALL LEVEL OF GRID TREE

!----------------------------------
! Initialization

curtime = zone%info%cycle_start + zone%info%cycle_time
pgrid => zone%gridlist%first
do while (associated(pgrid))

  call alloc_res(pgrid%info%field_loc)    ! internal test of allocation
  call alloc_cellgrad(pgrid%info%field_loc)   ! MUST BE TESTED
  call alloc_facegrad(pgrid%info%field_loc)   ! MUST BE TESTED

  call ale_meshupdate(pgrid%umesh, zone%defsolver, pgrid%optmem%gradcond_computed, curtime, dt) !1:zone%defsolver%nboco
  pgrid => pgrid%next
enddo


call integ_treelevel(dt, zone%info, zone%defsolver, &
                     zone%gridlist, zone%coupling, zone%ncoupling)

!-----------------------------
endsubroutine integzone_tstep_gridtree
!------------------------------------------------------------------------------!
! Changes history
!------------------------------------------------------------------------------!