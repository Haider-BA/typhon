!------------------------------------------------------------------------------!
! Procedure : integrationmacro_zone       Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  : Juillet 2003 (cf Historique)
!   Int�gration d'une zone sur un �cart de temps donn�,
!   d'une repr�sentation physique uniquement
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine integrationmacro_zone(mdt, lzone)

use TYPHMAKE
use OUTPUT
use VARCOM
use DEFZONE
use DEFFIELD
use GEO3D
use MATER_LOI

implicit none

! -- Declaration des entr�es --
real(krp)     :: mdt              ! pas de temps macro (sens physique)
type(st_zone) :: lzone            ! zone � int�grer

! -- Declaration des sorties --

! -- Declaration des variables internes --
real(krp)   :: local_t            ! temps local (0 � mdt)
real(krp)   :: dt                 ! pas de temps de la zone
integer     :: if                 ! index de champ
real(krp)   :: fourier

! -- Debut de la procedure --
local_t = 0._krp

!print*, "DEBUG INTEGRATIONMACRO_ZONE"

do while (local_t < mdt)
  
  ! On peut ici coder diff�rentes m�thodes d'int�gration (RK, temps dual...)

  write(str_w,'(a,i5,a,g10.4)') "  zone",lzone%id," � t local =",local_t
  call print_info(7,str_w)

  !call calc_zonetimestep(local_t, lzone, dt)
  dt = mdt
  call calc_fourier(fourier, dt, lzone%ust_mesh, &
                  lzone%defsolver%defkdif%materiau, &
                  lzone%field(1)%etatprim%tabscal(1) )
  write(str_w,'(a,i,a,g10.4)') "* FOURIER zone ", lzone%id, " : ", fourier
  call print_info(6, str_w)
   
  call integration_zone(dt, lzone)

  local_t = local_t + dt

  do if = 1, lzone%ndom
    call update_champ(lzone%field(if))                   ! m�j    des var. conservatives
    call calc_varprim(lzone%defsolver, lzone%field(if))   ! calcul des var. primitives
  enddo

enddo

call capteurs(lzone)

endsubroutine integrationmacro_zone

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juil  2002 (v0.0.1b) : cr�ation de la proc�dure
! juin  2003           : champs multiples
! juil  2003           : calcul du nombre de Fourier de la zone et deplacement
!                        de l'allocation des residus vers integration_macrodt
!------------------------------------------------------------------------------!
