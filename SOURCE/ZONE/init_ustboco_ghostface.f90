!------------------------------------------------------------------------------!
! Procedure : init_ustboco_ghostface      Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  :
!   Affectation des connectivit�s entre faces limites et cellules limites
!   pour le type "ghostface" (point fictif sur la face) : cela revient �
!   avoir une cellule fictive de volume nul.
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine init_ustboco_ghostface(ib, defboco, ust_mesh)

use TYPHMAKE
!use VARCOM
use OUTPUT
use USTMESH
use MENU_BOCO

implicit none

! -- Declaration des entr�es --
integer        :: ib                     ! num�ro de condition aux limites
type(mnu_boco) :: defboco                ! param�tres du solveur

! -- Declaration des entr�es/sorties --
type(st_ustmesh) :: ust_mesh             ! maillage et connectivit�s

! -- Declaration des sorties --

! -- Declaration des variables internes --
integer :: if                            ! indice boco et de face
integer :: icell, iface                  ! index de cellule et de face

! -- Debut de la procedure --

! affectation de connectivit� face limites -> cellules fictives
! la variable ust_mesh%ncell_lim contient le nombre courant de cellules limites affect�es

! le tableau de cellules est cens� pouvoir contenir le nombre de cellules fictives (test)

if ((ust_mesh%ncell_lim+ust_mesh%boco(ib)%nface)>(ust_mesh%ncell-ust_mesh%ncell_int)) then
  call erreur("Allocation","Pas assez de cellules allou�es pour les cellules fictives")
endif

! -- boucle sur la liste des faces de la condition limite --

print*,"GHOST" !! DEBUG
  
do if = 1, ust_mesh%boco(ib)%nface    
  
  ! affectation de connectivit� face limites -> cellules fictives
  ust_mesh%ncell_lim = ust_mesh%ncell_lim + 1     ! nouvelle cellule limite
  icell = ust_mesh%ncell_int + ust_mesh%ncell_lim ! index de cellule limite
  iface = ust_mesh%boco(ib)%iface(if)             ! index de face

  ! d�finition g�om�trique de la cellule fictive
  ust_mesh%mesh%volume(icell,1,1) = 0._krp
  ust_mesh%mesh%centre(icell,1,1) = ust_mesh%mesh%iface(iface,1,1)%centre
  print*,"ghost-cell",icell," / face", iface, ust_mesh%mesh%centre(icell,1,1) !! DEBUG
  
  if (ust_mesh%facecell%fils(iface,2) == 0) then
    ust_mesh%facecell%fils(iface,2) = icell        ! affectation de la cellule fictive
  else
    call erreur("Initialisation de connectivit�", &
                "Connectivit� d�j� affect�e sur face limite")
  endif

enddo

endsubroutine init_ustboco_ghostface

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2003 (v0.0.1b): cr�ation de la proc�dure
!------------------------------------------------------------------------------!
