!------------------------------------------------------------------------------!
! Procedure : calc_varprim_ns             Auteur : J. Gressier
!                                         Date   : Octobre 2003
! Fonction                                Modif  : (cf historique)
!   Calcul des variables primitives � partir des variables conservatives
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine calc_varprim_ns(defns, field)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use DEFFIELD

implicit none

! -- Declaration des entr�es --
type(mnu_ns) :: defns       ! d�finition des param�tres du solveur

! -- Declaration des entr�es/sorties --
type(st_field)   :: field       ! champ primitives->conservatives

! -- Declaration des variables internes --
integer   :: i
integer   :: ncell
real(krp) :: rho, ec
real(krp) :: g1
type(v3d) :: vel

! -- Debut de la procedure --

ncell = field%ncell
g1    = defns%properties(1)%gamma - 1._krp

do i = 1, ncell
  rho = field%etatcons%tabscal(1)%scal(i)
  vel = field%etatcons%tabvect(1)%vect(i) / rho
  ec  = .5_krp*rho*sqrabs(vel)
  field%etatprim%tabscal(1)%scal(i) = rho
  field%etatprim%tabscal(2)%scal(i) = g1*(field%etatcons%tabscal(2)%scal(i) - ec)
  field%etatprim%tabvect(1)%vect(i) = vel
enddo


!-----------------------------
endsubroutine calc_varprim_ns

!------------------------------------------------------------------------------!
! Historique des modifications
!
! oct  2003 : cr�ation de la proc�dure
! july 2004 : actual computations
!------------------------------------------------------------------------------!
