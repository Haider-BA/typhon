!------------------------------------------------------------------------------!
! Procedure : cgns2typhon_ustboco.f90     Auteur : J. Gressier
!                                         Date   : F�vrier 2003
! Fonction                                Modif  : (cf historique)
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

  select case(cgnszone%boco(ib)%gridlocation)
  case(vertex)
    call seek_bcface_vtex(ib, cgnszone%boco(ib), mesh, listface)
  case(facecenter)
    call seek_bcface_face(ib, cgnszone%boco(ib), cgnszone%nfacefam , &
                          cgnszone%facefam(:), mesh, listface)
  case default
    call erreur("construction de condition limite","type de sp�cification non admis")
  endselect
  
enddo

! -- V�rification du nombre total de faces limites affect�es aux conditions aux limites

nf = 0
do ib = 1, cgnszone%nboco
  nf = nf + mesh%boco(ib)%nface
enddo

if (nf /= mesh%nface_lim) call erreur("Conditions aux limites",&
  "le nombre de faces affect�es et existantes ne correspondent pas")

! desallocation

deallocate(listface)

!-------------------------
endsubroutine cgns2typhon_ustboco

!------------------------------------------------------------------------------!
! Historique des modifications
!
! fev  2003 : cr�ation de la proc�dure 
! juin 2004 : construction des connectivit�s BOCO-> faces, g�n�ralisation
!             proc�dure intrins�que transf�r�e dans USTMESH
!------------------------------------------------------------------------------!
