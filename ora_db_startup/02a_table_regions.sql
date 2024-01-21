alter session set container = XEPDB1;

--------------------------------------------------------
--  DDL for Table REGIONS
--------------------------------------------------------

  CREATE TABLE "HR"."REGIONS" 
   (  "REGION_ID" NUMBER, 
  "REGION_NAME" VARCHAR2(25)
   ) ;

   COMMENT ON COLUMN "HR"."REGIONS"."REGION_ID" IS 'Primary key of regions table.';
   COMMENT ON COLUMN "HR"."REGIONS"."REGION_NAME" IS 'Names of regions. Locations are in the countries of these regions.';
   COMMENT ON TABLE "HR"."REGIONS"  IS 'Regions table that contains region numbers and names. Contains 4 rows; references with the Countries table.';
REM INSERTING into HR.REGIONS
SET DEFINE OFF;
Insert into HR.REGIONS (REGION_ID,REGION_NAME) values ('1','Europe');
Insert into HR.REGIONS (REGION_ID,REGION_NAME) values ('2','Americas');
Insert into HR.REGIONS (REGION_ID,REGION_NAME) values ('3','Asia');
Insert into HR.REGIONS (REGION_ID,REGION_NAME) values ('4','Middle East and Africa');
--------------------------------------------------------
--  DDL for Index REG_ID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HR"."REG_ID_PK" ON "HR"."REGIONS" ("REGION_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table REGIONS
--------------------------------------------------------

  ALTER TABLE "HR"."REGIONS" MODIFY ("REGION_ID" CONSTRAINT "REGION_ID_NN" NOT NULL ENABLE);
  ALTER TABLE "HR"."REGIONS" ADD CONSTRAINT "REG_ID_PK" PRIMARY KEY ("REGION_ID")
  USING INDEX  ENABLE;

  