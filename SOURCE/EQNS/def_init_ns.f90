!------------------------------------------------------------------------------!
! Procedure : def_init_ns                 Auteur : J. Gressier
!                                         Date   : Octobre 2003
! Fonction                                Modif  : 
!   Traitement des param�tres du fichier menu principal
!   Param�tres principaux du projet
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_init_ns(block)!, init)

use RPM
use TYPHMAKE
use VARCOM
use OUTPUT
use MENU_NS

implicit none

! -- Declaration des entr�es --
type(rpmblock), target :: block    ! bloc RPM contenant les d�finitions
integer                :: type     ! type de condition aux limites

! -- Declaration des sorties --
!type(st_init_ns) :: init

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: ib, nkey
character(len=dimrpmlig) :: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

pblock => block

!call rpmgetkeyvalreal(pblock, "TEMP", init%temp)


endsubroutine def_init_ns


!------------------------------------------------------------------------------!
! Historique des modifications
!
! oct  2003 : cr�ation de la routine
!------------------------------------------------------------------------------!


