!------------------------------------------------------------------------------!
! Procedure : cgns2typhon                 Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  :
!   Conversion d'une structure CGNS compl�te dans la structure de donn�es
!   de TYPHON.
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine cgns2typhon(cgnsworld, typhonworld) 

use CGNS_STRUCT   ! Definition des structures CGNS
use MODWORLD
use DEFZONE          ! Definition des structures TYPHON
use OUTPUT        ! Sorties standard TYPHON


implicit none 

! -- Entr�es --
type(st_cgns_world) :: cgnsworld      ! structure des donn�es CGNS

! -- Sorties --
type(st_world)      :: typhonworld    ! structure des donn�es TYPHON

! -- Variables internes --
integer       :: i                ! indice courant

! -- D�but de proc�dure

call print_info(2, "* CONVERSION DES DONNEES CGNS -> TYPHON")

typhonworld%prj%nzone = cgnsworld%nbase
allocate(typhonworld%zone(typhonworld%prj%nzone))

do i = 1, typhonworld%prj%nzone

  call cgns2typhon_zone(cgnsworld%base(i), typhonworld%zone(i))

enddo

call print_info(8, "Fin de la conversion CGNS -> TYPHON")


!-------------------------
endsubroutine cgns2typhon
