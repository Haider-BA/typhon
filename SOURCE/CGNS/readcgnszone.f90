!------------------------------------------------------------------------------!
! Procedure : readcgnszone                Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  :
!   Lecture d'une zone d'un fichier CGNS
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine readcgnszone(unit, ib, iz, zone) 

use CGNSLIB       ! d�finition des mots-clefs
use CGNS_STRUCT   ! D�finition des structures CGNS
use OUTPUT        ! Sorties standard TYPHON

implicit none 

! -- Entr�es --
integer             :: unit       ! num�ro d'unit� pour la lecture
integer             :: ib, iz     ! num�ro de base et de zone

! -- Sorties --
type(st_cgns_zone)  :: zone       ! structure CGNS : zone

! -- Variables internes --
integer       :: size(3,3)        ! tableau d'informations de la zone
integer       :: ier              ! code d'erreur
integer       :: i, ibc           ! indice courant
integer       :: nmax_elem        ! nombre total d'�l�ments

! -- D�but de proc�dure
   
! --- Lecture du type de zone ---
          
call cg_zone_type_f(unit, ib, iz, zone%type, ier)
if (ier /= 0) call erreur("Lecture CGNS","Probl�me � la lecture du type de zone")

select case(zone%type)
  case(Structured,Unstructured)
    write(str_w,'(a,i3,a,a)') "- Zone",iz,": type",ZoneTypeName(zone%type)
    call print_info(5, adjustl(str_w))
  case default
    call erreur("Lecture CGNS","zone "//trim(ZoneTypeName(zone%type))//" inconnue")
endselect

! --- Lecture des informations de la zone ---

call cg_zone_read_f(unit, ib, iz, zone%nom, size, ier)
if (ier /= 0)   call erreur("Lecture CGNS","Probl�me � la lecture de la zone")

select case(zone%type)

  case(Structured)     ! cas STRUCTURE
    ! size(1:3, 1:3) contient             (cf CGNS Mid-level Library)
    !     (1:3, 1) le nombre de sommets ni,nj,nk
    !     (1:3, 2) le nombre de cellules
    !     (1:3, 3) ?
    zone%mesh%ni = size(1,1)
    zone%mesh%nj = size(2,1)
    zone%mesh%nk = size(3,1)

  case(Unstructured)   ! cas NON STRUCTURE
    ! size(1:3, 1) contient             (cf CGNS Mid-level Library)
    !     (1, 1) le nombre de sommets
    !     (2, 1) le nombre de cellules
    !     (3, 1) le nombre de sommets aux limites
    ! ce sont en fait les trois premiers entiers du tableau sous forme lin�aire
    zone%mesh%ni = size(1,1)
    zone%mesh%nj = 1
    zone%mesh%nk = 1
    nmax_elem    = size(2,1)

  case default
    call erreur("Gestion CGNS","type non reconnu")
endselect

! --- Allocation et Lecture des sommets du maillage ---

allocate(zone%mesh%vertex(zone%mesh%ni, zone%mesh%nj, zone%mesh%nk)) 
call readcgnsvtex(unit, ib, iz, zone%mesh)
   
! --- Lecture des connectivit�s  ---

select case(zone%type)

case(Structured)
  call erreur("D�veloppement",&
              "la lecture de connectivit� multibloc n'est pas impl�ment�e")
  !call readcgns_strconnect(unit, ib, iz, zone, nmax_elem)

case(Unstructured)
  call readcgns_ustconnect(unit, ib, iz, zone, nmax_elem)

case default
  call erreur("D�veloppement", "incoh�rence de programmation (zone%imesh)")
endselect

! --- Lecture des conditions aux limites ---

call cg_nbocos_f(unit, ib, iz, zone%nboco, ier)
if (ier /= 0) call erreur("Lecture CGNS","Probl�me � la lecture du nombre BoCo")

write(str_w,*) ". lecture de ",zone%nboco," conditions aux limites"
call print_info(5, adjustl(str_w))

allocate(zone%boco(zone%nboco))

do ibc = 1, zone%nboco

  select case(zone%type)

  case(Structured)
    call erreur("D�veloppement",&
                "la lecture de connectivit� multibloc n'est pas impl�ment�e")
    !call readcgns_strboco(unit, ib, iz, ibc, zone%boco(ibc))

  case(Unstructured)
    call readcgns_ustboco(unit, ib, iz, ibc, zone%boco(ibc))

  case default
    call erreur("D�veloppement", "incoh�rence de programmation (zone%imesh)")
  endselect


enddo




! --- fermeture du fichier ---

call cg_close_f(unit, ier)



!-------------------------
endsubroutine readcgnszone
