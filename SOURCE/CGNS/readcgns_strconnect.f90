!------------------------------------------------------------------------------!
! Procedure : readcgns_strconnect                Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  :
!   Lecture des de la connectivit� de tous les �lements
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine readcgns_strconnect(unit, ib, iz, zone, nmax_elem)                 

use CGNSLIB       ! d�finition des mots-clefs
use CGNS_STRUCT   ! D�finition des structures CGNS
use OUTPUT        ! Sorties standard TYPHON

implicit none

! -- Entr�es --
integer             :: unit       ! num�ro d'unit� pour la lecture
integer             :: ib, iz     ! num�ro de base et de zone
integer             :: nmax_elem  ! nombre total d'�l�ments

! -- Sorties --
type(st_cgns_zone)  :: zone       ! connectivit� cellule->sommets
                                  !              faces  ->sommets
                                  ! dans la structure zone

! -- Variables internes --                                        
integer             :: ier        ! code erreur
integer             :: ifam, nfam ! indice de famille et nombre total de familles
integer             :: ideb, ifin ! indice des cellules r�pertori�es dans la section
integer             :: itype      ! type d'�l�ment
integer             :: nbd, ip    ! entiers non utilis�s en sortie

! -- D�but de proc�dure

write(str_w,'(a,i8,a)') "lecture des connectivit�s du maillage non structur� :",nmax_elem,"�l�ments"
call print_info(5, adjustl(str_w))

! --- Lecture du nombre de sections ---
! (les cellules sont regroup�es par section selon leur type)

call cg_nsections_f(unit, ib, iz, nfam, ier)
if (ier /= 0)   call erreur("Lecture CGNS","Probl�me � la lecture du nombre de sections")

! --- Lecture des types de section et affectation aux familles ---




!------------------------------
endsubroutine readcgns_strconnect
