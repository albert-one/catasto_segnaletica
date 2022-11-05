BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "gpkg_spatial_ref_sys" (
	"srs_name"	TEXT NOT NULL,
	"srs_id"	INTEGER NOT NULL,
	"organization"	TEXT NOT NULL,
	"organization_coordsys_id"	INTEGER NOT NULL,
	"definition"	TEXT NOT NULL,
	"description"	TEXT,
	PRIMARY KEY("srs_id")
);
CREATE TABLE IF NOT EXISTS "gpkg_contents" (
	"table_name"	TEXT NOT NULL,
	"data_type"	TEXT NOT NULL,
	"identifier"	TEXT UNIQUE,
	"description"	TEXT DEFAULT '',
	"last_change"	DATETIME NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
	"min_x"	DOUBLE,
	"min_y"	DOUBLE,
	"max_x"	DOUBLE,
	"max_y"	DOUBLE,
	"srs_id"	INTEGER,
	PRIMARY KEY("table_name"),
	CONSTRAINT "fk_gc_r_srs_id" FOREIGN KEY("srs_id") REFERENCES "gpkg_spatial_ref_sys"("srs_id")
);
CREATE TABLE IF NOT EXISTS "gpkg_ogr_contents" (
	"table_name"	TEXT NOT NULL,
	"feature_count"	INTEGER DEFAULT NULL,
	PRIMARY KEY("table_name")
);
CREATE TABLE IF NOT EXISTS "gpkg_geometry_columns" (
	"table_name"	TEXT NOT NULL,
	"column_name"	TEXT NOT NULL,
	"geometry_type_name"	TEXT NOT NULL,
	"srs_id"	INTEGER NOT NULL,
	"z"	TINYINT NOT NULL,
	"m"	TINYINT NOT NULL,
	CONSTRAINT "pk_geom_cols" PRIMARY KEY("table_name","column_name"),
	CONSTRAINT "fk_gc_tn" FOREIGN KEY("table_name") REFERENCES "gpkg_contents"("table_name"),
	CONSTRAINT "fk_gc_srs" FOREIGN KEY("srs_id") REFERENCES "gpkg_spatial_ref_sys"("srs_id"),
	CONSTRAINT "uk_gc_table_name" UNIQUE("table_name")
);
CREATE TABLE IF NOT EXISTS "gpkg_tile_matrix_set" (
	"table_name"	TEXT NOT NULL,
	"srs_id"	INTEGER NOT NULL,
	"min_x"	DOUBLE NOT NULL,
	"min_y"	DOUBLE NOT NULL,
	"max_x"	DOUBLE NOT NULL,
	"max_y"	DOUBLE NOT NULL,
	PRIMARY KEY("table_name"),
	CONSTRAINT "fk_gtms_table_name" FOREIGN KEY("table_name") REFERENCES "gpkg_contents"("table_name"),
	CONSTRAINT "fk_gtms_srs" FOREIGN KEY("srs_id") REFERENCES "gpkg_spatial_ref_sys"("srs_id")
);
CREATE TABLE IF NOT EXISTS "gpkg_tile_matrix" (
	"table_name"	TEXT NOT NULL,
	"zoom_level"	INTEGER NOT NULL,
	"matrix_width"	INTEGER NOT NULL,
	"matrix_height"	INTEGER NOT NULL,
	"tile_width"	INTEGER NOT NULL,
	"tile_height"	INTEGER NOT NULL,
	"pixel_x_size"	DOUBLE NOT NULL,
	"pixel_y_size"	DOUBLE NOT NULL,
	CONSTRAINT "pk_ttm" PRIMARY KEY("table_name","zoom_level"),
	CONSTRAINT "fk_tmm_table_name" FOREIGN KEY("table_name") REFERENCES "gpkg_contents"("table_name")
);
CREATE TABLE IF NOT EXISTS "sostegni" (
	"id_so"	INTEGER NOT NULL,
	"so-geometry"	POINT,
	"so-toponomastica"	TEXT,
	"so-prop-strada"	TEXT(50),
	"so-civ-km"	TEXT(20),
	"so-lato"	TEXT(2),
	"so-materiale"	TEXT(20),
	"so-tipo"	TEXT(20),
	"so-altezza"	REAL,
	"so-dim-sez"	REAL,
	"so-stato"	TEXT(20),
	"so-sagomato"	BOOLEAN,
	"so-foto"	TEXT,
	PRIMARY KEY("id_so" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "gpkg_extensions" (
	"table_name"	TEXT,
	"column_name"	TEXT,
	"extension_name"	TEXT NOT NULL,
	"definition"	TEXT NOT NULL,
	"scope"	TEXT NOT NULL,
	CONSTRAINT "ge_tce" UNIQUE("table_name","column_name","extension_name")
);
CREATE VIRTUAL TABLE "rtree_sostegni_so-geometry" USING rtree(id, minx, maxx, miny, maxy);
CREATE TABLE IF NOT EXISTS "rtree_sostegni_so-geometry_rowid" (
	"rowid"	INTEGER,
	"nodeno"	,
	PRIMARY KEY("rowid")
);
CREATE TABLE IF NOT EXISTS "rtree_sostegni_so-geometry_node" (
	"nodeno"	INTEGER,
	"data"	,
	PRIMARY KEY("nodeno")
);
CREATE TABLE IF NOT EXISTS "rtree_sostegni_so-geometry_parent" (
	"nodeno"	INTEGER,
	"parentnode"	,
	PRIMARY KEY("nodeno")
);
CREATE TABLE IF NOT EXISTS "so-interventi" (
	"id_so_interv"	INTEGER NOT NULL,
	"fk-id-so"	MEDIUMINT,
	"int-so-data"	DATETIME,
	"int-so-interv"	TEXT(100),
	"int-so-operatore"	TEXT(100),
	"int-so-foto"	BLOB,
	PRIMARY KEY("id_so_interv" AUTOINCREMENT)
);
INSERT INTO "gpkg_spatial_ref_sys" ("srs_name","srs_id","organization","organization_coordsys_id","definition","description") VALUES ('Undefined cartesian SRS',-1,'NONE',-1,'undefined','undefined cartesian coordinate reference system'),
 ('Undefined geographic SRS',0,'NONE',0,'undefined','undefined geographic coordinate reference system'),
 ('WGS 84 geodetic',4326,'EPSG',4326,'GEOGCS["WGS 84",DATUM["WGS_1984",SPHEROID["WGS 84",6378137,298.257223563,AUTHORITY["EPSG","7030"]],AUTHORITY["EPSG","6326"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]],AXIS["Latitude",NORTH],AXIS["Longitude",EAST],AUTHORITY["EPSG","4326"]]','longitude/latitude coordinates in decimal degrees on the WGS 84 spheroid');
INSERT INTO "gpkg_contents" ("table_name","data_type","identifier","description","last_change","min_x","min_y","max_x","max_y","srs_id") VALUES ('sostegni','features','sostegni','','2022-10-30T11:42:49.558Z',11.3590850830078,45.7202835083008,11.3590869903564,45.7202911376953,4326),
 ('so-interventi','attributes','so-interventi','interventi ai sostegni','2022-10-31T09:14:14.432Z',NULL,NULL,NULL,NULL,0);
INSERT INTO "gpkg_ogr_contents" ("table_name","feature_count") VALUES ('sostegni',1),
 ('so-interventi',NULL);
INSERT INTO "gpkg_geometry_columns" ("table_name","column_name","geometry_type_name","srs_id","z","m") VALUES ('sostegni','so-geometry','POINT',4326,0,0);
INSERT INTO "gpkg_extensions" ("table_name","column_name","extension_name","definition","scope") VALUES ('sostegni','so-geometry','gpkg_rtree_index','http://www.geopackage.org/spec120/#extension_rtree','write-only');
CREATE TRIGGER 'gpkg_tile_matrix_zoom_level_insert' BEFORE INSERT ON 'gpkg_tile_matrix' FOR EACH ROW BEGIN SELECT RAISE(ABORT, 'insert on table ''gpkg_tile_matrix'' violates constraint: zoom_level cannot be less than 0') WHERE (NEW.zoom_level < 0); END;
CREATE TRIGGER 'gpkg_tile_matrix_zoom_level_update' BEFORE UPDATE of zoom_level ON 'gpkg_tile_matrix' FOR EACH ROW BEGIN SELECT RAISE(ABORT, 'update on table ''gpkg_tile_matrix'' violates constraint: zoom_level cannot be less than 0') WHERE (NEW.zoom_level < 0); END;
CREATE TRIGGER 'gpkg_tile_matrix_matrix_width_insert' BEFORE INSERT ON 'gpkg_tile_matrix' FOR EACH ROW BEGIN SELECT RAISE(ABORT, 'insert on table ''gpkg_tile_matrix'' violates constraint: matrix_width cannot be less than 1') WHERE (NEW.matrix_width < 1); END;
CREATE TRIGGER 'gpkg_tile_matrix_matrix_width_update' BEFORE UPDATE OF matrix_width ON 'gpkg_tile_matrix' FOR EACH ROW BEGIN SELECT RAISE(ABORT, 'update on table ''gpkg_tile_matrix'' violates constraint: matrix_width cannot be less than 1') WHERE (NEW.matrix_width < 1); END;
CREATE TRIGGER 'gpkg_tile_matrix_matrix_height_insert' BEFORE INSERT ON 'gpkg_tile_matrix' FOR EACH ROW BEGIN SELECT RAISE(ABORT, 'insert on table ''gpkg_tile_matrix'' violates constraint: matrix_height cannot be less than 1') WHERE (NEW.matrix_height < 1); END;
CREATE TRIGGER 'gpkg_tile_matrix_matrix_height_update' BEFORE UPDATE OF matrix_height ON 'gpkg_tile_matrix' FOR EACH ROW BEGIN SELECT RAISE(ABORT, 'update on table ''gpkg_tile_matrix'' violates constraint: matrix_height cannot be less than 1') WHERE (NEW.matrix_height < 1); END;
CREATE TRIGGER 'gpkg_tile_matrix_pixel_x_size_insert' BEFORE INSERT ON 'gpkg_tile_matrix' FOR EACH ROW BEGIN SELECT RAISE(ABORT, 'insert on table ''gpkg_tile_matrix'' violates constraint: pixel_x_size must be greater than 0') WHERE NOT (NEW.pixel_x_size > 0); END;
CREATE TRIGGER 'gpkg_tile_matrix_pixel_x_size_update' BEFORE UPDATE OF pixel_x_size ON 'gpkg_tile_matrix' FOR EACH ROW BEGIN SELECT RAISE(ABORT, 'update on table ''gpkg_tile_matrix'' violates constraint: pixel_x_size must be greater than 0') WHERE NOT (NEW.pixel_x_size > 0); END;
CREATE TRIGGER 'gpkg_tile_matrix_pixel_y_size_insert' BEFORE INSERT ON 'gpkg_tile_matrix' FOR EACH ROW BEGIN SELECT RAISE(ABORT, 'insert on table ''gpkg_tile_matrix'' violates constraint: pixel_y_size must be greater than 0') WHERE NOT (NEW.pixel_y_size > 0); END;
CREATE TRIGGER 'gpkg_tile_matrix_pixel_y_size_update' BEFORE UPDATE OF pixel_y_size ON 'gpkg_tile_matrix' FOR EACH ROW BEGIN SELECT RAISE(ABORT, 'update on table ''gpkg_tile_matrix'' violates constraint: pixel_y_size must be greater than 0') WHERE NOT (NEW.pixel_y_size > 0); END;
CREATE TRIGGER "rtree_sostegni_so-geometry_insert" AFTER INSERT ON "sostegni" WHEN (new."so-geometry" NOT NULL AND NOT ST_IsEmpty(NEW."so-geometry")) BEGIN INSERT OR REPLACE INTO "rtree_sostegni_so-geometry" VALUES (NEW."id_so",ST_MinX(NEW."so-geometry"), ST_MaxX(NEW."so-geometry"),ST_MinY(NEW."so-geometry"), ST_MaxY(NEW."so-geometry")); END;
CREATE TRIGGER "rtree_sostegni_so-geometry_update1" AFTER UPDATE OF "so-geometry" ON "sostegni" WHEN OLD."id_so" = NEW."id_so" AND (NEW."so-geometry" NOTNULL AND NOT ST_IsEmpty(NEW."so-geometry")) BEGIN INSERT OR REPLACE INTO "rtree_sostegni_so-geometry" VALUES (NEW."id_so",ST_MinX(NEW."so-geometry"), ST_MaxX(NEW."so-geometry"),ST_MinY(NEW."so-geometry"), ST_MaxY(NEW."so-geometry")); END;
CREATE TRIGGER "rtree_sostegni_so-geometry_update2" AFTER UPDATE OF "so-geometry" ON "sostegni" WHEN OLD."id_so" = NEW."id_so" AND (NEW."so-geometry" ISNULL OR ST_IsEmpty(NEW."so-geometry")) BEGIN DELETE FROM "rtree_sostegni_so-geometry" WHERE id = OLD."id_so"; END;
CREATE TRIGGER "rtree_sostegni_so-geometry_update3" AFTER UPDATE ON "sostegni" WHEN OLD."id_so" != NEW."id_so" AND (NEW."so-geometry" NOTNULL AND NOT ST_IsEmpty(NEW."so-geometry")) BEGIN DELETE FROM "rtree_sostegni_so-geometry" WHERE id = OLD."id_so"; INSERT OR REPLACE INTO "rtree_sostegni_so-geometry" VALUES (NEW."id_so",ST_MinX(NEW."so-geometry"), ST_MaxX(NEW."so-geometry"),ST_MinY(NEW."so-geometry"), ST_MaxY(NEW."so-geometry")); END;
CREATE TRIGGER "rtree_sostegni_so-geometry_update4" AFTER UPDATE ON "sostegni" WHEN OLD."id_so" != NEW."id_so" AND (NEW."so-geometry" ISNULL OR ST_IsEmpty(NEW."so-geometry")) BEGIN DELETE FROM "rtree_sostegni_so-geometry" WHERE id IN (OLD."id_so", NEW."id_so"); END;
CREATE TRIGGER "rtree_sostegni_so-geometry_delete" AFTER DELETE ON "sostegni" WHEN old."so-geometry" NOT NULL BEGIN DELETE FROM "rtree_sostegni_so-geometry" WHERE id = OLD."id_so"; END;
CREATE TRIGGER "trigger_insert_feature_count_sostegni" AFTER INSERT ON "sostegni" BEGIN UPDATE gpkg_ogr_contents SET feature_count = feature_count + 1 WHERE lower(table_name) = lower('sostegni'); END;
CREATE TRIGGER "trigger_delete_feature_count_sostegni" AFTER DELETE ON "sostegni" BEGIN UPDATE gpkg_ogr_contents SET feature_count = feature_count - 1 WHERE lower(table_name) = lower('sostegni'); END;
CREATE TRIGGER "trigger_insert_feature_count_so-interventi" AFTER INSERT ON "so-interventi" BEGIN UPDATE gpkg_ogr_contents SET feature_count = feature_count + 1 WHERE lower(table_name) = lower('so-interventi'); END;
CREATE TRIGGER "trigger_delete_feature_count_so-interventi" AFTER DELETE ON "so-interventi" BEGIN UPDATE gpkg_ogr_contents SET feature_count = feature_count - 1 WHERE lower(table_name) = lower('so-interventi'); END;
COMMIT;
