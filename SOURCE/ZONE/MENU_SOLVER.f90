!------------------------------------------------------------------------------!
! MODULE : MENU_SOLVER                    Auteur : J. Gressier
!                                         Date   : Aout 2002
! Fonction                                Modif  : Mars 2003 (cf Historique)
!   D�finition des structures pour les entr�es du programme TYPHON
!   Structures pour les options des solveurs 
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
module MENU_SOLVER

use TYPHMAKE   ! Definition de la precision
!use MENU_NS   ! D�finition des solveurs type NS
use MENU_KDIF ! D�finition des solveurs type Equation de diffusion
use MENU_BOCO
use MENU_INIT

implicit none

! -- Variables globales du module -------------------------------------------

! -- D�finition des entiers caract�ristiques pour le type de solveur --
!integer, parameter :: solNS   = 10   (d�finis dans VARCOM)
!integer, parameter :: solKDIF = 20 

! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! structure MNU_SOLVER : options num�riques les solveurs 
!------------------------------------------------------------------------------!
type mnu_solver
  integer         :: typ_solver      ! type de solveur (cf definitions VARCOM) 
  integer         :: nequat          ! nombre d'�quations
  !type(mnu_ns)    :: defns          ! options si solveur NS
  type(mnu_kdif)  :: defkdif        ! options si solveur KDIF
  integer         :: nboco           ! nombre de conditions aux limites
  type(mnu_boco), dimension(:), pointer &
                  :: boco            ! d�finitions des conditions aux limites
  integer         :: ninit           ! nombre de conditions aux limites
  type(mnu_init), dimension(:), pointer &
                  :: init            ! d�finitions des conditions aux limites
endtype mnu_solver


! -- INTERFACES -------------------------------------------------------------

interface delete
  module procedure delete_mnu_solver
endinterface

! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
contains

!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure MNU_SOLVER
!------------------------------------------------------------------------------!
subroutine delete_mnu_solver(defsolver)
implicit none
type(mnu_solver)  :: defsolver

  print*,'!! DEBUG destruction de structure "param�tres" � compl�ter'
  call delete(defsolver%defkdif%materiau%Kd)
  if (defsolver%nboco>1) then
  deallocate(defsolver%boco)
  endif
  if (defsolver%ninit>1) then
  deallocate(defsolver%init)
  endif
  
endsubroutine delete_mnu_solver



endmodule MENU_SOLVER


!------------------------------------------------------------------------------!
! Historique des modifications
!
! aout 2002 (v0.0.1b): cr�ation du module
! mars 2003          : ajout des conditions aux limites
!                      ajout des structures d'initialisation
!
! am�liorations futures : impl�menter les proc�dures delete
!------------------------------------------------------------------------------!




