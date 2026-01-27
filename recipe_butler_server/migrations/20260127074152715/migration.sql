BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "reminder" (
    "id" bigserial PRIMARY KEY,
    "shoppingListId" bigint NOT NULL,
    "createdByUserId" text NOT NULL,
    "title" text NOT NULL,
    "dueAt" timestamp without time zone NOT NULL,
    "isDone" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "reminder_list_idx" ON "reminder" USING btree ("shoppingListId");
CREATE INDEX "reminder_due_idx" ON "reminder" USING btree ("dueAt");


--
-- MIGRATION VERSION FOR recipe_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('recipe_butler', '20260127074152715', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260127074152715', "timestamp" = now();

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
