!------------------------------------------------------------------------------!
! MODULE : OUTPUT                         Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  :
!   D�finition des unit�s d'entr�es/sorties du programme TYPHON
!   D�finition des proc�dures d'�critures
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
 
module OUTPUT

use TYPHMAKE   ! Definition de la precision

implicit none

! -- Variables globales du module -------------------------------------------

! niveaux d'�critures

integer  std_maxlevel ! profondeur d'affichage maximale en sortie standard
integer  log_maxlevel ! profondeur d'affichage maximale en fichier log

! unit�s d'entr�es 

integer  uf_stdin     ! entr�e standard
integer  uf_menu      ! menus
integer  uf_mesh      ! maillages
integer  uf_cdlim     ! conditions aux limites

! unit�s de sorties

integer  uf_stdout    ! sortie standard (informations standard)
integer  uf_log       ! fichier log     (informations d�taill�es)
integer  uf_monres    ! residual monitor
integer  uf_monphy    ! physical value monitor
integer  uf_residu    ! residus
integer  uf_mesure    ! mesures diverses
integer  uf_chpresu   ! champs de r�sultats
integer  uf_compflux  ! comparaison des flux � l'interface
integer  uf_correction  ! correction  DEV2602
integer  uf_tempinter ! temp�rature interface DEV1404

! unit�s de entr�es/sorties 

integer  uf_reprise   ! fichier reprise

! divers

character(len=256) :: str_w   ! chaine provisoire pour l'�criture sur unit�
character(len=6), parameter :: str_std = "[STD] ", &   ! pr�fixe d'�criture std/log
                               str_log = "      "      ! pr�fixe d'�criture log/log

! -- DECLARATIONS -----------------------------------------------------------


! -- INTERFACES -------------------------------------------------------------


! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
contains

!------------------------------------------------------------------------------!
! Procedure : init_output                 Auteur : J. Gressier
!                                         Date   : Novembre 2002
! Fonction                                Modif  :
!   Initialisation des constantes, niveaux et unit�s
!
!------------------------------------------------------------------------------!
subroutine init_output()
implicit none

! -- Debut de la procedure --

  std_maxlevel = 100  !  15   ! profondeur d'affichage maximale en sortie standard
  log_maxlevel = 100  ! profondeur d'affichage maximale en fichier log

  ! unit�s d'entr�es 
  uf_stdin   = 5     ! entr�e standard
  uf_menu    = 10    ! menus
  uf_mesh    = 20    ! maillages
  uf_cdlim   = 30    ! conditions aux limites

  ! unit�s de sorties
  uf_stdout  = 6    ! sortie standard (informations standard)
  uf_log     = 9    ! fichier log     (informations d�taill�es)
  uf_monres  = 31   ! monres file : residual monitor
  uf_monphy  = 32   ! monphy file : physical value monitor
  uf_residu  = 40   ! residus
  uf_mesure  = 50   ! mesures diverses
  uf_chpresu = 55   ! champs r�sultats
  uf_compflux= 56   ! comparaison de flux � l'interface
  uf_tempinter=57   ! DEV1404
  uf_correction = 1000 !DEV2602

  open(unit=uf_log, file = "typhon.log", form="formatted")  

  ! unit�s de entr�es/sorties 
  uf_reprise = 60   ! fichier reprise


endsubroutine init_output


!------------------------------------------------------------------------------!
! Procedure : print_etape                 Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  :
!   Ecriture en sortie standard et dans le fichier log des entetes de commandes
!
!------------------------------------------------------------------------------!
subroutine print_etape(str)
implicit none

! -- Declaration des entr�es/sorties --
  character(len=*) str

! -- Debut de la procedure --

  call print_info(0,   "")
  call print_info(100, repeat('#',len_trim(str)+8))
  call print_info(0,   trim(str))

endsubroutine print_etape
  

!------------------------------------------------------------------------------!
! Procedure : print_warning               Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  :
!   Ecriture dans le fichier log des warnings
!
!------------------------------------------------------------------------------!
subroutine print_warning(str)
implicit none

! -- Declaration des entr�es/sorties --
  character(len=*) str

! -- Debut de la procedure --

  write(uf_log,'(aa)')   "[WARNING] ",trim(str)

endsubroutine print_warning
  

!------------------------------------------------------------------------------!
! Procedure : print_info                  Auteur : J. Gressier
!                                         Date   : November 2002
! Fonction                                Modif  :
!   Ecriture en sortie standard et dans le fichier log selon niveaux
!
!------------------------------------------------------------------------------!
subroutine print_info(n, str)
implicit none

! -- Declaration des entr�es --
  integer          n     ! niveau requis de l'�criture
  character(len=*) str   ! chaine � �crire

! -- Debut de la procedure --

  if (n <= std_maxlevel) then
    write(uf_stdout,'(a)') trim(str)
    write(uf_log,'(aa)')    str_std, trim(str)
  elseif (n <= log_maxlevel) then
    write(uf_log,'(aa)')    str_log, trim(str)
  endif

endsubroutine print_info
  

!------------------------------------------------------------------------------!
! Procedure : print_stdout                Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  :
!   Ecriture en sortie standart et dans le fichier log
!
!------------------------------------------------------------------------------!
subroutine print_std(str)
implicit none

! -- Declaration des entr�es/sorties --
  character(len=*) str

! -- Debut de la procedure --

  call erreur("interne","proc�dure print_std obsol�te")
  write(uf_stdout,'(a)') trim(str)
  write(uf_log,'(aa)')    "[OUT] ",trim(str)

endsubroutine print_std
  

!------------------------------------------------------------------------------!
! Procedure : print_log                   Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  :
!   Ecriture en sortie standart et dans le fichier log
!
!------------------------------------------------------------------------------!
subroutine print_log(str)
implicit none

! -- Declaration des entr�es/sorties --
  character(len=*) str

! -- Debut de la procedure --

  call erreur("interne","proc�dure print_log obsol�te")
  write(uf_stdout,'(a)') trim(str)
  write(uf_log,'(aa)')    "[OUT] ",trim(str)

endsubroutine print_log
  


endmodule OUTPUT
