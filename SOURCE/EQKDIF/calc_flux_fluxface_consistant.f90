!------------------------------------------------------------------------------!
! Procedure :calc_flux_fluxface_consistantAuteur : E. Radenac
!                                         Date   : Mai 2003
! Fonction                                Modif  : Juin 2003
!   Calcul du flux � l'interface par la m�thode du flux de face, par le 
!   biais d'une interpolation consistante
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine calc_flux_fluxface_consistant(gradtemp1, gradtemp2, conduct1, conduct2, d1, d2, &
					flux_inter)

use TYPHMAKE
use OUTPUT
use GEO3D

implicit none

! -- Declaration des entr�es --
real(krp)  :: d1, d2         ! distances des centres de cellules � l'interface
real(krp)  :: conduct1, conduct2 !  conductivit�s des mat�riaux                                         
type(v3d)  :: gradtemp1, gradtemp2 ! gradients de temp�rature �chang�s

! -- Declaration des entr�es/sorties --
type(v3d) :: flux_inter

! -- Declaration des variables internes --

real(krp) :: a, b
real(krp) :: conduct
type(v3d) :: gradtemp

! -- Debut de la procedure --


!attribution des valeurs des param�tres de pond�ration a et b
!la pond�ration est effectu�e par les distances

a = conduct1/d1
b = conduct2/d2

! "conductivit�" � l'interface :

conduct = (d2*conduct1 + d1*conduct2)/(d1 + d2)

! "gradient de temp�rature" � l'interface :

gradtemp = (a*gradtemp1 + b*gradtemp2) / (a+b)

flux_inter = -conduct * gradtemp

endsubroutine calc_flux_fluxface_consistant
