!------------------------------------------------------------------------------!
! Procedure : conditions_limites          Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  : Juin 2003 (cf Historique)
!   Int�gration d'une zone sur un �cart de temps donn�,
!   d'une repr�sentation physique uniquement
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine conditions_limites(lzone)

use TYPHMAKE
use OUTPUT
use VARCOM
use DEFZONE

implicit none

! -- Declaration des entr�es --
type(st_zone) :: lzone            ! zone � int�grer

! -- Declaration des sorties --

! -- Declaration des variables internes --
integer      :: ifield            ! indice de champ

! -- Debut de la procedure --
do ifield = 1, lzone%ndom

select case(lzone%typ_mesh)

case(mshSTR)
  call erreur("D�v�loppement (conditions_limites)", &
              "maillage structur� non impl�ment�")
  !do i = 1, zone%str_mesh%nblock
  !  call integration_strdomaine(dt, zone%defsolver, zone%str_mesh%block(i))
  !enddo

case(mshUST)
  !call erreur("D�veloppement (integration_zone)", &
  !            "maillage non structur� non impl�ment�")
  call calcboco_ust(lzone%defsolver, lzone%ust_mesh, lzone%field(ifield), &
                    lzone%ncoupling, lzone)

case default
  call erreur("incoh�rence interne (conditions_limites)", &
              "type de maillage inconnu")

endselect

enddo

endsubroutine conditions_limites

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avril 2003 (v0.0.1b): cr�ation de la proc�dure
!------------------------------------------------------------------------------!
