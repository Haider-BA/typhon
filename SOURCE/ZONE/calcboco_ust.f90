!------------------------------------------------------------------------------!
! Procedure : calcboco_ust                Auteur : J. Gressier
!                                         Date   : Avril 2003
! Fonction                                Modif  : Juin 2003 (cf Historique)
!   Calcul des conditions aux limites pour maillage non structur�
!   Aiguillage des appel selon le type (g�n�ral ou par solveur)
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine calcboco_ust(defsolver, ustdom, champ, ncoupling, zone)

use TYPHMAKE
use OUTPUT
use VARCOM
use MENU_SOLVER
use USTMESH
use DEFFIELD
!use MENU_ZONECOUPLING
use DEFZONE

implicit none

! -- Declaration des entr�es --
type(mnu_solver)       :: defsolver        ! type d'�quation � r�soudre
type(st_ustmesh)       :: ustdom           ! maillage non structur�
type(st_zone)          :: zone
!type(mnu_zonecoupling), dimension(ncoupling) :: zcoupling   ! couplages de la zone avec ses voisines
integer                :: ncoupling        ! nombre de couplages de la zone

! -- Declaration des sorties --
type(st_field)         :: champ            ! champ des �tats

! -- Declaration des variables internes --
integer :: ib, ir                    ! index de conditions aux limites et de couplage
integer :: idef                      ! index de definitions des conditions aux limites
integer :: nrac                      ! num�ro de raccord

! -- Debut de la procedure --

do ib = 1, ustdom%nboco

  idef = ustdom%boco(ib)%idefboco
  !print*,"!! DEBUG boco(",ib,") d�fini dans defboco(",idef,")"

  ! Traitement des conditions aux limites communes aux solveurs

  select case(defsolver%boco(idef)%typ_boco)

  case(bc_geo_sym)
    call erreur("D�veloppement","'bc_geo_sym' : Cas non impl�ment�")
    
  case(bc_geo_period)
    call erreur("D�veloppement","'bc_geo_period' : Cas non impl�ment�")
    
  case(bc_geo_extrapol)
    call calcboco_ust_extrapol(defsolver%boco(idef), ustdom%boco(ib), ustdom, champ)

  case(bc_connection)
    call erreur("D�veloppement","'bc_connection' : Cas non impl�ment�")
   ! do ir = 1, ncoupling
   !   if (samestring(zcoupling(i)%family, ustdom%boco(ib)%family)) then
   !     nrac = ir
   !   endif
   ! enddo
   !   
   ! call calcboco_ust_connect(defsolver%boco(idef), ustdom%boco(ib), ustdom, champ, &
   ! 				zcoupling(nrac)%zcoupling%cond_coupling)
  
  case(bc_coupling)
    do ir = 1, ncoupling
      if (samestring(zone%coupling(ir)%family, ustdom%boco(ib)%family)) then
        nrac = ir
      endif
    enddo

    call calcboco_ust_coupling(defsolver%boco(idef), ustdom%boco(ib), ustdom, champ, &
    				zone%coupling(nrac)%zcoupling%cond_coupling, &
                                zone%coupling(nrac)%zcoupling%solvercoupling)
   
  case default    
    select case(defsolver%typ_solver)
    case(solKDIF)
        call calcboco_kdif_ust(defsolver%boco(idef), ustdom%boco(ib), ustdom, champ)
     case default
       call erreur("incoh�rence interne (def_boco)","solveur inconnu")
    endselect

  endselect

enddo


endsubroutine calcboco_ust

!------------------------------------------------------------------------------!
! Historique des modifications
!
! avril 2003 (v0.0.1b): cr�ation de la proc�dure
!------------------------------------------------------------------------------!
