!------------------------------------------------------------------------------!
! Procedure : reorder_ustconnect.f90      Auteur : J. Gressier
!                                         Date   : F�vrier 2003
! Fonction                                Modif  :
!   Renum�rotation des faces (faces internes puis faces limites)
!     et des connectivit�s associ�es
!
! Defauts/Limitations/Divers :
!   choix des actions � effectuer par (iaction)
!     O: action sur les connectivit�s, pas le maillage
!     1: action sur connectivit�s et maillage
!
!------------------------------------------------------------------------------!
subroutine reorder_ustconnect(iaction, mesh) 

use USTMESH       ! D�finition des structures maillage non structur�

implicit none 

! -- Entr�es --
integer             :: iaction

! -- Entr�es/Sorties --
type(st_ustmesh)    :: mesh            ! maillage non structur� et connectivit�

! -- Variables internes --
type(st_ustconnect) :: f_vtex, f_cell  ! conn. Typhon interm�diaire : face -> sommets
integer, dimension(:), allocatable &
                    :: trans_index     ! nouvelle renum�rotation
integer             :: nface_int       ! nombre de faces internes
integer             :: nface_lim       ! nombre de faces limites
integer             :: ntotface        ! nombre total de faces
integer             :: if, oldf, newf

! -- D�but de proc�dure

if (iaction /= 0) then
  call erreur("D�veloppement","cas inattendu dans 'reorder_ustconnect'")
endif

ntotface = mesh%facecell%nbnodes
allocate(trans_index(ntotface))

! -- renum�rotation des faces (faces limites en dernier) --

nface_int = 0
nface_lim = 0

! calcul des nombres de faces et de la transposition d'index
do if = 1, ntotface
  if (mesh%facecell%fils(if,2) == 0) then     ! si face(if) est face limite
    nface_lim = nface_lim + 1
    trans_index(ntotface+1-nface_lim) = if
  else
    nface_int = nface_int + 1
    trans_index(nface_int) = if
  endif
enddo

! copie des connectivit�s
f_vtex = copy(mesh%facevtex)
f_cell = copy(mesh%facecell)
!print*,"!! DEBUG    f_vtex :",transpose(f_vtex%fils(:,:))
!print*,"!! DEBUG face_vtex :",transpose(mesh%facevtex%fils(:,:))

! transposition d'index
do if = 1, ntotface
  oldf = trans_index(if)
  newf = if
  mesh%facecell%fils(newf,:) = f_cell%fils(oldf,:)
  mesh%facevtex%fils(newf,:) = f_vtex%fils(oldf,:)
  !print*,"!! DEBUG trans ",oldf, newf,":", mesh%facevtex%fils(newf,:),"<=",f_vtex%fils(oldf,:)
enddo

mesh%nface_int = nface_int
mesh%nface_lim = nface_lim

!print*,"!! DEBUG trans index :",trans_index(:)
!print*,"!! DEBUG    f_vtex :",transpose(f_vtex%fils(:,:))
!print*,"!! DEBUG face_vtex :",transpose(mesh%facevtex%fils(:,:))

! desallocation
call delete(f_vtex)
call delete(f_cell)
deallocate(trans_index)

!-------------------------
endsubroutine reorder_ustconnect

!------------------------------------------------------------------------------!
! Historique des modifications
!
! fev 2003 (v0.0.1b): cr�ation de la proc�dure
!------------------------------------------------------------------------------!



