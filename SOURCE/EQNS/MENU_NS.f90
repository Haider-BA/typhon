!------------------------------------------------------------------------------!
! MODULE : MENU_NS                        Auteur : J. Gressier
!                                         Date   : Aout 2002
! Fonction                                Modif  : Novembre 2002
!   D�finition des structures pour les entr�es du programme TYPHON
!   Structures pour les options des solveurs EULER, NS, RANS
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
module MENU_NS

use TYPHMAKE   ! Definition de la precision
use EQNS      ! D�finition des propri�t�s gaz

implicit none

! -- Variables globales du module -------------------------------------------

! -- D�finition des entiers caract�ristiques pour le type de solveur --
integer, parameter :: eqEULER = 10
integer, parameter :: eqNSLAM = 11 
integer, parameter :: eqRANS  = 12


! -- DECLARATIONS -----------------------------------------------------------


!------------------------------------------------------------------------------!
! structure MNU_NS : options num�riques les solveurs Euler, NS et RANS
!------------------------------------------------------------------------------!
type mnu_ns
  integer         :: typ_fluid         ! type de fluide (cf definitions parameter) 
  integer         :: nb_species        ! nombre d'esp�ces r�solues
  type(st_espece), dimension(:), pointer &
                  :: properties        ! propri�t�s des diff�rentes esp�ces
endtype mnu_ns


! -- INTERFACES -------------------------------------------------------------


! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
!contains


endmodule MENU_NS




