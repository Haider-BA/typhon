!------------------------------------------------------------------------------!
! Procedure : precalc_grad_lsq               Auteur : J. Gressier
!                                         Date   : Septembre 2003
! Fonction                                Modif  : (cf historique)
!   Calcul des gradients d'un champ generique (conservatif ou primitif)
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine precalc_grad_lsq(def_solver, mgrid)

use TYPHMAKE
use LAPACK
use OUTPUT
use VARCOM
use MENU_SOLVER
use DEFFIELD
use USTMESH

implicit none

! -- Declaration des entrees --
type(mnu_solver)      :: def_solver  ! definition des parametres du solveur
type(st_mgrid)        :: mgrid       ! maillage et connectivites

! -- Declaration des sorties --
type(st_genericfield) :: grad        ! champ des gradients

! -- Declaration des variables internes --
type(v3d), allocatable :: dcg(:)      ! delta cg
real(krp), allocatable :: rhs(:,:)    ! second membre
real(krp)              :: imat(3,3)   ! matrice locale
real(krp)              :: dsca        ! variation de variable scalaire
type(v3d)              :: dvec        ! variation de variable vectorielle
integer                :: ic, nc      ! indice et nombre de cellules internes
integer                :: if, nf, nfi ! indice et nombre de faces totales et internes
integer                :: nv          ! nombre de variables
integer                :: is, iv      ! indice de variable scalaire et vectorielle
integer                :: ic1, ic2    ! indices de cellules (gauche et droite de face)
integer                :: info, xinfo ! retour d'info des routines LAPACK

! -- Debut de la procedure --

nc  = mgrid%umesh%ncell_int   ! nombre de cellules internes
nfi = mgrid%umesh%nface_int   ! nb de faces internes (connectees avec 2 cellules)
nf  = mgrid%umesh%nface       ! nb de faces totales 
allocate(dcg(nf))

! need OPTIMIZATION
! - splitting of loops into packets
! - define some calls (check efficiency)
! - memorize geometrical matrix


! -- Calcul des differences de centres de cellules --
!    (toutes les faces, meme limites, doivent avoir un centre de cellule)

do if = 1, nf
  ic1 = mgrid%umesh%facecell%fils(if,1)
  ic2 = mgrid%umesh%facecell%fils(if,2)
  dcg(if) = mgrid%umesh%mesh%centre(ic2,1,1) - mgrid%umesh%mesh%centre(ic1,1,1) 
enddo

! -- Calcul des matrices At.A et inversion --

allocate(mat(nc))
do ic = 1, nc
  mat(ic)%mat = 0._krp
enddo

! -- boucle sur les faces internes uniquement (code source double)  --

do if = 1, nfi
  imat(1,1) = dcg(if)%x **2
  imat(2,2) = dcg(if)%y **2
  imat(3,3) = dcg(if)%z **2
  imat(1,2) = dcg(if)%x * dcg(if)%y
  imat(2,1) = imat(1,2)
  imat(1,3) = dcg(if)%x * dcg(if)%z
  imat(3,1) = imat(1,3)
  imat(2,3) = dcg(if)%y * dcg(if)%z
  imat(3,2) = imat(2,3)
  
  ! contribution de la face a la cellule a gauche
  ic1 = mgrid%umesh%facecell%fils(if,1)
  mat(ic1)%mat(:,:) = mat(ic1)%mat(:,:) + imat(:,:)
  
  ! contribution de la face a la cellule a droite
  ic2 = mgrid%umesh%facecell%fils(if,2)
  mat(ic2)%mat(:,:) = mat(ic2)%mat(:,:) + imat(:,:)
enddo

! -- boucle sur les faces limites uniquement (code source double) --

do if = nfi+1, nf
  imat(1,1) = dcg(if)%x **2
  imat(2,2) = dcg(if)%y **2
  imat(3,3) = dcg(if)%z **2
  imat(1,2) = dcg(if)%x * dcg(if)%y
  imat(2,1) = imat(1,2)
  imat(1,3) = dcg(if)%x * dcg(if)%z
  imat(3,1) = imat(1,3)
  imat(2,3) = dcg(if)%y * dcg(if)%z
  imat(3,2) = imat(2,3)
  
  ! contribution de la face a la cellule a gauche (UNIQUEMENT)
  ic1 = mgrid%umesh%facecell%fils(if,1)
  mat(ic1)%mat(:,:) = mat(ic1)%mat(:,:) + imat(:,:)
enddo

! -- Correction de la matrice dans les cas 2D (vecteur supplementaire selon z) --

select case(mgrid%umesh%mesh%info%geom)
case(msh_2Dplan)
  do ic = 1, nc
    mat(ic)%mat(3,3) = mat(ic)%mat(3,3) + 1._krp  ! invariance direction ? magnitude ?
  enddo
case(msh_3D)
  ! nothing to do 
case default
  call erreur("computing gradients","unknown type of mesh")
endselect

! l'inversion peut se faire des fa�ons suivantes selon A symetrique (PO) ou non (GE)
! * calcul de l'inverse Ai (GETRI/POTRI) et multiplication Ai.B
! * decomposition LU (GETRF) et resolution (GETRS)
! * decomposition Choleski (POTRF) et resolution (POTRS)

xinfo = 0
do ic = 1, nc
  ! decomposition de Choleski
  call lapack_potrf('U', 3, mat(ic)%mat, 3, info)
  if (info /= 0) xinfo = ic
  !if (info /= 0) then
  !  xinfo = ic
  !  print*,"DEBUG!!: xinfo = ",xinfo
  !endif
enddo

!print*,"DEBUG!!: xinfo = ",xinfo
if (xinfo /= 0) call erreur("Routine LAPACK","Probleme POTRF")


deallocate(dcg)


!-----------------------------
endsubroutine precalc_grad_lsq

!------------------------------------------------------------------------------!
! Changes history
!
! dec  2004 : created (from split of calc_gradient)
!------------------------------------------------------------------------------!