!------------------------------------------------------------------------------!
! Procedure : setboco_kdif_hconv_unif     Auteur : J. Gressier/E. Radenac
!                                         Date   : Juin 2004
! Fonction                                Modif  : (cf Historique)
!   Calcul des conditions aux limites non uniformes pour la conduction de la 
!   chaleur
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine setboco_kdif_hconv_nunif(ustboco, ustdom, champ, flux, defsolver, hcoef, hTfluid)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use MENU_BOCO
use USTMESH
use DEFFIELD 

implicit none

! -- Declaration des entr�es --
type(st_ustboco) :: ustboco          ! lieu d'application des conditions aux limites
type(st_ustmesh) :: ustdom           ! maillage non structur�
real(krp), dimension(ustboco%nface) &
                 :: hcoef            ! coefficient de convection
real(krp), dimension(ustboco%nface) &
                 :: hTfluid          ! temp�rature de convection
type(mnu_solver) :: defsolver        ! type d'�quation � r�soudre

! -- Declaration des sorties --
type(st_field)   :: champ            ! champ des �tats
real(krp), dimension(ustboco%nface) &
                 :: flux             ! flux

! -- Declaration des variables internes --
integer          :: ifb, if, ip      ! index de liste, index de face limite et param�tres
integer          :: ic, ighost    ! index de cellule int�rieure, et de cellule fictive
type(v3d)        :: cgface, cg, normale ! centre de face, de cellule, normale face
real(krp)        :: d             ! distance cellule - face limite
real(krp)        :: conduct       ! conductivit�

! -- Debut de la procedure --

do ifb = 1, ustboco%nface
  if     = ustboco%iface(ifb)
  ic     = ustdom%facecell%fils(if,1)
  ighost = ustdom%facecell%fils(if,2)

  ! Calcul "distance pond�r�e" centre de cellule - centre face
  cgface = ustdom%mesh%iface(if,1,1)%centre
  cg     = ustdom%mesh%centre(ic,1,1)
  normale= ustdom%mesh%iface(if,1,1)%normale
  d    = (cgface - cg) .scal. (cgface - cg) / (abs((cgface - cg).scal.normale))

  ! Calcul conductivit�
  conduct = valeur_loi(defsolver%defkdif%materiau%Kd, champ%etatprim%tabscal(1)%scal(ic))

  ! Calcul approch� de la temp�rature du point fictif pour calcul des gradients
  do ip = 1, champ%nscal
    champ%etatprim%tabscal(ip)%scal(ighost) = ( (conduct/d) * champ%etatprim%tabscal(ip)%scal(ic) + hcoef(ifb)*hTfluid(ifb) ) / (conduct/d+hcoef(ifb))
  enddo

  ! Calcul du flux
  flux(ifb) = hcoef(ifb)*(champ%etatprim%tabscal(1)%scal(ighost) - hTfluid(ifb))

enddo

endsubroutine setboco_kdif_hconv_nunif

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juin 2004             : cr�ation de la proc�dure
!------------------------------------------------------------------------------!

