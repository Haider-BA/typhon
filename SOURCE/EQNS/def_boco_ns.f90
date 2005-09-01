!------------------------------------------------------------------------------!
! Procedure : def_boco_ns                 Author : J. Gressier
!                                         Date   : Novembre 2003
! Function                                Modif  : (cf historique)
!   Processing of main menu file parameters 
!   Main project parameters
!
! Faults/Limitations/Varia :
!
!------------------------------------------------------------------------------!
subroutine def_boco_ns(block, type, boco, unif)

use RPM
use TYPHMAKE
use VARCOM
use OUTPUT
use MENU_NS
use MENU_BOCO

implicit none

! -- Inputs --
type(rpmblock), target :: block    ! RPM block with all definitions
integer(kip)           :: unif     ! uniformity of boundary condition

! -- Outputs --
type(st_boco_ns) :: boco

! -- Inputs / Outputs --
integer(kip)           :: type     ! kind of boundary condition

! -- Internal variables --
type(rpmblock), pointer  :: pblock, pcour  ! RPM block pointer
integer(kip)             :: ib, nkey
character(len=dimrpmlig) :: str            ! intermediate RPM string
integer(kip)             :: info
integer(kip)             :: typ

! -- BODY --

pblock => block

select case(type)

case(bc_wall_adiab)
  typ = bc_wall_flux
  boco%flux = 0._krp

case(bc_wall_isoth)
  typ = bc_wall_isoth
  select case(unif)

  case(uniform)
    call rpmgetkeyvalreal(pblock, "WALL_TEMP", boco%temp_wall)

  case(nonuniform)
    boco%alloctemp = .true.
    call rpmgetkeyvalstr(pblock, "TEMP_FILE", str)
    boco%tempfile = str

  endselect

case(bc_wall_flux)
  typ = bc_wall_flux
  select case(unif)
  
  case(uniform)
    call rpmgetkeyvalreal(pblock, "WALL_FLUX", boco%flux)
    boco%flux = - boco%flux ! convention : flux out in the algorithm
                            ! BOCO convention : flux in for user

  case(nonuniform)
    boco%allocflux = .true.
    call rpmgetkeyvalstr(pblock, "FLUX_FILE", str)
    boco%fluxfile = str

  endselect

case(bc_inlet_sub)
  typ = bc_inlet_sub
   call rpmgetkeyvalreal(pblock, "PI",        boco%ptot)
   call rpmgetkeyvalreal(pblock, "TI",        boco%ttot)
   call rpmgetkeyvalstr (pblock, "DIRECTION", str)
   boco%direction = v3d_of(str, info)
   if (info /= 0) &
     call erreur("lecture de menu","probleme a la lecture du vecteur DIRECTION") 
   boco%direction = boco%direction / abs(boco%direction)
   !call erreur("Developpement","'bc_inlet_sub' : Cas non implemente")

case(bc_inlet_sup)
  typ = bc_inlet_sup
   call rpmgetkeyvalreal(pblock, "PI",        boco%ptot)
   call rpmgetkeyvalreal(pblock, "TI",        boco%ttot)
   call rpmgetkeyvalreal(pblock, "MACH",      boco%mach)
   call rpmgetkeyvalstr (pblock, "DIRECTION", str)
   boco%direction = v3d_of(str, info)
   if (info /= 0) &
     call erreur("lecture de menu","probleme a la lecture du vecteur DIRECTION") 
   boco%direction = boco%direction / abs(boco%direction)
   !call erreur("Developpement","'bc_inlet_sup' : Cas non implemente")

case(bc_outlet_sub)
  typ = bc_outlet_sub
  call rpmgetkeyvalreal(pblock, "P",         boco%pstat)
  !call erreur("Developpement","'bc_outlet_sub' : Cas non implemente")

case(bc_outlet_sup)
  typ = bc_outlet_sup
  !call erreur("Developpement","'bc_outlet_sup' : Cas non implemente")
  ! No parameter to read

case default
  call erreur("Lecture de menu","type de conditions aux limites non reconnu&
              & pour le solveur Navier-Stokes")
endselect

type = typ

endsubroutine def_boco_ns

!------------------------------------------------------------------------------!
! Changes history
!
! nov  2003 : creation
! june 2004 : definition and reading of boundary conditions(inlet/outlet)
! june 2005 : wall conditions
!------------------------------------------------------------------------------!


