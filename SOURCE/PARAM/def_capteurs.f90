!------------------------------------------------------------------------------!
! Procedure : def_capteurs                Auteur : J. Gressier
!                                         Date   : Novembre 2003
! Fonction                                Modif  : (cf historique)
!   Traitement des param�tres du fichier menu principal
!   Param�tres de d�finition des capteurs
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine def_capteurs(block, isolver, defsolver)

use RPM
use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use MENU_BOCO

implicit none

! -- Declaration des entr�es --
type(rpmblock), target :: block
integer                :: isolver

! -- Declaration des sorties --
type(mnu_solver)                             :: defsolver

! -- Declaration des variables internes --
type(rpmblock), pointer  :: pblock, pcour  ! pointeur de bloc RPM
integer                  :: nprobe         ! nombre   de capteurs
integer                  :: ip, nkey
character(len=dimrpmlig) :: str            ! cha�ne RPM interm�diaire

! -- Debut de la procedure --

call print_info(5,"- D�finition des capteurs")

! -- Recherche du BLOCK:BOCO

pblock => block
call seekrpmblock(pblock, "PROBE", 0, pcour, nprobe)
defsolver%nprobe = nprobe

if (nprobe < 1) then

  call print_info(5,"  pas de capteur d�fini")

else

  allocate(defsolver%probe(nprobe))

  do ip = 1, nprobe

    call seekrpmblock(pblock, "PROBE", ip, pcour, nkey)

    ! -- D�termination du type et du nom

    call rpmgetkeyvalstr(pcour, "TYPE", str)

    defsolver%probe(ip)%type = cnull

    if (samestring(str, "PROBE" ))         defsolver%probe(ip)%type = probe
    if (samestring(str, "BOCO_FIELD" ))    defsolver%probe(ip)%type = boco_field
    if (samestring(str, "BOCO_INTEGRAL" )) defsolver%probe(ip)%type = boco_integral
    if (samestring(str, "RESIDUALS" ))     defsolver%probe(ip)%type = residuals
    
    ! message d'erreur � la lecture de param�tres suivants

    call rpmgetkeyvalstr(pcour, "NAME", str)
    defsolver%probe(ip)%name = str

    ! -- Lecture des param�tres selon le type --

    select case(defsolver%probe(ip)%type)

    case(probe)
      call erreur("D�veloppement","PROBE: type PROBE non impl�ment�")

    case(boco_field, boco_integral)
      call rpmgetkeyvalstr(pcour, "BOCO", str)
      defsolver%probe(ip)%boco_name  = str
      defsolver%probe(ip)%boco_index = indexboco(defsolver, str)
      if (defsolver%probe(ip)%boco_index == inull) then
        call erreur("d�finition de capteurs",trim(str)//" nom de condition limite inexistant")
      endif

    case(residuals)
      call erreur("D�veloppement","PROBE: type RESIDUALS non impl�ment�")

    case default
      call erreur("lecture de menu (PROBE)","type de capteur inconnu")
    endselect

    ! -- D�termination de la quantit� � lire

    call rpmgetkeyvalstr(pcour, "QUANTITY", str)
    defsolver%probe(ip)%quantity = quantity(str)

    if (defsolver%probe(ip)%quantity == inull) then
      call erreur("lecture de menu (PROBE)","quantit� inconnue")
    endif  

    ! DEV: v�rification du type en fonction du solveur  

  enddo

endif


endsubroutine def_capteurs

!------------------------------------------------------------------------------!
! Historique des modifications
!
! nov  2003 : cr�ation de la routine
!------------------------------------------------------------------------------!


