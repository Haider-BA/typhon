!------------------------------------------------------------------------------!
! Procedure : dlu_lu                      Auteur : J. Gressier
!                                         Date   : Avril 2004
! Fonction                                Modif  : (cf historique)
!   Resolution d'un systeme lin�aire mat.sol = rhs
!     mat sous forme type(st_dlu)
!     m�thode directe : d�composition LU et resolution
!
! Defauts/Limitations/Divers :
!   - le tableau sol(*) est cens� �tre d�j� allou�
!   - la r�solution passe par l'allocation d'une matrice pleine (dim*dim)
!
!------------------------------------------------------------------------------!
subroutine dlu_lu(mat, rhs, sol)

use TYPHMAKE
use SPARSE_MAT
use LAPACK

implicit none

! -- Declaration des entr�es --
type(st_dlu)            :: mat
real(krp), dimension(*) :: rhs

! -- Declaration des sorties --
real(krp), dimension(*) :: sol

! -- Declaration des variables internes --
real(krp),    dimension(:,:), allocatable :: pmat, pvec
integer(kip), dimension(:),   allocatable :: piv
integer(kip)                              :: i, imin, imax, info

! -- Debut de la procedure --


! -- reconstruction d'une matrice pleine --

allocate(pmat(mat%dim, mat%dim))

do i = 1, mat%dim
  pmat(i,i) = mat%diag(i)
enddo

do i = 1, mat%ncouple
  imin = minval(mat%couple%fils(i,1:2))
  imax = maxval(mat%couple%fils(i,1:2))
  if (imax <= mat%dim) then
    pmat(imax,imin) = mat%lower(i)
    pmat(imin,imax) = mat%upper(i)
  endif
enddo

! -- reconstruction du vecteur rhs --

allocate(pvec(1:mat%dim, 1))
pvec(1:mat%dim, 1) = rhs(1:mat%dim)

! -- resolution --

allocate(piv(mat%dim))

! d�composition LU dans pmat

call lapack_getrf(mat%dim, mat%dim, pmat, mat%dim, piv, info)

if (info /= 0) call erreur("r�solution matricielle",&
                           "probl�me dans la d�composition LU")

! resolution RHS dans pvec en entr�e, solution en sortie
call lapack_getrs('N', mat%dim, 1, pmat, mat%dim, piv, pvec, mat%dim, info)

if (info /= 0) call erreur("r�solution matricielle",&
                           "probl�me dans l'inversion")

! -- redistribution --
sol(1:mat%dim) = pvec(1:mat%dim, 1)

! desallocation

deallocate(pmat, pvec, piv)


endsubroutine dlu_lu

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avr  2004 : cr�ation de la proc�dure
!------------------------------------------------------------------------------!
