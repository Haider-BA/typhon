!------------------------------------------------------------------------------!
! Procedure : integration_zone_lag        Auteur : J. Gressier
!                                         Date   : Mars 2004
! Fonction                                Modif  : (cf historique)
!   Integration de tous les domaines d'une zone sur un pas de temps correspondant 
!   a une iteration
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine integration_zone_lag(dt, zone)

use TYPHMAKE
use OUTPUT
use VARCOM
use DEFZONE
use LAPACK      ! linear algebra

implicit none

! -- Declaration des entrees --
real(krp)     :: dt              ! pas de temps propre a la zone
type(st_zone) :: zone            ! zone a integrer

! -- Declaration des sorties --
! retour des residus a travers le champ field de la structure zone ??

! -- Declaration des variables internes --
integer                :: ib, if, nf, dim, i, irhs, info
integer, dimension(:), &
           allocatable :: piv
type(st_grid), pointer :: pgrid
type(st_genericfield)  :: center, velocity
real(krp), dimension(:,:), allocatable &    ! 2 dimensions pour raisons informatiques
                       :: rhs
real(krp), dimension(:,:), allocatable &
                       :: mat
type(v3d)              :: vinf

! -- Debut de la procedure --


!-----------------------------------------------------------------------
! calcul du champ des vitesses induit (par singularites + vortex libres)
! aux points vortex uniquement

!pgrid => zone%grid
!do while (associated(pgrid))
  
!  call get_singularity_nodes(pgrid, center)
!
!  call calc_induced_velocity(zone, center, velocity) 

!  pgrid => pgrid%next
 
!enddo

! -- convection des tourbillons --
! a ajouter ! call calc_new_vortices

! -- emission des tourbillons aux limites --
! a ajouter ! call shed_vortices

!-----------------------------------------------------------------------
! dimensionnement

dim = 0
do ib = 1, zone%defsolver%nboco
  if (zone%defsolver%boco(ib)%typ_calc == bc_calc_singpanel) then
    !print*,"TEST DEBUG",associated(zone%defsolver%boco(ib)%boco_vortex%pgrid)
    dim = dim + zone%defsolver%boco(ib)%boco_vortex%pgrid%umesh%mesh%nface + 1
    ! DEV : memorisation d'indice ?
  endif
enddo

!-----------------------------------------------------------------------
! calcul de la vitesse normale locale aux centres de panneaux singularites

allocate(rhs(dim,1))
rhs(:,1) = 0._krp

!pgrid => zone%grid
!irhs  =  1
!nf    =  pgrid%umesh%nface
!do while (associated(pgrid))
!  call addtorhs_vect(rhs(irhs:irhs+nf-1), pgrid
!  pgrid => pgrid%next
!enddo

!-----------------------------------------------------------------------
! calcul du nouveau champ des vitesses induit 
! (par farfield + vortex libres)
! aux centres de panneaux singularites

do ib = 1, zone%defsolver%nboco  ! boucle sur boco / rech. de cond. champ lointain
  if (zone%defsolver%boco(ib)%typ_calc == bc_calc_farfield) then
    vinf  =  zone%defsolver%boco(ib)%boco_vortex%vect
  endif 
enddo

do ib = 1, zone%defsolver%nboco  ! boucle sur boco / rech. de cond. singularites
  if (zone%defsolver%boco(ib)%typ_calc == bc_calc_singpanel) then
    pgrid => zone%defsolver%boco(ib)%boco_vortex%pgrid
    ! DEV : memorisation de l'indice dans la structure boco_vortex
    irhs  =  0
    nf    =  pgrid%umesh%nface
    do if = 1, nf
      rhs(irhs+if,1) = rhs(irhs+if,1) - (vinf.scal.pgrid%umesh%mesh%iface(if,1,1)%normale)
    enddo
    irhs  = irhs + (nf+1)
  endif
enddo

!-----------------------------------------------------------------------
! calcul des singularites panneaux

allocate(mat(dim, dim)) 
mat(:,:) = 0._krp

! calcul de la matrice d'effets des singularites
!print*,'ngrid :',zone%ngrid
do ib = 1, zone%defsolver%nboco  ! boucle sur boco / rech. de cond. singularites
  if (zone%defsolver%boco(ib)%typ_calc == bc_calc_singpanel) then
    !print*,"TEST SNG DEBUG",associated(zone%defsolver%boco(ib)%boco_vortex%pgrid)
    pgrid => zone%defsolver%boco(ib)%boco_vortex%pgrid
    ! DEV : memorisation de l'indice dans la structure boco_vortex
    irhs  =  1
    nf    =  pgrid%umesh%nface
    call fillmat_sing_effects(mat, dim, irhs, pgrid, zone%defsolver)
    irhs  = irhs + (nf+1)
  endif
enddo

! ecriture des conditions de Kelvin (en instationnaire) (mat et rhs)
! DEV : init_boco_vortex !!!!!!!!! (connectivites)

! ecriture des conditions de Kutta-Joukowski (mat et rhs)
! DEV : init_boco_vortex !!!!!!!!! (connectivites)

do ib = 1, zone%defsolver%nboco  ! boucle sur boco / rech. de cond. KUTTA
  if (zone%defsolver%boco(ib)%typ_calc == bc_calc_kutta) then
    !print*,"TEST KT  DEBUG",associated(zone%defsolver%boco(ib)%boco_vortex%pgrid)
    pgrid => zone%defsolver%boco(ib)%boco_vortex%pgrid
    ! print*,pgrid%id
    !! DEV : memorisation de l'indice dans la structure boco_vortex
    !irhs  =  0
    nf    =  pgrid%umesh%nface
    ! DEV : PAR DEFAUT : KT sur premiere et derniere singularite de pgrid
    mat(nf+1, 1)    = 1._krp
    mat(nf+1, nf+1) = 1._krp
    rhs(nf+1, 1)    = 0._krp
  endif
enddo

! resolution

allocate(piv(dim))
piv(:) = 0

!print*,'mat:',real(mat,4)
!print*,'rhs:',real(rhs,4)

call erreur("development",&
            "dense LU decomposition no longer available")

!call lapack_getrf(dim, dim, mat, dim, piv, info)

if (info /= 0) call erreur("calcul des singularites",&
                           "probleme dans la decomposition LU")

!call lapack_getrs('N', dim, 1, mat, dim, piv, rhs, dim, info)

if (info /= 0) call erreur("calcul des singularites",&
                           "probleme dans l'inversion")

! redistribution des singularites

do ib = 1, zone%defsolver%nboco  ! boucle sur boco / rech. de cond. singularites
  if (zone%defsolver%boco(ib)%typ_calc == bc_calc_singpanel) then
    pgrid => zone%defsolver%boco(ib)%boco_vortex%pgrid
    ! DEV : memorisation de l'indice dans la structure boco_vortex
    irhs  =  0
    nf    =  pgrid%umesh%nface
    !print*,'debug field scalaires : ',pgrid%bocofield%nscal,'x',pgrid%bocofield%dim
    do if = 1, nf+1
      !print*,'debug redistribution ',if,'sur',nf ,':',rhs(irhs+if,1)
      pgrid%bocofield%tabscal(1)%scal(if) = rhs(irhs+if,1)
    enddo
    irhs  = irhs + (nf+1)
  endif
enddo

!print*,'inversion reussie (debug)'

! -- desallocation --
deallocate(mat, rhs, piv)

!-----------------------------
endsubroutine integration_zone_lag

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2004 : creation de la procedure
!------------------------------------------------------------------------------!
