!------------------------------------------------------------------------------!
! Procedure : integration_cyclezone       Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction
!   Integration d'une zone sur un ecart de temps donne,
!   d'une representation physique uniquement
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine integration_cyclezone(lzone, wres_ref, wcur_res)

use TYPHMAKE
use OUTPUT
use VARCOM
use DEFZONE
use DEFFIELD
use GEO3D
use MENU_GEN
use TIMER

implicit none

! -- INPUTS --
type(st_zone) :: lzone            ! zone a integrer
real(krp)   :: wres_ref           ! world reference residual
real(krp)   :: wcur_res           ! world current residual

! -- OUTPUTS --

! -- Internal variables --
real(krp)   :: dt                 ! pas de temps de la zone
integer     :: ic, ib, nbc        ! index de champ, couplage et boco
real(krp)   :: part_cor           ! part de correction a appliquer
real(krp)   :: dtmax, walltime
integer     :: typ_cor            ! type de correction
integer     :: itimer

!DEV
integer :: cumulreste, oui, non

! -- BODY --

!DEV
oui = 1
non = 2
cumulreste = oui

lzone%info%iter_loc    = 0
lzone%info%cur_res     = lzone%info%residu_ref   ! defined or initialized in integration_cycle
lzone%info%cycle_time  = 0._krp
lzone%info%end_cycle   = .false.

! -- CYCLE output header --

select case(lzone%info%time_model)

case(time_steady)
  write(str_w,'(a,i5)') "  zone",lzone%id
  call print_info(7,str_w)

case(time_unsteady)
  write(str_w,'(a,i5,a,g11.4)') "  zone",lzone%id," at time =",lzone%info%cycle_start
  call print_info(7,str_w)

case(time_unsteady_inverse)

case default
  call error_stop("internal error (integration_cyclezone): unknown time model")
endselect

! -- CYCLE initialization --

itimer = realtime_start()

!----------------------------------
! integration loop on timesteps
!----------------------------------

do while (.not.(lzone%info%end_cycle.or.lzone%info%stop_integration))

  lzone%info%iter_loc = lzone%info%iter_loc + 1
  lzone%info%iter_tot = lzone%info%iter_tot + 1

  select case(lzone%info%time_model)
  case(time_steady)
    dtmax = huge(dtmax)
  case(time_unsteady, time_unsteady_inverse)
    dtmax = lzone%info%cycle_dt - lzone%info%cycle_time
  case default
    call error_stop("internal error (integration_cyclezone): unknown time model")
  endselect

  !----------------------------------
  ! compute time step

  call calc_zonetimestep(lzone, dt, wres_ref, wcur_res, dtmax)

  !----------------------------------
  ! ecriture d'informations et gestion

  select case(lzone%info%time_model)
  case(time_steady)
  case(time_unsteady, time_unsteady_inverse)
    
    if (dt >= (lzone%info%cycle_dt - lzone%info%cycle_time)) then
      lzone%info%end_cycle = .true.
      dt  = lzone%info%cycle_dt - lzone%info%cycle_time
    endif
  case default
    call erreur("internal error (integration_cyclezone)", "unknown time model")
  endselect

  !-- DEV (coupling) -------------------------------------------------------
  ! Correction de flux quand necessaire
  ! PROVISOIRE A AMELIORER : correction seulement si KDIF
  if (lzone%defsolver%typ_solver == solKDIF) then
  do ic = 1, lzone%ncoupling
    part_cor = lzone%coupling(ic)%partcor
    typ_cor = lzone%coupling(ic)%typ_cor
    if ( (typ_cor.ne.sans).and.(typ_cor.ne.auto).and.(typ_cor.ne.partiel).and.&
         (typ_cor.ne.bocoT).and.(typ_cor.ne.avant).and.(typ_cor.ne.apres).and.&
         (typ_cor.ne.bocoT2) ) then !DEV1603
      ! Calcul de l'indice de condition aux limites
      do ib = 1, lzone%gridlist%first%umesh%nboco
        if (samestring(lzone%coupling(ic)%family, &
                       lzone%gridlist%first%umesh%boco(ib)%family)) nbc = ib
      enddo
      ! Correction de flux
      if (cumulreste == oui) then
        call corr_varprim(lzone%gridlist%first%field, lzone%gridlist%first%umesh, &
                          lzone%defsolver, &
                          lzone%coupling(ic)%zcoupling%etatcons, nbc, &
                          part_cor, typ_cor, .false.)
      else
        call corr_varprim(lzone%gridlist%first%field, lzone%gridlist%first%umesh, &
                          lzone%defsolver, &
                          lzone%coupling(ic)%zcoupling%etatcons, nbc, &
                          part_cor, typ_cor, lzone%info%end_cycle)
      endif
    endif
  enddo
  endif

  ! ---------------------------------------------------------------------------------------
  ! INTEGRATION

  select case(lzone%defsolver%typ_solver)

  case(solKDIF, solNS)
    call integzone_tstep_gridtree(dt, lzone)

  case default
    call erreur("internal error (integration_cyclezone)","unknown solver")
  endselect

  ! -------------------------------------------------------
  ! Write info and test end of cycle

  call check_end_cycle(lzone%info, dt)
  if (lzone%defsolver%deftime%maxit==lzone%info%iter_tot) then
    lzone%info%stop_integration = .true.
    call print_info(9,"    maximum number ("//trim(strof(lzone%info%iter_tot))//") of total iterations reached")
  endif
  lzone%info%end_cycle = lzone%info%end_cycle.or.lzone%info%stop_integration
  
  call write_monitors_iteration(lzone%info, &
                                lzone%info%end_cycle) ! 2nd argument to force output

enddo

walltime = realtime_stop(itimer)
call print_info(9,"    integration completed in "//trim(strof(lzone%info%iter_loc))//" iterations")
write(str_w, "(a,f8.3,a)") "    normalized walltime:", &
                         lzone%info%nbproc*nthread*walltime*1e6/lzone%info%iter_loc/lzone%info%totndof,&
                         " µs/cell/it (*ncpu)"  
call print_info(9,str_w)

!---------------------------------------
endsubroutine integration_cyclezone

!------------------------------------------------------------------------------!
! Change history
!
! juil 2002 : creation de la procedure
! juin 2003 : champs multiples
! juil 2003 : calcul du nombre de Fourier de la zone
!             allocation des residus remontee a integration_macrodt
! sept 2003 : calcul des gradients
! oct  2003 : deplacement des proc. calc_gradient et calc_varprim dans integration_zone
! mars 2004 : integration de zone par technique lagrangienne
! oct  2004 : field chained list
! mar  2006 : integrationmacro_zone changed to integration_cyclezone
!             update_champ moved to integzone_tstep_usttree (new name of integration_zone)
! Fev  2007 : English translation
!------------------------------------------------------------------------------!
