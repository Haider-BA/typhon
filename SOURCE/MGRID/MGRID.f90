!------------------------------------------------------------------------------!
! MODULE : MGRID                          Auteur : J. Gressier
!                                         Date   : Mars 2004
! Fonction                                Modif  : (cf historique)
!   D�finition des structures de donn�es des grilles
!   maillage et champ
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module MGRID

use TYPHMAKE      ! Definition de la precision/donn�es informatiques
use USTMESH       ! D�finition des maillages non structur�s
use DEFFIELD      ! D�finition des champs physiques
use GEO3D        ! module de d�finition des vecteurs et op�rateurs associ�s

implicit none

! -- Variables globales du module -------------------------------------------



! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! D�finition de la structure ST_GRID : grid maillage g�n�ral et champ
!------------------------------------------------------------------------------!
type st_grid
  integer                :: id         ! num�ro de grid
  integer                :: mpi_cpu    ! num�ro de CPU charg� du calcul
  type(st_grid), pointer :: next       ! pointeur de liste cha�n�e
  type(st_grid), pointer :: subgrid    ! pointeur de liste cha�n�e
  type(st_ustmesh)       :: umesh      ! maillage non structur�
  integer                :: nfield     ! nombre de champs
  type(st_field), pointer:: field      ! tableau des champs
  integer                :: nbocofield ! nombre de champs g�n�riques
  type(st_genericfield), pointer &
                         :: bocofield  ! liste cha�n�e de champs g�n�riques
  type(st_field), pointer:: field_loc  ! champ local pour l'int�gration
  type(st_field), pointer:: field_cyclestart  ! champ de d�but de cycle
endtype st_grid


! -- INTERFACES -------------------------------------------------------------

interface new
  module procedure new_grid
endinterface

interface delete
  module procedure delete_grid
endinterface

interface name
  module procedure name_grid
endinterface

! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
contains


!------------------------------------------------------------------------------!
! Proc�dure : initialisation d'une structure GRID
!------------------------------------------------------------------------------!
subroutine new_grid(grid, id)
implicit none
type(st_grid)  :: grid
integer        :: id

  grid%id = id
  nullify(grid%next)
  nullify(grid%subgrid)

endsubroutine new_grid


!------------------------------------------------------------------------------!
! Proc�dure : cr�ation et lien cha�n� d'une structure GRID
!------------------------------------------------------------------------------!
function insert_newgrid(grid, id) result(pgrid)
implicit none
type(st_grid), pointer :: pgrid
type(st_grid), target  :: grid
integer                :: id

  allocate(pgrid)
  call new(pgrid, id)
  pgrid%next => grid  

endfunction insert_newgrid


!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure GRID
!------------------------------------------------------------------------------!
subroutine delete_grid(grid)
implicit none
type(st_grid)  :: grid

  ! destruction des champs et maillage de la grille
  call delete(grid%umesh)
  call delete_chainedfield(grid%field)
  deallocate(grid%field_loc)

  ! destruction des sous-grilles
  call delete_chainedgrid(grid%subgrid)

  ! ATTENTION : pas de destruction de la grilles suivante

endsubroutine delete_grid


!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une liste cha�n�e de structure GRID
!------------------------------------------------------------------------------!
subroutine delete_chainedgrid(grid)
implicit none
type(st_grid), target  :: grid
type(st_grid), pointer :: pgrid, dgrid

  pgrid => grid
  do while(associated(pgrid))
    dgrid => pgrid
    pgrid => pgrid%next
    call delete(dgrid)
  enddo

endsubroutine delete_chainedgrid


!------------------------------------------------------------------------------!
! Fonction : nom de grille
!------------------------------------------------------------------------------!
function name_grid(grid) result(str)
implicit none
type(st_grid)         :: grid
character(len=strlen) :: str

  str = "" ! grid%umesh%name

endfunction name_grid

!------------------------------------------------------------------------------!
! Proc�dure : ajout avec allocation d'une structure champ g�n�rique
! (par insertion)
!------------------------------------------------------------------------------!
function newbocofield(grid,dim,nscal,nvect,ntens) result(pbocofield)
implicit none
type(st_genericfield), pointer :: pbocofield
type(st_grid)                  :: grid
integer                        :: dim, nscal, nvect, ntens

  grid%nbocofield = grid%nbocofield + 1

  if (grid%nbocofield == 1) then
   allocate(pbocofield)
   call new(pbocofield,dim,nscal,nvect,ntens)
   nullify(pbocofield%next)
   call init_genericfield(pbocofield,0._krp,v3d(0._krp,0._krp,0._krp))
  else
    pbocofield => insert_newgfield(grid%bocofield,dim,nscal,nvect,ntens)
    call init_genericfield(pbocofield,0._krp,v3d(0._krp,0._krp,0._krp))
  endif
  grid%bocofield => pbocofield

endfunction newbocofield

!------------------------------------------------------------------------------!
! Proc�dure : ajout avec allocation d'une structure champ (par insertion)
!------------------------------------------------------------------------------!
function newfield(grid,nscal,nvect,ncell,nface) result(pfield)
implicit none
type(st_field), pointer :: pfield
type(st_grid)           :: grid
integer                 :: dim, nscal, nvect, ncell, nface

  grid%nfield = grid%nfield + 1

  if (grid%nfield == 1) then
   allocate(pfield)
   call new(pfield,nscal,nvect,ncell,nface)
   nullify(pfield%next)
  else
    pfield => insert_newfield(grid%field,nscal,nvect,ncell,nface)
  endif
  grid%field => pfield

endfunction newfield


endmodule MGRID

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2004 : cr�ation du module
! juin 2004 : proc�dure newbocofield
! oct  2004 : field chained list
!------------------------------------------------------------------------------!
