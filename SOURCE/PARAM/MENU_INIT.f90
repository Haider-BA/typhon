!------------------------------------------------------------------------------!
! MODULE : MENU_INIT                      Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  : Mars 2003 (cf Historique)
!   D�finition des structures pour les entr�es du programme TYPHON
!   Structures pour la d�finition de l'initialisation des champs
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
module MENU_INIT

use STRING
use TYPHMAKE   ! Definition de la precision
use VARCOM     ! D�finition des constantes
!use MENU_NS   ! D�finition des solveurs type NS
use MENU_KDIF ! D�finition des solveurs type Equation de diffusion

implicit none

! -- Variables globales du module -------------------------------------------

! -- D�finition des entiers caract�ristiques pour le type de solveur --


! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! structure MNU_INIT : options num�riques les solveurs 
!------------------------------------------------------------------------------!
type mnu_init
  type(st_init_kdif)    :: kdif     ! condition aux limites propre au solveur KDIF
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
! mars 2003 (v0.0.1b): cr�ation du module
!
! Am�liorations futures : 
!   - d�finitions de zones g�om�trique pour initialisation
!   - initilisation de champs non uniformes
!------------------------------------------------------------------------------!


