!------------------------------------------------------------------------------!
! Procedure : calcboco_ust_sym            Auteur : J. Gressier
!                                         Date   : July 2004
! Fonction                                Modif  : (see history)
!   Boundary condition calculation (local symmetry)
!
! Defauts/Limitations/Divers :
!   ATTENTION : le calcul des conditions aux limites doit se faire sur les
!     variables primitives
!
!------------------------------------------------------------------------------!
subroutine calcboco_ust_sym(defboco, ustboco, umesh, champ)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_BOCO
use USTMESH
use DEFFIELD

implicit none

! -- Declaration des entrees --
type(mnu_boco)   :: defboco          ! parametres de conditions aux limites
type(st_ustboco) :: ustboco          ! lieu d'application des conditions aux limites
type(st_ustmesh) :: umesh            ! unstructured mesh

! -- Declaration des sorties --
type(st_field)   :: champ            ! champ des etats

! -- Declaration des variables internes --
integer    :: ifb, if, ip      ! index de liste, index de face limite, et parametre
integer    :: icell, ighost    ! index de cellule interieure, et de cellule fictive
type(v3d)  :: fn, dfc, dgc, vc
real(krp)  :: rap 

! -- Debut de la procedure --

do ifb = 1, ustboco%nface
  if     = ustboco%iface(ifb)
  icell  = umesh%facecell%fils(if,1)
  ighost = umesh%facecell%fils(if,2)
  do ip = 1, champ%nscal
    champ%etatprim%tabscal(ip)%scal(ighost) = champ%etatprim%tabscal(ip)%scal(icell) 
  enddo
  fn  = umesh%mesh%iface(if,1,1)%normale                               ! normale face
  dfc = umesh%mesh%iface(if,1,1)%centre - umesh%mesh%centre(icell,1,1) ! dist ctr. face - cell
  dgc = umesh%mesh%centre(ighost,1,1)   - umesh%mesh%centre(icell,1,1) ! dist ghostcell - cell
  rap = (dgc.scal.fn)/(dfc.scal.fn)
  do ip = 1, champ%nvect
    vc = champ%etatprim%tabvect(ip)%vect(icell)
    champ%etatprim%tabvect(ip)%vect(ighost) = vc - (rap*(vc.scal.fn))*fn
  enddo
enddo

endsubroutine calcboco_ust_sym

!------------------------------------------------------------------------------!
! Changes history
!
! July 2004 : creation
!------------------------------------------------------------------------------!
