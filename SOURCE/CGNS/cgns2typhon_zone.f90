!------------------------------------------------------------------------------!
! Procedure : cgns2typhon_zone            Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  : F�vrier 2003
!   Conversion d'une base CGNS en ZONE Typhon
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine cgns2typhon_zone(cgnsbase, typhonzone) 

use CGNS_STRUCT   ! D�finition des structures CGNS
use DEFZONE       ! D�finition des structures TYPHON
use OUTPUT        ! Sorties standard TYPHON
use VARCOM        ! Variables globales et d�finition de constantes

implicit none 

! -- Entr�es --
type(st_cgns_base) :: cgnsbase        ! structure des donn�es CGNS

! -- Sorties --
type(st_zone)      :: typhonzone      ! structure des donn�es TYPHON

! -- Variables internes --
integer       :: i, ist         ! indices courants

! -- D�but de proc�dure

call print_info(5, "- conversion de la zone "//trim(cgnsbase%nom))

typhonzone%ndom      = cgnsbase%nzone       ! (!) une zone CGNS est un domaine de maillage
typhonzone%nmesh_str = cgnsbase%nzone_str
typhonzone%nmesh_ust = cgnsbase%nzone_ust

if (cgnsbase%nzone_ust > 1) then
  call erreur("Conversion CGNS/TYPHON","Un seul domaine non structur� admis")
endif

! allocation des domaines structur�s
if (typhonzone%nmesh_str >= 1) then
  allocate(typhonzone%str_mesh(typhonzone%nmesh_str))
endif

ist = 0

do i = 1, typhonzone%ndom

  select case(cgnsbase%zone(i)%type)
  case(Structured)
    call erreur("D�veloppement","Maillage structur� non impl�ment�")
    ist = ist + 1
    typhonzone%typ_mesh = mshSTR
    !call cgns2typhon_strmesh(cgnsbase%zone(i), typhonzone%str_mesh(ist))

  case(Unstructured)
    typhonzone%typ_mesh = mshUST
    call cgns2typhon_ustmesh(cgnsbase%zone(i), typhonzone%ust_mesh)

  case default
    call erreur("D�veloppement","Type de maillage non pr�vu")
  endselect
  
enddo

call print_info(8, "Fin de la conversion CGNS -> TYPHON")


!-------------------------
endsubroutine cgns2typhon_zone
