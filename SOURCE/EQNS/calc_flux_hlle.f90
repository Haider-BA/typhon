!------------------------------------------------------------------------------!
! Procedure : calc_flux_hlle              Auteur : J. Gressier
!                                         Date   : July 2004
! Fonction                                Modif  : (cf historique)
!   Computation of HLLE flux for Euler equations
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine calc_flux_hlle(defsolver, defspat, nflux, face,        &
                          cg_l, cell_l, cg_r, cell_r, flux, ideb, &
                          calc_jac, jacL, jacR)
use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use MENU_NUM
use MESHBASE
use DEFFIELD
use EQNS
use GEO3D

implicit none

! -- Declaration des entr�es --
type(mnu_solver)      :: defsolver        ! param�tres de d�finition du solveur
type(mnu_spat)        :: defspat          ! param�tres d'int�gration spatiale
integer               :: nflux            ! nombre de flux (face) � calculer
integer               :: ideb             ! indice du premier flux � remplir
type(st_face),     dimension(1:nflux) & 
                      :: face             ! donn�es g�om�triques des faces
type(v3d),         dimension(1:nflux) &
                      :: cg_l, cg_r       ! centres des cellules
type(st_nsetat), dimension(1:nflux) &
                      :: cell_l, cell_r   ! champs des valeurs primitives
logical               :: calc_jac         ! choix de calcul de la jacobienne


! -- Declaration des sorties --
type(st_field)               :: flux
real(krp), dimension(nflux)  :: jacL, jacR  ! jac associ�es

! -- Declaration des variables internes --
integer                   :: if

! -- Debut de la procedure --


! -- Calculs pr�liminaires --

do if = 1, nflux

enddo


!--------------------------------------------------------------
! Calcul des jacobiennes
!--------------------------------------------------------------
if (calc_jac) then
  call erreur("D�veloppement","Calcul de jacobiennes du flux HLLE non impl�ment�")
endif
!  do if = 1, nflux
!    jacR(if) =  - kH(if) * (vLR(if).scal.face(if)%normale) &
!                  / (defsolver%defkdif%materiau%Cp * dLR(if)**2)
!    jacL(if) = -jacR(if)
!  enddo
!endif


!deallocate()


endsubroutine calc_flux_hlle

!------------------------------------------------------------------------------!
! Changes history
!
! July 2004 : creation, HLLE flux
!------------------------------------------------------------------------------!
