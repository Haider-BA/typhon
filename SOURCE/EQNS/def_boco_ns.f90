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
use FCT_PARSER

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
type(v3d)                :: temp_direction

! -- BODY --

pblock => block

select case(type)

case(bc_wall_adiab)
  call rpmgetkeyvalstr (pblock, "WALL_VELOCITY", str, "(0., 0., 0.)")
  boco%wall_velocity = v3d_of(str, info)
  if (info /= 0) &
    call erreur("parsing parameters","unable to read WALL_VELOCITY data")
  typ = bc_wall_flux
  boco%flux = 0._krp

case(bc_wall_isoth)
  call rpmgetkeyvalstr (pblock, "WALL_VELOCITY", str, "(0., 0., 0.)")
  boco%wall_velocity = v3d_of(str, info)
  if (info /= 0) &
    call erreur("parsing parameters","unable to read WALL_VELOCITY data")
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
  call rpmgetkeyvalstr (pblock, "WALL_VELOCITY", str, "(0., 0., 0.)")
  boco%wall_velocity = v3d_of(str, info)
  if (info /= 0) &
    call erreur("parsing parameters","unable to read WALL_VELOCITY data")
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
  call rpmgetkeyvalstr(pblock, "PI", str)
  call convert_to_funct(str, boco%ptot, info)  
  if (info /= 0) &
       call erreur("menu definition","problem when parsing PI (NS boundary condition)") 
  call rpmgetkeyvalstr(pblock, "TI", str)
  call convert_to_funct(str, boco%ttot, info)  
  if (info /= 0) &
       call erreur("menu definition","problem when parsing TI (NS boundary condition)") 
  if (rpm_existkey(pblock, "DIRECTION")) then
    call rpmgetkeyvalstr (pblock, "DIRECTION", str)
    temp_direction = v3d_of(str, info)
    if (info /= 0) &
         call erreur("menu definition","problem when parsing DIRECTION vector (NS initialization)") 
    call convert_to_funct(temp_direction%x, boco%dir_x, info)
    call convert_to_funct(temp_direction%y, boco%dir_y, info)
    call convert_to_funct(temp_direction%z, boco%dir_z, info)
  else
    call rpmgetkeyvalstr(pblock, "DIR_X", str)
    if (info /= 0) &
    	call erreur("parsing parameters","unable to read DIR_X data (subsonic inlet)")
    call convert_to_funct(str, boco%dir_x, info)  
    call rpmgetkeyvalstr(pblock, "DIR_Y", str)
    if (info /= 0) &
    	call erreur("parsing parameters","unable to read DIR_Y data (subsonic inlet)")
    call convert_to_funct(str, boco%dir_y, info)  
    call rpmgetkeyvalstr(pblock, "DIR_Z", str)
    if (info /= 0) &
    	call erreur("parsing parameters","unable to read DIR_Z data (subsonic inlet)")
    call convert_to_funct(str, boco%dir_z, info)  
  endif

  ! boco%direction = boco%direction / abs(boco%direction) MOVED TO setboco_ns_inlet_sub.f90
  !call erreur("Development","'bc_inlet_sub' : Case not implemented")

case(bc_inlet_sup)
  typ = bc_inlet_sup
  call rpmgetkeyvalstr(pblock, "PI", str)
  call convert_to_funct(str, boco%ptot, info)  
  if (info /= 0) &
       call erreur("menu definition","problem when parsing PI (NS boundary condition)") 
  call rpmgetkeyvalstr(pblock, "TI", str)
  call convert_to_funct(str, boco%ttot, info)  
  if (info /= 0) &
       call erreur("menu definition","problem when parsing TI (NS boundary condition)") 
  call rpmgetkeyvalstr(pblock, "MACH", str)
  call convert_to_funct(str, boco%mach, info)  
  if (info /= 0) &
       call erreur("menu definition","problem when parsing MACH (NS boundary condition)") 
  if (rpm_existkey(pblock, "DIRECTION")) then
    call rpmgetkeyvalstr (pblock, "DIRECTION", str)
    temp_direction = v3d_of(str, info)
    if (info /= 0) &
         call erreur("menu definition","problem when parsing DIRECTION vector (NS initialization)") 
    call convert_to_funct(temp_direction%x, boco%dir_x, info)
    call convert_to_funct(temp_direction%y, boco%dir_y, info)
    call convert_to_funct(temp_direction%z, boco%dir_z, info)
  else
    call rpmgetkeyvalstr(pblock, "DIR_X", str)
    if (info /= 0) &
    	call erreur("parsing parameters","unable to read DIR_X data (supersonic inlet)")
    call convert_to_funct(str, boco%dir_x, info)  
    call rpmgetkeyvalstr(pblock, "DIR_Y", str)
    if (info /= 0) &
    	call erreur("parsing parameters","unable to read DIR_Y data (supersonic inlet)")
    call convert_to_funct(str, boco%dir_y, info)  
    call rpmgetkeyvalstr(pblock, "DIR_Z", str)
    if (info /= 0) &
    	call erreur("parsing parameters","unable to read DIR_Z data (supersonic inlet)")
    call convert_to_funct(str, boco%dir_z, info)  
  endif

  ! boco%direction = boco%direction / abs(boco%direction) MOVED TO setboco_ns_inlet_sup.f90
  !call erreur("Development","'bc_inlet_sup' : Case not implemented")

case(bc_outlet_sub)
  typ = bc_outlet_sub
  call rpmgetkeyvalstr(pblock, "P", str)
  call convert_to_funct(str, boco%pstat, info)  
  if (info /= 0) &
       call erreur("menu definition","problem when parsing (static pressure) P (NS boundary condition)") 
  !call erreur("Development","'bc_outlet_sub' : Case not implemented")

case(bc_outlet_sup)
  typ = bc_outlet_sup
  !call erreur("Development","'bc_outlet_sup' : Case not implemented")
  ! No parameter to read

case default
  call erreur("reading menu","unknown boundary condition type for Navier-Stokes solver")
endselect

type = typ

endsubroutine def_boco_ns

!------------------------------------------------------------------------------!
! Changes history
!
! nov  2003 : creation
! june 2004 : definition and reading of boundary conditions(inlet/outlet)
! june 2005 : wall conditions
! nov  2006 : NS wall conditions with WALL_VELOCITY
! fev  2007 : English translation
! feb  2011 : symbolic funcions support added for inlet DIRECTION (A. Gardi)
!------------------------------------------------------------------------------!
