!------------------------------------------------------------------------------!
! Procedure : readcgnsbase                Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  :
!   Lecture d'une base d'un fichier CGNS
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine readcgnsbase(unit, ib,  base) 

use CGNSLIB       ! d�finition des mots-clefs
use CGNS_STRUCT   ! D�finition des structures CGNS
use OUTPUT        ! Sorties standard TYPHON

implicit none 

! -- Entr�es --
integer             :: unit       ! num�ro d'unit� pour la lecture
integer             :: ib         ! num�ro de base

! -- Sorties --
type(st_cgns_base)  :: base       ! structure CGNS : base

! -- Variables internes --
integer       :: ier              ! code d'erreur
integer       :: iz               ! indice courant de zone
character(len=10), dimension(2:3), parameter &
              :: type_maillage = (/ "surfacique", "volumique " /)

! -- D�but de proc�dure
   
! --- Lecture des infos de la base ---

call cg_base_read_f(unit, ib, base%nom, base%imesh, base%igeo, ier)

!!print*,unit, ib, base%nom, base%imesh, base%igeo, ier !! DEBUG
!!call cg_error_exit_f                                  !! DEBUG
!! BUG : test d�sactiv� car ier /= 0 meme si tout est correct
!if (ier /= 0) call erreur("Lecture CGNS","Probl�me � la lecture de la base")

call print_info(5,"- BASE "//trim(base%nom)//" : maillage "//type_maillage(base%imesh))
   
! --- Lecture du nombre de zones ---

call cg_nzones_f(unit, ib, base%nzone, ier)

write(str_w,'(2x,i2,a,i2)') base%nzone," zone(s) dans la base ",ib
call print_info(8, "   "//adjustl(str_w))

if (ier /= 0) call erreur("Lecture CGNS","Probl�me � la lecture du nombre de zones")
 
! --- Allocation et Lecture des zones ---

base%nzone_str = 0
base%nzone_ust = 0
allocate(base%zone(base%nzone))

do iz = 1, base%nzone

  ! les maillages (2D ou 3D) sont de meme type que la base

  base%zone(iz)%imesh = base%imesh   
  call readcgnszone(unit, ib, iz, base%zone(iz))

  ! D�nombrement des zones structur�es et non structur�es

  select case(base%zone(iz)%type)
  case(Structured)
    base%nzone_str = base%nzone_str + 1
  case(Unstructured)
    base%nzone_ust = base%nzone_ust + 1
  case default
    call erreur("D�veloppement","Type de maillage non pr�vu")
  endselect

enddo
 

!-------------------------
endsubroutine readcgnsbase
