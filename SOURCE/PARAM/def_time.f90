!------------------------------------------------------------------------------!
! Procedure : def_time                    Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : (cf historique)
!   Traitement des param�tres du fichier menu principal
!   Param�tres d'int�gration temporelle
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_time(block, solver, deftime)

use VARCOM
use RPM
use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_NUM

implicit none

! -- Declaration des entr�es --
type(rpmblock), target :: block
integer                :: solver

! -- Declaration des sorties --
type(mnu_time) :: deftime

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: nkey           ! nombre de clefs
integer                  :: i
character(len=dimrpmlig) :: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

call print_info(5,"- D�finition des param�tres d'int�gration temporelle")

! -- Recherche du BLOCK:TIME_PARAM

pblock => block
call seekrpmblock(pblock, "TIME_PARAM", 0, pcour, nkey)

if (nkey /= 1) call erreur("lecture de menu", &
                           "bloc TIME_PARAM inexistant ou surnum�raire")

! -- type de calcul du pas de temps, et param�tre associ�s

call rpmgetkeyvalstr(pcour, "DTCALC", str, "STABILITY_CONDITION")
deftime%stab_meth = inull

if (samestring(str,"STABILITY_CONDITION")) deftime%stab_meth = stab_cond
if (samestring(str,"GIVEN"))               deftime%stab_meth = given_dt

if (deftime%stab_meth == inull) &
  call erreur("lecture de menu","methode de calcul DTCALC inconnue")

select case(deftime%stab_meth)
case(given_dt)
  call rpmgetkeyvalreal(pcour, "DT", deftime%dt)
case(stab_cond)
  select case(solver)
  case(solKDIF)
    call rpmgetkeyvalreal(pcour, "FOURIER", deftime%stabnb)
  case(solNS)
    call rpmgetkeyvalreal(pcour, "CFL", deftime%stabnb)
  case default
    call erreur("lecture de menu","solveur inconnu (d�finition temporelle)")
  endselect
endselect

! -- type d'int�gration temporelle --

deftime%local_dt = .false.

! -- type de sch�ma temporel --

call rpmgetkeyvalstr(pcour, "METHOD", str, "EXPLICIT")
deftime%tps_meth = inull

if (samestring(str,"EXPLICIT"))    deftime%tps_meth = tps_expl
if (samestring(str,"RUNGE-KUTTA")) deftime%tps_meth = tps_rk
if (samestring(str,"IMPLICIT"))    deftime%tps_meth = tps_impl
if (samestring(str,"DUAL-TIME"))   deftime%tps_meth = tps_dualt

if (deftime%tps_meth == inull) &
  call erreur("lecture de menu","type d'int�gration temporelle inconnu")

select case(deftime%tps_meth)
case(tps_expl)
  
case(tps_rk)
  call rpmgetkeyvalint(pcour, "ORDER", deftime%rk%ordre, 2_kpp)

case(tps_impl)
  call rpmgetkeyvalstr(pcour, "INVERSION", str)
  if (.not.samestring(str,"LU")) call erreur("alg�bre","m�thode d'inversion inconnue")
  deftime%implicite%methode     = alg_lu    ! DEV : provisoire
  deftime%implicite%max_it      = 10
  deftime%implicite%maxres      = .001_krp
  deftime%implicite%ponderation = 1._krp

case(tps_dualt)

endselect



endsubroutine def_time

!------------------------------------------------------------------------------!
! Historique des modifications
! nov  2002 : cr�ation (vide) pour lien avec l'arborescence
! sept 2003 : lecture des param�tres de calcul du pas de temps
! avr  2004 : lecture des param�tres d'int�gration (implicitation)
!------------------------------------------------------------------------------!
