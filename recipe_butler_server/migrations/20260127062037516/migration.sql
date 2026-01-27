BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "task_message" (
    "id" bigserial PRIMARY KEY,
    "shoppingListId" bigint NOT NULL,
    "userId" text NOT NULL,
    "text" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "task_message_list_idx" ON "task_message" USING btree ("shoppingListId");


--
-- MIGRATION VERSION FOR recipe_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('recipe_butler', '20260127062037516', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260127062037516', "timestamp" = now();

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
