!------------------------------------------------------------------------------!
! Procedure : calc_zonetimestep           Auteur : J. Gressier
!                                         Date   : Septembre 2003
! Fonction                                Modif  : (cf historique)
!   Calcul du pas de temps local et global par zone selon solveur
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine calc_zonetimestep(lzone, dt)

use TYPHMAKE
use OUTPUT
use VARCOM
use MODWORLD

implicit none

! -- Declaration des entr�es --
type(st_zone) :: lzone

! -- Declaration des sorties --
real(krp)      :: dt

! -- Declaration des variables internes --
real(krp), dimension(:), allocatable :: dtloc    ! tableau de pas de temps local
integer                              :: ncell    ! nombre de cellules pour le calcul


! -- Debut de la procedure --


! -- Calcul des pas de temps locaux --

ncell = lzone%ust_mesh%ncell_int
allocate(dtloc(ncell))

select case(lzone%deftime%stab_meth)

case(given_dt)   ! -- Pas de temps impos� --

case(stab_cond)  ! -- Calcul par condition de stabilit� (deftim%stabnb) --
  select case(lzone%defsolver%typ_solver)
  case(solKDIF)
    call calc_kdif_timestep(lzone%deftime, lzone%defsolver%defkdif%materiau, &
                            lzone%ust_mesh, lzone%field, dtloc, ncell)
  case default
    call erreur("incoh�rence interne (calc_zonetimestep)", "solveur inconnu")
  endselect

endselect

! -- DEV -- pas de temps global impos� dans cette version

dt = minval(dtloc)

deallocate(dtloc)



endsubroutine calc_zonetimestep

!------------------------------------------------------------------------------!
! Historique des modifications
!   sept 2003 : cr�ation, appel des proc�dures sp�cifiques aux solveurs
!------------------------------------------------------------------------------!
