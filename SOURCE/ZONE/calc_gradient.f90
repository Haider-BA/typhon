!------------------------------------------------------------------------------!
! Procedure : calc_gradient               Auteur : J. Gressier
!                                         Date   : Septembre 2003
! Fonction                                Modif  : (cf historique)
!   Calcul des gradients d'un champ g�n�rique (conservatif ou primitif)
!
! Defauts/Limitations/Divers :
!   - le calcul des gradients ne doit se faire que sur les cellules internes
!
!------------------------------------------------------------------------------!
subroutine calc_gradient(def_solver, mesh, gfield, grad)

use TYPHMAKE
use LAPACK
use OUTPUT
use VARCOM
use MENU_SOLVER
use DEFFIELD
use USTMESH

implicit none

! -- Declaration des entr�es --
type(mnu_solver)      :: def_solver  ! d�finition des param�tres du solveur
type(st_ustmesh)      :: mesh        ! maillage et connectivit�s
type(st_genericfield) :: gfield      ! champ des valeurs

! -- Declaration des sorties --
type(st_genericfield) :: grad        ! champ des gradients

! -- Declaration des variables internes --
type(v3d), allocatable :: dcg(:)      ! delta cg
!type(v3d), allocatable :: rhs(:)    ! second membre
real(krp), allocatable :: rhs(:,:)    ! second membre
type(t3d), allocatable :: mat(:)      ! matrice AT.A
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

nc  = mesh%ncell_int   ! nombre de cellules internes
nfi = mesh%nface_int   ! nb de faces internes (connect�es avec 2 cellules)
nf  = mesh%nface       ! nb de faces totales 
allocate(dcg(nf))

! -- Calcul des diff�rences de centres de cellules --
!    (toutes les faces, m�me limites, doivent avoir un centre de cellule)

do if = 1, nf
  ic1 = mesh%facecell%fils(if,1)
  ic2 = mesh%facecell%fils(if,2)
  dcg(if) = mesh%mesh%centre(ic2,1,1) - mesh%mesh%centre(ic1,1,1) 
enddo

! -- Calcul des matrices At.A et inversion --

allocate(mat(nc))
do ic = 1, nc
  mat(ic)%mat = 0._krp
enddo

! -- boucle sur les faces internes uniquement (code source doubl�)  --

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
  
  ! contribution de la face � la cellule � gauche
  ic1 = mesh%facecell%fils(if,1)
  mat(ic1)%mat(:,:) = mat(ic1)%mat(:,:) + imat(:,:)
  
  ! contribution de la face � la cellule � droite
  ic2 = mesh%facecell%fils(if,2)
  mat(ic2)%mat(:,:) = mat(ic2)%mat(:,:) + imat(:,:)
enddo

! -- boucle sur les faces limites uniquement (code source doubl�) --

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
  
  ! contribution de la face � la cellule � gauche (UNIQUEMENT)
  ic1 = mesh%facecell%fils(if,1)
  mat(ic1)%mat(:,:) = mat(ic1)%mat(:,:) + imat(:,:)
enddo

! -- Correction de la matrice dans les cas 2D (vecteur suppl�mentaire selon z) --

do ic = 1, nc
  mat(ic)%mat(3,3) = mat(ic)%mat(3,3) + 1._krp
enddo



! l'inversion peut se faire des fa�on suivantes selon A sym�trique (PO) ou non (GE)
! * calcul de l'inverse Ai (GETRI/POTRI) et multiplication Ai.B
! * d�composition LU (GETRF) et r�solution (GETRS)
! * d�composition Choleski (POTRF) et r�solution (POTRS)

xinfo = 0
do ic = 1, nc
  ! d�composition de Choleski
  call lapack_potrf('U', 3, mat(ic)%mat, 3, info)
  if (info /= 0) xinfo = ic
  !if (info /= 0) then
  !  xinfo = ic
  !  print*,"DEBUG!!: xinfo = ",xinfo
  !endif
enddo

!print*,"DEBUG!!: xinfo = ",xinfo
if (xinfo /= 0) call erreur("Routine LAPACK","Probl�me POTRF")

! -- Calcul du second membre -At.dT et r�solution (multiplication par l'inverse) --
! ?? OPTIMISATION par interface variable/tableaux et r�solution en un seul coup

!nv = nbvar()
allocate(rhs(3,nc))    ! allocation
rhs(:,:) = 0._krp      ! initialisation

! calcul des gradients de scalaires

do is = 1, gfield%nscal

  ! Calcul des seconds membres (cellules internes et limites)
  do if = 1, nfi
    ic1  = mesh%facecell%fils(if,1)
    ic2  = mesh%facecell%fils(if,2)
    dsca = gfield%tabscal(is)%scal(ic2) - gfield%tabscal(is)%scal(ic1) 
    rhs(1:3, ic1) = rhs(1:3, ic1) - dsca*tab(dcg(if))
    rhs(1:3, ic2) = rhs(1:3, ic2) + dsca*tab(dcg(if))
  enddo
  do if = nfi+1, nf
    ic1  = mesh%facecell%fils(if,1)
    ic2  = mesh%facecell%fils(if,2)
    dsca = gfield%tabscal(is)%scal(ic2) - gfield%tabscal(is)%scal(ic1) 
    rhs(1:3, ic1) = rhs(1:3, ic1) - dsca*tab(dcg(if))
  enddo

  ! Resolution
  xinfo = 0
  do ic = 1, nc
    call lapack_potrs('U', 3, 1, mat(ic)%mat, 3, rhs(1:3,ic:ic), 3, info)
    if (info /= 0) xinfo = ic
  enddo
  if (xinfo /= 0) call erreur("Routine LAPACK","Probl�me POTRS")
  do ic = 1, nc
    grad%tabvect(is)%vect(ic) = v3d_of(rhs(1:3,ic))
  enddo
enddo

! calcul des gradients de vecteurs

do is = 1, gfield%nvect
  call erreur("D�veloppement","calcul de gradients de vecteurs non impl�ment�")
enddo

! --d�sallocation

deallocate(dcg, rhs)


!-----------------------------
endsubroutine calc_gradient

!------------------------------------------------------------------------------!
! Historique des modifications
!
! sept 2003 : cr�ation de la proc�dure
! DEV: optimiser le calcul de gradient
! DEV: cr�ation de proc�dures intrins�ques dans les modules 
!------------------------------------------------------------------------------!
