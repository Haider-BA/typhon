!------------------------------------------------------------------------------!
! Procedure : init_connect                Auteur : J. Gressier
!                                         Date   : Mars 2003
! Fonction                                Modif  : (cf historique)
!   Initialisation des connectivit�s des conditions limites
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine init_connect(zone)

use TYPHMAKE
use VARCOM     ! D�finition des constantes
use OUTPUT
use DEFZONE

implicit none

! -- Declaration des entr�es --

! -- Declaration des entr�es/sorties --
type(st_zone) :: zone

! -- Declaration des sorties --

! -- Declaration des variables internes --
type(st_grid), pointer :: pgrid

! -- Debut de la procedure --

select case(zone%typ_mesh)

case(mshSTR)
  call erreur("D�veloppement (init_maillage)", &
              "maillage structur� non impl�ment�")

case(mshUST)
  select case(zone%defsolver%typ_solver)

  case(solKDIF)
    call  init_connect_ust(zone%defsolver, zone%ust_mesh)

  case(solVORTEX)
    pgrid => zone%grid
    do while (associated(pgrid))
      call init_connect_grid(zone%defsolver, pgrid)
      pgrid => pgrid%next
    enddo
    
  case default
  endselect

case default
  call erreur("incoh�rence interne (init_maillage)", &
              "type de maillage inconnu")

endselect

endsubroutine init_connect


!------------------------------------------------------------------------------!
! Historique des modifications
!
! mars 2003 : cr�ation de la proc�dure
! mars 2004 : ajout du traitement GRID (solveur VORTEX)
!------------------------------------------------------------------------------!
