!------------------------------------------------------------------------------!
! MODULE : STRMESH                        Auteur : J. Gressier
!                                         Date   : Mai 2002
! Fonction                                Modif  : Octobre 2002
!   Bibliotheque de procedures et fonctions pour la gestion de maillages
!   structur�s
!
! Defauts/Limitations/Divers :
! Historique :
!
!------------------------------------------------------------------------------!

module STRMESH

use TYPHMAKE   ! Definition de la precision
use OUTPUT
use GEO3D      ! 
use MESHBASE   ! Librairie pour les �l�ments g�om�triques de base

implicit none

! -- Variables globales du module -------------------------------------------

integer, parameter :: nghostcell = 2


! -- DECLARATIONS -----------------------------------------------------------


!------------------------------------------------------------------------------!
! D�finition de la structure ST_PATCH : D�finition de portions de bloc
!------------------------------------------------------------------------------!
type st_patch
  character, dimension(3) :: dir   ! d�finition des directions 1 � 3 dans I,J,K
  integer,   dimension(3) :: sens  ! +1 ou -1 pour la direction des indices
                                   ! de min � max,
                                   ! si invariant, pr�cise le sens externe au bloc
  integer,   dimension(3) :: min, max  ! indices de cellules d�but et fin
endtype st_patch


!------------------------------------------------------------------------------!
! D�finition de la structure ST_STRCONNECT : D�finition des connections de blocs
!------------------------------------------------------------------------------!
type st_strconnect
  character                    :: type       ! type de connection
                                          !   (B)lock, (F)ace, (E)dge, (V)ertex
  type(st_patch)               :: local      ! Patch local au bloc
  type(st_block), pointer      :: linkedblk  ! Bloc associ�
  type(st_patch)               :: linkedpat  ! Patch associ�
  type(st_strconnect), pointer :: next       ! (liste) connection suivante
endtype st_strconnect


!------------------------------------------------------------------------------!
! D�finition de la structure ST_STRBOUND : D�finition des conditions aux limites
!------------------------------------------------------------------------------!
!type st_strbound
!  type(st_patch)              :: local      ! Patch local au bloc
  !type(st_solvbound), pointer :: bound      ! condition aux limites associ�e
!  type(st_strbound),  pointer :: next       ! (liste) condition suivante
!endtype st_strbound


!------------------------------------------------------------------------------!
! D�finition de la structure ST_BLOCK : Bloc structur�
!------------------------------------------------------------------------------!
type st_block
  integer                    :: id                ! numero de domaine
  integer                    :: level             ! niveau multigrille
  integer                    :: nbdim             ! nombre de dimension du maillage
  integer                    :: idim, jdim, kdim  ! indices max des cellules 
  type(st_mesh)              :: mesh              ! maillage associ�
  integer                    :: nconnect, nbound  ! nombre de connections et
                                               !   conditions aux limites
  type(st_strconnect), pointer &
                             :: connect           ! liste des connections
  !type(st_strbound), pointer :: bound             ! liste des conditions aux limites
  type(st_block), pointer    :: next              ! (liste) bloc suivant
endtype st_block


!------------------------------------------------------------------------------!
! D�finition de la structure ST_STRMESH : ensemble de blocs structur�s
!------------------------------------------------------------------------------!

type st_strmesh
  integer                 :: nblock   ! nombre de blocs dans la zone
  integer                 :: nlevel   ! nombre de niveau multigrille (0 � nlevel)
  type(st_block), pointer :: block    ! liste des blocs
  !type(st_nsgen)          :: nsgen    ! donn�es g�n�rales pour les �quations NS
endtype st_strmesh



! -- INTERFACES -------------------------------------------------------------

interface new
  module procedure new_block, new_strmesh
endinterface

interface delete
  module procedure delete_block, delete_strmesh
endinterface


! -- Fonctions et Operateurs ------------------------------------------------

integer nb_block       ! fonction d�finie dans count_struct.f90
integer nb_connect     ! fonction d�finie dans count_struct.f90
integer nb_bound       ! fonction d�finie dans count_struct.f90

! -- IMPLEMENTATION ---------------------------------------------------------
contains


!------------------------------------------------------------------------------!
! Proc�dure : allocation d'une structure BLOCK
!------------------------------------------------------------------------------!
subroutine new_block(block, idim, jdim, kdim, allocgrad)
implicit none
type(st_block) :: block             ! block � cr�er
integer        :: idim, jdim, kdim  ! dimension du maillage interne
logical        :: allocgrad         ! allocation des gradients

  block%idim = idim
  block%jdim = idim
  block%kdim = idim

  stop
  !call new(block%mesh,  idim, jdim, kdim)

  block%nconnect = 0        ! Initialisation des listes de connections
  !block%nbound   = 0        ! et de conditions aux limites
  nullify(block%connect)
  !nullify(block%bound)

endsubroutine new_block


!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure BLOCK
!------------------------------------------------------------------------------!
subroutine delete_block(block)
implicit none
type(st_block)               :: block
type(st_strconnect), pointer :: pc, pcd
!type(st_strbound),   pointer :: pb, pbd

  call delete(block%mesh)

  pc => block%connect        ! Destruction de la liste de connections
  do while (associated(pc))
    pcd => pc
    pc  => pc%next
    deallocate(pcd)
  enddo
!  pb => block%bound         ! Destruction de la liste de cond. aux lim.
!  do while (associated(pb))
!    pbd => pb
!    pb  => pb%next
!    deallocate(pbd)
!  enddo

endsubroutine delete_block


!------------------------------------------------------------------------------!
! Proc�dure : allocation d'une structure STRMESH
!------------------------------------------------------------------------------!
subroutine new_strmesh(zone)
implicit none
type(st_strmesh) :: zone

  zone%nblock = 0
  nullify(zone%block)

endsubroutine new_strmesh


!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure STRMESH
!------------------------------------------------------------------------------!
subroutine delete_strmesh(zone)
implicit none
type(st_strmesh)     :: zone
type(st_block), pointer :: pb, pbd

  pb => zone%block          ! Destruction de la liste de blocs 
  do while (associated(pb))
    pbd => pb
    pb  => pb%next
    !call delete(pbd)        ! destruction du contenu du bloc !!! A DEFINIR
    deallocate(pbd)
  enddo

endsubroutine delete_strmesh



endmodule STRMESH
