!------------------------------------------------------------------------------!
! Procedure : calcdifflux_kdif            Auteur : E. Radenac
!                                         Date   : Juillet 2003
! Fonction                                Modif  : 
!  Calcul de la diff�rence de flux � appliquer lorsque l'�change entre deux
!  zones n'est pas � chaque pas de temps (correction de flux). Solver thermique
!
! Defauts/Limitations/Divers :
!------------------------------------------------------------------------------!
 
subroutine calcdifflux_kdif(etatcons1, etatcons2, nfacelim, corcoef, connface2)

use OUTPUT
use DEFZONE
use DEFFIELD
use GEO3D
use TYPHMAKE

implicit none

! -- Declaration des entr�es --
integer                    :: nfacelim            ! nombre de faces limites
real(krp), dimension(nfacelim) &
                           :: corcoef             ! coeff correction de flux
integer, dimension(nfacelim) &
                           :: connface2

! -- Declaration des entr�es/sorties --
type(st_scafield), dimension(3) &
                           :: etatcons1, etatcons2 ! stockage des flux cumul�s
                                                   ! et des diff�rences de flux
                                                   ! pour les deux zones

! -- Declaration des variables internes --
integer                        :: i              ! indice de face
real(krp)                      :: dif_enflux     ! diff�rence des �nergies d'interface dans les deux zones

! -- Debut de la procedure --

! Suppl�ment de flux pour les �changes espac�s : calcul de la diff�rence � appliquer

do i=1, nfacelim

! La diff�rence est la "somme" des flux cumul�s car ce sont les valeurs alg�briques dont on dispose
! (les flux sortant de part et d'autre)

dif_enflux = etatcons2(1)%scal(connface2(i)) + etatcons1(1)%scal(i)

  ! diff�rence de flux pour la zone1 : tient compte du reste du cycle pr�c�dent
  ! (etatcons(3))
  etatcons1(2)%scal(i) = -corcoef(i)*dif_enflux + etatcons1(3)%scal(i)
  ! initialisation du reste � la diff�rence initiale
  etatcons1(3)%scal(i) = etatcons1(2)%scal(i) 
  etatcons2(2)%scal(connface2(i)) = (-1._krp + corcoef(i))*dif_enflux + &
                                    etatcons2(3)%scal(connface2(i))
  ! initialisation du reste � la diff�rence initiale
  etatcons2(3)%scal(connface2(i)) = etatcons2(2)%scal(connface2(i))

enddo

endsubroutine calcdifflux_kdif

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juillet 2003 (v0.0.1b): cr�ation de la proc�dure
! oct 2003              : ajout coefficient correction de flux
!------------------------------------------------------------------------------!
