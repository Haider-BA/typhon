!------------------------------------------------------------------------------
! Procedure : correction                  Auteur : E. Radenac
!                                         Date   : F�vrier 2004
! Fonction                                Modif  :
!   Application de la correction cumul�e de bilan de flux
!
! Defauts/Limitations/Divers : 
!------------------------------------------------------------------------------

subroutine correction(zone1, zone2, nfacelim, corcoef, nbc1, nbc2, ncoupl1, ncoupl2)

use OUTPUT
use VARCOM
use DEFZONE
use DEFFIELD
use GEO3D
use TYPHMAKE

implicit none

! -- Declaration des entr�es --
integer                    :: nfacelim            ! nombre de faces limites
real(krp)                  :: corcoef   ! coefficient de correction de flux
integer                    :: nbc1, nbc2 ! indice des conditions aux limites 
integer                    :: ncoupl1, ncoupl2 ! num�ro (identit�) du raccord

! -- Declaration des sorties --
type(st_zone)              :: zone1, zone2

! -- Declaration des variables internes --
integer                        :: ifield

! -- Debut de la procedure --

! Suppl�ment de flux pour �ch. espac�s : calcul de la diff�rence � appliquer

call calcdifflux(zone1%coupling(ncoupl1)%zcoupling%etatcons%tabscal, &
                  zone2%coupling(ncoupl2)%zcoupling%etatcons%tabscal, &
                  nfacelim, zone1%coupling(ncoupl1)%zcoupling%solvercoupling, &
                  corcoef, zone2%coupling(ncoupl2)%zcoupling%connface )

! Calcul des variables primitives avec correction de flux
do ifield = 1, zone1%ndom
  call corr_varprim(zone1%field(ifield), &
                    zone1%ust_mesh, &
                    zone1%defsolver, &
                    zone1%coupling(ncoupl1)%zcoupling%etatcons, nbc1)
enddo

do ifield = 1, zone2%ndom
  call corr_varprim(zone2%field(ifield), &
                    zone2%ust_mesh, &
                    zone2%defsolver, &
                    zone2%coupling(ncoupl2)%zcoupling%etatcons, nbc2)
enddo

endsubroutine correction

!------------------------------------------------------------------------------
! Historique des modifications
!
! f�vrier 2004 : cr�ation de la proc�dure
!------------------------------------------------------------------------------
