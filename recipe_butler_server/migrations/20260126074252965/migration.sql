BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ingredient" (
    "id" bigserial PRIMARY KEY,
    "recipeId" bigint NOT NULL,
    "text" text NOT NULL
);

-- Indexes
CREATE INDEX "ingredient_recipe_idx" ON "ingredient" USING btree ("recipeId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "recipe" (
    "id" bigserial PRIMARY KEY,
    "ownerUserId" text NOT NULL,
    "title" text NOT NULL,
    "sourceUrl" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "recipe_owner_idx" ON "recipe" USING btree ("ownerUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "recipe_step" (
    "id" bigserial PRIMARY KEY,
    "recipeId" bigint NOT NULL,
    "orderIndex" bigint NOT NULL,
    "text" text NOT NULL
);

-- Indexes
CREATE INDEX "step_recipe_idx" ON "recipe_step" USING btree ("recipeId");


--
-- MIGRATION VERSION FOR recipe_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('recipe_butler', '20260126074252965', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260126074252965', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
