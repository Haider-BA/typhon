!------------------------------------------------------------------------------!
! Procedure : calc_ust_cell               Auteur : J. Gressier
!                                         Date   : Janvier 2003
! Fonction                                Modif  :
!   Calcul des cellules (centres et volumes) � partir des volumes
!   �l�mentaires
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine calc_ust_cell(ncell, nface, facecell, cg_elem, vol_elem, mesh)

use TYPHMAKE
use GEO3D
use OUTPUT
use USTMESH

implicit none

! -- Declaration des entr�es --
integer                   :: ncell      ! nombre de cellules
integer                   :: nface      ! nombre de faces
type(st_connect)       :: facecell   ! connectivit� face->cellules
type(v3d), dimension(nface,2) :: cg_elem    ! centres de volume �l�mentaire
real(krp), dimension(nface,2) :: vol_elem   ! volumes de volume �l�mentaire

! -- Declaration des entr�es/sorties --
!type(st_ustmesh) :: ust_mesh

! -- Declaration des sorties --
type(st_mesh)    :: mesh                

! -- Declaration des variables internes --
integer                 :: if           ! indice  de face
integer                 :: ic, ic1, ic2 ! indices de cellules

! -- Debut de la procedure --

! les centres de gravit� et les volumes des cellules �l�mentaires sont
! index�s selon l'index de face. On doit utiliser la connectivit�
! face->cellules pour faire la somme des volumes �l�mentaires de chaque
! cellule.

! Initialisation

!print*,"!! DEBUG : initialisation"
!mesh%centre(1:ncell,1,1) = v3d(0.,0.,0.)
!mesh%volume(1:ncell,1,1) = 0._krp

! boucle sur la liste des faces et sommation pour les cellules

print*,"!! DEBUG : sommation"
do if = 1, nface

  ic1 = facecell%fils(if,1)
  ic2 = facecell%fils(if,2)

  ! premi�re cellule connect�e
  mesh%centre(ic1,1,1) = mesh%centre(ic1,1,1) + vol_elem(if,1)*cg_elem(if,1)
  mesh%volume(ic1,1,1) = mesh%volume(ic1,1,1) + vol_elem(if,1)

  ! seconde cellule connect�e (si existante)
  if (ic2 /= 0) then
    mesh%centre(ic2,1,1) = mesh%centre(ic2,1,1) + vol_elem(if,2)*cg_elem(if,2)
    mesh%volume(ic2,1,1) = mesh%volume(ic2,1,1) + vol_elem(if,2)
  endif

enddo

! calcul de la moyenne sur les cellules
do ic = 1, ncell
  mesh%centre(ic,1,1) = mesh%centre(ic,1,1) /  mesh%volume(ic,1,1)
enddo


endsubroutine calc_ust_cell
