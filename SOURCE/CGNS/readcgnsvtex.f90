!------------------------------------------------------------------------------!
! Procedure : readcgnsvtex                Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  :
!   Lecture des sommets d'une zone
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine readcgnsvtex(unit, ib, iz, mesh)                 

use CGNSLIB       ! d�finition des mots-clefs
use CGNS_STRUCT   ! D�finition des structures CGNS
use OUTPUT        ! Sorties standard TYPHON

implicit none

! -- Entr�es --
integer             :: unit       ! num�ro d'unit� pour la lecture
integer             :: ib, iz     ! num�ro de base et de zone

! -- Sorties --
type(st_cgns_vtex)  :: mesh       ! sommets de la zone

! -- Variables internes --                                        
integer             :: ier        ! code erreur
real(4), dimension(:,:,:), allocatable &
                    :: vs         ! tableau de valeurs interm�diaires SINGLE 
real(8), dimension(:,:,:), allocatable &
                    :: vd         ! tableau de valeurs interm�diaires DOUBLE
integer             :: i, j, k

! -- D�but de proc�dure

write(str_w,*) "lecture de maillage :",mesh%ni,"x",mesh%nj,"x",mesh%nk,"noeuds"
call print_info(5, adjustl(str_w))

! allocation des tableaux interm�diaires 
! (en re�l simple uniquement dans cette version)

allocate(vs(mesh%ni,mesh%nj,mesh%nk))

! --- Lecture du maillage  ---

! Lecture de X
call cg_coord_read_f(unit, ib, iz, 'CoordinateX', RealSingle, (/ 1, 1, 1/), &
                     (/ mesh%ni,mesh%nj,mesh%nk /), vs, ier)
if (ier /= 0) call erreur("Lecture CGNS","Probl�me � la lecture de la coordonn�e X")

! retranscription
do k = 1, mesh%nk
  do j = 1, mesh%nj
    do i = 1, mesh%ni
      mesh%vertex(i,j,k)%x = vs(i,j,k)
    enddo
  enddo
enddo

! Lecture de Y
call cg_coord_read_f(unit, ib, iz, 'CoordinateY', RealSingle, (/ 1, 1, 1/), &
                     (/ mesh%ni,mesh%nj,mesh%nk /), vs, ier)
if (ier /= 0) call erreur("Lecture CGNS","Probl�me � la lecture de la coordonn�e Y")

! retranscription
do k = 1, mesh%nk
  do j = 1, mesh%nj
    do i = 1, mesh%ni
      mesh%vertex(i,j,k)%y = vs(i,j,k)
    enddo
  enddo
enddo

! Lecture de Z
call cg_coord_read_f(unit, ib, iz, 'CoordinateZ', RealSingle, (/ 1, 1, 1/), &
                     (/ mesh%ni, mesh%nj,mesh%nk /), vs, ier)
if (ier /= 0)   call erreur("Lecture CGNS","Probl�me � la lecture de la coordonn�e Z")

! retranscription
do k = 1, mesh%nk
  do j = 1, mesh%nj
    do i = 1, mesh%ni
      mesh%vertex(i,j,k)%z = vs(i,j,k)
    enddo
  enddo
enddo


deallocate(vs)


!------------------------------
endsubroutine readcgnsvtex
