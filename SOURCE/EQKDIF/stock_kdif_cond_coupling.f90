!------------------------------------------------------------------------------!
! Procedure :  stock_kdif_cond_coupling   Auteur : E. Radenac
!                                         Date   : Mai 2003
! Fonction                                Modif  : Juin 2003
!   Attribution de ses conditions aux limites de couplage � une zone.
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine stock_kdif_cond_coupling(conditions_coupling, temp, flux, if)

use TYPHMAKE
use OUTPUT
use DEFFIELD

implicit none

! -- Declaration des entr�es --
real(krp) :: temp     ! temp�rature attribu�e
real(krp) :: flux     ! flux attribu�
integer ::   if       ! indice de la face concern�e

! -- Declaration des entr�es/sorties --
type(st_genericfield) :: conditions_coupling ! stockage des conditions

! -- Declaration des variables internes --

! -- Debut de la procedure --

conditions_coupling%tabscal(1)%scal(if) = temp
conditions_coupling%tabscal(2)%scal(if) = flux

endsubroutine stock_kdif_cond_coupling
