!------------------------------------------------------------------------------!
! Procedure : echange_zonematch           Auteur : E. Radenac
!                                         Date   : Mai 2003
! Fonction                                Modif  : Juillet 2003
!   Echange des donnees entre deux zones
!
! Defauts/Limitations/Divers : pour l'instant, une methode de calcul commune 
!				aux deux zones
!------------------------------------------------------------------------------!

! ------PROVISOIRE pour affichage des champs avt et apres cor de flux-----------
!subroutine echange_zonematch(zone1, zone2, typcalc, nfacelim, nbc1, nbc2, ncoupl1, ncoupl2, corcoef, icycle, typtemps)
! --------------------------------------------------------------------------
subroutine echange_zonematch(zone1, zone2, typcalc, nfacelim, nbc1, nbc2, ncoupl1, ncoupl2, corcoef, typtemps)

use OUTPUT
use VARCOM
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
real(krp)                  :: corcoef             ! coefficient de correction de flux
character                  :: typtemps

! ------PROVISOIRE pour affichage des champs avt et apres cor de flux-----------
!integer     :: icycle
!---------------------------------------------------------------------------



! -- Declaration des sorties --

! -- Declaration des variables internes --
integer                        :: i, if, ic, if2, ifield
type(v3d), dimension(nfacelim) :: normale ! normales � l'interface
type(v3d), dimension(nfacelim) :: vecinter ! vecteurs inter-cellule
    real(krp), dimension(nfacelim) :: d1, d2  ! distance centre de cellule - centre de face
  				                 ! (gauche, droite)  
integer                        :: typmethod
type(v3d)                      :: cg1, cg2, cgface ! centres des cellules des zones 1 et 2, et des faces
integer                        :: typsolver1, typsolver2
real(krp)                      :: dif_enflux     ! diff�rence des �nergies d'interface dans les deuxzones

! ------PROVISOIRE pour affichage des champs avt et apres cor de flux-----------
integer     :: uf
!---------------------------------------------------------------------------

! -- Debut de la procedure --
! ------PROVISOIRE pour affichage des champs avt et apres cor de flux-----------
!  uf = 556
!if ((icycle.lt.10)) then
!  open(unit = uf, file = "t"//trim(adjustl(strof(icycle,3)))//".dat", form = 'formatted')
!  write(uf, '(a)') 'VARIABLES="X","Y","Z", "T"'
!
!  call output_field(uf, zone1%ust_mesh, zone2%ust_mesh, zone1%field, &
!                    zone2%field,"FIN DU CYCLE PRECEDENT")
!endif
!-----------------------------------------------------------------------------

select case(typtemps)

 case(instationnaire) ! On applique des corrections de flux entre les �changes

 ! Suppl�ment de flux pour les �changes espac�s : calcul de la diff�rence � appliquer

 call calcdifflux(zone1%coupling(ncoupl1)%zcoupling%etatcons%tabscal, &
                  zone2%coupling(ncoupl2)%zcoupling%etatcons%tabscal, &
                  nfacelim, zone1%coupling(ncoupl1)%zcoupling%solvercoupling, &
                  corcoef )

 ! Calcul des variables primitives avec correction de flux
 do ifield = 1, zone1%ndom
   call corr_varprim(zone1%field(ifield), &
                     zone1%ust_mesh, &
                     zone1%defsolver, &
                     zone1%coupling(ncoupl1)%zcoupling%etatcons, nbc1)
 enddo

 do ifield = 1, zone2%ndom
   call corr_varprim(zone2%field(ifield), &
                     zone2%ust_mesh, &
                     zone2%defsolver, &
                     zone2%coupling(ncoupl2)%zcoupling%etatcons, nbc2)
 enddo

endselect

! --------PROVISOIRE pour affichage des champs avt et apres cor de flux---------
!if ((icycle.lt.10)) then
!  call output_field(uf, zone1%ust_mesh, zone2%ust_mesh, zone1%field, &
!                    zone2%field,"APRES CORRECTION")
!endif
!-----------------------------------------------------------------------------


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

!------------------------------------------------------------------------------!
! Historique des modifications
!
! mai 2003 (v0.0.1b): cr�ation de la proc�dure
! juillet 2003      : ajouts pour corrections de  flux
! oct 2003          : ajout coef correction de flux
! oct 2003          : correction de flux seulement pour le cas instationnaire
!------------------------------------------------------------------------------!
