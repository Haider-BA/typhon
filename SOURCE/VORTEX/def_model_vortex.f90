!------------------------------------------------------------------------------!
! Procedure : def_model_vortex            Auteur : J. Gressier
!                                         Date   : F�vrier 2004
! Fonction                                Modif  : (cd historique)
!   Traitement des param�tres du fichier menu principal
!   Param�tres de d�finition du mod�le d'int�gration des VORTEX
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_model_vortex(block, defsolver)

use RPM
use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use MENU_VORTEX

implicit none

! -- Declaration des entr�es --
type(rpmblock), target :: block

! -- Declaration des sorties --
type(mnu_solver)       :: defsolver

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: nkey           ! nombre de clefs
integer                  :: i
character(len=dimrpmlig) :: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

call print_info(5,"- D�finition du mod�le de singularit�s tourbillonaires")

! -- Recherche du BLOCK:MODEL

pblock => block
call seekrpmblock(pblock, "MODEL", 0, pcour, nkey)

if (nkey /= 1) call erreur("lecture de menu", &
                           "bloc MODEL inexistant ou surnum�raire")

! -- lecture du type de singularit� VORTEX

defsolver%defvort%typ_vortex = cnull

call rpmgetkeyvalstr(pcour, "VORTEX", str)

if (samestring(str,"SINGULARITY")) defsolver%defvort%typ_vortex = vort_sng
if (samestring(str,"BLOB"))        defsolver%defvort%typ_vortex = vort_blob
if (samestring(str,"RING"))        defsolver%defvort%typ_vortex = vort_ring
if (samestring(str,"FILAMENT"))    defsolver%defvort%typ_vortex = vort_fil

select case(defsolver%defvort%typ_vortex)
case(vort_sng)
  call print_info(10,"    singularit�s VORTEX brutes")
case(vort_blob)
  call erreur("lecture de menu", "singularit� BLOB non impl�ment�e")
case(vort_ring)
  call erreur("lecture de menu", "singularit� RING non impl�ment�e")
case(vort_fil)
  call erreur("lecture de menu", "singularit� FILAMENT non impl�ment�e")
endselect


endsubroutine def_model_vortex

!------------------------------------------------------------------------------!
! Historique des modifications
!
! fev  2004 : cr�ation de la proc�dure
!------------------------------------------------------------------------------!
