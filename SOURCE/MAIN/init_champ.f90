!------------------------------------------------------------------------------!
! Procedure : init_champ                  Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  :
!   Lecture des menus
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine init_champ(zone)

use TYPHMAKE
use OUTPUT
use DEFZONE

implicit none

! -- Declaration des entr�es --

! -- Declaration des sorties --

! -- Declaration des entr�es/sorties --
type(st_zone) :: zone

! -- Declaration des variables internes --
integer :: id             ! index de domaine/champ

! -- Debut de la procedure --

!zone%champ%idim = 1

select case(zone%typ_mesh)

case(mshSTR)
  call erreur("D�veloppement (init_champ)", &
              "maillage structur� non impl�ment�")

case(mshUST)
  allocate(zone%field(zone%ndom))
  do id = 1, zone%ndom
    call init_champ_ust(zone%defsolver, zone%ust_mesh, zone%field(id))
  enddo

case default
  call erreur("incoh�rence interne (init_champ)", &
              "type de maillage inconnu")

endselect


endsubroutine init_champ


!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2003 (v0.0.1b): cr�ation de la proc�dure
!------------------------------------------------------------------------------!
