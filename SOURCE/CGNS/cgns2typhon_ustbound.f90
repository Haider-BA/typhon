!------------------------------------------------------------------------------!
! Procedure : cgns2typhon_ustboco.f90    Auteur : J. Gressier
!                                         Date   : F�vrier 2003
! Fonction                                Modif  :
!   Cr�ation des conditions aux limites par conversion CGNS->TYPHON
!   Test de coh�rence entre les faces CGNS et les faces cr��es dans TYPHON
!
! Defauts/Limitations/Divers :
!   ATTENTION : les faces sont suppos�es ordonn�es (faces limites en fin de tab)
!
!------------------------------------------------------------------------------!
subroutine cgns2typhon_ustboco(cgnszone, mesh) 

use TYPHMAKE      ! d�finitions g�n�rales 
use CGNS_STRUCT   ! D�finition des structures CGNS
use USTMESH       ! D�finition des structures maillage non structur�
use OUTPUT        ! Sorties standard TYPHON

implicit none 

! -- Entr�es --
type(st_cgns_zone)  :: cgnszone        ! zone CGNS contenant conditions aux limites

! -- Entr�es/Sorties --
type(st_ustmesh)    :: mesh            ! connectivit�s et conditions aux limites

! -- Variables internes --
integer, dimension(:), allocatable &
                    :: listface        ! liste provisoire de faces
integer             :: nface_int       ! nombre de faces internes
integer             :: nface_lim       ! nombre de faces limites
integer             :: ib, if, nf

! -- D�but de proc�dure

! -- Cr�ation des conditions aux limites --

allocate(listface(mesh%nface_lim))   ! allocation provisoire avec marges
mesh%nboco = cgnszone%nboco         
allocate(mesh%boco(mesh%nboco))    ! allocation des conditions aux limites TYPHON

do ib = 1, cgnszone%nboco

  call print_info(8,"  . traitement des conditions aux limites : "//trim(cgnszone%boco(ib)%family))
  nf = 0  
  !print*,"!! DEBUG liste",cgnszone%boco(ib)%nvtex,"sommets boco :",cgnszone%boco(ib)%ivtex
  ! recherche des faces limites concern�es
  do if = mesh%nface_int+1, mesh%nface_int+mesh%nface_lim
    !print*,"!!     DEBUG face (",mesh%facevtex%fils(if,:),")"
    if (face_invtexlist(mesh%facevtex%nbfils, mesh%facevtex%fils(if,:), &
                        cgnszone%boco(ib)%nvtex, cgnszone%boco(ib)%ivtex)) then
      nf = nf + 1
      listface(nf) = if
      !print*,"!! DEBUG affection face n�:",nf,"de face",if,": (",mesh%facevtex%fils(if,:),")"
    endif
  enddo

  allocate(mesh%boco(ib)%iface(nf))
  mesh%boco(ib)%nface       = nf
  mesh%boco(ib)%iface(1:nf) = listface(1:nf)
  mesh%boco(ib)%family      = cgnszone%boco(ib)%family
  
enddo

! -- V�rification du nombre total de faces limites affect�es aux conditions aux limites
nf = 0
do ib = 1, cgnszone%nboco
  nf = nf + mesh%boco(ib)%nface
enddo
!print*,"!! DEBUG faces :",nf, " ?= ", mesh%nface_lim
if (nf /= mesh%nface_lim) call erreur("Conditions aux limites",&
  "le nombre de faces affect�es et existantes ne correspondent pas")

! desallocation
deallocate(listface)


!-------------------------
contains ! SOUS-PROCEDURES


  !------------------------------------------------------------------------------!
  ! Fonction : face_invtexlist
  ! Teste la face est incluse (selon ses sommets) dans une liste de sommets
  !------------------------------------------------------------------------------!
  logical function face_invtexlist(nsf, face, nsl, vtexlist)
  implicit none
  ! -- Entr�es --
  integer                   :: nsf, nsl         ! nombre de sommets de la face et de la liste
  integer, dimension(1:nsf) :: face             ! face � rechercher
  integer, dimension(1:nsl) :: vtexlist         ! liste des sommets
  ! -- Variables internes --
  integer :: isf, isl
  logical :: same_som

  ! -- D�but de proc�dure
   
  do isf = 1, nsf   ! boucle sur les sommets de la face
    ! recherche sommet par sommet de FACE dans VTEXLIST

    do isl = 1, nsl
      same_som = (face(isf)==vtexlist(isl)).or.(face(isf)==0)   ! la face peut etre d�finie avec des 0
      if (same_som) exit    ! le sommet a �t� trouv� : on passe au suivant (de la face)
    enddo

    if (.not.same_som) exit   ! un sommet non trouv� de la face suffit � quitter
  enddo

  face_invtexlist = same_som

  !-------------------------
  endfunction face_invtexlist


!-------------------------
endsubroutine cgns2typhon_ustboco

!------------------------------------------------------------------------------!
! Historique des modifications
!
! fev 2003 (v0.0.1b): cr�ation de la proc�dure
!------------------------------------------------------------------------------!



