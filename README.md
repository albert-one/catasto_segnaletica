# Catasto segnaletica stradale verticale
Progetto GIS per la formazione del catasto della segnaletica stradale verticale e la sua manutenzione.

Il progetto è stato realizzato con **QGIS** e database **GeoPackage**.

E' completo dei simboli SVG della segnaletica verticale e di tabelle in formato CSV da utilizzare nelle maschere di inserimento dati.

Il progetto tiene conto che il codice della strada permette di installare due segnali per ogni sostegno (che nella realtà la disposizione non viene rispettata, trovando spesso più di due segnali per sostegno). Il concetto quindi è quello di mappare i sostegni e non i singoli segnali, perchè mappando i singoli segnali ci ritroveremmo con i punti sovrapposti.

Il progetto può essere utilizzato in strada su device portatili (si consiglia l'utilizzo di **QField** e **QFieldCloud** per avere i dati sempre aggiornati).

Questa versione è stata pensata per realtà di piccole dimensioni, gestibili da un solo operatore.

Se si ha la necessità di un utilizzo da parte di più operatori è opportuno traferire il progetto su server PostGIS. Così facendo si ha la possibilità di avere accessi multipli in contemporanea, cosa non possibile con DB SQlite, sul quale si basa il GeoPackage.

"Sostegni" è il layer principale e raccoglie i dati del sostegno; con un collegamento 1:m vengono censiti i segnali installati sul singolo sostegno; in questo modo si registrano i dati del segnale nel suo complesso (cartelli e sostegno), della sua collocazione lungo le strade, della tipologia, materiale, classe della pellicola, foto (fronte, retro e contesto), ecc.

Le tabelle secondarie, senza geometria, collegate 1:m, tengono nota delle manutenzioni eseguite sia per il sostegno che per la segnaletica. Il prefisso "so-" identifica le tabelle collegate al sostegno, mentre le tabelle con prefisso "se-" identifica quelle collegate al segnale.

I simboli SVG vengono visualizzati nella maschera della segnaletica, in modo da avere visione dei segnali installati.
