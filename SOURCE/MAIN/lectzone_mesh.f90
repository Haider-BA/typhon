!------------------------------------------------------------------------------!
! Procedure : lectzone_mesh               Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : (cf historique)
!   Lecture des maillages
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine lectzone_mesh(zone)

use TYPHMAKE
use OUTPUT
use VARCOM
use DEFZONE
use CGNS_STRUCT

implicit none

! -- Declaration des entr�es/sorties --
type(st_zone) :: zone

! -- Declaration des entr�es --

! -- Declaration des sorties --

! -- Declaration des variables internes --
type(st_cgns_world) :: cgnsworld      ! structure des donn�es CGNS

! -- Debut de la procedure --

select case(zone%defmesh%format)

case(fmt_CGNS) ! Format de fichier CGNS

  ! DEV : num�ro d'unit� inutile
  call readcgnsfile(15, zone%defmesh%fichier, cgnsworld)
  call print_info(2, "* CONVERSION DES DONNEES CGNS -> TYPHON")
  if (cgnsworld%nbase /= 1) call erreur("CGNS -> TYPHON",&
                                        "trop de bases dans la structure CGNS")

  ! -- D�finition minimale du maillage --
  !  coordonn�es de sommets
  !  connectivit�s face->cellules
  !  connectivit�s face->sommets
  call cgns2typhon_zone(cgnsworld%base(1), zone)
  ! DEV : call delete(cgnsworld)

case(fmt_TYPHMSH) ! Format de fichier CGNS

  call readtyphmshfile(15, zone%defmesh%fichier, zone)
  !call print_info(2, "* C TYPHON")
  !if (cgnsworld%nbase /= 1) call erreur("CGNS -> TYPHON",&
  !                                      "trop de bases dans la structure CGNS")

  !call cgns2typhon_zone(cgnsworld%base(1), zone)

case default
  call erreur("Lecture de maillage","format de maillage inconnu")
endselect


endsubroutine lectzone_mesh

!------------------------------------------------------------------------------!
! Historique des modifications
!
! nov  2002 : cr�ation de la proc�dure (lecture de maillage CGNS)
! fev  2004 : lecture de maillage TYPHMSH 
!------------------------------------------------------------------------------!
