!------------------------------------------------------------------------------!
! Procedure : calc_varcons_ns             Auteur : J. Gressier
!                                         Date   : Octobre 2003
! Fonction                                Modif  : (cf historique)
!   Calcul des variables conservatives � partir des variables primitives
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine calc_varcons_ns(defns, field)

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
integer :: ip

! -- Debut de la procedure --

do ip = 1, field%nscal

enddo


!-----------------------------
endsubroutine calc_varcons_ns

!------------------------------------------------------------------------------!
! Historique des modifications
!
! oct  2003 : cr�ation de la proc�dure
!------------------------------------------------------------------------------!
