!------------------------------------------------------------------------------
! Procedure : correction                  Auteur : E. Radenac
!                                         Date   : F�vrier 2004
! Fonction                                Modif  :
!   Application de la correction cumul�e de bilan de flux
!
! Defauts/Limitations/Divers : 
!------------------------------------------------------------------------------

subroutine correction(zone1, zone2, nfacelim, corcoef, nbc1, nbc2, ncoupl1, &
                      ncoupl2, part_cor1, part_cor2, typ_cor1, typ_cor2, &
                      fincycle)
 
use OUTPUT
use VARCOM
use DEFZONE
use DEFFIELD
use GEO3D
use TYPHMAKE

implicit none

! -- Declaration des entr�es --
integer                    :: nfacelim            ! nombre de faces limites
real(krp), dimension(nfacelim) &
                           :: corcoef   ! coefficient de correction de flux
integer                    :: nbc1, nbc2 ! indice des conditions aux limites 
integer                    :: ncoupl1, ncoupl2 ! num�ro (identit�) du raccord
real(krp)                  :: part_cor1, part_cor2 ! part de la correction � 
                                                ! apporter, dans les deux zones
integer                    :: typ_cor1, typ_cor2 ! type de correction
logical                    :: fincycle

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

if ( (typ_cor1.ne.bocoT) .and. (typ_cor1.ne.repart_reg) .and. &
     (typ_cor1.ne.repart_geo) )then

  call corr_varprim(zone1%grid%field_loc, &
                    zone1%grid%umesh, &
                    zone1%defsolver, &
                    zone1%coupling(ncoupl1)%zcoupling%etatcons, nbc1, &
                    part_cor1, typ_cor1, fincycle)

  call corr_varprim(zone2%grid%field_loc, &
                    zone2%grid%umesh, &
                    zone2%defsolver, &
                    zone2%coupling(ncoupl2)%zcoupling%etatcons, nbc2, &
                    part_cor2, typ_cor2, fincycle)
endif

endsubroutine correction

!------------------------------------------------------------------------------
! Historique des modifications
!
! fev  2004 : cr�ation de la proc�dure
! avr  2004 : changement de structure (MGRID) : limit� � une grille
! oct  2004 : field chained list
!------------------------------------------------------------------------------
