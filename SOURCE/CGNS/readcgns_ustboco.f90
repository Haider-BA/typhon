!------------------------------------------------------------------------------!
! Procedure : readcgns_ustboco            Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : (cd historique)
!   Lecture de conditions aux limites pour maillage non structur�
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine readcgns_ustboco(unit, ib, iz, ibc, boco)                 

use CGNSLIB       ! d�finition des mots-clefs
use CGNS_STRUCT   ! D�finition des structures CGNS
use OUTPUT        ! Sorties standard TYPHON
use STRING

implicit none

! -- Entr�es --
integer            :: unit         ! num�ro d'unit� pour la lecture
integer            :: ib, iz, ibc  ! num�ro de base, zone et condition aux limites

! -- Sorties --
type(st_cgns_boco) :: boco         ! structure "condition aux limites"

! -- Variables internes --                                        
integer             :: ier         ! code erreur
integer             :: bctyp       ! type   de condition aux limites
integer             :: pttyp       ! type   de r�f�rence
integer             :: npts        ! nombre de sommets r�f�renc�s
integer             :: n1, n2, n3, nd ! variables fantomes

! -- D�but de proc�dure


! --- Lecture des informations ---

boco%nom = ""
call cg_boco_info_f(unit, ib, iz, ibc, boco%nom, bctyp, pttyp, npts, &
                    n1, n2, n3, nd, ier)
if (ier /= 0) call erreur("Lecture CGNS","Probl�me � la lecture des conditions aux limites")

! --- nom de famille selon le type de d�finition ---

select case(bctyp)

case(FamilySpecified)
  call erreur("D�veloppement","Cas CGNS/boco non impl�ment�")

case default
  call cg_goto_f(unit, ib, ier, 'Zone_t', iz, 'ZoneBC_t', 1, 'BC_t',ibc, 'end')
  if (ier /= 0) call erreur("Lecture CGNS","Probl�me lors du parcours ADF")
  call cg_famname_read_f(boco%family, ier)
  if (ier /= 0) call erreur("Lecture CGNS","Probl�me � la lecture du nom de famille")
  call cg_gridlocation_read_f(boco%gridlocation, ier)
  if (ier /= 0) then
    call print_warning("Lecture CGNS : type de connectivit� non d�fini (VERTEX par d�faut)")
    boco%gridlocation = Vertex
  endif
endselect
 
!write(str_w,*) 
call print_info(5, ". condition aux limites"//strof(ibc,3)//" : "//trim(boco%family))
call print_info(8, "type "//trim(BCTypeName(bctyp)))

! --- Lecture des noeuds ou faces r�f�renc�s --

call new(boco%list, npts)

select case(pttyp)

case(PointList)
  call cg_boco_read_f(unit, ib, iz, ibc, boco%list%fils(1:npts), n1, ier)
  if (ier /= 0) call erreur("Lecture CGNS", "Probl�me � la lecture des conditions aux limites")

case(PointRange)
  call erreur("Gestion CGNS","type de r�f�rence (PointRange) inattendu en non structur�")

case default
  call erreur("Gestion CGNS","type de r�f�rence inattendu dans cette version CGNS")

endselect


!------------------------------
endsubroutine readcgns_ustboco
