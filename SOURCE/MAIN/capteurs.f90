!------------------------------------------------------------------------------!
! Procedure : capteurs                    Auteur : J. Gressier
!                                         Date   : Mai 2003
! Fonction                                Modif  : (cf historique)
!   Calcul des quantit�s d�finis par les capteurs
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine capteurs(zone)

use TYPHMAKE
use OUTPUT
use VARCOM
use DEFZONE

implicit none

! -- Declaration des entr�es --
type(st_zone) :: zone            ! zone 

! -- Declaration des sorties --

! -- Declaration des variables internes --
integer    :: ic                 ! index de capteur

! -- Debut de la procedure --

do ic = 1, zone%defsolver%nprobe

  select case(zone%defsolver%probe(ic)%type)
  case(probe)
    call erreur("D�veloppement","type PROBE non impl�ment�")
  case(boco_field)
    call prb_boco_field()
  case(boco_integral)
    call erreur("D�veloppement","type BOCO_INTEGRAL non impl�ment�")
  case(residuals)

  endselect

enddo

write(uf_monres,*) zone%info%iter_tot, log10(zone%info%cur_res)

!-----------------------------
endsubroutine capteurs

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mai 2003 : cr�ation de la proc�dure (test pour debuggage)
! nov 2003 : redirection selon type de capteur
!------------------------------------------------------------------------------!
