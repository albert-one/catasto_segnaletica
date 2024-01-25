BEGIN TRANSACTION;
DROP TABLE IF EXISTS "chilometriche";
CREATE TABLE IF NOT EXISTS "chilometriche" (
	"fid"	INTEGER NOT NULL,
	"geom"	POINT,
	"sp"	TEXT,
	"toponomastica"	TEXT(100),
	"km"	TEXT(7),
	"foto"	TEXT(500),
	PRIMARY KEY("fid" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "gpkg_ogr_contents";
CREATE TABLE IF NOT EXISTS "gpkg_ogr_contents" (
	"table_name"	TEXT NOT NULL,
	"feature_count"	INTEGER DEFAULT NULL,
	PRIMARY KEY("table_name")
);
DROP TABLE IF EXISTS "supporti";
CREATE TABLE IF NOT EXISTS "supporti" (
	"fid"	INTEGER NOT NULL,
	"geom"	POINT,
	"TOPON"	TEXT(35),
	"FOTO"	TEXT(250),
	"NOTE"	TEXT(100),
	"DATA_INST"	DATE,
	"TIPO-SUPP"	TEXT(50),
	"DIM-SUPP"	REAL,
	"STATO-SUPP"	TEXT(15),
	"LATO-STRADA"	TEXT(2),
	"KM-CIV"	TEXT(10),
	"INTERV-SUPP"	TEXT(50),
	"programmato"	BOOLEAN,
	PRIMARY KEY("fid" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "segnali";
CREATE TABLE IF NOT EXISTS "segnali" (
	"fid"	INTEGER NOT NULL,
	"TIPO"	TEXT(20),
	"DIM"	TEXT(7),
	"CLASSE"	TEXT(1),
	"SIMBOLO"	TEXT(120),
	"STATO_VERT"	TEXT(15),
	"PRESCR"	TEXT(150),
	"FOTO"	TEXT(250),
	"INTERVENTO"	TEXT(50),
	"NOTE"	TEXT(100),
	"DATA_INST"	DATE,
	"DATA_VER"	DATE,
	"INTEGRATIVO"	BOOLEAN,
	"TESTO-INTEGR"	TEXT(75),
	"programmato"	BOOLEAN,
	"fk-supp"	MEDIUMINT,
	PRIMARY KEY("fid" AUTOINCREMENT)
);
DROP TRIGGER IF EXISTS "rtree_chilometriche_geom_insert";
CREATE TRIGGER "rtree_chilometriche_geom_insert" AFTER INSERT ON "chilometriche" WHEN (new."geom" NOT NULL AND NOT ST_IsEmpty(NEW."geom")) BEGIN INSERT OR REPLACE INTO "rtree_chilometriche_geom" VALUES (NEW."fid",ST_MinX(NEW."geom"), ST_MaxX(NEW."geom"),ST_MinY(NEW."geom"), ST_MaxY(NEW."geom")); END;
DROP TRIGGER IF EXISTS "rtree_chilometriche_geom_update1";
CREATE TRIGGER "rtree_chilometriche_geom_update1" AFTER UPDATE OF "geom" ON "chilometriche" WHEN OLD."fid" = NEW."fid" AND (NEW."geom" NOTNULL AND NOT ST_IsEmpty(NEW."geom")) BEGIN INSERT OR REPLACE INTO "rtree_chilometriche_geom" VALUES (NEW."fid",ST_MinX(NEW."geom"), ST_MaxX(NEW."geom"),ST_MinY(NEW."geom"), ST_MaxY(NEW."geom")); END;
DROP TRIGGER IF EXISTS "rtree_chilometriche_geom_update2";
CREATE TRIGGER "rtree_chilometriche_geom_update2" AFTER UPDATE OF "geom" ON "chilometriche" WHEN OLD."fid" = NEW."fid" AND (NEW."geom" ISNULL OR ST_IsEmpty(NEW."geom")) BEGIN DELETE FROM "rtree_chilometriche_geom" WHERE id = OLD."fid"; END;
DROP TRIGGER IF EXISTS "rtree_chilometriche_geom_update3";
CREATE TRIGGER "rtree_chilometriche_geom_update3" AFTER UPDATE ON "chilometriche" WHEN OLD."fid" != NEW."fid" AND (NEW."geom" NOTNULL AND NOT ST_IsEmpty(NEW."geom")) BEGIN DELETE FROM "rtree_chilometriche_geom" WHERE id = OLD."fid"; INSERT OR REPLACE INTO "rtree_chilometriche_geom" VALUES (NEW."fid",ST_MinX(NEW."geom"), ST_MaxX(NEW."geom"),ST_MinY(NEW."geom"), ST_MaxY(NEW."geom")); END;
DROP TRIGGER IF EXISTS "rtree_chilometriche_geom_update4";
CREATE TRIGGER "rtree_chilometriche_geom_update4" AFTER UPDATE ON "chilometriche" WHEN OLD."fid" != NEW."fid" AND (NEW."geom" ISNULL OR ST_IsEmpty(NEW."geom")) BEGIN DELETE FROM "rtree_chilometriche_geom" WHERE id IN (OLD."fid", NEW."fid"); END;
DROP TRIGGER IF EXISTS "rtree_chilometriche_geom_delete";
CREATE TRIGGER "rtree_chilometriche_geom_delete" AFTER DELETE ON "chilometriche" WHEN old."geom" NOT NULL BEGIN DELETE FROM "rtree_chilometriche_geom" WHERE id = OLD."fid"; END;
DROP TRIGGER IF EXISTS "trigger_insert_feature_count_chilometriche";
CREATE TRIGGER "trigger_insert_feature_count_chilometriche" AFTER INSERT ON "chilometriche" BEGIN UPDATE gpkg_ogr_contents SET feature_count = feature_count + 1 WHERE lower(table_name) = lower('chilometriche'); END;
DROP TRIGGER IF EXISTS "trigger_delete_feature_count_chilometriche";
CREATE TRIGGER "trigger_delete_feature_count_chilometriche" AFTER DELETE ON "chilometriche" BEGIN UPDATE gpkg_ogr_contents SET feature_count = feature_count - 1 WHERE lower(table_name) = lower('chilometriche'); END;
DROP TRIGGER IF EXISTS "rtree_supporti_geom_insert";
CREATE TRIGGER "rtree_supporti_geom_insert" AFTER INSERT ON "supporti" WHEN (new."geom" NOT NULL AND NOT ST_IsEmpty(NEW."geom")) BEGIN INSERT OR REPLACE INTO "rtree_supporti_geom" VALUES (NEW."fid",ST_MinX(NEW."geom"), ST_MaxX(NEW."geom"),ST_MinY(NEW."geom"), ST_MaxY(NEW."geom")); END;
DROP TRIGGER IF EXISTS "rtree_supporti_geom_update1";
CREATE TRIGGER "rtree_supporti_geom_update1" AFTER UPDATE OF "geom" ON "supporti" WHEN OLD."fid" = NEW."fid" AND (NEW."geom" NOTNULL AND NOT ST_IsEmpty(NEW."geom")) BEGIN INSERT OR REPLACE INTO "rtree_supporti_geom" VALUES (NEW."fid",ST_MinX(NEW."geom"), ST_MaxX(NEW."geom"),ST_MinY(NEW."geom"), ST_MaxY(NEW."geom")); END;
DROP TRIGGER IF EXISTS "rtree_supporti_geom_update2";
CREATE TRIGGER "rtree_supporti_geom_update2" AFTER UPDATE OF "geom" ON "supporti" WHEN OLD."fid" = NEW."fid" AND (NEW."geom" ISNULL OR ST_IsEmpty(NEW."geom")) BEGIN DELETE FROM "rtree_supporti_geom" WHERE id = OLD."fid"; END;
DROP TRIGGER IF EXISTS "rtree_supporti_geom_update3";
CREATE TRIGGER "rtree_supporti_geom_update3" AFTER UPDATE ON "supporti" WHEN OLD."fid" != NEW."fid" AND (NEW."geom" NOTNULL AND NOT ST_IsEmpty(NEW."geom")) BEGIN DELETE FROM "rtree_supporti_geom" WHERE id = OLD."fid"; INSERT OR REPLACE INTO "rtree_supporti_geom" VALUES (NEW."fid",ST_MinX(NEW."geom"), ST_MaxX(NEW."geom"),ST_MinY(NEW."geom"), ST_MaxY(NEW."geom")); END;
DROP TRIGGER IF EXISTS "rtree_supporti_geom_update4";
CREATE TRIGGER "rtree_supporti_geom_update4" AFTER UPDATE ON "supporti" WHEN OLD."fid" != NEW."fid" AND (NEW."geom" ISNULL OR ST_IsEmpty(NEW."geom")) BEGIN DELETE FROM "rtree_supporti_geom" WHERE id IN (OLD."fid", NEW."fid"); END;
DROP TRIGGER IF EXISTS "rtree_supporti_geom_delete";
CREATE TRIGGER "rtree_supporti_geom_delete" AFTER DELETE ON "supporti" WHEN old."geom" NOT NULL BEGIN DELETE FROM "rtree_supporti_geom" WHERE id = OLD."fid"; END;
DROP TRIGGER IF EXISTS "trigger_insert_feature_count_supporti";
CREATE TRIGGER "trigger_insert_feature_count_supporti" AFTER INSERT ON "supporti" BEGIN UPDATE gpkg_ogr_contents SET feature_count = feature_count + 1 WHERE lower(table_name) = lower('supporti'); END;
DROP TRIGGER IF EXISTS "trigger_delete_feature_count_supporti";
CREATE TRIGGER "trigger_delete_feature_count_supporti" AFTER DELETE ON "supporti" BEGIN UPDATE gpkg_ogr_contents SET feature_count = feature_count - 1 WHERE lower(table_name) = lower('supporti'); END;
DROP TRIGGER IF EXISTS "trigger_insert_feature_count_segnali";
CREATE TRIGGER "trigger_insert_feature_count_segnali" AFTER INSERT ON "segnali" BEGIN UPDATE gpkg_ogr_contents SET feature_count = feature_count + 1 WHERE lower(table_name) = lower('segnali'); END;
DROP TRIGGER IF EXISTS "trigger_delete_feature_count_segnali";
CREATE TRIGGER "trigger_delete_feature_count_segnali" AFTER DELETE ON "segnali" BEGIN UPDATE gpkg_ogr_contents SET feature_count = feature_count - 1 WHERE lower(table_name) = lower('segnali'); END;
COMMIT;
