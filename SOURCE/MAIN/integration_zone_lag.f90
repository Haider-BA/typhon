!------------------------------------------------------------------------------!
! Procedure : integration_zone_lag        Auteur : J. Gressier
!                                         Date   : Mars 2004
! Fonction                                Modif  : (cf historique)
!   Int�gration de tous les domaines d'une zone sur un pas de temps correspondant 
!   � une it�ration
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine integration_zone_lag(dt, zone)

use TYPHMAKE
use OUTPUT
use VARCOM
use DEFZONE
use LAPACK      ! biblioth�que d'alg�bre lin�aire

implicit none

! -- Declaration des entr�es --
real(krp)     :: dt              ! pas de temps propre � la zone
type(st_zone) :: zone            ! zone � int�grer

! -- Declaration des sorties --
! retour des r�sidus � travers le champ field de la structure zone ??

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
! calcul du champ des vitesses induit (par singularit�s + vortex libres)
! aux points vortex uniquement

!pgrid => zone%grid
!do while (associated(pgrid))
  
!  call get_singularity_nodes(pgrid, center)
!
!  call calc_induced_velocity(zone, center, velocity) 

!  pgrid => pgrid%next
 
!enddo

! -- convection des tourbillons --
! � ajouter ! call calc_new_vortices

! -- emission des tourbillons aux limites --
! � ajouter ! call shed_vortices

!-----------------------------------------------------------------------
! dimensionnement

dim = 0
do ib = 1, zone%defsolver%nboco
  if (zone%defsolver%boco(ib)%typ_calc == bc_calc_singpanel) then
    !print*,"TEST DEBUG",associated(zone%defsolver%boco(ib)%boco_vortex%pgrid)
    dim = dim + zone%defsolver%boco(ib)%boco_vortex%pgrid%umesh%mesh%nface + 1
    ! DEV : m�morisation d'indice ?
  endif
enddo

!-----------------------------------------------------------------------
! calcul de la vitesse normale locale aux centres de panneaux singularit�s

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
! aux centres de panneaux singularit�s

do ib = 1, zone%defsolver%nboco  ! boucle sur boco / rech. de cond. champ lointain
  if (zone%defsolver%boco(ib)%typ_calc == bc_calc_farfield) then
    vinf  =  zone%defsolver%boco(ib)%boco_vortex%vect
  endif 
enddo

do ib = 1, zone%defsolver%nboco  ! boucle sur boco / rech. de cond. singularit�s
  if (zone%defsolver%boco(ib)%typ_calc == bc_calc_singpanel) then
    pgrid => zone%defsolver%boco(ib)%boco_vortex%pgrid
    ! DEV : m�morisation de l'indice dans la structure boco_vortex
    irhs  =  0
    nf    =  pgrid%umesh%nface
    do if = 1, nf
      rhs(irhs+if,1) = rhs(irhs+if,1) - (vinf.scal.pgrid%umesh%mesh%iface(if,1,1)%normale)
    enddo
    irhs  = irhs + (nf+1)
  endif
enddo

!-----------------------------------------------------------------------
! calcul des singularit�s panneaux

allocate(mat(dim, dim)) 
mat(:,:) = 0._krp

! calcul de la matrice d'effets des singularit�s
!print*,'ngrid :',zone%ngrid
do ib = 1, zone%defsolver%nboco  ! boucle sur boco / rech. de cond. singularit�s
  if (zone%defsolver%boco(ib)%typ_calc == bc_calc_singpanel) then
    !print*,"TEST SNG DEBUG",associated(zone%defsolver%boco(ib)%boco_vortex%pgrid)
    pgrid => zone%defsolver%boco(ib)%boco_vortex%pgrid
    ! DEV : m�morisation de l'indice dans la structure boco_vortex
    irhs  =  1
    nf    =  pgrid%umesh%nface
    call fillmat_sing_effects(mat, dim, irhs, pgrid, zone%defsolver)
    irhs  = irhs + (nf+1)
  endif
enddo

! �criture des conditions de Kelvin (en instationnaire) (mat et rhs)
! DEV : init_boco_vortex !!!!!!!!! (connectivit�s)

! �criture des conditions de Kutta-Joukowski (mat et rhs)
! DEV : init_boco_vortex !!!!!!!!! (connectivit�s)

do ib = 1, zone%defsolver%nboco  ! boucle sur boco / rech. de cond. KUTTA
  if (zone%defsolver%boco(ib)%typ_calc == bc_calc_kutta) then
    !print*,"TEST KT  DEBUG",associated(zone%defsolver%boco(ib)%boco_vortex%pgrid)
    pgrid => zone%defsolver%boco(ib)%boco_vortex%pgrid
    ! print*,pgrid%id
    !! DEV : m�morisation de l'indice dans la structure boco_vortex
    !irhs  =  0
    nf    =  pgrid%umesh%nface
    ! DEV : PAR DEFAUT : KT sur premi�re et derni�re singularit� de pgrid
    mat(nf+1, 1)    = 1._krp
    mat(nf+1, nf+1) = 1._krp
    rhs(nf+1, 1)    = 0._krp
  endif
enddo

! r�solution

allocate(piv(dim))
piv(:) = 0

!print*,'mat:',real(mat,4)
!print*,'rhs:',real(rhs,4)

call lapack_getrf(dim, dim, mat, dim, piv, info)

if (info /= 0) call erreur("calcul des singularit�s",&
                           "probl�me dans la d�composition LU")

call lapack_getrs('N', dim, 1, mat, dim, piv, rhs, dim, info)

if (info /= 0) call erreur("calcul des singularit�s",&
                           "probl�me dans l'inversion")

! redistribution des singularit�s

do ib = 1, zone%defsolver%nboco  ! boucle sur boco / rech. de cond. singularit�s
  if (zone%defsolver%boco(ib)%typ_calc == bc_calc_singpanel) then
    pgrid => zone%defsolver%boco(ib)%boco_vortex%pgrid
    ! DEV : m�morisation de l'indice dans la structure boco_vortex
    irhs  =  0
    nf    =  pgrid%umesh%nface
    !print*,'debug field scalaires : ',pgrid%bocofield%nscal,'x',pgrid%bocofield%dim
    do if = 1, nf+1
      print*,'debug redistribution ',if,'sur',nf ,':',rhs(irhs+if,1)
      pgrid%bocofield%tabscal(1)%scal(if) = rhs(irhs+if,1)
    enddo
    irhs  = irhs + (nf+1)
  endif
enddo

!print*,'inversion r�ussie (debug)'

! -- d�sallocation --
deallocate(mat, rhs, piv)

!-----------------------------
endsubroutine integration_zone_lag

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2004 : cr�ation de la proc�dure
!------------------------------------------------------------------------------!
