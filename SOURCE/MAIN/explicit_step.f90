!------------------------------------------------------------------------------!
! Procedure : explicit_step               Auteur : J. Gressier
!                                         Date   : Avril 2004
! Fonction                                Modif  : (cf historique)
!   Integration explicit de domaine
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine explicit_step(dt, typtemps, defsolver, defspat, deftime, &
                         umesh, field, coupling, ncp)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use MENU_NUM
use USTMESH
use DEFFIELD
use MENU_ZONECOUPLING

implicit none

! -- Declaration des entr�es --
real(krp)        :: dt         ! pas de temps CFL
character        :: typtemps   ! type d'integration (stat, instat, period)
type(mnu_solver) :: defsolver  ! type d'�quation � r�soudre
type(mnu_spat)   :: defspat    ! param�tres d'int�gration spatiale
type(mnu_time)   :: deftime    ! param�tres d'int�gration spatiale
type(st_ustmesh) :: umesh      ! domaine non structur� � int�grer
integer          :: ncp        ! nombre de couplages de la zone

! -- Declaration des entr�es/sorties --
type(st_field)   :: field            ! champ des valeurs et r�sidus
type(mnu_zonecoupling), dimension(1:ncp) &
                 :: coupling ! donn�es de couplage

! -- Declaration des variables internes --
type(st_genericfield) :: flux             ! tableaux des flux
real(krp), dimension(1) :: jacL, jacR     ! tableaux FICTIFS de jacobiennes des flux

! -- Debut de la procedure --


! -- allocation des flux et termes sources (structure �quivalente � field%etatcons) --

call new(flux, umesh%nface, field%nscal, field%nvect, 0)

! On peut ici d�couper le maillage complet en blocs de taille fix� pour optimiser
! l'encombrement m�moire et la vectorisation

select case(defsolver%typ_solver)
case(solKDIF)
  call integration_kdif_ust(dt, defsolver, defspat, umesh, field, flux, .false., jacL, jacR)
case default
  call erreur("incoh�rence interne (explicit_step)", "solveur inconnu")
endselect

! -- flux surfaciques -> flux de surfaces et calcul des r�sidus  --

call flux_to_res(dt, umesh, flux, field%residu, .false., jacL, jacR)

! -- calcul pour correction en couplage --

select case(typtemps)
 case(instationnaire) ! corrections de flux seulement en instationnaire

 ! Calcul de l'"�nergie" � l'interface, en vue de la correction de flux, pour 
 ! le couplage avec �changes espac�s
 !DVT : flux%tabscal(1) !
 if (ncp>0) then
   call accumulfluxcorr(dt, defsolver, umesh%nboco, umesh%boco, &
                        umesh%nface, flux%tabscal(1)%scal, ncp, &
                        coupling)
 endif

endselect

call delete(flux)


endsubroutine explicit_step

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avr  2003 : cr�ation de la proc�dure
! juil 2003 : ajout corrections de  flux
! oct  2003 : corrections de flux seulement en instationnaire
! avr  2004 : changement de nom  integration_ustdomaine -> integration_grid
! avr  2004 : decoupage integration_grid -> explicit_step
!------------------------------------------------------------------------------!
