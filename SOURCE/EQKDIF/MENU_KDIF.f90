!------------------------------------------------------------------------------!
! MODULE : MENU_KDIF                      Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : (cf Historique)
!   D�finition des structures pour les entr�es du programme TYPHON
!   Structures pour les options du solveur KDIF
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
module MENU_KDIF

use TYPHMAKE   ! Definition de la precision
use VARCOM
use MATERIAU  ! D�finition du mat�riau
!use EQKDIF    ! D�finition des propri�t�s temp�ratures et mat�riau

implicit none

! -- Variables globales du module -------------------------------------------


! -- DECLARATIONS -----------------------------------------------------------


!------------------------------------------------------------------------------!
! structure MNU_KDIF : options num�riques du solveur de diffusion (thermique)
!------------------------------------------------------------------------------!
type mnu_kdif
  type(st_materiau)   :: materiau      ! type de mat�riau
endtype mnu_kdif


!------------------------------------------------------------------------------!
! structure ST_BOCO_KDIF : D�finition des conditions aux limites
!------------------------------------------------------------------------------!
type st_boco_kdif
  real(krp) :: temp_ext       ! temp�rature ext�rieure pour le rayonnement
  real(krp) :: temp_wall      ! temp�rature de paroi (si isotherme)
  real(krp), dimension(:), pointer  &
            :: temp           ! temp�rature de paroi non uniforme
  logical   :: alloctemp      ! allocation du tableau temp
  character (len=strlen) &
            :: tempfile       ! nom de fichier de d�finition de la temp non uniforme  
  real(krp), dimension(:), pointer  &
            :: flux_nunif     ! flux non uniforme
  logical   :: allocflux      ! allocation du tableau flux_nunif
  character (len=strlen) &
            :: fluxfile       ! nom de fichier de d�finition du flux non uniforme  
  real(krp) :: h_conv         ! coefficient de convection
  real(krp) :: temp_conv      ! temp�rature de relaxation pour la convection
  real(krp) :: flux           ! flux (si flux impos�)
endtype st_boco_kdif


!------------------------------------------------------------------------------!
! structure ST_INIT_KDIF : D�finition des conditions aux limites
!------------------------------------------------------------------------------!
type st_init_kdif
  real(krp) :: temp           ! temp�rature du champ
endtype st_init_kdif



! -- INTERFACES -------------------------------------------------------------


! -- Fonctions et Operateurs ------------------------------------------------

!integer bctype_of_kdifboco

! -- IMPLEMENTATION ---------------------------------------------------------
contains

!------------------------------------------------------------------------------!
! fonction : retourne le type de calcul selon le type physique de cond. lim.
!------------------------------------------------------------------------------!
integer function bctype_of_kdifboco(bocotype)
implicit none
integer bocotype

  select case(bocotype)
  case(bc_wall_adiab)
    bctype_of_kdifboco = bc_calc_flux
  case(bc_wall_isoth)
    bctype_of_kdifboco = bc_calc_ghostface
  case(bc_wall_flux)
    bctype_of_kdifboco = bc_calc_flux
  case(bc_wall_hconv)
    bctype_of_kdifboco = bc_calc_ghostface
  case default
    call erreur("incoh�rence interne (MENU_KDIF)",&
                "type de conditions aux limites inattendu")
  endselect

endfunction bctype_of_kdifboco


endmodule MENU_KDIF

!------------------------------------------------------------------------------!
! Historique des modifications
!
! nov  2002 (v0.0.1b): cr�ation du module
! nov 2003           : ajout de la temp�rature non uniforme de paroi 
!                      (CL Dirichlet)
!------------------------------------------------------------------------------!
