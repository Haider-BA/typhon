!------------------------------------------------------------------------------!
! Procedure : calcdifflux_kdif            Auteur : E. Radenac
!                                         Date   : Juillet 2003
! Fonction                                Modif  : 
!  Calcul de la diff�rence de flux � appliquer lorsque l'�change entre deux
!  zones n'est pas � chaque pas de temps (correction de flux). Solver thermique
!
! Defauts/Limitations/Divers :
!------------------------------------------------------------------------------!

subroutine calcdifflux_kdif(etatcons1, etatcons2, nfacelim)

use OUTPUT
use DEFZONE
use DEFFIELD
use GEO3D
use TYPHMAKE

implicit none

! -- Declaration des entr�es --
integer                    :: nfacelim            ! nombre de faces limites

! -- Declaration des entr�es/sorties --
type(st_scafield), dimension(2) &
                           :: etatcons1, etatcons2 ! stockage des flux cumul�s
                                                   ! et des diff�rences de flux
                                                   ! pour les deux zones

! -- Declaration des variables internes --
integer                        :: i              ! indice de face
real(krp)                      :: a              ! coefficient correcteur
real(krp)                      :: dif_enflux     ! diff�rence des �nergies d'interface dans les deux zones

! -- Debut de la procedure --

! Suppl�ment de flux pour les �changes espac�s : calcul de la diff�rence � appliquer

do i=1, nfacelim
  dif_enflux = abs(etatcons2(1)%scal(i)) - abs(etatcons1(1)%scal(i))

  !1ere possibilit�
!  a = 0.5_krp

  !2eme possibilit� : on garde le flux maximum
!  a = 1._krp

  !3eme possibilit� : on garde le flux minimum
  a = 0._krp

  ! si l'�nergie accumul�e en 1 est positive, il faut ajouter la diff�rence des valeurs absolues
  ! (au coefficient a pr�s) ; sinon, on doit la retirer.
  if (etatcons1(1)%scal(i) > 0) then
    etatcons1(2)%scal(i) = a*dif_enflux
    etatcons2(2)%scal(i) = (1._krp-a)*dif_enflux
  else
    etatcons1(2)%scal(i) = -a*dif_enflux
    etatcons2(2)%scal(i) = -(1._krp-a)*dif_enflux
  endif

  !4eme possibilite : maximum et minimum en alternance : � faire

enddo

endsubroutine calcdifflux_kdif

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juillet 2003 (v0.0.1b): cr�ation de la proc�dure
!------------------------------------------------------------------------------!
