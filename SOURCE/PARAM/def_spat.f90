!------------------------------------------------------------------------------!
! Procedure : def_spat                    Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : (cf historique)
!   Traitement des parametres du fichier menu principal
!   Parametres principaux du projet
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_spat(block, defsolver, defspat, defmesh)

use RPM
use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use MENU_NUM
use MESHPARAMS

implicit none

! -- INPUTS --
type(rpmblock), target :: block
type(mnu_solver)       :: defsolver

! -- OUTPUTS --
type(mnu_spat) :: defspat
type(mnu_mesh) :: defmesh

! -- Internal variables --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: nkey           ! nombre de clefs
integer                  :: i
character(len=dimrpmlig) :: str            ! chaine RPM intermediaire

! -- BODY --

call print_info(5,"- Definition of spatial numerical parameters")

! -- Recherche du BLOCK:SPAT_PARAM --

pblock => block
call seekrpmblock(pblock, "SPAT_PARAM", 0, pcour, nkey)

! DEV : est-ce que la presence du bloc est obligatoire ?
if (nkey /= 1) call error_stop("parameters parsing: SPAT_PARAM block not found")

select case(defsolver%typ_solver)

case(solNS)

  !-----------------------------------------
  ! Euler numerical Scheme

  defspat%calc_hresQ = .true.   ! needed, even for first order

  call rpmgetkeyvalstr(pcour, "SCHEME", str, "HLLC")
  defspat%sch_hyp = inull

  if (samestring(str,"RUSANOV"))         defspat%sch_hyp = sch_rusanov
  if (samestring(str,"ROE"))             defspat%sch_hyp = sch_roe
  if (samestring(str,"OSHER-NO"))        defspat%sch_hyp = sch_osher_no
  if (samestring(str,"OSHER-IO"))        defspat%sch_hyp = sch_osher_io
  if (samestring(str,"OSHER"))           defspat%sch_hyp = sch_osher_no
  if (samestring(str,"HUS"))             defspat%sch_hyp = sch_efmo
  if (samestring(str,"EFMO"))            defspat%sch_hyp = sch_efmo
  if (samestring(str,"HLL"))             defspat%sch_hyp = sch_hlle
  if (samestring(str,"HLLE"))            defspat%sch_hyp = sch_hlle
  if (samestring(str,"HLLEB"))           defspat%sch_hyp = sch_hlleb
  if (samestring(str,"HLLEK"))           defspat%sch_hyp = sch_hllek
  if (samestring(str,"HLLEKB"))          defspat%sch_hyp = sch_hllekb
  if (samestring(str,"HLLC"))            defspat%sch_hyp = sch_hllc
  if (samestring(str,"HLLCB"))           defspat%sch_hyp = sch_hllcb
  if (samestring(str,"HLLCK"))           defspat%sch_hyp = sch_hllck
  if (samestring(str,"HLLCKB"))          defspat%sch_hyp = sch_hllckb
  if (samestring(str,"STEGER-WARMING"))  defspat%sch_hyp = sch_stegwarm
  if (samestring(str,"VANLEER"))         defspat%sch_hyp = sch_vanleer
  if (samestring(str,"VLEER"))           defspat%sch_hyp = sch_vanleer
  if (samestring(str,"VANLEERH"))        defspat%sch_hyp = sch_hwps_vleer
  if (samestring(str,"VLEERH"))          defspat%sch_hyp = sch_hwps_vleer
  if (samestring(str,"VLH"))             defspat%sch_hyp = sch_hwps_vleer
  if (samestring(str,"EFM"))             defspat%sch_hyp = sch_efm
  if (samestring(str,"EFMH"))            defspat%sch_hyp = sch_hwps_efm
  if (samestring(str,"KFVS"))            defspat%sch_hyp = sch_efm
  if (samestring(str,"AUSMM"))           defspat%sch_hyp = sch_ausmm

  select case(defspat%sch_hyp)
  case(sch_rusanov)
    call print_info(7,"  numerical flux : Rusanov")
  case(sch_roe)
    call print_info(7,"  numerical flux : Roe")
  case(sch_hlle)
    call print_info(7,"  numerical flux : HLLE")
  case(sch_hlleb)
    call print_info(7,"  numerical flux : HLLE(B)")
  case(sch_hllek)
    call print_info(7,"  numerical flux : HLLEK")
  case(sch_hllekb)
    call print_info(7,"  numerical flux : HLLEK(B)")
  case(sch_hllc)
    call print_info(7,"  numerical flux : HLLC")
  case(sch_hllcb)
    call print_info(7,"  numerical flux : HLLC(B)")
  case(sch_hllck)
    call print_info(7,"  numerical flux : HLLCK")
  case(sch_hllckb)
    call print_info(7,"  numerical flux : HLLCK(B)")
  case(sch_vanleer)
    call print_info(7,"  numerical flux : Van Leer")
  case(sch_ausmm)
    call print_info(7,"  numerical flux : AUSM (original scheme, Mach weighting)")
  case(sch_hwps_vleer)
    call print_info(7,"  numerical flux : van Leer (Hanel variant)")
  case(sch_hwps_efm)
    call print_info(7,"  numerical flux : EFM (Hanel variant)")
  case(sch_efm)
    call print_info(7,"  numerical flux : EFM/KFVS")
  case default
    call error_stop("parameters parsing: "//trim(str)//"' unknown numerical scheme")
  endselect

  !-----------------------------------------
  ! Jacobian matrix (if needed)

  call rpmgetkeyvalstr(pcour, "JACOBIAN", str, "HLL")
  defspat%jac_hyp = inull

  if (samestring(str,"DIFFNUM"))       defspat%jac_hyp = jac_diffnum
  if (samestring(str,"HLL"))           defspat%jac_hyp = jac_hll
  if (samestring(str,"HLL-DIAG"))      defspat%jac_hyp = jac_hlldiag
  if (samestring(str,"RUSANOV"))       defspat%jac_hyp = jac_rusanov
  if (samestring(str,"EFM"))           defspat%jac_hyp = jac_efm
  if (samestring(str,"KFVS"))          defspat%jac_hyp = jac_efm
  if (samestring(str,"VLH"))           defspat%jac_hyp = jac_vlh
  if (samestring(str,"VLEERH"))        defspat%jac_hyp = jac_vlh
  if (samestring(str,"VANLEERH"))      defspat%jac_hyp = jac_vlh
  if (samestring(str,"VANLEER-HANEL")) defspat%jac_hyp = jac_vlh

  select case(defspat%jac_hyp)
  case(jac_diffnum)
    call print_info(7,"  approximate jacobian: numerical differenciation of inviscid flux")
  case(jac_hll)
    call print_info(7,"  approximate jacobian: HLL (constant waves)")
  case(jac_hlldiag)
    call print_info(7,"  approximate jacobian: HLL (diagonal variant)")
  case(jac_rusanov)
    call print_info(7,"  approximate jacobian: Rusanov")
  case(jac_efm)
    call print_info(7,"  approximate jacobian: EFM (kinetic)")
  case(jac_vlh)
    call print_info(7,"  approximate jacobian: van Leer / Hanel")
   case default
    call error_stop("parameters parsing: unknown jacobian")
  endselect

  !-----------------------------------------
  ! High resolution method

  defsolver%defspat%calc_cellgrad = .false.
  defsolver%defspat%calc_facegrad = .false.
  defspat%gradmeth = gradnone
  defspat%method   = cnull
  
  call rpmgetkeyvalstr(pcour, "HIGHRES", str, "NONE")
  if (samestring(str,"NONE"))       defspat%method = hres_none
  if (samestring(str,"MUSCL"))      defspat%method = hres_muscl
  if (samestring(str,"MUSCL-FAST")) defspat%method = hres_musclfast
  if (samestring(str,"MUSCL-UNS"))  defspat%method = hres_muscluns
  if (samestring(str,"ENO"))        defspat%method = hres_eno
  if (samestring(str,"WENO"))       defspat%method = hres_weno
  if (samestring(str,"SVM"))        defspat%method = hres_svm
  if (samestring(str,"SDM"))        defspat%method = hres_sdm
  
  if (defspat%method == cnull) &
    call error_stop("parameters parsing: unexpected high resolution method")
    
  select case(defspat%method)

  ! --------------- first order ---------------------
  case(hres_none)

    call print_info(7,"  No high order extension")

  ! --------------- MUSCL methods ---------------------
  case(hres_muscl, hres_musclfast, hres_muscluns)

    call print_info(7,"  MUSCL second order extension: "//trim(str))

    ! -- High resolution order
    !call rpmgetkeyvalint(pcour, "ORDER", defspat%order, 2_kpp)

    defspat%muscl%limiter = cnull
    call rpmgetkeyvalstr(pcour, "LIMITER", str, "VAN_ALBADA")
    if (samestring(str,"NONE"))        defspat%muscl%limiter = lim_none
    if (samestring(str,"MINMOD"))      defspat%muscl%limiter = lim_minmod
    if (samestring(str,"VAN_ALBADA"))  defspat%muscl%limiter = lim_albada
    if (samestring(str,"ALBADA"))      defspat%muscl%limiter = lim_albada
    if (samestring(str,"VAN_LEER"))    defspat%muscl%limiter = lim_vleer
    if (samestring(str,"VANLEER"))     defspat%muscl%limiter = lim_vleer
    if (samestring(str,"SUPERBEE"))    defspat%muscl%limiter = lim_sbee
    if (samestring(str,"KIM3"))        defspat%muscl%limiter = lim_kim3
    if (samestring(str,"LIM03"))       defspat%muscl%limiter = lim_lim03
    !if (samestring(str,"MINMAX"))      defspat%muscl%limiter = lim_minmax
    call print_info(7,"    limiter     : "//trim(str))

    if (defspat%muscl%limiter == cnull) &
      call error_stop("parameters parsing: unexpected high resolution limiter ")

  ! --------------- SVM methods ---------------------
  case(hres_svm)

    call print_info(7,"  Spectral Volume method")

    call rpmgetkeyvalstr(pcour, "SVM", str, "2QUAD")
    if (samestring(str,"2"))       defspat%svm%sv_method = svm_2quad
    if (samestring(str,"2TRI"))    defspat%svm%sv_method = svm_2tri
    if (samestring(str,"2QUAD"))   defspat%svm%sv_method = svm_2quad
    if (samestring(str,"2Q2X2"))   defspat%svm%sv_method = svm_2q2x2b3
    if (samestring(str,"2Q2X2B3")) defspat%svm%sv_method = svm_2q2x2b3
    if (samestring(str,"2Q2X2B4")) defspat%svm%sv_method = svm_2q2x2b4
    if (samestring(str,"3"))       defspat%svm%sv_method = svm_3wang
    if (samestring(str,"3WANG"))   defspat%svm%sv_method = svm_3wang
    if (samestring(str,"3KRIS"))   defspat%svm%sv_method = svm_3kris
    if (samestring(str,"3KRIS2"))  defspat%svm%sv_method = svm_3kris2
    if (samestring(str,"3Q3X3"))   defspat%svm%sv_method = svm_3q3x3b6
    if (samestring(str,"3Q3X3B6")) defspat%svm%sv_method = svm_3q3x3b6
    if (samestring(str,"4"))       defspat%svm%sv_method = svm_4wang
    if (samestring(str,"4WANG"))   defspat%svm%sv_method = svm_4wang
    if (samestring(str,"4KRIS"))   defspat%svm%sv_method = svm_4KRIS
    if (samestring(str,"4KRIS2"))  defspat%svm%sv_method = svm_4KRIS2

    defmesh%defsplit%nsplit = 1
    select case(defspat%svm%sv_method)
    case(svm_2quad)
      call print_info(7,"    second order, splitted into quads (face split)")
      defmesh%defsplit%splitmesh    = split_svm2quad    
    case(svm_2tri)
      call print_info(7,"    second order, splitted into tris (vertex split)")
    case(svm_2q2x2b3)
      call print_info(7,"    second order, splitted into 2x2 quads (3 polynomials)")
      defmesh%defsplit%splitmesh    = split_quad2x2
    case(svm_2q2x2b4)
      call print_info(7,"    second order, splitted into 2x2 quads (4 polynomials)")
      defmesh%defsplit%splitmesh    = split_quad2x2
    case(svm_3wang)
      call print_info(7,"    third order, splitted into 3 quads and 3 pentagons: original partition by Wang")
      defmesh%defsplit%splitmesh = split_svm3wang
    case(svm_3kris)
      call print_info(7,"    third order, splitted into 3 quads and 3 pentagons: 1st optimised partition by Abeele")
      defmesh%defsplit%splitmesh = split_svm3kris
    case(svm_3kris2)
      call print_info(7,"    third order, splitted into 3 quads and 3 pentagons: 2nd optimised partition by Abeele")
      defmesh%defsplit%splitmesh = split_svm3kris2
    case(svm_3q3x3b6)
      call print_info(7,"    third order, splitted into 3x3 quads (6 polynomials)")
      defmesh%defsplit%splitmesh    = split_quad3x3lg
    case(svm_4wang)
      call print_info(7,"    fourth order, splitted into 9 quads and 1 tri (defined as hexa) : original partition by Wang")
      defmesh%defsplit%splitmesh = split_svm4wang
    case(svm_4kris)
      call print_info(7,"    fourth order, splitted into 3 quads, 6 pents and 1 tri (defined as hexa) : 1st optimised partition by Abeele")
      defmesh%defsplit%splitmesh = split_svm4kris
    case(svm_4kris2)
      call print_info(7,"    fourth order, splitted into 3 quads, 6 pents and 1 tri (defined as hexa) : 2nd optimised partition by Abeele")
      defmesh%defsplit%splitmesh = split_svm4kris2

    case default
      call error_stop("parameters parsing: unknown SVM method")
    endselect
    
    call init_svmweights(defspat%svm)

    call rpmgetkeyvalstr(pcour, "SVMFLUX", str, "QUAD_Q")
    if (samestring(str,"QUAD_Q"))    defspat%svm%sv_flux = svm_fluxQ
    if (samestring(str,"QUAD_F"))    defspat%svm%sv_flux = svm_fluxF

  select case(defspat%svm%sv_flux)
    case(svm_fluxQ)
      call print_info(7,"  SVM flux on Gauss points: averaged quantities")
    case(svm_fluxF)
      call print_info(7,"  SVM flux on Gauss points: averaged fluxes")
    case default
      call error_stop("parameters parsing: unknown method for SVM flux on Gauss points")
  endselect

  case default
    call error_stop("parameters parsing: unexpected high resolution method (reading limiter)")
  endselect

  ! --- Post-Limitation method ---
 
  defspat%postlimiter = -1
  call rpmgetkeyvalstr(pcour, "POST-LIMITER", str, "NONE")
  if (samestring(str,"NONE"))        defspat%postlimiter = postlim_none
  if (samestring(str,"MONOTONIC0"))  defspat%postlimiter = postlim_monotonic0
  if (samestring(str,"MONOTONIC1"))  defspat%postlimiter = postlim_monotonic1
  if (samestring(str,"MONOTONIC2"))  defspat%postlimiter = postlim_monotonic2
  if (samestring(str,"BARTH"))       defspat%postlimiter = postlim_barth
  if (samestring(str,"SUPERBARTH"))  defspat%postlimiter = postlim_superbarth
  if (defspat%postlimiter == -1) &
       call error_stop("parameters parsing: unexpected post limiter")
  call print_info(7,"    post-limiter: "//trim(str))

  !-----------------------------------------
  ! Gradient and Dissipative flux method

  select case(defsolver%defns%typ_fluid)
  case(eqEULER, eqEULERaxi)
    defspat%sch_dis = dis_noflux
    call get_gradientmethod(pcour, defspat)
  case(eqNSLAM, eqRANS)
    call get_dissipmethod(pcour, "DISSIPATIVE_FLUX", defspat)
  case default
    call error_stop("parameters parsing: unexpected fluid dynamical model")
  endselect

  ! ---  Gradient evaluation for SVM --------------- 
  ! must be consistently handled when asking for dissipative method

!  if (defspat%gradmeth.eq.grad_svm) then
!    if (defspat%svm%sv_order.ge.3) then
!      call init_gradsvmweights(defspat%svm)
!    else
!      call print_info(7,"  SVM2: gradient evaluation changed to GAUSS Method")
!      defspat%gradmeth=grad_gauss
!    endif
!  endif

case(solKDIF)

  defspat%calc_cellgrad = .false.
  defspat%calc_facegrad = .false.
  defspat%calc_hresQ = .false.

  ! -- Methode de calcul des flux dissipatifs --
  defspat%method = hres_none 
  call get_dissipmethod(pcour, "DISSIPATIVE_FLUX", defspat)

case(solVORTEX)

case default
  call error_stop("internal error: unknown solver (defspat)")
endselect

endsubroutine def_spat
!------------------------------------------------------------------------------!
! Changes history
!
! nov  2002 : creation, lecture de bloc vide
! oct  2003 : choix de la methode de calcul des flux dissipatifs
! mars 2004 : traitement dans le cas solVORTEX
! july 2004 : NS solver parameters
! nov  2004 : NS high resolution parameters
! jan  2006 : basic parameter routines moved to MENU_NUM
! apr  2007 : add SVM method parameters
! Feb  2013 : kinetic/beta evaluations for hllc and hlle
!------------------------------------------------------------------------------!
