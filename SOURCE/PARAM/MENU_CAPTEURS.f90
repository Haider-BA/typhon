!------------------------------------------------------------------------------!
! MODULE : MENU_CAPTEURS                  Auteur : J. Gressier
!                                         Date   : Juillet 2003
! Fonction                                Modif  : (cf Historique)
!   D�finition des structures pour les entr�es du programme TYPHON
!   Structures pour la d�finition des capteurs
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
module MENU_CAPTEURS

use TYPHMAKE   ! Definition de la precision
use GEO3D      ! D�finition des vecteurs 3D

implicit none

! -- Variables globales du module -------------------------------------------

! -- type de capteur --
character, parameter :: probe         = 'P'    ! calcul ponctuel d'une quantit�
character, parameter :: boco_field    = 'F'    ! restitution d'un champ sur boco
character, parameter :: boco_integral = 'I'    ! int�grale   d'un champ sur boco
character, parameter :: residuals     = 'R'    ! calcul de r�sidu moyen

! -- type de stockage --
character, parameter :: phys_tstep = 'T'       ! � chaque cycle
character, parameter :: ziter      = 'Z'       ! pour chaque it�ration interne de zone


! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! structure MNU_CAPTEUR : options num�riques les capteurs
!------------------------------------------------------------------------------!
type mnu_capteur
  character             :: type        ! type de capteur
  character             :: store       ! type de stockage
  character(len=strlen) :: family      ! famille associ�e (si n�cessaire)
                                       !   DEV: on peut extrapoler � plusieurs familles
  integer               :: quantity    ! quantit� � calculer (selon solveur)
  type(v3d)             :: center, dir ! vecteurs centre et direction (si n�cessaire)
endtype mnu_capteur


! -- INTERFACES -------------------------------------------------------------

interface delete
  module procedure delete_mnu_capteur
endinterface

! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
contains

!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure MNU_SOLVER
!------------------------------------------------------------------------------!
subroutine delete_mnu_capteur(defcapteur)
implicit none
type(mnu_capteur)  :: defcapteur

  print*,'!! DEBUG destruction de structure "param�tres" � compl�ter'

endsubroutine delete_mnu_capteur



endmodule MENU_CAPTEURS


!------------------------------------------------------------------------------!
! Historique des modifications
!
! juil 2003 : cr�ation du module
!
! am�liorations futures : capteurs sur plusieurs familles simultan�ment
!------------------------------------------------------------------------------!




