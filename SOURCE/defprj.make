####### D�finition des catalogues

INCDIR  = $(HDIR)/LIB/Include
LIBDIR  = $(HDIR)/LIB/Lib
#PRJDIR  = $(HDIR)/TYPHON
PRJDIR  = .
PRJINC  = $(PRJDIR)/Include
PRJLIB  = $(PRJDIR)/Lib
PRJEXT  = $(PRJDIR)/LIBEXT
PRJOBJ  = $(PRJDIR)/Obj

####### D�finition des utilitaires

AR          = ar
RAN         = ranlib
MAKE        = make
MAKEDEPENDS = Util/make_depends

####### D�finitions des r�gles de compilation

.SUFFIXES: .f .f90 .$(MOD) .o


.f.o:
	@echo Il est anormal de passer par cette directive de compilation !!!
	$(CF) $(FF) -c $<

.f90.o:
	@echo Il est anormal de passer par cette directive de compilation !!!
	$(CF) $(FF) -c $< -o $(PRJOBJ)/$@

.f90:
	@echo TEST
	$(CF) $(FF) -c $< -o $(PRJOBJ)/$@

.f90.$(MOD):
	@echo Il est anormal de passer par cette directive de compilation !!!
	$(CF) $(FF) -c $<

$(PRJINC)/%.$(MOD): %.f90  
	@echo - MODULE : compilation du fichier $*
	$(CF) $(FF) -c $< -o $(PRJOBJ)/$*.o
	@echo - transfert du module $*
	@mv $*.$(MOD) $(PRJINC)

$(PRJOBJ)/%.o: %.f90
	@echo - OBJET : compilation du fichier $*
	$(CF) $(FF) -c $< -o $(PRJOBJ)/$*.o

# interm�diaire pour les d�pendances, garantissant la compilation
# %.dep: %.f90 
#	@echo - compilation du fichier $*
#	$(CF) $(FF) -c $< -o $(PRJOBJ)/$*.o
#	@touch $*.dep




