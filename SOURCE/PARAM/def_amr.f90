!------------------------------------------------------------------------------!
! Procedure : def_amr                     Auteur : J. Gressier
!                                         Date   : July 2004
! Fonction                                Modif  : (cf historique)
!   Traitement des param�tres du fichier menu principal
!   Param�tres AMR
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_amr(block, isolver, defamr)

use RPM
use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_AMR

implicit none

! -- Declaration des entr�es --
type(rpmblock), target :: block
integer                :: isolver

! -- Declaration des sorties --
type(mnu_amr) :: defamr

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: nkey           ! nombre de clefs
integer                  :: i
character(len=dimrpmlig) :: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

call print_info(5,"- D�finition des param�tres de raffinememt automatique (AMR)")

! -- Initialisation --



! -- Recherche du BLOCK:AMR_PARAM --

pblock => block
call seekrpmblock(pblock, "AMR", 0, pcour, nkey)

! DEV : est-ce que la pr�sence du bloc est obligatoire ?
if (nkey > 1) call erreur("lecture de menu", &
                           "bloc AMR surnum�raire")

if (nkey == 1) then

  ! -- max level number --
  call rpmgetkeyvalint(pcour, "MAXLEVEL", defamr%maxlevel, 1)
  if ((defamr%maxlevel > 0).and.(defamr%maxlevel < 10)) then
    call print_info(8,"  niveau maximal de raffinement :"//strof(defamr%maxlevel,2))
  else
    call erreur("Param�tre AMR","nombre de niveau de raffinement inattendu")
  endif

  ! -- refinement degree --
  call rpmgetkeyvalint(pcour, "REFINEMENT", defamr%degree, 2)
  if ((defamr%degree >= 2).and.(defamr%degree <= 4)) then
    call print_info(8,"  degr� de raffinement :"//strof(defamr%degree,2))
  else
    call erreur("Param�tre AMR","degr� de raffinement inattendu")
  endif

  ! -- method --
  call rpmgetkeyvalstr(pcour, "METHOD", str)
  defamr%method = cnull
  if (samestring(str,"EVOLUTIVE"))   defamr%method = amr_evolutive
  if (samestring(str,"PROGRESSIVE")) defamr%method = amr_progressive
  select case(defamr%method)
  case(amr_evolutive)
    call print_info(8,"  m�thode �volutive (raffinement complet)")
  case(amr_progressive)
    call print_info(8,"  m�thode progressive (niveau par niveau)")
  case default
    call erreur("Param�tre AMR","m�thode inconnue")
  endselect

  ! -- periodicity --
  call rpmgetkeyvalstr(pcour, "PERIODICITY", str)
  defamr%period = cnull
  if (samestring(str,"TIMESTEP")) defamr%period = amr_timestep
  if (samestring(str,"CYCLE"))    defamr%period = amr_cycle
  select case(defamr%period)
  case(amr_timestep)
    call print_info(8,"  raffinement � chaque it�ration")
  case(amr_cycle)
    call print_info(8,"  raffinement � chaque cycle")
  case default
    call erreur("Param�tre AMR","type de p�riodicit� inconnue")
  endselect


endif


endsubroutine def_amr
!------------------------------------------------------------------------------!
! Changes history
!
! july 2004 : creation, reading basic parameters
!------------------------------------------------------------------------------!
