!------------------------------------------------------------------------------!
! Procedure : def_boco                    Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  : Juin 2003 (cf historique)
!   Traitement des param�tres du fichier menu principal
!   Param�tres principaux du projet
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_boco(block, isolver, defsolver, zcoupling, ncoupling)

use RPM
use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use MENU_BOCO
use MENU_ZONECOUPLING

implicit none

! -- Declaration des entr�es --
type(rpmblock), target :: block
integer                :: isolver
integer                :: ncoupling

! -- Declaration des sorties --
type(mnu_solver)                             :: defsolver
type(mnu_zonecoupling), dimension(ncoupling) :: zcoupling

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: nboco          ! nombre de conditions aux limites
integer                  :: ib, nkey
integer                  :: izr            ! indice de parcours du tableau de raccords
character(len=dimrpmlig) :: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

call print_info(5,"- D�finition des conditions aux limites")

! -- Recherche du BLOCK:BOCO

pblock => block
call seekrpmblock(pblock, "BOCO", 0, pcour, nboco)

if (nboco < 1) call erreur("lecture de menu", &
                           "Pas de d�finition de conditions aux limites (BOCO)")

defsolver%nboco = nboco
allocate(defsolver%boco(nboco))
izr = 0 !initialisation

do ib = 1, nboco

  call seekrpmblock(pblock, "BOCO", ib, pcour, nkey)

  ! -- D�termination du nom de famille

  call rpmgetkeyvalstr(pcour, "FAMILY", str)
  defsolver%boco(ib)%family = str

  ! -- D�termination du type de condition aux limites 

  call rpmgetkeyvalstr(pcour, "TYPE", str)

  defsolver%boco(ib)%typ_boco = bocotype(str)

  if (defsolver%boco(ib)%typ_boco /= inull) then
    call print_info(8,"    famille "//defsolver%boco(ib)%family//": condition "//trim(str))
  else
    call erreur("lecture de menu (def_boco)","condition aux limites inconnue")
  endif

  ! Traitement des conditions aux limites communes aux solveurs

  select case(defsolver%boco(ib)%typ_boco)

  case(bc_geo_sym) 
    call erreur("D�veloppement","'bc_geo_sym' : Cas non impl�ment�")
    
  case(bc_geo_period)
    call erreur("D�veloppement","'bc_geo_period' : Cas non impl�ment�")
    
  case(bc_geo_extrapol)
    call rpmgetkeyvalstr(pcour, "ORDER", str, "QUANTITY")
    defsolver%boco(ib)%order_extrap = inull
    if (samestring(str, "QUANTITY" )) defsolver%boco(ib)%order_extrap = extrap_quantity
    if (samestring(str, "GRADIENT" )) defsolver%boco(ib)%order_extrap = extrap_gradient
    if (defsolver%boco(ib)%order_extrap == inull) &
      call erreur("lecture de menu (def_boco)","ordre d'extrapolation inconnu")

  case(bc_coupling)
    ! -- D�termination de la m�thode de calcul du raccord
    
    izr = izr + 1

    call rpmgetkeyvalstr(pcour, "CONNZONE", str)
    zcoupling(izr)%connzone = str
    
    call rpmgetkeyvalstr(pcour, "CONNFAM", str)
    zcoupling(izr)%connfam = str
    
    zcoupling(izr)%family = defsolver%boco(ib)%family
    
    call rpmgetkeyvalstr(pcour, "METHOD", str)
  
    if (samestring(str, "FLUX" ))      defsolver%boco(ib)%typ_calc = bc_calc_flux
    if (samestring(str, "GHOSTFACE" )) defsolver%boco(ib)%typ_calc = bc_calc_ghostface
    if (samestring(str, "GHOSTCELL"))  defsolver%boco(ib)%typ_calc = bc_calc_ghostcell
    
    select case(defsolver%boco(ib)%typ_calc)
  
    case(bc_calc_flux) ! M�thode du flux sp�cifique
      call print_info(10,"    m�thode du flux sp�cifique")
    case(bc_calc_ghostface) ! M�thode du flux de face
      call print_info(10,"    m�thode du flux de face")
    case(bc_calc_ghostcell) ! M�thode de la cellule fictive
      call print_info(10,"    m�thode de la cellule fictive")
    case default
      call erreur("lecture de menu","m�thode de calcul du raccord inconnue") 
    endselect
                
  case default    
    select case(isolver)
    case(solKDIF)
        call def_boco_kdif(pcour, defsolver%boco(ib)%typ_boco, defsolver%boco(ib)%boco_kdif)
     case default
       call erreur("incoh�rence interne (def_boco)","solveur inconnu")
    endselect

  endselect

  ! initialisation de l'impl�mentation de la condition aux limites

select case(defsolver%boco(ib)%typ_boco)

case(bc_coupling)
  
case default
  defsolver%boco(ib)%typ_calc = bctype_of_boco(isolver, defsolver%boco(ib)%typ_boco)

endselect

enddo

endsubroutine def_boco


!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2003 (v0.0.1b): cr�ation de la routine
!------------------------------------------------------------------------------!


