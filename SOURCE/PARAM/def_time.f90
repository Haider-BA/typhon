!------------------------------------------------------------------------------!
! Procedure : def_time                    Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : 
!   Traitement des param�tres du fichier menu principal
!   Param�tres d'int�gration temporelle
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_time(block, deftime)

use RPM
use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_NUM
!DVT
use MENU_SOLVER

implicit none

! -- Declaration des entr�es --
type(rpmblock), target :: block

! -- Declaration des sorties --
!type(mnu_time) :: deftime
!DVT
type(mnu_solver) :: deftime

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: nkey           ! nombre de clefs
integer                  :: i
character(len=dimrpmlig) :: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

call print_info(5,"- D�finition des param�tres d'int�gration temporelle")

! -- Recherche du BLOCK:TIME_PARAM

pblock => block
call seekrpmblock(pblock, "TIME_PARAM", 0, pcour, nkey)

if (nkey /= 1) call erreur("lecture de menu", &
                           "bloc TIME_PARAM inexistant ou surnum�raire")



endsubroutine def_time
