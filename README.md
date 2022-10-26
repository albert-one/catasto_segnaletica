# Catasto segnaletica stradale verticale
Progetto GIS per la formazione del catasto della segnaletica stradale verticale e la sua manutenzione.

Il progetto è stato realizzato con **QGIS** e **Spatialite**.

L'uso di Spatialite è stato preferito per la possibilità di utilizzare la sua GUI per la creazione delle viste.

E' completo dei simboli SVG della segnaletica verticale e di tabelle in formato CSV da utilizzare nelle maschere di inserimento dati.

Il progetto può essere utilizzato in strada su device portatili. Si consiglia l'utilizzo di **QField** e **QFieldCloud** per avere i dati sempre aggiornati.

Questa versione è stata pensata per realtà di piccole dimensioni, gestibili da un solo operatore.

Se si ha la necessità di un utilizzo da parte di più operatori è opportuno traferire il progetto su server PostGIS. Così facendo si ha la possibilità di accessi multipli in contemporanea, cosa non possibile con Spatialite.

Il DB principale raccoglie i dati del segnale nel suo complesso (cartello e sostegno), della sua collocazione lungo le strade, della tipologia, materiale, classe della pellicola, foto (fronte, retro e contesto), ecc.

Un DB secondario, collegato al principale 1:m, tiene nota delle manutenzioni eseguite.

Una vista permette di visualizzare sulla mappa i segnali catalogati come "insufficiente" e che, pertanto, dovrebbero essere sostituiti.

Per poter visualizzare i simboli SVG dei segnali nella mappa è necessario impostare la cartella del progetto di QGIS.
