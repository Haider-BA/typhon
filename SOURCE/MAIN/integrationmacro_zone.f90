!------------------------------------------------------------------------------!
! Procedure : integrationmacro_zone       Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  : (cf Historique)
!   Int�gration d'une zone sur un �cart de temps donn�,
!   d'une repr�sentation physique uniquement
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine integrationmacro_zone(lzone)
 
use TYPHMAKE
use OUTPUT
use VARCOM
use DEFZONE
use DEFFIELD
use GEO3D

implicit none

! -- Declaration des entr�es --
type(st_zone) :: lzone            ! zone � int�grer

! -- Declaration des sorties --

! -- Declaration des variables internes --
real(krp)   :: local_t            ! temps local (0 � mdt)
real(krp)   :: dt                 ! pas de temps de la zone
integer     :: iter               ! num�ro d'it�ration local au cycle
integer     :: if, ic, ib, nbc    ! index de champ, couplage et boco
real(krp)   :: part_cor           ! part de correction � appliquer
integer     :: typ_cor            ! type de correction
logical     :: fin

!DEV
integer :: cumulreste, oui, non
! -- Debut de la procedure --

!DEV
oui = 1
non = 2
cumulreste = oui

iter    = 0
local_t = 0._krp
fin     = .false.

! �criture d'informations

select case(lzone%info%typ_temps)

case(stationnaire)
  write(str_w,'(a,i5)') "  zone",lzone%id

case(instationnaire)
  write(str_w,'(a,i5,a,g10.4)') "  zone",lzone%id," � t local =",local_t
  
case(periodique)

endselect

call print_info(7,str_w)

!----------------------------------
! int�gration
!----------------------------------

do while (.not.fin)

  iter = iter + 1
  
  ! ---
  call calc_zonetimestep(lzone, dt)
  ! ---

  ! �criture d'informations et gestion

  select case(lzone%info%typ_temps)

  case(stationnaire)

  case(instationnaire)
    if (dt >= (lzone%info%cycle_dt - local_t)) then
      fin = .true.
      dt  = lzone%info%cycle_dt - local_t
    endif  
  
  case(periodique)
    call erreur("D�veloppement","cas non impl�ment�")

  endselect

  ! Correction de flux quand n�cessaire
  do ic = 1, lzone%ncoupling
    part_cor = lzone%coupling(ic)%partcor
    typ_cor = lzone%coupling(ic)%typ_cor
    if ( (typ_cor.ne.sans).and.(typ_cor.ne.auto).and.(typ_cor.ne.partiel).and.&
         (typ_cor.ne.bocoT).and.(typ_cor.ne.avant).and.(typ_cor.ne.apres).and.&
         (typ_cor.ne.bocoT2) ) then !DEV1603
      ! Calcul de l'indice de condition aux limites
      do ib = 1, lzone%grid%umesh%nboco
        if (samestring(lzone%coupling(ic)%family, &
                       lzone%grid%umesh%boco(ib)%family)) nbc = ib
      enddo
      ! Correction de flux
      if (cumulreste == oui) then
        call corr_varprim(lzone%grid%field, lzone%grid%umesh, &
                          lzone%defsolver, &
                          lzone%coupling(ic)%zcoupling%etatcons, nbc, &
                          part_cor, typ_cor, .false.)
      else
        call corr_varprim(lzone%grid%field, lzone%grid%umesh, &
                          lzone%defsolver, &
                          lzone%coupling(ic)%zcoupling%etatcons, nbc, &
                          part_cor, typ_cor, fin)
      endif 
    endif
  enddo

  ! On peut ici coder diff�rentes m�thodes d'int�gration (RK, temps dual...)

  ! ---
  select case(lzone%defsolver%typ_solver)
  case(solKDIF, solNS)
    call integration_zone(dt, lzone)
  case(solVORTEX)
    call integration_zone_lag(dt, lzone)
  case default
    call erreur("incoh�rence interne","solveur inattendu")
  endselect
  ! ---

  !do if = 1, lzone%ndom  ! DEV: � remplacer par une boucle sur les grilles
                          ! apr�s homog�n�isation des solveurs dans MGRID
    select case(lzone%defsolver%typ_solver)
    case(solKDIF, solNS)
      call update_champ(lzone%info, lzone%grid%field, &
                        lzone%grid%umesh%ncell_int)  ! m�j  des var. conservatives
    case(solVORTEX)
      ! pas de mise � jour pour le moment 
      ! DEV : mise � jour de la position des vortex libres
      ! call update_lag
      lzone%info%residumax  = 2._krp      ! astuce pour n'imposer qu'une it�ration 
      lzone%info%cur_res    = 1.e-8_krp   ! dans le cycle
      lzone%info%residu_ref = 1.e+8_krp   ! astuce pour n'avoir qu'un cycle
    case default
      call erreur("incoh�rence interne","solveur inattendu")
    endselect
  !enddo

  ! �criture d'informations et test de fin de cycle

  select case(lzone%info%typ_temps)

  case(stationnaire)
    lzone%info%residu_ref = max(lzone%info%residu_ref, lzone%info%cur_res)
    if (lzone%info%cur_res/lzone%info%residu_ref <= lzone%info%residumax) fin = .true.
    if (mod(iter,10) == 0) &
      write(str_w,'(a,i5,a,g10.4)') "    iteration",iter," | residu = ", log10(lzone%info%cur_res)
!                                    log10(lzone%info%cur_res/lzone%info%residu_ref)

  case(instationnaire)
    local_t = local_t + dt
    if (mod(iter,10) == 0) &
      write(str_w,'(a,i5,a,g10.4)') "    integration",iter," � t local =",local_t
  
  case(periodique)

  endselect

  if (mod(iter,10) == 0) call print_info(9,str_w)

enddo

call capteurs(lzone)

!---------------------------------------
endsubroutine integrationmacro_zone

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juil 2002 : cr�ation de la proc�dure
! juin 2003 : champs multiples
! juil 2003 : calcul du nombre de Fourier de la zone 
!             allocation des residus remont�e � integration_macrodt
! sept 2003 : calcul des gradients
! oct  2003 : d�placement des proc. calc_gradient et calc_varprim dans integration_zone
! mars 2004 : integration de zone par technique lagrangienne
!------------------------------------------------------------------------------!
