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

implicit none

! -- Variables globales du module -------------------------------------------


! -- DECLARATIONS -----------------------------------------------------------


!------------------------------------------------------------------------------!
! D�finition de la structure ST_USTBOUND : D�finition des conditions aux limites
!------------------------------------------------------------------------------!
type st_ustboco
  character(len=strlen)          :: family     ! nom de famille
  integer                        :: idefboco   ! pointeur index vers la d�finition 
                                               ! des conditions aux limites dans defsolver
  integer                        :: nface      ! nombre de faces concern�es
  integer, dimension(:), pointer :: iface      ! liste des faces concern�es par
                                               ! les conditions aux limites

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
  integer               :: nbdim           ! nombre de dimension du maillage
  integer               :: nvtex, nface, ncell   ! nombre de sommets, faces et cellules
  integer               :: nface_int, ncell_int  ! nombre de faces et cellules internes
  integer               :: nface_lim, ncell_lim  ! nombre de faces et cellules limites
  type(st_mesh)         :: mesh            ! maillage associ� (g�om�trie)
!! type(st_connect), pointer &           ! tableau par type d'�lements (nbfils)
  type(st_connect)      :: facevtex, &     ! connectivit� face   -> sommets   par type
      !! non utilis�       cellface, &     ! connectivit� cellule-> faces     par type
      !! non utilis�       cellvtex, &     ! connectivit� cellule-> vtex      par type
                           facecell        ! connectivit� face   -> cellules  par type
  integer               :: nboco          ! nombre de conditions aux limites
  type(st_ustboco), dimension(:), pointer &
                        :: boco           ! liste des conditions aux limites
endtype st_ustmesh


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
endtype st_cellvtex



! -- INTERFACES -------------------------------------------------------------

interface new
  module procedure new_ustmesh
endinterface

interface delete
  module procedure delete_ustmesh, delete_cellvtex
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

  call delete(mesh%mesh)
  !deallocate(mesh%center, mesh%vertex, mesh%volume)
  !deallocate(mesh%iface, mesh%jface)
  !if (mesh%kdim /= 1) deallocate(mesh%kface)

endsubroutine delete_ustmesh


!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure CELLVTEX
!------------------------------------------------------------------------------!
subroutine delete_cellvtex(conn)
implicit none
type(st_cellvtex) :: conn

  if (conn%nbar   /= 0) call delete(conn%bar)
  if (conn%ntri   /= 0) call delete(conn%tri)
  if (conn%nquad  /= 0) call delete(conn%quad)
  if (conn%ntetra /= 0) call delete(conn%tetra)
  if (conn%npyra  /= 0) call delete(conn%pyra)
  if (conn%npenta /= 0) call delete(conn%penta)
  if (conn%nhexa  /= 0) call delete(conn%hexa)

endsubroutine delete_cellvtex




endmodule USTMESH

!------------------------------------------------------------------------------!
! Historique des modifications
!
! oct  2002 : cr�ation du module
! juil 2003 : suppression des structures USTCONNECT, d�finition dans CONNECTIVITY
!             cr�ation d'une structure de connectivit� CELLVTEX
!------------------------------------------------------------------------------!



