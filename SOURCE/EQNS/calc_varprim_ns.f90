!------------------------------------------------------------------------------!
! Procedure : calc_varprim_ns           Auteur : J. Gressier
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
integer :: ip
integer        :: ncell

! -- Debut de la procedure --

ncell = field%ncell

do ip = 1, field%nscal

enddo


!-----------------------------
endsubroutine calc_varprim_ns

!------------------------------------------------------------------------------!
! Historique des modifications
!
! oct  2003 : cr�ation de la proc�dure
!------------------------------------------------------------------------------!
