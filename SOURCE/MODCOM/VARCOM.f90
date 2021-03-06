!----------------------------------------------------------------------------------------
! MODULE : VARCOM                         Auteur : J. Gressier
!                                         Date   : Octobre 2002
! Function                                Modif  : (cf historique)
!   TYPHON global variables
!
!----------------------------------------------------------------------------------------
module VARCOM

use TYPHMAKE   ! machine accuracy definition
!$ use OMP_LIB

! -- Variables globales du module -------------------------------------------

logical        :: mpi_run, omp_run     ! parallel computation
character      :: memory_mode          ! mode d'economie memoire
character      :: model_mode           ! mode de modelisation physique
logical        :: verbose_mode         ! increase outputs

integer        :: histo_buffer         ! buffer for history writing

integer        :: myprocid, nthread    ! id of current proc

! -- CONSTANTES globales du module -------------------------------------------

! -- Definition des fonctionnalites

logical, parameter :: pass_kdif  = .true.
logical, parameter :: pass_ns    = .true.
logical, parameter :: pass_vort  = .true.
logical, parameter :: pass_mpi   = .false.
logical, parameter :: pass_amr   = .false.
logical, parameter :: pass_coupl_int = .true.
logical, parameter :: pass_coupl_ext = .false.

! -- Constantes "erreurs"

character, parameter :: cnull = ' '
integer,   parameter :: inull = 0

! -- Constantes de definition du mode de calcul cpu/memoire --

character, parameter :: mode_normal = 'N' ! mode economie : normal
character, parameter :: save_mem    = 'M' ! mode economie : memoire  minimale (recalcul)
character, parameter :: save_cpu    = 'C' ! mode economie : cpu time minimal  (mise en memoire)

! -- Constantes de definition du type de modelisation (qualite/hypothese) --

character, parameter :: model_max = 'X'   ! mode modelisation : strict (hypotheses minimales)
character, parameter :: model_hyp = 'H'   ! mode modelisation : avec hypotheses classiques
character, parameter :: model_sim = 'S'   ! mode modelisation : simpliste

! -- Constantes de definition du type de maillage --

character, parameter :: mshSTR = 'S'      ! maillage structure
character, parameter :: mshUST = 'U'      ! maillage non structure
character, parameter :: mshHYB = 'H'      ! maillage hybride

! -- Constantes de definition du type de solveur --

integer, parameter   :: solNS     = 10    ! Equations de Navier-Stokes (EQNS)
integer, parameter   :: solKDIF   = 20    ! Equation  de la chaleur    (EQKDIF)
integer, parameter   :: solVORTEX = 30    ! Methode integrale et lagrangienne VORTEX

!definitino de solVORTEX dans MENU_SOLVER

! -- Constantes pour l'etat d'avancement du calcul
integer, parameter :: end_calc          = 01
integer, parameter :: in_cycle          = 02
integer, parameter :: end_cycle         = 03

! -- Constantes de definition des conditions aux limites (physique) --

integer, parameter :: bc_coupling        = 02
integer, parameter :: bc_connect_match   = 05
integer, parameter :: bc_connect_refined = 06
integer, parameter :: bc_connect_nomatch = 07

integer, parameter :: bc_geo_sym        = 10
integer, parameter :: bc_geo_period     = 11
integer, parameter :: bc_geo_periodx    = 12
integer, parameter :: bc_geo_extrapol   = 13

integer, parameter :: bc_wall_adiab     = 20
integer, parameter :: bc_wall_isoth     = 21
integer, parameter :: bc_wall_flux      = 22
integer, parameter :: bc_wall_hconv     = 23
integer, parameter :: bc_wall_hgen      = 24

integer, parameter :: bc_inlet_sub      = 30
integer, parameter :: bc_inlet_sup      = 31
integer, parameter :: bc_outlet_sub     = 35
integer, parameter :: bc_outlet_sup     = 36

integer, parameter :: bc_farfield       = 90
integer, parameter :: bc_wall           = 92
integer, parameter :: bc_kutta          = 95

! -- Constantes de definition des conditions aux limites (calcul) --

integer, parameter :: bc_calc_ghostcell = 01   ! calcul par cellule fictive
integer, parameter :: bc_calc_ghostface = 02   ! calcul par cellule fictive sur la face
integer, parameter :: bc_calc_flux      = 03   ! calcul par flux, pas de point fictif
integer, parameter :: bc_calc_singpanel = 10   ! calcul implicite de singularites
integer, parameter :: bc_calc_kutta     = 15   ! calcul de condition kutta-joukowski
integer, parameter :: bc_calc_farfield  = 16   ! calcul de condition champ lointain

! -- Constantes de definition des parametres de conditions aux limites --

integer, parameter :: extrap_quantity   = 1
integer, parameter :: extrap_gradient   = 2

! -- Constantes pour les types de connections ou couplages --
!    au niveau des faces communes du maillage

integer, parameter  :: mesh_match    = 01
integer, parameter  :: mesh_nonmatch = 03
integer, parameter  :: mesh_slide    = 04

! -- Constantes pour le choix du parametre "typecalcul" (coupling)

integer, parameter  :: compact    = 01
integer, parameter  :: consistant = 02
integer, parameter  :: threed     = 03

! -- Constantes pour le choix du parametre "mode" (coupling)

integer, parameter  :: fixed  = 01
integer, parameter  :: sensor = 02

! -- Constantes pour le choix du parametre "boco" (coupling)

integer, parameter  :: couplingboco_TT  = 01
integer, parameter  :: couplingboco_CC  = 02
integer, parameter  :: couplingboco_CT  = 03
integer, parameter  :: couplingboco_TC  = 04

! -- Constantes pour le choix du parametre "solvercoupling" (zonecoupling)
integer, parameter  :: kdif_kdif = 01
integer, parameter  :: kdif_ns   = 02
integer, parameter  :: ns_ns     = 03

! -- Constantes pour le choix du parametre typ_cor (MENU_ZONECOUPLING) : type de correction
integer, parameter  :: sans       = 01
integer, parameter  :: avant      = 02
integer, parameter  :: apres      = 03
integer, parameter  :: auto       = 04
integer, parameter  :: repart_reg = 05
integer, parameter  :: repart_geo = 06
integer, parameter  :: partiel    = 07
integer, parameter  :: bocoT      = 08
integer, parameter  :: bocoT2     = 09 !DEV1603
integer, parameter  :: distributed= 10

! -- Constantes pour le choix du parametre "activite" (senseur)
!
!integer, parameter  :: fluxcomp = 1
!integer, parameter  :: tempevol = 2


! -- DECLARATIONS -----------------------------------------------------------

contains

!----------------------------------------------------------------------------------------
subroutine init_varcom()

  ! parametres par defaut

  memory_mode   = mode_normal
  model_mode    = model_max
  !cell_buffer   = 256  ! Compiler dependent ?
  !taille_buffer = cell_buffer
  verbose_mode = .false.
  histo_buffer  = 10   ! 
  omp_run = .false.
  nthread = 1
  !$OMP PARALLEL
  !$ omp_run = .true.
  !$ nthread = OMP_GET_NUM_THREADS()
  !$OMP END PARALLEL

  ! constantes

endsubroutine init_varcom



!----------------------------------------------------------------------------------------
endmodule VARCOM
!------------------------------------------------------------------------------!
! Changes history
!
! Oct  2002 : creation du module
! Feb  2011 : split packet functions to PACKET module
!------------------------------------------------------------------------------!
