!------------------------------------------------------------------------------!
! Procedure : create_facevtex.f90 
!                                 
! Fonction
!   Creation des faces a partir de la connectivite CELLULES->SOMMETS (CGNS)
!   et du type de cellules (cf documentation CGNS)
!   Creation de la connectivite FACES -> CELLULES
!   Creation de la connectivite FACES -> SOMMETS (avec test de redondance)
!
! Defauts/Limitations/Divers :
!   On calcule une connectivite intermediaire (sommet->faces) pour gagner en
! temps de calcul lors du test des redondances de faces.
!
!------------------------------------------------------------------------------!
subroutine create_facevtex(facetag, nvtex, cellvtex, face_cell, face_vtex, Ltag, Rtag) 

use IOCFD
use USTMESH       ! Definition des structures maillage non structure

implicit none 

! -- INPUTS --
logical, intent(in)   :: facetag         ! must handle face TAGs or not
integer               :: nvtex           ! nombre total de sommets
type(st_genelemvtex)  :: cellvtex        ! 

! -- OUTPUTS --
type(st_connect)      :: face_cell, &    ! conn. Typhon       : face -> cellules
                         face_vtex, &    ! conn. Typhon       : face -> sommets
                         Ltag, Rtag      ! left and right tag (face index in cell)

! -- Internal variables --
integer, parameter    :: nmax_face = 100 ! nb max de face dans la connectivite vtex->face
                                         ! (moyenne de 30 pour des TETRA)
type(st_connect)      :: vtex_face       ! connectivite intermediaire sommets -> faces
integer               :: i, j, ic, icell ! indices de boucles
integer, dimension(:), allocatable &
                      :: face, element   ! face, element intermediaires
integer, dimension(:), allocatable &
                      :: nface           ! number of faces which share this vertex

integer               :: ns, isect       ! nombre de sommets de la face courante, index de section
integer               :: iprop, maxdim

! -- BODY --

!-------------------------------------------
! initialization

if (facetag) then
  iprop = 1
else
  iprop = 0
endif

maxdim = 0
do isect = 1, cellvtex%nsection
  maxdim = max(maxdim, dim_element(cellvtex%elem(isect)%elemtype))
enddo

! allocation de la connectivite intermediaire VTEX -> FACE 
! utile pour la recherche optimale de face existante

call new_connect(vtex_face, nvtex, nmax_face)
vtex_face%fils(:,:) = 0                    ! initialization

allocate(nface(nvtex))                     ! number of faces shared by a vertex
nface(:) = 0

! allocation de structures de travail

allocate(face(face_vtex%nbfils))      ! allocation d'une face au nb max de sommets
   
!-------------------------------------------
! BOUCLE sur les SECTIONS

do isect = 1, cellvtex%nsection          ! loop on element section

  if (dim_element(cellvtex%elem(isect)%elemtype) /= maxdim) cycle

  allocate(element(cellvtex%elem(isect)%nvtex))   ! allocation of one element

  ! --- creation des faces selon le type

  select case(cellvtex%elem(isect)%elemtype)

  case(elem_BAR2)  ! skipping BAR element


  case(elem_TRI3)  ! trois faces (cotes) pour chacune deux sommets

    call cfd_print("  . creating faces of TRI3")

    do ic = 1, cellvtex%elem(isect)%nelem
      icell   = cellvtex%elem(isect)%ielem(ic) 
      element = cellvtex%elem(isect)%elemvtex(ic,:) 
      ns = 2              ! nombre de sommets par face (BAR_2)
      ! FACE 1 : BAR_2
      face(1:ns) = (/ element(1), element(2) /)
      call ust_create_face(ns, icell, face, iprop*3, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 2 : BAR_2
      face(1:ns) = (/ element(2), element(3) /)
      call ust_create_face(ns, icell, face, iprop*1, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 3 : BAR_2
      face(1:ns) = (/ element(3), element(1) /)
      call ust_create_face(ns, icell, face, iprop*2, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
    enddo

  case(elem_QUAD4) ! quatre faces (cotes) pour chacune deux sommets

    call cfd_print("  . creating faces of QUAD4")

    do ic = 1, cellvtex%elem(isect)%nelem
      icell   = cellvtex%elem(isect)%ielem(ic) 
      element = cellvtex%elem(isect)%elemvtex(ic,:) 
      ns = 2            ! nombre de sommets par face (BAR_2)
      ! FACE 1 : BAR_2
      face(1:ns) = (/ element(1), element(2) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 2 : BAR_2
      face(1:ns) = (/ element(2), element(3) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 3 : BAR_2
      face(1:ns) = (/ element(3), element(4) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 4 : BAR_2
      face(1:ns) = (/ element(4), element(1) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
    enddo

  case(elem_TETRA4) ! quatre faces (triangles) pour chacune trois sommets

    call cfd_print("  . creating faces of TETRA4")

    do ic = 1, cellvtex%elem(isect)%nelem
      icell   = cellvtex%elem(isect)%ielem(ic) 
      element = cellvtex%elem(isect)%elemvtex(ic,:) 
      ns = 3            ! nombre de sommets par face (TRI_3)
      ! FACE 1 : TRI_3
      face(1:ns) = (/ element(1), element(3), element(2) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 2 : TRI_3
      face(1:ns) = (/ element(1), element(2), element(4) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 3 : TRI_3
      face(1:ns) = (/ element(2), element(3), element(4) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 4 : TRI_3
      face(1:ns) = (/ element(3), element(1), element(4) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
    enddo

  case(elem_PYRA5) ! 1 quadrangle (4 sommets) et 4 triangles par element PYRA
    call cfd_error("Development: Pyramid elements are not yet implemented")
    ! CF PDF : CGNS SIDS pages 21-23

  case(elem_PENTA6) ! 3 quadrangles (4 sommets) et 2 triangles par element PENTA

    call cfd_print("  . creating faces of PENTA6")

    do ic = 1, cellvtex%elem(isect)%nelem
      icell   = cellvtex%elem(isect)%ielem(ic) 
      element = cellvtex%elem(isect)%elemvtex(ic,:) 
      ns = 3            ! nombre de sommets par face (TRI_3)
      ! FACE 1 : TRI_3
      face(1:ns) = (/ element(1), element(2), element(3) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 2 : TRI_3
      face(1:ns) = (/ element(4), element(5), element(6) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)

      ns = 4            ! nombre de sommets par face (QUAD_3)
      ! FACE 3 : QUAD_4
      face(1:ns) = (/ element(1), element(3), element(6), element(4) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 4 : QUAD_4
      face(1:ns) = (/ element(1), element(2), element(5), element(4) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 5 : QUAD_4
      face(1:ns) = (/ element(2), element(3), element(6), element(5) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
    enddo
    ! CF PDF : CGNS SIDS pages 21-23

  case(elem_HEXA8) ! 6 quadrangles (4 sommets)

    call cfd_print("  . creating faces of HEXA8")

    do ic = 1, cellvtex%elem(isect)%nelem
      icell   = cellvtex%elem(isect)%ielem(ic) 
      element = cellvtex%elem(isect)%elemvtex(ic,:) 
      ns = 4            ! nombre de sommets par face (QUAD_4)
      ! FACE 1 : QUAD_4
      face(1:ns) = (/ element(1), element(2), element(3), element(4) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 2 : QUAD_4
      face(1:ns) = (/ element(1), element(2), element(6), element(5) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 3 : QUAD_4
      face(1:ns) = (/ element(5), element(6), element(7), element(8) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 4 : QUAD_4
      face(1:ns) = (/ element(4), element(3), element(7), element(8) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 5 : QUAD_4
      face(1:ns) = (/ element(1), element(4), element(8), element(5) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
      ! FACE 6 : QUAD_4
      face(1:ns) = (/ element(2), element(3), element(7), element(6) /)
      call ust_create_face(ns, icell, face, 0, face_vtex, face_cell, Ltag, Rtag, vtex_face, nface)
    enddo
    ! CF PDF : CGNS SIDS pages 21-23

  case default
    call cfd_error("Development: unexpected type of element")
  endselect

  !print*,'moyenne des connections:',sum(vtex_face%nface(1:nvtex))/real(nvtex,krp)

  deallocate(element)

  ! -- FIN de boucle sur les sections
enddo

! --- desallocation ---

deallocate(face, nface)
call delete(vtex_face)


!-------------------------
endsubroutine create_facevtex
!------------------------------------------------------------------------------!
! Changes History
!
! nov  2002 : creation de la procedure
! juin 2004 : ajout de construction de PRISM (PENTA_6) et HEXA
!             connectivite vtex->face commune a toutes les familles volumiques
! July 2007: transfer sub-routines to USTMESH module
! Oct  2007: add face property to Ltag or Rtag
! Dec  2010: TYPHON(createface_fromcgns)->CFDTOOLS(create_facevtex)
!            use USTMESH "elemvtex" connectivity 
!------------------------------------------------------------------------------!
