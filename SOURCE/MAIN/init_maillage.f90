!------------------------------------------------------------------------------!
! Procedure : init_maillage               Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : (cf historique)
!   Calcul et initialisation du maillage
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine init_maillage(zone)

use TYPHMAKE
use VARCOM
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
  call erreur("D�v�loppement (init_maillage)", &
              "maillage structur� non impl�ment�")
  !do i = 1, zone%str_mesh%nblock
  !  call integration_strdomaine(dt, zone%typ_solver, zone%str_mesh%block(i))
  !enddo

case(mshUST)

  select case(zone%defsolver%typ_solver)

  case(solKDIF)
    call calc_ustmesh(zone%ust_mesh)

  case(solVORTEX)
    pgrid => zone%grid
    do while (associated(pgrid))
      call calc_ustmesh(pgrid%umesh)
      pgrid => pgrid%next
    enddo
    
  case default
  endselect

case default
  call erreur("incoh�rence interne (init_maillage)", &
              "type de maillage inconnu")

endselect


endsubroutine init_maillage

!------------------------------------------------------------------------------!
! Historique des modifications
!
! nov  2002 : cr�ation de la proc�dure
! mars 2004 : traitement des grilles (VORTEX)
!------------------------------------------------------------------------------!

