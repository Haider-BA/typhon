!------------------------------------------------------------------------------!
! Procedure : init_connect_grid           Auteur : J. Gressier
!                                         Date   : Mars 2004
! Fonction                                Modif  : (cf historique)
!   Calcul des connectivit�s suppl�mentaires (conditions limites)
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine init_connect_grid(defsolver, grid)

use TYPHMAKE
use STRING
use VARCOM
use OUTPUT
use MGRID
use MENU_SOLVER

implicit none

! -- Declaration des entr�es --
type(mnu_solver) :: defsolver            ! param�tres du solveur

! -- Declaration des entr�es/sorties --
type(st_grid)    :: grid                 ! maillage et connectivit�s

! -- Declaration des sorties --

! -- Declaration des variables internes --
integer :: ib, idef                      ! index de conditions aux limites et index de d�finition
logical :: same_name

! -- Debut de la procedure --

call print_info(10,"  Grille "//name(grid))

write(str_w,'(a,i8,a,i8,a,i7,a)') "  connectivit� :",grid%umesh%ncell," cellules dont",&
                                  grid%umesh%ncell_int," internes et",&
                                  grid%umesh%ncell_lim," limites"
call print_info(10, str_w)
write(str_w,'(a,i8,a,i8,a,i7,a)') "  connectivit� :",grid%umesh%nface," faces    dont",&
                                  grid%umesh%nface_int," internes et",&
                                  grid%umesh%nface_lim," limites"
call print_info(10, str_w)

call print_info(8, ". initialisation des connectivit�s faces limites -> cellules limites")

! -- D�finition des connectivit�s faces limites -> cellules limites

grid%umesh%ncell_lim = 0     ! initialisation du compteur de cellules limites

! Boucle sur les conditions aux limites

do ib = 1, grid%umesh%nboco

  ! recherche d'une d�finition (boco) par nom de famille

  same_name = .false.
  idef      = 0
  do while ((.not.same_name).and.(idef+1 <= defsolver%nboco))
    idef      = idef + 1
    !print*,'debug:',grid%umesh%boco(ib)%family, defsolver%boco(idef)%family
    same_name = samestring(grid%umesh%boco(ib)%family, defsolver%boco(idef)%family)
  enddo
  if (same_name) then
    grid%umesh%boco(ib)%idefboco = idef
  else
    call erreur("D�finition des conditions aux limites", &
                "la d�finition de la famille "//trim(grid%umesh%boco(ib)%family)// &
                " est introuvable")
  endif

  ! affectation 

  select case(defsolver%boco(idef)%typ_calc)
  case(bc_calc_ghostface)
    call init_ustboco_ghostface(ib, defsolver%boco(idef), grid%umesh)
  case(bc_calc_singpanel)
    call init_ustboco_singpanel(ib, defsolver%boco(idef), grid)
  case(bc_calc_kutta)
    call init_ustboco_kutta(ib, defsolver%boco(idef), grid)
  case default
    call erreur("Incoh�rence interne (init_connect_grid)","type d'impl�mentation boco inconnu")
  endselect 

enddo

write(str_w,'(a,i8,a,i8,a,i7,a)') "  connectivit� :",grid%umesh%ncell," cellules dont",&
                                  grid%umesh%ncell_int," internes et",&
                                  grid%umesh%ncell_lim," limites"
call print_info(10, str_w)
write(str_w,'(a,i8,a,i8,a,i7,a)') "  connectivit� :",grid%umesh%nface," faces    dont",&
                                  grid%umesh%nface_int," internes et",&
                                  grid%umesh%nface_lim," limites"
call print_info(10, str_w)

endsubroutine init_connect_grid

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2004 : cr�ation de la proc�dure (copie de init_connect_grid)
!------------------------------------------------------------------------------!
