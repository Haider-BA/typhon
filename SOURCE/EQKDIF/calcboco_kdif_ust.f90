!------------------------------------------------------------------------------!
! Procedure : calcboco_kdif_ust           Auteur : J. Gressier
!                                         Date   : Avril 2003
! Fonction                                Modif  : Juin  2003 (cf Historique)
!   Calcul des conditions aux limites pour la conduction de la chaleur
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine calcboco_kdif_ust(defboco, ustboco, ustdom, champ)

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

  !!print*,"!! DEBUG-isoth : ",defboco%boco_kdif%temp_wall
  do ifb = 1, ustboco%nface
    if     = ustboco%iface(ifb)
    ighost = ustdom%facecell%fils(if,2)
    do ip = 1, champ%nscal
      champ%etatprim%tabscal(ip)%scal(ighost) = defboco%boco_kdif%temp_wall
    enddo
  enddo

case(bc_wall_flux)
  call erreur("D�veloppement","Condition de flux impos� non impl�ment�e")

case(bc_wall_hconv)
  call erreur("D�veloppement","Condition de flux de convection non impl�ment�e")

endselect


endsubroutine calcboco_kdif_ust

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avril 2003 (v0.0.1b) : cr�ation de la proc�dure
! juin  2003           : m�j pour gestion variables conservatives et primitves
!------------------------------------------------------------------------------!
