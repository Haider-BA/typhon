
!------------------------------------------------------------------------------!
! Procedure :  calc_tempinter_kdif        Auteur : E. Radenac
!                                         Date   : Avril 2003
! Fonction                                Modif  : Juin 2003
!   Calcul de la temp�rature de l'interface entre deux cellules appartenant � 
!   deux zones diff�rentes
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

subroutine calc_tempinter_kdif(temp1, temp2, conduct1, conduct2, d1, d2, &
					temp_inter)

use TYPHMAKE
use OUTPUT

implicit none

! -- Declaration des entr�es --
integer               :: if
real(krp)             :: temp1, temp2   ! temp�ratures �chang�es
real(krp)             :: conduct1, conduct2  ! conductivit�s �chang�es
real(krp)             :: d1, d2  ! distance entre les centres des cellules et l'interface      		   
		      		 
! -- Declaration des entr�es/sorties --
real(krp) :: temp_inter

! -- Declaration des variables internes --
real(krp) :: a, b


! -- Debut de la procedure --

a = conduct1/d1
b = conduct2/d2

temp_inter = (a*temp1+b*temp2)/(a+b)
!print*, "temp�ratures CALC_TEMPINTER_KDIF :", temp1, " et ", temp2
!print*, "temp�rature � l'interface :", temp_inter

endsubroutine calc_tempinter_kdif
