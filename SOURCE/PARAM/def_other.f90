!------------------------------------------------------------------------------!
! Procedure : def_other                   Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : 
!   Traitement des param�tres du fichier menu principal
!   Param�tres principaux du projet
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_other(block )!  , defdivers)

use RPM
use TYPHMAKE
use OUTPUT
use VARCOM
!use MENU_

implicit none

! -- Declaration des entr�es --
type(rpmblock), target :: block

! -- Declaration des sorties --
!type(mnu_divers) :: prj

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: nkey           ! nombre de clefs
integer                  :: i
character(len=dimrpmlig) :: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

call print_info(5,"- D�finition des param�tres optionnels")

! -- Recherche du BLOCK:OTHER

!pblock => block
!call seekrpmblock(pblock, "PROJECT", 0, pcour, nkey)

!if (nkey /= 1) call erreur("lecture de menu", &
!                           "bloc PROJECT inexistant ou surnum�raire")



endsubroutine def_other
