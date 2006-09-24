####### D�finition des catalogues

INCDIR  = $(HDIR)/LIB/Include
LIBDIR  = $(HDIR)/LIB/Lib
#PRJDIR  = $(HDIR)/TYPHON
PRJDIR  = .
PRJINC  = $(PRJDIR)/Include
PRJLIB  = $(PRJDIR)/Lib
PRJEXT  = ../LIBEXT
PRJOBJ  = $(PRJDIR)/Obj

####### D�finition des utilitaires

AR          = ar
RAN         = touch
MAKE        = make

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

$(PRJINC)/%.$(MOD):
	@echo -n "MODULE: "
	$(CF) $(FF) -c ${$*.source} -o $(PRJOBJ)/${$*.objet}
	@mv $*.$(MOD) $(PRJINC)

$(PRJOBJ)/%.o: %.f90
	@echo -n "OBJECT: "
	$(CF) $(FF) -c $< -o $(PRJOBJ)/$*.o

# interm�diaire pour les d�pendances, garantissant la compilation
# %.dep: %.f90 
#	@echo - compilation du fichier $*
#	$(CF) $(FF) -c $< -o $(PRJOBJ)/$*.o
#	@touch $*.dep


