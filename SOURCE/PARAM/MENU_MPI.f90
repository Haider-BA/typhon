!------------------------------------------------------------------------------!
! MODULE : MENU_MPI                     Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : 
!   D�finition des structures pour les entr�es du programme TYPHON
!   Structures pour les param�tres de distribution entre processeurs
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module MENU_MPI

use TYPHMAKE   ! Definition de la precision

implicit none

! -- Variables globales du module -------------------------------------------


! -- DECLARATIONS -----------------------------------------------------------


!------------------------------------------------------------------------------!
! structure MNU_MPI : param�tres pour la distribution entre processeurs
!------------------------------------------------------------------------------!
type mnu_mpi
  character       :: temps      ! (S)tationnaire, (I)nstationnaire, (P)�riodique
endtype mnu_mpi



! -- INTERFACES -------------------------------------------------------------


! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
!contains


endmodule MENU_MPI




