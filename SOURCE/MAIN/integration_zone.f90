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
type(st_grid), pointer :: pgrid
integer                :: if

! -- Debut de la procedure --

! -- Pr�paration du calcul --

pgrid => zone%grid
do while (associated(pgrid))
  call calc_varprim(zone%defsolver, pgrid%field)     ! calcul des var. primitives
  pgrid => pgrid%next
enddo

! -- calcul des conditions aux limites pour tous les domaines --

call conditions_limites(zone)
    
! on ne calcule les gradients que dans les cas n�cessaires

if (zone%defspat%calc_grad) then
  pgrid => zone%grid
  do while (associated(pgrid))
    call calc_gradient(zone%defsolver, pgrid%umesh,                 &
                       pgrid%field%etatprim, pgrid%field%gradient)
    call calc_gradient_limite(zone%defsolver, pgrid%umesh, pgrid%field%gradient)
    pgrid => pgrid%next
  enddo
endif

! -- int�gration des domaines --

pgrid => zone%grid
do while (associated(pgrid))
  ! DEV : changer les structures de couplages dans MGRID
  call integration_grid(dt, zone%info%typ_temps,                    &
                        zone%defsolver, zone%defspat, zone%deftime, &
                        pgrid, zone%coupling, zone%ncoupling)
  pgrid => pgrid%next
enddo



!-----------------------------
endsubroutine integration_zone

!------------------------------------------------------------------------------!
! Historique des modifications
!
! ao�t 2002 : cr�ation de la proc�dure
! juil 2003 : modification arguments integration_ustdomaine
! oct  2003  : modification arguments integration_ustdomaine : ajout typ_temps
! oct  2003 : insertion des proc�dures de calcul var. primitives et gradients
!             (calcul des conditions aux limites avant calcul de gradients)
!             ajout du calcul des gradients aux limites (set_gradient_limite)
! avr  2004 : traitement des listes cha�n�es de structures MGRID
!             changement d'appel integration_ustdomaine -> integration_grid
!------------------------------------------------------------------------------!
