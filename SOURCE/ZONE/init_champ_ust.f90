!------------------------------------------------------------------------------!
! Procedure : init_champ_ust              Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  : Juin 2003
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine init_champ_ust(defsolver, ust_mesh, champ)

use TYPHMAKE
use VARCOM
use OUTPUT
use USTMESH
use DEFFIELD
use MENU_SOLVER

implicit none

! -- Declaration des entr�es --
type(mnu_solver) :: defsolver            ! param�tres du solveur
type(st_ustmesh) :: ust_mesh             ! maillage et connectivit�s

! -- Declaration des sorties --
type(st_field)   :: champ                ! champ d'�tat et de gradients

! -- Declaration des variables internes --
integer :: i

! -- Debut de la procedure --

call print_info(8, ". initialisation des champs")

! allocation des champs

call new(champ, 1, 0, ust_mesh%ncell, ust_mesh%nface)
call alloc_prim(champ)

! Boucle sur les d�finitions de champ

do i = 1, defsolver%ninit

  write(str_w,*) "    initialisation n�",i
  call print_info(10, str_w)

  ! initialisation selon solveur

  select case(defsolver%typ_solver)
  case(solKDIF)
    call init_kdif_ust(defsolver%init(i)%kdif, champ)
  case default
    call erreur("Incoh�rence interne (init_champ_ust)","type de solveur inconnu")
  endselect 

enddo

call calc_varcons(defsolver, champ)

endsubroutine init_champ_ust

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2003 (v0.0.1b): cr�ation de la proc�dure
! juin 2003          : mise � jour 
!------------------------------------------------------------------------------!
