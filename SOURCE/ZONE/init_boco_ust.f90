!------------------------------------------------------------------------------!
! Procedure : init_boco_ust               Auteur : J. Gressier/ E. Radenac
!                                         Date   : Nov 2003
! Fonction                                Modif  :
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine init_boco_ust(defsolver, ustdom)

use TYPHMAKE
use VARCOM
use OUTPUT
use USTMESH
use DEFFIELD
use MENU_SOLVER

implicit none

! -- Declaration des entr�es --
type(mnu_solver) :: defsolver            ! param�tres du solveur
type(st_ustmesh) :: ustdom             ! maillage et connectivit�s

! -- Declaration des sorties --

! -- Declaration des variables internes --

! -- Debut de la procedure --

! initialisation selon solveur

select case(defsolver%typ_solver)
case(solKDIF)
  call init_boco_kdif(defsolver, ustdom)
case default
  call erreur("Incoh�rence interne (init_boco_ust)","type de solveur inconnu")
endselect 

endsubroutine init_boco_ust

!------------------------------------------------------------------------------!
! Historique des modifications
!
! nov 2003 (v0.1.2): cr�ation de la proc�dure
!------------------------------------------------------------------------------!
