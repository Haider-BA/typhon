!------------------------------------------------------------------------------!
! MODULE : GEO2D                          Auteur : J. Gressier
!                                         Date   : F�vrier 2004
! Fonction                                Modif  : (cf historique)
!   Bibliotheque de procedures et fonctions pour le calcul g�om�trique 2D
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!

module GEO2D

use TYPHMAKE

! -- DECLARATIONS -----------------------------------------------------------

type v2d
  real(krp) :: x, y
endtype

! -- INTERFACES -------------------------------------------------------------

interface v2d_of
  module procedure v2d_fromtab
endinterface

interface abs
  module procedure v2d_norme
endinterface

interface tab
  module procedure tab_v2d
endinterface

interface xcomp
  module procedure v2d_xcomp
endinterface

interface ycomp
  module procedure v2d_ycomp
endinterface

interface operator(+)
  module procedure v2d_addition
endinterface

interface operator(-)
  module procedure v2d_substraction, v2d_opp
endinterface

interface operator(*)
  module procedure v2d_multiplysp, v2d_multiplydp
endinterface

interface operator(/)
  module procedure v2d_divisionsp, v2d_divisiondp
endinterface

interface operator(.scal.)
  module procedure v2d_scalar_product
endinterface

interface operator(.vect.)
  module procedure v2d_vectorial_product
endinterface

interface rot
  module procedure v2d_rot, v2d_rot_a
endinterface

! -- Fonctions et Operateurs ------------------------------------------------


! -- IMPLEMENTATION ---------------------------------------------------------
contains

!------------------------------------------------------------------------------!
! Fonction : composante x
!------------------------------------------------------------------------------!
real(krp) function v2d_xcomp(v)
implicit none
type(v2d), intent(in) :: v

  v2d_xcomp = v%x

endfunction v2d_xcomp

!------------------------------------------------------------------------------!
! Fonction : composante y
!------------------------------------------------------------------------------!
real(krp) function v2d_ycomp(v)
implicit none
type(v2d), intent(in) :: v

  v2d_ycomp = v%y

endfunction v2d_ycomp

!------------------------------------------------------------------------------!
! Fonction : transtypage real(1:2) -> v2d
!------------------------------------------------------------------------------!
type(v2d) function v2d_fromtab(tab)
implicit none
real(krp), dimension(2) :: tab

  v2d_fromtab = v2d(tab(1), tab(2))

endfunction v2d_fromtab

!------------------------------------------------------------------------------!
! Fonction : transtypage v2d -> real(1:2)
!------------------------------------------------------------------------------!
function tab_v2d(v)
implicit none
type(v2d), intent(in)   :: v
real(krp), dimension(2) :: tab_v2d

  tab_v2d(1:2) = (/ v%x, v%y /)

endfunction tab_v2d

!------------------------------------------------------------------------------!
! Fonction : calcul de somme de vecteur
!------------------------------------------------------------------------------!
type(v2d) function v2d_addition(v1, v2)
implicit none
type(v2d), intent(in) :: v1, v2

  v2d_addition%x = v1%x + v2%x 
  v2d_addition%y = v1%y + v2%y 

endfunction v2d_addition

!------------------------------------------------------------------------------!
! Fonction : calcul diff�rence de vecteur
!------------------------------------------------------------------------------!
type(v2d) function v2d_substraction(v1, v2)
implicit none
type(v2d), intent(in) :: v1, v2

  v2d_substraction%x = v1%x - v2%x 
  v2d_substraction%y = v1%y - v2%y 

endfunction v2d_substraction

!------------------------------------------------------------------------------!
! Fonction : calcul de l'oppos� d'un vecteur
!------------------------------------------------------------------------------!
type(v2d) function v2d_opp(v)
implicit none
type(v2d), intent(in) :: v

  v2d_opp%x = - v%x 
  v2d_opp%y = - v%y 

endfunction v2d_opp

!------------------------------------------------------------------------------!
! Fonction : calcul de multiplication de vecteur par r�el
!------------------------------------------------------------------------------!
type(v2d) function v2d_multiplysp(x, v)
implicit none
real(4),   intent(in) :: x
type(v2d), intent(in) :: v

  v2d_multiplysp%x = x * v%x 
  v2d_multiplysp%y = x * v%y 

endfunction v2d_multiplysp

!------------------------------------------------------------------------------!
! Fonction : calcul de multiplication de vecteur par r�el
!------------------------------------------------------------------------------!
type(v2d) function v2d_multiplydp(x, v)
implicit none
real(8),   intent(in) :: x
type(v2d), intent(in) :: v

  v2d_multiplydp%x = x * v%x 
  v2d_multiplydp%y = x * v%y 

endfunction v2d_multiplydp

!------------------------------------------------------------------------------!
! Fonction : calcul de division de vecteur par r�el
!------------------------------------------------------------------------------!
type(v2d) function v2d_divisionsp(v,x)
implicit none
real(4),   intent(in) :: x
type(v2d), intent(in) :: v

  v2d_divisionsp%x = v%x / x 
  v2d_divisionsp%y = v%y / x

endfunction v2d_divisionsp

!------------------------------------------------------------------------------!
! Fonction : calcul de division de vecteur par r�el
!------------------------------------------------------------------------------!
type(v2d) function v2d_divisiondp(v,x)
implicit none
real(8),   intent(in) :: x
type(v2d), intent(in) :: v

  v2d_divisiondp%x = v%x / x 
  v2d_divisiondp%y = v%y / x

endfunction v2d_divisiondp

!------------------------------------------------------------------------------!
! Fonction : norme de vecteur
!------------------------------------------------------------------------------!
real(krp) function v2d_norme(v)
implicit none
type(v2d), intent(in) :: v

  v2d_norme = sqrt(v%x*v%x + v%y*v%y)

endfunction v2d_norme

!------------------------------------------------------------------------------!
! Fonction : calcul de produit scalaire
!------------------------------------------------------------------------------!
real(krp) function v2d_scalar_product(v1, v2)
implicit none
type(v2d), intent(in) :: v1, v2

  v2d_scalar_product = v1%x*v2%x + v1%y*v2%y

endfunction v2d_scalar_product

!------------------------------------------------------------------------------!
! Fonction : produit vectoriel -> scalaire
!------------------------------------------------------------------------------!
real(krp) function v2d_vectorial_product(v1, v2)
implicit none
type(v2d), intent(in) :: v1, v2

  v2d_vectorial_product = v1%x*v2%y - v1%y*v2%x

endfunction v2d_vectorial_product

!------------------------------------------------------------------------------!
! Fonction : rotation d'un vecteur
!------------------------------------------------------------------------------!
type(v2d) function v2d_rot(v)
implicit none
type(v2d), intent(in) :: v

  v2d_rot%x = - v%y 
  v2d_rot%y =   v%x 

endfunction v2d_rot

!------------------------------------------------------------------------------!
! Fonction : rotation d'un vecteur
!------------------------------------------------------------------------------!
type(v2d) function v2d_rot_a(v, a)
implicit none
type(v2d), intent(in) :: v  ! vecteur � tourner
real(krp), intent(in) :: a  ! angle de rotation en radians
real(krp) :: ca, sa

  ca = cos(a)
  sa = sin(a)
  v2d_rot_a%x = v%x*ca - v%y*sa
  v2d_rot_a%y = v%x*sa + v%y*ca

endfunction v2d_rot_a


endmodule GEO2D

!------------------------------------------------------------------------------!
! Historique des modifications
!
! fev  2004 : cr�ation du module (� partir de GEO3D)
! mars 2004 : rotation angulaire 2D (v2d_rot_a)
!------------------------------------------------------------------------------!
