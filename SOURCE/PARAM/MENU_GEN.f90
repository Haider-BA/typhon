!------------------------------------------------------------------------------!
! MODULE : MENU_GEN                       Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : Juin 2003
!   D�finition des structures pour les entr�es du programme TYPHON
!   Structures pour les options g�n�rales
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module MENU_GEN

use TYPHMAKE   ! Definition de la precision

implicit none

! -- Variables globales du module -------------------------------------------


! -- DECLARATIONS -----------------------------------------------------------


!------------------------------------------------------------------------------!
! structure MNU_PROJECT : Param�tres du projet
!------------------------------------------------------------------------------!
type mnu_project
  integer         :: nzone      ! nombre de zones
  integer         :: ncoupling  ! nombre de couplages entre zones
  character       :: typ_coord  ! type de rep�re
  character       :: typ_temps  ! (S)tationnaire, (I)nstationnaire, (P)�riodique
  real(krp)       :: duree      ! dur�e de l'int�gration ou de la p�riode
  real(krp)       :: tpsbase    ! pas de temps de base pour le couplage
  integer         :: ncycle     ! nombre de cycle (en stationnaire ou p�riodique)
  real(krp)       :: residumax  ! valeur maximale du r�sidu admise (stationnaire)
  real(krp)       :: dtbase     ! pas de temps de base d'un cycle
endtype mnu_project


!------------------------------------------------------------------------------!
! structure MNU_OUTPUT : Param�tres du projet
!------------------------------------------------------------------------------!
type mnu_OUTPUT
  character       :: format     ! format de la sortie
  character(len=strlen) &
                  :: fichier    ! nom du fichier de sortie
  character       :: type       ! type de sortie (cf. VARCOM)
endtype mnu_OUTPUT

! -- INTERFACES -------------------------------------------------------------


! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
!contains


endmodule MENU_GEN

