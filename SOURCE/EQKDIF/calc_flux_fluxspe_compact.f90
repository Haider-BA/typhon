!------------------------------------------------------------------------------!
! Procedure :calc_flux_fluxspe_compact    Auteur : E. Radenac
!                                         Date   : Avril 2003
! Fonction                                Modif  : Juin 2003
!   Calcul du flux � l'interface par la m�thode du flux sp�cifique, par le 
!   biais d'une interpolation compacte
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine calc_flux_fluxspe_compact(temp1, temp2, conduct1, conduct2, d1, d2,&
					vecinter, flux_inter)

use TYPHMAKE
use OUTPUT
use GEO3D

implicit none

! -- Declaration des entr�es --
real(krp)             :: temp1, temp2   ! temp�ratures �chang�es
real(krp)	      :: conduct1, conduct2  ! conductivit�s �chang�es
real(krp)	      :: d1, d2  ! distance entre les centres des cellules et l'interface
type(v3d)             :: vecinter                ! vecteur unitaire "intercellules"		      		   
		      		   
! -- Declaration des entr�es/sorties --
type(v3d) :: flux_inter

! -- Declaration des variables internes --
real(krp) :: a, b
real(krp) :: conduct


! -- Debut de la procedure --


!Pond�ration de la conductivit� : param�tres a et b

a = conduct1/d1
b = conduct2/d2

conduct = (a*conduct1 + b*conduct2)/(a+b)

flux_inter = -conduct*(temp2 - temp1)&
		/(d1 + d2) * vecinter

endsubroutine calc_flux_fluxspe_compact
