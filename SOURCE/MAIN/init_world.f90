!------------------------------------------------------------------------------!
! Procedure : init_world                  Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  :
!   Initialisation des structures et contenus
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine init_world(world)

use TYPHMAKE
use OUTPUT
use MODWORLD

implicit none

! -- Declaration des entr�es/sorties --
type(st_world) :: world

! -- Declaration des sorties --

! -- Declaration des variables internes --
integer :: izone, icoupling

! -- Debut de la procedure --

!--------------------------------------------------------------------
! Lecture, transformation des maillages, calcul des param�tres g�om�triques et connectivit�s

call print_info(5,"Calcul et Initialisation des maillages")
do izone = 1, world%prj%nzone
  call init_maillage(world%zone(izone))
enddo

!--------------------------------------------------------------------
! Initialisation des connectivit�s cellules/faces/sommets des conditions aux limites

call print_info(5,"Calcul et Initialisation des connectivit�s&
                  & et conditions aux limites")
do izone = 1, world%prj%nzone
  call init_connect(world%zone(izone))
enddo

!--------------------------------------------------------------------
! Initialisation des connectivit�s entres zones

!! DEV


!--------------------------------------------------------------------
! Initialisation des champs

call print_info(5,"Calcul et Initialisation des champs initiaux")
do izone = 1, world%prj%nzone
  call init_champ(world%zone(izone))
enddo

!--------------------------------------------------------------------
! Initialisation des conditions limites

call print_info(5,"Initialisation des conditions aux limites")
do izone = 1, world%prj%nzone
  call init_boco(world%zone(izone))
enddo

!--------------------------------------------------------------------
! Initialisation des echanges entre zones

do icoupling = 1,  world%prj%ncoupling
  call print_info(5,"Calcul et Initialisation des �changes entre zones")
  call init_coupling(world%zone(world%coupling(icoupling)%zone1), &
                     world%zone(world%coupling(icoupling)%zone2))
enddo

!--------------------------------------------------------------------
! Initialisation des capteurs

call print_info(5,"Initialisation des capteurs")
do izone = 1, world%prj%nzone
  call init_capteurs(world%zone(izone))
enddo

 



endsubroutine init_world

!------------------------------------------------------------------------------!
! Historique des modifications
!
! nov   2002 : cr�ation de la proc�dure
! jan   2004 : initialisation des capteurs
!------------------------------------------------------------------------------!
