!------------------------------------------------------------------------------!
! MODULE : MATER_LOI                          Auteur : J. Gressier
!                                             Date   : Aout 2002
! Fonction                                    Modif  :
!   Structures pour la d�finition de loi
!     - constante
!     - polynomiale
!     - fichier de points
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
module MATER_LOI

use TYPHMAKE ! D�finition de la pr�cision courante

!------------------------------------------------------------------------------!
!    DECLARATIONS
!------------------------------------------------------------------------------!

character, parameter :: LOI_CST  = 'K'
character, parameter :: LOI_POLY = 'P'
character, parameter :: LOI_PTS  = 'F'


!------------------------------------------------------------------------------!
! ST_LOI_POLY : structure de d�finition  d'une loi polynomiale
!------------------------------------------------------------------------------!
type st_loi_poly
  integer                          :: ordre  ! ordre du polynome
  real(krp), dimension(:), pointer :: coef   ! val. des coef (0:ordre)
endtype st_loi_poly


!------------------------------------------------------------------------------!
! ST__LOI_PTS : structure de d�finition  d'une loi ptsnomiale
!------------------------------------------------------------------------------!
type st_loi_pts
  integer                            :: nb   ! nb de points de def.
  real(krp), dimension(:,:), pointer :: val  ! val. des couples (1:nb,1:2)
endtype st_loi_pts

!------------------------------------------------------------------------------!
! ST__LOI : structure de d�finition g�n�rale d'une loi
!------------------------------------------------------------------------------!
type st_loi
  character         :: type
  real(krp)         :: valeur
  type(st_loi_poly) :: poly     
  type(st_loi_pts)  :: pts
endtype st_loi



! -- INTERFACES -------------------------------------------------------------


! -- Proc�dures, Fonctions et Operateurs ------------------------------------

!------------------------------------------------------------------------------!
!    IMPLEMENTATION 
!------------------------------------------------------------------------------!
contains

!------------------------------------------------------------------------------!
! Fonction : Calcul de la valeur de la loi au point t de la variable
!------------------------------------------------------------------------------!
real(krp) function valeur_loi(loi, t)

implicit none

! -- Entr�es --
type(st_loi) :: loi
real(krp)           :: t

! -- variables internes --

! D�but de proc�dure

select case(loi%type)
  case(LOI_CST)
    valeur_loi = loi%valeur
  case(LOI_POLY)
    print*, "module MATER_LOI : type de loi non impl�ment�"
    stop
  case(LOI_PTS)
    print*, "module MATER_LOI : type de loi non impl�ment�"
    stop
  case default
    print*, "module MATER_LOI : type de loi inconnu"
    stop
endselect

endfunction valeur_loi



!------------------------------------------------------------------------------!
endmodule MATER_LOI

