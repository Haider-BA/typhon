!------------------------------------------------------------------------------!
! MODULE : EQKDIF                         Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  :
!   Bibliotheque de procedures et fonctions pour la d�finition des �tats
!   dans une �quation de diffusion
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module EQKDIF

use TYPHMAKE   ! Definition de la precision
use OUTPUT
use MENU_KDIF
use MATERIAU

! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! D�finition de la structure ST_KDIFETAT : �tat physique
!------------------------------------------------------------------------------!
type st_kdifetat
  !real(krp), dimension(:), pointer &
  real(krp)       :: temperature    ! temp�ratures (nbtemp)
endtype st_kdifetat

! -- INTERFACES -------------------------------------------------------------

!interface new
!  module procedure new_mesh, new_field, new_block, new_zone
!endinterface

!interface delete
!  module procedure delete_mesh, delete_field, delete_block, delete_zone
!endinterface


! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
contains



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


!------------------------------------------------------------------------------!
! Fonction : conversion de variables conservatives en variables primitives
!------------------------------------------------------------------------------!
type(st_kdifetat) function cons2kdif(defkdif, etat)
implicit none
! d�claration des entr�es
type(mnu_kdif)          :: defkdif
real(krp), dimension(*) :: etat

  select case(defkdif%materiau%type)
  case(mat_LIN, mat_KNL)
    cons2kdif%temperature = etat(1)/defkdif%materiau%Cp
  case(mat_XMAT)
    call erreur("Calcul de mat�riau","Materiau non lin�aire interdit")
  endselect

endfunction cons2kdif


endmodule EQKDIF
