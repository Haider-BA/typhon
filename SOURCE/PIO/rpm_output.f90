!------------------------------------------------------------------------------!
! Procedure : rpmerr                      Auteur : J. Gressier
!                                         Date   : Fevrier 2002
! Fonction                                Modif  :
!   Gestion des erreurs de la librairie RPM
!
!------------------------------------------------------------------------------!
subroutine rpmerr(message)
  implicit none 
! -- Declaration des Parametres --
  character(len=*) :: message
! -- Debut de la procedure --
  print*,'** librairie RPM - erreur : ' // message // ' **'
  stop
endsubroutine rpmerr
!------------------------------------------------------------------------------!


  

!------------------------------------------------------------------------------!
! Proc�dure : printrpmblock               Auteur : J. Gressier
!                                         Date   : Fevrier 2002
! Fonction                                Modif  :
!   Ecrit sur le num�ro d'unit� sp�cifi� (iu) le contenu du bloc sp�cifi� 
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine printrpmblock(iu, block, debug)
  use RPM
  implicit none 

! -- Declaration des entr�es --
  integer        :: iu      ! numero d'unite pour l'�criture
  type(rpmblock) :: block   ! bloc � �crire
  logical        :: debug

! -- Declaration des variables internes --
  integer i

! -- Debut de la procedure --

  write(iu,*) 'BLOCK: ',block%name
  do i = 1, block%nblig
    if (debug) then
      write(iu,*) i,':  ',trim(block%txt(i))
    else
      write(iu,*) '  ',trim(block%txt(i))
    endif
  enddo

  if (debug) then
    write(iu,*) 'ENDBLOCK ! fin r�elle de bloc'
  else
    write(iu,*) 'ENDBLOCK'
  endif
  
endsubroutine printrpmblock
!------------------------------------------------------------------------------!



!------------------------------------------------------------------------------!
! Proc�dure : printrpm_unread             Auteur : J. Gressier
!                                         Date   : Fevrier 2002
! Fonction                                Modif  :
!   Ecrit sur le num�ro d'unit� sp�cifi� (iu) les donn�es non lues
!
! Defauts/Limitations/Divers :
!
!------------------------------------------------------------------------------!
subroutine printrpm_unread(iu, block)
  use RPM
  implicit none 

! -- Declaration des entr�es --
  integer iu                ! numero d'unite pour l'�criture
  type(rpmblock) :: block   ! bloc � tester

! -- Declaration des variables internes --
  integer i

! -- Debut de la procedure --

  if (.not.block%flagblock) then
    write(iu,*) " Attention : bloc RPM ",trim(block%name)," non trait�"
    call printrpmblock(iu, block)
  else
    do i = 1, block%nblig                   ! Ecriture des lignes
      if (.not.block%flagtxt(i)) &
        write(iu,*) "Attention : ligne du bloc RPM ",trim(block%name),&
                    "non trait� : ",trim(block%txt(i))
    enddo
  endif
  
endsubroutine printrpm_unread
!------------------------------------------------------------------------------!


