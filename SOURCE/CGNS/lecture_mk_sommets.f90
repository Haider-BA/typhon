!--------------------------------------------------------------------------!
!--------------------------------------------------------------------------!
subroutine lecture_mk_sommets(index_cg, nb, nz, origine)                 

use CGNSLIB               ! d�finition des mots-clefs
use mod_origine           ! structure r�ceptrices des donn�es CGNS

implicit none

! -- Entr�es --
integer       :: index_cg   ! num�ro d'unit� du fichier CGNS
integer       :: nb, nz     ! index de base et de zone du fichier CGNS

! -- Sorties --
type(type_origine) :: origine     ! structure r�ceptrice des �l�ments CGNS

! -- Variables internes --                                        
integer       :: ier        ! code erreur
real, dimension(:), allocatable &
              :: v          ! tableau de valeurs interm�diaires pour la lecture
integer       :: ibc        ! index  de condition aux limites
integer       :: bctype     ! type   de condition aux limites
integer       :: pointtype  ! type   de r�f�rence
integer       :: npts       ! nombre de sommets r�f�renc�s
integer       :: n1, n2, n3, nd ! variables fantomes
character(len=32) :: nom    ! nom de condition aux limites

!----------------------
! D�but de proc�dure

print*
print*,"  * Lecture des sommets marqu�s"

call cg_nbocos_f(index_cg, nb, nz, origine%nboco, ier)
if (ier /= 0) call erreur("Probl�me � la lecture du nombre BC")

allocate(origine%mk_sommets(origine%nboco))

! --- Lecture des conditions aux limites  ---

do ibc = 1, origine%nboco

  ! -- Lecture du type BC et nombre de r�f�rences --
  nom = "" 
  call cg_boco_info_f(index_cg, nb, nz, ibc, nom, bctype, pointtype, npts, &
                      n1, n2, n3, nd, ier)
  if (ier /= 0) call erreur("Probl�me � la lecture des conditions aux limites")

  print*,"    . BC",ibc,": type ",trim(BCTypeName(bctype)),",",npts,"sommets"

  if (pointtype /= PointList) then
    print*,"r�f�rence de type ",trim(PointSetTypeName(pointtype))
    call erreur("le type de r�f�rence aux �l�ments BC n'est pas reconnu")
  endif

  ! -- Allocation --
  origine%mk_sommets(ibc)%nombre = npts
  allocate(origine%mk_sommets(ibc)%article(npts))

  call cg_boco_read_f(index_cg, nb, nz, ibc,           &
                      origine%mk_sommets(ibc)%article, &
                      n1, ier)
  if (ier /= 0) call erreur("Probl�me � la lecture des conditions aux limites")


  call cg_goto_f(index_cg, nb, ier, 'Zone_t',nz, 'ZoneBC_t',1, 'BC_t',ibc, 'end')
  if (ier /= 0) call erreur("Probl�me lors de la recherche de la zone")
  call cg_famname_read_f(nom, ier)
  if (ier /= 0) call erreur("Probl�me � la lecture du nom de famille")

  print*,"             famille ",trim(nom)
  origine%mk_sommets(ibc)%nom = nom

enddo


!------------------------------
endsubroutine lecture_mk_sommets
