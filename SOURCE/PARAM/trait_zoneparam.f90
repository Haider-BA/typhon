!------------------------------------------------------------------------------!
! Procedure : trait_zoneparam             Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  : (cf historique)
!   Traitement des param�tres de d�finition des zones
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine trait_zoneparam(block, solver, zone)

use RPM
use VARCOM
use OUTPUT
use DEFZONE
use MENU_BOCO

implicit none

! -- Declaration des entr�es --
type(rpmblock), target  :: block    ! blocks RPM (param�tres de la zone � lire)
integer                 :: solver  ! type de solveur

! -- Declaration des sorties --
type(st_zone)          :: zone

! -- Declaration des variables internes --
type(rpmblock), pointer :: pblock, pcour  ! pointeur de bloc RPM
integer                 :: nkey           ! nombre de clefs
integer                 :: nboco          ! nombre de conditions limites
integer                 :: nzr            ! nombre de couplages avec d'autres
                                          ! zones
integer                 :: ib             ! indice de parcours des boco
character(len=dimrpmlig):: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

! -------------------------
! d�finition de la mod�lisation

zone%defsolver%typ_solver = solver

select case(solver)
case(solKDIF)
  if (.not.pass_kdif) call erreur("restriction","solveur Conduction indisponible")
  call def_model_kdif(block, zone%defsolver)
case(solNS)
  if (.not.pass_ns) call erreur("restriction","solveur Navier-Stokes indisponible")
  call def_model_ns(block, zone%defsolver)
case(solVORTEX)
  if (.not.pass_vort) call erreur("restriction","solveur Vortex indisponible")
  call def_model_vortex(block, zone%defsolver)
case default
  call erreur("lecture de menu","solveur inconnu")
endselect

! -------------------------
! D�finition du maillage

call def_mesh(block, zone%defmesh)

! -------------------------
! D�finition des param�tres de simulation

call def_time(block, solver, zone%deftime)

call def_spat(block, solver, zone%defspat)

! -------------------------
! D�finition des conditions aux limites et param�tres de couplage

! -- D�termination du nombre de couplages avec d'autres zones
call print_info(5,"- Nombre de zones coupl�es")

pblock => block
call seekrpmblock(pblock, "BOCO", 0, pcour, nboco)

if (nboco < 1) call erreur("lecture de menu", &
                           "Pas de d�finition de conditions aux limites (BOCO)")
! Initialisation du nombre de couplages avec d'autres zones
nzr = 0 

do ib = 1, nboco

  call seekrpmblock(pblock, "BOCO", ib, pcour, nkey)
  
  ! -- D�termination du type de condition aux limites 

  call rpmgetkeyvalstr(pcour, "TYPE", str)

  if(samestring(str,"COUPLING")) nzr = nzr +1

enddo

! Allocation de coupling
zone%ncoupling = nzr
!if (zone%ncoupling > 0) then
  allocate(zone%coupling(zone%ncoupling))
!endif

! Conditions aux limites

call def_boco(block, solver, zone%defsolver, zone%coupling, zone%ncoupling)

! -------------------------
! D�finition de l'initialisation

call def_init(block, solver, zone%defsolver)

! -------------------------
! D�finition des capteurs

call def_capteurs(block, solver, zone%defsolver)

! -------------------------
! D�finition des autres param�tres

call def_other(block, solver, zone%defsolver)



endsubroutine trait_zoneparam

!------------------------------------------------------------------------------!
! Historique des modifications
!
! Juil 2002 : cr�ation de la proc�dure
! Sept 2003 : appel � la d�finition de solveur NS
! Nov  2003 : appel � la d�finition de capteurs
! Fev  2004 : appel � la d�finition de solveur VORTEX
!------------------------------------------------------------------------------!
