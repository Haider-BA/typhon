!------------------------------------------------------------------------------!
! Procedure : calcboco_kdif_ust_nunif     Auteur : J. Gressier/E. Radenac
!                                         Date   : Avril 2003
! Fonction                                Modif  : Novembre 2003 (cf Historique)
!   Calcul des conditions aux limites non uniformes pour la conduction de la 
!   chaleur
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine calcboco_kdif_ust_nunif(defboco, ustboco, ustdom, champ)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_BOCO
use USTMESH
use DEFFIELD 

implicit none

! -- Declaration des entr�es --
type(mnu_boco)   :: defboco          ! param�tres de conditions aux limites
type(st_ustboco) :: ustboco          ! lieu d'application des conditions aux limites
type(st_ustmesh) :: ustdom           ! maillage non structur�

! -- Declaration des sorties --
type(st_field)   :: champ            ! champ des �tats

! -- Declaration des variables internes --
integer          :: ifb, if, ip      ! index de liste, index de face limite et param�tres
integer          :: icell, ighost    ! index de cellule int�rieure, et de cellule fictive

! -- Debut de la procedure --

select case(defboco%typ_boco)

case(bc_wall_adiab)   
  call erreur("D�veloppement","Extrapolation d'ordre 2 non impl�ment�e")

case(bc_wall_isoth)
  call setboco_kdif_isoth_nunif(ustboco, ustdom, champ, &
                               defboco%boco_kdif%temp)
case(bc_wall_flux)
  call erreur("D�veloppement","Condition de flux impos� non impl�ment�e")

case(bc_wall_hconv)
  call erreur("D�veloppement","Condition de flux de convection non impl�ment�e")

endselect


endsubroutine calcboco_kdif_ust_nunif

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avril 2003 (v0.0.1b) : cr�ation de la proc�dure
! juin  2003           : m�j pour gestion variables conservatives et primitves
! nov 2003             : distinction entre conditions uniformes et non 
!                        uniformes (ancien nom : calcboco_kdif_ust)
!------------------------------------------------------------------------------!
