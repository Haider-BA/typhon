!------------------------------------------------------------------------------!
! Procedure : createface_fromcgns.f90     Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : (cf historique)
!   Cr�ation des faces � partir de la connectivit� CELLULES->SOMMETS (CGNS)
!   et du type de cellules (cf documentation CGNS)
!   Cr�ation de la connectivit� FACES -> CELLULES
!   Cr�ation de la connectivit� FACES -> SOMMETS (avec test de redondance)
!
! Defauts/Limitations/Divers :
!   On calcule une connectivit� interm�diaire (sommet->faces) pour gagner en
! temps de calcul lors du test des redondances de faces.
!
!------------------------------------------------------------------------------!
subroutine createface_fromcgns(nvtex, cgzone, face_cell, face_vtex) 

use CGNS_STRUCT   ! D�finition des structures CGNS
use USTMESH       ! D�finition des structures maillage non structur�
use OUTPUT        ! Sorties standard TYPHON

implicit none 

! -- Entr�es --
integer               :: nvtex           ! nombre total de sommets
type(st_cgns_zone)    :: cgzone          ! conn. CGNS         : cellule -> sommets

! -- Sorties --
type(st_connect)      :: face_cell, &    ! conn. Typhon       : face -> cellules
                         face_vtex       ! conn. Typhon       : face -> sommets

! -- type connectivit� locale sommets -> faces --
type stloc_vtex_face
  integer             :: nvtex           ! nombre de sommets (dim. de la connectivit�)
  integer, dimension(:,:), pointer &
                      :: vtex_face       ! connectivit� interm�diaire sommets -> faces
  integer, dimension(:), pointer &
                      :: nface           ! nombre de faces par sommet
endtype stloc_vtex_face

! -- Variables internes --
integer, parameter    :: nmax_face = 100 ! nb max de face dans la connectivit� vtex->face
                                         ! (moyenne de 30 pour des TETRA)
type(stloc_vtex_face) :: vtex_face       ! connectivit� interm�diaire sommets -> faces
integer               :: i, j, icell     ! indices de boucles
integer, dimension(:), allocatable &
                      :: face, element   ! face, �l�ment interm�diaires
integer               :: ns, isect       ! nombre de sommets de la face courante, index de section

! -- D�but de proc�dure

! allocation de la connectivit� interm�diaire VTEX -> FACE 
! utile pour la recherche optimale de face existante

vtex_face%nvtex = nvtex                         ! nombre total de sommets
allocate(vtex_face%vtex_face(nvtex, nmax_face)) ! allocation de la connectivit� interm�diaire
vtex_face%vtex_face(:,:) = 0                    !   sommet->faces
allocate(vtex_face%nface(nvtex))                ! allocation du nombre de faces par sommet
vtex_face%nface(:) = 0

! allocation de structures de travail

allocate(face(face_vtex%nbfils))      ! allocation d'une face au nb max de sommets
   
!-------------------------------------------
! BOUCLE sur les SECTIONS

do isect = 1, cgzone%ncellfam          ! boucle sur les sections de cellules

allocate(element(cgzone%cellfam(isect)%nbfils))   ! allocation d'un �l�ment

! --- cr�ation des faces selon le type

select case(cgzone%cellfam(isect)%type)

case(TRI_3)  ! trois faces (cot�s) pour chacune deux sommets

  call print_info(8,"    cr�ation des faces de TRI_3")

  do icell = cgzone%cellfam(isect)%ideb, cgzone%cellfam(isect)%ifin
    element = cgzone%cellfam(isect)%fils(icell,:) 
    ns = 2              ! nombre de sommets par face (BAR_2)
    ! FACE 1 : BAR_2
    face(1:ns) = (/ element(1), element(2) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 2 : BAR_2
    face(1:ns) = (/ element(2), element(3) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 3 : BAR_2
    face(1:ns) = (/ element(3), element(1) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
  enddo

case(QUAD_4) ! quatre faces (cot�s) pour chacune deux sommets

  call print_info(8,"    cr�ation des faces de QUAD_4")
 
  do icell = cgzone%cellfam(isect)%ideb, cgzone%cellfam(isect)%ifin
    element = cgzone%cellfam(isect)%fils(icell,:) 
    ns = 2            ! nombre de sommets par face (BAR_2)
    ! FACE 1 : BAR_2
    face(1:ns) = (/ element(1), element(2) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 2 : BAR_2
    face(1:ns) = (/ element(2), element(3) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 3 : BAR_2
    face(1:ns) = (/ element(3), element(4) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 4 : BAR_2
    face(1:ns) = (/ element(4), element(1) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
  enddo

case(TETRA_4) ! quatre faces (triangles) pour chacune trois sommets

  call print_info(8,"    cr�ation des faces de TETRA_4")

  do icell = cgzone%cellfam(isect)%ideb, cgzone%cellfam(isect)%ifin
    element = cgzone%cellfam(isect)%fils(icell,:) 
    ns = 3            ! nombre de sommets par face (TRI_3)
    ! FACE 1 : TRI_3
    face(1:ns) = (/ element(1), element(3), element(2) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 2 : TRI_3
    face(1:ns) = (/ element(1), element(2), element(4) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 3 : TRI_3
    face(1:ns) = (/ element(2), element(3), element(4) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 4 : TRI_3
    face(1:ns) = (/ element(3), element(1), element(4) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
  enddo

case(PYRA_5) ! 1 quadrangle (4 sommets) et 4 triangles par �l�ment PYRA
  call erreur("D�veloppement", "Traitement des �l�ments PYRA_5 non impl�ment�")
  ! CF PDF : CGNS SIDS pages 21-23

case(PENTA_6) ! 3 quadrangles (4 sommets) et 2 triangles par �l�ment PENTA

  call print_info(8,"    cr�ation des faces de PENTA_6")

  do icell = cgzone%cellfam(isect)%ideb, cgzone%cellfam(isect)%ifin
    element = cgzone%cellfam(isect)%fils(icell,:) 
    ns = 3            ! nombre de sommets par face (TRI_3)
    ! FACE 1 : TRI_3
    face(1:ns) = (/ element(1), element(2), element(3) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 2 : TRI_3
    face(1:ns) = (/ element(4), element(5), element(6) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    
    ns = 4            ! nombre de sommets par face (QUAD_3)
    ! FACE 3 : QUAD_4
    face(1:ns) = (/ element(1), element(3), element(6), element(4) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 4 : QUAD_4
    face(1:ns) = (/ element(1), element(2), element(5), element(4) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 5 : QUAD_4
    face(1:ns) = (/ element(2), element(3), element(6), element(5) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
  enddo
  !call erreur("D�veloppement", "Traitement des �l�ments PENTA_6 non impl�ment�")
  ! CF PDF : CGNS SIDS pages 21-23

case(HEXA_8) ! 6 quadrangles (4 sommets)

  call print_info(8,"    cr�ation des faces de HEXA_8")

  do icell = cgzone%cellfam(isect)%ideb, cgzone%cellfam(isect)%ifin
    element = cgzone%cellfam(isect)%fils(icell,:) 
    ns = 4            ! nombre de sommets par face (QUAD_4)
    ! FACE 1 : QUAD_4
    face(1:ns) = (/ element(1), element(2), element(3), element(4) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 2 : QUAD_4
    face(1:ns) = (/ element(1), element(2), element(6), element(5) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 3 : QUAD_4
    face(1:ns) = (/ element(5), element(6), element(7), element(8) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 4 : QUAD_4
    face(1:ns) = (/ element(4), element(3), element(7), element(8) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 5 : QUAD_4
    face(1:ns) = (/ element(1), element(4), element(8), element(5) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
    ! FACE 6 : QUAD_4
    face(1:ns) = (/ element(2), element(3), element(7), element(6) /)
    call traitface(ns, icell, face, face_vtex, face_cell, vtex_face)
  enddo
  !call erreur("D�veloppement", "Traitement des �l�ments HEXA_8 non impl�ment�")
  ! CF PDF : CGNS SIDS pages 21-23

case default
  call erreur("D�veloppement", &
              "Type d'�l�ment inattendu dans le calcul de connectivit�")
endselect

!print*,'moyenne des connections:',sum(vtex_face%nface(1:nvtex))/real(nvtex,krp)

deallocate(element)

! -- FIN de boucle sur les sections
enddo
   
! --- d�sallocation ---

deallocate(face, vtex_face%vtex_face, vtex_face%nface)

!-------------------------
contains      ! SOUS-PROCEDURES

  !------------------------------------------------------------------------------!
  ! Proc�dure : traitface
  ! Sous proc�dure pour le traitement des faces selon leur existence
  !------------------------------------------------------------------------------!
  subroutine traitface(nsom, icell, face, face_vtex, face_cell, vtex_face)
  implicit none
  ! -- Entr�es --
  integer                    :: nsom      ! nombre de sommets des faces trait�es
  integer                    :: icell     ! cellule en cours de d�composition en faces
  integer, dimension(1:nsom) :: face      ! face courante de la cellule
  ! -- Entr�es/Sorties --
  type(st_connect)        :: face_vtex ! connectivit� face->sommets  � cr�er
  type(st_connect)        :: face_cell ! connectivit� face->cellules � cr�er
  type(stloc_vtex_face)   :: vtex_face ! connectivit� sommets->(faces cr��es)
  ! Variables internes
  integer :: iface, newf   ! index de face si d�j� cr��e, ou index de nouvelle face 
  integer :: i, is         ! indice, indice de sommet

  ! Corps de proc�dure

    ! calcul de l'indice de face (/ face /) : 0 si non trouv�
    iface = face_exist(face, nsom, face_vtex, vtex_face)  

    if (iface == 0) then
      ! la face n'existe pas dans la liste courante : on l'ajoute (face_vtex)
      newf              = face_vtex%nbnodes + 1
      face_vtex%nbnodes = newf
      face_vtex%fils(newf, 1:nsom) = face(1:nsom)
      ! on met � jour la connectivit� face->cellule
      face_cell%nbnodes = newf
      face_cell%fils(newf, 1) = icell   ! premi�re cellule
      ! on ajoute la face dans la connectivit� sommets->faces
      do i = 1, nsom
        is = face(i)
        vtex_face%nface(is)                          = vtex_face%nface(is) + 1
        !print*,'nface',is,':',vtex_face%nface(is)
        vtex_face%vtex_face(is, vtex_face%nface(is)) = newf
      enddo

    else
      ! la face existe d�j� : on met � jour la connectivit� face->cellule
      !print*,"!! DEBUG : face_exist =",iface," :",face_cell%fils(iface,:)
      if (face_cell%fils(iface,2) /= 0) then
        call erreur("Conversion CGNS->TYPHON",&
                    "Erreur de calcul de connectivit� : trois cellules pour une face")
      endif
      face_cell%fils(iface,2) = icell   ! seconde cellule

    endif

  endsubroutine traitface


  !------------------------------------------------------------------------------!
  ! Fonction : face_exist   
  !   Recherche dans l'ensemble des faces d�j� cr��es si la face courante
  !   existe d�j� (tous les sommets communs) : renvoie le numero de la face si c'est le cas,
  !   0 dans le cas contraire
  !------------------------------------------------------------------------------!
  integer function face_exist(face, nsom, face_vtex, vtex_face) 
  implicit none 
  ! -- Entr�es --
  integer, dimension(:)   :: face      ! face
  integer                 :: nsom      ! nombre de sommets de la face
  type(st_connect)        :: face_vtex ! connectivit� face->sommets  � cr�er
  type(stloc_vtex_face)   :: vtex_face ! connectivit� sommets->(faces cr��es)
  ! -- Variables internes --
  integer :: iface, isom  
  logical :: find_face

  ! -- D�but de proc�dure

  face_exist = 0  ! initialisation si face non trouv�e

  ! recherche parmi les faces cr��es contenant le premier sommet de "face"
  isom      = face(1)
  find_face = .false.
  
  do iface = 1, vtex_face%nface(isom)    ! boucle sur les faces connect�es au sommet isom
    find_face = same_face(nsom, face, face_vtex%fils(vtex_face%vtex_face(isom,iface), 1:nsom))
    if (find_face) exit                  ! boucle avort�e si face trouv�e
  enddo 

  if (find_face) face_exist = vtex_face%vtex_face(isom,iface)

  !-------------------------
  endfunction face_exist


  !------------------------------------------------------------------------------!
  ! Fonction : same_face  
  ! Teste si deux faces ont les memes sommets 
  !  (Hyp. : elles ont le meme nombre de sommets)
  !------------------------------------------------------------------------------!
  logical function same_face(nsom, face1, face2) 
  implicit none
  ! -- Entr�es --
  integer, dimension(:)   :: face1, face2     ! faces � comparer
  integer                 :: nsom             ! nombre de sommets des faces
  ! -- Variables internes --
  integer :: isom1, isom2
  logical :: same_som

  ! -- D�but de proc�dure
   
  do isom1 = 1, nsom   ! boucle sur les sommets de la face1
    ! recherche sommet par sommet de FACE1 dans FACE2

    do isom2 = 1, nsom
      same_som = ( face1(isom1) == face2(isom2) )
      if (same_som) exit    ! le sommet a �t� trouv� : on passe au suivant
    enddo

    if (.not.same_som) exit   ! un sommet non trouv� suffit � quitter
  enddo

  same_face = same_som

  !-------------------------
  endfunction same_face



!-------------------------
endsubroutine createface_fromcgns

!------------------------------------------------------------------------------!
! Historique des modifications
!
! nov  2002 : cr�ation de la proc�dure
! juin 2004 : ajout de construction de PRISM (PENTA_6) et HEXA
!             connectivit� vtex->face commune � toutes les familles volumiques
!------------------------------------------------------------------------------!
