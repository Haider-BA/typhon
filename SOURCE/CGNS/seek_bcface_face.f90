!------------------------------------------------------------------------------!
! Procedure : seek_bcface_face.f90        Auteur : J. Gressier
!                                         Date   : Juin 2004
! Fonction                                Modif  : (cf historique)
!   Recherche des faces � partir des listes de FACES marqu�es
!
! Defauts/Limitations/Divers :
!   On passe par la reconstruction d'une liste de VERTEX marqu�s et on
!   utilise seek_bcface_vtex
!
!------------------------------------------------------------------------------!
subroutine seek_bcface_face(ib, cgnsboco, nfam, facevtex, mesh, listface) 

use TYPHMAKE      ! d�finitions g�n�rales 
use CONNECTIVITY
use CGNS_STRUCT   ! D�finition des structures CGNS
use USTMESH       ! D�finition des structures maillage non structur�
use OUTPUT        ! Sorties standard TYPHON

implicit none 

! -- Entr�es --
integer             :: ib             ! indice de condition limite
integer             :: nfam           ! nombre de connectivit� facevtex
type(st_cgns_boco)  :: cgnsboco       ! zone CGNS contenant conditions aux limites
type(st_cgns_ustconnect), dimension(1:nfam) &
                    :: facevtex

! -- Entr�es/Sorties --
type(st_ustmesh)    :: mesh            ! connectivit�s et conditions aux limites

! -- Variables internes --
integer, dimension(*) :: listface      ! tableau de travail
type(st_cgns_boco)    :: cgboco        ! connectivit� interm�diaire
logical, dimension(:), allocatable &
                      :: mkvtex        ! liste de vertex marqu�s
integer               :: iface, pface, ifam, pfam, iv, ivm, dim

! -- D�but de proc�dure

allocate(mkvtex(mesh%mesh%nvtex))    ! allocation du tableau des vertex marqu�s
mkvtex(:) = .false.                  ! initialisation � "non marqu�"

!print*,"DEBUG:",nfam

! -- marquage de sommets marqu�s par la liste de faces marqu�es --

do iface = 1, cgnsboco%list%nbfils  ! boucle sur la liste de faces marqu�es

  pface = cgnsboco%list%fils(iface)   ! index r�el de face
  pfam  = 0                           ! recherche de famille
  do ifam = 1, nfam
    if ((pface >= facevtex(ifam)%ideb).and.(pface <= facevtex(ifam)%ifin)) pfam = ifam
  enddo

  if (pfam == 0) call erreur("Calcul de connectivit�","face limite introuvable dans CGNS")

  ! on marque les sommets de la face trouv�e
  do iv = 1, facevtex(pfam)%nbfils
    mkvtex(facevtex(pfam)%fils(pface,iv)) = .true.
  enddo

enddo

! -- construction d'une connectivit� cgnsboco/vertex associ�e --

!dim = count(mkvtex==.true.)
dim = count(mkvtex)
cgboco%nom    = cgnsboco%nom
cgboco%family = cgnsboco%family
call new(cgboco%list, dim)

ivm = 0
do iv = 1, size(mkvtex)
  if (mkvtex(iv)) then
    ivm = ivm+1
    cgboco%list%fils(ivm) = iv
  endif
enddo

deallocate(mkvtex)

! -- contruction de la connectivit� boco/face de TYPHON � partir des sommets --

call seek_bcface_vtex(ib, cgboco, mesh, listface)

call delete(cgboco%list)

  
!-------------------------
endsubroutine seek_bcface_face

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juin 2004 : cr�ation de la proc�dure
!------------------------------------------------------------------------------!
