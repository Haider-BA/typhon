!------------------------------------------------------------------------------!
! Procedure : calc_kdif_flux              Auteur : J. Gressier
!                                         Date   : Avril 2003
! Fonction                                Modif  : cf historique
!   Calcul des flux de conduction de la chaleur  Fn = - conduc * (grad T . n)
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine calc_kdif_flux(defsolver, nflux, face, cg_l, cell_l, cg_r, cell_r, flux)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use MESHBASE
use DEFFIELD
use EQKDIF
use GEO3D
use MATER_LOI

implicit none

! -- Declaration des entr�es --
type(mnu_solver)      :: defsolver        ! type d'�quation � r�soudre
integer               :: nflux            ! nombre de flux (face) � calculer
type(st_face),     dimension(1:nflux) & 
                      :: face             ! donn�es g�om�triques des faces
type(v3d),         dimension(1:nflux) &
                      :: cg_l, cg_r       ! centres des cellules
type(st_kdifetat), dimension(1:nflux) &
                      :: cell_l, cell_r   ! champs des valeurs primitives

! -- Declaration des sorties --
real(krp), dimension(nflux, defsolver%nequat) :: flux

! -- Declaration des variables internes --
integer   :: if
real(krp), dimension(:), allocatable :: conduct
real(krp) :: dist
type(v3d) :: dcg
real(krp) :: tempf   ! temp�rature estim�e entre deux cellules
real(krp) :: dl, dr  ! distance centre de cellule - face

! -- Debut de la procedure --

allocate(conduct(nflux))

! -- Calcul de la conductivit� selon le mat�riau --

select case(defsolver%defkdif%materiau%type)

case(mat_LIN)
  conduct(:) = defsolver%defkdif%materiau%Kd%valeur

case(mat_KNL)
  do if = 1, nflux
    !dl = abs(face(if)%centre - cg_l(if)).scal.(dcg / dist) )
    !dr = abs(face(if)%centre - cg_r(if)).scal.(dcg / dist) )
    dl    = abs(face(if)%centre - cg_l(if))
    dr    = abs(face(if)%centre - cg_r(if))
    tempf = (dr*cell_l(if)%temperature + dl*cell_r(if)%temperature)/(dl + dr)
    conduct(if) = valeur_loi(defsolver%defkdif%materiau%Kd, tempf)
  enddo

case(mat_XMAT)
  call erreur("Calcul de mat�riau","Materiau non lin�aire complet interdit")

endselect

! -- Calcul du flux --

do if = 1, nflux
  dcg         = cg_r(if) - cg_l(if)
  dist        = abs(dcg)
  flux(if,1)  = - conduct(if) * (cell_r(if)%temperature - cell_l(if)%temperature) &
                              * (dcg.scal.face(if)%normale) / (dist**2)
enddo

deallocate(conduct)


endsubroutine calc_kdif_flux

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avril 2003  : cr�ation de la proc�dure
! juil  2003  : conductivit� non constante
! sept  2003  : optimisation de la proc�dure pour r�cup�rer les temps CPU initiaux
!------------------------------------------------------------------------------!
