subroutine lecture_elements(index_cg, nb, nz, nbcell, origine)                  

use CGNSLIB               ! d�finition des mots-clefs
use mod_origine           ! structure de donn�es r�ceptrices du maillage CGNS
use mod_connectivite      ! structure g�n�rale pour la connectivit�

implicit none

! -- Entr�es --
integer     :: index_cg   ! num�ro d'unit� du fichier CGNS
integer     :: nb, nz     ! index de base et de zone du fichier CGNS
integer     :: nbcell     ! nombre de cellules

! -- Sorties --
type(type_origine) :: origine     ! structure r�ceptrice de la connectivit� 

! -- Variables internes --                                        
integer           :: ier        ! code erreur
integer           :: ideb, ifin ! indice des cellules r�pertori�es dans la section
integer           :: itype      ! type de cellule
integer           :: nbd, ip    ! entiers non utilis�s en sortie
integer           :: nelem      ! nombre d'�l�ments dans la section
integer           :: nbtot      ! nombre total de sections
integer           :: nbnodes    ! nombre de noeuds pour un type d'�l�ment donn�
integer, dimension(:), allocatable &
                  :: typelem    ! tableau des types d'�l�ment
integer, dimension(:), allocatable &
                  :: typesect   ! flag de type de section i
                                !   0 : section � supprimer
                                !   1 : section LIMITE
                                !   2 : section ELEMENT
integer, dimension(:,:), allocatable &
                  :: elem       ! tableau de connectivit�
real,    dimension(:),   allocatable &
                  :: v          ! tableau de valeurs interm�diaires pour la lecture
integer           :: i, j, isect, ilim, last
character(len=32) :: nom

! -- D�but de proc�dure

! --- allocation  ---

print*
print*,"  * Lecture des connectivit�s :",nbcell,"�l�ments"

! --- Lecture du nombre de sections ---
! ( les cellules sont regroup�es par section selon leur type )

call cg_nsections_f(index_cg, nb, nz, nbtot, ier)
if (ier /= 0)   call erreur("Probl�me � la lecture du nombre de sections")

! --- Lecture des types de section ---

allocate( typelem(nbtot))
allocate(typesect(nbtot))

do i = 1, nbtot
  call cg_section_read_f(index_cg, nb, nz, i, nom, typelem(i), ideb, ifin, nbd, ip, ier)
  if (ier /= 0) call erreur("Probl�me � la lecture de section")
enddo

! --- D�termination maillage 2D ou 3D ---

origine%m3d = .false.    ! par d�faut

do i = 1, nbtot
  select case(typelem(i))
    case(NODE)
      ! call erreur("Element NODE inattendu")
    case(BAR_2)
    case(TRI_3, QUAD_4)
    case(TETRA_4, PYRA_5, PENTA_6, HEXA_8)
      origine%m3d = .true.
    case(BAR_3,TRI_6,QUAD_8,QUAD_9,TETRA_10,PYRA_14,PENTA_15,PENTA_18,HEXA_20,HEXA_27)
      call erreur("El�ment avec centres inter-sommets non g�r�s par CGNS_CEDRE")
    case(MIXED, NGON_n)
      call erreur("Type d'�l�ment interdit dans CGNS_CEDRE")
    case default
      call erreur("Type d'�l�ment non reconnu dans CGNSLIB")
  endselect
enddo

! --- Lecture du nombre de sections CELLULES et sections LIMITES ---
! ( le type d�pend du maillage, 3D ou non )

origine%nbsect = 0
origine%nblim  = 0

do i = 1, nbtot
  select case(typelem(i))
    case(NODE)
      typesect(i) = 0    ! section � supprimer (ne pas lire)
    case(BAR_2)
      if (origine%m3d) then
        ! call erreur("Element BAR_2 inattendu dans un maillage 3D")
        typesect(i) = 0  ! section � supprimer (ne pas lire)
      else
        origine%nblim  = origine%nblim  + 1
        typesect(i)    = 1   ! section de type LIMITE
      endif
    case(TRI_3, QUAD_4)
      if (origine%m3d) then
        origine%nblim  = origine%nblim  + 1
        typesect(i)    = 1   ! section de type LIMITE
      else
        origine%nbsect = origine%nbsect + 1
        typesect(i)    = 2   ! section de type CELLULE
      endif
    case(TETRA_4, PYRA_5, PENTA_6, HEXA_8)
      if (origine%m3d) then
        origine%nbsect = origine%nbsect + 1
        typesect(i)    = 2   ! section de type CELLULE
      else
        call erreur("Element inattendu dans un maillage 2D")
      endif
    case default
      call erreur("Type d'�l�ment de CGNSLIB non trait� par CGNS_CEDRE")
  endselect
enddo

print*,"    .",origine%nbsect,"section(s) de cellules"
print*,"    .",origine%nblim, "section(s) de faces limites"
allocate(origine%section(origine%nbsect))
allocate(origine%limite (origine%nblim))

! --- Boucle sur les sections (CELLULES et LIMITE) et lecture des connectivit�s  ---

nom   = ""
isect = 0     ! index de section CELLULE
ilim  = 0     ! index de section LIMITE

do i = 1, nbtot

  if (typesect(i) /= 0) then

    call cg_section_read_f(index_cg, nb, nz, i, nom, itype, ideb, ifin, nbd, ip, ier)
    if (ier /= 0) call erreur("Probl�me � la lecture de section")
    nelem = ifin-ideb+1

    !--- Calcul des nombres d'�l�ments et allocation ---
    select case(typesect(i))

    case(2) ! --- section type CELLULE ---
      isect = isect + 1
      print*
      print*,"    * section",i,"(",trim(nom),") de cellules      :",&
             nelem,trim(ElementTypeName(itype))
      origine%section(isect)%type = itype      ! type d'�l�ment
      origine%section(isect)%elements%nombre = nelem
      origine%section(isect)%nb              = nelem
      origine%section(isect)%ideb            = ideb
      origine%section(isect)%ifin            = ifin
      allocate(origine%section(isect)%elements%liste(ideb:ifin))

    case(1) ! --- section type LIMITE ---
      ilim = ilim + 1
      print*
      print*,"    * section",i,"(",trim(nom),") de faces limites :",&
             nelem,trim(ElementTypeName(itype))
      origine%limite(ilim)%type = itype      ! type d'�l�ment
      origine%limite(ilim)%elements%nombre = nelem
      origine%limite(ilim)%nb              = nelem
      origine%limite(ilim)%ideb            = ideb
      origine%limite(ilim)%ifin            = ifin
      allocate(origine%limite(ilim)%elements%liste(ideb:ifin))

    case default
      call erreur("Probl�me de coh�rence interne CGNS_CEDRE")
    endselect

    ! --- Lecture du nombre de noeuds pour le type itype ---
 
    call cg_npe_f(itype, nbnodes, ier)
    if (ier /= 0)    call erreur("Probl�me � la lecture du type d'�l�ment")
    if (nbnodes > maxconnect) &
      call erreur("Nombre de sommets maximal (8) d�pass� pour ce type")

    print*, "      . indices CGNS",ideb,"�",ifin,": lecture de connectivit�s"
  
    allocate(elem(nbnodes,ideb:ifin))
    elem = 0

    call cg_elements_read_f(index_cg, nb, nz, i, elem, ip, ier)
    if (ier /= 0) &
      call erreur("Probl�me � la lecture de connectivit� dans une section")

    ! --- Retranscription des donn�es dans la structure origine ---

    select case(typesect(i))

    case(2) ! --- section type CELLULE ---
      do j = ideb, ifin
        ! allocation de (nbnodes) sommets par cellules 
        allocate(origine%section(isect)%elements%liste(j)%article(nbnodes)) 
      enddo 
      ! -- retranscription dans la structure "origine" --
      do j = ideb, ifin
        origine%section(isect)%elements%liste(j)%article(1:nbnodes) = elem(1:nbnodes,j)
      enddo

    case(1) ! --- section type LIMITE ---
      do j = ideb, ifin
        ! allocation de (nbnodes) sommets par cellules 
        allocate(origine%limite(ilim)%elements%liste(j)%article(nbnodes)) 
      enddo 
      ! -- retranscription dans la structure "origine" --
      do j = ideb, ifin
        origine%limite(ilim)%elements%liste(j)%article(1:nbnodes) = elem(1:nbnodes,j)
      enddo

    case default
      call erreur("Probl�me de coh�rence interne CGNS_CEDRE")
    endselect

    ! --- d�sallocation ---
    deallocate(elem)

  endif ! test si section � supprimer

enddo ! boucle sur section

! --- Calcul des nouveaux index de cellules pour chacun des types ---
! (on renum�rote les cellules pour avoir une continuit� de la num�rotation)

print*
print*,"  * Renum�rotation continue des cellules et faces limites"

last = 0
do i = 1, origine%nbsect
  origine%section(i)%ideb = last + 1
  origine%section(i)%ifin = last + origine%section(i)%nb
  last = origine%section(i)%nb
enddo

last = 0
do i = 1, origine%nblim
  origine%limite(i)%ideb = last + 1
  origine%limite(i)%ifin = last + origine%limite(i)%nb
  last = origine%limite(i)%nb
enddo


! --- d�sallocation ---
deallocate(typelem, typesect)
   
!------------------------------
endsubroutine lecture_elements
