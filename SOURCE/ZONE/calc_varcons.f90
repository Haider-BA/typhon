 !------------------------------------------------------------------------------!
! Procedure : calc_varcons                Auteur : J. Gressier
!                                         Date   : Juin 2003
! Fonction                                Modif  : (cf historique)
!   Calcul des variables conservatives � partir des variables primitives
!   Reroutage vers des proc�dures sp�cifiques aux solveurs
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine calc_varcons(def_solver, field)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use DEFFIELD

implicit none

! -- Declaration des entr�es --
type(mnu_solver) :: def_solver       ! d�finition des param�tres du solveur

! -- Declaration des entr�es/sorties --
type(st_field)   :: field            ! champ primitives->conservatives

! -- Declaration des variables internes --


! -- Debut de la procedure --


select case(def_solver%typ_solver)
case(solNS)
  call calc_varcons_ns(def_solver%defns, field)
case(solKDIF)
  call calc_varcons_kdif(def_solver%defkdif, field)
case default
  call erreur("Incoh�rence interne (calc_varcons)","type de solveur inconnu")
endselect 


!-----------------------------
endsubroutine calc_varcons

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juin 2003 : cr�ation de la proc�dure
! july 2004 : NS solver (call calv_varcons_ns)
!------------------------------------------------------------------------------!
