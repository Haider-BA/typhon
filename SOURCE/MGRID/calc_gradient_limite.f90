!------------------------------------------------------------------------------!
! Procedure : calc_gradient_limite        Auteur : J. Gressier
!                                         Date   : Octobre 2003
! Fonction                                Modif  : (cf historique)
!   Calcul des gradients aux limites � partir des gradients uniquement
!
! Defauts/Limitations/Divers :
!   - le calcul des gradient_limites ne doit se faire que sur les cellules limites
!
!------------------------------------------------------------------------------!
subroutine calc_gradient_limite(def_solver, mesh, grad)

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

! -- Declaration des sorties --
type(st_genericfield) :: grad        ! champ des gradients

! -- Declaration des variables internes --
integer :: nc, nf, nfi, is, if, ic1, ic2

! -- Debut de la procedure --

nc  = mesh%ncell_int   ! nombre de cellules internes
nfi = mesh%nface_int   ! nb de faces internes (connect�es avec 2 cellules)
nf  = mesh%nface       ! nb de faces totales 

! calcul des gradient_limites de scalaires (vecteurs gradient)

do is = 1, grad%nvect
  do if = nfi+1, nf
    ic1 = mesh%facecell%fils(if,1)
    ic2 = mesh%facecell%fils(if,2)
    grad%tabvect(is)%vect(ic2) = grad%tabvect(is)%vect(ic1)
  enddo
enddo

! calcul des gradient_limites de vecteurs (tenseur gradient)

do is = 1, grad%ntens
  call erreur("D�veloppement","calcul de gradient_limites de vecteurs non impl�ment�")
enddo

!-----------------------------
endsubroutine calc_gradient_limite

!------------------------------------------------------------------------------!
! Historique des modifications
!
! oct 2003 : cr�ation de la proc�dure
!------------------------------------------------------------------------------!
