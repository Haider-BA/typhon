!------------------------------------------------------------------------------!
! MODULE : MENU_NUM                       Auteur : J. Gressier
!                                         Date   : Mai 2002
! Fonction                                Modif  : (cf historique)
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
integer(kpp), parameter :: given_dt  = 1
integer(kpp), parameter :: stab_cond = 2

! -- Constantes pour la m�thode d'int�gration temporelle
integer(kpp), parameter :: tps_expl  = 10   ! int�gration explicite basique
integer(kpp), parameter :: tps_impl  = 20   ! int�gration implicite lin�aris� (theta sch�ma)
integer(kpp), parameter :: tps_dualt = 25   ! int�gration implicite / convergence locale
integer(kpp), parameter :: tps_rk    = 30   ! int�gration en Runge Kutta explicite

! -- Constantes pour sch�ma de calcul des flux hyperboliques (sch_hyp)
integer(kpp), parameter :: roe      = 10
integer(kpp), parameter :: hlle     = 20
integer(kpp), parameter :: hllc     = 25
integer(kpp), parameter :: stegwar  = 30
integer(kpp), parameter :: vanleer  = 31
integer(kpp), parameter :: efm      = 40

! -- Constantes pour sch�ma de calcul des flux dissipatifs (sch_dis)
integer(kpp), parameter :: dis_dif2 = 1     ! diff�rence des 2 �tats/face (NON CONSISTANT)
integer(kpp), parameter :: dis_avg2 = 5     ! moyenne des 2 gradients/face
integer(kpp), parameter :: dis_full = 10    ! �valuation compl�te (pond�r�e de 1 et 5)

! -- Constantes pour le calcul des gradients (gradmeth)
integer(kpp), parameter :: lsm1 = 10     ! moindres carr�s bas�e sur les centres voisins

! -- Constantes pour la m�thode de r�solution matricielle
integer(kpp), parameter :: alg_lu    = 10  ! r�solution directe LU
integer(kpp), parameter :: alg_cho   = 15  ! resolution directe (d�composition Choleski) (SYM)
integer(kpp), parameter :: alg_jac   = 20  ! resolution it�rative Jacobi
integer(kpp), parameter :: alg_gs    = 25  ! resolution it�rative Gauss-Seidel
integer(kpp), parameter :: alg_sor   = 26  ! resolution it�rative Gauss-Seidel avec OverRelaxation
integer(kpp), parameter :: alg_gmres = 40  ! resol. par proj. : GMRES


! -- DECLARATIONS -----------------------------------------------------------


!------------------------------------------------------------------------------!
! structure MNU_RK : options num�riques pour la m�thode Runge Kutta
!------------------------------------------------------------------------------!
type mnu_rk
  integer(kpp)    :: ordre        ! ordre d'int�gration temporelle Runge-Kutta
endtype mnu_rk

!------------------------------------------------------------------------------!
! structure MNU_IMP : options num�riques pour l'implicitation
!------------------------------------------------------------------------------!
type mnu_imp
  integer(kpp)    :: methode      ! (A)DI
  integer(kpp)    :: max_it       ! nombre d'it�ration maximal
  real(krp)       :: ponderation  ! ponderation implicite/explicite
  real(krp)       :: maxres       ! residu maximal pour convergence de l'inversion
endtype mnu_imp

!------------------------------------------------------------------------------!
! structure MNU_TIME : options num�riques pour l'int�gration temporelle
!------------------------------------------------------------------------------!
type mnu_time
  integer(kpp)    :: temps      ! (S)tationnaire, (I)nstationnaire, (P)�riodique
  integer(kpp)    :: tps_meth   ! m�thode d'int�gration temporelle
  logical         :: local_dt   ! methode de calcul du pas de temps (global/local)
  integer(kpp)    :: stab_meth  ! methode de calcul de la stabilit�
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
  integer(kpp)    :: ordre        ! ordre d'int�gration spatiale
  integer(kpp)    :: sch_hyp      ! type de sch�ma pour les flux hyperboliques
  integer(kpp)    :: sch_dis      ! type de sch�ma pour les flux dissipatifs
  character       :: methode      ! m�thode d'ordre �lev� (M)USCL, (E)NO
  integer(kpp)    :: gradmeth     ! m�thode de calcul des gradients
  logical         :: calc_grad    ! n�cessite le calcul des gradients
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
