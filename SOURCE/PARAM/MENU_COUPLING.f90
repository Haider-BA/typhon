!------------------------------------------------------------------------------!
! MODULE : MENU_COUPLING                  Auteur : J. Gressier / E. Radenac
!                                         Date   : Juin 2003
! Fonction                                Modif  :
!   D�finition des m�thodes de couplage entre zones
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module MENU_COUPLING

use TYPHMAKE   ! Definition de la precision et des types basiques

! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! D�finition de la structure COUPLING : definitions des raccords pour une zone
!------------------------------------------------------------------------------!
type mnu_coupling
  integer               :: zone1, zone2  ! num�ro des zones concern�es par le couplage
  integer               :: typ_calc      ! type de calcul/connection des maillages
  integer               :: period_mode   ! mode de calcul de la p�riodicit�
  integer               :: typ_interpol  ! type de calcul/interpolation
  integer               :: n_tpsbase     ! p�riodicit� du couplage
  real(krp)             :: corcoef      ! coefficient pour correction de flux
endtype mnu_coupling


!------------------------------------------------------------------------------!
! D�finition de la structure SENSEUR : senseur pour le d�clenchement du couplage
!------------------------------------------------------------------------------!
type mnu_senseur
  integer                      :: mode ! utilisation du senseur
  logical                      :: sens ! "d�tection" de conditions de d�clenchement
  				       ! de couplage
  integer                      :: nmin
  integer                      :: nmax
  real(krp)                    :: ecartflux
  real(krp)                    :: epsilon
endtype mnu_senseur


endmodule MENU_COUPLING

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juin 2003 (v0.0.1b): cr�ation du module
! oct 2003           : ajout coeff correction de flux
!------------------------------------------------------------------------------!


