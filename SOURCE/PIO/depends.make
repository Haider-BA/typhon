# Ce fichier est g�n�r� automatiquement
# et est susceptible d'�tre �cras�

$(PRJINC)/OUTPUT.$(MOD): \
                         $(PRJINC)/TYPHMAKE.$(MOD)    \

$(PRJOBJ)/OUTPUT.o: \
                         $(PRJINC)/TYPHMAKE.$(MOD)    \

$(PRJINC)/RPM.$(MOD): \
                         $(PRJINC)/STRING.$(MOD)    \

$(PRJOBJ)/RPM.o: \
                         $(PRJINC)/STRING.$(MOD)    \

$(PRJINC)/STRING.$(MOD): \

$(PRJOBJ)/STRING.o: \

$(PRJOBJ)/erreur.o: \
                         $(PRJINC)/OUTPUT.$(MOD)    \

$(PRJOBJ)/rpm_output.o: \
                         $(PRJINC)/RPM.$(MOD)    \
                         $(PRJINC)/RPM.$(MOD)    \

