!------------------------------------------------------------------------------!
! Procedure : integration                 Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  : (cf historique)
!   Integration totale jusqu'au crit�re d'arr�t du calcul
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
 
subroutine integration(lworld)

use TYPHMAKE
use STRING
use OUTPUT
use VARCOM
use MODWORLD

implicit none

! -- Declaration des entr�es/sorties --
type(st_world) :: lworld

! -- Declaration des entr�es --

! -- Declaration des sorties --

! -- Declaration des variables internes --
type(st_grid), pointer :: pgrid
!real(krp)             :: macro_dt
integer, dimension(:), allocatable &
                       :: exchcycle ! indices des cycles d'�change pour les diff�rents couplages de zones
integer                :: ir, izone, if, ib, ic
integer                :: iz1, iz2, ncoupl1, ncoupl2, nbc1, nbc2

! -- Debut de la procedure --

!macro_dt        = lworld%prj%dtbase

! initialisation

lworld%info%icycle          = 0
lworld%info%curtps          = 0._krp
lworld%info%residu_ref      = 1._krp
lworld%info%fin_integration = .false.

! Allocation du tableau des inidices de cycle d'�change pour les calculs coupl�s
allocate(exchcycle(lworld%prj%ncoupling))
exchcycle(:) = 1 ! initialisation � 1 : 1er �change au 1er cycle, � partir des conditions initiales


! allocation des champs de r�sidus et gradients

do izone = 1, lworld%prj%nzone
  pgrid => lworld%zone(izone)%grid
  do while (associated(pgrid))
    call alloc_res(pgrid%field)
    !! DEV : l'allocation ne doit se faire que dans certains cas
    call alloc_grad(pgrid%field)
    pgrid => pgrid%next
  enddo
enddo

! Faire appel � une subroutine contenant l'�criture
!------------------------------------------------------------------------------------------------
! DVT : Ouverture du fichier de comparaison des flux � l'interface
!------------------------------------------------------------------------------------------------
!if (lworld%prj%ncoupling > 0) then
!  open(unit = uf_compflux, file = "compflux.dat", form = 'formatted')
!  write(uf_compflux, '(a)') 'VARIABLES="t","F1","F2", "ERREUR", "Fcalcule", "ERRCALC"'
!endif


!--------------------------------------------------------
! INTEGRATION
!--------------------------------------------------------
do while (.not. lworld%info%fin_integration)

  lworld%info%icycle = lworld%info%icycle + 1

  ! -- �criture d'informations en d�but de cycle --

  select case(lworld%prj%typ_temps)
  case(stationnaire)
    str_w = "* CYCLE "//strof(lworld%info%icycle)
    !write(str_w,'(a,a)') "* CYCLE ",strof(lworld%info%icycle,3)
  case(instationnaire)
    write(str_w,'(a,i5,a,g10.4)') "* CYCLE", lworld%info%icycle, &
                                  " : t = ",  lworld%info%curtps
  case(periodique)
    write(str_w,'(a,i5)') "* CYCLE", lworld%info%icycle
  endselect

  call print_info(6,str_w)

  ! -- int�gration d'un cycle --

  call integration_cycle(lworld, exchcycle, lworld%prj%ncoupling)  
  
  ! -- Actualisation des conditions aux limites au raccord
  ! PROVISOIREMENT tout � condition de Dirichlet
  do izone = 1, lworld%prj%nzone
    ! Boucle sur les conditiosn aux limites et sur les couplages pour
    ! rep�rer les conditions correspondant � des raccords
    do ib = 1, lworld%zone(izone)%grid%umesh%nboco
      do ic = 1, lworld%zone(izone)%ncoupling
        if(samestring(lworld%zone(izone)%coupling(ic)%family, &
           lworld%zone(izone)%grid%umesh%boco(ib)%family)) then
          lworld%zone(izone)%defsolver%boco(lworld%zone(izone)%grid%umesh%boco(ib)%idefboco)%typ_boco = bc_wall_isoth
        endif
      enddo
    enddo
  enddo

  ! -- �criture d'informations en fin de cycle --

  select case(lworld%prj%typ_temps)

  case(stationnaire)
    write(str_w,'(a,g10.4)') "  R�sidu de cycle = ", log10(lworld%info%cur_res/lworld%info%residu_ref)
    if (lworld%info%cur_res/lworld%info%residu_ref <= lworld%prj%residumax) then
      lworld%info%fin_integration = .true.
    endif

  case(instationnaire)
    lworld%info%curtps = lworld%info%curtps + lworld%prj%dtbase
    if (lworld%info%curtps >= lworld%prj%duree) lworld%info%fin_integration = .true.
    write(str_w,'(a)') " "

  case(periodique)
    lworld%info%fin_integration = .true.

  endselect

  call print_info(6,str_w)

enddo

! Mise � jour des variables primitives
do izone = 1, lworld%prj%nzone
  call calc_varprim(lworld%zone(izone)%defsolver, lworld%zone(izone)%grid%field)
enddo

! Mise � jour des conditions aux limites, notamment de couplage pour l'affichage des donn�es :
if (lworld%prj%ncoupling > 0) then
  do ir = 1, lworld%prj%ncoupling
      call calcul_raccord(lworld, ir, iz1, iz2, ncoupl1, ncoupl2, nbc1, nbc2)
      call echange_zonedata(lworld,ir, iz1, iz2, ncoupl1, ncoupl2, nbc1, nbc2) 
  enddo
endif

do izone = 1, lworld%prj%nzone
 call conditions_limites(lworld%zone(izone))
enddo


!-----------------------------------------------------------------------------------------------------------------------
! DVT : Fermeture du fichier de comparaison des flux � l'interface
!-----------------------------------------------------------------------------------------------------------------------
!if (lworld%prj%ncoupling > 0) then
  close(uf_compflux)
!endif
!-----------------------------------------------------------------------------------------------------------------------

! D�sallocation du tableau d'indice de cycle d'�change pour le calcul coupl� :
deallocate(exchcycle)

do izone = 1, lworld%prj%nzone
 select case(lworld%zone(izone)%defsolver%typ_solver)    ! DEV : en attendant homog�n�isation
 case(solKDIF)                                           ! de l'acc�s des champs dans 
   call dealloc_res(lworld%zone(izone)%grid%field)       ! les structures MGRID
   call dealloc_grad(lworld%zone(izone)%grid%field)
 case(solVORTEX)
 endselect
enddo

endsubroutine integration

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juil 2002 : cr�ation de la proc�dure
! juin 2003 : instant d'�change excht
!             mise � jour des CL pour le fichier de sortie
! sept 2003 : gestion du calcul par r�sidus (optionnel) + r�organisation
! oct  2003 : remplacement d'instant d'�change excht par indice de cycle d'�change
!              exchcycle
! avr  2004 : integration des structures MGRID pour tous les solveurs
!------------------------------------------------------------------------------!
