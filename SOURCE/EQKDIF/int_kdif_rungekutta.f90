!------------------------------------------------------------------------------!
! Procedure : int_eqkdif_rungekutta       Auteur : J. Gressier
!                                         Date   : Avril 2003
! Fonction                                Modif  :
!   Integration domaine par domaine
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine int_eqkdif_rungekutta(dt, defsolver, domaine)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use USTMESH

implicit none

! -- Declaration des entr�es --
real(krp)        :: dt               ! pas de temps CFL
type(mnu_solver) :: defsolver        ! type d'�quation � r�soudre
type(st_ustmesh) :: domaine          ! domaine non structur� � int�grer

! -- Declaration des sorties --
! domaine

! -- Declaration des variables internes --


! -- Debut de la procedure --

print*,"!!! DEBUG integration eqkdif"



endsubroutine int_eqkdif_rungekutta

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avril 2003 (v0.0.1b): cr�ation de la proc�dure
!------------------------------------------------------------------------------!
