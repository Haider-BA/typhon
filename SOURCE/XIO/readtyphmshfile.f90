!------------------------------------------------------------------------------!
! Procedure : readtyphmshfile             Auteur : J. Gressier
!                                         Date   : Fevrier 2004
! Fonction                                Modif  : (cf historique)
!   Lecture d'un fichier de maillage TYPHMSH
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine readtyphmshfile(unit, nom, zone)

use DEFZONE       ! structure ZONE
use OUTPUT        ! Sorties standard TYPHON
use DEFZONE
use MGRID
use MESHBASE

implicit none 

! -- Entr�es --
integer             :: unit       ! num�ro d'unit� pour la lecture
character(len=*)    :: nom

! -- Sorties --
type(st_zone) :: zone      ! structure de ZONE

! -- Variables internes --
integer                :: ier              ! code d'erreur
integer                :: i                ! indice courant
integer                :: ndom             ! nombre de domaine
character(len=60)      :: str              ! cha�ne
integer                :: mode             ! mode 1:ASCII 2:BINARY
character              :: typ_geo          ! type de g�om�trie
type(st_grid), pointer :: pgrid

! -- D�but de proc�dure
   
! --- Lecture du nom de fichier ---
   
! --- Ouverture du fichier ---

call print_info(5, "* LECTURE DU MAILLAGE TYPHMSH : "//trim(nom))

zone%typ_mesh = mshUST

call print_info(8, "Ouverture du fichier "//trim(nom))

open(unit=unit, file=nom, form="formatted", action="read", iostat=ier)
if (ier /= 0) call erreur("Lecture TYPHMSH","Probl�me � l'ouverture du fichier")

! -- v�rification du format TYPHMSH --

read(unit,*) str
if (.not.samestring(str,"TYPHMSH")) then 
  call erreur("Lecture TYPHMSH","Ent�te de fichier incorrecte")
endif

! -- mode de lecture --

read(unit,*) str
mode = inull
if (samestring(str,"ASCII"))  mode = 1
if (samestring(str,"BINARY")) mode = 2
if (mode == inull)  call erreur("Lecture TYPHMSH","Ent�te de fichier incorrecte")

! -- type de rep�re --

read(unit,*) str
typ_geo = cnull
if (samestring(str,"1DC")) typ_geo = msh_1dcurv
if (samestring(str,"2D"))  typ_geo = msh_2dplan
if (samestring(str,"2DC")) typ_geo = msh_2dcurv
if (samestring(str,"3D"))  typ_geo = msh_3d
if (typ_geo == cnull) call erreur("Lecture TYPHMSH","type de g�om�trie incorrect")

! -- nombre de courbes (domaines de maillage) --

read(unit,*) ndom

if (ndom /= 1) call erreur("D�veloppement","nombre de domaines limit� � 1")

pgrid => newgrid(zone)

do i = 1, ndom

  call readtyphmsh_dom(unit, pgrid%umesh, typ_geo)

!  ! -- cr�ation des conditions limites --
!
!  call typhmsh_createboco(pgrid)

enddo
   
! --- fermeture du fichier ---

close(ier)
call print_info(8, "Fermeture du fichier "//trim(nom))



!-------------------------
endsubroutine readtyphmshfile

!------------------------------------------------------------------------------!
! Historique des modifications
!
! fev  2004 : cr�ation de la proc�dure
! mars 2004 : affectation des maillages aux structures "grid"
!------------------------------------------------------------------------------!
