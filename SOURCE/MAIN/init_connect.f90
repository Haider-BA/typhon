!------------------------------------------------------------------------------!
! Procedure : init_connect                Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  : 
!   Lecture des menus
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine init_connect(zone)

use TYPHMAKE
use VARCOM     ! D�finition des constantes
use OUTPUT
use DEFZONE

implicit none

! -- Declaration des entr�es --

! -- Declaration des entr�es/sorties --
type(st_zone) :: zone

! -- Declaration des sorties --

! -- Declaration des variables internes --

! -- Debut de la procedure --

select case(zone%typ_mesh)

case(mshSTR)
  call erreur("D�veloppement (init_maillage)", &
              "maillage structur� non impl�ment�")

case(mshUST)
  call init_connect_ust(zone%defsolver, zone%ust_mesh)

case default
  call erreur("incoh�rence interne (init_maillage)", &
              "type de maillage inconnu")

endselect

endsubroutine init_connect


!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2003 (v0.0.1b): cr�ation de la proc�dure
!------------------------------------------------------------------------------!
