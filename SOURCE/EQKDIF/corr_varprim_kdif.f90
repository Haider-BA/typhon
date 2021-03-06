!------------------------------------------------------------------------------!
! Procedure : corr_varprim_kdif           Auteur : E. Radenac
!                                         Date   : Juillet 2003
! Fonction                                Modif  :
!   Calcul des variables primitives aux frontieres de couplage,
!   tenant compte des corrections de flux, code thermique.
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine corr_varprim_kdif(field, umesh, def_solver, dif_enflux, nb, &
                             part_cor, typ_cor, fincycle)
 
use TYPHMAKE
use OUTPUT
use VARCOM
use USTMESH
use MENU_SOLVER
use DEFFIELD
use MENU_ZONECOUPLING

implicit none

! -- Declaration des entrees --
type(st_ustmesh)      :: umesh            ! unstructured mesh
type(mnu_solver)      :: def_solver       ! proprietes du solver
type(st_genericfield) :: dif_enflux       ! energie a ajouter, pour correction de flux
integer               :: nb               ! index de la condition aux limites
real(krp)             :: part_cor         ! part de la correction a apporter
integer               :: typ_cor          ! type de correction
logical               :: fincycle

! -- Declaration des entrees/sorties --
type(st_field)   :: field            ! champ des valeurs et residus

! -- Declaration des variables internes --
integer               :: i, if               ! index de face
integer               :: ic1, ic2         ! index de cellules
integer               :: ip               ! index de variables

! -- Debut de la procedure --

do i=1, umesh%boco(nb)%nface

  if = umesh%boco(nb)%iface(i)

  ic1 = umesh%facecell%fils(if,1)
  ic2 = umesh%facecell%fils(if,2)

  ! -- calcul des residus --
  ! Choix selon les types de correction
  select case(typ_cor)

  case(repart_reg)
! DEV : on cumule les restes eventuels en fin de cycle, sinon modifier pour les
! echanges n'ayant pas lieu a chaque fin de cycle

!    if (.not. fincycle) then
      if (abs(dif_enflux%tabscal(3)%scal(i)) .ge. &
          abs(part_cor*dif_enflux%tabscal(2)%scal(i)) ) then
          !print*, "debug correction repartie C", dif_enflux%tabscal(3)%scal(i), &
          !          part_cor*dif_enflux%tabscal(2)%scal(i)
        do ip = 1, field%nscal
          field%residu%tabscal(ip)%scal(ic1) = &
                                       - part_cor*dif_enflux%tabscal(2)%scal(i)
          field%residu%tabscal(ip)%scal(ic2) = &
                                         part_cor*dif_enflux%tabscal(2)%scal(i)
          dif_enflux%tabscal(3)%scal(i) = dif_enflux%tabscal(3)%scal(i) - &
                                        part_cor*dif_enflux%tabscal(2)%scal(i)
        enddo
        !do ip = 1, field%nvect
        !  field%residu%tabvect(ip)%vect(ic1) = &
        !                              - part_cor*dif_enflux%tabvect(2)%vect(i)
        !  field%residu%tabvect(ip)%vect(ic2) = &
        !                                part_cor*dif_enflux%tabvect(2)%vect(i)
        !  dif_enflux%tabvect(3)%vect(i) = dif_enflux%tabvect(3)%vect(i) - &
        !                                part_cor*dif_enflux%tabvect(2)%vect(i)
        !enddo
      else
        !print*, "debug correction repartie NC", dif_enflux%tabscal(3)%scal(i), &
        !          part_cor*dif_enflux%tabscal(2)%scal(i)
        do ip = 1, field%nscal
          field%residu%tabscal(ip)%scal(ic1) = - dif_enflux%tabscal(3)%scal(i)
          field%residu%tabscal(ip)%scal(ic2) = dif_enflux%tabscal(3)%scal(i)
          dif_enflux%tabscal(3)%scal(i) = 0
        enddo
        !do ip = 1, field%nvect
        !  field%residu%tabvect(ip)%vect(ic1) = - dif_enflux%tabvect(3)%vect(i)
        !  field%residu%tabvect(ip)%vect(ic2) = dif_enflux%tabvect(3)%vect(i)
        !  dif_enflux%tabvect(3)%vect(i) = v3d(0._krp, 0._krp, 0._krp)
        !enddo  
      endif   
 
!    else
!      do ip = 1, field%nscal
!        field%residu%tabscal(ip)%scal(ic1) = - dif_enflux%tabscal(3)%scal(i)
!        field%residu%tabscal(ip)%scal(ic2) = dif_enflux%tabscal(3)%scal(i)
!        dif_enflux%tabscal(3)%scal(i) = 0
!      enddo
!      do ip = 1, field%nvect
!        field%residu%tabvect(ip)%vect(ic1) = - dif_enflux%tabvect(3)%vect(i)
!        field%residu%tabvect(ip)%vect(ic2) = dif_enflux%tabvect(3)%vect(i)
!        dif_enflux%tabvect(3)%vect(i) = v3d(0._krp, 0._krp, 0._krp)
!      enddo
!    endif

  case(repart_geo)
! DEV : on cumule les restes eventuels en fin de cycle, sinon modifier pour les
! echanges n'ayant pas lieu a chaque fin de cycle

!    if (.not. fincycle) then
!print*, "debug correction repartie geo", dif_enflux%tabscal(3)%scal(i)
      do ip = 1, field%nscal
        field%residu%tabscal(ip)%scal(ic1) = &
                                       - part_cor*dif_enflux%tabscal(3)%scal(i)
        field%residu%tabscal(ip)%scal(ic2) = &
                                         part_cor*dif_enflux%tabscal(3)%scal(i)
        dif_enflux%tabscal(3)%scal(i) = dif_enflux%tabscal(3)%scal(i) - &
                                        part_cor*dif_enflux%tabscal(3)%scal(i)
      enddo
      do ip = 1, field%nvect
        field%residu%tabvect(ip)%vect(ic1) = &
                                       - part_cor*dif_enflux%tabvect(3)%vect(i)
        field%residu%tabvect(ip)%vect(ic2) = &
                                         part_cor*dif_enflux%tabvect(3)%vect(i)
        dif_enflux%tabvect(3)%vect(i) = dif_enflux%tabvect(3)%vect(i) - &
                                        part_cor*dif_enflux%tabvect(3)%vect(i)
      enddo

!    else
!      do ip = 1, field%nscal
!        field%residu%tabscal(ip)%scal(ic1) = - dif_enflux%tabscal(3)%scal(i)
!        field%residu%tabscal(ip)%scal(ic2) = dif_enflux%tabscal(3)%scal(i)
!        dif_enflux%tabscal(3)%scal(i) = 0
!      enddo
!      do ip = 1, field%nvect
!        field%residu%tabvect(ip)%vect(ic1) = - dif_enflux%tabvect(3)%vect(i)
!        field%residu%tabvect(ip)%vect(ic2) = dif_enflux%tabvect(3)%vect(i)
!        dif_enflux%tabvect(3)%vect(i) = v3d(0._krp, 0._krp, 0._krp)
!      enddo
!    endif

  case(partiel)
    do ip = 1, field%nscal
      field%residu%tabscal(ip)%scal(ic1) = &
                                       - part_cor*dif_enflux%tabscal(2)%scal(i)
      field%residu%tabscal(ip)%scal(ic2) = &
                                         part_cor*dif_enflux%tabscal(2)%scal(i)
      dif_enflux%tabscal(3)%scal(i) = dif_enflux%tabscal(3)%scal(i) - &
                                        part_cor*dif_enflux%tabscal(2)%scal(i)
    enddo
    do ip = 1, field%nvect
      field%residu%tabvect(ip)%vect(ic1) = &
                                       - part_cor*dif_enflux%tabvect(2)%vect(i)
      field%residu%tabvect(ip)%vect(ic2) = &
                                         part_cor*dif_enflux%tabvect(2)%vect(i)
      dif_enflux%tabvect(3)%vect(i) = dif_enflux%tabvect(3)%vect(i) - &
                                        part_cor*dif_enflux%tabvect(2)%vect(i)
    enddo

  case default ! correction AVANT, APRES ou AUTO
!DEBUG
!print*, "CORRECTION"
    do ip = 1, field%nscal
      field%residu%tabscal(ip)%scal(ic1) = - dif_enflux%tabscal(2)%scal(i)
      field%residu%tabscal(ip)%scal(ic2) = - dif_enflux%tabscal(2)%scal(i)
      if (typ_cor.ne.bocoT2) then
        dif_enflux%tabscal(3)%scal(i) = 0
      endif
    enddo
    do ip = 1, field%nvect
      field%residu%tabvect(ip)%vect(ic1) = - dif_enflux%tabvect(2)%vect(i)
      field%residu%tabvect(ip)%vect(ic2) = dif_enflux%tabvect(2)%vect(i)
      if (typ_cor.ne.bocoT2) then
        dif_enflux%tabvect(3)%vect(i) = v3d(0._krp, 0._krp, 0._krp)
      endif
    enddo
  endselect

  ! -- residus
  do ip = 1, field%nscal
    field%residu%tabscal(ip)%scal(ic1) =  field%residu%tabscal(ip)%scal(ic1) &
                                            / umesh%mesh%volume(ic1,1,1)
    field%residu%tabscal(ip)%scal(ic2) =  field%residu%tabscal(ip)%scal(ic2) &
                                            / umesh%mesh%volume(ic1,1,1)
  enddo
  do ip = 1, field%nvect
    field%residu%tabvect(ip)%vect(ic1) =  field%residu%tabvect(ip)%vect(ic1)  &
                                            / umesh%mesh%volume(ic1,1,1)
    field%residu%tabvect(ip)%vect(ic2) =  field%residu%tabvect(ip)%vect(ic2)  &
                                            / umesh%mesh%volume(ic1,1,1)
  enddo

  if (typ_cor == bocoT2) then
    def_solver%boco(umesh%boco(nb)%idefboco)%boco_kdif%temp(i)= &
      def_solver%boco(umesh%boco(nb)%idefboco)%boco_kdif%temp(i)&
      +(field%residu%tabscal(ip)%scal(ic2)/def_solver%defkdif%materiau%Cp)

  else

  ! -- calcul des variables conservatives et primitives --
  do ip = 1, field%nscal
    field%etatcons%tabscal(ip)%scal(ic1) = field%etatcons%tabscal(ip)%scal(ic1) &
                                          + field%residu%tabscal(ip)%scal(ic1)
    field%etatprim%tabscal(ip)%scal(ic1) = field%etatcons%tabscal(ip)%scal(ic1) &
                                          / def_solver%defkdif%materiau%Cp
  enddo

  do ip= 1, field%nvect
    field%etatcons%tabvect(ip)%vect(ic1) = field%etatcons%tabvect(ip)%vect(ic1) &
                                          + field%residu%tabvect(ip)%vect(ic1)
    field%etatprim%tabvect(ip)%vect(ic1) = field%etatcons%tabvect(ip)%vect(ic1) &
                                          / def_solver%defkdif%materiau%Cp
  enddo

  endif

enddo

endsubroutine corr_varprim_kdif

!------------------------------------------------------------------------------!
! Historique des modifications
!
! juillet 2003 : creation de la procedure
!------------------------------------------------------------------------------!
