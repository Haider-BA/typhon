!------------------------------------------------------------------------------!
! Procedure : integration_kdif_ust        Auteur : J. Gressier
!                                         Date   : Avril 2003
! Fonction                                Modif  :
!   Integration domaine par domaine
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine integration_kdif_ust(dt, defsolver, domaine)

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

!print*,"!!! DEBUG integration kdif"

! A ce niveau, on est cens� appeler une routine qui int�gre aussi bien les flux
! dans un domaine structur� que dans un domaine non structur�
! On peut ici d�couper la maillage complet en blocs de taille fix� pour optimiser
! l'encombrement m�moire et la vectorisation

call calc_kdif_flux(defsolver)


endsubroutine integration_kdif_ust

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avril 2003 (v0.0.1b): cr�ation de la proc�dure
!------------------------------------------------------------------------------!
