!------------------------------------------------------------------------------!
! Procedure : calc_varprim_kdif           Auteur : J. Gressier
!                                         Date   : Juin 2003
! Fonction                                Modif  : Juin 2003 (cf historique)
!   Calcul des variables primitives � partir des variables conservatives
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine calc_varprim_kdif(defkdif, field)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use DEFFIELD

implicit none

! -- Declaration des entr�es --
type(mnu_kdif) :: defkdif       ! d�finition des param�tres du solveur

! -- Declaration des entr�es/sorties --
type(st_field)   :: field       ! champ primitives->conservatives

! -- Declaration des variables internes --
integer :: ip
integer        :: ncell

! -- Debut de la procedure --

ncell = field%ncell

do ip = 1, field%nscal
  select case(defkdif%materiau%type)
  case(mat_LIN, mat_KNL)
    field%etatprim%tabscal(ip)%scal(1:ncell) = &
                          field%etatcons%tabscal(ip)%scal(1:ncell) &
                          / defkdif%materiau%Cp 
  case(mat_XMAT)
    call erreur("Calcul de mat�riau","Materiau non lin�aire interdit")
  endselect
enddo


!-----------------------------
endsubroutine calc_varprim_kdif

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juin 2003 (v0.0.1b): cr�ation de la proc�dure
!------------------------------------------------------------------------------!
