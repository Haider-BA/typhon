!------------------------------------------------------------------------------!
! MODULE : MENU_ZONECOUPLING              Auteur : E. Radenac / J. Gressier
!                                         Date   : Juin 2003
! Fonction                                Modif  :
!   D�finition des m�thodes de couplage entre zones
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module MENU_ZONECOUPLING

use TYPHMAKE   ! Definition de la precision et des types basiques
use DEFFIELD   ! D�finition des champs de valeurs physiques pour les transferts
use ZONE_COUPLING

! -- DECLARATIONS -----------------------------------------------------------

!------------------------------------------------------------------------------!
! D�finition de la structure MNU_ZONECOUPLING : structures d'�changes entres zones
!------------------------------------------------------------------------------!
type mnu_zonecoupling
  character(len=strlen)      :: family     ! nom de famille de la CL
  character(len=strlen)      :: connzone   ! nom de la zone connect�e par ce raccord
  character(len=strlen)      :: connfam    ! nom de famille de la CL connect�e
                                           ! par ce raccord
  type(st_zonecoupling)      :: zcoupling  ! param�tres de couplage
  real(krp)                  :: partcor    ! part de correction � faire par 
                                           ! it�ration <=1
  integer                    :: typ_cor    ! type de r�partition de correction
endtype mnu_zonecoupling

! -- INTERFACES -------------------------------------------------------------

interface delete
  module procedure delete_zonecoupling
endinterface

! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
contains


!------------------------------------------------------------------------------!
! Proc�dure : desallocation d'une structure MNU_ZONECOUPLING
!------------------------------------------------------------------------------!
subroutine delete_zonecoupling(zcoupl)
implicit none
type(mnu_zonecoupling)  :: zcoupl

call delete(zcoupl%zcoupling)

endsubroutine delete_zonecoupling

endmodule MENU_ZONECOUPLING

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juin 2003 (v0.0.1b): cr�ation du module
!                      cr�ation de delete
!------------------------------------------------------------------------------!


