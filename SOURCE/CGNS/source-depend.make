############################################################
##   Compilation de la librairie CGNS

LDIR := CGNS

####### Files

CGNS_LIB = libt_cgns.a

CGNS_MOD = CGNS_STRUCT.$(MOD)       \
           CGNSLIB.$(MOD) 


CGNS_OBJ := $(CGNS_MOD:.$(MOD)=.o)   \
            cgns2typhon.o            \
            cgns2typhon_zone.o       \
            cgns2typhon_ustboco.o    \
            cgns2typhon_ustmesh.o    \
            createface_fromcgns.o    \
            readcgns_strboco.o       \
            readcgns_strconnect.o    \
            readcgns_ustboco.o       \
            readcgns_ustconnect.o    \
            readcgnsbase.o           \
            readcgnsfile.o           \
            readcgnsvtex.o           \
            readcgnszone.o

D_CGNS_OBJ := $(CGNS_OBJ:%=$(PRJOBJ)/%)

D_CGNS_SRC := $(CGNS_OBJ:%.o=$(LDIR)/%.f90)


####### Build rules

all: $(PRJLIB)/$(CGNS_LIB)

$(PRJLIB)/$(CGNS_LIB): $(CGNS_LIB)
	@echo \* Copie de la librairie $(CGNS_LIB)
	@cp $(CGNS_LIB) $(PRJLIB)

$(CGNS_LIB): $(D_CGNS_OBJ)
	@echo ---------------------------------------------------------------
	@echo \* Cr�ation de la librairie $(CGNS_LIB)
	@touch $(CGNS_LIB) ; rm $(CGNS_LIB)
	@$(AR) ruv $(CGNS_LIB) $(D_CGNS_OBJ)
	@echo \* Cr�ation de l\'index de la librairie
	@$(RAN)    $(CGNS_LIB)
	@echo ---------------------------------------------------------------
	@echo \* LIBRAIRIE $(CGNS_LIB) cr��e
	@echo ---------------------------------------------------------------

CGNS_clean:
	-rm  $(CGNS_LIB) $(D_CGNS_OBJ) $(CGNS_MOD)

####### Dependencies



CGNS/depends.make: $(D_CGNS_SRC)
	(cd CGNS ; ../$(MAKEDEPENDS))

include CGNS/depends.make