!------------------------------------------------------------------------------!
! Procedure : def_param                   Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  : Novembre 2002
!   Lecture des menus et traitement pour d�finition des param�tres
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine def_param(lworld)

use RPM        ! librairie de blocs RPM pour la lecture des param�tres
use TYPHMAKE   ! d�finition de la pr�cision
use OUTPUT     ! d�finition des unit�s de sortie
use MODWORLD   ! d�finition des donn�es globales

implicit none

! -- Declaration des entr�es --

! -- Declaration des sorties --
type(st_world) :: lworld

! -- Declaration des variables internes --
type(rpmblock), pointer :: firstblock
integer                 :: info         ! etat de l'ouverture de fichier
character(len=strlen)   :: fic

! -- Debut de la procedure --

call print_etape("> LECTURE : fichier menu principal")

fic = "main.rpm"

open(unit=uf_menu, file=trim(fic), iostat=info)
if (info /= 0) call erreur("Lecture du menu","fichier "//trim(fic)// &
                           " introuvable ou interdit en lecture")

allocate(firstblock)
nullify(firstblock)   ! n�cessaire pour le bon fonctionnement de readrpmblock

call readrpmblock(uf_menu, uf_log, 1, firstblock) ! Lecture du fichier de param�tres
close(uf_menu)

!call printrpmblock(6,firstblock,.false.)

call print_etape("> PARAMETRES : traitement et initialisation")

call trait_param(firstblock, lworld)

call dealloc_rpmblock(firstblock)            ! D�sallocation de la liste RPM


endsubroutine def_param
