!------------------------------------------------------------------------------!
! Procedure : extract_points              Auteur : J. Gressier
!                                         Date   : Juin 2003
! Fonction                                Modif  :
!   Extraction d'une liste de points � partir d'une liste d'index
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine extract_points(umesh, index, liste)

use TYPHMAKE
use GEO3D
use OUTPUT
use USTMESH

implicit none

! -- Declaration des entr�es --
type(st_ustmesh) :: umesh
integer, dimension(1:umesh%nvtex) :: index     ! liste des index des points renum�rot�s

! -- Declaration des entr�es/sorties --

! -- Declaration des sorties --
type(v3d), dimension(*) :: liste  ! liste des sommets � extraire

! -- Declaration des variables internes --
integer :: if, iface, iv, nvtex

! -- Debut de la procedure --

!! instruction where ?

do iv = 1, umesh%nvtex
  if (index(iv) /= 0) then
    liste(index(iv)) = umesh%mesh%vertex(iv,1,1)
  endif
enddo


endsubroutine extract_points

!------------------------------------------------------------------------------!
! Historique des modifications
!
! Juin 2003 (v0.0.1b): cr�ation de la proc�dure
! 
!------------------------------------------------------------------------------!