!------------------------------------------------------------------------------!
! Procedure : calc_flux_euler             Auteur : J. Gressier
!                                         Date   : Aout 2002
! Fonction                                Modif  :
!   Calcul des flux des �quations d'Euler
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine calc_flux_euler(typ_solver, domaine)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use STRMESH

implicit none

! -- Declaration des entr�es --
type(mnu_solver) :: typ_solver       ! type d'�quation � r�soudre
type(st_block)   :: domaine          ! domaine structur� � int�grer

! -- Declaration des sorties --
! domaine

! -- Declaration des variables internes --


! -- Debut de la procedure --



endsubroutine calc_flux_euler
