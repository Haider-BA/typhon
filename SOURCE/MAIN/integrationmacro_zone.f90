!------------------------------------------------------------------------------!
! Procedure : integrationmacro_zone       Auteur : J. Gressier
!                                         Date   : Juillet 2002
! Fonction                                Modif  : Juin 2003 (cf Historique)
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

implicit none

! -- Declaration des entr�es --
real(krp)     :: mdt              ! pas de temps macro (sens physique)
type(st_zone) :: lzone            ! zone � int�grer

! -- Declaration des sorties --

! -- Declaration des variables internes --
real(krp)   :: local_t            ! temps local (0 � mdt)
real(krp)   :: dt                 ! pas de temps de la zone
integer     :: if                 ! index de champ

! -- Debut de la procedure --
local_t = 0._krp

! allocation des champs de r�sidus
!print*, "DEBUG INTEGRATIONMACRO_ZONE"
do if = 1, lzone%ndom
  call alloc_res(lzone%field(if))
enddo

do while (local_t < mdt)
  
  ! On peut ici coder diff�rentes m�thodes d'int�gration (RK, temps dual...)

  write(str_w,'(a,i5,a,g10.4)') "  zone",lzone%id," � t local =",local_t
  call print_info(7,str_w)

  !call calc_zonetimestep(local_t, lzone, dt)
  dt = mdt

  call integration_zone(dt, lzone)

  local_t = local_t + dt

  do if = 1, lzone%ndom
    print*,'!! DEBUG update dom =',if
    call update_champ(lzone%field(if))                   ! m�j    des var. conservatives
    call calc_varprim(lzone%defsolver, lzone%field(if), &
                      lzone%ust_mesh%ncell_int)  ! calcul des var. primitives
  enddo

enddo

call capteurs(lzone)

do if = 1, lzone%ndom
  call dealloc_res(lzone%field(if))
enddo
!print*, "DEBUG : fin dealloc"
endsubroutine integrationmacro_zone

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juil  2002 (v0.0.1b) : cr�ation de la proc�dure
! juin  2003           : champs multiples
!------------------------------------------------------------------------------!
