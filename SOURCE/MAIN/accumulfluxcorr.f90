!------------------------------------------------------------------------------!
! Procedure : accumulfluxcorr            Auteur : E.Radenac
!                                         Date   : Juillet 2003
! Fonction                                Modif  : 
!   Accumulation des flux entre deux �changes de donn�es entre zone coupl�es
!   pour correction ult�rieure des pertes de flux � l'interface. Orientation
!   selon solver
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine accumulfluxcorr(dt, def_solver, domainenboco, domaineboco, &
                           nface, flux, ncoupling, coupling)
                           

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use USTMESH
use MENU_ZONECOUPLING

implicit none

! -- Declaration des entr�es --
real(krp)        :: dt               ! pas de temps CFL
type(mnu_solver) :: def_solver       ! propri�t�s du solver
integer          :: domainenboco     ! nb de conditions aux limites du domaine
type(st_ustboco), dimension(1:domainenboco) &
                 :: domaineboco      !conditions aux limites du domaine
integer          :: nface            ! nombre de faces du domaine
real(krp), dimension(1:nface) &
                 :: flux
integer          :: ncoupling        ! nombre de couplages de la zone

! -- Declaration des entr�es/sorties --
type(mnu_zonecoupling), dimension(1:ncoupling) &
                 :: coupling ! donn�es de couplage

! -- Debut de la procedure --

select case(def_solver%typ_solver)
case(solKDIF)
  call accumulfluxcorr_kdif(dt, def_solver%nboco, def_solver%boco, &
                           domainenboco, domaineboco, nface, flux, &
                           ncoupling, coupling)
case default
  call erreur("Incoh�rence interne (accumulfluxcorr)","type de solveur inconnu")
endselect 

endsubroutine accumulfluxcorr

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juillet 2003 (v0.0.1b): cr�ation de la proc�dure
!------------------------------------------------------------------------------!
