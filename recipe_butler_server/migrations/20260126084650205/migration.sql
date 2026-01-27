BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "invite" (
    "id" bigserial PRIMARY KEY,
    "targetType" text NOT NULL,
    "targetId" bigint NOT NULL,
    "token" text NOT NULL,
    "role" text NOT NULL,
    "expiresAt" timestamp without time zone,
    "acceptedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "invite_token_idx" ON "invite" USING btree ("token");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shopping_item" (
    "id" bigserial PRIMARY KEY,
    "shoppingListId" bigint NOT NULL,
    "text" text NOT NULL,
    "isChecked" boolean NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "updatedByUserId" text
);

-- Indexes
CREATE INDEX "shopping_item_list_idx" ON "shopping_item" USING btree ("shoppingListId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shopping_list" (
    "id" bigserial PRIMARY KEY,
    "ownerUserId" text NOT NULL,
    "name" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "shopping_list_owner_idx" ON "shopping_list" USING btree ("ownerUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shopping_list_member" (
    "id" bigserial PRIMARY KEY,
    "shoppingListId" bigint NOT NULL,
    "userId" text NOT NULL,
    "role" text NOT NULL
);


--
-- MIGRATION VERSION FOR recipe_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('recipe_butler', '20260126084650205', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260126084650205', "timestamp" = now();

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
