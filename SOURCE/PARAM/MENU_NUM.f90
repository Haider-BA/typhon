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

! -- Constantes pour le calcul du pas de temps
character, parameter :: stab_cond = 'S'
character, parameter :: given_dt  = 'T'

! -- Constantes pour sch�ma de calcul des flux hyperboliques (sch_hyp)
integer, parameter :: roe      = 10
integer, parameter :: hlle     = 20
integer, parameter :: hllc     = 25
integer, parameter :: stegwar  = 30
integer, parameter :: vanleer  = 31
integer, parameter :: efm      = 40

! -- Constantes pour sch�ma de calcul des flux dissipatifs (sch_dis)
integer, parameter :: dis_dif2 = 1     ! diff�rence des 2 �tats/face (NON CONSISTANT)
integer, parameter :: dis_avg2 = 5     ! moyenne des 2 gradients/face
integer, parameter :: dis_opt  = 10    ! �valuation compl�te (pond�r�e de 1 et 5)

! -- Constantes pour le calcul des gradients (gradmeth)
integer, parameter :: lsm1 = 10     ! moindres carr�s bas�e sur les centres voisins


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
  integer         :: max_it       ! nombre d'it�ration maximal
endtype mnu_imp

!------------------------------------------------------------------------------!
! structure MNU_TIME : options num�riques pour l'int�gration temporelle
!------------------------------------------------------------------------------!
type mnu_time
  character       :: temps      ! (S)tationnaire, (I)nstationnaire, (P)�riodique
  character       :: methode    ! m�thode d'int�gration temporelle
  logical         :: local_dt   ! methode de calcul du pas de temps (global/local)
  character       :: stab_meth  ! methode de calcul de la stabilit�
  real(krp)       :: dt, stabnb ! pas de temps fixe ou nombre de stabilit� associ�
                                !                      (CFL/Fourier)
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
  integer         :: sch_hyp      ! type de sch�ma pour les flux hyperboliques
  integer         :: sch_dis      ! type de sch�ma pour les flux dissipatifs
  character       :: methode      ! m�thode d'ordre �lev� (M)USCL, (E)NO
  integer         :: gradmeth     ! m�thode de calcul des gradients
  type(mnu_muscl) :: muscl        ! param�tres de la m�thode MUSCL
endtype mnu_spat


! -- INTERFACES -------------------------------------------------------------


! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
!contains


endmodule MENU_NUM


!------------------------------------------------------------------------------!
! Historique des modifications
!
! mai  2002 : cr�ation du module
! aout 2003 : param�tres pour l'int�gration temporelle (Fourier, r�sidu)
! sept 2003 : param�tres pour l'int�gration spatiale (calcul de gradients)
!------------------------------------------------------------------------------!
