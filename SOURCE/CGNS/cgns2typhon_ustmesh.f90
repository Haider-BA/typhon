!------------------------------------------------------------------------------!
! Procedure : cgns2typhon_ustmesh         Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : (cf historique)
!   Conversion d'une zone CGNS en structure Maillage NON structur� pour Typhon
!   Cr�ation des connectivit�s FACE->SOMMETS et FACES->CELLULES
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine cgns2typhon_ustmesh(cgnszone, mesh) 

use CGNS_STRUCT   ! D�finition des structures CGNS
use DEFZONE       ! D�finition des structures ZONE
use USTMESH       ! D�finition des structures maillages non structur�s
use OUTPUT        ! Sorties standard TYPHON

implicit none 

! -- Entr�es --
type(st_cgns_zone) :: cgnszone          ! structure ZONE des donn�es CGNS

! -- Sorties --
type(st_ustmesh)   :: mesh           ! structure USTMESH des donn�es TYPHON

! -- Variables internes --
integer, parameter  :: nmax_cell = 20   ! nb max de cellules dans la connectivit� vtex->cell
!integer, dimension(:,:), allocatable &
!                    :: vtex_cell,     & ! connectivit� interm�diaire sommets -> faces
type(st_connect) :: face_vtex, &     ! connectivit� interm�diaire faces   -> sommets
                       face_cell        ! connectivit� interm�diaire faces   -> cellules
!integer, dimension(:), allocatable &
!                    :: ncell            ! nombre de cellules par sommet
integer             :: ntotcell         ! calcul du nombre total de cellules
integer             :: maxvtex, maxface ! nombre de sommets/face, face/cellule
integer             :: nface            ! estimation du nombre de faces
integer             :: iconn, icell, ivtex   ! indices courants

! -- D�but de proc�dure

call print_info(8,". conversion du maillage et cr�ation des connectivit�s")

if (cgnszone%type /= Unstructured) then
  call erreur("D�veloppement","incoh�rence dans l'appel de subroutine")
endif

select case(cgnszone%imesh)    ! transfert du nombre de dimensions (2D ou 3D)
case(2)
  mesh%mesh%info%geom = msh_2dplan
case(3)
  mesh%mesh%info%geom = msh_3d
endselect

! --- conversion du nuage du point ---

call print_info(8,"  nuage de points")

mesh%mesh%nvtex  = cgnszone%mesh%ni         ! nb de sommets
allocate(mesh%mesh%vertex(mesh%mesh%nvtex, 1, 1))
mesh%mesh%vertex = cgnszone%mesh%vertex     ! copie du nuage de points
mesh%nvtex       = mesh%mesh%nvtex          ! nb de sommets (redondant)

! on sp�cifie que le tableau de faces ne sera pas allou�e
nullify(mesh%mesh%iface)
mesh%mesh%nface = 0

! --- cr�ation des connectivit�s interm�diaires sommets -> cellules ---
!
!call print_info(8,"  connectivit� interm�diaire sommets -> cellules")
!
!allocate(vtex_cell(mesh%nvtex, nmax_cell))
!allocate(    ncell(mesh%nvtex))
!vtex_cell(:,:) = 0
!ncell(:)       = 0
!
!do iconn = 1, cgnszone%ncellfam          ! boucle sur les sections, puis les cellules
!  do icell = cgnszone%cellfam(iconn)%ideb, cgnszone%cellfam(iconn)%ifin 
!    do ivtex = 1, cgnszone%cellfam(iconn)%nbfils                  ! sur les sommets
!      ! la cellule (icell) est connect�e au sommets fils(icell,ivtex)
!      ncell(icell) = ncell(icell) + 1
!      vtex_cell(cgnszone%cellfam(iconn)%fils(icell, ivtex), ncell(icell)) = icell
!    enddo
!  enddo
!enddo
!
!write(str_w,*) "    (",maxval(ncell)," cellules max par sommet, limit� � ",nmax_cell,")"
!call print_info(8,str_w)

! --- cr�ation des connectivit�s (cellule -> faces) et (face -> sommets) ---

call print_info(8,"  cr�ation des faces et connectivit�s associ�es")

! recherche des tailles de tableaux selon les types d'�l�ments

ntotcell = 0    ! nombre total de cellules
maxvtex  = 0    ! nombre de sommets max par face
maxface  = 0    ! nombre de faces   max par cellule
nface    = 0    ! estimation du nombre de faces max

do iconn = 1, cgnszone%ncellfam          ! boucle sur les sections de cellules
 
  ! cumul du nombre de cellules
  ntotcell = ntotcell + cgnszone%cellfam(iconn)%nbnodes  
  !print*,iconn," ",cgnszone%cellfam(iconn)%type !! DEBUG
  select case(cgnszone%cellfam(iconn)%type)
  case(NODE)
    call erreur("D�veloppement", "Type de cellule inattendu (NODE)")
  case(BAR_2,BAR_3)
    call erreur("D�veloppement", "Type de cellule inattendu (BAR)")
  case(TRI_3,TRI_6)
    maxvtex = max(maxvtex, 2)
    maxface = max(maxface, 3)
    nface   = nface + 3*cgnszone%cellfam(iconn)%nbnodes
  case(QUAD_4,QUAD_8,QUAD_9)
    maxvtex = max(maxvtex, 2)
    maxface = max(maxface, 4)
    nface   = nface + 4*cgnszone%cellfam(iconn)%nbnodes
  case(TETRA_4,TETRA_10)
    maxvtex = max(maxvtex, 3)
    maxface = max(maxface, 4)
    nface   = nface + 4*cgnszone%cellfam(iconn)%nbnodes
  case(PYRA_5,PYRA_14,PENTA_6,PENTA_15,PENTA_18)
    maxvtex = max(maxvtex, 4)
    maxface = max(maxface, 5)
    nface   = nface + 5*cgnszone%cellfam(iconn)%nbnodes
  case(HEXA_8,HEXA_20,HEXA_27)
    maxvtex = max(maxvtex, 4)
    maxface = max(maxface, 6)
    nface   = nface + 6*cgnszone%cellfam(iconn)%nbnodes
  case(MIXED, NGON_n)
    call erreur("Gestion CGNS", "El�ments MIXED et NFON_n non trait�s")
  case default
    call erreur("Gestion CGNS", "Type d'�l�ment non reconnu dans CGNSLIB")
  endselect
enddo

! allocation des tableaux de connectivit�s

! -- connectivit� interm�diaire face->sommets --
call new(face_vtex, nface, maxvtex)
face_vtex%nbnodes   = 0                     ! r�initialisation : nombre de faces cr�es
face_vtex%fils(:,:) = 0                     ! initialisation de la connectivit�

! -- connectivit� interm�diaire face->cellules --
call new(face_cell, nface, 2)
face_cell%nbnodes   = 0                     ! r�initialisation : nombre de faces cr�es
face_cell%fils(:,:) = 0                     ! initialisation de la connectivit�

! -- cr�ation des faces et des connectivit�s --

do iconn = 1, cgnszone%ncellfam          ! boucle sur les sections de cellules
  call createface_fromcgns(mesh%nvtex, cgnszone%cellfam(iconn), &
                           face_cell, face_vtex)
enddo

! Recopie des connectivit�s dans la structure TYPHON
! avec le nombre exact de faces reconstruites

nface          = face_vtex%nbnodes     ! meme valeur que face_cell%nbnodes aussi
mesh%nface     = nface
mesh%ncell_int = ntotcell
write(str_w,'(i10,a)') nface,"faces cr��es"
call print_info(8,str_w)

call new(mesh%facevtex, nface, maxvtex)
call new(mesh%facecell, nface, 2)

mesh%facevtex%fils(1:nface,1:maxvtex) = face_vtex%fils(1:nface,1:maxvtex)
mesh%facecell%fils(1:nface,1:2)       = face_cell%fils(1:nface,1:2)

! d�sallocation
!deallocate(vtex_cell, ncell)
call delete(face_cell)
call delete(face_vtex)

! -- Renum�rotation des faces --

call reorder_ustconnect(0, mesh)    ! action sur les connectivit�s uniquement

! -- Conversion des conditions aux limites  --

call cgns2typhon_ustboco(cgnszone, mesh)

!print*,"fin de cr�ation des structures TYPHON" !!! DEBUG

mesh%ncell_lim = mesh%nface_lim
mesh%ncell     = mesh%ncell_int + mesh%ncell_lim

!-------------------------
endsubroutine cgns2typhon_ustmesh

!------------------------------------------------------------------------------!
! Historique des modifications
!
! nov 2002 : cr�ation de la proc�dure
! fev 2004 : renseignements dans structure INFO_MESH
!------------------------------------------------------------------------------!



