!------------------------------------------------------------------------------!
! MODULE : MENU_BOCO                      Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : Mars 2003 (cf Historique)
!   D�finition des structures pour les entr�es du programme TYPHON
!   Structures pour la d�finition des conditions aux limites
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
module MENU_BOCO

use STRING
use TYPHMAKE   ! Definition de la precision
use VARCOM     ! D�finition des constantes
!use MENU_NS   ! D�finition des solveurs type NS
use MENU_KDIF ! D�finition des solveurs type Equation de diffusion

implicit none


! -- Variables globales du module -------------------------------------------

! -- D�finition des entiers caract�ristiques pour l'uniformit� de la CL --
integer, parameter :: uniform   = 10   
integer, parameter :: nonuniform = 20 

! -- D�finition des entiers caract�ristiques pour le type de solveur --


! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! structure MNU_BOCO : options num�riques les solveurs 
!------------------------------------------------------------------------------!
type mnu_boco
  character(len=strlen) :: family        ! nom de famille de la condition aux limites
  integer               :: typ_boco      ! type physique de condition aux limites 
                                         !  (cf definitions VARCOM) 
  integer               :: typ_calc      ! type de calcul de conditions aux limites
                                         !  (cf definitions VARCOM) 
                                         !   CONNECTION    : type de connection (GHOSTFACE,...)?!  
                                         !   COUPLING      : type de connection (GHOSTFACE,...)?!  
                                         !   EXTRAPOLATION : ordre d'extrapolation?!
  integer               :: boco_unif     ! condition aux limites uniforme ou non                                   
  integer               :: order_extrap  ! ordre d'extrapolation : A INCLURE dans typ_calc

  type(st_boco_kdif)    :: boco_kdif     ! condition aux limites propre au solveur KDIF

  !integer               :: np_int    ! nombre de param�tres entiers
  !integer               :: np_real   ! nombre de param�tres r�els
  !integer, dimension(:), pointer &
  !                      :: iparam    ! param�tres entiers
  !real(krp), dimension(:), pointer &
  !                      :: rparam    ! param�tres r�els
  !type(st_boco_ns)    :: boco_ns     ! condition aux limites propre au solveur NS
endtype mnu_boco


! -- INTERFACES -------------------------------------------------------------


! -- Fonctions et Operateurs ------------------------------------------------

!integer bocotype, bctype_of_boco

! -- IMPLEMENTATION ---------------------------------------------------------
contains

!------------------------------------------------------------------------------!
! Fonction : retourne le type entier de conditions aux limites
!------------------------------------------------------------------------------!
integer function bocotype(str)
implicit none
character(len=*) str

  bocotype = inull

  if (samestring(str, "CONNECTION" ))          bocotype = bc_connection
  if (samestring(str, "COUPLING" ))            bocotype = bc_wall_isoth

  if (samestring(str, "SYMMETRY" ))            bocotype =  bc_geo_sym   
  if (samestring(str, "PERIODIC" ))            bocotype =  bc_geo_period
  if (samestring(str, "EXTRAPOLATE" ))         bocotype =  bc_geo_extrapol

  if (samestring(str, "ADIABATIC_WALL" ))      bocotype =  bc_wall_adiab 
  if (samestring(str, "ISOTHERMAL_WALL" ))     bocotype =  bc_wall_isoth 
  if (samestring(str, "FLUXSET_WALL" ))        bocotype =  bc_wall_flux  
  if (samestring(str, "CONVECTION_WALL" ))     bocotype =  bc_wall_hconv 

endfunction bocotype


!------------------------------------------------------------------------------!
! Fonction : bctype_of_boco(isolver, itype)
!------------------------------------------------------------------------------!
integer function bctype_of_boco(isolver, itype)
implicit none
integer isolver, itype

  select case(itype)
  case(bc_geo_sym)
    call erreur("D�veloppement","'bc_geo_sym' : Cas non impl�ment�")
  case(bc_geo_period)
    call erreur("D�veloppement","'bc_geo_period' : Cas non impl�ment�")
  case(bc_geo_extrapol)
      bctype_of_boco = bc_calc_ghostface
  case default    
    select case(isolver)
    case(solKDIF)
      bctype_of_boco = bctype_of_kdifboco(itype)
    case default
      call erreur("incoh�rence interne (MENU_BOCO)","solveur inconnu")
    endselect
  endselect

endfunction bctype_of_boco


endmodule MENU_BOCO


!------------------------------------------------------------------------------!
! Historique des modifications
!
! nov  2002 (v0.0.1b): cr�ation du module
! mars 2003          : d�finition des types de conditions aux limites
! juin 2003          : regroupement des types "connection", ajout de "coupling"
! nov 2003           : ajout de l'uniformit� ou non des CL
!------------------------------------------------------------------------------!


