!------------------------------------------------------------------------------!
! Procedure : integration_macrodt         Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  : Juin 2003
!   Int�gration de toutes les donn�es sur un �cart de temps donn�,
!   identique pour toutes les zones, et avec une repr�sentation
!   physique uniquement
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine integration_macrodt(mdt, lworld, excht, ncoupling, enrtps)

use TYPHMAKE
use OUTPUT
use VARCOM
use MODWORLD

implicit none

! -- Declaration des entr�es --
integer                 :: ncoupling          ! nombre de couplages
real(krp)               :: mdt                ! pas de temps macro (sens physique)
real(krp), dimension(1:ncoupling) :: excht      ! instant d'�change (pour les diff�rents couplages de zones)
real(krp)               :: enrtps

! -- Declaration des entr�es/sorties --
type(st_world) :: lworld

! -- Declaration des sorties --

! -- Declaration des variables internes --
integer   :: izone, ir
integer   :: iz1, iz2, ic, ncoupl1, ncoupl2, ib, nbc1, nbc2
! -- Debut de la procedure --

if (ncoupling > 0) then
do ir = 1, ncoupling
  if (lworld%info%curtps >= excht(ir)) then
    call echange_zonedata(lworld,ir)
    excht(ir) = excht(ir) + lworld%coupling(ir)%n_tpsbase * mdt
  endif
enddo
endif

do izone = 1, lworld%prj%nzone
 call conditions_limites(lworld%zone(izone))
enddo

!if (lworld%info%curtps >= enrtps) then
!  call output_result(lworld)
!endif

!------------------------------------------------------------------------------------------------------------
! DVT : comparaison des flux � l'interface.
!------------------------------------------------------------------------------------------------------------
if (lworld%prj%ncoupling > 0) then

ir =1 ! DVT : provisoire

! D�termination des num�ros des zones coupl�es
iz1 = lworld%coupling(ir)%zone1
iz2 = lworld%coupling(ir)%zone2
  
! D�termination des num�ros du raccord pour les zones 1 et 2
do ic = 1, lworld%zone(iz1)%ncoupling
  if (samestring(lworld%zone(iz1)%coupling(ic)%connzone, lworld%zone(iz2)%nom)) then
    ncoupl1 = ic
  endif
enddo

do ic = 1, lworld%zone(iz2)%ncoupling
  if (samestring(lworld%zone(iz2)%coupling(ic)%connzone, lworld%zone(iz1)%nom)) then
    ncoupl2 = ic
  endif
enddo

! D�termination des indices de condition aux limites pour les zones 1 et 2
do ib = 1, lworld%zone(iz1)%ust_mesh%nboco
  if (samestring(lworld%zone(iz1)%coupling(ncoupl1)%family, lworld%zone(iz1)%ust_mesh%boco(ib)%family)) then
    nbc1 = ib
  endif
enddo
  
do ib = 1, lworld%zone(iz2)%ust_mesh%nboco
  if (samestring(lworld%zone(iz2)%coupling(ncoupl2)%family, lworld%zone(iz2)%ust_mesh%boco(ib)%family)) then
    nbc2 = ib
  endif
enddo

call comp_flux(lworld%zone(iz1), lworld%zone(iz2), nbc1, nbc2, lworld%zone(iz1)%ust_mesh%boco(nbc1)%nface,  &
                    lworld%info%curtps, ncoupl1)
endif

!------------------------------------------------------------------------------------------------------------------

do izone = 1, lworld%prj%nzone
 call integrationmacro_zone(mdt, lworld%zone(izone))
enddo

endsubroutine integration_macrodt
