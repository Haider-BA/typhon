!------------------------------------------------------------------------------!
! MODULE : INFO                           Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  : cf historique
!   D�finition des structures de donn�es g�n�rales pour l'int�gration (gestion)
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
  real(krp) :: first_res, cur_res   ! residu initial et courant
endtype st_info


!------------------------------------------------------------------------------!
! D�finition de la structure ST_INFOZONE : informations sur la zone
!------------------------------------------------------------------------------!
type st_infozone
  logical   :: fin_cycle            ! fin d'int�gration du cycle
  integer   :: nbstep               ! nombre de pas maximal du cycle
  real(krp) :: cycle_dt             ! dur�e du cycle
  real(krp) :: residumax            ! residu maximal admissible pour le cycle
  real(krp) :: first_res, cur_res   ! residu initial (world) et courant (cycle)
endtype st_infozone


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
! mars 2003 : cr�ation du module
! sept 2003 : informations sp�cifiques pour l'int�gration d'un cycle
!------------------------------------------------------------------------------!
