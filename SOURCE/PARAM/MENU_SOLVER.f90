!------------------------------------------------------------------------------!
! MODULE : MENU_SOLVER                    Auteur : J. Gressier
!                                         Date   : Aout 2002
! Fonction                                Modif  : (cf Historique)
!   D�finition des structures pour les entr�es du programme TYPHON
!   Structures pour les options des solveurs 
!   - D�finition du probl�me (solveur, conditions limites, initiales)
!   - Param�tres de calcul   (int�gration temporelle, spatiale, AMR...)
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
module MENU_SOLVER

use TYPHMAKE      ! Definition de la precision
use MENU_NS       ! Definition des solveurs type NS
use MENU_KDIF     ! Definition des solveurs type Equation de diffusion
use MENU_VORTEX   ! Definition des solveurs type VORTEX (lagrangien)
use MENU_BOCO     ! Definition des conditions limites
use MENU_INIT     ! Definition de l'initialisation
use MENU_CAPTEURS ! Definition des capteurs
use MENU_AMR      ! Definition des parametres de raffinement

implicit none

! -- Variables globales du module -------------------------------------------

! -- D�finition des entiers caract�ristiques pour le type de solveur -- CF VARCOM
!integer, parameter :: solNS   = 10    ! Equations de Navier-Stokes (EQNS)
!integer, parameter :: solKDIF = 20    ! Equation  de la chaleur    (EQKDIF)
!integer, parameter :: solVORTEX = 30   ! M�thode int�grale et lagrangienne VORTEX

! -- D�finition du type de quantite 
integer, parameter :: qs_temperature = 010 
integer, parameter :: qs_pressure    = 011
integer, parameter :: qs_density     = 012
integer, parameter :: qv_velocity    = 101
integer, parameter :: qv_stress      = 102 




! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! structure MNU_SOLVER : options num�riques les solveurs 
!------------------------------------------------------------------------------!
type mnu_solver
  integer         :: typ_solver      ! type de solveur (cf definitions VARCOM) 
  integer         :: nequat          ! nombre d'�quations
  type(mnu_ns)    :: defns           ! options si solveur NS
  type(mnu_kdif)  :: defkdif         ! options si solveur KDIF
  type(mnu_vort)  :: defvort         ! options si solveur VORTEX
  type(mnu_amr)   :: defamr          ! options si AMR
  integer         :: nboco           ! nombre de conditions aux limites
  type(mnu_boco), dimension(:), pointer &
                  :: boco            ! d�finitions des conditions aux limites
  integer         :: ninit           ! nombre de conditions initiales
  type(mnu_init), dimension(:), pointer &
                  :: init            ! d�finitions des conditions initiales
  integer         :: nprobe          ! nombre de capteurs
  type(mnu_capteur), dimension(:), pointer &
                  :: probe           ! d�finitions des capteurs
endtype mnu_solver


! -- INTERFACES -------------------------------------------------------------

interface delete
  module procedure delete_mnu_solver
endinterface

! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
contains

!------------------------------------------------------------------------------!
! Proc�dure : initialisation d'une structure MNU_SOLVER
!------------------------------------------------------------------------------!
subroutine init_mnu_solver(defsolver)
implicit none
type(mnu_solver)  :: defsolver

  defsolver%nboco  = 0
  defsolver%nprobe = 0
  defsolver%ninit  = 0
  defsolver%defamr%nbcriter = 0     ! call init(defsolver%defamr)

endsubroutine init_mnu_solver


!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure MNU_SOLVER
!------------------------------------------------------------------------------!
subroutine delete_mnu_solver(defsolver)
implicit none
type(mnu_solver)  :: defsolver
integer           :: ib

  call delete(defsolver%defamr)

  select case(defsolver%typ_solver)
  case(solKDIF)
    call delete(defsolver%defkdif%materiau%Kd)
  case(solNS)
  case(solVORTEX)
  endselect

  ! -- destruction des param�tres d'initialisation --
  select case(defsolver%typ_solver)
  case(solKDIF)
    do ib = 1, defsolver%ninit
      if (defsolver%init(ib)%unif==init_nonunif) then
        deallocate(defsolver%init(ib)%kdif%coef)
      endif
    enddo
  case(solNS)
  case(solVORTEX)
  endselect
  if (defsolver%ninit >= 1) then
    deallocate(defsolver%init)
  endif
  
  ! -- destruction des param�tres des capteurs --

  if (defsolver%nprobe >= 1) then
    do ib = 1, defsolver%nprobe
      call delete(defsolver%probe(ib))
    enddo
    deallocate(defsolver%probe)
  endif
  
  ! -- destruction des param�tres de conditions limites --

  if (defsolver%nboco >= 1) then
    ! DEV : d�finition d'un delete_mnu_boco
    do ib = 1, defsolver%nboco
      select case(defsolver%boco(ib)%boco_unif)
      case(nonuniform)
        ! condition de Dirichlet non uniforme
        if (defsolver%boco(ib)%boco_kdif%alloctemp) then
          deallocate(defsolver%boco(ib)%boco_kdif%temp)
          defsolver%boco(ib)%boco_kdif%alloctemp = .false.
        endif
        ! condition de Von Neumann non uniforme
        if (defsolver%boco(ib)%boco_kdif%allocflux) then
          deallocate(defsolver%boco(ib)%boco_kdif%flux_nunif)
          defsolver%boco(ib)%boco_kdif%allocflux = .false.
        endif
        ! condition de Fourier non uniforme
        if (defsolver%boco(ib)%boco_kdif%allochconv) then
          deallocate(defsolver%boco(ib)%boco_kdif%h_nunif)
          deallocate(defsolver%boco(ib)%boco_kdif%tconv_nunif)
          defsolver%boco(ib)%boco_kdif%allochconv = .false.
        endif
      endselect
    enddo

    deallocate(defsolver%boco)

  endif

endsubroutine delete_mnu_solver


!------------------------------------------------------------------------------!
! Fonction : retourne le type entier de quantit� physique
!------------------------------------------------------------------------------!
integer function quantity(str)
implicit none
character(len=*) str

  quantity = inull
  
  ! quantit�s scalaires
  if (samestring(str, "TEMPERATURE" ))  quantity = qs_temperature
  if (samestring(str, "PRESSURE" ))     quantity = qs_pressure
  if (samestring(str, "DENSITY" ))      quantity = qs_density

  ! quantit�s vectorielles
  if (samestring(str, "VELOCITY" ))     quantity = qv_velocity
  if (samestring(str, "STRESS" ))       quantity = qv_stress

endfunction quantity


!------------------------------------------------------------------------------!
! Fonction : retourne l'index de condition limite correspondant au nom "str"
!------------------------------------------------------------------------------!
integer function indexboco(defsolver, str)
implicit none
type(mnu_solver) :: defsolver
character(len=*) :: str
integer          :: i

  indexboco = inull
  do i = 1, defsolver%nboco
    if (samestring(str, defsolver%boco(i)%family)) indexboco = i
  enddo

endfunction indexboco


!------------------------------------------------------------------------------!
! Fonction : retourne l'index de capteur correspondant au nom "str"
!------------------------------------------------------------------------------!
integer function indexcapteur(defsolver, str)
implicit none
type(mnu_solver) :: defsolver
character(len=*) :: str
integer          :: i

  indexcapteur = inull
  do i = 1, defsolver%nprobe
    if (samestring(str, defsolver%probe(i)%name)) indexcapteur = i
  enddo

endfunction indexcapteur



endmodule MENU_SOLVER

!------------------------------------------------------------------------------!
! Historique des modifications
!
! aout 2002 : cr�ation du module
! mars 2003 : ajout des conditions aux limites
!             ajout des structures d'initialisation
! juil 2003 : proc�dure delete : Kd
! nov  2003 : tableau de param�tres pour les capteurs
!             d�finition des quantit�s
!             index de conditions limites ou de capteurs en fonction du nom
! fev  2004 : d�finition du solveur VORTEX
! juin 2004 : proc�dure delete : condition limite Fourier non uniforme
! july 2004 : add AMR parameters
!------------------------------------------------------------------------------!




