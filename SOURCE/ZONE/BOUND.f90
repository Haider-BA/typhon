!------------------------------------------------------------------------------!
! MODULE : BOUND                          Auteur : J. Gressier
!                                         Date   : Octobre 2002
! Fonction                                Modif  :
!   Bibliotheque de procedures et fonctions pour la gestion des champs
!   des diff�rents solveurs
!
! Defauts/Limitations/Divers :
! Historique :
!
!------------------------------------------------------------------------------!

module BOUND

use TYPHMAKE   ! Definition de la precision
!use EQNS      ! Definition des champs pour �quations de Navier-Stokes
use EQKDIF      ! D�finition des champs pour �quations de diffusion

implicit none

! -- Variables globales du module -------------------------------------------



! -- DECLARATIONS -----------------------------------------------------------



!------------------------------------------------------------------------------!
! D�finition de la structure ST_BOUND : Champ physique 
!------------------------------------------------------------------------------!

type st_bound
  integer      :: idim, jdim, kdim       ! indices max des cellules 
                                                              ! n dimension spatiale
endtype st_bound



! -- INTERFACES -------------------------------------------------------------

interface new
  module procedure new_bound
endinterface

interface delete
  module procedure delete_bound
endinterface


! -- Fonctions et Operateurs ------------------------------------------------



! -- IMPLEMENTATION ---------------------------------------------------------
contains


!------------------------------------------------------------------------------!
! Proc�dure : allocation d'une structure BOUND
!------------------------------------------------------------------------------!
subroutine new_bound(bound, idim, jdim, kdim)
implicit none
type(st_bound) :: bound             ! champ � cr�er
integer        :: idim, jdim, kdim  ! dimension du champ interne
logical        :: allocgrad         ! allocation des gradients
integer        :: imin, jmin, kmin
integer        :: imax, jmax, kmax

  bound%idim     = idim
  bound%jdim     = jdim
  bound%kdim     = kdim

endsubroutine new_bound


!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure BOUND
!------------------------------------------------------------------------------!
subroutine delete_bound(bound)
implicit none
type(st_bound) :: bound


endsubroutine delete_bound





endmodule BOUND
