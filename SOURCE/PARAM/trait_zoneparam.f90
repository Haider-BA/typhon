!------------------------------------------------------------------------------!
! Procedure : trait_zoneparam             Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  : Juin 2003 (cf historique)
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
  call def_model_kdif(block, zone%defsolver)
endselect

! -------------------------
! D�finition du maillage

call def_mesh(block, zone%defmesh)

! -------------------------
! D�finition des param�tres de simulation

call def_time(block, zone%defsolver)

call def_spat(block, zone%defsolver)

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
  
  select case(bocotype(str))
  case(bc_coupling)
  nzr = nzr+1
  endselect

enddo

! Allocation de coupling
zone%ncoupling = nzr
!if (zone%ncoupling > 0) then
  allocate(zone%coupling(zone%ncoupling))
!endif

print*, "!DEBUG", zone%nom , zone%ncoupling
! Conditions aux limites

call def_boco(block, solver, zone%defsolver, zone%coupling, zone%ncoupling)

! -------------------------
! D�finition de l'initialisation

call def_init(block, solver, zone%defsolver)

call def_other(block, solver, zone%defsolver)



endsubroutine trait_zoneparam
