!------------------------------------------------------------------------------!
! Procedure : integration_cycle           Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  : (cf Historique)
!   Int�gration de cycle pour toutes les zones
!   Gestion des communications et couplages entre zones
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine integration_cycle(lworld, excht, ncoupling)

use TYPHMAKE
use OUTPUT
use VARCOM
use MODWORLD

implicit none

! -- Declaration des entr�es --
integer                 :: ncoupling        ! nombre de couplages
real(krp), dimension(1:ncoupling) :: excht  ! instant d'�change (pour les diff�rents couplages de zones)

! -- Declaration des entr�es/sorties --
type(st_world) :: lworld

! -- Declaration des sorties --

! -- Declaration des variables internes --
real(krp) :: mdt              ! pas de temps macro (sens physique)
integer   :: izone, ir, ifield, if
integer   :: iz1, iz2, ic, ncoupl1, ncoupl2, ib, nbc1, nbc2

! -- Debut de la procedure --

! PROVISOIRE pour compatibilit� - � effacer
mdt = lworld%prj%dtbase

! allocation des champs de r�sidus
!do izone = 1, lworld%prj%nzone
!  do if = 1, lworld%zone(izone)%ndom
!    call alloc_res(lworld%zone(izone)%field(if))
!  enddo
!enddo

if (ncoupling > 0) then

do ir = 1, ncoupling

  if (lworld%info%curtps >= excht(ir)) then

    ! calcul des donn�es de raccord : indices de raccord, de CL pour les deux zones coupl�es
    call calcul_raccord(lworld, ir, iz1, iz2, ncoupl1, ncoupl2, nbc1, nbc2)

    ! appel proc�dure d'�change
    call echange_zonedata(lworld,ir, iz1, iz2, ncoupl1, ncoupl2, nbc1, nbc2)

    ! r�initialisation � 0 des tableaux de cumul de flux pour la correction de flux
    lworld%zone(iz1)%coupling(ncoupl1)%zcoupling%etatcons%tabscal(1)%scal(:) = 0._krp
    lworld%zone(iz2)%coupling(ncoupl2)%zcoupling%etatcons%tabscal(1)%scal(:) = 0._krp

! DVT : impl�menter un choix de correction apr�s (ou avt) l'echange 
!       ou supprimer ce cas.
!    ! Calcul des variables primitives avec correction de flux
!    do ifield = 1, lworld%zone(iz1)%ndom
!      call corr_varprim(lworld%zone(iz1)%field(ifield), &
!                        lworld%zone(iz1)%ust_mesh, &
!                        lworld%zone(iz1)%defsolver, &
!                        lworld%zone(iz1)%coupling(ncoupl1)%zcoupling%etatcons, nbc1)
!    enddo
!
!    do ifield = 1, lworld%zone(iz2)%ndom
!      call corr_varprim(lworld%zone(iz2)%field(ifield), &
!                        lworld%zone(iz2)%ust_mesh, &
!                        lworld%zone(iz2)%defsolver, &
!                        lworld%zone(iz2)%coupling(ncoupl2)%zcoupling%etatcons, nbc2)
!    enddo

    ! calcul du nouvel instant d'�change
    excht(ir) = excht(ir) + lworld%coupling(ir)%n_tpsbase * mdt

  endif

enddo

endif


!------------------------------------------------------------------------------------------------------------
! DVT : comparaison des flux � l'interface.
!------------------------------------------------------------------------------------------------------------

! Calcul des conditions aux limites pour le calcul des flux � l'interface

do izone = 1, lworld%prj%nzone
 call conditions_limites(lworld%zone(izone))
enddo

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

!-----------------------------------------------------------------------------------------------------

! --------------------------------------------
! Int�gration d'un cycle de chacune des zones 
! --------------------------------------------

do izone = 1, lworld%prj%nzone
 
  ! -- Initialisation des infos pour le cycle

  lworld%zone(izone)%info%typ_temps = lworld%prj%typ_temps

  select case(lworld%prj%typ_temps)

  case(stationnaire)
    lworld%zone(izone)%info%residumax  = lworld%prj%residumax 
    lworld%zone(izone)%info%residu_ref = lworld%info%residu_ref

  case(instationnaire)
    lworld%zone(izone)%info%cycle_dt = lworld%prj%dtbase

  case(periodique)

  endselect

  !-------------------------------------
  ! changement de nom en integration_cycle_zone ?
  call integrationmacro_zone(lworld%zone(izone))
  !-------------------------------------

  ! -- Retour d'informations d'int�gration du cycle

  lworld%zone(izone)%info%typ_temps = lworld%prj%typ_temps

  select case(lworld%prj%typ_temps)

  case(stationnaire)
    lworld%info%cur_res    = lworld%zone(izone)%info%cur_res
    lworld%info%residu_ref = max(lworld%info%residu_ref, lworld%zone(izone)%info%residu_ref)

  case(instationnaire)
    lworld%zone(izone)%info%cycle_dt = lworld%prj%dtbase

  case(periodique)

  endselect
  ! do if = 1, lworld%zone(izone)%ndom
  !   call dealloc_res(lworld%zone(izone)%field(if))
  ! enddo
enddo


!-------------------------------------
endsubroutine integration_cycle

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juil  2002 : cr�ation de la proc�dure
! mai   2003 : proc�dures d'�change
! juil  2003 : ajout de corrections de flux lors de couplage
!              allocation des residus globale pour tous les cycles
! sept  2003 : changement de nom de la proc�dure (ancien: integration_macrodt)
!              gestion du calcul selon r�sidus 
!------------------------------------------------------------------------------!
