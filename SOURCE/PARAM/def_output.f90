!------------------------------------------------------------------------------!
! Procedure : def_output                  Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : Octobre 2003
!   Traitement des param�tres du fichier menu principal
!   Param�tres principaux du projet
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_output(block, world)

use RPM
use TYPHMAKE
use OUTPUT
use VARCOM
use MODWORLD
use MENU_GEN

implicit none

! -- Declaration des entr�es --
type(rpmblock), target :: block

! -- Declaration des sorties --
type(st_world) :: world

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: nkey, nkey2    ! nombre de clefs
integer                  :: i
character(len=dimrpmlig) :: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

call print_info(2,"* D�finition des sorties r�sultats")

! -- Recherche du BLOCK:OUTPUT

pblock => block
call seekrpmblock(pblock, "OUTPUT", 0, pcour, nkey)
!
if (nkey /= 1) call erreur("lecture de menu", &
                           "bloc OUTPUT inexistant ou surnum�raire")

world%noutput = 1
allocate(world%output(1))

! -- lecture du format

call rpmgetkeyvalstr(pcour, "FORMAT", str)
world%output(1)%format = cnull

if (samestring(str,"TECPLOT")) world%output(1)%format = fmt_TECPLOT
if (samestring(str,"VIGIE"))   world%output(1)%format = fmt_VIGIE
if (world%output(1)%format == cnull) call erreur("lecture de menu","format de fichier inconnu")

! -- lecture du nom de fichier

call rpmgetkeyvalstr(pcour, "FILE", str)
world%output(1)%fichier = str

! -- D�termination du type de sortie : aux noeuds du maillage 
!    ou au centre des cellules (par d�faut au centre)

call rpmgetkeyvalstr(pcour, "TYPE", str, "CENTER")

if (samestring(str,"NODE")) world%output(1)%type = outp_NODE
if (samestring(str,"CENTER"))   world%output(1)%type = outp_CENTER


endsubroutine def_output
