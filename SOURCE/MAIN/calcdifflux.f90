!------------------------------------------------------------------------------!
! Procedure : calcdifflux                 Auteur : E. Radenac
!                                         Date   : Juillet 2003
! Fonction                                Modif  : 
!  Calcul de la diff�rence de flux � appliquer lorsque l'�change entre deux
!  zones n'est pas � chaque pas de temps (correction de flux). Orientation 
!  selon solver.
! Defauts/Limitations/Divers :
!------------------------------------------------------------------------------!
 
subroutine calcdifflux(etatcons1, etatcons2, nfacelim, solvercoupling, &
                       corcoef, connface2)

use OUTPUT
use VARCOM
use DEFZONE
use DEFFIELD
use GEO3D
use TYPHMAKE

implicit none

! -- Declaration des entr�es --
integer                    :: nfacelim            ! nombre de faces limites
integer                    :: solvercoupling      ! solvers utilis�s
real(krp), dimension(nfacelim) &
                           :: corcoef             ! coeff correction de flux
integer, dimension(nfacelim) &
                           :: connface2

! -- Declaration des entr�es/sorties --
type(st_scafield), dimension(2) &
                           :: etatcons1, etatcons2 ! stockage des flux cumul�s
                                                   ! et des diff�rences de flux
                                                   ! pour les deux zones

! -- Declaration des variables internes --

! -- Debut de la procedure --

select case(solvercoupling)
case(kdif_kdif)
  call calcdifflux_kdif(etatcons1, etatcons2, nfacelim, corcoef, connface2)
case default
  call erreur("Incoh�rence interne (calcdifflux)","type de solveur inconnu")
endselect 

endsubroutine calcdifflux

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juillet 2003 (v0.0.1b): cr�ation de la proc�dure
! oct 2003              : ajout coefficient de correction de flux
!------------------------------------------------------------------------------!
