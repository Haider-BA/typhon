!------------------------------------------------------------------------------!
! Procedure : def_other                   Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : 
!   Traitement des parametres du fichier menu principal
!   Parametres principaux du projet
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_other(block, isolver, defsolver )!  , defdivers)

use RPM
use TYPHMAKE
use OUTPUT
use VARCOM
!DVT
use MENU_SOLVER
!use MENU_

implicit none

! -- Declaration des entrees --
type(rpmblock), target :: block
!DVT
integer                :: isolver
type(mnu_solver) :: defsolver
! -- Declaration des sorties --
!type(mnu_divers) :: prj

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: nkey           ! nombre de clefs
integer                  :: i
character(len=dimrpmlig) :: str            ! chaine RPM intermediaire

! -- Debut de la procedure --

call print_info(5,"- Definition des parametres optionnels")

! -- Recherche du BLOCK:OTHER

!pblock => block
!call seekrpmblock(pblock, "PROJECT", 0, pcour, nkey)

!if (nkey /= 1) call erreur("lecture de menu", &
!                           "bloc PROJECT inexistant ou surnumeraire")



endsubroutine def_other
