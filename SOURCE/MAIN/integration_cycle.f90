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
subroutine integration_cycle(lworld, exchcycle, ncoupling)
 
use TYPHMAKE
use OUTPUT
use VARCOM
use MODWORLD

implicit none

! -- Declaration des entr�es --
integer                         :: ncoupling  ! nombre de couplages
integer, dimension(1:ncoupling) :: exchcycle  ! indice du cycle d'�change
                                              ! (pour les diff�rents couplages de zones)

! -- Declaration des entr�es/sorties --
type(st_world) :: lworld

! -- Declaration des sorties --

! -- Declaration des variables internes --
integer   :: izone, ir, ifield, if
integer   :: iz1, iz2, ic, ncoupl1, ncoupl2, ib, nbc1, nbc2

! -- Debut de la procedure --


! allocation des champs de r�sidus
!do izone = 1, lworld%prj%nzone
!  do if = 1, lworld%zone(izone)%ndom
!    call alloc_res(lworld%zone(izone)%field(if))
!  enddo
!enddo

! -- Proc�dure d'�change, en d�but de cycle

if (ncoupling > 0) then

do ir = 1, ncoupling

  if (lworld%info%icycle.eq.exchcycle(ir)) then

    ! calcul des donn�es de raccord : indices de raccord, de CL pour 
    ! les deux zones coupl�es
    call calcul_raccord(lworld, ir, iz1, iz2, ncoupl1, ncoupl2, nbc1, nbc2)

    ! appel proc�dure d'�change
    call echange_zonedata(lworld,ir, iz1, iz2, ncoupl1, ncoupl2, nbc1, nbc2)

    select case(lworld%prj%typ_temps)
     
     case(instationnaire)
     ! r�initialisation � 0 des tableaux de cumul de flux pour la correction 
     ! de flux
     print*, "correction de flux", lworld%zone(iz1)%coupling(ncoupl1)%zcoupling%etatcons%tabscal(1)%scal(1), &
             lworld%zone(iz1)%coupling(ncoupl1)%zcoupling%etatcons%tabscal(2)%scal(1), &
             lworld%zone(iz1)%coupling(ncoupl1)%zcoupling%etatcons%tabscal(3)%scal(1)
     lworld%zone(iz1)%coupling(ncoupl1)%zcoupling%etatcons%tabscal(1)%scal(:) = 0._krp
     lworld%zone(iz2)%coupling(ncoupl2)%zcoupling%etatcons%tabscal(1)%scal(:) = 0._krp

    endselect

    ! calcul du nouvel instant d'�change
    exchcycle(ir) = exchcycle(ir) + lworld%coupling(ir)%n_tpsbase

  endif

enddo

call output_result(lworld, in_cycle) !DEV2602

endif


!------------------------------------------------------------------------------
! DVT : comparaison des flux � l'interface.
!------------------------------------------------------------------------------
!
! Calcul des conditions aux limites pour le calcul des flux � l'interface
!
!do izone = 1, lworld%prj%nzone
! call conditions_limites(lworld%zone(izone))
!enddo
!
!if (lworld%prj%ncoupling > 0) then
!
!ir =1 ! DVT : provisoire
!    
! calcul des donn�es de raccord : indices de raccord, de CL pour les 
! deux zones coupl�es

!call calcul_raccord(lworld, ir, iz1, iz2, ncoupl1, ncoupl2, nbc1, nbc2)
!
!call comp_flux(lworld%zone(iz1), lworld%zone(iz2), nbc1, nbc2, lworld%zone(iz1)%ust_mesh%boco(nbc1)%nface,  &
!                    lworld%info%curtps, ncoupl1)
!endif
!

!------------------------------------------------------------------------------

! --------------------------------------------
! Int�gration d'un cycle de chacune des zones 
! --------------------------------------------

! -- Initialisation du r�sidu courant de world � 0 :
lworld%info%cur_res = 0

do izone = 1, lworld%prj%nzone
 
  ! -- Initialisation des infos pour le cycle

  lworld%zone(izone)%info%iter_tot  = 0
  lworld%zone(izone)%info%typ_temps = lworld%prj%typ_temps

  select case(lworld%prj%typ_temps)

  case(stationnaire)
    lworld%zone(izone)%info%residumax  = lworld%zone(izone)%deftime%maxres
    lworld%zone(izone)%info%residu_ref = 0._krp

  case(instationnaire)
    lworld%zone(izone)%info%cycle_dt = lworld%prj%dtbase

  case(periodique)

  endselect

  !-------------------------------------
  ! changement de nom en integration_cycle_zone ?
  call integrationmacro_zone(lworld%zone(izone))
  !-------------------------------------

  ! -- Initialisation de residu_reforigine : valeur du r�sidu de r�f�rence 
  !    du premier cycle pour chaque zone.
  if(lworld%info%icycle.eq.1) then
    lworld%zone(izone)%info%residu_reforigine = lworld%zone(izone)%info%residu_ref
  endif

  ! -- Retour d'informations d'int�gration du cycle

  lworld%zone(izone)%info%typ_temps = lworld%prj%typ_temps

  select case(lworld%prj%typ_temps)

  case(stationnaire)

   
  ! On attribue les residus courant et de r�f�rence de la zone la moins avanc�e, c'est-�-dire
  ! celle dont le rapport (residu courant/residu de r�f�rence (d'origine)) est le plus grand.
  ! Ainsi, la fin est atteinte quand toutes les zones ont vu leur r�sidu diminuer de la valeur
  ! voulue au moins.

    if( (lworld%zone(izone)%info%cur_res / lworld%zone(izone)%info%residu_reforigine) &
        .ge.(lworld%info%cur_res / lworld%info%residu_ref) ) then
      lworld%info%cur_res    = lworld%zone(izone)%info%cur_res
      lworld%info%residu_ref = lworld%zone(izone)%info%residu_reforigine !max(lworld%info%residu_ref, lworld%zone(izone)%info%residu_ref)
    endif

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
! juil 2002 : cr�ation de la proc�dure
! mai  2003 : proc�dures d'�change
! juil 2003 : ajout de corrections de flux lors de couplage
!             allocation des residus globale pour tous les cycles
! sept 2003 : changement de nom de la proc�dure (ancien: integration_macrodt)
!             gestion du calcul selon r�sidus 
! oct  2003 : suppression correction de flux APRES
! oct  2003 : remplacement instant d'�change excht par cycle d'�change exchcycle
! oct  2003 : modification de la gestion selon r�sidus pour le calcul stationnaire 
!             multizone.
! oct  2003 : corrections de flux seulement en instationnaire
!------------------------------------------------------------------------------!
