!------------------------------------------------------------------------------!
! Procedure : flux_limite                 Auteur : J. Gressier/E. Radenac
!                                         Date   : Juin 2004
! Fonction                                Modif  : (cf Historique)
!  Flux aux faces limites quand n�cessaire
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine fluxlimite(defsolver, domaine, flux)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use MENU_BOCO
use USTMESH
use DEFFIELD 

implicit none

! -- Declaration des entr�es --
type(mnu_solver) :: defsolver        ! type d'�quation � r�soudre
type(st_ustmesh) :: domaine          ! domaine non structur� � int�grer

! -- Declaration des sorties --
type(st_genericfield)   :: flux        ! flux physiques

! -- Declaration des variables internes --
integer          :: ifb, if, ib, idef     ! index de liste, index de face limite et param�tres

! -- Debut de la procedure --

do ib = 1, domaine%nboco
  idef = domaine%boco(ib)%idefboco
  if ( (defsolver%boco(idef)%typ_boco == bc_wall_adiab) .or. (defsolver%boco(idef)%typ_boco == bc_wall_flux) .or. (defsolver%boco(idef)%typ_boco == bc_wall_hconv) ) then
    do ifb = 1, domaine%boco(ib)%nface
      if = domaine%boco(ib)%iface(ifb)
      flux%tabscal(1)%scal(if) = domaine%boco(ib)%bocofield%tabscal(1)%scal(ifb)
    enddo
  endif
enddo

endsubroutine fluxlimite

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juin 2004             : cr�ation de la proc�dure
!------------------------------------------------------------------------------!
