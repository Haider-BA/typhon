!------------------------------------------------------------------------------!
! Procedure : output_tec_str              Auteur : J. Gressier
!                                         Date   : D�cembre 2002
! Fonction                                Modif  : 
!   Ecriture fichier des champs STRUCTURES de chaque zone au format TECPLOT
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine output_tec_str(uf, mesh)

use TYPHMAKE
use OUTPUT
use VARCOM
use MODWORLD

implicit none

! -- Declaration des entr�es --
integer          :: uf            ! unit� d'�criture
type(st_strmesh) :: mesh          ! maillage � �crire

! -- Declaration des sorties --

! -- Declaration des variables internes --
integer :: izone
integer :: info

! -- Debut de la procedure --

write(uf_chpresu,'(a)') 'ZONE T="STRMESH", F=POINT"'


endsubroutine output_tec_str
