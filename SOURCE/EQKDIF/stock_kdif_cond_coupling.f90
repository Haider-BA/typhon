!------------------------------------------------------------------------------!
! Procedure :  stock_kdif_cond_coupling   Auteur : E. Radenac
!                                         Date   : Mai 2003
! Fonction                                Modif  : Juin 2003
!   Attribution de ses conditions aux limites de couplage � une zone.
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine stock_kdif_cond_coupling(bocokdif, temp, flux, if)

use TYPHMAKE
use OUTPUT
use DEFFIELD
use MENU_KDIF

implicit none

! -- Declaration des entr�es --
real(krp) :: temp     ! temp�rature attribu�e
real(krp) :: flux     ! flux attribu�
integer ::   if       ! indice de la face concern�e

! -- Declaration des entr�es/sorties --
type(st_boco_kdif) :: bocokdif ! stockage des conditions

! -- Declaration des variables internes --

! -- Debut de la procedure --

bocokdif%temp(if) = temp
bocokdif%flux_nunif(if) = flux



endsubroutine stock_kdif_cond_coupling
