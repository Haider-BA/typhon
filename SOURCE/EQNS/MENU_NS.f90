!------------------------------------------------------------------------------!
! MODULE : MENU_NS                        Auteur : J. Gressier
!                                         Date   : Aout 2002
! Fonction                                Modif  : (cf historique)
!   D�finition des structures pour les entr�es du programme TYPHON
!   Structures pour les options des solveurs EULER, NS, RANS
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
module MENU_NS

use TYPHMAKE   ! Definition de la precision
use VARCOM     ! D�finition des param�tres constantes
use EQNS       ! D�finition des propri�t�s gaz

implicit none

! -- Variables globales du module -------------------------------------------

! -- Type de solveur (menu_ns%typ_fluid)--
integer, parameter :: eqEULER = 10
integer, parameter :: eqNSLAM = 11 
integer, parameter :: eqRANS  = 12

! -- Type de gaz (menu_ns%typ_gaz) --
integer, parameter :: gas_AIR = 10


! -- DECLARATIONS -----------------------------------------------------------


!------------------------------------------------------------------------------!
! structure MNU_NS : options num�riques les solveurs Euler, NS et RANS
!------------------------------------------------------------------------------!
type mnu_ns
  integer         :: typ_fluid         ! type de fluide (cf definitions parameter) 
  integer         :: typ_gas           ! type de gaz    (cf definitions parameter) 
  integer         :: nb_species        ! nombre d'esp�ces r�solues
  type(st_espece), dimension(:), pointer &
                  :: properties        ! propri�t�s des diff�rentes esp�ces
endtype mnu_ns

!------------------------------------------------------------------------------!
! structure ST_BOCO_NS : D�finition des conditions aux limites
!------------------------------------------------------------------------------!
type st_boco_ns
  ! d�finir un �tat
  real(krp) :: pstat, ptot, ttot, mach
  real(krp) :: temp_wall
  type(v3d) :: direction
endtype st_boco_ns

!------------------------------------------------------------------------------!
! structure ST_INIT_NS : D�finition de l'initialisation
!------------------------------------------------------------------------------!
type st_init_ns
  ! d�finir un �tat
  real(krp) :: pstat, ptot, ttot, mach
  type(v3d) :: direction
endtype st_init_ns


! -- INTERFACES -------------------------------------------------------------


! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
contains

!------------------------------------------------------------------------------!
! fonction : retourne le type de calcul selon le type physique de cond. lim.
!------------------------------------------------------------------------------!
integer function bctype_of_nsboco(bocotype)
implicit none
integer bocotype

  select case(bocotype)
  case(bc_wall_adiab)
    bctype_of_nsboco = bc_calc_ghostface
  case(bc_wall_isoth)
    bctype_of_nsboco = bc_calc_ghostface
  case(bc_wall_flux)
    bctype_of_nsboco = bc_calc_ghostface
  case(bc_inlet_sup)
    bctype_of_nsboco = bc_calc_ghostface
  case(bc_inlet_sub)
    bctype_of_nsboco = bc_calc_ghostface
  case(bc_outlet_sup)
    bctype_of_nsboco = bc_calc_ghostface
  case(bc_outlet_sub)
    bctype_of_nsboco = bc_calc_ghostface
  case default
    call erreur("incoh�rence interne (MENU_NS)",&
                "type de conditions aux limites inattendu")
  endselect

endfunction bctype_of_nsboco


endmodule MENU_NS
!------------------------------------------------------------------------------!
! Historique des modifications
!
! aout 2002 : cr�ation du module
! juin 2004 : conditions limites (bctype_of_nsboco, st_boco_ns) 
!------------------------------------------------------------------------------!




