!------------------------------------------------------------------------------!
! MODULE : USTMESH                        Auteur : J. Gressier
!                                         Date   : Octobre 2002
! Fonction                                Modif  : (cf historique)
!   Bibliotheque de procedures et fonctions pour la gestion de maillages
!   non structur�s
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module USTMESH

use TYPHMAKE      ! Definition de la precision
use GEO3D 
use MESHBASE      ! Librairie pour les �l�ments g�om�triques de base
use CONNECTIVITY  ! Librairie de gestion de listes et connectivit�s
use DEFFIELD

implicit none

! -- Variables globales du module -------------------------------------------


! -- DECLARATIONS -----------------------------------------------------------


!------------------------------------------------------------------------------!
! structure ST_CELLVTEX : D�finition de connectivit� CELL -> VERTEX
!   une connectivit� sp�ciale est d�finie pour une meilleure gestions des
!   actions selon le type des �l�ments.
!------------------------------------------------------------------------------!
type st_cellvtex
  integer          :: dim                      ! dimension spatiale des �l�ments (2D/3D)
  integer          :: nbar, ntri, nquad, &     ! nombre d'�l�ments par famille
                      ntetra, npyra, npenta, nhexa  
  type(st_connect) :: bar, tri, quad,    &     ! d�finition des �l�ments
                      tetra, pyra, penta, hexa
  integer, dimension(:), pointer &
                   :: ibar, itri, iquad, &     ! redirection d'index vers "icell" de ustmesh
                      itetra, ipyra, ipenta, ihexa 
endtype st_cellvtex


!------------------------------------------------------------------------------!
! D�finition de la structure ST_USTBOCO : D�finition des conditions aux limites
!------------------------------------------------------------------------------!
type st_ustboco
  character(len=strlen)          :: family     ! nom de famille
  integer                        :: idefboco   ! pointeur index vers la d�finition 
                                               ! des conditions aux limites dans defsolver
  integer                        :: nface      ! nombre de faces concern�es
  integer, dimension(:), pointer :: iface      ! liste des faces concern�es par
                                               ! les conditions aux limites
  type(st_genericfield), pointer &
                         :: bocofield          ! liste cha�n�e de champs g�n�riques

  !! type(st_solvboco), pointer    :: boco      ! condition aux limites associ�e
  !! type(st_strboco),  pointer :: next       ! (liste) condition suivante
endtype st_ustboco


!------------------------------------------------------------------------------!
! D�finition de la structure ST_USTMESH : Maillage non structur�
!------------------------------------------------------------------------------!
! les tableaux de faces et de cellules contiennent les �l�ments internes puis
! les �l�ments limites.

type st_ustmesh
  integer               :: id              ! numero de domaine
  !integer              :: level           ! niveau multigrille
  !integer               :: nbdim           ! nombre de dimension du maillage
  integer               :: nvtex, nface, ncell   ! nombre de sommets, faces et cellules
  integer               :: nface_int, ncell_int  ! nombre de faces et cellules internes
  integer               :: nface_lim, ncell_lim  ! nombre de faces et cellules limites
  type(st_mesh)         :: mesh            ! maillage associ� (g�om�trie)
  type(st_connect)      :: facevtex, &     ! connectivit� face   -> sommets   par type
                           facecell        ! connectivit� face   -> cellules  par type
                                           ! SUPPOSED TO INDEX LOWER INDEX CELL BEFORE
  type(st_cellvtex)     :: cellvtex        ! connectivit� cellule-> vtex      par type
  integer               :: nboco          ! nombre de conditions aux limites
  type(st_ustboco), dimension(:), pointer &
                        :: boco           ! liste des conditions aux limites
endtype st_ustmesh



! -- INTERFACES -------------------------------------------------------------

interface new
  module procedure new_ustmesh, new_cellvtex, new_ustboco
endinterface

interface init
  module procedure init_cellvtex
endinterface

interface delete
  module procedure delete_ustmesh, delete_cellvtex, delete_ustboco
endinterface


! -- Fonctions et Operateurs ------------------------------------------------



! -- IMPLEMENTATION ---------------------------------------------------------
contains


!------------------------------------------------------------------------------!
! Proc�dure : allocation d'une structure USTMESH
!------------------------------------------------------------------------------!
subroutine new_ustmesh(mesh, ncell, nface, nvtex)
implicit none
type(st_ustmesh) :: mesh
integer       :: ncell, nface, nvtex

  print*,"!!! pas d'allocation dans new_ustmesh !!!"
  stop
  !mesh%idim = idim
  !mesh%jdim = jdim
  !mesh%kdim = kdim
  !if (kdim /= 1) then ! CAS 3D
  !  allocate(mesh%center(0:idim+1, 0:jdim+1, 0:kdim+1))
  !  allocate(mesh%vertex(1:idim+1, 1:jdim+1, 1:kdim+1))
  !  allocate(mesh% iface(1:idim+1, 1:jdim,   1:kdim))
  !  allocate(mesh% jface(1:idim,   1:jdim+1, 1:kdim))
  !  allocate(mesh% kface(1:idim,   1:jdim,   1:kdim+1))
  !  allocate(mesh%volume(1:idim,   1:jdim,   1:kdim))
  !else                ! CAS 2D
  !  allocate(mesh%center(0:idim+1, 0:jdim+1, 1))
  !  allocate(mesh%vertex(1:idim+1, 1:jdim+1, 1))
  !  allocate(mesh% iface(1:idim+1, 1:jdim,   1))
  !  allocate(mesh% jface(1:idim,   1:jdim+1, 1))
  !  nullify(mesh%kface)
  !  allocate(mesh%volume(1:idim,   1:jdim,   1))
  !endif
  !nullify(mesh%facevtex)
  !nullify(mesh%cellvtex)
  !nullify(mesh%facecell)
  !nullify(mesh%cellface)

endsubroutine new_ustmesh


!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure USTMESH
!------------------------------------------------------------------------------!
subroutine delete_ustmesh(mesh)
implicit none
type(st_ustmesh) :: mesh
integer          :: i

  call delete(mesh%mesh)
  call delete(mesh%facevtex)
  call delete(mesh%facecell)
  call delete(mesh%cellvtex)
  do i = 1, mesh%nboco 
    call delete(mesh%boco(i))
  enddo
  deallocate(mesh%boco)
  !deallocate(mesh%center, mesh%vertex, mesh%volume)
  !deallocate(mesh%iface, mesh%jface)
  !if (mesh%kdim /= 1) deallocate(mesh%kface)

endsubroutine delete_ustmesh


!------------------------------------------------------------------------------!
! Proc�dure : cr�ation d'une structure BOCO dans USTMESH
!------------------------------------------------------------------------------!
subroutine createboco(mesh, nboco)
implicit none
type(st_ustmesh) :: mesh
integer          :: nboco

  mesh%nboco = nboco
  allocate(mesh%boco(nboco))

endsubroutine createboco


!------------------------------------------------------------------------------!
! Proc�dure : recherche d'une condition limite dans USTMESH
!------------------------------------------------------------------------------!
function pboco_ustmesh(umesh, name) result(pboco)
implicit none
type(st_ustboco), pointer :: pboco
type(st_ustmesh)          :: umesh
character(len=strlen)     :: name
! -- variables internes --
integer :: i, info

  info = 0
  do i = 1, umesh%nboco
    if (samestring(umesh%boco(i)%family, name)) then
      info  =  info + 1
      pboco => umesh%boco(i)
    endif
  enddo
  if (info /= 1) call erreur("structure","plusieurs noms de conditions limites identiques")
  
endfunction pboco_ustmesh


!------------------------------------------------------------------------------!
! Proc�dure : allocation d'une structure USTBOCO
!------------------------------------------------------------------------------!
subroutine new_ustboco(bc, nom, n)
implicit none
type(st_ustboco)      :: bc
character(len=strlen) :: nom
integer               :: n

  bc%family = nom
  bc%nface  = n
  allocate(bc%iface(n))

endsubroutine new_ustboco


!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure USTBOCO
!------------------------------------------------------------------------------!
subroutine delete_ustboco(bc)
implicit none
type(st_ustboco) :: bc
integer          :: i

  deallocate(bc%iface)

endsubroutine delete_ustboco


!------------------------------------------------------------------------------!
! Proc�dure : allocation des tableaux d'une structure CELLVTEX
!------------------------------------------------------------------------------!
subroutine new_cellvtex(conn)
implicit none
type(st_cellvtex) :: conn

  if (conn%nbar   /= 0) then
    call new(conn%bar, conn%nbar, 2)
    allocate(conn%ibar(conn%nbar))
  endif
  if (conn%ntri   /= 0) then
    call new(conn%tri, conn%ntri, 3)
    allocate(conn%itri(conn%ntri))
  endif
  if (conn%nquad  /= 0) then
    call new(conn%quad, conn%nquad, 4)
    allocate(conn%iquad(conn%nquad))
  endif
  if (conn%ntetra /= 0) then
    call new(conn%tetra, conn%ntetra, 4)
    allocate(conn%itetra(conn%ntetra))
  endif
  if (conn%npyra  /= 0) then
    call new(conn%pyra, conn%npyra, 5)
    allocate(conn%ipyra(conn%npyra))
  endif
  if (conn%npenta /= 0) then
    call new(conn%penta, conn%npenta, 6)
    allocate(conn%ipenta(conn%npenta))
  endif
  if (conn%nhexa  /= 0) then
    call new(conn%hexa, conn%nhexa, 8)
    allocate(conn%ihexa(conn%nhexa))
  endif

endsubroutine new_cellvtex


!------------------------------------------------------------------------------!
! Proc�dure : Intialisation des tableaux d'une structure CELLVTEX
!------------------------------------------------------------------------------!
subroutine init_cellvtex(conn)
implicit none
type(st_cellvtex) :: conn

  conn%nbar   = 0
  conn%ntri   = 0
  conn%nquad  = 0
  conn%ntetra = 0
  conn%npyra  = 0
  conn%npenta = 0
  conn%nhexa  = 0

endsubroutine init_cellvtex


!------------------------------------------------------------------------------!
! Proc�dure :desallocation d'une structure CELLVTEX
!------------------------------------------------------------------------------!
subroutine delete_cellvtex(conn)
implicit none
type(st_cellvtex) :: conn

  if (conn%nbar   /= 0) then
    call delete(conn%bar)
    deallocate(conn%ibar)
  endif
  if (conn%ntri   /= 0) then
    call delete(conn%tri)
    deallocate(conn%itri)
  endif
  if (conn%nquad  /= 0) then
    call delete(conn%quad)
    deallocate(conn%iquad)
  endif
  if (conn%ntetra /= 0) then
    call delete(conn%tetra)
    deallocate(conn%itetra)
  endif
  if (conn%npyra  /= 0) then
    call delete(conn%pyra)
    deallocate(conn%ipyra)
  endif
  if (conn%npenta /= 0) then
    call delete(conn%penta)
    deallocate(conn%ipenta)
  endif
  if (conn%nhexa  /= 0) then
    call delete(conn%hexa)
    deallocate(conn%ihexa)
  endif

endsubroutine delete_cellvtex


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

endfunction face_invtexlist


!------------------------------------------------------------------------------!
! Fonction : typgeo : type de g�om�trie du maillage
!------------------------------------------------------------------------------!
character function typgeo(umesh)
implicit none
type(st_ustmesh) :: umesh

  typgeo = umesh%mesh%info%geom

endfunction typgeo


endmodule USTMESH

!------------------------------------------------------------------------------!
! Historique des modifications
!
! oct  2002 : cr�ation du module
! juil 2003 : suppression des structures USTCONNECT, d�finition dans CONNECTIVITY
!             cr�ation d'une structure de connectivit� CELLVTEX
!------------------------------------------------------------------------------!



