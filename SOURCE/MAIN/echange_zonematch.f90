!------------------------------------------------------------------------------!
! Procedure : echange_zonematch           Auteur : E. Radenac
!                                         Date   : Mai 2003
! Fonction                                Modif  : Juin 2003
!   Echange des donnees entre deux zones
!
! Defauts/Limitations/Divers : pour l'instant, une methode de calcul commune 
!				aux deux zones
!------------------------------------------------------------------------------!

subroutine echange_zonematch(zone1, zone2, typcalc, nfacelim, nbc1, nbc2, ncoupl1, ncoupl2)

use OUTPUT
use DEFZONE
use DEFFIELD
use GEO3D
use TYPHMAKE

implicit none

! -- Declaration des entr�es --
type(st_zone)              :: zone1, zone2
integer                    :: typcalc             ! type d'interpolation
integer                    :: nfacelim            ! nombre de faces limites
integer                    :: nbc1, nbc2          ! indice des conditions aux limites 
                                                  ! concern�es dans les zones 1 et 2                                                  
integer                    :: ncoupl1, ncoupl2    ! num�ro (identit�) du raccord
                                                  ! dans les zones 1 et 2                                                  


! -- Declaration des sorties --

! -- Declaration des variables internes --
integer                        :: i, if, ic, if2
type(v3d), dimension(nfacelim) :: normale ! normales � l'interface
type(v3d), dimension(nfacelim) :: vecinter ! vecteurs inter-cellule
real(krp), dimension(nfacelim) :: d1, d2  ! distance centre de cellule - centre de face
  				                 ! (gauche, droite)  
integer                        :: typmethod
type(v3d)                      :: cg1, cg2, cgface ! centres des cellules des zones 1 et 2, et des faces
integer                        :: typsolver1, typsolver2

! -- Debut de la procedure --

typsolver1 = zone1%defsolver%typ_solver
typsolver2 = zone2%defsolver%typ_solver

! Donn�es g�om�triques :

do i=1, nfacelim    
  
  ! indices des faces concern�es
  if = zone1%ust_mesh%boco(nbc1)%iface(i)
  if2 = zone2%ust_mesh%boco(nbc2)%iface(i)
  
  normale(i) = zone1%ust_mesh%mesh%iface(if,1,1)%normale
 
  cgface = zone1%ust_mesh%mesh%iface(if,1,1)%centre
  ic = zone1%ust_mesh%facecell%fils(if,1)
  cg1 = zone1%ust_mesh%mesh%centre(ic,1,1)
  ic = zone2%ust_mesh%facecell%fils(if2,1)
  cg2 = zone2%ust_mesh%mesh%centre(ic,1,1)

  ! calcul du vecteur unitaire "inter-cellules"
  vecinter(i) = (cg2 - cg1) / abs((cg2 - cg1))
  
  ! calcul des distances d1 et d2 entre les cellules (des zones 1 et 2) et l'interface.
  d1(i) = (cgface-cg1).scal.vecinter(i)
  d2(i) = (cg2-cgface).scal.vecinter(i)

enddo 

! Type de m�thode de calcul:
typmethod = zone1%defsolver%boco(zone1%ust_mesh%boco(nbc1)%idefboco)%typ_calc
! = zone2%defsolver%boco(zone2%ust_mesh%boco(nbc2)%idefboco)%typ_calc

! Valeurs des donn�es instationnaires � �changer
call donnees_echange(zone1%coupling(ncoupl1)%zcoupling%solvercoupling, &
                     zone1%coupling(ncoupl1)%zcoupling%echdata, &
                     zone1, nbc1)
call donnees_echange(zone2%coupling(ncoupl2)%zcoupling%solvercoupling, &
                     zone2%coupling(ncoupl2)%zcoupling%echdata, &
                     zone2, nbc2)


! Calcul des conditions de raccord
!if (senseur(i)%sens) then
call echange(zone1%coupling(ncoupl1)%zcoupling%echdata, &
             zone2%coupling(ncoupl2)%zcoupling%echdata, &
             normale, vecinter, d1, d2, nfacelim, typcalc, typmethod,&
             zone1%coupling(ncoupl1)%zcoupling%cond_coupling, &
             zone2%coupling(ncoupl2)%zcoupling%cond_coupling, &
             zone1%coupling(ncoupl1)%zcoupling%solvercoupling)

!endif

endsubroutine echange_zonematch