!------------------------------------------------------------------------------!
! Procedure :calc_flux_fluxspe_3D         Auteur : E. Radenac
!                                         Date   : Avril 2003
! Fonction                                Modif  : Juin 2003
!   Calcul du flux � l'interface par la m�thode du flux sp�cifique, par le 
!   biais d'une interpolation 3D
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine calc_flux_fluxspe_3D(d1, d2, flux1, flux2, temp1, temp2, &
				conduct1, conduct2, vecinter, flux_inter)

use TYPHMAKE
use OUTPUT
use GEO3D

implicit none

! -- Declaration des entr�es --
real(krp)             :: temp1, temp2   ! temp�ratures �chang�es
real(krp)	      :: conduct1, conduct2  ! conductivit�s �chang�es
real(krp)	      :: d1, d2  ! distance entre les centres des cellules et l'interface
type(v3d)             :: vecinter                ! vecteur unitaire "intercellules"	
type(v3d)             :: flux1, flux2 ! densit�s de flux �chang�es

! -- Declaration des entr�es/sorties --
type(v3d) :: flux_inter

! -- Declaration des variables internes --
real(krp) :: theta = 1                         ! aller chercher la valeur ailleurs
type(v3d) :: flux_compact, flux_consistant     ! densit�s de flux calul�es par les m�thodes
                                               ! compacte et consistante resp.
                         
! -- Debut de la procedure --
call calc_flux_fluxspe_compact(temp1, temp2, conduct1, conduct2, d1, d2, &
					vecinter, flux_compact)
call calc_flux_fluxspe_consistant(d1, d2, flux1, flux2, flux_consistant)			       

flux_inter = flux_consistant + theta*(flux_compact - (flux_consistant.scal.vecinter) * vecinter)

! mieux avec la d�finition vectorielle

endsubroutine calc_flux_fluxspe_3D
