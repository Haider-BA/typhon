!------------------------------------------------------------------------------!
! MODULE : MENU_INIT                      Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  : (cf Historique)
!   D�finition des structures pour les entr�es du programme TYPHON
!   Structures pour la d�finition de l'initialisation des champs
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
module MENU_INIT

use STRING
use TYPHMAKE    ! Definition de la precision
use VARCOM      ! D�finition des constantes
use MENU_NS    ! D�finition des solveurs type NS
use MENU_KDIF   ! D�finition des solveurs type Equation de diffusion
use MENU_VORTEX ! D�finition des solveurs type Equation de diffusion

implicit none

! -- Variables globales du module -------------------------------------------

! -- D�finition des entiers caract�ristiques pour l'uniformit� de la CI --
integer, parameter :: init_unif    = 10   
integer, parameter :: init_nonunif = 20 

! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! structure MNU_INIT : options num�riques les solveurs 
!------------------------------------------------------------------------------!
type mnu_init
  type(st_init_ns)    :: ns       ! condition aux limites propre au solveur NS
  type(st_init_kdif)  :: kdif     ! condition aux limites propre au solveur KDIF
  type(st_init_vort)  :: vortex   ! condition aux limites propre au solveur VORTEX
  integer             :: unif     ! uniformit� de la condition initiale
endtype mnu_init


! -- INTERFACES -------------------------------------------------------------


! -- Fonctions et Operateurs ------------------------------------------------

!integer inittype, bctype_of_init

! -- IMPLEMENTATION ---------------------------------------------------------
!contains

endmodule MENU_INIT

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2003 : cr�ation du module
! fev  2004 : ajout des donn�es d'initialisation pour solveur VORTEX
! juil 2004 : donn�es d'initialistion pour solveur NS
!
! Am�liorations futures : 
!   - d�finitions de zones g�om�trique pour initialisation
!------------------------------------------------------------------------------!


