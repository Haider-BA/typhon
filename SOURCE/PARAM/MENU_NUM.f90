!------------------------------------------------------------------------------!
! MODULE : MENU_NUM                       Auteur : J. Gressier
!                                         Date   : Mai 2002
! Fonction                                Modif  : Novembre 2002
!   D�finition des structures pour les entr�es du programme TYPHON
!   Structures pour les options num�riques
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module MENU_NUM

use TYPHMAKE   ! Definition de la precision

implicit none

! -- Variables globales du module -------------------------------------------

! -- Constantes pour le choix du param�tre "temps"
!character, parameter :: stationnaire   = 'S'
!character, parameter :: instationnaire = 'I'
!character, parameter :: periodique     = 'P'


! -- DECLARATIONS -----------------------------------------------------------


!------------------------------------------------------------------------------!
! structure MNU_RK : options num�riques pour la m�thode Runge Kutta
!------------------------------------------------------------------------------!
type mnu_rk
  integer         :: ordre        ! ordre d'int�gration temporelle Runge-Kutta
endtype mnu_rk

!------------------------------------------------------------------------------!
! structure MNU_IMP : options num�riques pour l'implicitation
!------------------------------------------------------------------------------!
type mnu_imp
  character       :: methode      ! (A)DI
  real(krp)       :: ponderation  ! ponderation implicite/explicite
endtype mnu_imp

!------------------------------------------------------------------------------!
! structure MNU_TIME : options num�riques pour l'int�gration temporelle
!------------------------------------------------------------------------------!
type mnu_time
  !character       :: temps      ! (S)tationnaire, (I)nstationnaire, (P)�riodique
  character       :: methode    ! m�thode d'int�gration temporelle
  type(mnu_rk)    :: rk         ! param�tres de la m�thode Runge Kutta
  type(mnu_imp)   :: implicite  ! param�tres pour la m�thode d'implicitation
endtype mnu_time

!------------------------------------------------------------------------------!
! structure MNU_MUSCL : options num�riques pour la m�thode MUSCL
!------------------------------------------------------------------------------!
type mnu_muscl
  real(krp)      :: precision     ! param�tre de pr�cision
  real(krp)      :: compression   ! param�tre de compression
  character      :: limiteur      ! limiteur (X) aucun, (M)inmod, (V)an Leer
                                  !          (A) Van Albada, (S)uperbee
endtype mnu_muscl

!------------------------------------------------------------------------------!
! structure MNU_SPAT : options num�riques pour l'int�gration spatiale
!------------------------------------------------------------------------------!
type mnu_spat
  integer         :: ordre        ! ordre d'int�gration spatiale
  character       :: methode      ! m�thode d'ordre �lev� (M)USCL, (E)NO
  type(mnu_muscl) :: muscl        ! param�tres de la m�thode MUSCL
endtype mnu_spat


! -- INTERFACES -------------------------------------------------------------


! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
!contains


endmodule MENU_NUM

