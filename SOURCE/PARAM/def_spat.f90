!------------------------------------------------------------------------------!
! Procedure : def_spat                    Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : (cf historique)
!   Traitement des param�tres du fichier menu principal
!   Param�tres principaux du projet
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_spat(block, isolver, defspat)

use RPM
use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_NUM

implicit none

! -- Declaration des entr�es --
type(rpmblock), target :: block
integer                :: isolver

! -- Declaration des sorties --
type(mnu_spat) :: defspat

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: nkey           ! nombre de clefs
integer                  :: i
character(len=dimrpmlig) :: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

call print_info(5,"- D�finition des param�tres de discr�tisation spatiale")

! -- Initialisation --

defspat%calc_grad = .false.

! -- Recherche du BLOCK:SPAT_PARAM --

pblock => block
call seekrpmblock(pblock, "SPAT_PARAM", 0, pcour, nkey)

! DEV : est-ce que la pr�sence du bloc est obligatoire ?
if (nkey /= 1) call erreur("lecture de menu", &
                           "bloc SPAT_PARAM inexistant ou surnum�raire")


select case(isolver)

case(solKDIF)

  ! -- M�thode de calcul des flux dissipatifs --

  call rpmgetkeyvalstr(pcour, "DISSIPATIVE_FLUX", str, "FULL")
  defspat%sch_dis = inull

  if (samestring(str,"COMPACT")) defspat%sch_dis = dis_dif2
  if (samestring(str,"AVERAGE")) defspat%sch_dis = dis_avg2
  if (samestring(str,"FULL"))    defspat%sch_dis = dis_full

  if (defspat%sch_dis == inull) &
    call erreur("lecture de menu",&
                "methode de calcul DISSIPATIVE_FLUX inconnue")

  select case(defspat%sch_dis)
  case(dis_dif2)
  
  case(dis_avg2)
    defspat%calc_grad = .true.
  case(dis_full)
    defspat%calc_grad = .true.
  endselect

case(solVORTEX)

endselect


endsubroutine def_spat

!------------------------------------------------------------------------------!
! Historique des modifications
!
! nov  2002 : cr�ation, lecture de bloc vide
! oct  2003 : choix de la m�thode de calcul des flux dissipatifs
! mars 2004 : traitement dans le cas solVORTEX
!------------------------------------------------------------------------------!
