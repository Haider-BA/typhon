!------------------------------------------------------------------------------!
! Procedure : init_kdif_ust               Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  : juin 2003 (cf historique)
!   Traitement des param�tres du fichier menu principal
!   Param�tres principaux du projet
!
! Defauts/Limitations/Divers :
!   ATTENTION : initialisation des variables primitives
!
!------------------------------------------------------------------------------!
subroutine init_kdif_ust(kdif, champ)

use TYPHMAKE
use DEFFIELD
use MENU_KDIF

implicit none

! -- Declaration des entr�es --
type(st_init_kdif) :: kdif

! -- Declaration des sorties --
type(st_field) :: champ

! -- Declaration des variables internes --
integer :: ip
! -- Debut de la procedure --

do ip = 1, champ%nscal
  champ%etatprim%tabscal(ip)%scal(:) = kdif%temp
enddo

! pas de de variables vectorielles attendues (pas de test)

!!if (champ%allocgrad) champ%gradient(:,:,:,:,:) = 0._krp


endsubroutine init_kdif_ust

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2003 (v0.0.1b) : cr�ation de la routine
! juin 2003           : m�j pour variables conservatives et primitives
!------------------------------------------------------------------------------!


