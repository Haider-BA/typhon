!!------------------------------------------------------------------------------!
! Procedure : implicit_step               Auteur : J. Gressier
!                                         Date   : Avril 2004
! Fonction                                Modif  : (cf historique)
!   Integration implicit de domaine
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine implicit_step(dt, typtemps, defsolver, defspat, deftime, &
                         umesh, field, coupling, ncp)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use MENU_NUM
use USTMESH
use DEFFIELD
use SPARSE_MAT
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
type(st_dlu)          :: mat
type(st_genericfield) :: flux             ! tableaux des flux
real(krp), dimension(:), allocatable &
                      :: jacL, jacR       ! tableaux de jacobiennes des flux
integer(kip)          :: if, ic1, ic2, ic, info

! -- Debut de la procedure --

allocate(jacL(umesh%nface))
allocate(jacR(umesh%nface))

!--------------------------------------------------
! phase explicite : calcul du second membre
!--------------------------------------------------

! -- allocation des flux et termes sources --

call new(flux, umesh%nface, field%nscal, field%nvect, 0)

select case(defsolver%typ_solver)
case(solKDIF)
  call integration_kdif_ust(dt, defsolver, defspat, umesh, field, flux, .true., jacL, jacR)
case default
  call erreur("incoh�rence interne (implicit_step)", "solveur inconnu")
endselect

! -- flux surfaciques -> flux de surfaces et calcul des r�sidus  --

call flux_to_res(dt, umesh, flux, field%residu, .true., jacL, jacR)


!--------------------------------------------------
! phase implicite 
!--------------------------------------------------

! DEV : on ne devrait allouer que les faces internes

call new(mat, umesh%ncell_int, umesh%nface)  ! allocation et initialisation
mat%couple%fils(1:mat%ncouple, 1:2) = umesh%facecell%fils(1:mat%ncouple, 1:2) 

! -- suppression de l'influence des cellules limites --
! l'�ventuelle d�pendance de la cellule gauche via la cellule limite
! doit d�j� �tre dans jacL

do if = 1, mat%ncouple
  if (mat%couple%fils(if,2) > mat%dim) jacR(if) = 0._krp
enddo

! construction de la matrice

do if = 1, mat%ncouple
  ic1 = mat%couple%fils(if,1)    
  ic2 = mat%couple%fils(if,2)    
  ! bilan cellule � gauche de la face
  mat%diag(ic1) = mat%diag(ic1) + jacL(if)
  mat%upper(if) = + jacR(if)    ! ic1 cell is supposed to the lowest index
  ! bilan cellule � droite de la face
  if (ic2 <= mat%dim) then
    mat%diag(ic2) = mat%diag(ic2) - jacR(if)
    mat%lower(if) = - jacL(if)  ! ic2 cell is supposed to the highest index
  endif
enddo

do ic = 1, mat%dim
  mat%diag(ic) = mat%diag(ic) + umesh%mesh%volume(ic,1,1) / dt
  !mat%diag(ic) = umesh%mesh%volume(ic,1,1) / dt
enddo

deallocate(jacL, jacR)

! r�solution

select case(deftime%implicite%methode)
case(alg_lu)
  call dlu_lu(mat, field%residu%tabscal(1)%scal, field%residu%tabscal(1)%scal)

case(alg_jac)
  call dlu_jacobi(deftime%implicite, mat, field%residu%tabscal(1)%scal, &
                  field%residu%tabscal(1)%scal, info)
  if (info < 0) call print_warning("m�thode d'inversion JACOBI non converg�e")

case(alg_gs)
  call erreur("d�veloppement","M�thode Gauss-Seidel non impl�ment�e")

case(alg_sor)
  call erreur("d�veloppement","M�thode SOR non impl�ment�e")
  
case default
  call erreur("incoh�rence","m�thode d'inversion inconnue")
endselect

call delete(mat)

!--------------------------------------------------

!select case(typtemps)
! case(instationnaire) ! corrections de flux seulement en instationnaire

! ! Calcul de l'"�nergie" � l'interface, en vue de la correction de flux, pour 
! ! le couplage avec �changes espac�s
! !DVT : flux%tabscal(1) !
! if (ncp>0) then
!   call accumulfluxcorr(dt, defsolver, umesh%nboco, umesh%boco, &
!                        umesh%nface, flux%tabscal(1)%scal, ncp, &
!                        coupling)
! endif

!endselect

if (ncp > 0) call erreur("D�veloppement","couplage interdit en implicite")

call delete(flux)


endsubroutine implicit_step

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avr  2004 : cr�ation de la proc�dure
!------------------------------------------------------------------------------!
