!------------------------------------------------------------------------------!
! Procedure : def_model_ns                Auteur : J. Gressier
!                                         Date   : Septembre 2003
! Fonction                                Modif  : (cf historique)
!   Traitement des param�tres du fichier menu principal
!   Param�tres de d�finition du mod�le de conduction de la chaleur
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_model_ns(block, defsolver)

use RPM
use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use MENU_NS

implicit none

! -- Declaration des entr�es --
type(rpmblock), target :: block

! -- Declaration des sorties --
type(mnu_solver)       :: defsolver

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: nkey           ! nombre de clefs
integer                  :: i
character(len=dimrpmlig) :: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

call print_info(5,"- D�finition du mod�le fluide")

! -- Recherche du BLOCK:MODEL

pblock => block
call seekrpmblock(pblock, "MODEL", 0, pcour, nkey)

if (nkey /= 1) call erreur("lecture de menu", &
                           "bloc MODEL inexistant ou surnum�raire")

defsolver%nequat = 5

! -- lecture du type de mod�lisation

call rpmgetkeyvalstr(pcour, "DYNAMICS", str)

if (samestring(str, "EULER"))    defsolver%defns%typ_fluid = eqEULER
if (samestring(str, "PERFECT"))  defsolver%defns%typ_fluid = eqEULER
if (samestring(str, "LAMINAR"))  defsolver%defns%typ_fluid = eqNSLAM
if (samestring(str, "RANS"))     defsolver%defns%typ_fluid = eqRANS

select case(defsolver%defns%typ_fluid)
case(eqEULER)
  call print_info(10,"    �quations de fluide parfait (Euler)")

case(eqNSLAM)
  call print_info(10,"    �quations de Navier-Stokes laminaires")
  call erreur("D�veloppement", "Pas d'impl�mentation des termes visqueux")

case(eqRANS)
  call print_info(10,"    �quations de Navier-Stokes moyenn�es (RANS)")
  call erreur("D�veloppement", "Pas d'impl�mentation de la turbulence")

case default
  call erreur("lecture de menu", "mod�lisation de la dynamique inconnue (DYNAMICS)")
endselect


! -- lecture des propri�t�s du gaz

call rpmgetkeyvalstr(pcour, "GAS", str, "AIR")

if (samestring(str, "AIR"))    defsolver%defns%typ_gas = gas_AIR

select case(defsolver%defns%typ_gas)
case(gas_AIR)
  call print_info(10,"    gaz id�al 'AIR'")
  defsolver%defns%nb_species = 1
  allocate(defsolver%defns%properties(defsolver%defns%nb_species))
  ! -- d�finition d'esp�ce 1
  defsolver%defns%properties(1)%gamma    = 1.40_krp
  defsolver%defns%properties(1)%prandtl  = 0.72_krp
  defsolver%defns%properties(1)%visc_dyn = 0.00_krp

case default
  call erreur("lecture de menu", "mod�lisation du gas inconnue (GAS)")
endselect


endsubroutine def_model_ns

!------------------------------------------------------------------------------!
! Historique des modifications
!
! sept 2003 : cr�ation de la proc�dure
! nov  2003 : d�finition du fluide (Euler) et du gaz (AIR mono esp�ce)
!------------------------------------------------------------------------------!
