!------------------------------------------------------------------------------!
! Procedure : def_model_kdif              Auteur : J. Gressier
!                                         Date   : Avril 2003
! Fonction                                Modif  : (cd historique)
!   Traitement des param�tres du fichier menu principal
!   Param�tres de d�finition du mod�le de conduction de la chaleur
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_model_kdif(block, defsolver)

use RPM
use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER

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

call print_info(5,"- D�finition du mod�le de conduction de la chaleur")

! -- Recherche du BLOCK:MODEL

pblock => block
call seekrpmblock(pblock, "MODEL", 0, pcour, nkey)

if (nkey /= 1) call erreur("lecture de menu", &
                           "bloc MODEL inexistant ou surnum�raire")

defsolver%nequat = 1

! -- lecture du type de mat�riau

call rpmgetkeyvalstr(pcour, "MATERIAL", str)

if (samestring(str,"DEFINITION")) then
  defsolver%defkdif%materiau%type    = mat_LIN
  defsolver%defkdif%materiau%Kd%type = LOI_CST
  call rpmgetkeyvalreal(pcour, "CONDUCT",  defsolver%defkdif%materiau%Kd%valeur)
  call rpmgetkeyvalreal(pcour, "HEATCAPA", defsolver%defkdif%materiau%Cp)
else
  call erreur("lecture de menu","D�finition de MATERIAL inconnue")
endif


endsubroutine def_model_kdif

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avril 2003 (v0.0.1b): cr�ation de la proc�dure
!                       d�finition interne de mat�riau � propri�t�s constantes
!------------------------------------------------------------------------------!
