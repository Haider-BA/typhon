!------------------------------------------------------------------------------!
! Procedure : calc_induced_velocity       Auteur : J. Gressier
!                                         Date   : Mars 2004
! Fonction                                Modif  : (cf historique)
!   Calcul des vitesses induites par les diff�rents �l�ments singularit�s
!   aux centres sp�cifi�s
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine calc_induced_velocity(zone, center, velocity)

use TYPHMAKE
use DEFZONE
use MENU_VORTEX

implicit none

! -- Declaration des entr�es --
type(st_zone)         :: zone
type(st_genericfield) :: center

! -- Declaration des sorties --
type(st_genericfield) :: velocity

! -- Declaration des variables internes --
integer :: ip

! -- Debut de la procedure --




endsubroutine calc_induced_velocity

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2004 : cr�ation de la routine
!------------------------------------------------------------------------------!


