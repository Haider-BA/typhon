!------------------------------------------------------------------------------!
! Procedure : calcboco_kdif               Auteur : J. Gressier/E. Radenac
!                                         Date   : Avril 2003
! Fonction                                Modif  : (cf Historique)
!   Calcul des conditions aux limites non uniformes pour la conduction de la 
!   chaleur
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine calcboco_kdif(defsolver, defboco, ustboco, grid)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use MENU_BOCO
use USTMESH
use DEFFIELD 

implicit none

! -- Declaration des entr�es --
type(mnu_boco)   :: defboco          ! param�tres de conditions aux limites
type(st_ustboco) :: ustboco          ! lieu d'application des conditions aux limites
type(mnu_solver) :: defsolver        ! type d'�quation � r�soudre

! -- Declaration des sorties --
type(st_grid)    :: grid             ! mise � jour du champ (maillage en entr�e)

! -- Declaration des variables internes --
integer          :: ifb, if, ip      ! index de liste, index de face limite et param�tres
integer          :: icell, ighost    ! index de cellule int�rieure, et de cellule fictive
type(st_genericfield), pointer :: pbcf

! -- Debut de la procedure --

select case(defboco%typ_boco) 

case(bc_wall_isoth)
  call setboco_kdif_isoth(defboco%boco_unif, ustboco, grid%umesh, grid%field, defboco%boco_kdif)

case(bc_wall_flux)
  pbcf => newbocofield(grid,ustboco%nface,1,0,0)  
  call setboco_kdif_flux(defboco%boco_unif, ustboco, grid%umesh, grid%field, pbcf%tabscal(1)%scal, &
                         defsolver, defboco%boco_kdif)
  ustboco%bocofield => pbcf

case(bc_wall_hconv)
  pbcf => newbocofield(grid,ustboco%nface,1,0,0) 
  call setboco_kdif_hconv(defboco%boco_unif, ustboco, grid%umesh, grid%field, pbcf%tabscal(1)%scal, &
                          defsolver, defboco%boco_kdif)
  ustboco%bocofield => pbcf

case default
  call erreur("D�veloppement","Condition limite inconnu � ce niveau (calcboco_kdif)")

endselect


endsubroutine calcboco_kdif

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avr  2003 : cr�ation de la proc�dure
! juin 2003 : m�j pour gestion variables conservatives et primitves
! nov  2003 : distinction entre conditions uniformes et non 
!             uniformes (ancien nom : calcboco_kdif_ust)
! july 2004 : merge of uniform or non-uniform boundary conditions
!             (old name: calc_boco_kdif_?unif)
!------------------------------------------------------------------------------!
