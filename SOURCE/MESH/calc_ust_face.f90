!------------------------------------------------------------------------------!
! Procedure : calc_ust_face               Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : see history
!   Calcul des faces
!   . barycentre de la face (ou centre de gravit�)  (cgface)
!   . normale (sens arbitraire) de la face  
!   . surface de la face
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine calc_ust_face(facevtex, mesh, cgface)

use TYPHMAKE
use OUTPUT
use USTMESH
use MESHBASE
use GEO3D

implicit none

! -- Declaration des entr�es --
type(st_connect)      :: facevtex

! -- Declaration des entr�es/sorties --
type(st_mesh)            :: mesh      ! entr�es:vertex / sorties:iface

! -- Declaration des sorties --
!type(v3d), dimension(1:facevtex%nbnodes) :: cgface
type(v3d), dimension(*) :: cgface

! -- Declaration des variables internes --
type(v3d), dimension(:), allocatable &
               :: vtex           ! sommets interm�diaires
integer        :: nface          ! nombre de faces (connectivit� et tableau)
integer        :: ns             ! nombre de sommet de la face (iface)
integer        :: if, is         ! index de face, index de sommet
real(krp)      :: surf, s1, s2   ! surfaces interm�diaires
type(v3d)      :: norm           ! normale interm�diaire
type(v3d)      :: pt, cg1, cg2   ! point et CG interm�diaires

! -- Debut de la procedure --

!print*,"debug",facevtex%nbnodes
nface = facevtex%nbnodes          ! nombre de faces dans la connectivit�
allocate(vtex(facevtex%nbfils))   ! nombre maximal de sommets par face

! A ce stage, on peut choisir de calculer les faces comme les volumes avec
! des d�composition en faces �l�mentaires. Cela permet de calculer des
! surfaces de faces � nombre de sommets quelconque.
! Dans un premier temps, on se contente d'appliquer une m�thode sp�cifique
! pour chaque type de face.

do if = 1, nface

  ! calcul du nombre de sommet de la face
  ns = 2
  do while ((ns <= facevtex%nbfils).and.(facevtex%fils(if,ns) /= 0))
    ns = ns + 1
  enddo
  ns = ns - 1  ! le dernier sommet ne satisfait pas les conditions

  ! affectation des sommets
  do is = 1, ns
    vtex(is) = mesh%vertex(facevtex%fils(if,is),1,1)
  enddo

  ! calcul selon le nombre de sommets de la face

  select case(ns)

  case(2)
    norm = v3d(0.,0.,1.) .vect. (vtex(2)-vtex(1))
    surf = abs(norm)
    mesh%iface(if,1,1)%normale = norm / surf
    mesh%iface(if,1,1)%surface = surf
    cgface(if) = .5*(vtex(1) + vtex(2))

  case(3)
    norm = .5 * ( (vtex(2)-vtex(1)) .vect. (vtex(3)-vtex(1)) )
    surf = abs(norm)
    mesh%iface(if,1,1)%normale = norm / surf
    mesh%iface(if,1,1)%surface = surf
    cgface(if) = (vtex(1) + vtex(2) + vtex(3)) / 3._krp

  case(4)
    ! calcul du premier triangle �l�mentaire
    norm = .5 * ( (vtex(2)-vtex(1)) .vect. (vtex(3)-vtex(1)) )
    s1   = abs(norm)
    cg1  = (vtex(1) + vtex(2) + vtex(3)) / 3._krp
    ! calcul du second triangle �l�mentaire
    pt   = .5 * ( (vtex(3)-vtex(1)) .vect. (vtex(4)-vtex(1)) )
    s2   = abs(pt) 
    cg2  = (vtex(1) + vtex(3) + vtex(4)) / 3._krp
    ! calcul des normales et surfaces
    norm = norm + pt
    surf = abs(norm)
    mesh%iface(if,1,1)%normale = norm / surf
    mesh%iface(if,1,1)%surface = surf
    cgface(if) = (s1*cg1 + s2*cg2)/(s1+s2)

  case default
    call erreur("D�veloppement","Trop de sommets pour le calcul de face")
  endselect

  mesh%iface(if,1,1)%centre = cgface(if)

enddo

deallocate(vtex)

endsubroutine calc_ust_face
!------------------------------------------------------------------------------!
! Change history
!
! nov  2002 : creation
! july 2004 : bug correction (computation of QUAD face center)
!------------------------------------------------------------------------------!
