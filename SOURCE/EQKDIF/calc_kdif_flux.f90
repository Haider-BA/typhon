!------------------------------------------------------------------------------!
! Procedure : calc_kdif_flux              Auteur : J. Gressier
!                                         Date   : Avril 2003
! Fonction                                Modif  : (cf historique)
!   Calcul des flux de conduction de la chaleur : trois m�thodes
!
! Defauts/Limitations/Divers :
!   Les gradients sont cens�s �tre ceux des variables primitives qui
!   sont aussi pass�es en argument
!
!------------------------------------------------------------------------------!
subroutine calc_kdif_flux(defsolver, defspat, nflux, face,   &
                          cg_l, cell_l, grad_l,              &
                          cg_r, cell_r, grad_r, flux)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use MENU_NUM
use MESHBASE
use DEFFIELD
use EQKDIF
use GEO3D
use MATER_LOI

implicit none

! -- Declaration des entr�es --
type(mnu_solver)      :: defsolver        ! param�tres de d�finition du solveur
type(mnu_spat)        :: defspat          ! param�tres d'int�gration spatiale
integer               :: nflux            ! nombre de flux (face) � calculer
type(st_face),     dimension(1:nflux) & 
                      :: face             ! donn�es g�om�triques des faces
type(v3d),         dimension(1:nflux) &
                      :: cg_l, cg_r       ! centres des cellules
type(st_kdifetat), dimension(1:nflux) &
                      :: cell_l, cell_r   ! champs des valeurs primitives
type(v3d),         dimension(1:nflux) &
                      :: grad_l, grad_r   ! gradients aux centres des cellules

! -- Declaration des sorties --
real(krp), dimension(nflux, defsolver%nequat) :: flux

! -- Declaration des variables internes --
real(krp), parameter :: theta = 1._krp
integer   :: if
real(krp), dimension(:), allocatable :: kH, dHR, dHL, dLR  ! voir allocation
type(v3d), dimension(:), allocatable :: vLR                ! vecteur entre centres de cellules
real(krp) :: TH                                            ! temp�rature en H
real(krp) :: Fcomp, Favg                                   ! flux compacts et moyens
real(krp) :: id, pscal                                     ! re�ls temporaires
type(v3d) :: vi                                            ! vecteur interm�diaire

! -- Debut de la procedure --

allocate( kH(nflux))    ! conductivit� en H, centre de face
allocate(dHR(nflux))    ! distance HR, rapport�e � HL+HR
allocate(dHL(nflux))    ! distance HL, rapport�e � HL+HR
allocate(dLR(nflux))    ! distance LR (diff�rence de HR+HL)
allocate(vLR(nflux))    ! vecteur  LR

! -- Calculs pr�liminaires --

do if = 1, nflux
  dHL(if) = abs(face(if)%centre - cg_l(if))
  dHR(if) = abs(face(if)%centre - cg_r(if))
  id      = 1._krp/(dHL(if) + dHR(if))
  dHL(if) = id*dHL(if) 
  dHR(if) = id*dHR(if) 
  vLR(if) = cg_r(if) - cg_l(if)
  ! DEV / OPT : calcul de la distance au carr�e si c'est la seule utilis�e
  ! pour �viter sqrt()**2
  dLR(if) = abs(vLR(if))
enddo

! -- Calcul de la conductivit� en H (centre de face) selon le mat�riau --

select case(defsolver%defkdif%materiau%type)

case(mat_LIN)
  kH(:) = defsolver%defkdif%materiau%Kd%valeur

case(mat_KNL)
  do if = 1, nflux
    TH     = dHR(if)*cell_l(if)%temperature + dHL(if)*cell_r(if)%temperature
    kH(if) = valeur_loi(defsolver%defkdif%materiau%Kd, TH)
  enddo

case(mat_XMAT)
  call erreur("Calcul de mat�riau","Materiau non lin�aire complet interdit")

endselect

!--------------------------------------------------------------
! Calcul du flux
!--------------------------------------------------------------
! COMPACT : F1 = - k(H) * (T(R) - T(L))            ! L et R centres de cellules
! AVERAGE : F2 = - k(H) * (a.gT(L) + b.gT(R)).n    ! H centre de face
! FULL    : F3 = 
! a = HR/RL et b = HL/RL
! k(H) = k(T(H)) avec T(H) = a.T(L) + b.T(R)

select case(defspat%sch_dis)
case(dis_dif2) ! formulation compacte, non consistance si vLR et n non align�s
  do if = 1, nflux
    flux(if,1)  = - kH(if) * (cell_r(if)%temperature - cell_l(if)%temperature) &
                           * (vLR(if).scal.face(if)%normale) / (dLR(if)**2)
  enddo

case(dis_avg2) ! formulation consistante, moyenne pond�r�e des gradients
  do if = 1, nflux
    flux(if,1)  = - kH(if) * ((dHL(if)*grad_r(if) + dHR(if)*grad_l(if)).scal.face(if)%normale)
  enddo

case(dis_full)
  do if = 1, nflux
    pscal = (vLR(if).scal.face(if)%normale) / (dLR(if)**2)
    Fcomp = pscal * (cell_r(if)%temperature - cell_l(if)%temperature)
    vi    = face(if)%normale - (theta*pscal)*vLR(if)
    Favg  = (dHL(if)*grad_r(if) + dHR(if)*grad_l(if)).scal.vi
    !!write(*,"(a,4e12.4)") "DEBUG: ",Favg, Fcomp, abs(grad_l(if)), abs(grad_r(if))
    flux(if,1)  = - kH(if) * (theta*Fcomp + Favg)
  enddo

endselect

deallocate(kH, dHR, dHL, dLR, vLR)


endsubroutine calc_kdif_flux

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avr  2003  : cr�ation de la proc�dure : m�thode COMPACTE
! juil 2003  : conductivit� non constante
! sept 2003  : optimisation de la proc�dure pour r�cup�rer les temps CPU initiaux
! oct  2003  : impl�mentation des trois m�thodes de calcul COMPACT, AVERAGE, FULL
!------------------------------------------------------------------------------!
