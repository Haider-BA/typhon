!------------------------------------------------------------------------------!
! MODULE : INFO                           Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  : 
!   D�finition des structures de donn�es g�n�rales
!   Encapsulation de toutes les structures
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module MODINFO

use TYPHMAKE     ! Definition de la precision


implicit none

! -- Variables globales du module -------------------------------------------



! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! D�finition de la structure ST_INFO : informations g�n�rales sur la gestion du calcul
!------------------------------------------------------------------------------!
type st_info
  logical   :: fin_integration      ! fin d'int�gration
  integer   :: icycle               ! cycle courant
  real(krp) :: curtps               ! temps physique courant
endtype st_info


! -- INTERFACES -------------------------------------------------------------



! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
!contains

!------------------------------------------------------------------------------!
! Proc�dure : 
!------------------------------------------------------------------------------!




endmodule MODINFO

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2003 (v0.0.1b): cr�ation du module
!------------------------------------------------------------------------------!
