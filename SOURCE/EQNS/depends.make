# Ce fichier est g�n�r� automatiquement
# et est susceptible d'�tre �cras�

$(PRJINC)/EQNS.$(MOD): \
                         $(PRJINC)/TYPHMAKE.$(MOD)    \
                         $(PRJINC)/GEO3D.$(MOD)    \

$(PRJOBJ)/EQNS.o: \
                         $(PRJINC)/TYPHMAKE.$(MOD)    \
                         $(PRJINC)/GEO3D.$(MOD)    \

$(PRJINC)/MENU_NS.$(MOD): \
                         $(PRJINC)/TYPHMAKE.$(MOD)    \
                         $(PRJINC)/EQNS.$(MOD)    \

$(PRJOBJ)/MENU_NS.o: \
                         $(PRJINC)/TYPHMAKE.$(MOD)    \
                         $(PRJINC)/EQNS.$(MOD)    \

