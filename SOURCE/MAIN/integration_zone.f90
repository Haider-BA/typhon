!------------------------------------------------------------------------------!
! Procedure : integration_zone            Auteur : J. Gressier
!                                         Date   : Aout 2002
! Fonction                                Modif  : Juillet 2003
!   Int�gration d'une zone sur un pas de temps correspondant 
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
integer     :: ifield

! -- Debut de la procedure --

! -- calcul des conditions aux limites pour tous les domaines --

call conditions_limites(zone)

! -- int�gration des domaines --
select case(zone%typ_mesh)

case(mshSTR)
  call erreur("D�v�loppement (integration_zone)", &
              "maillage structur� non impl�ment�")
  !do i = 1, zone%str_mesh%nblock
  !  call integration_strdomaine(dt, zone%defsolver, zone%str_mesh%block(i))
  !enddo

case(mshUST)
  !call erreur("D�veloppement (integration_zone)", &
  !            "maillage non structur� non impl�ment�")
  do ifield = 1, zone%ndom
    call integration_ustdomaine(dt, zone%defsolver, zone%ust_mesh, zone%field(ifield),&
                                zone%coupling, zone%ncoupling)
  enddo

case default
  call erreur("incoh�rence interne (integration_zone)", &
              "type de maillage inconnu")

endselect

!-----------------------------
endsubroutine integration_zone

!------------------------------------------------------------------------------!
! Historique des modifications
!
! ao�t 2002 (v0.0.1b): cr�ation de la proc�dure
! juillet 2003       : modification arguments integration_ustdomaine
!------------------------------------------------------------------------------!
