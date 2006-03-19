!------------------------------------------------------------------------------!
! Procedure : calc_roe_states              Auteur : J. Gressier
!                                         Date   : July 2004
! Fonction                                Modif  : (cf historique)
!   Computation of HLLE flux for Euler equations
!
!------------------------------------------------------------------------------!
subroutine calc_roe_states(fluid, nf, cell_l, cell_r, roe)

use TYPHMAKE
use VARCOM
use EQNS
use GEO3D

implicit none

! -- INPUTS --
type(st_espece)       :: fluid            ! parametres de definition du fluide
integer               :: nf               ! nombre de flux (face) a calculer
type(st_nsetat)       :: cell_l, cell_r   ! champs des valeurs primitives

! -- OUTPUTS --
type(st_nsetat)       :: roe              ! roe state average

! -- Internal variables --
integer               :: if
real(krp)             :: gig1
real(krp)             :: hil, hir, him    ! mass total enthalpy
real(krp), dimension(nf) :: t1, t2, kl, kr     ! automatic real arrays

! -- BODY --

gig1 = fluid%gamma / (fluid%gamma - 1._krp)

t1(1:nf) = sqrt( cell_r%density(1:nf) / cell_l%density(1:nf) )   ! sqrt(rhoR/rhoL)

roe%density(1:nf) = cell_l%density(1:nf) * t1(1:nf)              ! Roe density

kl(1:nf) = 1._krp / (1._krp + t1(1:nf))                          ! L weight
kr(1:nf) = t1(1:nf) * kl(1:nf)                                   ! R weight 

roe%velocity(1:nf) = (kl(1:nf)*cell_l%velocity(1:nf)) + (kr(1:nf)*cell_r%velocity(1:nf))

! -- Total enthalpies --

t1(1:nf) = gig1*cell_l%pressure(1:nf)/cell_l%density(1:nf) + .5_krp*sqrabs(cell_l%velocity(1:nf))
t2(1:nf) = gig1*cell_r%pressure(1:nf)/cell_r%density(1:nf) + .5_krp*sqrabs(cell_r%velocity(1:nf))

t1(1:nf) = (kl(1:nf)*t1(1:nf)) + (kr(1:nf)*t2(1:nf))             ! Roe total enthalpy

roe%pressure(1:nf) = (t1(1:nf) - .5_krp*sqrabs(roe%velocity(1:nf)))*roe%density(1:nf)/gig1


endsubroutine calc_roe_states

!------------------------------------------------------------------------------!
! Changes history
!
! July 2004 : creation, Roe average state computation
! Mar  2006 : array optimizations
!------------------------------------------------------------------------------!
