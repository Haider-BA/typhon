!------------------------------------------------------------------------------!
! MODULE : DEFZONE                        Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  : (cf historique)
!   D�finition des structures de donn�es des zones (contient
!   maillage, type de solveur et info)
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module DEFZONE

use TYPHMAKE      ! Definition de la precision/donn�es informatiques
use MODINFO       ! Information pour la gestion de l'int�gration
use MENU_SOLVER   ! D�finition des solveurs
use MENU_NUM      ! D�finition des param�tres num�riques d'int�gration
use MENU_MESH     ! D�finition du maillage
use MGRID         ! D�finition des grilles
use STRMESH       ! D�finition des maillages structur�s
use USTMESH       ! D�finition des maillages non structur�s
!use BOUND        ! Librairie de d�finition des conditions aux limites
use MENU_ZONECOUPLING ! D�finition des structures d'�change entre zones
use DEFFIELD      ! Donn�es des champs physiques
use DEFCAPTEURS   ! Donn�es des capteurs 

implicit none

! -- Variables globales du module -------------------------------------------



! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! D�finition de la structure ST_ZONE : zone maillage g�n�ral et champ
!------------------------------------------------------------------------------!
type st_zone
  integer               :: id         ! num�ro de zone
  character(len=strlen) :: nom        ! nom de la zone
  !integer               :: ndom       ! nombre de domaine total (cas hybride)
  !integer               :: nmesh_str  ! nombre de domaines     structur�s
  !integer               :: nmesh_ust  ! nombre de domaines non structur�s
  integer               :: nprobe     ! nombre de capteurs
  integer               :: ncoupling  ! nombre d'�changes avec d'autres zones
  type(st_infozone)     :: info       ! information sur l'int�gration
  type(mnu_solver)      :: defsolver  ! type de solveur � utiliser 
  type(mnu_time)        :: deftime    ! param�tres d'int�gration temporelle
  type(mnu_spat)        :: defspat    ! param�tres d'int�gration spatiale
                                      !   cf d�finitions variables globales
  type(mnu_mesh)        :: defmesh    ! type de maillage
  character             :: typ_mesh   ! type de maillage (cf VARCOM)
                                      !   S : multibloc structur�
                                      !   U : non structur�
                                      !   H : hybride
  integer               :: mpi_cpu    ! num�ro de CPU charg� du calcul

  !type(st_strmesh), dimension(:), pointer &
  !                      :: str_mesh   ! maillage multibloc structur�
  integer                :: ngrid      ! nombre de grilles (mesh + field)
  type(st_grid), pointer :: grid       ! liste cha�n�e de grilles
  !integer               :: nmesh      ! nombre champs (liste cha�n�e)  
  !integer               :: nfield     ! nombre champs (liste cha�n�e)  
  !type(st_ustmesh), pointer &
  !type(st_ustmesh) & !, dimension(:), pointer &
  !                      :: ust_mesh   ! liste cha�n�e de maillage non structur�
  !type(st_field), pointer &
  !type(st_field), dimension(:), pointer &
  !                      :: field      ! tableau des champs
  type(st_capteur), dimension(:), pointer &
                        :: probe      ! tableau des capteurs
  type(mnu_zonecoupling), dimension(:), pointer &
                        :: coupling   !definition des raccords avec d'autres zones
endtype st_zone


! -- INTERFACES -------------------------------------------------------------

interface new
  module procedure new_zone
endinterface

interface delete
  module procedure delete_zone
endinterface

! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
contains


!------------------------------------------------------------------------------!
! Proc�dure : initialisation d'une structure ZONE
!------------------------------------------------------------------------------!
subroutine new_zone(zone, id)
implicit none
type(st_zone)  :: zone
integer        :: id

  zone%id = id

  !zone%ndom  = 0   ! DEV: � supprimer apr�s homog�n�isation dans MGRID

  zone%ngrid = 0
  nullify(zone%grid)

endsubroutine new_zone


!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure ZONE
!------------------------------------------------------------------------------!
subroutine delete_zone(zone)
implicit none
type(st_zone)  :: zone
integer        :: i     

  !print*,'DEBUG: destruction de zone '
  !if (zone%nmesh_str >= 1) then
  !  do i = 1, zone%nmesh_str
  !    call delete(zone%str_mesh(i))   
  !  enddo 
  !  deallocate(zone%str_mesh)
  !endif
  
  call delete(zone%defsolver)
  
  ! Destruction des structures USTMESH (DEV: dans MGRID)
  !if (zone%nmesh_ust >= 1) then
  !  print*,"desallocation ust_mesh" !! DEBUG
  !  call delete(zone%ust_mesh)
  !endif
  
!  if (zone%ncoupling >= 1) then
    print*,"desallocation tableau coupling" !! DEBUG
    do i = 1, zone%ncoupling
      print*,"desallocation coupling ",i !! DEBUG
      call delete(zone%coupling(i))
    enddo  
    deallocate(zone%coupling)
!  endif

  ! Destruction des champs (structures FIELD) (DEV: dans MGRID)
  !print*,'debug delete_zone : ',zone%ndom,' ndom'
  !do i = 1, zone%ndom
  !  print*,"desallocation champ ",i !! DEBUG
  !  call delete(zone%field(i))
  !enddo
  !if (zone%ndom >= 1) deallocate(zone%field)

  ! Destruction des structures MGRID

  print*,'DEV!!! destruction des MGRID � effectuer'  

  !print*,'fin de destruction de zone interne' !! DEBUG

endsubroutine delete_zone


!------------------------------------------------------------------------------!
! Proc�dure : ajout avec allocation d'une structure grille (par insertion)
!------------------------------------------------------------------------------!
function newgrid(zone) result(pgrid)
implicit none
type(st_grid), pointer :: pgrid
type(st_zone)          :: zone
integer                :: id

  zone%ngrid = zone%ngrid + 1

  if (zone%ngrid == 1) then
   allocate(pgrid)
   call new(pgrid, zone%ngrid)
  else
    pgrid => insert_newgrid(zone%grid, zone%ngrid)
  endif

  pgrid%nbocofield = 0
  pgrid%nfield = 0

  zone%grid => pgrid

endfunction newgrid



endmodule DEFZONE

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juil 2002 : cr�ation du module
! juin 2003 : structuration des champs par type (scalaire, vecteur...)
! juil 2003 : delete zone%defsolver
! mars 2003 : structure "grid" (mesh + field) en liste cha�n�e
!------------------------------------------------------------------------------!
