############################################################
##   Compilation de la librairie MESH

LDIR := MESH

####### Files

MESH_LIB = libt_mesh.a

MESH_MOD = GEO3D.$(MOD)     \
           MESHBASE.$(MOD)  \
           STRMESH.$(MOD)   \
           TENSOR3.$(MOD)   \
           USTMESH.$(MOD) 

MESH_OBJ = $(MESH_MOD:.$(MOD)=.o)  \
           calc_connface.o         \
           calc_ust_cell.o         \
           calc_ust_elemvol.o      \
           calc_ust_midcell.o      \
           calc_ust_checkface.o    \
           calc_ust_face.o         \
           calc_ustmesh.o          \
           extract_points.o        \
           extract_pts_index.o     \
           reorder_ustconnect.o    \
           test_ustmesh.o   


D_MESH_OBJ = $(MESH_OBJ:%=$(PRJOBJ)/%)

D_MESH_SRC := $(MESH_OBJ:%.o=$(LDIR)/%.f90)

####### Build rules

#all: $(PRJLIB)/$(MESH_LIB)

$(PRJLIB)/$(MESH_LIB): $(MESH_LIB)
	@echo \* Copie de la librairie $(MESH_LIB)
	@cp $(MESH_LIB) $(PRJLIB)

$(MESH_LIB): $(D_MESH_OBJ)
	@echo ---------------------------------------------------------------
	@echo \* Cr�ation de la librairie $(MESH_LIB)
	@touch $(MESH_LIB) ; rm $(MESH_LIB)
	@$(AR) ruv $(MESH_LIB) $(D_MESH_OBJ)
	@echo \* Cr�ation de l\'index de la librairie
	@$(RAN)    $(MESH_LIB)
	@echo ---------------------------------------------------------------
	@echo \* LIBRAIRIE $(MESH_LIB) cr��e
	@echo ---------------------------------------------------------------

MESH_clean:
	-rm $(MESH_LIB) $(D_MESH_OBJ) $(MESH_MOD)

####### Dependencies

MESH/depends.make: $(D_MESH_SRC)
	(cd MESH ; ../$(MAKEDEPENDS))

include MESH/depends.make


