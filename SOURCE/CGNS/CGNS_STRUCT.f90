!------------------------------------------------------------------------------!
! MODULE : CGNS_STRUCT                    Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : 
!   D�finition des structures de donn�es pour la lecture et la gestion
!   de fichiers CGNS
!
! Defauts/Limitations/Divers :
!   La notion de ZONE pour le maillage CGNS est diff�rent de la ZONE pour TYPHON
!   En CGNS, une ZONE est une entit� de maillage (ensemble non structur� ou bloc
!   structur�). Il y a en g�n�ral plusieurs ZONEs CGNS pour d�finir un maillage
!   (structur�), alors que cela ne repr�sentera qu'une seule ZONE dans TYPHON.
!
!------------------------------------------------------------------------------!

module CGNS_STRUCT   

use TYPHMAKE             ! D�finition de la pr�cision
use CGNSLIB             ! D�finition des constantes pour les types CGNS
use GEO3D            ! MES! Compilation conditionnelle ? avec GEO3D_dp

!use mod_nuage_de_points         ! TYPE INCLUS: NUAGE DE POINTS  
!use mod_connectivite            ! TYPE INCLUS: CONNECTIVITE   

implicit none         

! -- Variables globales du module -------------------------------------------

!integer, parameter :: cgnslen   = 30  ! d�fini dans CGNSLIB
integer, parameter :: maxconnect = 8   ! nombre maximum de sommets par �l�ment


! -- DECLARATIONS -----------------------------------------------------------


!------------------------------------------------------------------------------!
! ST_CGNS_USTCONNECT : D�finition de la connectivit�
!   Sommets, faces, cellules
!------------------------------------------------------------------------------!
type st_cgns_ustconnect
  integer                 :: nbnodes     ! nombre de d'ensemble connectivit�s
  integer                 :: ideb, ifin  ! indice de d�but et de fin
  integer                 :: type        ! type d'�l�ments (cf CGNSLIB)
  integer                 :: imesh       ! type g�om�trique (1D, 2D ou 3D)
  integer                 :: nbfils      ! nombre de connectivit�s par ensemble
                                         !   selon le type
  integer, dimension(:,:), pointer &
                          :: fils        ! d�finition de la connectivit�
endtype st_cgns_ustconnect


!------------------------------------------------------------------------------!
! ST_CGNS_VTEX : structure r�ceptrice des sommets des maillages
!------------------------------------------------------------------------------!
type st_cgns_vtex
  integer                 :: ni, nj, nk   ! nombre de sommets
  type(v3d), dimension(:,:,:), pointer &
                          :: vertex       ! liste des sommets
endtype st_cgns_vtex


!------------------------------------------------------------------------------!
! ST_CGNS_PATCH : structure de d�finition de patch
!------------------------------------------------------------------------------!
type st_cgns_patch
  integer                          :: nbvtex   ! nombre de sommets
endtype st_cgns_patch


!------------------------------------------------------------------------------!
! ST_CGNS_BOCO : structure de d�finition de condition aux limites
!------------------------------------------------------------------------------!
type st_cgns_boco
  character(len=cgnslen)  :: nom          ! nom de la condition aux limites
  character(len=cgnslen)  :: family       ! nom de la condition aux limites
  integer                 :: nvtex        ! nombre de sommets
  integer, dimension(:), pointer &
                          :: ivtex        ! liste des sommets 
                                          ! (pointeurs entiers dans zone%mesh)
endtype st_cgns_boco


!------------------------------------------------------------------------------!
! ST_CGNS_ZONE : structure r�ceptrice des donn�es par zone
!------------------------------------------------------------------------------!
type st_cgns_zone
  character(len=cgnslen)  :: nom          ! nom de la zone
  integer                 :: imesh        ! type de maillage (2: 2D, 3: 3D) IDEM BASE
  integer                 :: type         ! type de zone (structur�e ou non)
  type(st_cgns_vtex)      :: mesh
  integer                 :: ncellfam, &  ! nombre de familles de connectivit�s de 
                             nfacefam, &  ! (   cellules, faces,   bords)
                             nedgefam     ! (3D: volume,  surface, ligne)
                                          ! (2D: surface, ligne,   X)
  type(st_cgns_ustconnect), dimension(:), pointer &
                          :: cellfam, &   ! sections de connectivit� par type d'�l�ment
                             facefam, &   ! (cellules, faces, bords)
                             edgefam
  integer                 :: npatch       ! nombre de patchs (connectivit� en structur�)
  type(st_cgns_patch), dimension(:), pointer &
                          :: patch        ! patch de maillage structur�
  integer                 :: nboco        ! nombre de conditions aux limites 
  type(st_cgns_boco), dimension(:), pointer &
                          :: boco         ! liste des conditions aux limites
endtype st_cgns_zone


!------------------------------------------------------------------------------!
! ST_CGNS_BASE : structure r�ceptrice des donn�es par base
!------------------------------------------------------------------------------!
type st_cgns_base  
  character(len=cgnslen) :: nom        ! nom de la base
  integer                 :: imesh     ! type de maillage (2: 2D, 3: 3D)
  integer                 :: igeo      ! nombre de coordonn�es
  integer                 :: nzone     ! nombre de zones
  integer                 :: nzone_str ! nombre de zones structur�es
  integer                 :: nzone_ust ! nombre de zones non structur�es
  type(st_cgns_zone), dimension(:), pointer &
                          :: zone   ! liste des zones
endtype st_cgns_base  


!------------------------------------------------------------------------------!
! ST_CGNS_WORLD : structure principale r�ceptrice des donn�es du fichier CGNS
!------------------------------------------------------------------------------!
type st_cgns_world
  character(len=cgnslen) :: nom    ! nom DU JEU DE DONNEES  
  integer                 :: nbase  ! nombre de bases
  type(st_cgns_base), dimension(:), pointer &
                          :: base   ! liste des bases
endtype st_cgns_world





endmodule CGNS_STRUCT
