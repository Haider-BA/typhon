!------------------------------------------------------------------------------!
! MODULE : DEFZONE                        Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  : Juin 2003 (cf historique)
!   D�finition des structures de donn�es des zones (contient
!   maillage, type de solveur et info)
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module DEFZONE

use TYPHMAKE      ! Definition de la precision/donn�es informatiques
use MENU_SOLVER   ! D�finition des solveurs
use MENU_MESH     ! D�finition du maillage
use STRMESH       ! D�finition des maillages structur�s
use USTMESH       ! D�finition des maillages non structur�s
!use BOUND        ! Librairie de d�finition des conditions aux limites
use MENU_ZONECOUPLING ! D�finition des structures d'�change entre zones
use DEFFIELD      ! D�finition des champs physiques

implicit none

! -- Variables globales du module -------------------------------------------



! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! D�finition de la structure ST_ZONE : zone maillage g�n�ral et champ
!------------------------------------------------------------------------------!
type st_zone
  integer               :: id         ! num�ro de zone
  character(len=strlen) :: nom        ! nom de la zone
  integer               :: ndom       ! nombre de domaine total (cas hybride)
  integer               :: nmesh_str  ! nombre de domaines structur�s
  integer               :: nmesh_ust  ! nombre de domaines non structur�s
  type(mnu_solver)      :: defsolver  ! type de solveur � utiliser 
                                      !   cf d�finitions variables globales
  type(mnu_mesh)        :: defmesh    ! type de maillage
  character             :: typ_mesh   ! type de maillage (cf VARCOM)
                                      !   S : multibloc structur�
                                      !   U : non structur�
                                      !   H : hybride
  integer               :: mpi_cpu    ! num�ro de CPU charg� du calcul

  type(st_strmesh), dimension(:), pointer &
                        :: str_mesh   ! maillage multibloc structur�
  type(st_ustmesh)      :: ust_mesh   ! maillage non structur�
  type(st_field), dimension(:), pointer &
                        :: field      ! tableau des champs

  integer               :: ncoupling  ! nombre d'�changes avec d'autres zones
  type(mnu_zonecoupling), dimension(:), pointer &
                        :: coupling   !definition des raccords avec d'autres zones
endtype st_zone


! -- INTERFACES -------------------------------------------------------------

interface delete
  module procedure delete_zone
endinterface

! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
contains


!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure ZONE
!------------------------------------------------------------------------------!
subroutine delete_zone(zone)
implicit none
type(st_zone)  :: zone
integer        :: i     

  print*,'destruction de zone interne / mesh :',zone%nmesh_str, zone%nmesh_ust !! DEBUG
  if (zone%nmesh_str >= 1) then
    do i = 1, zone%nmesh_str
      call delete(zone%str_mesh(i))   
    enddo 
    deallocate(zone%str_mesh)
  endif

  if (zone%nmesh_ust >= 1) then
    print*,"desallocation ust_mesh" !! DEBUG
    call delete(zone%ust_mesh)
  endif
  
  if (zone%ncoupling >= 1) then
    print*,"desallocation tableau coupling" !! DEBUG
    do i = 1, zone%ncoupling
      print*,"desallocation coupling ",i !! DEBUG
      call delete(zone%coupling(i))
    enddo  
    deallocate(zone%coupling)
  endif

  do i = 1, zone%ndom
    print*,"desallocation champ ",i !! DEBUG
    call delete(zone%field(i))
  enddo
  deallocate(zone%field)

  print*,'fin de destruction de zone interne' !! DEBUG

endsubroutine delete_zone




endmodule DEFZONE


!------------------------------------------------------------------------------!
! Historique des modifications
!
! juil 2002 (v0.0.1b): cr�ation du module
! juin 2003          : structuration des champs par type (scalaire, vecteur...)
!------------------------------------------------------------------------------!