!------------------------------------------------------------------------------!
! Procedure : def_init                    Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  : 
!   Traitement des param�tres du fichier menu principal
!   Param�tres principaux du projet
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_init(block, isolver, defsolver)

use RPM
use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER

implicit none

! -- Declaration des entr�es --
type(rpmblock), target :: block
integer                :: isolver

! -- Declaration des sorties --
type(mnu_solver) :: defsolver

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: n_init         ! nombre de d�finition d'initialisation
integer                  :: i, nkey
character(len=dimrpmlig) :: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

call print_info(5,"- D�finition de l'initialisation des champs")

! -- Recherche du BLOCK:INIT

pblock => block
call seekrpmblock(pblock, "INIT", 0, pcour, n_init)

if (n_init < 1) call erreur("lecture de menu", &
                            "Pas de d�finition de l'initialisation (INIT)")

defsolver%ninit = n_init
allocate(defsolver%init(n_init))

do i = 1, n_init

  call seekrpmblock(pblock, "INIT", i, pcour, nkey)

  ! -- D�termination des caract�ristiques communes

  !call rpmgetkeyvalstr(pcour, "FAMILY", str)
  !defsolver%boco(ib)%family = str

  ! -- D�termination du type de rep�re

  !call rpmgetkeyvalstr(pcour, "TYPE", str)
  !defsolver%boco(ib)%typ_boco = bocotype(str)

  !if (defsolver%boco(ib)%typ_boco /= inull) then
  !  call print_info(8,"    famille "//defsolver%boco(ib)%family//": condition "//trim(str))
  !else
  !  call erreur("lecture de menu (def_init)","condition aux limites inconnue")
  !endif

  ! Traitement selon solveurs

  call print_info(10,"  Directive d'initialisation par champs uniformes")

  select case(isolver)
  case(solKDIF)
    call def_init_kdif(pcour, defsolver%init(i)%kdif)
  case(solVORTEX)
    call def_init_vortex(pcour, defsolver%init(i)%vortex)
  case default
    call erreur("incoh�rence interne (def_init)","solveur inconnu")
  endselect

enddo

endsubroutine def_init


!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2003 (v0.0.1b): cr�ation de la routine
!------------------------------------------------------------------------------!


