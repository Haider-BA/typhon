!------------------------------------------------------------------------------!
! Procedure : capteurs                    Auteur : J. Gressier
!                                         Date   : Mai 2003
! Fonction                                Modif  :
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
real(krp)     :: dt              ! pas de temps propre � la zone
type(st_zone) :: zone            ! zone � int�grer

! -- Declaration des sorties --

! -- Declaration des variables internes --

! -- Debut de la procedure --


! -- int�gration des domaines --

select case(zone%typ_mesh)
 
case(mshSTR)
  call erreur("D�v�loppement (capteurs)", &
              "maillage structur� non impl�ment�")
  !do i = 1, zone%str_mesh%nblock
  !  call capteurs_str(dt, zone%defsolver, zone%str_mesh%block(i))
  !enddo

case(mshUST)
  !call erreur("D�veloppement (capteurs)", &
  !            "maillage non structur� non impl�ment�")
  !call capteurs_ust(dt, zone%defsolver, zone%ust_mesh, zone%field)
  write(*,"(a,5f10.1)")"capteur : ", &
                       zone%field(1)%etatprim%tabscal(1)%scal(1:10:2) !! DEBUG

case default
  call erreur("incoh�rence interne (capteurs)", &
              "type de maillage inconnu")

endselect

!-----------------------------
endsubroutine capteurs

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mai 2003 (v0.0.1b): cr�ation de la proc�dure
!------------------------------------------------------------------------------!
