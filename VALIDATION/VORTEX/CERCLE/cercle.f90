program cercle

implicit none

integer :: npts     ! nombre de points de discr�tisation du profil

integer :: i
real(8) :: pi, dth, theta

real(8), dimension(:), allocatable :: x, y, u, v, p

! -- d�but du programme --

print*,"------------------------------------------------"
print*,"G�n�ration de profil CIRCULAIRE"
print*,"------------------------------------------------"

! -- lecture des param�tres --

write(*,'("      nombre de points : ")', advance="no") ; read(*,*) npts

! -- pr�paration du calcul  --

print*
print*," * g�n�ration de la g�om�trie et calcul a�rodynamique"

pi  = acos(-1._8)

allocate(x(0:npts))
allocate(y(0:npts))
allocate(u(0:npts))
allocate(v(0:npts))
allocate(p(0:npts))

! -- calcul  --

dth = 2._8*pi/real(npts,8)

do i = 0, npts

  theta = i*dth
  x(i)  = cos(theta)
  y(i)  = sin(theta)

  ! vitesse
  u(i) = 0.
  v(i) = 0.
  p(i) = 1._8 - (u(i)**2 + v(i)**2)

enddo

! -- �criture du fichier g�om�trie  --

print*
print*," * �criture du fichier g�om�trie cercle-geo.dat"

open(10, file="cercle-geo.dat", form="formatted")

write(10,*) "# profil Circulaire ",npts," panneaux"

do i = 0, npts
  write(10,'(2e16.8)') x(i), y(i)
enddo

close(10)

! -- �criture du fichier r�sultat  --

print*
print*," * �criture du fichier r�sultat cercle-res.dat"

open(10, file="cercle-res.dat", form="formatted")

write(10,*) "# profil Circulaire ",npts," panneaux"

do i = 0, npts
  write(10,'(5e16.8)') x(i), y(i), u(i), v(i), p(i)
enddo

close(10)


print*
print*,"------------------------------------------------"

deallocate(x, y, u, v, p)


endprogram
