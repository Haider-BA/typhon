!------------------------------------------------------------------------------!
! MODULE : INFO                           Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  : 
!   D�finition des structures de donn�es g�n�rales
!   Encapsulation de toutes les structures
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module INFO

use TYPHMAKE     ! Definition de la precision
use MENU_GEN    ! D�finition des param�tres g�n�raux
use DEFZONE        ! D�finition des zones (maillages)

implicit none

! -- Variables globales du module -------------------------------------------



! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! D�finition de la structure ST_WORLD : ensemble des donn�es
!------------------------------------------------------------------------------!
type st_world
  type(mnu_project)   :: prj        ! parametres g�n�raux du projet
  type(st_zone), dimension(:), pointer &
                      :: zone       ! liste de zones
  integer             :: noutput    ! nombre de d�finition des sorties
  type(mnu_output), dimension(:), pointer &
                      :: output     ! liste des sorties
endtype st_world


! -- INTERFACES -------------------------------------------------------------

interface new
  module procedure new_world
endinterface

interface delete
  module procedure delete_world
endinterface

! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
contains

!------------------------------------------------------------------------------!
! Proc�dure : sallocation d'une structure WORLD
!------------------------------------------------------------------------------!
subroutine new_world(world, nzone, noutput)
implicit none
type(st_world)    :: world
integer           :: nzone
integer, optional :: noutput

  world%prj%nzone = nzone
  allocate(world%zone(nzone))

  if (present(noutput)) then
    world%noutput = noutput
    allocate(world%output(noutput))
  else
    world%noutput = 0
  endif

endsubroutine new_world


!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure WORLD
!------------------------------------------------------------------------------!
subroutine delete_world(world)
implicit none
type(st_world)   :: world
integer          :: i     

  do i = 1, world%prj%nzone
    print*,"destruction de zone ",i !! DEBUG
    call delete(world%zone(i))
  enddo 
  deallocate(world%zone)

  if (world%noutput > 0) deallocate(world%output)

endsubroutine delete_world



endmodule INFO

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2003 (v0.0.1b): cr�ation du module
!------------------------------------------------------------------------------!
