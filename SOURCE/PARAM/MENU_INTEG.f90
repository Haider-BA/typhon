!------------------------------------------------------------------------------!
! MODULE : MENU_INTEG                     Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : 
!   D�finition des structures pour les entr�es du programme TYPHON
!   Structures pour les param�tres de l'int�gration temporelle entre zones
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module MENU_INTEG

use TYPHMAKE   ! Definition de la precision

implicit none

! -- Variables globales du module -------------------------------------------


! -- DECLARATIONS -----------------------------------------------------------


!------------------------------------------------------------------------------!
! structure MNU_TEMP : options num�riques pour l'int�gration temporelle
!------------------------------------------------------------------------------!
type mnu_integ
  character       :: temps      ! (S)tationnaire, (I)nstationnaire, (P)�riodique
endtype mnu_integ



! -- INTERFACES -------------------------------------------------------------


! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
!contains


endmodule MENU_INTEG




