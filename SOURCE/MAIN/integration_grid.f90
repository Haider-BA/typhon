!------------------------------------------------------------------------------!
! Procedure : integration_grid            Auteur : J. Gressier
!                                         Date   : Avril 2003
! Fonction                                Modif  : (cf historique)
!   Integration domaine par domaine
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine integration_grid(dt, typtemps, defsolver, defspat, deftime, grid, &
                            coupling, ncoupling)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use MENU_NUM
use MGRID
use MENU_ZONECOUPLING

implicit none

! -- Declaration des entr�es --
real(krp)        :: dt               ! pas de temps CFL
character        :: typtemps         ! type d'integration (stat, instat, period)
type(mnu_solver) :: defsolver        ! type d'�quation � r�soudre
type(mnu_spat)   :: defspat          ! param�tres d'int�gration spatiale
type(mnu_time)   :: deftime          ! param�tres d'int�gration spatiale
integer          :: ncoupling        ! nombre de couplages de la zone

! -- Declaration des entr�es/sorties --
type(st_grid)    :: grid             ! domaine non structur� � int�grer
type(mnu_zonecoupling), dimension(1:ncoupling) &
                 :: coupling ! donn�es de couplage

! -- Declaration des variables internes --


! -- Debut de la procedure --


select case(deftime%tps_meth)

case(tps_expl)
  call explicit_step(dt, typtemps, defsolver, defspat, deftime, grid%umesh, grid%field_loc, &
                     coupling, ncoupling)

case(tps_rk)
  call erreur("developpement","m�thode RUNGE KUTTA non impl�ment�e")

case(tps_impl)
  call implicit_step(dt, typtemps, defsolver, defspat, deftime, grid%umesh, grid%field_loc, &
                     coupling, ncoupling)

case(tps_dualt)
  call erreur("developpement","m�thode DUAL TIME non impl�ment�e")

case default
  call erreur("incoh�rence","param�tre inattendu (integration_grid)")
endselect



endsubroutine integration_grid

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avr  2003 : cr�ation de la proc�dure
! juil 2003 : ajout corrections de  flux
! oct  2003 : corrections de flux seulement en instationnaire
! avr  2004 : changement de nom  integration_ustdomaine -> integration_grid
!             appel des routines d'integration temporelle
! oct  2004 : field chained list
!------------------------------------------------------------------------------!
