!------------------------------------------------------------------------------!
! MODULE : MATERIAU                       Auteur : J. Gressier
!                                         Date   : Mai 2002
! Fonction                                Modif  :
!   Structures pour les param�tres MATERIAU du solveur de thermique
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
module MATERIAU

use TYPHMAKE      ! d�finition de la pr�cision des r�els
use MATER_LOI    ! d�finition g�n�rale d'une loi de variation des param�tres

implicit none

! -- Variables globales du module -------------------------------------------

character, parameter :: mat_LIN  = 'L'   ! mat�riau � propri�t�s constantes
character, parameter :: mat_KNL  = 'K'   ! mat�riau � cp constant et conductivit� non lin�aire
character, parameter :: mat_XMAT = 'X'   ! mat�riau � propri�t�s sp�cifiques

!------------------------------------------------------------------------------!
!    DECLARATIONS
!------------------------------------------------------------------------------!

!------------------------------------------------------------------------------!
! ST_MATERIAU : structure pour la d�finition des �quations
!------------------------------------------------------------------------------!
type st_materiau
  character(len=30) :: nom       ! nom du materiau
  character         :: type      ! cf constantes
  real(krp)         :: Cp        ! Capacit� calorifique
  type(st_loi)      :: Energie   ! Energie (fct de temp�rature)
  type(st_loi)      :: Kd        ! conductivit� thermique 
endtype st_materiau


! -- INTERFACES -------------------------------------------------------------


! -- Proc�dures, Fonctions et Operateurs ------------------------------------

!------------------------------------------------------------------------------!
!    IMPLEMENTATION 
!------------------------------------------------------------------------------!
!contains


endmodule MATERIAU

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mai   2002 (v0.0.1b): cr�ation du module
! avril 2003          : sp�cification des types de mat�riaux (LIN, KNL, XMAT)
!------------------------------------------------------------------------------!
