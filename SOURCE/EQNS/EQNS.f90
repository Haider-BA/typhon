!------------------------------------------------------------------------------!
! MODULE : EQNS                           Auteur : J. Gressier
!                                         Date   : Mai 2002
! Fonction                                Modif  : Aout 2002
!   Bibliotheque de procedures et fonctions pour la d�finition des �tats
!   dans les �quations de Navier-Stokes
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module EQNS

use TYPHMAKE   ! Definition de la precision
use GEO3D  ! Compilation conditionnelle ? avec GEO3D_dp

! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! D�finition de la structure ST_NSETAT : �tat physique
!------------------------------------------------------------------------------!
type st_nsetat
  real(krp), dimension(:), pointer &
                  :: density    ! masses volumiques partielles (nesp)
  real(krp)       :: pressure   ! pression
  type(v3d)       :: velocity   ! vitesse
endtype st_nsetat

!------------------------------------------------------------------------------!
! D�finition de la structure ST_ESPECE : D�finition d'une esp�ce de gaz
!------------------------------------------------------------------------------!
type st_espece
  real(krp)    :: gamma         ! rapport de chaleurs sp�cifiques
  real(krp)    :: prandtl       ! nombre de Prandtl
  real(krp)    :: visc_dyn      ! viscosit� dynamique (faire �voluer en loi)
endtype st_espece

! -- INTERFACES -------------------------------------------------------------

!interface new
!  module procedure new_mesh, new_field, new_block, new_zone
!endinterface

!interface delete
!  module procedure delete_mesh, delete_field, delete_block, delete_zone
!endinterface


! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
!contains



!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure FIELD
!------------------------------------------------------------------------------!
!subroutine delete_field(field)
!implicit none
!type(st_field) :: field

!  deallocate(etat)
!  if (allocated(gradient)) deallocate(gradient)

!endsubroutine delete_field



!------------------------------------------------------------------------------!
! Proc�dure : allocation d'une structure BLOCK
!------------------------------------------------------------------------------!
!subroutine new_block(block, idim, jdim, kdim, allocgrad)
!implicit none
!type(st_block) :: block             ! block � cr�er
!integer        :: idim, jdim, kdim  ! dimension du maillage interne
!logical        :: allocgrad         ! allocation des gradients

!  block%idim = idim
!  block%jdim = idim
!  block%kdim = idim

!  call new(block%mesh,  idim, jdim, kdim)
!  call new(block%field, idim, jdim, kdim, allocgrad)

!  block%nconnect = 0        ! Initialisation des listes de connections
!  block%nbound   = 0        ! et de conditions aux limites
!  nullify(block%connect)
!  nullify(block%bound)

!endsubroutine new_block





endmodule EQNS
