!------------------------------------------------------------------------------!
! Procedure : integration_zone            Auteur : J. Gressier
!                                         Date   : Aout 2002
! Fonction                                Modif  : (cf historique)
!   Int�gration de tous les domaines d'une zone sur un pas de temps correspondant 
!   � une it�ration
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine integration_zone(dt, zone)

use TYPHMAKE
use OUTPUT
use VARCOM
use DEFZONE

implicit none

! -- Declaration des entr�es --
real(krp)     :: dt              ! pas de temps propre � la zone
type(st_zone) :: zone            ! zone � int�grer

! -- Declaration des sorties --
! retour des r�sidus � travers le champ field de la structure zone

! -- Declaration des variables internes --
integer     :: if

! -- Debut de la procedure --

! -- Pr�paration du calcul --

do if = 1, zone%ndom
  call calc_varprim(zone%defsolver, zone%field(if))     ! calcul des var. primitives
    
  ! on ne calcule les gradients que dans les cas n�cessaires
  if (zone%defspat%calc_grad) then
    call calc_gradient(zone%defsolver, zone%ust_mesh,                 &
                       zone%field(if)%etatprim, zone%field(if)%gradient)
  endif
enddo

! -- calcul des conditions aux limites pour tous les domaines --

call conditions_limites(zone)

! -- int�gration des domaines --

do if = 1, zone%ndom
  call integration_ustdomaine(dt, zone%defsolver, zone%defspat,  &
                              zone%ust_mesh, zone%field(if),     &
                              zone%coupling, zone%ncoupling)
enddo



!-----------------------------
endsubroutine integration_zone

!------------------------------------------------------------------------------!
! Historique des modifications
!
! ao�t 2002 : cr�ation de la proc�dure
! juil 2003 : modification arguments integration_ustdomaine
! oct  2003 : insertion des proc�dures de calcul var. primitves et gradients
!             (avant le calcul des conditions aux limites)
!------------------------------------------------------------------------------!
