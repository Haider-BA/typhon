!------------------------------------------------------------------------------!
! MODULE : MODINFO                        Auteur : J. Gressier
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
! niveau WORLD
!------------------------------------------------------------------------------!
type st_info
  logical   :: fin_integration      ! fin d'int�gration
  integer   :: icycle               ! cycle courant
  real(krp) :: curtps               ! temps physique courant
  real(krp) :: residu_ref, cur_res  ! residu de r�f�rence et courant
  integer   :: nbproc               ! total number of communicating processors
  integer   :: my_id                ! id of the current process
endtype st_info


!------------------------------------------------------------------------------!
! D�finition de la structure ST_INFOZONE : informations sur la zone
!------------------------------------------------------------------------------!
type st_infozone
  character :: typ_temps            ! (S)tationnaire, (I)nstationnaire, (P)�riodique
  logical   :: fin_cycle            ! fin d'int�gration du cycle
  integer   :: nbstep               ! nombre de pas maximal du cycle
  real(krp) :: cycle_dt             ! dur�e du cycle
  real(krp) :: residumax            ! residu maximal admissible pour le cycle
  real(krp) :: residu_ref, cur_res  ! residu de r�f�rence (world) et courant (cycle)
  real(krp) :: residu_reforigine    ! residu de r�f�rence du premier cycle
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
! oct 2003  : ajout de residu_ref_origine
!------------------------------------------------------------------------------!
