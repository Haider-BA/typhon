!------------------------------------------------------------------------------!
! Liste de fonctions : count_struct       Auteur : J. Gressier
!                                         Date   : Mai 2002
! Fonction                                Modif  :
!   Calcul de maillage, et �l�ments g�om�triques associ�s
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!


!------------------------------------------------------------------------------!
! Proc�dure : Calcul des centres de c�t�s � partir des sommets sur une ligne
!------------------------------------------------------------------------------!
subroutine calc_center1d(imin, imax, vertex, center)
use TYPHMAKE
use GEO3D     ! compilation conditionnelle ?
implicit none 
! -- Declaration des entr�es --
integer                           :: imin, imax, jmin, jmax
type(v3d), dimension(imin:imax+1) :: vertex

! -- Declaration des sorties --
type(v3d), dimension(imin:imax)   :: center

! -- Declaration des variables internes --
integer i

! -- Debut de la procedure --

do i = imin, imax
  center(i) = .5*( vertex(i) + vertex(i+1) )
enddo

endsubroutine calc_center1d


!------------------------------------------------------------------------------!
! Proc�dure : Calcul des centres de cellules � partir des sommets dans plan 2D
!------------------------------------------------------------------------------!
subroutine calc_center2d(imin, imax, jmin, jmax, vertex, center)
use TYPHMAKE
use GEO3D     ! compilation conditionnelle ?
implicit none 
! -- Declaration des entr�es --
integer                                       :: imin, imax, jmin, jmax
type(v3d), dimension(imin:imax+1,jmin:jmax+1) :: vertex

! -- Declaration des sorties --
type(v3d), dimension(imin:imax,  jmin:jmax)   :: center

! -- Declaration des variables internes --
integer i, j

! -- Debut de la procedure --


endsubroutine calc_center2d


!------------------------------------------------------------------------------!
! Proc�dure : Calcul du maillage 2D � partir des sommets
!------------------------------------------------------------------------------!
subroutine calc_mesh2d(mesh)
use TYPHMAKE
use STRMESH
implicit none 
! -- Declaration des entr�es --
type(st_mesh) :: mesh         ! entr�e : vertex et dimensions

! -- Declaration des sorties --
! mesh%face, mesh%center, mesh%volume

! -- Declaration des variables internes --
type(v3d), dimension(:,:), allocatable :: iside, jside      ! vecteurs c�t�s
type(v3d)                              :: cg1, cg2          ! centre G des triangles
type(v3d)                              :: v                 ! vecteur provisoire
real(krp)                              :: surf1, surf2      ! surface des triangles
integer                                :: i, j, idim, jdim

! -- Debut de la procedure --

idim = mesh%idim
jdim = mesh%jdim
allocate(iside(idim+1, jdim)
allocate(iside(idim,   jdim+1)

! -- Calcul des c�t�s i cst --
do j = 1, jdim      ! pour toutes les cellules j
  do i = 1, idim+1    ! pour toutes les faces "verticales"
    iside(i,j) = mesh%vertex(i,j+1,1) - mesh%vertex(i,j,1)
  enddo
enddo

! -- Calcul des c�t�s j cst --
do i = 1, idim      ! pour toutes les cellules i
  do j = 1, jdim+1    ! pour toutes les faces "horizontales"
    jside(i,j) = mesh%vertex(i+1,j,1) - mesh%vertex(i,j,1)
  enddo
enddo

! -- Calcul des centres et "volumes" (surfaces) --
! Le centre de gravit� de la cellule est calcul� � partir de la moyenne
! pond�r�e des centres de gravit� des deux triangles d�finissant la face
do i = 1, idim
  do j = 1, idim
    surf1 = abs(iside(i,  j).vect.jside(i,j))       ! Calcul des surfaces des
    surf2 = abs(iside(i+1,j).vect.jside(i,j+1))     ! triangles composant la face
    v     = mesh%vertex(i+1,j,1) + mesh%vertex(i,j+1,1) 
    cg1   = ( mesh%vertex(i,  j)   + v ) / 3.       ! Calcul des centres gravit�
    cg2   = ( mesh%vertex(i+1,j+1) + v ) / 3.
    mesh%volume(i,j,1) = surf1 + surf2
    mesh%center(i,j,1) = ((surf1*cg1) + (surf2*cg2))/mesh%volume(i,j,1)
  enddo
enddo

! -- Calcul des faces i cst --
do j = 1, jdim      ! pour toutes les cellules j
  do i = 1, idim+1    ! pour toutes les faces "verticales"
    mesh%iface(i,j,1)%normale%x =  iside(i,j)%y 
    mesh%iface(i,j,1)%normale%y = -iside(i,j)%x 
    mesh%iface(i,j,1)%normale%z = 0.
    mesh%iface(i,j,1)%surface   = abs(mesh%iface(i,j,1)%normale)
    mesh%iface(i,j,1)%normale   = mesh%iface(i,j,1)%normale / mesh%iface(i,j,1)%surface 
  enddo
enddo

! -- Calcul des c�t�s j cst --
do i = 1, idim      ! pour toutes les cellules i
  do j = 1, jdim+1    ! pour toutes les faces "horizontales"
    mesh%iface(i,j,1)%normale%x = -iside(i,j)%y 
    mesh%iface(i,j,1)%normale%y =  iside(i,j)%x 
    mesh%iface(i,j,1)%normale%z = 0.
    mesh%iface(i,j,1)%surface   = abs(mesh%iface(i,j,1)%normale)
    mesh%iface(i,j,1)%normale   = mesh%iface(i,j,1)%normale / mesh%iface(i,j,1)%surface 
  enddo
enddo

endsubroutine calc_center2d
