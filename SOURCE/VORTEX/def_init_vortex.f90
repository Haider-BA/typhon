!------------------------------------------------------------------------------!
! Procedure : def_init_vortex             Auteur : J. Gressier
!                                         Date   : F�vrier 2004
! Fonction                                Modif  : (cf historique)
!   Traitement des param�tres du fichier menu principal
!   Param�tres d'initialisation (domaine de solveur VORTEX)
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_init_vortex(block, init)

use RPM
use TYPHMAKE
use VARCOM
use OUTPUT
use MENU_VORTEX

implicit none

! -- Declaration des entr�es --
type(rpmblock), target :: block    ! bloc RPM contenant les d�finitions
integer                :: type     ! type de condition aux limites

! -- Declaration des sorties --
type(st_init_vort)     :: init

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: ib, nkey
character(len=dimrpmlig) :: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

pblock => block

!call rpmgetkeyvalreal(pblock, "TEMP", init%temp)


endsubroutine def_init_vortex


!------------------------------------------------------------------------------!
! Historique des modifications
!
! fev  2004 : cr�ation de la routine
!------------------------------------------------------------------------------!


