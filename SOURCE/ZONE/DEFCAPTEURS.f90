!------------------------------------------------------------------------------!
! MODULE : DEFCAPTEURS                    Auteur : J. Gressier
!                                         Date   : Juillet 2003
! Fonction                                Modif  : (cf historique)
!   D�finition des structures de donn�es pour capteurs dans les zones
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module DEFCAPTEURS

use TYPHMAKE      ! Definition de la precision/donn�es informatiques
use DEFFIELD      ! D�finition des champs physiques

implicit none

! -- Variables globales du module -------------------------------------------



! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! D�finition de la structure ST_CAPTEUR : capteur maillage g�n�ral et champ
!------------------------------------------------------------------------------!

type st_capteur
  integer      :: idef            ! index de d�finition de capteur (mnu_capteur)
  integer      :: iunit           ! num�ro d'unit� pour la sauvegarde
  integer      :: dim             ! taille du champ � sauvegarder
  integer      :: nbuf            ! taille du buffer
  real(krp), dimension(:,:), pointer &
               :: tab             ! tableau de valeurs (dim,nbuf)
endtype st_capteur


! -- INTERFACES -------------------------------------------------------------

interface delete
  module procedure delete_capteur
endinterface

! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
contains


!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure CAPTEUR
!------------------------------------------------------------------------------!
subroutine delete_capteur(capteur)
implicit none
type(st_capteur)  :: capteur
integer           :: i     

  deallocate(capteur%tab)

endsubroutine delete_capteur




endmodule DEFCAPTEURS

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juil 2003 : cr�ation du module
!------------------------------------------------------------------------------!
