!------------------------------------------------------------------------------!
! Procedure : init_zone               Auteur : J. Gressier
!                                         Date   : Janvier 2004
! Fonction                                Modif  : see history
!   Initialisation des zone
!     - zone par d�faut
!     - zone d�fnis par l'utilisateur
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine init_zone(zone, prj)

use TYPHMAKE
use DEFZONE
use MENU_GEN

implicit none

! -- Declaration des entr�es --
type(mnu_project) :: prj

! -- Declaration des sorties --

! -- Declaration des entr�es/sorties --
type(st_zone) :: zone

! -- Declaration des variables internes --

! -- Debut de la procedure --

zone%info%typ_temps =  prj%typ_temps

endsubroutine init_zone

!------------------------------------------------------------------------------!
! Changes history
!
! aug  2004 : creation
!------------------------------------------------------------------------------!
