!------------------------------------------------------------------------------!
! Procedure : integration_kdif_ust        Auteur : J. Gressier
!                                         Date   : Avril 2003
! Fonction                                Modif  : juin 2003
!   Integration d'un domaine non structur�
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine integration_kdif_ust(dt, defsolver, domaine, field, flux)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use USTMESH
use DEFFIELD
use EQKDIF

implicit none

! -- Declaration des entr�es --
real(krp)        :: dt               ! pas de temps CFL
type(mnu_solver) :: defsolver        ! type d'�quation � r�soudre
type(st_ustmesh) :: domaine          ! domaine non structur� � int�grer

! -- Declaration des entr�es/sorties --
type(st_field)   :: field            ! champ des valeurs et r�sidus

! -- Declaration des sorties --
type(st_genericfield) :: flux

! -- Declaration des variables internes --
integer :: if, nfb              ! index de face et taille de bloc courant
integer :: nbuf                 ! taille de buffer 
integer :: ib, nbloc            ! index de bloc et nombre de blocs
integer :: ideb                 ! index de d�but de bloc
integer :: it                   ! index de tableau
integer :: icl, icr             ! index de cellule � gauche et � droite
type(st_kdifetat), dimension(:), allocatable & 
        :: cell_l, cell_r       ! tableau de cellules � gauche et � droite   
type(v3d), dimension(:), allocatable &
        :: cg_l, cg_r           ! tableau des centres de cellules � gauche et � droite   

! -- Debut de la procedure --

! A ce niveau, on est cens� appeler une routine qui int�gre aussi bien les flux
! dans un domaine structur� que dans un domaine non structur�
! On peut ici d�couper la maillage complet en blocs de taille fix� pour optimiser
! l'encombrement m�moire et la vectorisation

! nombre de blocs (<= taille_buffer) n�cessaires pour domaine%nface
nbloc = 1 + (domaine%nface-1) / taille_buffer
nbuf  = 1 + (domaine%nface-1) / nbloc          ! taille de bloc buffer
nfb   = 1 + mod(domaine%nface-1, nbuf)         ! taille de 1er bloc peut �tre <> de nbuf

!print*,"!!! DEBUG integration kdif", domaine%nface, nbloc, nbuf, nfb, taille_buffer

! il sera � tester l'utilisation de tableaux de champs g�n�riques plut�t que
! des d�finitions type d'�tat sp�cifiques (st_kdifetat)

allocate(cell_l(nbuf), cell_r(nbuf))
allocate(  cg_l(nbuf),   cg_r(nbuf))

ideb = 1

do ib = 1, nbloc

  !print*,"!!! DEBUG integration bloc,",ib," de",ideb," �",ideb+nfb-1

  do it = 1, nfb
    if  = ideb+it-1
    icl = domaine%facecell%fils(if,1)
    icr = domaine%facecell%fils(if,2)
    !cell_l(it) = cons2kdif(defsolver%defkdif, field%etat(icl, 1, 1, 1:field%dim_etat))
    !cell_r(it) = cons2kdif(defsolver%defkdif, field%etat(icr, 1, 1, 1:field%dim_etat))
    cell_l(it)%temperature = field%etatprim%tabscal(1)%scal(icl)
    cell_r(it)%temperature = field%etatprim%tabscal(1)%scal(icr)
    cg_l(it)   = domaine%mesh%centre(icl, 1, 1)
    cg_r(it)   = domaine%mesh%centre(icr, 1, 1)
  enddo

  ! - dans une version ult�rieure, il sera n�cessaire de faire intervenir les gradients
  ! - l'acc�s au tableau flux n'est pas programm� de mani�re g�n�rale !!! DEV

  ! ATTENTION : le flux n'est pass� ici que pour UN SEUL scalaire

  call calc_kdif_flux(defsolver, nfb, domaine%mesh%iface(ideb:ideb+nfb-1, 1, 1), &
                      cg_l, cell_l, cg_r, cell_r,                                &
                      flux%tabscal(1)%scal(ideb:ideb+nfb-1))

  ideb = ideb + nfb
  nfb  = nbuf         ! tous les blocs suivants sont de taille nbuf
  
enddo

deallocate(cell_l, cell_r, cg_l, cg_r)

endsubroutine integration_kdif_ust

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avril 2003 (v0.0.1b) : cr�ation de la proc�dure
! juin  2003           : m�j gestion variables conservatives et primitives
!------------------------------------------------------------------------------!