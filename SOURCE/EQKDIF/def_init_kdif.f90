!------------------------------------------------------------------------------!
! Procedure : def_init_kdif               Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  : 
!   Traitement des parametres du fichier menu principal
!   Parametres principaux du projet
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_init_kdif(block, initk, unif)

use RPM
use TYPHMAKE
use VARCOM
use OUTPUT
use MENU_KDIF
use MENU_INIT

implicit none

! -- Declaration des entrees --
type(rpmblock), target :: block    ! bloc RPM contenant les definitions
integer                :: type     ! type de condition aux limites
integer                :: unif     ! uniformite de la condition initiale

! -- Declaration des sorties --
type(st_init_kdif) :: initk

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: ib, nkey, i
character(len=dimrpmlig) :: str            ! chaine RPM intermediaire

! -- Debut de la procedure --

pblock => block
if (unif == init_unif) then
  call rpmgetkeyvalreal(pblock, "TEMP", initk%temp)
else ! provisoire
  call print_info(10,"    repartition lineaire de temperature initiale")
  allocate(initk%coef(4))
  call rpmgetkeyvalstr(pblock, "TEMPC_FILE", str)
  open(unit=1003, file = str, form="formatted")
  read(1003,*) (initk%coef(i),i = 1, 4) 
  close(1003)
endif

endsubroutine def_init_kdif


!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2003 : creation de la routine
!------------------------------------------------------------------------------!


