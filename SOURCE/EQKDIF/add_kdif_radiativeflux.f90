!------------------------------------------------------------------------------!
! Procedure : add_kdif_radiativeflux                   Authors : J. Gressier
!                                                      Created : April 2005
! Fonction                                        
!  Add radiative flux to boundary fluxes
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine add_kdif_radiativeflux(defsolver, idef, umesh, ib, flux, stprim)

use TYPHMAKE
use OUTPUT
use VARCOM
use MATERIAU
use EQKDIF
use MENU_SOLVER
use MENU_BOCO
use USTMESH
use DEFFIELD 

implicit none

! -- Inputs --
type(mnu_solver)        :: defsolver        ! solver parameters
integer                 :: idef             ! boco defintion (defsolver%boco)
integer                 :: ib               ! domain boco definition
type(st_ustmesh)        :: umesh            ! unstructured mesh (cell, face, connectivity)
type(st_genericfield)   :: stprim           ! primitive state

! -- Outputs --
type(st_genericfield)   :: flux             ! physical flux

! -- Internal variables --
integer                 :: ifb, if, ic       ! index de liste, index de face limite et parametres
real(krp)               :: cst, Tfar4

! -- Body --

cst   = stefan_cst * defsolver%boco(idef)%boco_kdif%emmissivity
Tfar4 = defsolver%boco(idef)%boco_kdif%rad_Tinf**4

!---------------------------------------------------------------------
! add radiative term to flux (should eventually be initialized)

do ifb = 1, umesh%boco(ib)%nface
  if = umesh%boco(ib)%iface(ifb)
  ic = umesh%facecell%fils(if,2)    ! ghost cell is always right cell
  flux%tabscal(1)%scal(if) = flux%tabscal(1)%scal(if) + cst*(stprim%tabscal(1)%scal(ic)**4 -Tfar4)
enddo

endsubroutine add_kdif_radiativeflux

!------------------------------------------------------------------------------!
! Change history
!
! apr  2005 : created
!------------------------------------------------------------------------------!
