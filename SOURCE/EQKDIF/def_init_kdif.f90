!------------------------------------------------------------------------------!
! Procedure : def_init_kdif               Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  : 
!   Traitement des param�tres du fichier menu principal
!   Param�tres principaux du projet
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_init_kdif(block, init)

use RPM
use TYPHMAKE
use VARCOM
use OUTPUT
use MENU_KDIF

implicit none

! -- Declaration des entr�es --
type(rpmblock), target :: block    ! bloc RPM contenant les d�finitions
integer                :: type     ! type de condition aux limites

! -- Declaration des sorties --
type(st_init_kdif) :: init

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: ib, nkey
character(len=dimrpmlig) :: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

pblock => block

call rpmgetkeyvalreal(pblock, "TEMP", init%temp)


endsubroutine def_init_kdif


!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2003 (v0.0.1b): cr�ation de la routine
!------------------------------------------------------------------------------!


