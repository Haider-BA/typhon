!------------------------------------------------------------------------------!
! Procedure : calc_ustmesh                Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : (cf historique)
!   Calcul et initialisation d'un maillage non structur�, n�cessite
!     en entr�e : liste des sommets et coordonn�es
!                 connectivit�s faces->sommets et faces->cellules
!
! Defauts/Limitations/Divers :
!   Apr�s avoir calcul� les faces (centres Hi, normales, surfaces), on d�coupe
!   les cellules en (n) volumes �l�mentaires chacun d�fini par un centre (midcell)
!   de cellule et une face (pour chacune des (n) faces).
!   On calcule le volume et le centre de gravit� de chacun des volumes �l�mentaires
!   pour ensuite calculer le volume et le centre de gravit� de la cellule compl�te.
!   (la m�thode est indiff�rente en 2D ou 3D, seules les formules de calcul
!   du volume (surface en 2D) et des centres de gravit� des volumes �l�mentaires
!   changent).
!
!------------------------------------------------------------------------------!
subroutine calc_ustmesh(ust_mesh)

use TYPHMAKE
use OUTPUT
use USTMESH

implicit none

! -- Declaration des entr�es --

! -- Declaration des entr�es/sorties --
type(st_ustmesh) :: ust_mesh

! -- Declaration des sorties --

! -- Declaration des variables internes --
integer                                :: i
type(v3d), dimension(:),   allocatable :: cgface
type(v3d), dimension(:),   allocatable :: midcell   ! centres approch�s de cellule
type(v3d), dimension(:,:), allocatable :: cg_elem   ! centres de volume �l�mentaire
real(krp), dimension(:,:), allocatable :: vol_elem  ! volumes �l�mentaires

! -- Debut de la procedure --

call test_ustmesh(ust_mesh)

! -- allocation --
! les allocations de faces et cellules g�om�triques sont de taille (nface) et (ncell)
! (nombre d'�l�ments limites ou fictifs inclus)
! le calcul se fait sur toutes les faces mais uniquement sur les cellules internes.

! allocation des faces g�om�triques si n�cessaire
if (ust_mesh%mesh%nface == 0) then
  ust_mesh%mesh%nface = ust_mesh%nface                  ! copie du nombre de faces
  allocate(ust_mesh%mesh%iface(ust_mesh%nface,1,1))     ! allocation des faces
endif

allocate(cgface(ust_mesh%nface))                      ! tab. interm. centre G des faces
  ! les centres G des faces sont maintenant m�moris�es dans la liste de faces
  ! il n'est pas utile d'allouer un tableau s�par�ment

!-------------------------------------------------------------------
! Calcul des faces (centres, normales et surfaces)

call calc_ust_face(ust_mesh%facevtex, ust_mesh%mesh, cgface)


select case(typgeo(ust_mesh))

!-------------------------------------------------------------------
! maillage de cellules + faces

case(msh_2dplan, msh_3d)

  ! -- Calcul de centres de cellules (centres approximatifs)

  allocate(midcell(ust_mesh%ncell))
  call calc_ust_midcell(ust_mesh%ncell_int, ust_mesh%facecell, cgface, midcell)

  ! -- Calcul des volumes �l�mentaires (volume et centre de gravit�)

  allocate(cg_elem (ust_mesh%nface,2))
  allocate(vol_elem(ust_mesh%nface,2))
  call calc_ust_elemvol(typgeo(ust_mesh), ust_mesh%ncell_int, ust_mesh%nface, &
                        midcell, ust_mesh%facecell,                     &
                        cgface, ust_mesh%mesh%iface, cg_elem, vol_elem)

  ! -- Calcul des cellules (volumes et centre de gravit�)

  ! attention : les allocations se font sur (ncell) et les calculs sur (ncell_int)
  ! on choisit d'allouer par d�faut toutes les cellules y compris les cellules fictives,
  ! m�me si elles ne sont pas utilis�es par le code (�conomie en m�moire � rechercher)

  allocate(ust_mesh%mesh%centre(ust_mesh%ncell,1,1))
  allocate(ust_mesh%mesh%volume(ust_mesh%ncell,1,1))

  ust_mesh%mesh%centre(1:ust_mesh%ncell,1,1) = v3d(0.,0.,0.)
  ust_mesh%mesh%volume(1:ust_mesh%ncell,1,1) = 0._krp

  call calc_ust_cell(ust_mesh%ncell_int, ust_mesh%nface, &
                     ust_mesh%facecell, cg_elem, vol_elem, ust_mesh%mesh)

  ! -- V�rification de l'orientation des normales et connectivit�s face->cellules

  call calc_ust_checkface(ust_mesh%facecell, ust_mesh%mesh)

  ! d�sallocation tableaux interm�diaires

  deallocate(cgface, midcell, cg_elem, vol_elem)

!-------------------------------------------------------------------
! maillage de facettes uniquement (solveur VORTEX)

case(msh_1dcurv, msh_2dcurv)

! DEV ! VERIFIER L'ORIENTATION DES NORMALES A L'EXTERIEUR DES CORPS (INTERIEUR FLUIDE)

case default

  call erreur("D�veloppement","cas inattendu (calc_ustmesh)")

endselect


endsubroutine calc_ustmesh

!------------------------------------------------------------------------------!
! Historique des modifications
!
! nov  2002 : cr�ation de la proc�dure
! f�v  2003 : int�gration du calcul des m�triques
!------------------------------------------------------------------------------!
