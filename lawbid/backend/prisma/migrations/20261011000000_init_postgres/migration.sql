-- Склеено из 141 старой миграции CockroachDB и переведено на Postgres (11.10.2026).
-- Убрано: роли и GRANT, hash-шардирование, триграммные индексы.
-- Stage 1.3: auth schema (docs/01_FOUNDATION_AUTH.md §15 -- generated via
-- `prisma migrate diff --from-empty --to-schema-datamodel` (no live
-- CockroachDB instance was available in the sandbox to run
-- `prisma migrate dev` directly). Verified: `prisma validate` and
-- `prisma generate` both pass against this schema. NOT yet verified:
-- this file has not been applied to a real running CockroachDB --
-- that must happen the first time `prisma migrate deploy` (or
-- `docker compose up` + `prisma migrate dev`) is run against a live
-- instance, per docs/CHANGELOG.md.

-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "user_role" AS ENUM ('client', 'attorney', 'admin');

-- CreateEnum
CREATE TYPE "user_status" AS ENUM ('active', 'suspended', 'deletion_pending', 'deleted');

-- CreateEnum
CREATE TYPE "theme_pref" AS ENUM ('system', 'light', 'dark');

-- CreateEnum
CREATE TYPE "identifier_type" AS ENUM ('phone', 'email', 'apple', 'google');

-- CreateEnum
CREATE TYPE "consent_type" AS ENUM ('terms', 'privacy', 'disclaimer', 'client_contact_sharing', 'age_18', 'marketing_email', 'marketing_push', 'analytics');

-- CreateEnum
CREATE TYPE "legal_doc_type" AS ENUM ('terms', 'privacy', 'disclaimer', 'client_contact_sharing');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "role" "user_role" NOT NULL,
    "status" "user_status" NOT NULL DEFAULT 'active',
    "first_name" TEXT,
    "last_name" TEXT,
    "avatar_file_id" UUID,
    "email" TEXT,
    "email_verified_at" TIMESTAMPTZ,
    "phone_e164" TEXT,
    "phone_verified_at" TIMESTAMPTZ,
    "ui_language" TEXT NOT NULL DEFAULT 'en',
    "theme" "theme_pref" NOT NULL DEFAULT 'system',
    "suspended_reason" TEXT,
    "last_active_at" TIMESTAMPTZ,
    "deletion_requested_at" TIMESTAMPTZ,
    "deleted_at" TIMESTAMPTZ,
    "anonymized_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_identifiers" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "provider" "identifier_type" NOT NULL,
    "provider_uid" TEXT NOT NULL,
    "verified_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "user_identifiers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sessions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "device_id" TEXT,
    "device_name" TEXT,
    "platform" TEXT,
    "app_version" TEXT,
    "ip" TEXT,
    "user_agent" TEXT,
    "refresh_hash" TEXT NOT NULL,
    "last_used_at" TIMESTAMPTZ,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "revoked_at" TIMESTAMPTZ,
    "revoked_reason" TEXT,
    "replaced_by_session_id" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "auth_events" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID,
    "event_type" TEXT NOT NULL,
    "success" BOOL NOT NULL,
    "identifier_hash" TEXT,
    "ip" TEXT,
    "device_id" TEXT,
    "user_agent" TEXT,
    "meta" JSONB,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "auth_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "legal_documents" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "doc_type" "legal_doc_type" NOT NULL,
    "version" TEXT NOT NULL,
    "locale" TEXT NOT NULL,
    "content_url" TEXT,
    "content_md" TEXT,
    "published_at" TIMESTAMPTZ,
    "is_current" BOOL NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "legal_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_consents" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "consent_type" "consent_type" NOT NULL,
    "document_id" UUID,
    "granted" BOOL NOT NULL,
    "ip" TEXT,
    "device_id" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_consents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "onboarding_state" (
    "user_id" UUID NOT NULL,
    "current_step" TEXT,
    "completed_at" TIMESTAMPTZ,
    "data" JSONB,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "onboarding_state_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "blocked_email_domains" (
    "domain" TEXT NOT NULL,
    "reason" TEXT NOT NULL,

    CONSTRAINT "blocked_email_domains_pkey" PRIMARY KEY ("domain")
);

-- CreateTable
CREATE TABLE "feature_flags" (
    "key" TEXT NOT NULL,
    "enabled" BOOL NOT NULL,
    "rollout_percent" INTEGER NOT NULL DEFAULT 100,
    "description" TEXT,
    "updated_by" UUID,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "feature_flags_pkey" PRIMARY KEY ("key")
);

-- CreateTable
CREATE TABLE "i18n_languages" (
    "code" TEXT NOT NULL,
    "name_native" TEXT NOT NULL,
    "is_active" BOOL NOT NULL,
    "is_rtl" BOOL NOT NULL DEFAULT false,
    "sort" INTEGER NOT NULL,

    CONSTRAINT "i18n_languages_pkey" PRIMARY KEY ("code")
);

-- CreateTable
CREATE TABLE "i18n_keys" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "key" TEXT NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "i18n_keys_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "i18n_translations" (
    "key_id" UUID NOT NULL,
    "lang" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "i18n_translations_pkey" PRIMARY KEY ("key_id","lang")
);

-- CreateTable
CREATE TABLE "i18n_bundle_versions" (
    "lang" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "i18n_bundle_versions_pkey" PRIMARY KEY ("lang")
);

-- CreateIndex
CREATE INDEX "user_identifiers_user_id_idx" ON "user_identifiers"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_identifiers_provider_provider_uid_key" ON "user_identifiers"("provider", "provider_uid");

-- CreateIndex
CREATE UNIQUE INDEX "sessions_refresh_hash_key" ON "sessions"("refresh_hash");

-- CreateIndex
CREATE INDEX "sessions_user_id_idx" ON "sessions"("user_id");

-- CreateIndex
CREATE INDEX "auth_events_user_id_created_at_idx" ON "auth_events"("user_id", "created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "legal_documents_doc_type_version_locale_key" ON "legal_documents"("doc_type", "version", "locale");

-- CreateIndex
CREATE INDEX "user_consents_user_id_consent_type_created_at_idx" ON "user_consents"("user_id", "consent_type", "created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "i18n_keys_key_key" ON "i18n_keys"("key");

-- AddForeignKey
ALTER TABLE "user_identifiers" ADD CONSTRAINT "user_identifiers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "auth_events" ADD CONSTRAINT "auth_events_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_consents" ADD CONSTRAINT "user_consents_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_consents" ADD CONSTRAINT "user_consents_document_id_fkey" FOREIGN KEY ("document_id") REFERENCES "legal_documents"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "onboarding_state" ADD CONSTRAINT "onboarding_state_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feature_flags" ADD CONSTRAINT "feature_flags_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "i18n_translations" ADD CONSTRAINT "i18n_translations_key_id_fkey" FOREIGN KEY ("key_id") REFERENCES "i18n_keys"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "i18n_translations" ADD CONSTRAINT "i18n_translations_lang_fkey" FOREIGN KEY ("lang") REFERENCES "i18n_languages"("code") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "i18n_bundle_versions" ADD CONSTRAINT "i18n_bundle_versions_lang_fkey" FOREIGN KEY ("lang") REFERENCES "i18n_languages"("code") ON DELETE RESTRICT ON UPDATE CASCADE;
-- Stage 1.4: add sessions.session_chain_id (docs/CHANGELOG.md has the full
-- rationale). Hand-written rather than `prisma migrate diff` because that
-- mode needs a shadow database and this change is a single column + index
-- -- simple enough to write and read directly.
--
-- NOT NULL with no default: safe only because no session ever existed in a
-- real deployment before this stage (the only rows CockroachDB has seen so
-- far were in a throwaway local verification instance, since discarded).
-- If this repo ever has real session rows before this migration ships,
-- it needs a backfill step first (expand/contract, docs/02_DATABASE.md
-- §7.1) -- add one then, don't edit this file per .cursorrules.
ALTER TABLE "sessions" ADD COLUMN "session_chain_id" UUID NOT NULL;

CREATE INDEX "sessions_session_chain_id_idx" ON "sessions"("session_chain_id");
-- Stage 1.4: users.role becomes nullable. docs/01_FOUNDATION_AUTH.md §11's
-- guard logic treats "no role yet" as a real intermediate state (a user
-- exists from the moment OTP/social login succeeds, stage 1.4, but picks
-- client/attorney during onboarding step 2, later) -- the stage 1.3
-- schema didn't account for that. Hand-written for the same reason as the
-- session_chain_id migration: too small to need a shadow-DB diff.
ALTER TABLE "users" ALTER COLUMN "role" DROP NOT NULL;
-- CreateTable
CREATE TABLE "app_config" (
    "key" TEXT NOT NULL,
    "value" JSONB NOT NULL,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "app_config_pkey" PRIMARY KEY ("key")
);
-- CreateEnum
CREATE TYPE "file_purpose" AS ENUM ('avatar', 'post_image', 'verification_document', 'verification_selfie');

-- CreateEnum
CREATE TYPE "scan_status" AS ENUM ('pending', 'clean', 'infected', 'failed');

-- CreateEnum
CREATE TYPE "contact_method" AS ENUM ('call', 'sms', 'email', 'in_app_chat');

-- CreateEnum
CREATE TYPE "verification_status" AS ENUM ('unverified', 'pending', 'verified', 'rejected', 'suspended');

-- CreateEnum
CREATE TYPE "license_status" AS ENUM ('pending', 'verified', 'rejected', 'expired', 'suspended');

-- CreateEnum
CREATE TYPE "verification_request_status" AS ENUM ('draft', 'submitted', 'in_review', 'needs_more_info', 'approved', 'rejected');

-- CreateEnum
CREATE TYPE "verification_doc_type" AS ENUM ('bar_license', 'drivers_license', 'passport', 'state_id', 'selfie', 'other');

-- CreateEnum
CREATE TYPE "verification_provider" AS ENUM ('manual', 'stripe_identity', 'persona');

-- CreateEnum
CREATE TYPE "verification_check_type" AS ENUM ('bar_lookup', 'id_check', 'face_match');

-- CreateEnum
CREATE TYPE "check_result" AS ENUM ('pass', 'fail', 'manual_review');

-- CreateEnum
CREATE TYPE "case_status" AS ENUM ('open', 'in_progress', 'pending_completion', 'disputed', 'closed', 'archived');

-- CreateEnum
CREATE TYPE "budget_mode" AS ENUM ('amount', 'clarify_later');

-- CreateEnum
CREATE TYPE "bid_status" AS ENUM ('active', 'accepted', 'rejected_by_client', 'rejected_auto', 'withdrawn', 'failed_negotiation');

-- CreateEnum
CREATE TYPE "fee_type" AS ENUM ('fixed', 'hourly', 'free_consultation');

-- CreateEnum
CREATE TYPE "start_availability" AS ENUM ('immediately', 'within_week', 'custom_date');

-- CreateEnum
CREATE TYPE "party_role" AS ENUM ('client', 'attorney');

-- CreateEnum
CREATE TYPE "offer_status" AS ENUM ('pending', 'accepted', 'declined', 'countered', 'superseded');

-- CreateEnum
CREATE TYPE "case_journal_event" AS ENUM ('created', 'updated', 'bid_placed', 'offer_made', 'bid_accepted', 'bid_rejected', 'bid_withdrawn', 'negotiation_failed', 'contacts_disclosed', 'completion_requested', 'completion_confirmed', 'auto_closed', 'disputed', 'dispute_resolved', 'archived', 'restored', 'deleted', 'closed');

-- CreateEnum
CREATE TYPE "contact_issue_type" AS ENUM ('phone_invalid', 'no_answer', 'email_bounce', 'wrong_person', 'other');

-- CreateEnum
CREATE TYPE "contact_issue_status" AS ENUM ('open', 'confirmed', 'rejected');

-- CreateEnum
CREATE TYPE "dispute_status" AS ENUM ('open', 'resolved');

-- CreateEnum
CREATE TYPE "review_status" AS ENUM ('published', 'hidden', 'removed');

-- CreateEnum
CREATE TYPE "content_status" AS ENUM ('published', 'hidden', 'removed');

-- CreateEnum
CREATE TYPE "saved_item_type" AS ENUM ('post', 'case');

-- CreateEnum
CREATE TYPE "media_type" AS ENUM ('image', 'video');

-- CreateEnum
CREATE TYPE "conversation_status" AS ENUM ('pre_acceptance', 'active', 'closed');

-- CreateEnum
CREATE TYPE "message_type" AS ENUM ('text', 'system');

-- CreateEnum
CREATE TYPE "notification_type" AS ENUM ('bid_received', 'offer_countered', 'offer_accepted', 'bid_accepted', 'bid_rejected', 'negotiation_failed', 'case_stale_prompt', 'case_archived', 'completion_requested', 'completion_reminder', 'case_closed', 'new_message', 'new_follower', 'post_like', 'post_comment', 'comment_reply', 'comment_like', 'verification_update', 'subscription_trial_ending', 'subscription_payment_failed', 'subscription_status', 'contact_issue_update', 'moderation_notice', 'security_new_device');

-- CreateEnum
CREATE TYPE "notification_category" AS ENUM ('messages', 'bids', 'cases', 'social', 'system', 'marketing');

-- CreateEnum
CREATE TYPE "subscription_status" AS ENUM ('trialing', 'active', 'past_due', 'canceled', 'incomplete', 'expired');

-- CreateEnum
CREATE TYPE "payment_status" AS ENUM ('pending', 'succeeded', 'failed', 'refunded');

-- CreateEnum
CREATE TYPE "report_target_type" AS ENUM ('post', 'comment', 'user', 'message', 'case', 'review');

-- CreateEnum
CREATE TYPE "report_reason" AS ENUM ('spam', 'abuse', 'misinformation', 'impersonation', 'inappropriate', 'other');

-- CreateEnum
CREATE TYPE "report_status" AS ENUM ('open', 'actioned', 'dismissed');

-- CreateEnum
CREATE TYPE "moderation_action_type" AS ENUM ('hide', 'remove', 'warn', 'suspend', 'restore');

-- CreateEnum
CREATE TYPE "admin_role" AS ENUM ('super_admin', 'moderator', 'verifier', 'support', 'finance');

-- CreateEnum
CREATE TYPE "data_request_type" AS ENUM ('subpoena', 'court_order');

-- CreateEnum
CREATE TYPE "data_request_status" AS ENUM ('received', 'in_progress', 'fulfilled', 'rejected');

-- CreateTable
CREATE TABLE "states" (
    "code" CHAR(2) NOT NULL,
    "name" TEXT NOT NULL,
    "is_active" BOOL NOT NULL DEFAULT true,

    CONSTRAINT "states_pkey" PRIMARY KEY ("code")
);

-- CreateTable
CREATE TABLE "practice_areas" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "parent_id" UUID,
    "code" TEXT NOT NULL,
    "name_en" TEXT NOT NULL,
    "i18n_key" TEXT NOT NULL,
    "sort" INTEGER NOT NULL,
    "is_active" BOOL NOT NULL DEFAULT true,

    CONSTRAINT "practice_areas_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "practice_areas_code_key" ON "practice_areas"("code");

-- CreateIndex
CREATE INDEX "practice_areas_parent_id_idx" ON "practice_areas"("parent_id");

-- AddForeignKey
ALTER TABLE "practice_areas" ADD CONSTRAINT "practice_areas_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "practice_areas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
-- CreateTable
CREATE TABLE "files" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "owner_user_id" UUID NOT NULL,
    "purpose" "file_purpose" NOT NULL,
    "s3_bucket" TEXT NOT NULL,
    "s3_key" TEXT NOT NULL,
    "mime" TEXT NOT NULL,
    "size_bytes" BIGINT NOT NULL,
    "sha256" TEXT NOT NULL,
    "width" INTEGER,
    "height" INTEGER,
    "scan_status" "scan_status" NOT NULL DEFAULT 'pending',
    "is_public" BOOL NOT NULL DEFAULT false,
    "deleted_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "files_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "files_s3_key_key" ON "files"("s3_key");

-- CreateIndex
CREATE INDEX "files_owner_user_id_idx" ON "files"("owner_user_id");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_e164_key" ON "users"("phone_e164");

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_avatar_file_id_fkey" FOREIGN KEY ("avatar_file_id") REFERENCES "files"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "files" ADD CONSTRAINT "files_owner_user_id_fkey" FOREIGN KEY ("owner_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
-- CreateTable
CREATE TABLE "client_profiles" (
    "user_id" UUID NOT NULL,
    "state_code" CHAR(2) NOT NULL,
    "preferred_languages" TEXT[],
    "preferred_contact_method" "contact_method",
    "preferred_contact_note" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "client_profiles_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "attorney_profiles" (
    "user_id" UUID NOT NULL,
    "username" TEXT NOT NULL,
    "username_lower" TEXT NOT NULL,
    "bio" TEXT,
    "firm_name" TEXT,
    "languages" TEXT[],
    "verification_status" "verification_status" NOT NULL DEFAULT 'unverified',
    "verified_at" TIMESTAMPTZ,
    "rating_avg" DECIMAL(3,2) NOT NULL DEFAULT 0,
    "rating_count" INTEGER NOT NULL DEFAULT 0,
    "posts_count" INTEGER NOT NULL DEFAULT 0,
    "followers_count" INTEGER NOT NULL DEFAULT 0,
    "following_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "attorney_profiles_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "attorney_licenses" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "attorney_id" UUID NOT NULL,
    "state_code" CHAR(2) NOT NULL,
    "bar_number" TEXT NOT NULL,
    "license_status" "license_status" NOT NULL DEFAULT 'pending',
    "expires_at" DATE,
    "verified_at" TIMESTAMPTZ,
    "verified_by" UUID,
    "auto_check_result" JSONB,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "attorney_licenses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attorney_practice_areas" (
    "attorney_id" UUID NOT NULL,
    "practice_area_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "attorney_practice_areas_pkey" PRIMARY KEY ("attorney_id","practice_area_id")
);

-- CreateTable
CREATE TABLE "verification_requests" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "attorney_id" UUID NOT NULL,
    "status" "verification_request_status" NOT NULL,
    "provider" "verification_provider" NOT NULL DEFAULT 'manual',
    "provider_ref" TEXT,
    "submitted_at" TIMESTAMPTZ,
    "reviewed_by" UUID,
    "reviewed_at" TIMESTAMPTZ,
    "rejection_reason" TEXT,
    "admin_note" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "verification_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "verification_documents" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "request_id" UUID NOT NULL,
    "doc_type" "verification_doc_type" NOT NULL,
    "file_id" UUID NOT NULL,
    "state_code" CHAR(2),
    "notes" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "verification_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "verification_checks" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "request_id" UUID NOT NULL,
    "check_type" "verification_check_type" NOT NULL,
    "provider" "verification_provider" NOT NULL,
    "result" "check_result" NOT NULL,
    "details" JSONB NOT NULL,
    "checked_at" TIMESTAMPTZ NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "verification_checks_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "attorney_profiles_username_lower_key" ON "attorney_profiles"("username_lower");

-- CreateIndex
CREATE INDEX "attorney_licenses_attorney_id_idx" ON "attorney_licenses"("attorney_id");

-- CreateIndex
CREATE INDEX "attorney_licenses_state_code_license_status_idx" ON "attorney_licenses"("state_code", "license_status");

-- CreateIndex
CREATE UNIQUE INDEX "attorney_licenses_state_code_bar_number_key" ON "attorney_licenses"("state_code", "bar_number");

-- CreateIndex
CREATE INDEX "attorney_practice_areas_practice_area_id_attorney_id_idx" ON "attorney_practice_areas"("practice_area_id", "attorney_id");

-- CreateIndex
CREATE INDEX "verification_requests_attorney_id_idx" ON "verification_requests"("attorney_id");

-- CreateIndex
CREATE INDEX "verification_requests_status_submitted_at_idx" ON "verification_requests"("status", "submitted_at");

-- CreateIndex
CREATE INDEX "verification_documents_request_id_idx" ON "verification_documents"("request_id");

-- CreateIndex
CREATE INDEX "verification_checks_request_id_idx" ON "verification_checks"("request_id");

-- AddForeignKey
ALTER TABLE "client_profiles" ADD CONSTRAINT "client_profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "client_profiles" ADD CONSTRAINT "client_profiles_state_code_fkey" FOREIGN KEY ("state_code") REFERENCES "states"("code") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attorney_profiles" ADD CONSTRAINT "attorney_profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attorney_licenses" ADD CONSTRAINT "attorney_licenses_attorney_id_fkey" FOREIGN KEY ("attorney_id") REFERENCES "attorney_profiles"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attorney_licenses" ADD CONSTRAINT "attorney_licenses_state_code_fkey" FOREIGN KEY ("state_code") REFERENCES "states"("code") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attorney_licenses" ADD CONSTRAINT "attorney_licenses_verified_by_fkey" FOREIGN KEY ("verified_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attorney_practice_areas" ADD CONSTRAINT "attorney_practice_areas_attorney_id_fkey" FOREIGN KEY ("attorney_id") REFERENCES "attorney_profiles"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attorney_practice_areas" ADD CONSTRAINT "attorney_practice_areas_practice_area_id_fkey" FOREIGN KEY ("practice_area_id") REFERENCES "practice_areas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "verification_requests" ADD CONSTRAINT "verification_requests_attorney_id_fkey" FOREIGN KEY ("attorney_id") REFERENCES "attorney_profiles"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "verification_requests" ADD CONSTRAINT "verification_requests_reviewed_by_fkey" FOREIGN KEY ("reviewed_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "verification_documents" ADD CONSTRAINT "verification_documents_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "verification_requests"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "verification_documents" ADD CONSTRAINT "verification_documents_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "files"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "verification_documents" ADD CONSTRAINT "verification_documents_state_code_fkey" FOREIGN KEY ("state_code") REFERENCES "states"("code") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "verification_checks" ADD CONSTRAINT "verification_checks_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "verification_requests"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- docs/02_DATABASE.md §4.C / §6.1: length limits.
ALTER TABLE "client_profiles" ADD CONSTRAINT "client_profiles_contact_note_len" CHECK (char_length("preferred_contact_note") <= 200);

ALTER TABLE "attorney_profiles" ADD CONSTRAINT "attorney_profiles_bio_len" CHECK (char_length("bio") <= 300);

-- username_lower must be the lowercased username (UQ is case-insensitive by construction).
ALTER TABLE "attorney_profiles" ADD CONSTRAINT "attorney_profiles_username_lower_ck" CHECK ("username_lower" = lower("username"));
-- CreateTable
CREATE TABLE "cases" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "client_id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "practice_area_id" UUID NOT NULL,
    "primary_state_code" CHAR(2) NOT NULL,
    "city" TEXT,
    "budget_mode" "budget_mode" NOT NULL,
    "budget_cents" INTEGER,
    "status" "case_status" NOT NULL DEFAULT 'open',
    "accepted_bid_id" UUID,
    "view_count" INTEGER NOT NULL DEFAULT 0,
    "bids_count" INTEGER NOT NULL DEFAULT 0,
    "last_activity_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "stale_prompt_sent_at" TIMESTAMPTZ,
    "archived_at" TIMESTAMPTZ,
    "client_completed_at" TIMESTAMPTZ,
    "attorney_confirmed_at" TIMESTAMPTZ,
    "auto_close_at" TIMESTAMPTZ,
    "closed_at" TIMESTAMPTZ,
    "deleted_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "cases_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "case_states" (
    "case_id" UUID NOT NULL,
    "state_code" CHAR(2) NOT NULL,
    "is_primary" BOOL NOT NULL DEFAULT false,

    CONSTRAINT "case_states_pkey" PRIMARY KEY ("case_id","state_code")
);

-- CreateTable
CREATE TABLE "bids" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "case_id" UUID NOT NULL,
    "attorney_id" UUID NOT NULL,
    "status" "bid_status" NOT NULL DEFAULT 'active',
    "fee_type" "fee_type" NOT NULL,
    "amount_cents" INTEGER NOT NULL,
    "message" TEXT NOT NULL,
    "start_availability" "start_availability" NOT NULL,
    "start_date" DATE,
    "estimated_duration_days" INTEGER,
    "round_count" SMALLINT NOT NULL DEFAULT 0,
    "turn" "party_role" NOT NULL,
    "decided_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "bids_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bid_offers" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "bid_id" UUID NOT NULL,
    "round_no" SMALLINT NOT NULL,
    "from_role" "party_role" NOT NULL,
    "fee_type" "fee_type" NOT NULL,
    "amount_cents" INTEGER NOT NULL,
    "message" TEXT,
    "status" "offer_status" NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "bid_offers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "case_journal" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "case_id" UUID NOT NULL,
    "client_id" UUID NOT NULL,
    "actor_user_id" UUID,
    "actor_role" "user_role",
    "event_type" "case_journal_event" NOT NULL,
    "payload" JSONB NOT NULL,
    "prev_hash" TEXT,
    "row_hash" TEXT NOT NULL,
    "retain_until" TIMESTAMPTZ NOT NULL DEFAULT now() + '5 years'::INTERVAL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "case_journal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contact_disclosures" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "case_id" UUID NOT NULL,
    "bid_id" UUID NOT NULL,
    "client_id" UUID NOT NULL,
    "attorney_id" UUID NOT NULL,
    "fields" TEXT[],
    "ip" TEXT,
    "device_id" TEXT,
    "disclosed_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "contact_disclosures_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contact_issue_reports" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "case_id" UUID NOT NULL,
    "bid_id" UUID NOT NULL,
    "attorney_id" UUID NOT NULL,
    "client_id" UUID NOT NULL,
    "issue_type" "contact_issue_type" NOT NULL,
    "note" TEXT,
    "status" "contact_issue_status" NOT NULL DEFAULT 'open',
    "resolved_by" UUID,
    "resolved_at" TIMESTAMPTZ,
    "resolution_note" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "contact_issue_reports_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "case_disputes" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "case_id" UUID NOT NULL,
    "opened_by" UUID NOT NULL,
    "reason" TEXT NOT NULL,
    "status" "dispute_status" NOT NULL DEFAULT 'open',
    "resolved_by" UUID,
    "resolved_at" TIMESTAMPTZ,
    "resolution_note" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "case_disputes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reviews" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "case_id" UUID NOT NULL,
    "client_id" UUID NOT NULL,
    "attorney_id" UUID NOT NULL,
    "rating" SMALLINT NOT NULL,
    "body" TEXT,
    "status" "review_status" NOT NULL DEFAULT 'published',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "reviews_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "cases_accepted_bid_id_key" ON "cases"("accepted_bid_id");

-- CreateIndex
CREATE INDEX "cases_client_id_status_created_at_idx" ON "cases"("client_id", "status", "created_at" DESC);

-- CreateIndex
CREATE INDEX "cases_primary_state_code_practice_area_id_created_at_idx" ON "cases"("primary_state_code", "practice_area_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "case_states_state_code_case_id_idx" ON "case_states"("state_code", "case_id");

-- CreateIndex
CREATE INDEX "bids_case_id_status_idx" ON "bids"("case_id", "status");

-- CreateIndex
CREATE INDEX "bids_attorney_id_status_updated_at_idx" ON "bids"("attorney_id", "status", "updated_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "bids_case_id_attorney_id_key" ON "bids"("case_id", "attorney_id");

-- CreateIndex
CREATE UNIQUE INDEX "bid_offers_bid_id_round_no_key" ON "bid_offers"("bid_id", "round_no");

-- CreateIndex
CREATE INDEX "case_journal_case_id_created_at_idx" ON "case_journal"("case_id", "created_at");

-- CreateIndex
CREATE INDEX "case_journal_client_id_created_at_idx" ON "case_journal"("client_id", "created_at");

-- CreateIndex
CREATE INDEX "case_journal_retain_until_idx" ON "case_journal"("retain_until");

-- CreateIndex
CREATE UNIQUE INDEX "contact_disclosures_bid_id_key" ON "contact_disclosures"("bid_id");

-- CreateIndex
CREATE INDEX "contact_issue_reports_status_created_at_idx" ON "contact_issue_reports"("status", "created_at");

-- CreateIndex
CREATE INDEX "case_disputes_case_id_idx" ON "case_disputes"("case_id");

-- CreateIndex
CREATE UNIQUE INDEX "reviews_case_id_key" ON "reviews"("case_id");

-- CreateIndex
CREATE INDEX "reviews_attorney_id_created_at_idx" ON "reviews"("attorney_id", "created_at" DESC);

-- AddForeignKey
ALTER TABLE "cases" ADD CONSTRAINT "cases_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cases" ADD CONSTRAINT "cases_practice_area_id_fkey" FOREIGN KEY ("practice_area_id") REFERENCES "practice_areas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cases" ADD CONSTRAINT "cases_primary_state_code_fkey" FOREIGN KEY ("primary_state_code") REFERENCES "states"("code") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cases" ADD CONSTRAINT "cases_accepted_bid_id_fkey" FOREIGN KEY ("accepted_bid_id") REFERENCES "bids"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "case_states" ADD CONSTRAINT "case_states_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "case_states" ADD CONSTRAINT "case_states_state_code_fkey" FOREIGN KEY ("state_code") REFERENCES "states"("code") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bids" ADD CONSTRAINT "bids_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bids" ADD CONSTRAINT "bids_attorney_id_fkey" FOREIGN KEY ("attorney_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bid_offers" ADD CONSTRAINT "bid_offers_bid_id_fkey" FOREIGN KEY ("bid_id") REFERENCES "bids"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "case_journal" ADD CONSTRAINT "case_journal_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "case_journal" ADD CONSTRAINT "case_journal_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "case_journal" ADD CONSTRAINT "case_journal_actor_user_id_fkey" FOREIGN KEY ("actor_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contact_disclosures" ADD CONSTRAINT "contact_disclosures_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contact_disclosures" ADD CONSTRAINT "contact_disclosures_bid_id_fkey" FOREIGN KEY ("bid_id") REFERENCES "bids"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contact_disclosures" ADD CONSTRAINT "contact_disclosures_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contact_disclosures" ADD CONSTRAINT "contact_disclosures_attorney_id_fkey" FOREIGN KEY ("attorney_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contact_issue_reports" ADD CONSTRAINT "contact_issue_reports_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contact_issue_reports" ADD CONSTRAINT "contact_issue_reports_bid_id_fkey" FOREIGN KEY ("bid_id") REFERENCES "bids"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contact_issue_reports" ADD CONSTRAINT "contact_issue_reports_attorney_id_fkey" FOREIGN KEY ("attorney_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contact_issue_reports" ADD CONSTRAINT "contact_issue_reports_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contact_issue_reports" ADD CONSTRAINT "contact_issue_reports_resolved_by_fkey" FOREIGN KEY ("resolved_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "case_disputes" ADD CONSTRAINT "case_disputes_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "case_disputes" ADD CONSTRAINT "case_disputes_opened_by_fkey" FOREIGN KEY ("opened_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "case_disputes" ADD CONSTRAINT "case_disputes_resolved_by_fkey" FOREIGN KEY ("resolved_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_attorney_id_fkey" FOREIGN KEY ("attorney_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- docs/02_DATABASE.md §6.1 CHECK constraints (stage 2.4).
ALTER TABLE "bids" ADD CONSTRAINT "bids_round_count_ck" CHECK ("round_count" BETWEEN 0 AND 5);

ALTER TABLE "bids" ADD CONSTRAINT "bids_amount_cents_ck" CHECK ("amount_cents" >= 0);

ALTER TABLE "bids" ADD CONSTRAINT "bids_message_len" CHECK (char_length("message") <= 2000);

ALTER TABLE "bid_offers" ADD CONSTRAINT "bid_offers_amount_cents_ck" CHECK ("amount_cents" >= 0);

ALTER TABLE "bid_offers" ADD CONSTRAINT "bid_offers_round_no_ck" CHECK ("round_no" BETWEEN 0 AND 5);

ALTER TABLE "cases" ADD CONSTRAINT "cases_budget_cents_ck" CHECK ("budget_cents" >= 0);

ALTER TABLE "cases" ADD CONSTRAINT "cases_budget_mode_ck" CHECK (("budget_mode" = 'amount') = ("budget_cents" IS NOT NULL));

ALTER TABLE "cases" ADD CONSTRAINT "cases_title_len" CHECK (char_length("title") <= 120);

ALTER TABLE "cases" ADD CONSTRAINT "cases_description_len" CHECK (char_length("description") <= 5000);

ALTER TABLE "reviews" ADD CONSTRAINT "reviews_rating_ck" CHECK ("rating" BETWEEN 1 AND 5);

ALTER TABLE "reviews" ADD CONSTRAINT "reviews_body_len" CHECK (char_length("body") <= 1000);
-- This is an empty migration.


-- docs/02_DATABASE.md §4.D / §5.1: exactly one primary state per case
-- (partial UQ). Max 3 rows and "at least one primary" are enforced by
-- validateCaseStates() in the case domain (no triggers on CockroachDB 24.1).
CREATE UNIQUE INDEX "case_states_one_primary_uq" ON "case_states"("case_id") WHERE "is_primary";
-- CreateTable
CREATE TABLE "posts" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "author_id" UUID NOT NULL,
    "body" TEXT NOT NULL,
    "language" TEXT,
    "status" "content_status" NOT NULL DEFAULT 'published',
    "like_count" INTEGER NOT NULL DEFAULT 0,
    "comment_count" INTEGER NOT NULL DEFAULT 0,
    "save_count" INTEGER NOT NULL DEFAULT 0,
    "deleted_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "posts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "post_media" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "post_id" UUID NOT NULL,
    "file_id" UUID NOT NULL,
    "media_type" "media_type" NOT NULL DEFAULT 'image',
    "position" SMALLINT NOT NULL,
    "width" INTEGER,
    "height" INTEGER,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "post_media_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tags" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "tag_lower" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "post_tags" (
    "post_id" UUID NOT NULL,
    "tag_id" UUID NOT NULL,

    CONSTRAINT "post_tags_pkey" PRIMARY KEY ("post_id","tag_id")
);

-- CreateTable
CREATE TABLE "comments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "post_id" UUID NOT NULL,
    "author_id" UUID NOT NULL,
    "parent_comment_id" UUID,
    "body" TEXT NOT NULL,
    "status" "content_status" NOT NULL DEFAULT 'published',
    "like_count" INTEGER NOT NULL DEFAULT 0,
    "reply_count" INTEGER NOT NULL DEFAULT 0,
    "deleted_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "comments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "post_likes" (
    "post_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "post_likes_pkey" PRIMARY KEY ("post_id","user_id")
);

-- CreateTable
CREATE TABLE "comment_likes" (
    "comment_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "comment_likes_pkey" PRIMARY KEY ("comment_id","user_id")
);

-- CreateTable
CREATE TABLE "follows" (
    "follower_id" UUID NOT NULL,
    "followee_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "follows_pkey" PRIMARY KEY ("follower_id","followee_id")
);

-- CreateTable
CREATE TABLE "saved_items" (
    "user_id" UUID NOT NULL,
    "item_type" "saved_item_type" NOT NULL,
    "item_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "saved_items_pkey" PRIMARY KEY ("user_id","item_type","item_id")
);

-- CreateTable
CREATE TABLE "conversations" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "case_id" UUID NOT NULL,
    "attorney_id" UUID NOT NULL,
    "client_id" UUID NOT NULL,
    "bid_id" UUID,
    "status" "conversation_status" NOT NULL DEFAULT 'pre_acceptance',
    "contacts_unlocked" BOOL NOT NULL DEFAULT false,
    "last_message_at" TIMESTAMPTZ,
    "last_message_id" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "conversations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "conversation_participants" (
    "conversation_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "last_read_message_id" UUID,
    "muted_until" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "conversation_participants_pkey" PRIMARY KEY ("conversation_id","user_id")
);

-- CreateTable
CREATE TABLE "messages" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "conversation_id" UUID NOT NULL,
    "sender_id" UUID,
    "type" "message_type" NOT NULL,
    "body_original" TEXT NOT NULL,
    "body_display" TEXT NOT NULL,
    "contact_masked" BOOL NOT NULL DEFAULT false,
    "client_message_id" TEXT NOT NULL,
    "deleted_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "type" "notification_type" NOT NULL,
    "category" "notification_category" NOT NULL,
    "payload" JSONB NOT NULL,
    "read_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_settings" (
    "user_id" UUID NOT NULL,
    "category" "notification_category" NOT NULL,
    "push_enabled" BOOL NOT NULL DEFAULT true,
    "email_enabled" BOOL NOT NULL DEFAULT true,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "notification_settings_pkey" PRIMARY KEY ("user_id","category")
);

-- CreateTable
CREATE TABLE "notification_quiet_hours" (
    "user_id" UUID NOT NULL,
    "start_time" TIME NOT NULL,
    "end_time" TIME NOT NULL,
    "timezone" TEXT NOT NULL,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "notification_quiet_hours_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "push_tokens" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "session_id" UUID NOT NULL,
    "fcm_token" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "last_seen_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "push_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stripe_customers" (
    "user_id" UUID NOT NULL,
    "stripe_customer_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "stripe_customers_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "subscriptions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "stripe_subscription_id" TEXT,
    "status" "subscription_status" NOT NULL,
    "price_cents" INTEGER NOT NULL,
    "trial_started_at" TIMESTAMPTZ,
    "trial_ends_at" TIMESTAMPTZ,
    "current_period_start" TIMESTAMPTZ,
    "current_period_end" TIMESTAMPTZ,
    "cancel_at_period_end" BOOL NOT NULL DEFAULT false,
    "canceled_at" TIMESTAMPTZ,
    "card_fingerprint" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "stripe_invoice_id" TEXT,
    "stripe_payment_intent_id" TEXT,
    "amount_cents" INTEGER NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'usd',
    "status" "payment_status" NOT NULL,
    "paid_at" TIMESTAMPTZ,
    "failure_code" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stripe_webhook_events" (
    "stripe_event_id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "processed_at" TIMESTAMPTZ,
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "stripe_webhook_events_pkey" PRIMARY KEY ("stripe_event_id")
);

-- CreateTable
CREATE TABLE "reports" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "reporter_id" UUID NOT NULL,
    "target_type" "report_target_type" NOT NULL,
    "target_id" UUID NOT NULL,
    "reason" "report_reason" NOT NULL,
    "note" TEXT,
    "status" "report_status" NOT NULL DEFAULT 'open',
    "handled_by" UUID,
    "handled_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "reports_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "moderation_actions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "report_id" UUID,
    "admin_id" UUID NOT NULL,
    "target_type" "report_target_type" NOT NULL,
    "target_id" UUID NOT NULL,
    "action" "moderation_action_type" NOT NULL,
    "reason" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "moderation_actions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "admin_profiles" (
    "user_id" UUID NOT NULL,
    "admin_role" "admin_role" NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "admin_profiles_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "audit_log" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "admin_id" UUID NOT NULL,
    "action" TEXT NOT NULL,
    "target_type" TEXT NOT NULL,
    "target_id" UUID,
    "before" JSONB,
    "after" JSONB,
    "ip" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_log_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "data_access_requests" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "request_type" "data_request_type" NOT NULL,
    "reference_number" TEXT NOT NULL,
    "agency" TEXT NOT NULL,
    "received_at" TIMESTAMPTZ NOT NULL,
    "scope" TEXT NOT NULL,
    "handled_by" UUID NOT NULL,
    "status" "data_request_status" NOT NULL,
    "closed_at" TIMESTAMPTZ,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "data_access_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "data_access_log" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "request_id" UUID NOT NULL,
    "admin_id" UUID NOT NULL,
    "entity_type" TEXT NOT NULL,
    "entity_id" UUID NOT NULL,
    "accessed_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "data_access_log_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "post_media_post_id_position_key" ON "post_media"("post_id", "position");

-- CreateIndex
CREATE UNIQUE INDEX "tags_tag_lower_key" ON "tags"("tag_lower");

-- CreateIndex
CREATE INDEX "post_tags_tag_id_post_id_idx" ON "post_tags"("tag_id", "post_id");

-- CreateIndex
CREATE INDEX "comments_post_id_created_at_idx" ON "comments"("post_id", "created_at");

-- CreateIndex
CREATE INDEX "comments_parent_comment_id_created_at_idx" ON "comments"("parent_comment_id", "created_at");

-- CreateIndex
CREATE INDEX "post_likes_user_id_created_at_idx" ON "post_likes"("user_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "follows_followee_id_follower_id_idx" ON "follows"("followee_id", "follower_id");

-- CreateIndex
CREATE INDEX "saved_items_user_id_item_type_created_at_idx" ON "saved_items"("user_id", "item_type", "created_at" DESC);

-- CreateIndex
CREATE INDEX "conversations_client_id_last_message_at_idx" ON "conversations"("client_id", "last_message_at" DESC);

-- CreateIndex
CREATE INDEX "conversations_attorney_id_last_message_at_idx" ON "conversations"("attorney_id", "last_message_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "conversations_case_id_attorney_id_key" ON "conversations"("case_id", "attorney_id");

-- CreateIndex
CREATE INDEX "conversation_participants_user_id_idx" ON "conversation_participants"("user_id");

-- CreateIndex
CREATE INDEX "messages_conversation_id_created_at_idx" ON "messages"("conversation_id", "created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "messages_conversation_id_sender_id_client_message_id_key" ON "messages"("conversation_id", "sender_id", "client_message_id");

-- CreateIndex
CREATE INDEX "notifications_user_id_created_at_idx" ON "notifications"("user_id", "created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "push_tokens_fcm_token_key" ON "push_tokens"("fcm_token");

-- CreateIndex
CREATE INDEX "push_tokens_user_id_idx" ON "push_tokens"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "stripe_customers_stripe_customer_id_key" ON "stripe_customers"("stripe_customer_id");

-- CreateIndex
CREATE UNIQUE INDEX "subscriptions_user_id_key" ON "subscriptions"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "subscriptions_stripe_subscription_id_key" ON "subscriptions"("stripe_subscription_id");

-- CreateIndex
CREATE INDEX "subscriptions_status_trial_ends_at_idx" ON "subscriptions"("status", "trial_ends_at");

-- CreateIndex
CREATE INDEX "subscriptions_current_period_end_idx" ON "subscriptions"("current_period_end");

-- CreateIndex
CREATE UNIQUE INDEX "payments_stripe_invoice_id_key" ON "payments"("stripe_invoice_id");

-- CreateIndex
CREATE INDEX "payments_user_id_created_at_idx" ON "payments"("user_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "reports_status_created_at_idx" ON "reports"("status", "created_at");

-- CreateIndex
CREATE INDEX "moderation_actions_target_type_target_id_idx" ON "moderation_actions"("target_type", "target_id");

-- CreateIndex
CREATE INDEX "audit_log_admin_id_created_at_idx" ON "audit_log"("admin_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "data_access_log_request_id_idx" ON "data_access_log"("request_id");

-- AddForeignKey
ALTER TABLE "posts" ADD CONSTRAINT "posts_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "post_media" ADD CONSTRAINT "post_media_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "posts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "post_media" ADD CONSTRAINT "post_media_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "files"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "post_tags" ADD CONSTRAINT "post_tags_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "posts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "post_tags" ADD CONSTRAINT "post_tags_tag_id_fkey" FOREIGN KEY ("tag_id") REFERENCES "tags"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "posts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_parent_comment_id_fkey" FOREIGN KEY ("parent_comment_id") REFERENCES "comments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "post_likes" ADD CONSTRAINT "post_likes_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "posts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "post_likes" ADD CONSTRAINT "post_likes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comment_likes" ADD CONSTRAINT "comment_likes_comment_id_fkey" FOREIGN KEY ("comment_id") REFERENCES "comments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comment_likes" ADD CONSTRAINT "comment_likes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "follows" ADD CONSTRAINT "follows_follower_id_fkey" FOREIGN KEY ("follower_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "follows" ADD CONSTRAINT "follows_followee_id_fkey" FOREIGN KEY ("followee_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "saved_items" ADD CONSTRAINT "saved_items_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversations" ADD CONSTRAINT "conversations_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversations" ADD CONSTRAINT "conversations_attorney_id_fkey" FOREIGN KEY ("attorney_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversations" ADD CONSTRAINT "conversations_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversations" ADD CONSTRAINT "conversations_bid_id_fkey" FOREIGN KEY ("bid_id") REFERENCES "bids"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversation_participants" ADD CONSTRAINT "conversation_participants_conversation_id_fkey" FOREIGN KEY ("conversation_id") REFERENCES "conversations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversation_participants" ADD CONSTRAINT "conversation_participants_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_conversation_id_fkey" FOREIGN KEY ("conversation_id") REFERENCES "conversations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_settings" ADD CONSTRAINT "notification_settings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_quiet_hours" ADD CONSTRAINT "notification_quiet_hours_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "push_tokens" ADD CONSTRAINT "push_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "push_tokens" ADD CONSTRAINT "push_tokens_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "sessions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stripe_customers" ADD CONSTRAINT "stripe_customers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscriptions" ADD CONSTRAINT "subscriptions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reports" ADD CONSTRAINT "reports_reporter_id_fkey" FOREIGN KEY ("reporter_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reports" ADD CONSTRAINT "reports_handled_by_fkey" FOREIGN KEY ("handled_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "moderation_actions" ADD CONSTRAINT "moderation_actions_report_id_fkey" FOREIGN KEY ("report_id") REFERENCES "reports"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "moderation_actions" ADD CONSTRAINT "moderation_actions_admin_id_fkey" FOREIGN KEY ("admin_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "admin_profiles" ADD CONSTRAINT "admin_profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_log" ADD CONSTRAINT "audit_log_admin_id_fkey" FOREIGN KEY ("admin_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "data_access_requests" ADD CONSTRAINT "data_access_requests_handled_by_fkey" FOREIGN KEY ("handled_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "data_access_log" ADD CONSTRAINT "data_access_log_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "data_access_requests"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "data_access_log" ADD CONSTRAINT "data_access_log_admin_id_fkey" FOREIGN KEY ("admin_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- docs/02_DATABASE.md §6.1 (stage 2.5).
ALTER TABLE "follows" ADD CONSTRAINT "follows_not_self_ck" CHECK ("follower_id" <> "followee_id");

ALTER TABLE "posts" ADD CONSTRAINT "posts_body_len" CHECK (char_length("body") <= 2200);

ALTER TABLE "comments" ADD CONSTRAINT "comments_body_len" CHECK (char_length("body") <= 1000);

ALTER TABLE "subscriptions" ADD CONSTRAINT "subscriptions_price_cents_ck" CHECK ("price_cents" >= 0);

ALTER TABLE "payments" ADD CONSTRAINT "payments_amount_cents_ck" CHECK ("amount_cents" >= 0);
ALTER TABLE "users" ADD COLUMN "full_name_lower" TEXT GENERATED ALWAYS AS (lower(COALESCE("first_name", '') || ' ' || COALESCE("last_name", ''))) STORED;

ALTER TABLE "posts" ADD COLUMN "search_tsv" TSVECTOR GENERATED ALWAYS AS (to_tsvector('english', "body")) STORED;

ALTER TABLE "cases" ADD COLUMN "search_tsv" TSVECTOR GENERATED ALWAYS AS (to_tsvector('english', "title" || ' ' || "description")) STORED;

-- ---------------------------------------------------------------------
-- §5.2 partial indexes (replace the plain ones Prisma created earlier)
-- ---------------------------------------------------------------------
DROP INDEX IF EXISTS "cases_client_id_status_created_at_idx";

DROP INDEX IF EXISTS "cases_primary_state_code_practice_area_id_created_at_idx";

DROP INDEX IF EXISTS "sessions_user_id_idx";

-- Attorney case feed (§5.2 / §5.4).
CREATE INDEX "cases_open_feed_idx" ON "cases" ("primary_state_code", "practice_area_id", "created_at" DESC)
  WHERE "status" = 'open' AND "deleted_at" IS NULL;

-- Client "My cases".
CREATE INDEX "cases_client_idx" ON "cases" ("client_id", "status", "created_at" DESC)
  WHERE "deleted_at" IS NULL;

-- Crons: stale prompt / archive, auto-close.
CREATE INDEX "cases_open_activity_idx" ON "cases" ("last_activity_at") WHERE "status" = 'open';

CREATE INDEX "cases_auto_close_idx" ON "cases" ("auto_close_at") WHERE "status" = 'pending_completion';

-- Practice lookup for the §5.4 query (cases by leaf + open).
CREATE INDEX "cases_open_practice_idx" ON "cases" ("practice_area_id", "created_at" DESC)
  WHERE "status" = 'open' AND "deleted_at" IS NULL;

CREATE INDEX "sessions_active_user_idx" ON "sessions" ("user_id") WHERE "revoked_at" IS NULL;

CREATE INDEX "notifications_unread_idx" ON "notifications" ("user_id") WHERE "read_at" IS NULL;

CREATE INDEX "posts_author_published_idx" ON "posts" ("author_id", "created_at" DESC)
  WHERE "status" = 'published' AND "deleted_at" IS NULL;

CREATE INDEX "posts_search_tsv_idx" ON "posts" USING gin ("search_tsv");

CREATE INDEX "cases_search_tsv_idx" ON "cases" USING gin ("search_tsv");

CREATE INDEX "attorney_profiles_languages_idx" ON "attorney_profiles" USING gin ("languages");

CREATE INDEX "client_profiles_languages_idx" ON "client_profiles" USING gin ("preferred_languages");
-- Fix for stage 2.6 (docs/02_DATABASE.md §1.1 / §5.2): replace the three
-- `USING HASH` indexes with an explicit STORED shard column + a plain index.
-- Prisma's schema engine panics while introspecting hash-sharded indexes
-- (sql-schema-describer unwrap on the hidden shard column) and the CLI then
-- reports "no drift" with exit code 0 — so `prisma migrate diff`, the CI drift
-- check and every future migration diff were silently broken. The explicit
-- column spreads writes over 16 ranges exactly like hash sharding does.
-- Dropping a hash-sharded index also drops its hidden shard column.
DROP INDEX IF EXISTS "posts_global_feed_idx";

DROP INDEX IF EXISTS "auth_events_created_at_idx";

DROP INDEX IF EXISTS "audit_log_created_at_idx";

ALTER TABLE "posts" ADD COLUMN "created_shard" SMALLINT NOT NULL DEFAULT 0;

ALTER TABLE "auth_events" ADD COLUMN "created_shard" SMALLINT NOT NULL DEFAULT 0;

ALTER TABLE "audit_log" ADD COLUMN "created_shard" SMALLINT NOT NULL DEFAULT 0;

-- Global feed: read as 16 limited per-shard scans merged by created_at
-- (UNION ALL of `WHERE created_shard = k ORDER BY created_at DESC LIMIT n`).
CREATE INDEX "posts_global_feed_idx" ON "posts" ("created_shard", "created_at" DESC)
  WHERE "status" = 'published';

CREATE INDEX "auth_events_created_at_idx" ON "auth_events" ("created_shard", "created_at");

CREATE INDEX "audit_log_created_at_idx" ON "audit_log" ("created_shard", "created_at");
-- Fix for stage 2.6: trigram GIN indexes can't be declared with Prisma's
-- CockroachDB connector (no gin_trgm_ops support), so Prisma's diff wanted to
-- drop them. Recreated as partial indexes, which Prisma ignores. The planner
-- uses them for LIKE/ILIKE '%term%' (verified with EXPLAIN); the `%`
-- similarity operator does not use a trigram index on this CockroachDB
-- version, so search (docs/05 stage 5.6) filters with LIKE and ranks with
-- similarity().
DROP INDEX IF EXISTS "users_full_name_trgm_idx";

DROP INDEX IF EXISTS "attorney_profiles_username_trgm_idx";

DROP INDEX IF EXISTS "tags_tag_trgm_idx";
-- AlterEnum
ALTER TYPE "notification_type" ADD VALUE 'review_requested';

ALTER TYPE "notification_type" ADD VALUE 'review_received';

-- AlterTable
ALTER TABLE "attorney_licenses" ADD COLUMN     "rejection_code" TEXT;

ALTER TABLE "attorney_licenses" ADD COLUMN     "rejection_note" TEXT;

-- AlterTable
ALTER TABLE "attorney_profiles" ADD COLUMN     "username_changed_at" TIMESTAMPTZ;

-- AlterTable
ALTER TABLE "reviews" ADD COLUMN     "edited_at" TIMESTAMPTZ;

-- AlterTable
ALTER TABLE "verification_documents" ADD COLUMN     "side" TEXT;

-- AlterTable
ALTER TABLE "verification_requests" ADD COLUMN     "applicant_comment" TEXT;

ALTER TABLE "verification_requests" ADD COLUMN     "info_request_message" TEXT;

ALTER TABLE "verification_requests" ADD COLUMN     "rejection_code" TEXT;

-- docs/03_VERIFICATION_PROFILES.md §10: applicant comment up to 500 chars;
-- side is front | back. verification_documents(request_id) already
-- exists (stage 2.3).
ALTER TABLE "verification_requests" ADD CONSTRAINT "verification_requests_applicant_comment_len" CHECK (char_length("applicant_comment") <= 500);

ALTER TABLE "verification_documents" ADD CONSTRAINT "verification_documents_side_ck" CHECK ("side" IN ('front', 'back'));
-- docs/01_FOUNDATION_AUTH.md §10.6 / docs/02_DATABASE.md §6.4 (p12 leaf 1.1):
-- SessionService.isNewDevice() runs, on every login,
--   SELECT id FROM sessions WHERE user_id = $1 AND device_id = $2 LIMIT 1
-- Without this index that is a FULL SCAN of sessions: the only user_id
-- index is the partial "revoked_at IS NULL" one (stage 2.6), which cannot
-- answer a lookup that must also see revoked rows. user_id is a random
-- UUID, so this plain index has no write hot-spot (§1.1).
-- CreateIndex
CREATE INDEX "sessions_user_id_device_id_idx" ON "sessions"("user_id", "device_id");
-- docs/04_CASES_BIDS.md §14 (stage 4.1): the only schema change of file 04.
-- Generated by `prisma migrate diff` against the dev DB; raw SQL appended
-- below.

-- AlterEnum
ALTER TYPE "notification_type" ADD VALUE 'case_updated';

-- AlterTable
ALTER TABLE "case_journal" ADD COLUMN     "attorney_id" UUID;

-- CreateIndex
CREATE INDEX "case_journal_attorney_id_created_at_idx" ON "case_journal"("attorney_id", "created_at");

-- AddForeignKey
ALTER TABLE "case_journal" ADD CONSTRAINT "case_journal_attorney_id_fkey" FOREIGN KEY ("attorney_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- Job indexes from the file-03 DB review, folded into this migration so
-- file 04 keeps a single migration:
-- CreateIndex (nightly license-expiry job)
CREATE INDEX "attorney_licenses_license_status_expires_at_idx" ON "attorney_licenses"("license_status", "expires_at");

-- CreateIndex (review-reminder job: closed cases by closed_at)
CREATE INDEX "cases_status_closed_at_idx" ON "cases"("status", "closed_at");

-- CreateIndex (reports per target / per reporter)
CREATE INDEX "reports_target_type_target_id_status_idx" ON "reports"("target_type", "target_id", "status");

-- CreateIndex
CREATE INDEX "reports_reporter_id_idx" ON "reports"("reporter_id");

-- ---------------------------------------------------------------------
-- Raw SQL (not expressible in schema.prisma)
-- ---------------------------------------------------------------------

-- §14: app_config key read by the contact-issue flow (§8.4, stage 4.5).
-- ON CONFLICT DO NOTHING: a value changed in the admin panel is kept.
INSERT INTO "app_config" ("key", "value", "updated_at")
VALUES ('contacts.suspend_after_confirmed_reports', '3'::JSONB, now())
ON CONFLICT ("key") DO NOTHING;
-- docs/04 file-04 load review (5k RPS / millions of cases target): indexes
-- for queries added by stages 4.6–4.10. Performance only; no data change.
-- Recorded in docs/OPEN_QUESTIONS.md OQ-011 item 5.

-- §10.2 stale prompt: open cases never prompted, by inactivity. The
-- stage 2.6 cases_open_activity_idx also covers already-prompted rows,
-- which the hourly job would otherwise walk every run.
CREATE INDEX "cases_open_unprompted_idx" ON "cases" ("last_activity_at", "id")
  WHERE "status" = 'open' AND "stale_prompt_sent_at" IS NULL AND "deleted_at" IS NULL;

-- §10.2 auto-archive: prompted open cases, by prompt time.
CREATE INDEX "cases_open_prompted_idx" ON "cases" ("stale_prompt_sent_at", "id")
  WHERE "status" = 'open' AND "stale_prompt_sent_at" IS NOT NULL AND "deleted_at" IS NULL;

-- §11.2 "Мои биды" (finished = several statuses): newest activity first
-- across statuses; bids(attorney_id, status, updated_at) can't serve the
-- sort for an IN list.
CREATE INDEX "bids_attorney_updated_idx" ON "bids" ("attorney_id", "updated_at" DESC, "id" DESC);
-- docs/05_FEED_SEARCH_CHAT_NOTIFICATIONS.md §14 (stage 5.1): video posts are
-- prepared now and enabled later by the `video_posts` flag (§3.6).
-- Separate migration: CockroachDB can't use a new enum value in the same
-- transaction that adds it.
ALTER TYPE "file_purpose" ADD VALUE 'post_video';
-- docs/05_FEED_SEARCH_CHAT_NOTIFICATIONS.md §14 (stage 5.1) — the only schema
-- migration of file 05.

-- §3.3: "Изменено" mark after a text edit.
ALTER TABLE "posts" ADD COLUMN "edited_at" TIMESTAMPTZ;

-- §9.4: aggregation (post_like, comment_like, new_follower): one row per
-- recipient and object per 1-hour window.
ALTER TABLE "notifications" ADD COLUMN "dedupe_key" TEXT;

ALTER TABLE "notifications" ADD COLUMN "aggregate_count" INTEGER NOT NULL DEFAULT 1;

CREATE UNIQUE INDEX "notifications_user_dedupe_uq" ON "notifications" ("user_id", "dedupe_key")
  WHERE "dedupe_key" IS NOT NULL;

-- §13 / §14: app_config tunables. ON CONFLICT DO NOTHING keeps values
-- changed in the admin panel.
INSERT INTO "app_config" ("key", "value", "updated_at") VALUES
  ('rate_limit.post_create_per_day', '10'::JSONB, now()),
  ('rate_limit.comment_per_hour', '30'::JSONB, now()),
  ('rate_limit.like_per_hour', '300'::JSONB, now()),
  ('rate_limit.follow_per_day', '200'::JSONB, now()),
  ('rate_limit.message_per_minute', '60'::JSONB, now()),
  ('rate_limit.search_per_minute', '30'::JSONB, now()),
  ('rate_limit.report_per_day', '20'::JSONB, now()),
  ('notifications.retention_days', '180'::JSONB, now())
ON CONFLICT ("key") DO NOTHING;
-- docs/05 end-of-file load review (see docs/OPEN_QUESTIONS.md OQ-012):
-- indexes only, no table or column changes.

-- §10 badge: unread notifications per user without scanning read history.
CREATE INDEX IF NOT EXISTS "notifications_user_unread_idx"
  ON "notifications" ("user_id", "created_at" DESC)
  WHERE "read_at" IS NULL;

-- Stage 5.8 retention job: rows older than retention_days, oldest first.
CREATE INDEX IF NOT EXISTS "notifications_created_at_idx"
  ON "notifications" ("created_at");
-- 2026-09-28: prepared for profile-started chats; the owner then kept
-- chats case-only (docs/04 §9, OQ-014), so nothing writes NULL today.
-- Applied to dev DBs already; kept as-is (harmless, avoids a checksum
-- mismatch).
ALTER TABLE "conversations" ALTER COLUMN "case_id" DROP NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS "conversations_direct_uq"
  ON "conversations" ("attorney_id", "client_id")
  WHERE "case_id" IS NULL;

-- Reviews filtered by stars (owner request): (attorney, rating, newest).
CREATE INDEX IF NOT EXISTS "reviews_attorney_rating_created_idx"
  ON "reviews" ("attorney_id", "rating", "created_at" DESC)
  WHERE "status" = 'published';
-- docs/06_PRODUCTION.md §10 (stage 6.1): the only schema changes file 06 allows.
CREATE TYPE "data_export_type" AS ENUM ('user_data', 'case_history_pdf');

CREATE TYPE "data_export_status" AS ENUM ('queued', 'processing', 'ready', 'failed', 'expired');

CREATE TABLE "admin_credentials" (
  "user_id" UUID NOT NULL,
  "totp_secret_enc" TEXT NOT NULL,
  "totp_enabled_at" TIMESTAMPTZ,
  "recovery_codes_hash" TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  "last_login_at" TIMESTAMPTZ,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ NOT NULL,
  CONSTRAINT "admin_credentials_pkey" PRIMARY KEY ("user_id"),
  CONSTRAINT "admin_credentials_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "data_export_jobs" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "user_id" UUID NOT NULL,
  "type" "data_export_type" NOT NULL,
  "status" "data_export_status" NOT NULL DEFAULT 'queued',
  "file_id" UUID,
  "expires_at" TIMESTAMPTZ,
  "error" TEXT,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ NOT NULL,
  CONSTRAINT "data_export_jobs_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "data_export_jobs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "data_export_jobs_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "files"("id") ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE INDEX "data_export_jobs_user_id_created_at_idx" ON "data_export_jobs"("user_id", "created_at" DESC);

CREATE INDEX "data_export_jobs_status_expires_at_idx" ON "data_export_jobs"("status", "expires_at");

ALTER TABLE "subscriptions" ADD COLUMN "grace_ends_at" TIMESTAMPTZ;

ALTER TABLE "audit_log" ADD COLUMN "justification" TEXT;
-- docs/06_PRODUCTION.md §5 (stage 6.9): user data export ZIP files and the
-- "your export is ready" notification.
ALTER TYPE "file_purpose" ADD VALUE 'data_export';

ALTER TYPE "notification_type" ADD VALUE 'data_export_ready';
-- docs/06 stage 6.12 (load review): indexes behind the file-06 background
-- jobs — ops counters, anonymization scan and message scrub, the daily
-- journal chain check, the hourly bid-lapse job.
CREATE INDEX "users_created_at_idx" ON "users"("created_at");

CREATE INDEX "users_status_deletion_requested_at_idx" ON "users"("status", "deletion_requested_at");

CREATE INDEX "messages_sender_id_idx" ON "messages"("sender_id");

CREATE INDEX "case_journal_created_at_idx" ON "case_journal"("created_at");

CREATE INDEX "bids_status_idx" ON "bids"("status");
-- docs/04 §12 (file 06 wrap-up): notification for the ready case-history PDF.
ALTER TYPE "notification_type" ADD VALUE 'case_history_export_ready';
-- Owner decision 2026-09-29 (docs/OPEN_QUESTIONS.md OQ-026): clients are
-- searchable by @username and name, so client_profiles carry a username
-- with the attorney rules. Nullable: existing clients receive one lazily
-- (UsernameRegistry.allocate) the first time their profile is read.
ALTER TABLE "client_profiles" ADD COLUMN "username" TEXT;

ALTER TABLE "client_profiles" ADD COLUMN "username_lower" TEXT;

ALTER TABLE "client_profiles" ADD COLUMN "username_changed_at" TIMESTAMPTZ;

CREATE UNIQUE INDEX "client_profiles_username_lower_key" ON "client_profiles"("username_lower");
-- Owner decision 2026-09-29 (docs/OPEN_QUESTIONS.md OQ-028): a block
-- system for every user. One row per (blocker, blocked).
CREATE TABLE "user_blocks" (
  "blocker_id" UUID NOT NULL REFERENCES "users"("id") ON DELETE CASCADE,
  "blocked_id" UUID NOT NULL REFERENCES "users"("id") ON DELETE CASCADE,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT "user_blocks_pkey" PRIMARY KEY ("blocker_id", "blocked_id")
);

CREATE INDEX "user_blocks_blocked_id_idx" ON "user_blocks"("blocked_id");
-- Owner decision 2026-09-30 (OQ-030): an attorney lists several firms.
-- firm_name stays as the first entry (older clients, admin, exports).
ALTER TABLE "attorney_profiles" ADD COLUMN "firm_names" TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[];

UPDATE "attorney_profiles" SET "firm_names" = ARRAY["firm_name"] WHERE "firm_name" IS NOT NULL AND "firm_name" <> '';
-- Owner decision 2026-09-30 (OQ-029): name changes never block an
-- attorney; the blue check hides itself when the name drifts far from the
-- verified one. Snapshot the current names of verified attorneys.
ALTER TABLE "attorney_profiles" ADD COLUMN "verified_first_name" TEXT;

ALTER TABLE "attorney_profiles" ADD COLUMN "verified_last_name" TEXT;

ALTER TABLE "attorney_profiles" ADD COLUMN "name_mismatch" BOOL NOT NULL DEFAULT false;

UPDATE "attorney_profiles" AS a
   SET "verified_first_name" = u."first_name",
       "verified_last_name"  = u."last_name"
  FROM "users" AS u
 WHERE u."id" = a."user_id" AND a."verification_status" = 'verified';
-- Owner decision 2026-09-30 (OQ-031): case photos (0-9), private.
ALTER TYPE "file_purpose" ADD VALUE 'case_photo';

CREATE TABLE "case_photos" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "case_id" UUID NOT NULL REFERENCES "cases"("id") ON DELETE CASCADE,
  "file_id" UUID NOT NULL REFERENCES "files"("id") ON DELETE RESTRICT,
  "position" SMALLINT NOT NULL,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT "case_photos_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "case_photos_case_id_position_key" ON "case_photos"("case_id", "position");

CREATE INDEX "case_photos_file_id_idx" ON "case_photos"("file_id");
-- Owner decision 2026-09-30 (OQ-029 final): name changes never hide the
-- blue check any more; clear flags set by the short-lived automatic rule.
UPDATE "attorney_profiles" SET "name_mismatch" = false WHERE "name_mismatch" = true;
-- Owner decision 2026-09-30 (OQ-034): comments under cases (like post
-- comments), case documents, new report/notification kinds.
ALTER TYPE "file_purpose" ADD VALUE 'case_attachment';

ALTER TYPE "report_target_type" ADD VALUE 'case_comment';

ALTER TYPE "notification_type" ADD VALUE 'case_comment';

ALTER TABLE "cases" ADD COLUMN "comment_count" INTEGER NOT NULL DEFAULT 0;

CREATE TABLE "case_comments" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "case_id" UUID NOT NULL REFERENCES "cases"("id") ON DELETE RESTRICT,
  "author_id" UUID NOT NULL REFERENCES "users"("id") ON DELETE RESTRICT,
  "parent_comment_id" UUID REFERENCES "case_comments"("id") ON DELETE RESTRICT,
  "body" TEXT NOT NULL,
  "status" "content_status" NOT NULL DEFAULT 'published',
  "like_count" INTEGER NOT NULL DEFAULT 0,
  "reply_count" INTEGER NOT NULL DEFAULT 0,
  "deleted_at" TIMESTAMPTZ,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ NOT NULL,
  CONSTRAINT "case_comments_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "case_comments_body_len" CHECK (char_length("body") BETWEEN 1 AND 1000)
);

CREATE INDEX "case_comments_case_id_created_at_idx" ON "case_comments"("case_id", "created_at");

CREATE INDEX "case_comments_parent_comment_id_created_at_idx" ON "case_comments"("parent_comment_id", "created_at");

CREATE TABLE "case_comment_likes" (
  "comment_id" UUID NOT NULL REFERENCES "case_comments"("id") ON DELETE CASCADE,
  "user_id" UUID NOT NULL REFERENCES "users"("id") ON DELETE CASCADE,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT "case_comment_likes_pkey" PRIMARY KEY ("comment_id", "user_id")
);
-- Owner decision 2026-09-30 (OQ-037): share counters on posts and cases.
ALTER TABLE "posts" ADD COLUMN "share_count" INTEGER NOT NULL DEFAULT 0;

ALTER TABLE "cases" ADD COLUMN "share_count" INTEGER NOT NULL DEFAULT 0;

CREATE TABLE "post_shares" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "post_id" UUID NOT NULL REFERENCES "posts"("id") ON DELETE CASCADE,
  "user_id" UUID NOT NULL REFERENCES "users"("id") ON DELETE CASCADE,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT "post_shares_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "post_shares_post_id_idx" ON "post_shares"("post_id");

CREATE TABLE "case_shares" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "case_id" UUID NOT NULL REFERENCES "cases"("id") ON DELETE CASCADE,
  "user_id" UUID NOT NULL REFERENCES "users"("id") ON DELETE CASCADE,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT "case_shares_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "case_shares_case_id_idx" ON "case_shares"("case_id");
-- Owner decision 2026-09-30 (OQ-038): client profile like Instagram —
-- posts, followers, following counters; attorneys' reviews of clients.
ALTER TABLE "client_profiles"
  ADD COLUMN "posts_count" INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN "followers_count" INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN "following_count" INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN "rating_avg" DECIMAL(3,2) NOT NULL DEFAULT 0,
  ADD COLUMN "rating_count" INTEGER NOT NULL DEFAULT 0;

-- Clients already follow attorneys: backfill their following counter.
UPDATE "client_profiles" AS c SET "following_count" =
  (SELECT count(*) FROM "follows" f WHERE f."follower_id" = c."user_id");

CREATE TABLE "client_reviews" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "case_id" UUID NOT NULL REFERENCES "cases"("id") ON DELETE RESTRICT,
  "attorney_id" UUID NOT NULL REFERENCES "users"("id") ON DELETE RESTRICT,
  "client_id" UUID NOT NULL REFERENCES "users"("id") ON DELETE RESTRICT,
  "rating" SMALLINT NOT NULL,
  "body" TEXT,
  "status" "review_status" NOT NULL DEFAULT 'published',
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ NOT NULL,
  CONSTRAINT "client_reviews_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "client_reviews_rating" CHECK ("rating" BETWEEN 1 AND 5),
  CONSTRAINT "client_reviews_body_len" CHECK ("body" IS NULL OR char_length("body") <= 2000)
);

CREATE UNIQUE INDEX "client_reviews_case_id_attorney_id_key" ON "client_reviews"("case_id", "attorney_id");

CREATE INDEX "client_reviews_client_id_created_at_idx" ON "client_reviews"("client_id", "created_at" DESC);
-- Owner 2026-09-30 (OQ-040): voice messages in chats, like Telegram.
ALTER TYPE "file_purpose" ADD VALUE 'chat_voice';

ALTER TYPE "message_type" ADD VALUE 'voice';

ALTER TABLE "messages" ADD COLUMN "file_id" UUID REFERENCES "files"("id") ON DELETE RESTRICT;

ALTER TABLE "messages" ADD COLUMN "duration_ms" INTEGER;

ALTER TABLE "messages" ADD COLUMN "waveform" INTEGER[] NOT NULL DEFAULT ARRAY[]::INTEGER[];

ALTER TABLE "messages" ADD COLUMN "listened_at" TIMESTAMPTZ;

CREATE INDEX "messages_file_id_idx" ON "messages"("file_id");
-- Owner 2026-09-30 (OQ-041): audio calls inside the app (WebRTC), no video.
CREATE TYPE "call_status" AS ENUM ('ringing', 'active', 'ended', 'missed', 'declined', 'busy', 'canceled', 'failed');

ALTER TYPE "message_type" ADD VALUE 'call';

ALTER TYPE "notification_type" ADD VALUE 'missed_call';

CREATE TABLE "calls" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "conversation_id" UUID NOT NULL REFERENCES "conversations"("id") ON DELETE RESTRICT,
  "caller_id" UUID NOT NULL REFERENCES "users"("id") ON DELETE RESTRICT,
  "callee_id" UUID NOT NULL REFERENCES "users"("id") ON DELETE RESTRICT,
  "status" "call_status" NOT NULL DEFAULT 'ringing',
  "answered_at" TIMESTAMPTZ,
  "ended_at" TIMESTAMPTZ,
  "duration_sec" INTEGER,
  "end_reason" TEXT,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ NOT NULL,
  CONSTRAINT "calls_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "calls_callee_id_status_idx" ON "calls"("callee_id", "status");

CREATE INDEX "calls_caller_id_status_idx" ON "calls"("caller_id", "status");

CREATE INDEX "calls_conversation_id_created_at_idx" ON "calls"("conversation_id", "created_at");

CREATE INDEX "calls_status_created_at_idx" ON "calls"("status", "created_at");
-- Owner 2026-09-30 (OQ-042): @username mentions in posts and comments.
ALTER TYPE "notification_type" ADD VALUE 'mention';
-- Owner 2026-09-30 (OQ-043): direct chats from a profile ("Message") and
-- message requests like Instagram.
CREATE TYPE "message_request_status" AS ENUM ('none', 'pending', 'accepted', 'declined');

ALTER TABLE "conversations" ADD COLUMN "request_status" "message_request_status" NOT NULL DEFAULT 'none';

ALTER TABLE "conversations" ADD COLUMN "requested_by" UUID REFERENCES "users"("id") ON DELETE RESTRICT;

-- One direct chat per attorney/client pair.
CREATE UNIQUE INDEX "conversations_direct_pair_key" ON "conversations"("attorney_id", "client_id") WHERE "case_id" IS NULL;
-- Owner 2026-09-30 (OQ-043): an accepted message request is a full chat
-- (contacts open, calls allowed) — also for requests accepted earlier.
UPDATE "conversations" SET "contacts_unlocked" = true
  WHERE "case_id" IS NULL AND "request_status" = 'accepted' AND "contacts_unlocked" = false;
-- Owner 2026-09-30: calls get their own notification category (incoming
-- call ring push + missed calls), separate from messages.
ALTER TYPE "notification_category" ADD VALUE 'calls';
-- Owner 2026-09-30: a post has a title, a qualification (practice
-- category or subcategory) and a kind — a regular post or News (attorneys
-- only). Older posts keep NULL title/practice and are kind 'post'.
CREATE TYPE "post_kind" AS ENUM ('post', 'news');

ALTER TABLE "posts" ADD COLUMN "title" TEXT NULL;

ALTER TABLE "posts" ADD COLUMN "practice_area_id" UUID NULL;

ALTER TABLE "posts" ADD COLUMN "kind" "post_kind" NOT NULL DEFAULT 'post';

ALTER TABLE "posts" ADD CONSTRAINT "posts_title_len" CHECK ("title" IS NULL OR char_length("title") BETWEEN 1 AND 120);

ALTER TABLE "posts" ADD CONSTRAINT "posts_practice_area_id_fkey" FOREIGN KEY ("practice_area_id") REFERENCES "practice_areas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

CREATE INDEX "posts_practice_area_id_created_at_idx" ON "posts"("practice_area_id", "created_at" DESC);

CREATE INDEX "posts_kind_created_at_idx" ON "posts"("kind", "created_at" DESC);
-- Owner 2026-09-30: attorneys may bid on cases outside their own
-- practices; such a bid is marked so the client is warned.
ALTER TABLE "bids" ADD COLUMN "outside_practice" BOOL NOT NULL DEFAULT false;
-- Owner 2026-09-30: opt-in alerts — new posts / news of people I follow,
-- and (attorneys) new cases in my practices and licensed states. Both
-- categories are off until the user turns them on.
ALTER TYPE "notification_category" ADD VALUE 'following';

ALTER TYPE "notification_category" ADD VALUE 'new_cases';

ALTER TYPE "notification_type" ADD VALUE 'followed_post';

ALTER TYPE "notification_type" ADD VALUE 'new_case';
-- Owner 2026-09-30: anyone (attorney or client) may review a client to
-- warn others, without a shared case; one review per author per client
-- (service-enforced). The author deletes it at any time; the reviewed
-- client may appeal — admins accept (remove) or reject (keep), in bulk;
-- an appeal nobody decided in 30 days removes the review by itself.
ALTER TABLE "client_reviews" ALTER COLUMN "case_id" DROP NOT NULL;

CREATE TYPE "review_appeal_status" AS ENUM ('pending', 'accepted', 'rejected', 'auto_removed');

CREATE TABLE "client_review_appeals" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "review_id" UUID NOT NULL,
  "appellant_id" UUID NOT NULL,
  "reason" TEXT NOT NULL,
  "status" "review_appeal_status" NOT NULL DEFAULT 'pending',
  "auto_remove_at" TIMESTAMPTZ NOT NULL,
  "decided_at" TIMESTAMPTZ NULL,
  "decided_by" UUID NULL,
  "admin_note" TEXT NULL,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT "client_review_appeals_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "client_review_appeals_reason_len" CHECK (char_length("reason") BETWEEN 1 AND 1000)
);

CREATE UNIQUE INDEX "client_review_appeals_review_id_key" ON "client_review_appeals"("review_id");

CREATE INDEX "client_review_appeals_status_created_at_idx" ON "client_review_appeals"("status", "created_at");

CREATE INDEX "client_review_appeals_status_auto_remove_at_idx" ON "client_review_appeals"("status", "auto_remove_at");

ALTER TABLE "client_review_appeals" ADD CONSTRAINT "client_review_appeals_review_id_fkey" FOREIGN KEY ("review_id") REFERENCES "client_reviews"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "client_review_appeals" ADD CONSTRAINT "client_review_appeals_appellant_id_fkey" FOREIGN KEY ("appellant_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

CREATE INDEX "client_reviews_client_id_attorney_id_idx" ON "client_reviews"("client_id", "attorney_id");
-- Owner 2026-09-30 (OQ-047): photos and documents in chats once the bid
-- is accepted (contacts unlocked) — any number, every common format.
ALTER TYPE "file_purpose" ADD VALUE 'chat_attachment';

ALTER TYPE "message_type" ADD VALUE 'attachment';

-- The original file name shown on the document card (≤200 chars).
ALTER TABLE "messages" ADD COLUMN "file_name" TEXT NULL;

ALTER TABLE "messages" ADD CONSTRAINT "messages_file_name_len" CHECK ("file_name" IS NULL OR char_length("file_name") BETWEEN 1 AND 200);
-- Owner 2026-09-30 (OQ-048): plans and attorney assistants.
-- Monthly: $399 + $100 per assistant seat (0–6); yearly: attorney + 6
-- assistants, 20 % off ($9,590). An assistant has no subscription or
-- profile of their own: they work inside the attorney's account under
-- their own login, every action is logged, publications wait for the
-- attorney's approval, and they never bid.
CREATE TYPE "subscription_plan" AS ENUM ('monthly', 'yearly');

ALTER TABLE "subscriptions" ADD COLUMN "plan" "subscription_plan" NOT NULL DEFAULT 'monthly';

ALTER TABLE "subscriptions" ADD COLUMN "assistant_seats" SMALLINT NOT NULL DEFAULT 0;

ALTER TABLE "subscriptions" ADD CONSTRAINT "subscriptions_assistant_seats_range" CHECK ("assistant_seats" BETWEEN 0 AND 6);

ALTER TYPE "user_role" ADD VALUE 'assistant';

CREATE TYPE "assistant_status" AS ENUM ('invited', 'active', 'removed');

CREATE TYPE "assistant_approval" AS ENUM ('purchase', 'attorney_added', 'attorney_otp');

CREATE TABLE "assistant_memberships" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "attorney_id" UUID NOT NULL,
  "assistant_user_id" UUID NULL,
  "phone_e164" TEXT NOT NULL,
  "display_name" TEXT NULL,
  "status" "assistant_status" NOT NULL DEFAULT 'invited',
  "approval" "assistant_approval" NOT NULL,
  -- calls · chats · files · cases · bid_drafts · posts · tasks · profile
  "duties" TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "joined_at" TIMESTAMPTZ NULL,
  "removed_at" TIMESTAMPTZ NULL,
  CONSTRAINT "assistant_memberships_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "assistant_memberships_name_len" CHECK ("display_name" IS NULL OR char_length("display_name") <= 80)
);

CREATE INDEX "assistant_memberships_attorney_id_status_idx" ON "assistant_memberships"("attorney_id", "status");

CREATE INDEX "assistant_memberships_phone_e164_status_idx" ON "assistant_memberships"("phone_e164", "status");

CREATE INDEX "assistant_memberships_assistant_user_id_idx" ON "assistant_memberships"("assistant_user_id");

-- One live membership per phone (an assistant works for one attorney).
CREATE UNIQUE INDEX "assistant_memberships_live_phone_key" ON "assistant_memberships"("phone_e164") WHERE "status" != 'removed';

ALTER TABLE "assistant_memberships" ADD CONSTRAINT "assistant_memberships_attorney_id_fkey" FOREIGN KEY ("attorney_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "assistant_memberships" ADD CONSTRAINT "assistant_memberships_assistant_user_id_fkey" FOREIGN KEY ("assistant_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- Every action of an assistant (the attorney's "Team" feed).
CREATE TABLE "assistant_activity" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "attorney_id" UUID NOT NULL,
  "membership_id" UUID NOT NULL,
  "action" TEXT NOT NULL,
  "target_type" TEXT NULL,
  "target_id" TEXT NULL,
  "summary" TEXT NULL,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT "assistant_activity_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "assistant_activity_attorney_id_created_at_idx" ON "assistant_activity"("attorney_id", "created_at" DESC);

CREATE INDEX "assistant_activity_membership_id_created_at_idx" ON "assistant_activity"("membership_id", "created_at" DESC);

ALTER TABLE "assistant_activity" ADD CONSTRAINT "assistant_activity_membership_id_fkey" FOREIGN KEY ("membership_id") REFERENCES "assistant_memberships"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Publications and profile edits waiting for the attorney's approval.
CREATE TYPE "assistant_request_kind" AS ENUM ('post', 'comment', 'case_comment', 'profile_edit');

CREATE TYPE "assistant_request_status" AS ENUM ('pending', 'approved', 'rejected');

CREATE TABLE "assistant_requests" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "attorney_id" UUID NOT NULL,
  "membership_id" UUID NOT NULL,
  "kind" "assistant_request_kind" NOT NULL,
  "payload" JSONB NOT NULL,
  "status" "assistant_request_status" NOT NULL DEFAULT 'pending',
  "result_id" TEXT NULL,
  "note" TEXT NULL,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "decided_at" TIMESTAMPTZ NULL,
  CONSTRAINT "assistant_requests_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "assistant_requests_attorney_id_status_created_at_idx" ON "assistant_requests"("attorney_id", "status", "created_at" DESC);

ALTER TABLE "assistant_requests" ADD CONSTRAINT "assistant_requests_membership_id_fkey" FOREIGN KEY ("membership_id") REFERENCES "assistant_memberships"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Tasks assistants set for the attorney (Mine → Tasks).
CREATE TYPE "attorney_task_kind" AS ENUM ('call', 'meeting', 'court', 'deadline', 'documents', 'print', 'visit', 'other');

CREATE TYPE "attorney_task_status" AS ENUM ('open', 'taken', 'done', 'not_done', 'cancelled');

CREATE TABLE "attorney_tasks" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "attorney_id" UUID NOT NULL,
  "created_by_membership_id" UUID NULL,
  "kind" "attorney_task_kind" NOT NULL,
  "title" TEXT NOT NULL,
  "notes" TEXT NULL,
  "due_at" TIMESTAMPTZ NULL,
  "location" TEXT NULL,
  "case_id" UUID NULL,
  "contact_name" TEXT NULL,
  "contact_phone" TEXT NULL,
  "file_ids" UUID[] NOT NULL DEFAULT ARRAY[]::UUID[],
  "status" "attorney_task_status" NOT NULL DEFAULT 'open',
  "outcome_note" TEXT NULL,
  "rescheduled_to" TIMESTAMPTZ NULL,
  "done_at" TIMESTAMPTZ NULL,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT "attorney_tasks_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "attorney_tasks_title_len" CHECK (char_length("title") BETWEEN 1 AND 160),
  CONSTRAINT "attorney_tasks_notes_len" CHECK ("notes" IS NULL OR char_length("notes") <= 2000)
);

CREATE INDEX "attorney_tasks_attorney_id_status_due_at_idx" ON "attorney_tasks"("attorney_id", "status", "due_at");

ALTER TABLE "attorney_tasks" ADD CONSTRAINT "attorney_tasks_attorney_id_fkey" FOREIGN KEY ("attorney_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "attorney_tasks" ADD CONSTRAINT "attorney_tasks_membership_fkey" FOREIGN KEY ("created_by_membership_id") REFERENCES "assistant_memberships"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "attorney_tasks" ADD CONSTRAINT "attorney_tasks_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- Who in the team actually sent a chat message (shown to the client as
-- "Assistant of <attorney>").
ALTER TABLE "messages" ADD COLUMN "sent_by_membership_id" UUID NULL;

ALTER TYPE "file_purpose" ADD VALUE 'task_attachment';

ALTER TYPE "notification_type" ADD VALUE 'assistant_request';

ALTER TYPE "notification_type" ADD VALUE 'assistant_task';

ALTER TYPE "notification_type" ADD VALUE 'assistant_joined';
-- OQ-048: the assistant hears back when the attorney answers a request or
-- finishes / moves a task they set.
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'assistant_result';
-- OQ-048: "Assistant of <attorney>" label — the assistant's name at send time.
ALTER TABLE messages ADD COLUMN IF NOT EXISTS sent_by_name VARCHAR(80);
-- OQ-048: bid drafts an assistant prepares; only the attorney sends a bid.
CREATE TABLE IF NOT EXISTS bid_drafts (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  attorney_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  case_id UUID NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
  payload JSONB NOT NULL,
  prepared_by_name VARCHAR(80),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT bid_drafts_attorney_case_key UNIQUE (attorney_id, case_id)
);
-- Owner 2026-09-30: admin broadcasts (push + in-app) to an audience.
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'admin_broadcast';

CREATE TABLE IF NOT EXISTS admin_broadcasts (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  admin_id UUID NOT NULL,
  title VARCHAR(120) NOT NULL,
  body VARCHAR(1000) NOT NULL,
  audience VARCHAR(20) NOT NULL,
  state_code VARCHAR(2),
  recipients BIGINT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- OQ-049: an attorney lets assistants bid / negotiate and publish without
-- approval only after accepting full responsibility. Append-only record of
-- each acceptance (and each withdrawal) — evidence of who agreed to what.
CREATE TABLE IF NOT EXISTS assistant_liability_acceptances (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  attorney_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  membership_id UUID NOT NULL REFERENCES assistant_memberships(id) ON DELETE CASCADE,
  duties TEXT[] NOT NULL,
  granted BOOL NOT NULL,
  terms_version VARCHAR(20) NOT NULL,
  ip VARCHAR(64),
  user_agent VARCHAR(300),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX assistant_liability_by_attorney ON assistant_liability_acceptances (attorney_id, created_at DESC);
-- Owner 2026-10-01: every kind of attorney work in the planner.
ALTER TYPE attorney_task_kind ADD VALUE IF NOT EXISTS 'consultation';

ALTER TYPE attorney_task_kind ADD VALUE IF NOT EXISTS 'hearing_prep';

ALTER TYPE attorney_task_kind ADD VALUE IF NOT EXISTS 'deposition';

ALTER TYPE attorney_task_kind ADD VALUE IF NOT EXISTS 'mediation';

ALTER TYPE attorney_task_kind ADD VALUE IF NOT EXISTS 'filing';

ALTER TYPE attorney_task_kind ADD VALUE IF NOT EXISTS 'review';

ALTER TYPE attorney_task_kind ADD VALUE IF NOT EXISTS 'email';

ALTER TYPE attorney_task_kind ADD VALUE IF NOT EXISTS 'sign';

ALTER TYPE attorney_task_kind ADD VALUE IF NOT EXISTS 'payment';

ALTER TYPE attorney_task_kind ADD VALUE IF NOT EXISTS 'research';

ALTER TYPE attorney_task_kind ADD VALUE IF NOT EXISTS 'jail_visit';
-- Owner 2026-10-01: email tasks need the address to write to.
ALTER TABLE attorney_tasks ADD COLUMN IF NOT EXISTS contact_email VARCHAR(254);
-- Owner 2026-10-01: one task card holds any number of steps (5 calls,
-- 6 meetings, several addresses…), each with its own time and checkmark.
CREATE TABLE IF NOT EXISTS attorney_task_steps (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  task_id UUID NOT NULL,
  position INTEGER NOT NULL DEFAULT 0,
  kind attorney_task_kind NULL,
  title VARCHAR(160) NOT NULL,
  due_at TIMESTAMPTZ NULL,
  location VARCHAR(200) NULL,
  contact_name VARCHAR(120) NULL,
  contact_phone VARCHAR(20) NULL,
  contact_email VARCHAR(254) NULL,
  status attorney_task_status NOT NULL DEFAULT 'open',
  note VARCHAR(1000) NULL,
  done_at TIMESTAMPTZ NULL,
  created_by_name VARCHAR(120) NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT attorney_task_steps_pkey PRIMARY KEY (id),
  CONSTRAINT attorney_task_steps_task_fkey FOREIGN KEY (task_id) REFERENCES attorney_tasks(id) ON DELETE CASCADE
);
CREATE INDEX attorney_task_steps_task_idx ON attorney_task_steps (task_id, position);
-- Owner 2026-10-01: an admin changed the account's phone on request.
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'security_phone_changed';
-- Owner 2026-10-01: an attorney picks which qualifications send "new
-- case" alerts. false = the profile's qualifications (the default).
ALTER TABLE attorney_profiles ADD COLUMN IF NOT EXISTS new_case_alerts_custom BOOL NOT NULL DEFAULT false;

CREATE TABLE IF NOT EXISTS new_case_alert_practices (
  attorney_id UUID NOT NULL,
  practice_area_id UUID NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT new_case_alert_practices_pkey PRIMARY KEY (attorney_id, practice_area_id),
  CONSTRAINT new_case_alert_practices_attorney_fkey FOREIGN KEY (attorney_id) REFERENCES attorney_profiles(user_id) ON DELETE CASCADE,
  CONSTRAINT new_case_alert_practices_area_fkey FOREIGN KEY (practice_area_id) REFERENCES practice_areas(id) ON DELETE CASCADE
);
CREATE INDEX new_case_alert_practices_area_idx ON new_case_alert_practices (practice_area_id, attorney_id);
-- Owner 2026-10-01: Instagram-like chat folders for each member — Primary
-- / General (NULL = automatic: case chats are Primary), "waiting for my
-- answer" with a note pinned on the chat ("send him the documents"), and
-- chats pinned to the top.
CREATE TYPE chat_folder AS ENUM ('primary', 'general');

ALTER TABLE conversation_participants ADD COLUMN IF NOT EXISTS folder chat_folder NULL;

ALTER TABLE conversation_participants ADD COLUMN IF NOT EXISTS waiting_since TIMESTAMPTZ NULL;

ALTER TABLE conversation_participants ADD COLUMN IF NOT EXISTS note VARCHAR(280) NULL;

ALTER TABLE conversation_participants ADD COLUMN IF NOT EXISTS pinned_at TIMESTAMPTZ NULL;

CREATE INDEX IF NOT EXISTS conversation_participants_waiting_idx ON conversation_participants (user_id, waiting_since) WHERE waiting_since IS NOT NULL;
-- Owner 2026-10-01: anyone reviews anyone. An attorney review no longer
-- needs a case (case_id NULL = an open review, one per author); the case
-- ones stay "verified by a case". Open reviews can be appealed like client
-- reviews: an admin decides, undecided after 30 days -> removed.
ALTER TABLE reviews ALTER COLUMN case_id DROP NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS reviews_open_author_uq
  ON reviews (client_id, attorney_id)
  WHERE case_id IS NULL AND status <> 'removed';

CREATE TABLE IF NOT EXISTS review_appeals (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  review_id UUID NOT NULL,
  appellant_id UUID NOT NULL,
  reason TEXT NOT NULL,
  status review_appeal_status NOT NULL DEFAULT 'pending',
  auto_remove_at TIMESTAMPTZ NOT NULL,
  decided_at TIMESTAMPTZ NULL,
  decided_by UUID NULL,
  admin_note TEXT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT review_appeals_pkey PRIMARY KEY (id),
  CONSTRAINT review_appeals_review_fkey FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
  CONSTRAINT review_appeals_appellant_fkey FOREIGN KEY (appellant_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT review_appeals_reason_len CHECK (length(reason) BETWEEN 1 AND 1000)
);
CREATE UNIQUE INDEX review_appeals_review_key ON review_appeals (review_id);
CREATE INDEX review_appeals_status_created_idx ON review_appeals (status, created_at);
CREATE INDEX review_appeals_status_auto_idx ON review_appeals (status, auto_remove_at);
-- Owner 2026-10-01: reviews exactly like Google Maps — the author edits /
-- deletes any time; the reviewed person can't delete, they reply publicly;
-- anyone flags a review (policy categories) to moderation; "Helpful".
DROP TABLE IF EXISTS review_appeals;

ALTER TABLE reviews ADD COLUMN IF NOT EXISTS reply VARCHAR(1000) NULL;

ALTER TABLE reviews ADD COLUMN IF NOT EXISTS reply_at TIMESTAMPTZ NULL;

ALTER TABLE reviews ADD COLUMN IF NOT EXISTS helpful_count INTEGER NOT NULL DEFAULT 0;

ALTER TABLE client_reviews ADD COLUMN IF NOT EXISTS reply VARCHAR(1000) NULL;

ALTER TABLE client_reviews ADD COLUMN IF NOT EXISTS reply_at TIMESTAMPTZ NULL;

ALTER TABLE client_reviews ADD COLUMN IF NOT EXISTS helpful_count INTEGER NOT NULL DEFAULT 0;

ALTER TABLE client_reviews ADD COLUMN IF NOT EXISTS edited_at TIMESTAMPTZ NULL;

CREATE TABLE IF NOT EXISTS review_helpful_votes (
  review_id UUID NOT NULL,
  user_id UUID NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT review_helpful_votes_pkey PRIMARY KEY (review_id, user_id),
  CONSTRAINT review_helpful_votes_review_fkey FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
  CONSTRAINT review_helpful_votes_user_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS client_review_helpful_votes (
  review_id UUID NOT NULL,
  user_id UUID NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT client_review_helpful_votes_pkey PRIMARY KEY (review_id, user_id),
  CONSTRAINT client_review_helpful_votes_review_fkey FOREIGN KEY (review_id) REFERENCES client_reviews(id) ON DELETE CASCADE,
  CONSTRAINT client_review_helpful_votes_user_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
-- Owner 2026-10-01: client reviews in the moderation queue, and Google's
-- review policy categories as report reasons.
ALTER TYPE report_target_type ADD VALUE IF NOT EXISTS 'client_review';

ALTER TYPE report_reason ADD VALUE IF NOT EXISTS 'off_topic';

ALTER TYPE report_reason ADD VALUE IF NOT EXISTS 'conflict_of_interest';

ALTER TYPE report_reason ADD VALUE IF NOT EXISTS 'profanity';

ALTER TYPE report_reason ADD VALUE IF NOT EXISTS 'harassment';

ALTER TYPE report_reason ADD VALUE IF NOT EXISTS 'hate_speech';

ALTER TYPE report_reason ADD VALUE IF NOT EXISTS 'personal_info';
-- Owner 2026-10-01 (Google Maps-style reviews): photos in reviews.
ALTER TYPE file_purpose ADD VALUE IF NOT EXISTS 'review_photo';
-- Owner 2026-10-01: up to 10 photos per review (public media, like posts).
ALTER TABLE reviews ADD COLUMN IF NOT EXISTS photo_ids UUID[] NOT NULL DEFAULT '{}';

ALTER TABLE client_reviews ADD COLUMN IF NOT EXISTS photo_ids UUID[] NOT NULL DEFAULT '{}';
-- Owner 2026-10-01: "online / last seen" in chats, hideable like
-- Instagram's activity status (reciprocal). users.last_active_at becomes
-- the "last seen" time (set when the last app connection closes).
ALTER TABLE users ADD COLUMN show_activity_status BOOL NOT NULL DEFAULT true;
-- Owner 2026-10-01: third-party API keys the owner manages in the admin
-- (Bunny Stream, Stripe, Twilio, FCM, TURN…). One row per provider per
-- version; the secret fields are one AES-256-GCM envelope (master key from
-- env SECRETS_MASTER_KEYS, AAD "provider:version"). A new version waits as
-- `pending` until it is tested and activated; the previous one stays as
-- `retired` for a one-step rollback.
CREATE TYPE integration_credential_status AS ENUM ('pending', 'active', 'retired');

CREATE TABLE integration_credentials (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  provider TEXT NOT NULL,
  version INTEGER NOT NULL,
  status integration_credential_status NOT NULL DEFAULT 'pending',
  secret_enc TEXT NOT NULL,
  kid TEXT NOT NULL,
  public_config JSONB NOT NULL DEFAULT '{}'::JSONB,
  masked JSONB NOT NULL DEFAULT '{}'::JSONB,
  fingerprint TEXT NOT NULL,
  created_by UUID NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  activated_at TIMESTAMPTZ NULL,
  retired_at TIMESTAMPTZ NULL,
  last_test_at TIMESTAMPTZ NULL,
  last_test_ok BOOL NULL,
  last_test_error TEXT NULL,
  CONSTRAINT integration_credentials_pkey PRIMARY KEY (id),
  CONSTRAINT integration_credentials_created_by_fkey FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE SET NULL
);
CREATE UNIQUE INDEX integration_credentials_provider_version_key ON integration_credentials (provider, version);

-- At most one active version per provider.
CREATE UNIQUE INDEX integration_credentials_one_active
  ON integration_credentials (provider) WHERE status = 'active';
-- Owner 2026-10-01: video posts (Bunny Stream). A post with a video that
-- is still encoding waits as `processing` (not in any feed) and goes
-- `published` when the video is ready.
ALTER TYPE content_status ADD VALUE IF NOT EXISTS 'processing';

CREATE TYPE video_asset_status AS ENUM (
  'awaiting_upload', 'processing', 'ready', 'failed', 'rejected', 'deleted'
);
-- Owner 2026-10-01: one video per post, uploaded straight from the phone
-- to Bunny Stream (TUS); Bunny encodes it and tells us by webhook.
CREATE TABLE video_assets (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  owner_user_id UUID NOT NULL,
  provider TEXT NOT NULL DEFAULT 'bunny',
  library_id TEXT NOT NULL,
  external_id TEXT NOT NULL,
  status video_asset_status NOT NULL DEFAULT 'awaiting_upload',
  duration_sec INTEGER NULL,
  width INTEGER NULL,
  height INTEGER NULL,
  storage_bytes BIGINT NULL,
  failure_reason TEXT NULL,
  upload_expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  ready_at TIMESTAMPTZ NULL,
  deleted_at TIMESTAMPTZ NULL,
  purged_at TIMESTAMPTZ NULL,
  CONSTRAINT video_assets_pkey PRIMARY KEY (id),
  CONSTRAINT video_assets_owner_fkey FOREIGN KEY (owner_user_id) REFERENCES users (id) ON DELETE CASCADE
);
CREATE UNIQUE INDEX video_assets_external_id_key ON video_assets (external_id);
CREATE INDEX video_assets_status_created_idx ON video_assets (status, created_at);
CREATE INDEX video_assets_owner_created_idx ON video_assets (owner_user_id, created_at DESC);

ALTER TABLE posts ADD COLUMN video_asset_id UUID NULL;

ALTER TABLE posts ADD CONSTRAINT posts_video_asset_fkey FOREIGN KEY (video_asset_id) REFERENCES video_assets (id) ON DELETE SET NULL;

CREATE UNIQUE INDEX posts_video_asset_id_key ON posts (video_asset_id);
-- Owner 2026-10-02: admin growth & support tools — contract (blogger)
-- subscriptions, promo codes + redemptions, refunds, referrals, paid case
-- promotion, support tickets, email template overrides. Status/kind
-- columns are short strings (validated by the API, CHECKs below).
-- CreateTable
CREATE TABLE "contract_grants" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "months" SMALLINT NOT NULL,
    "assistant_seats" SMALLINT NOT NULL DEFAULT 0,
    "starts_at" TIMESTAMPTZ NOT NULL,
    "ends_at" TIMESTAMPTZ NOT NULL,
    "contract_ref" VARCHAR(200),
    "note" VARCHAR(1000),
    "created_by" UUID NOT NULL,
    "revoked_at" TIMESTAMPTZ,
    "revoked_by" UUID,
    "revoke_reason" VARCHAR(500),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "contract_grants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "promo_codes" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "code" VARCHAR(40) NOT NULL,
    "description" VARCHAR(300),
    "discount_type" VARCHAR(16) NOT NULL,
    "percent_off" SMALLINT,
    "amount_off_cents" INTEGER,
    "free_days" INTEGER,
    "audience" VARCHAR(16) NOT NULL DEFAULT 'attorney',
    "applies_to" VARCHAR(16) NOT NULL DEFAULT 'any',
    "max_redemptions" INTEGER,
    "redeemed_count" INTEGER NOT NULL DEFAULT 0,
    "starts_at" TIMESTAMPTZ,
    "expires_at" TIMESTAMPTZ,
    "active" BOOL NOT NULL DEFAULT true,
    "stripe_coupon_id" TEXT,
    "created_by" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "promo_codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "promo_redemptions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "promo_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "amount_off_cents" INTEGER,
    "payment_id" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "promo_redemptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refunds" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "payment_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "amount_cents" INTEGER NOT NULL,
    "reason" VARCHAR(500) NOT NULL,
    "status" VARCHAR(16) NOT NULL,
    "stripe_refund_id" TEXT,
    "failure_reason" TEXT,
    "admin_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "refunds_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "referral_codes" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "code" VARCHAR(24) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "referral_codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "referrals" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "referrer_id" UUID NOT NULL,
    "referee_id" UUID NOT NULL,
    "code" VARCHAR(24) NOT NULL,
    "status" VARCHAR(16) NOT NULL DEFAULT 'pending',
    "referrer_role" VARCHAR(16) NOT NULL,
    "referee_role" VARCHAR(16) NOT NULL,
    "referrer_reward" JSONB NOT NULL DEFAULT '{}',
    "referee_reward" JSONB NOT NULL DEFAULT '{}',
    "qualified_at" TIMESTAMPTZ,
    "rewarded_at" TIMESTAMPTZ,
    "rejected_reason" VARCHAR(300),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "referrals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "case_promotions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "case_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "days" SMALLINT NOT NULL,
    "price_cents_per_day" INTEGER NOT NULL,
    "total_cents" INTEGER NOT NULL,
    "status" VARCHAR(20) NOT NULL,
    "starts_at" TIMESTAMPTZ,
    "ends_at" TIMESTAMPTZ,
    "stripe_checkout_id" TEXT,
    "payment_id" UUID,
    "promo_code_id" UUID,
    "granted_by" UUID,
    "canceled_by" UUID,
    "cancel_reason" VARCHAR(500),
    "impressions" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "case_promotions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "support_tickets" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "subject" VARCHAR(200) NOT NULL,
    "category" VARCHAR(20) NOT NULL DEFAULT 'other',
    "status" VARCHAR(16) NOT NULL DEFAULT 'open',
    "priority" VARCHAR(8) NOT NULL DEFAULT 'normal',
    "assignee_id" UUID,
    "unread_by_admin" BOOL NOT NULL DEFAULT true,
    "unread_by_user" BOOL NOT NULL DEFAULT false,
    "last_message_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resolved_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "support_tickets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "support_messages" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "ticket_id" UUID NOT NULL,
    "author_user_id" UUID,
    "author_admin_id" UUID,
    "internal" BOOL NOT NULL DEFAULT false,
    "body" VARCHAR(5000) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "support_messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "email_templates" (
    "key" VARCHAR(64) NOT NULL,
    "locale" VARCHAR(5) NOT NULL,
    "subject" VARCHAR(200) NOT NULL,
    "text_body" TEXT NOT NULL,
    "html_body" TEXT,
    "enabled" BOOL NOT NULL DEFAULT true,
    "updated_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "email_templates_pkey" PRIMARY KEY ("key","locale")
);

-- CreateIndex
CREATE INDEX "contract_grants_user_id_ends_at_idx" ON "contract_grants"("user_id", "ends_at");

-- CreateIndex
CREATE INDEX "contract_grants_ends_at_idx" ON "contract_grants"("ends_at");

-- CreateIndex
CREATE UNIQUE INDEX "promo_codes_code_key" ON "promo_codes"("code");

-- CreateIndex
CREATE INDEX "promo_codes_active_expires_at_idx" ON "promo_codes"("active", "expires_at");

-- CreateIndex
CREATE INDEX "promo_redemptions_user_id_idx" ON "promo_redemptions"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "promo_redemptions_promo_id_user_id_key" ON "promo_redemptions"("promo_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "refunds_stripe_refund_id_key" ON "refunds"("stripe_refund_id");

-- CreateIndex
CREATE INDEX "refunds_payment_id_idx" ON "refunds"("payment_id");

-- CreateIndex
CREATE INDEX "refunds_created_at_idx" ON "refunds"("created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "referral_codes_user_id_key" ON "referral_codes"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "referral_codes_code_key" ON "referral_codes"("code");

-- CreateIndex
CREATE UNIQUE INDEX "referrals_referee_id_key" ON "referrals"("referee_id");

-- CreateIndex
CREATE INDEX "referrals_referrer_id_created_at_idx" ON "referrals"("referrer_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "referrals_status_created_at_idx" ON "referrals"("status", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "case_promotions_stripe_checkout_id_key" ON "case_promotions"("stripe_checkout_id");

-- CreateIndex
CREATE INDEX "case_promotions_status_ends_at_idx" ON "case_promotions"("status", "ends_at");

-- CreateIndex
CREATE INDEX "case_promotions_case_id_idx" ON "case_promotions"("case_id");

-- CreateIndex
CREATE INDEX "case_promotions_user_id_created_at_idx" ON "case_promotions"("user_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "support_tickets_status_last_message_at_idx" ON "support_tickets"("status", "last_message_at" DESC);

-- CreateIndex
CREATE INDEX "support_tickets_user_id_last_message_at_idx" ON "support_tickets"("user_id", "last_message_at" DESC);

-- CreateIndex
CREATE INDEX "support_tickets_assignee_id_status_idx" ON "support_tickets"("assignee_id", "status");

-- CreateIndex
CREATE INDEX "support_messages_ticket_id_created_at_idx" ON "support_messages"("ticket_id", "created_at");

-- Value guards (the DTOs validate too).
ALTER TABLE "contract_grants" ADD CONSTRAINT "contract_grants_months_check" CHECK ("months" BETWEEN 1 AND 24);

ALTER TABLE "contract_grants" ADD CONSTRAINT "contract_grants_seats_check" CHECK ("assistant_seats" BETWEEN 0 AND 6);

ALTER TABLE "promo_codes" ADD CONSTRAINT "promo_codes_type_check" CHECK ("discount_type" IN ('percent', 'amount', 'free_days'));

ALTER TABLE "promo_codes" ADD CONSTRAINT "promo_codes_percent_check" CHECK ("percent_off" IS NULL OR "percent_off" BETWEEN 1 AND 100);

ALTER TABLE "refunds" ADD CONSTRAINT "refunds_status_check" CHECK ("status" IN ('pending', 'succeeded', 'failed'));

ALTER TABLE "referrals" ADD CONSTRAINT "referrals_status_check" CHECK ("status" IN ('pending', 'qualified', 'rewarded', 'rejected'));

ALTER TABLE "case_promotions" ADD CONSTRAINT "case_promotions_status_check" CHECK ("status" IN ('pending_payment', 'active', 'finished', 'canceled', 'refunded'));

ALTER TABLE "case_promotions" ADD CONSTRAINT "case_promotions_days_check" CHECK ("days" BETWEEN 1 AND 90);

ALTER TABLE "support_tickets" ADD CONSTRAINT "support_tickets_status_check" CHECK ("status" IN ('open', 'waiting_user', 'resolved', 'closed'));

ALTER TABLE "support_tickets" ADD CONSTRAINT "support_tickets_priority_check" CHECK ("priority" IN ('low', 'normal', 'high', 'urgent'));
-- Owner 2026-10-01: Telegram-style stickers — a sticker image is its own
-- file purpose (public media) and a chat message can be a sticker.
ALTER TYPE file_purpose ADD VALUE IF NOT EXISTS 'sticker';

ALTER TYPE message_type ADD VALUE IF NOT EXISTS 'sticker';
-- Owner 2026-10-01: sticker packs like Telegram. Anyone makes their own
-- packs ("+"), installs anyone's pack from a sticker in a chat, the owner
-- publishes official packs from the admin panel and hides bad ones.
CREATE TABLE sticker_packs (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  -- NULL = official (made in the admin panel).
  owner_user_id UUID NULL,
  title VARCHAR(64) NOT NULL,
  short_name VARCHAR(40) NOT NULL,
  is_official BOOL NOT NULL DEFAULT false,
  -- active | hidden (admin moderation).
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  sticker_count INTEGER NOT NULL DEFAULT 0,
  install_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ NULL,
  CONSTRAINT sticker_packs_pkey PRIMARY KEY (id),
  CONSTRAINT sticker_packs_owner_fkey FOREIGN KEY (owner_user_id) REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT sticker_packs_status_check CHECK (status IN ('active', 'hidden'))
);
CREATE UNIQUE INDEX sticker_packs_short_name_key ON sticker_packs (short_name);
CREATE INDEX sticker_packs_owner_idx ON sticker_packs (owner_user_id, created_at DESC);
CREATE INDEX sticker_packs_official_idx ON sticker_packs (is_official, status, install_count DESC);

CREATE TABLE stickers (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  pack_id UUID NOT NULL,
  file_id UUID NOT NULL,
  emoji VARCHAR(16) NOT NULL DEFAULT '🙂',
  position INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ NULL,
  CONSTRAINT stickers_pkey PRIMARY KEY (id),
  CONSTRAINT stickers_pack_fkey FOREIGN KEY (pack_id) REFERENCES sticker_packs (id) ON DELETE CASCADE,
  CONSTRAINT stickers_file_fkey FOREIGN KEY (file_id) REFERENCES files (id) ON DELETE RESTRICT
);
CREATE UNIQUE INDEX stickers_file_id_key ON stickers (file_id);
CREATE INDEX stickers_pack_position_idx ON stickers (pack_id, position);

CREATE TABLE user_sticker_packs (
  user_id UUID NOT NULL,
  pack_id UUID NOT NULL,
  position INTEGER NOT NULL DEFAULT 0,
  installed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT user_sticker_packs_pkey PRIMARY KEY (user_id, pack_id),
  CONSTRAINT user_sticker_packs_user_fkey FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT user_sticker_packs_pack_fkey FOREIGN KEY (pack_id) REFERENCES sticker_packs (id) ON DELETE CASCADE
);
CREATE INDEX user_sticker_packs_pack_idx ON user_sticker_packs (pack_id);

CREATE TABLE user_recent_stickers (
  user_id UUID NOT NULL,
  sticker_id UUID NOT NULL,
  used_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT user_recent_stickers_pkey PRIMARY KEY (user_id, sticker_id),
  CONSTRAINT user_recent_stickers_user_fkey FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT user_recent_stickers_sticker_fkey FOREIGN KEY (sticker_id) REFERENCES stickers (id) ON DELETE CASCADE
);
CREATE INDEX user_recent_stickers_used_idx ON user_recent_stickers (user_id, used_at DESC);

ALTER TABLE messages ADD COLUMN sticker_id UUID NULL;

ALTER TABLE messages ADD CONSTRAINT messages_sticker_fkey FOREIGN KEY (sticker_id) REFERENCES stickers (id) ON DELETE SET NULL;

CREATE INDEX messages_sticker_id_idx ON messages (sticker_id);
-- Notification types for the referral reward and case promotion events.
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'referral_reward';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'promotion_started';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'promotion_ended';
-- User sticker packs can be reported (Owner 2026-10-02).
ALTER TYPE report_target_type ADD VALUE IF NOT EXISTS 'sticker_pack';
-- A chat removed from my list only (Owner 2026-10-02); a new message revives it.
ALTER TABLE conversation_participants ADD COLUMN IF NOT EXISTS hidden_at TIMESTAMPTZ;
-- Admin access control (owner 2026-10-02): login + password as the first
-- factor, a security question for the super admin, per-area permissions.

ALTER TABLE admin_credentials ADD COLUMN login VARCHAR(40) NULL;

ALTER TABLE admin_credentials ADD COLUMN password_hash TEXT NULL;

ALTER TABLE admin_credentials ADD COLUMN password_changed_at TIMESTAMPTZ NULL;

ALTER TABLE admin_credentials ADD COLUMN security_question VARCHAR(200) NULL;

ALTER TABLE admin_credentials ADD COLUMN security_answer_hash TEXT NULL;

CREATE UNIQUE INDEX admin_credentials_login_key ON admin_credentials (login);

ALTER TABLE admin_profiles ADD COLUMN permissions JSONB NOT NULL DEFAULT '{}';

-- Existing staff keep what their role gave them, except money (hard-denied
-- for everyone but the super admin from now on).
UPDATE admin_profiles SET permissions = '{"dashboard":"view","moderation":"manage","content":"manage","media":"manage","users":"view"}'::JSONB
  WHERE admin_role = 'moderator';

UPDATE admin_profiles SET permissions = '{"dashboard":"view","verification":"manage","users":"view"}'::JSONB
  WHERE admin_role = 'verifier';

UPDATE admin_profiles SET permissions = '{"dashboard":"view","support":"manage","users":"view"}'::JSONB
  WHERE admin_role = 'support';

UPDATE admin_profiles SET permissions = '{"dashboard":"view","support":"view","users":"view"}'::JSONB
  WHERE admin_role = 'finance';
-- Paid verified badge of a client (Owner 2026-10-02).
CREATE TABLE IF NOT EXISTS client_verifications (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'pending',
  document_file_ids JSONB NOT NULL DEFAULT '[]',
  note VARCHAR(500),
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  reviewed_at TIMESTAMPTZ,
  reviewed_by UUID,
  reject_reason VARCHAR(500),
  revoke_reason VARCHAR(500),
  stripe_checkout_id VARCHAR(255),
  stripe_subscription_id VARCHAR(255),
  sub_status VARCHAR(16) NOT NULL DEFAULT 'none',
  current_period_end TIMESTAMPTZ,
  cancel_at_period_end BOOL NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT client_verifications_pkey PRIMARY KEY (id),
  CONSTRAINT client_verifications_user_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE NO ACTION
);

CREATE UNIQUE INDEX IF NOT EXISTS client_verifications_user_id_key ON client_verifications (user_id);

CREATE UNIQUE INDEX IF NOT EXISTS client_verifications_stripe_subscription_id_key ON client_verifications (stripe_subscription_id);

CREATE INDEX IF NOT EXISTS client_verifications_queue_idx ON client_verifications (status, submitted_at DESC);
-- Owner 2026-10-02: admin role templates and account bans (additive).

CREATE TABLE admin_role_templates (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  name VARCHAR(60) NOT NULL,
  permissions JSONB NOT NULL DEFAULT '{}',
  created_by UUID NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL,
  CONSTRAINT admin_role_templates_pkey PRIMARY KEY (id)
);

CREATE UNIQUE INDEX admin_role_templates_name_key ON admin_role_templates (name);

CREATE TABLE account_bans (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  kind VARCHAR(10) NOT NULL,
  value TEXT NOT NULL,
  user_id UUID NULL,
  reason TEXT NOT NULL,
  expires_at TIMESTAMPTZ NULL,
  created_by UUID NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  lifted_at TIMESTAMPTZ NULL,
  lifted_by UUID NULL,
  lift_reason TEXT NULL,
  CONSTRAINT account_bans_pkey PRIMARY KEY (id),
  CONSTRAINT account_bans_kind_check CHECK (kind IN ('user', 'phone', 'email', 'device'))
);

CREATE INDEX account_bans_kind_value_idx ON account_bans (kind, value);

CREATE INDEX account_bans_created_at_idx ON account_bans (created_at);
-- Repair: a restored database can miss the `processing` value that
-- 20261001210000_owner_video_enums adds. Idempotent.
ALTER TYPE content_status ADD VALUE IF NOT EXISTS 'processing';
-- Owner 2026-10-02: reels/posts like Instagram — a location under the
-- author's name and "turn off commenting". Additive and idempotent.
ALTER TABLE posts ADD COLUMN IF NOT EXISTS location_name TEXT;

ALTER TABLE posts ADD COLUMN IF NOT EXISTS location_lat FLOAT8;

ALTER TABLE posts ADD COLUMN IF NOT EXISTS location_lng FLOAT8;

ALTER TABLE posts ADD COLUMN IF NOT EXISTS comments_enabled BOOL NOT NULL DEFAULT true;
-- Owner 2026-10-03: plan prices edited in the admin (additive).
CREATE TABLE IF NOT EXISTS plan_prices (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  kind VARCHAR(16) NOT NULL,
  amount_cents INTEGER NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'usd',
  active BOOL NOT NULL DEFAULT true,
  stripe_price_ids JSONB NOT NULL DEFAULT '{}',
  stripe_product_ids JSONB NOT NULL DEFAULT '{}',
  note VARCHAR(300),
  created_by UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT plan_prices_pkey PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS plan_prices_kind_idx ON plan_prices (kind, active, created_at DESC);
-- Owner 2026-10-04: the chat "Translate" button, off until the owner saves
-- the Google key in the admin and turns the flag on (data only).
INSERT INTO feature_flags (key, enabled, rollout_percent, description, updated_at)
VALUES ('chat_translate', false, 100, 'Translate button under chat messages (Google Translate)', now())
ON CONFLICT (key) DO NOTHING;
-- Owner 2026-10-04: an attorney confirms the license under a sworn
-- statement instead of documents. When, from where and which wording
-- version was accepted (additive, nullable).
ALTER TABLE verification_requests ADD COLUMN IF NOT EXISTS attested_at TIMESTAMPTZ;

ALTER TABLE verification_requests ADD COLUMN IF NOT EXISTS attestation_ip TEXT;

ALTER TABLE verification_requests ADD COLUMN IF NOT EXISTS attestation_version TEXT;
-- Owner 2026-10-04: a broadcast can target any set of states.
ALTER TABLE "admin_broadcasts" ADD COLUMN "state_codes" TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[];

UPDATE "admin_broadcasts" SET "state_codes" = ARRAY["state_code"] WHERE "state_code" IS NOT NULL;
-- Owner 2026-10-04: the client's optional case cover (an app cover
-- variant `art:0..3` or an icon avatar `icon:<name>`, never a personal
-- photo) and how urgent the case is. Additive and nullable: older cases
-- get a cover picked from their id and show no urgency.
ALTER TABLE cases ADD COLUMN IF NOT EXISTS cover_key TEXT;

ALTER TABLE cases ADD COLUMN IF NOT EXISTS urgency TEXT;

ALTER TABLE cases ADD CONSTRAINT cases_cover_key_check
  CHECK (cover_key IS NULL OR cover_key ~ '^(art:[0-3]|icon:[a-z_]{2,32})$');

ALTER TABLE cases ADD CONSTRAINT cases_urgency_check
  CHECK (urgency IS NULL OR urgency IN ('flexible', 'soon', 'urgent'));
-- Owner 2026-10-05: automatic license check per state. Each state picks an
-- adapter (manual by default) and, when the registry needs one, an API key
-- kept as an AES-256-GCM envelope. A self-attested license the registry
-- disagrees with stays verified and gets a flag for the admin.
ALTER TABLE "attorney_licenses" ADD COLUMN "registry_flag" TEXT;

ALTER TABLE "attorney_licenses" ADD COLUMN "registry_flagged_at" TIMESTAMPTZ;

CREATE TABLE "state_bar_registries" (
    "state_code" CHAR(2) NOT NULL,
    "adapter" TEXT NOT NULL DEFAULT 'manual',
    "enabled" BOOL NOT NULL DEFAULT false,
    "config" JSONB NOT NULL DEFAULT '{}',
    "secret_enc" TEXT,
    "secret_masked" TEXT,
    "test_bar_number" TEXT,
    "last_test_at" TIMESTAMPTZ,
    "last_test_result" JSONB,
    "updated_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "state_bar_registries_pkey" PRIMARY KEY ("state_code")
);

CREATE INDEX "attorney_licenses_registry_flag_idx" ON "attorney_licenses"("registry_flag");

ALTER TABLE "state_bar_registries" ADD CONSTRAINT "state_bar_registries_state_code_fkey" FOREIGN KEY ("state_code") REFERENCES "states"("code") ON DELETE RESTRICT ON UPDATE CASCADE;

-- New York's open dataset was the one registry behind the global flag
-- `auto_bar_check`; it becomes the NY row and keeps the flag's state.
INSERT INTO "state_bar_registries" ("state_code", "adapter", "enabled", "updated_at")
SELECT s.code, 'ny_open_data',
       COALESCE((SELECT f.enabled FROM feature_flags f WHERE f.key = 'auto_bar_check'), false),
       now()
  FROM states s
 WHERE s.code = 'NY'
ON CONFLICT ("state_code") DO NOTHING;
-- Owner 2026-10-04: attorneys may bid on a case in any state. A bid from an
-- attorney with no verified licence in the case's states is marked so the
-- client sees it before accepting.
ALTER TABLE "bids" ADD COLUMN "outside_licensed_states" BOOL NOT NULL DEFAULT false;
-- Owner 2026-10-04: an assistant joins (and signs in again) with a one-time
-- code the attorney gets for each seat in the app — no SMS. The code is
-- stored hashed (lookup, globally unique) and encrypted (the attorney can
-- show and copy it again); the phone is no longer required.
ALTER TABLE "assistant_memberships" ALTER COLUMN "phone_e164" DROP NOT NULL;

ALTER TABLE "assistant_memberships" ADD COLUMN "join_code_hash" TEXT NULL;

ALTER TABLE "assistant_memberships" ADD COLUMN "join_code_enc" TEXT NULL;

ALTER TABLE "assistant_memberships" ADD COLUMN "join_code_expires_at" TIMESTAMPTZ NULL;

CREATE UNIQUE INDEX "assistant_memberships_join_code_hash_key" ON "assistant_memberships"("join_code_hash");
-- Owner 2026-10-05: a client offers a case to a chosen attorney.
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'case_invite_received';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'case_invite_declined';
-- Owner 2026-10-05: a client offers one of their open cases to a chosen
-- attorney; the attorney answers with a bid or declines.
CREATE TABLE IF NOT EXISTS case_invites (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  case_id UUID NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
  client_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  attorney_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(20) NOT NULL DEFAULT 'pending',
  message VARCHAR(1000),
  budget_cents INTEGER,
  decline_reason VARCHAR(500),
  outside_practice BOOL NOT NULL DEFAULT false,
  outside_licensed_states BOOL NOT NULL DEFAULT false,
  bid_id UUID,
  expires_at TIMESTAMPTZ NOT NULL,
  decided_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT case_invites_case_attorney_key UNIQUE (case_id, attorney_id)
);

CREATE INDEX IF NOT EXISTS case_invites_attorney_status_idx
  ON case_invites (attorney_id, status);

CREATE INDEX IF NOT EXISTS case_invites_client_created_idx
  ON case_invites (client_id, created_at);
-- Owner 2026-10-05: a personal assistant limit per attorney, and the
-- attorney's requests for more seats that an admin approves.
ALTER TABLE attorney_profiles ADD COLUMN IF NOT EXISTS assistant_seat_limit SMALLINT;

CREATE TABLE IF NOT EXISTS seat_limit_requests (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  attorney_id UUID NOT NULL,
  requested_seats SMALLINT NOT NULL,
  note VARCHAR(1000),
  status VARCHAR(20) NOT NULL DEFAULT 'pending',
  granted_seats SMALLINT,
  decision_note VARCHAR(500),
  decided_by UUID,
  decided_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS seat_limit_requests_status_created_idx
  ON seat_limit_requests (status, created_at);

CREATE INDEX IF NOT EXISTS seat_limit_requests_attorney_created_idx
  ON seat_limit_requests (attorney_id, created_at);

-- Owner 2026-10-05: the assistant limit is an admin setting (default 10)
-- with personal overrides, so the old "at most 6" checks become the hard
-- cap of 50 (SEATS_HARD_CAP in billing.constants.ts).
ALTER TABLE "subscriptions" DROP CONSTRAINT "subscriptions_assistant_seats_range";

ALTER TABLE "subscriptions" ADD CONSTRAINT "subscriptions_assistant_seats_range" CHECK ("assistant_seats" BETWEEN 0 AND 50);

ALTER TABLE "contract_grants" DROP CONSTRAINT "contract_grants_seats_check";

ALTER TABLE "contract_grants" ADD CONSTRAINT "contract_grants_seats_check" CHECK ("assistant_seats" BETWEEN 0 AND 50);
-- Owner 2026-10-05: documents (PDF, Word, text) attached to posts and to a
-- reel's inner page. Own migration: CockroachDB can't use an enum value
-- added in the same transaction. Idempotent.
ALTER TYPE file_purpose ADD VALUE IF NOT EXISTS 'post_attachment';
-- Owner 2026-10-05: reels like Instagram (trim + cover frame), up to 9
-- documents per post / reel inner page, and video calls behind the
-- `video_calls` flag. Additive.
CREATE TABLE IF NOT EXISTS post_attachments (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    post_id UUID NOT NULL,
    file_id UUID NOT NULL,
    file_name TEXT NOT NULL,
    position SMALLINT NOT NULL,
    created_at TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT post_attachments_pkey PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS post_attachments_file_id_key ON post_attachments(file_id);

CREATE UNIQUE INDEX IF NOT EXISTS post_attachments_post_id_position_key ON post_attachments(post_id, position);

ALTER TABLE post_attachments ADD CONSTRAINT post_attachments_post_id_fkey FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE post_attachments ADD CONSTRAINT post_attachments_file_id_fkey FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE video_assets ADD COLUMN IF NOT EXISTS trim_start_ms INTEGER;

ALTER TABLE video_assets ADD COLUMN IF NOT EXISTS trim_end_ms INTEGER;

ALTER TABLE video_assets ADD COLUMN IF NOT EXISTS cover_time_ms INTEGER;

ALTER TABLE calls ADD COLUMN IF NOT EXISTS video BOOL NOT NULL DEFAULT false;

INSERT INTO feature_flags (key, enabled, rollout_percent, description, updated_at)
VALUES ('video_calls', false, 100, 'Video calls in chats (WebRTC, needs TURN in Admin → Integrations)', now())
ON CONFLICT (key) DO NOTHING;
-- Owner 2026-10-05: partner (affiliate) program — people paid per referred
-- attorney who buys a subscription / client who hires, plus an optional
-- monthly base. Attribution reuses referral_codes / referrals.
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'partner_commission';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'partner_payout';

CREATE TABLE IF NOT EXISTS partners (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  label VARCHAR(120),
  note VARCHAR(1000),
  attorney_rate_cents INTEGER,
  client_rate_cents INTEGER,
  monthly_base_cents INTEGER NOT NULL DEFAULT 0,
  client_rule VARCHAR(24),
  hold_days SMALLINT,
  created_by UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL,
  ended_at TIMESTAMPTZ,
  CONSTRAINT partners_pkey PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS partners_user_id_key ON partners (user_id);

CREATE INDEX IF NOT EXISTS partners_status_created_at_idx ON partners (status, created_at);

CREATE TABLE IF NOT EXISTS partner_commissions (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  partner_id UUID NOT NULL,
  partner_user_id UUID NOT NULL,
  referral_id UUID,
  referred_user_id UUID,
  kind VARCHAR(32) NOT NULL,
  amount_cents INTEGER NOT NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'held',
  event_ref VARCHAR(120) NOT NULL,
  period VARCHAR(7) NOT NULL,
  hold_until TIMESTAMPTZ,
  approved_at TIMESTAMPTZ,
  approved_by UUID,
  paid_at TIMESTAMPTZ,
  paid_by UUID,
  payout_ref VARCHAR(120),
  reversed_at TIMESTAMPTZ,
  reversed_reason VARCHAR(300),
  note VARCHAR(300),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL,
  CONSTRAINT partner_commissions_pkey PRIMARY KEY (id),
  CONSTRAINT partner_commissions_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES partners (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS partner_commissions_event_ref_key ON partner_commissions (event_ref);

CREATE INDEX IF NOT EXISTS partner_commissions_partner_id_created_at_idx ON partner_commissions (partner_id, created_at DESC);

CREATE INDEX IF NOT EXISTS partner_commissions_status_hold_until_idx ON partner_commissions (status, hold_until);

CREATE INDEX IF NOT EXISTS partner_commissions_referred_user_id_idx ON partner_commissions (referred_user_id);

CREATE INDEX IF NOT EXISTS partner_commissions_period_status_idx ON partner_commissions (period, status);
-- Owner 2026-10-05: plan builder — plans with entitlements assembled in the
-- admin, client plans, subscriptions frozen to the plan they bought
-- (additive; nothing existing changes shape).
ALTER TABLE plan_prices ALTER COLUMN kind TYPE VARCHAR(64);

CREATE TABLE IF NOT EXISTS plans (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  code VARCHAR(64) NOT NULL,
  audience VARCHAR(16) NOT NULL,
  kind VARCHAR(16) NOT NULL DEFAULT 'paid',
  name JSONB NOT NULL DEFAULT '{}',
  tagline JSONB NOT NULL DEFAULT '{}',
  description JSONB NOT NULL DEFAULT '{}',
  interval VARCHAR(8),
  price_kind VARCHAR(64),
  entitlements JSONB NOT NULL DEFAULT '{}',
  highlights JSONB NOT NULL DEFAULT '[]',
  status VARCHAR(16) NOT NULL DEFAULT 'draft',
  sort INTEGER NOT NULL DEFAULT 0,
  is_default BOOL NOT NULL DEFAULT false,
  created_by UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT plans_pkey PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS plans_code_key ON plans (code);

CREATE INDEX IF NOT EXISTS plans_audience_idx ON plans (audience, status, sort);

ALTER TABLE subscriptions ADD COLUMN IF NOT EXISTS plan_id UUID;

ALTER TABLE subscriptions ADD COLUMN IF NOT EXISTS entitlements JSONB;

ALTER TABLE subscriptions ADD CONSTRAINT subscriptions_plan_id_fkey
  FOREIGN KEY (plan_id) REFERENCES plans(id) ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE IF NOT EXISTS client_subscriptions (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  plan_id UUID,
  stripe_checkout_id VARCHAR(255),
  stripe_subscription_id VARCHAR(255),
  status VARCHAR(16) NOT NULL DEFAULT 'incomplete',
  price_cents INTEGER NOT NULL DEFAULT 0,
  trial_ends_at TIMESTAMPTZ,
  current_period_end TIMESTAMPTZ,
  cancel_at_period_end BOOL NOT NULL DEFAULT false,
  canceled_at TIMESTAMPTZ,
  entitlements JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT client_subscriptions_pkey PRIMARY KEY (id),
  CONSTRAINT client_subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT client_subscriptions_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES plans(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS client_subscriptions_user_id_key ON client_subscriptions (user_id);

CREATE UNIQUE INDEX IF NOT EXISTS client_subscriptions_stripe_subscription_id_key ON client_subscriptions (stripe_subscription_id);

CREATE INDEX IF NOT EXISTS client_subscriptions_status_idx ON client_subscriptions (status, current_period_end);
-- Owner 2026-10-05: document templates the admin publishes. Own
-- migration: CockroachDB can't use an enum value added in the same
-- transaction. Idempotent.
ALTER TYPE file_purpose ADD VALUE IF NOT EXISTS 'document_template';
-- Owner 2026-10-05: the document templates library (admin → Content →
-- Document templates, app → "Templates") behind the `document_templates`
-- flag (on). Additive.
CREATE TYPE document_template_audience AS ENUM ('everyone', 'lawyers');

CREATE TABLE IF NOT EXISTS document_templates (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    file_id UUID NOT NULL,
    file_name TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    practice_area_id UUID,
    state CHAR(2),
    language TEXT NOT NULL DEFAULT 'en',
    audience document_template_audience NOT NULL DEFAULT 'everyone',
    is_published BOOL NOT NULL DEFAULT false,
    download_count INTEGER NOT NULL DEFAULT 0,
    created_by UUID,
    created_at TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ(6) NOT NULL,
    deleted_at TIMESTAMPTZ(6),
    CONSTRAINT document_templates_pkey PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS document_templates_file_id_key ON document_templates(file_id);

CREATE INDEX IF NOT EXISTS document_templates_is_published_deleted_at_created_at_idx ON document_templates(is_published, deleted_at, created_at);

CREATE INDEX IF NOT EXISTS document_templates_practice_area_id_idx ON document_templates(practice_area_id);

ALTER TABLE document_templates ADD CONSTRAINT document_templates_file_id_fkey FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE document_templates ADD CONSTRAINT document_templates_practice_area_id_fkey FOREIGN KEY (practice_area_id) REFERENCES practice_areas(id) ON DELETE SET NULL ON UPDATE CASCADE;

INSERT INTO feature_flags (key, enabled, rollout_percent, description, updated_at)
VALUES ('document_templates', true, 100, 'Document templates library (Content → Document templates; app → Templates)', now())
ON CONFLICT (key) DO NOTHING;

-- Plan builder entitlement `document_templates`: paid plans and the terms
-- frozen on paid subscriptions get it (the attorney baseline does not).
UPDATE plans SET entitlements = entitlements || '{"document_templates": true}'::JSONB
WHERE kind = 'paid' AND NOT (entitlements ? 'document_templates');

UPDATE subscriptions SET entitlements = entitlements || '{"document_templates": true}'::JSONB
WHERE entitlements IS NOT NULL AND NOT (entitlements ? 'document_templates');

UPDATE client_subscriptions SET entitlements = entitlements || '{"document_templates": true}'::JSONB
WHERE entitlements IS NOT NULL AND NOT (entitlements ? 'document_templates');
-- Owner 2026-10-04: a dispute was opened on the case / support decided it.
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'case_disputed';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'dispute_resolved';
-- Web client kill switch (owner 2026-10-05: on by default). Website
-- sign-in already exists; switching this off refuses sign-ins and sign-ups
-- that declare deviceInfo.platform = 'web' (data only).
INSERT INTO feature_flags (key, enabled, rollout_percent, description, updated_at)
VALUES ('web_client', true, 100, 'Sign-in from the web client (platform = web)', now())
ON CONFLICT (key) DO NOTHING;
-- Owner 2026-10-05: client → attorney payments through the platform
-- (Stripe Connect Express, direct charges): the attorney's payout
-- account, the payments themselves and their refunds. Additive.

-- CreateTable
CREATE TABLE "payout_accounts" (
    "user_id" UUID NOT NULL,
    "provider" VARCHAR(16) NOT NULL DEFAULT 'stripe',
    "stripe_account_id" TEXT NOT NULL,
    "status" VARCHAR(16) NOT NULL DEFAULT 'pending',
    "charges_enabled" BOOL NOT NULL DEFAULT false,
    "payouts_enabled" BOOL NOT NULL DEFAULT false,
    "details_submitted" BOOL NOT NULL DEFAULT false,
    "requirements_due" TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
    "disabled_reason" VARCHAR(200),
    "country" VARCHAR(2),
    "last_synced_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "payout_accounts_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "case_payments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "case_id" UUID NOT NULL,
    "bid_id" UUID,
    "client_id" UUID NOT NULL,
    "attorney_id" UUID NOT NULL,
    "kind" VARCHAR(16) NOT NULL,
    "status" VARCHAR(24) NOT NULL,
    "amount_cents" INTEGER NOT NULL,
    "platform_fee_cents" INTEGER NOT NULL DEFAULT 0,
    "processing_fee_cents" INTEGER NOT NULL DEFAULT 0,
    "client_total_cents" INTEGER NOT NULL,
    "attorney_net_cents" INTEGER NOT NULL,
    "fee_type" VARCHAR(16) NOT NULL,
    "fee_payer" VARCHAR(16) NOT NULL,
    "currency" VARCHAR(3) NOT NULL DEFAULT 'usd',
    "note" VARCHAR(200),
    "stripe_account_id" TEXT,
    "stripe_checkout_id" TEXT,
    "stripe_payment_intent_id" TEXT,
    "stripe_charge_id" TEXT,
    "receipt_url" TEXT,
    "refunded_cents" INTEGER NOT NULL DEFAULT 0,
    "dispute_status" VARCHAR(32),
    "disputed_at" TIMESTAMPTZ,
    "paid_at" TIMESTAMPTZ,
    "canceled_reason" VARCHAR(100),
    "failure_code" VARCHAR(100),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "case_payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "case_payment_refunds" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "payment_id" UUID NOT NULL,
    "amount_cents" INTEGER NOT NULL,
    "reason" VARCHAR(500) NOT NULL,
    "initiated_by_type" VARCHAR(16) NOT NULL,
    "initiated_by" UUID,
    "stripe_refund_id" TEXT,
    "status" VARCHAR(16) NOT NULL,
    "failure_reason" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "case_payment_refunds_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "payout_accounts_stripe_account_id_key" ON "payout_accounts"("stripe_account_id");

-- CreateIndex
CREATE INDEX "payout_accounts_status_idx" ON "payout_accounts"("status");

-- CreateIndex
CREATE UNIQUE INDEX "case_payments_stripe_checkout_id_key" ON "case_payments"("stripe_checkout_id");

-- CreateIndex
CREATE UNIQUE INDEX "case_payments_stripe_payment_intent_id_key" ON "case_payments"("stripe_payment_intent_id");

-- CreateIndex
CREATE INDEX "case_payments_case_id_created_at_idx" ON "case_payments"("case_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "case_payments_client_id_created_at_idx" ON "case_payments"("client_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "case_payments_attorney_id_created_at_idx" ON "case_payments"("attorney_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "case_payments_status_created_at_idx" ON "case_payments"("status", "created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "case_payment_refunds_stripe_refund_id_key" ON "case_payment_refunds"("stripe_refund_id");

-- CreateIndex
CREATE INDEX "case_payment_refunds_payment_id_idx" ON "case_payment_refunds"("payment_id");

-- Validated by the API; CHECKs keep stray values out.
ALTER TABLE "payout_accounts" ADD CONSTRAINT "payout_accounts_status_check"
  CHECK (status IN ('pending', 'onboarding', 'active', 'restricted', 'disabled'));

ALTER TABLE "case_payments" ADD CONSTRAINT "case_payments_kind_check"
  CHECK (kind IN ('bid', 'deposit', 'balance', 'custom'));

ALTER TABLE "case_payments" ADD CONSTRAINT "case_payments_status_check"
  CHECK (status IN ('pending_payment', 'succeeded', 'failed', 'canceled', 'refunded', 'partially_refunded', 'disputed'));

ALTER TABLE "case_payments" ADD CONSTRAINT "case_payments_amount_check"
  CHECK (amount_cents > 0 AND platform_fee_cents >= 0 AND processing_fee_cents >= 0 AND client_total_cents > 0 AND attorney_net_cents >= 0 AND refunded_cents >= 0);

ALTER TABLE "case_payment_refunds" ADD CONSTRAINT "case_payment_refunds_amount_check"
  CHECK (amount_cents > 0);

-- Notification types of the payment events.
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'case_payment_received';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'case_payment_sent';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'case_payment_refunded';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'case_payment_disputed';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'payout_account_status';

-- The feature flag: off until the owner connects Stripe and switches it on
-- (the admin refuses to enable it without the Stripe keys).
INSERT INTO feature_flags (key, enabled, rollout_percent, description, updated_at)
VALUES ('payments_in_app', false, 100, 'Clients pay the accepted attorney through the platform (Stripe Connect)', now())
ON CONFLICT (key) DO NOTHING;
-- Owner 2026-10-05: payment requests (invoices, installments) from the
-- attorney, who covers Stripe's fee per payment, saved cards per attorney
-- account. Additive.

-- AlterTable
ALTER TABLE "case_payments" ADD COLUMN "request_id" UUID;

ALTER TABLE "case_payments" ADD COLUMN "processing_fee_payer" VARCHAR(16) NOT NULL DEFAULT 'client';

-- CreateIndex
CREATE INDEX "case_payments_request_id_idx" ON "case_payments"("request_id");

-- CreateTable
CREATE TABLE "payment_requests" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "case_id" UUID NOT NULL,
    "attorney_id" UUID NOT NULL,
    "client_id" UUID NOT NULL,
    "created_by" UUID NOT NULL,
    "amount_cents" INTEGER NOT NULL,
    "description" VARCHAR(200) NOT NULL,
    "due_at" TIMESTAMPTZ,
    "status" VARCHAR(16) NOT NULL DEFAULT 'open',
    "plan_id" UUID,
    "seq" INTEGER NOT NULL DEFAULT 1,
    "total" INTEGER NOT NULL DEFAULT 1,
    "payment_id" UUID,
    "paid_at" TIMESTAMPTZ,
    "canceled_at" TIMESTAMPTZ,
    "last_reminded_at" TIMESTAMPTZ,
    "reminders_sent" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "payment_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "connected_customers" (
    "client_id" UUID NOT NULL,
    "stripe_account_id" TEXT NOT NULL,
    "stripe_customer_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "connected_customers_pkey" PRIMARY KEY ("client_id","stripe_account_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "payment_requests_payment_id_key" ON "payment_requests"("payment_id");

-- CreateIndex
CREATE INDEX "payment_requests_case_id_created_at_idx" ON "payment_requests"("case_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "payment_requests_client_id_status_due_at_idx" ON "payment_requests"("client_id", "status", "due_at");

-- CreateIndex
CREATE INDEX "payment_requests_attorney_id_created_at_idx" ON "payment_requests"("attorney_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "payment_requests_status_due_at_idx" ON "payment_requests"("status", "due_at");

-- Notification types of payment requests.
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'payment_request_created';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'payment_request_due';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'payment_request_overdue';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'payment_request_canceled';
-- Owner 2026-10-05: who covers Stripe's card fee is the attorney's choice
-- (default per attorney, override per invoice); the admin value is only
-- the default for attorneys who have not chosen.
ALTER TABLE "payout_accounts" ADD COLUMN "processing_fee_payer" VARCHAR(16);

ALTER TABLE "payment_requests" ADD COLUMN "processing_fee_payer" VARCHAR(16) NOT NULL DEFAULT 'client';
-- Owner 2026-10-05 03:03: who covers Stripe's fee is agreed per invoice like
-- a bid (proposed / countered / agreed, capped rounds).
ALTER TABLE "payment_requests" ADD COLUMN "fee_payer_status" VARCHAR(16) NOT NULL DEFAULT 'proposed';

ALTER TABLE "payment_requests" ADD COLUMN "fee_payer_by" VARCHAR(16) NOT NULL DEFAULT 'attorney';

ALTER TABLE "payment_requests" ADD COLUMN "fee_payer_rounds" INTEGER NOT NULL DEFAULT 0;

ALTER TABLE "payment_requests" ADD COLUMN "fee_payer_agreed_at" TIMESTAMPTZ;

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'payment_fee_countered';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'payment_fee_agreed';
-- Owner 2026-10-05: a payment that pays an attorney's payment request
-- (invoice) is kind = 'invoice'; the CHECK from the first migration only
-- knew the four free kinds and refused the insert.
ALTER TABLE "case_payments" DROP CONSTRAINT IF EXISTS "case_payments_kind_check";

ALTER TABLE "case_payments" ADD CONSTRAINT "case_payments_kind_check"
  CHECK (kind IN ('bid', 'deposit', 'balance', 'custom', 'invoice'));
-- Owner 2026-10-05: several key sets per service (primary + fallbacks or
-- several accounts) and services added from the admin. Additive: every
-- existing row becomes the "main" set.
ALTER TABLE integration_credentials ADD COLUMN IF NOT EXISTS slot TEXT NOT NULL DEFAULT 'main';

ALTER TABLE integration_credentials ADD COLUMN IF NOT EXISTS label TEXT NULL;

ALTER TABLE integration_credentials ADD COLUMN IF NOT EXISTS priority INTEGER NOT NULL DEFAULT 0;

ALTER TABLE integration_credentials ADD COLUMN IF NOT EXISTS enabled BOOL NOT NULL DEFAULT true;

-- At most one active version per key set (was: per provider).
DROP INDEX IF EXISTS integration_credentials_one_active;

CREATE UNIQUE INDEX IF NOT EXISTS integration_credentials_one_active_slot
  ON integration_credentials (provider, slot) WHERE status = 'active';

CREATE TABLE IF NOT EXISTS integration_custom_providers (
  id TEXT NOT NULL,
  label TEXT NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  fields JSONB NOT NULL DEFAULT '[]'::JSONB,
  created_by UUID NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT integration_custom_providers_pkey PRIMARY KEY (id)
);
-- Owner 2026-10-05: staff salaries in the admin ("Зарплаты"). Additive.
CREATE TABLE IF NOT EXISTS payroll_employees (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  admin_user_id UUID NULL,
  user_id UUID NULL,
  name VARCHAR(120) NOT NULL,
  role_title VARCHAR(120) NOT NULL DEFAULT '',
  amount_cents INTEGER NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'usd',
  method_note VARCHAR(300) NOT NULL DEFAULT '',
  email VARCHAR(254) NULL,
  stripe_account_id VARCHAR(64) NULL,
  stripe_payouts_enabled BOOL NOT NULL DEFAULT false,
  active BOOL NOT NULL DEFAULT true,
  created_by UUID NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT payroll_employees_pkey PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS payroll_employees_active_name_idx ON payroll_employees (active, name);

CREATE UNIQUE INDEX IF NOT EXISTS payroll_employees_user_id_key ON payroll_employees (user_id);

CREATE TABLE IF NOT EXISTS payroll_payouts (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  employee_id UUID NOT NULL,
  batch_id UUID NOT NULL,
  period VARCHAR(40) NOT NULL,
  amount_cents INTEGER NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'usd',
  method VARCHAR(20) NOT NULL DEFAULT 'manual',
  status VARCHAR(16) NOT NULL DEFAULT 'paid',
  base_cents INTEGER NOT NULL DEFAULT 0,
  commission_cents INTEGER NOT NULL DEFAULT 0,
  fee_cents INTEGER NOT NULL DEFAULT 0,
  net_cents INTEGER NOT NULL DEFAULT 0,
  transfer_id VARCHAR(64) NULL,
  failure VARCHAR(300) NULL,
  note VARCHAR(300) NULL,
  cancel_reason VARCHAR(500) NULL,
  created_by UUID NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  canceled_at TIMESTAMPTZ NULL,
  CONSTRAINT payroll_payouts_pkey PRIMARY KEY (id),
  CONSTRAINT payroll_payouts_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES payroll_employees (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX IF NOT EXISTS payroll_payouts_employee_id_created_at_idx ON payroll_payouts (employee_id, created_at DESC);

CREATE INDEX IF NOT EXISTS payroll_payouts_period_created_at_idx ON payroll_payouts (period, created_at DESC);

CREATE INDEX IF NOT EXISTS payroll_payouts_batch_id_idx ON payroll_payouts (batch_id);

CREATE TABLE IF NOT EXISTS payroll_accruals (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  employee_id UUID NOT NULL,
  source VARCHAR(24) NOT NULL,
  kind VARCHAR(24) NOT NULL DEFAULT 'commission',
  event_ref VARCHAR(120) NOT NULL,
  amount_cents INTEGER NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'usd',
  period VARCHAR(40) NOT NULL,
  note VARCHAR(300) NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'pending',
  payout_id UUID NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  paid_at TIMESTAMPTZ NULL,
  canceled_at TIMESTAMPTZ NULL,
  CONSTRAINT payroll_accruals_pkey PRIMARY KEY (id),
  CONSTRAINT payroll_accruals_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES payroll_employees (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS payroll_accruals_event_ref_key ON payroll_accruals (event_ref);

CREATE INDEX IF NOT EXISTS payroll_accruals_employee_id_status_idx ON payroll_accruals (employee_id, status);

CREATE INDEX IF NOT EXISTS payroll_accruals_payout_id_idx ON payroll_accruals (payout_id);

-- Stripe's payout cost is taken from the person's payout (owner
-- 2026-10-05); the owner can change these in Настройки.
INSERT INTO app_config (key, value, updated_at) VALUES
  ('payroll.stripe_fee_percent', '0.25'::JSONB, now()),
  ('payroll.stripe_fee_fixed_cents', '25'::JSONB, now()),
  ('payroll.stripe_monthly_fee_cents', '200'::JSONB, now())
ON CONFLICT (key) DO NOTHING;

-- Stripe Connect payouts stay off until the owner turns this on (data only).
INSERT INTO feature_flags (key, enabled, rollout_percent, description, updated_at)
VALUES ('payroll_stripe_payouts', false, 100, 'Salaries paid out through Stripe Connect (employees link a bank account or card)', now())
ON CONFLICT (key) DO NOTHING;
-- Owner 2026-10-05: where the paid translator may be used (data only).
-- translate.scope: 'all' = every zone, 'zones' = only the zones whose
-- translate.<zone> is true (Ключи и сервисы → Google Translate).
INSERT INTO "app_config" ("key", "value", "updated_at") VALUES
  ('translate.scope', '"all"'::JSONB, now()),
  ('translate.chat', 'true'::JSONB, now()),
  ('translate.posts', 'true'::JSONB, now()),
  ('translate.cases', 'true'::JSONB, now()),
  ('translate.reviews', 'true'::JSONB, now()),
  ('translate.profiles', 'true'::JSONB, now())
ON CONFLICT ("key") DO NOTHING;
-- Owner 2026-10-05: outreach (Привлечение) — leads, activities, templates.
CREATE TABLE "outreach_leads" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "kind" VARCHAR(10) NOT NULL DEFAULT 'attorney',
  "first_name" VARCHAR(80),
  "last_name" VARCHAR(80),
  "company" VARCHAR(160),
  "state_code" VARCHAR(2),
  "city" VARCHAR(80),
  "practice" VARCHAR(80),
  "phone" VARCHAR(20),
  "email" VARCHAR(254),
  "source" VARCHAR(20) NOT NULL DEFAULT 'manual',
  "source_ref" VARCHAR(64),
  "status" VARCHAR(16) NOT NULL DEFAULT 'new',
  "partner_id" UUID,
  "converted_user_id" UUID,
  "unsubscribe_token" VARCHAR(48) NOT NULL,
  "unsubscribed_at" TIMESTAMPTZ,
  "last_activity_at" TIMESTAMPTZ,
  "next_action_at" TIMESTAMPTZ,
  "note" VARCHAR(2000),
  "created_by" UUID NOT NULL,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ NOT NULL,
  CONSTRAINT "outreach_leads_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "outreach_leads_phone_key" ON "outreach_leads"("phone");

CREATE UNIQUE INDEX "outreach_leads_email_key" ON "outreach_leads"("email");

CREATE UNIQUE INDEX "outreach_leads_unsubscribe_token_key" ON "outreach_leads"("unsubscribe_token");

CREATE INDEX "outreach_leads_partner_id_status_created_at_idx" ON "outreach_leads"("partner_id", "status", "created_at");

CREATE INDEX "outreach_leads_status_created_at_idx" ON "outreach_leads"("status", "created_at");

CREATE INDEX "outreach_leads_state_code_kind_idx" ON "outreach_leads"("state_code", "kind");

CREATE INDEX "outreach_leads_converted_user_id_idx" ON "outreach_leads"("converted_user_id");

CREATE INDEX "outreach_leads_next_action_at_idx" ON "outreach_leads"("next_action_at");

ALTER TABLE "outreach_leads" ADD CONSTRAINT "outreach_leads_partner_id_fkey"
  FOREIGN KEY ("partner_id") REFERENCES "partners"("id") ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE "outreach_activities" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "lead_id" UUID NOT NULL,
  "partner_id" UUID,
  "actor_admin_id" UUID,
  "kind" VARCHAR(12) NOT NULL,
  "outcome" VARCHAR(24),
  "body" VARCHAR(4000),
  "meta" JSONB,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT "outreach_activities_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "outreach_activities_lead_id_created_at_idx" ON "outreach_activities"("lead_id", "created_at");

CREATE INDEX "outreach_activities_partner_id_kind_created_at_idx" ON "outreach_activities"("partner_id", "kind", "created_at");

CREATE INDEX "outreach_activities_created_at_idx" ON "outreach_activities"("created_at");

ALTER TABLE "outreach_activities" ADD CONSTRAINT "outreach_activities_lead_id_fkey"
  FOREIGN KEY ("lead_id") REFERENCES "outreach_leads"("id") ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE "outreach_templates" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "name" VARCHAR(80) NOT NULL,
  "kind" VARCHAR(10) NOT NULL DEFAULT 'any',
  "subject" VARCHAR(200) NOT NULL,
  "body" VARCHAR(8000) NOT NULL,
  "active" BOOL NOT NULL DEFAULT true,
  "created_by" UUID NOT NULL,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ NOT NULL,
  CONSTRAINT "outreach_templates_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "outreach_templates_active_kind_idx" ON "outreach_templates"("active", "kind");
-- Owner 2026-10-05: partners join by themselves; a request the admin
-- approves or declines tells the person.
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'partner_approved';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'partner_declined';
-- Owner 2026-10-05: the planner's own notifications — a reminder before
-- a task, a task assigned to an assistant, archived tasks about to be
-- removed. Alone in this migration: a new enum value can't be used in the
-- transaction that adds it.
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'task_reminder';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'task_assigned';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'task_purge_soon';
-- Owner 2026-10-05: the attorney's planner — many addresses and many
-- people on one task, priority, repeating tasks, reminders, assignment
-- to an assistant, a link to the chat, and the archive (finished tasks
-- are kept, then removed after tasks.archive_retention_days unless kept
-- forever).
CREATE TYPE attorney_task_priority AS ENUM ('low', 'normal', 'high', 'urgent');

CREATE TYPE attorney_task_repeat AS ENUM ('none', 'daily', 'weekdays', 'weekly', 'monthly', 'yearly');

ALTER TABLE attorney_tasks
  ADD COLUMN IF NOT EXISTS assignee_membership_id UUID NULL,
  ADD COLUMN IF NOT EXISTS conversation_id UUID NULL,
  ADD COLUMN IF NOT EXISTS priority attorney_task_priority NOT NULL DEFAULT 'normal',
  ADD COLUMN IF NOT EXISTS repeat attorney_task_repeat NOT NULL DEFAULT 'none',
  ADD COLUMN IF NOT EXISTS repeat_until TIMESTAMPTZ NULL,
  ADD COLUMN IF NOT EXISTS repeated_at TIMESTAMPTZ NULL,
  ADD COLUMN IF NOT EXISTS remind_before_min INTEGER NULL,
  ADD COLUMN IF NOT EXISTS remind_at TIMESTAMPTZ NULL,
  ADD COLUMN IF NOT EXISTS reminded_at TIMESTAMPTZ NULL,
  ADD COLUMN IF NOT EXISTS archived_at TIMESTAMPTZ NULL,
  ADD COLUMN IF NOT EXISTS keep_forever BOOL NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS purge_notice_days INTEGER NULL;

ALTER TABLE attorney_tasks
  ADD CONSTRAINT attorney_tasks_assignee_fkey FOREIGN KEY (assignee_membership_id)
  REFERENCES assistant_memberships(id) ON DELETE SET NULL ON UPDATE NO ACTION;

CREATE INDEX IF NOT EXISTS attorney_tasks_remind_idx ON attorney_tasks (remind_at);

CREATE INDEX IF NOT EXISTS attorney_tasks_archived_idx ON attorney_tasks (archived_at);

CREATE TABLE IF NOT EXISTS attorney_task_places (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  task_id UUID NOT NULL,
  position INTEGER NOT NULL DEFAULT 0,
  label VARCHAR(80) NULL,
  address VARCHAR(300) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT attorney_task_places_pkey PRIMARY KEY (id),
  CONSTRAINT attorney_task_places_task_fkey FOREIGN KEY (task_id) REFERENCES attorney_tasks(id) ON DELETE CASCADE ON UPDATE NO ACTION
);
CREATE INDEX attorney_task_places_task_idx ON attorney_task_places (task_id, position);

CREATE TABLE IF NOT EXISTS attorney_task_people (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  task_id UUID NOT NULL,
  position INTEGER NOT NULL DEFAULT 0,
  user_id UUID NULL,
  role VARCHAR(60) NULL,
  name VARCHAR(120) NOT NULL,
  phone VARCHAR(20) NULL,
  email VARCHAR(254) NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT attorney_task_people_pkey PRIMARY KEY (id),
  CONSTRAINT attorney_task_people_task_fkey FOREIGN KEY (task_id) REFERENCES attorney_tasks(id) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT attorney_task_people_user_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL ON UPDATE NO ACTION
);
CREATE INDEX attorney_task_people_task_idx ON attorney_task_people (task_id, position);
CREATE INDEX attorney_task_people_user_idx ON attorney_task_people (user_id);

-- The single address / contact of existing tasks becomes the first place
-- and the first person.
INSERT INTO attorney_task_places (task_id, position, address)
SELECT id, 0, substring(location, 1, 300)
FROM attorney_tasks
WHERE location IS NOT NULL AND trim(location) <> '';

INSERT INTO attorney_task_people (task_id, position, name, phone, email)
SELECT id, 0,
       COALESCE(NULLIF(trim(contact_name), ''), contact_phone, contact_email),
       contact_phone, contact_email
FROM attorney_tasks
WHERE COALESCE(NULLIF(trim(contact_name), ''), contact_phone, contact_email) IS NOT NULL;

-- Finished tasks already in the history are the archive from today.
UPDATE attorney_tasks SET archived_at = COALESCE(done_at, updated_at)
WHERE status IN ('done', 'not_done', 'cancelled') AND archived_at IS NULL;

-- Reminders: tasks with a time get the default one (at the time).
UPDATE attorney_tasks SET remind_before_min = 0, remind_at = due_at
WHERE due_at IS NOT NULL AND status IN ('open', 'taken') AND due_at > now();

ALTER TABLE attorney_tasks DROP COLUMN IF EXISTS location;

ALTER TABLE attorney_tasks DROP COLUMN IF EXISTS contact_name;

ALTER TABLE attorney_tasks DROP COLUMN IF EXISTS contact_phone;

ALTER TABLE attorney_tasks DROP COLUMN IF EXISTS contact_email;
-- Owner 2026-10-05 (attorney trust levels): a client can report an attorney
-- who took money and vanished or used someone else's bar number.
ALTER TYPE report_reason ADD VALUE IF NOT EXISTS 'fraud';
-- Owner 2026-10-05: attorney trust levels. The simple sign-up stays (state +
-- bar number + sworn statement), but what LawBid shows to clients and what
-- the attorney may do (bids, receiving money, the blue check) now follow a
-- computed level: 0 self-attested, 1 license confirmed by the state
-- registry or a verifier, 2 identity confirmed (Stripe KYC with a matching
-- legal name, or staff-checked documents), 3 both. Holds (a client's fraud
-- complaint, a name mismatch, a duplicate bar-number claim) close the
-- payment and bid gates whatever the level, until a verifier looks.

ALTER TABLE "attorney_profiles" ADD COLUMN IF NOT EXISTS "trust_level" SMALLINT NOT NULL DEFAULT 0;

ALTER TABLE "attorney_profiles" ADD COLUMN IF NOT EXISTS "trust_badge" BOOL NOT NULL DEFAULT false;

CREATE TABLE IF NOT EXISTS "attorney_trust" (
    "attorney_id" UUID NOT NULL,
    "level" SMALLINT NOT NULL DEFAULT 0,
    "license_confirmed_at" TIMESTAMPTZ,
    "license_confirmed_by" VARCHAR(16),
    "license_confirmed_note" VARCHAR(500),
    "documents_verified_at" TIMESTAMPTZ,
    "documents_verified_by" UUID,
    "stripe_kyc_at" TIMESTAMPTZ,
    "stripe_charges_enabled" BOOL NOT NULL DEFAULT false,
    "stripe_legal_name" VARCHAR(200),
    "stripe_business_type" VARCHAR(24),
    "stripe_company_name" VARCHAR(200),
    "stripe_company_domain" VARCHAR(200),
    "stripe_representative" VARCHAR(200),
    "name_check" VARCHAR(16) NOT NULL DEFAULT 'unknown',
    "name_checked_at" TIMESTAMPTZ,
    "firm_link_status" VARCHAR(16) NOT NULL DEFAULT 'none',
    "firm_link_source" VARCHAR(16),
    "firm_link_at" TIMESTAMPTZ,
    "firm_link_note" VARCHAR(500),
    "firm_email_domain" VARCHAR(200),
    "firm_email_verified_at" TIMESTAMPTZ,
    "payments_hold" VARCHAR(32),
    "payments_hold_at" TIMESTAMPTZ,
    "bids_hold" VARCHAR(32),
    "bids_hold_at" TIMESTAMPTZ,
    "hold_note" VARCHAR(500),
    "complaints_total" INTEGER NOT NULL DEFAULT 0,
    "duplicate_claims" INTEGER NOT NULL DEFAULT 0,
    "payout_delay_days" SMALLINT,
    "payout_delay_synced_at" TIMESTAMPTZ,
    "computed_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "attorney_trust_pkey" PRIMARY KEY ("attorney_id")
);

CREATE INDEX IF NOT EXISTS "attorney_trust_level_idx" ON "attorney_trust"("level");

CREATE INDEX IF NOT EXISTS "attorney_trust_payments_hold_idx" ON "attorney_trust"("payments_hold");

CREATE INDEX IF NOT EXISTS "attorney_trust_bids_hold_idx" ON "attorney_trust"("bids_hold");

ALTER TABLE "attorney_trust" ADD CONSTRAINT "attorney_trust_attorney_id_fkey" FOREIGN KEY ("attorney_id") REFERENCES "attorney_profiles"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE IF NOT EXISTS "attorney_trust_events" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "attorney_id" UUID NOT NULL,
    "kind" VARCHAR(48) NOT NULL,
    "from_level" SMALLINT,
    "to_level" SMALLINT,
    "actor_type" VARCHAR(16) NOT NULL DEFAULT 'system',
    "actor_id" UUID,
    "details" JSONB NOT NULL DEFAULT '{}',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "attorney_trust_events_pkey" PRIMARY KEY ("id")
);

CREATE INDEX IF NOT EXISTS "attorney_trust_events_attorney_id_created_at_idx" ON "attorney_trust_events"("attorney_id", "created_at" DESC);

CREATE INDEX IF NOT EXISTS "attorney_trust_events_kind_created_at_idx" ON "attorney_trust_events"("kind", "created_at" DESC);

ALTER TABLE "attorney_trust_events" ADD CONSTRAINT "attorney_trust_events_attorney_id_fkey" FOREIGN KEY ("attorney_id") REFERENCES "attorney_profiles"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;
-- Owner 2026-10-05 («Борьба с мошенниками»): a verifier's clearance opens
-- the badge and payments for good; the last "request more documents".
ALTER TABLE "attorney_trust" ADD COLUMN "staff_cleared_at" TIMESTAMPTZ;

ALTER TABLE "attorney_trust" ADD COLUMN "staff_cleared_by" UUID;

ALTER TABLE "attorney_trust" ADD COLUMN "staff_cleared_note" VARCHAR(500);

ALTER TABLE "attorney_trust" ADD COLUMN "documents_requested_at" TIMESTAMPTZ;

ALTER TABLE "attorney_trust" ADD COLUMN "documents_requested_template" VARCHAR(32);
-- Owner 2026-10-05 07:00 («Борьба с мошенниками»): a rejected or blocked bar
-- number cannot register again under another name or account; staff can
-- unblock with a reason. History is append-only.
CREATE TABLE "bar_number_blocks" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "state_code" CHAR(2) NOT NULL,
  "bar_number" TEXT NOT NULL,
  "bar_key" TEXT NOT NULL,
  "active" BOOL NOT NULL DEFAULT true,
  "reason" VARCHAR(500) NOT NULL,
  "source" VARCHAR(32) NOT NULL,
  "attorney_id" UUID,
  "blocked_by" UUID,
  "blocked_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "block_contacts" BOOL NOT NULL DEFAULT false,
  "email_lower" TEXT,
  "phone_e164" TEXT,
  "unblocked_at" TIMESTAMPTZ,
  "unblocked_by" UUID,
  "unblock_reason" VARCHAR(500),
  "attempts" INTEGER NOT NULL DEFAULT 0,
  "last_attempt_at" TIMESTAMPTZ,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ NOT NULL,
  CONSTRAINT "bar_number_blocks_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "bar_number_blocks_state_code_bar_key_key" ON "bar_number_blocks"("state_code", "bar_key");

CREATE INDEX "bar_number_blocks_active_blocked_at_idx" ON "bar_number_blocks"("active", "blocked_at" DESC);

CREATE INDEX "bar_number_blocks_email_lower_idx" ON "bar_number_blocks"("email_lower");

CREATE INDEX "bar_number_blocks_phone_e164_idx" ON "bar_number_blocks"("phone_e164");

CREATE TABLE "bar_number_block_events" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "block_id" UUID NOT NULL,
  "kind" VARCHAR(32) NOT NULL,
  "actor_type" VARCHAR(16) NOT NULL DEFAULT 'system',
  "actor_id" UUID,
  "reason" VARCHAR(500),
  "details" JSONB NOT NULL DEFAULT '{}',
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT "bar_number_block_events_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "bar_number_block_events_block_id_created_at_idx" ON "bar_number_block_events"("block_id", "created_at" DESC);

ALTER TABLE "bar_number_block_events" ADD CONSTRAINT "bar_number_block_events_block_id_fkey" FOREIGN KEY ("block_id") REFERENCES "bar_number_blocks"("id") ON DELETE CASCADE ON UPDATE CASCADE;
-- Owner 2026-10-05: support 24/7 (SLA, auto-assignment, ready answers,
-- shifts, after-hours auto-reply) and staff rewards («Лучший сотрудник»).
-- Additive only.
ALTER TABLE "support_tickets"
  ADD COLUMN "assigned_at" TIMESTAMPTZ,
  ADD COLUMN "first_response_at" TIMESTAMPTZ,
  ADD COLUMN "first_response_by" UUID,
  ADD COLUMN "resolved_by" UUID,
  ADD COLUMN "sla_due_at" TIMESTAMPTZ,
  ADD COLUMN "sla_breached_at" TIMESTAMPTZ;

CREATE INDEX "support_tickets_sla_due_at_idx" ON "support_tickets"("sla_due_at");

ALTER TABLE "support_messages" ADD COLUMN "auto" BOOL NOT NULL DEFAULT false;

CREATE TABLE "support_macros" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "title" VARCHAR(120) NOT NULL,
    "body" VARCHAR(5000) NOT NULL,
    "category" VARCHAR(20),
    "active" BOOL NOT NULL DEFAULT true,
    "uses" INTEGER NOT NULL DEFAULT 0,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "support_macros_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "support_macros_active_title_idx" ON "support_macros"("active", "title");

CREATE TABLE "support_agents" (
    "admin_id" UUID NOT NULL,
    "on_shift" BOOL NOT NULL DEFAULT false,
    "max_open" INTEGER NOT NULL DEFAULT 25,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "support_agents_pkey" PRIMARY KEY ("admin_id")
);

CREATE TABLE "staff_rewards" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "period" VARCHAR(20) NOT NULL,
    "department" VARCHAR(24) NOT NULL,
    "admin_id" UUID NOT NULL,
    "rank" INTEGER NOT NULL DEFAULT 1,
    "score" INTEGER NOT NULL DEFAULT 0,
    "prize" VARCHAR(200) NOT NULL DEFAULT '',
    "bonus_cents" INTEGER NOT NULL DEFAULT 0,
    "currency" VARCHAR(3) NOT NULL DEFAULT 'usd',
    "accrual_id" UUID,
    "auto" BOOL NOT NULL DEFAULT false,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "staff_rewards_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "staff_rewards_period_department_admin_id_key" ON "staff_rewards"("period", "department", "admin_id");

CREATE INDEX "staff_rewards_admin_id_created_at_idx" ON "staff_rewards"("admin_id", "created_at" DESC);

-- Tunables (data only; the admin changes them in Связь → Поддержка and
-- Люди → Поощрения). Rewards stay off until the owner switches them on.
INSERT INTO "app_config" ("key", "value", "updated_at") VALUES
  ('support.auto_assign', 'true'::JSONB, now()),
  ('support.sla_first_response_minutes', '60'::JSONB, now()),
  ('support.sla_urgent_minutes', '15'::JSONB, now()),
  ('support.sla_alerts', 'true'::JSONB, now()),
  ('support.escalate_on_breach', 'true'::JSONB, now()),
  ('support.always_open', 'true'::JSONB, now()),
  ('support.open_days', '[1,2,3,4,5]'::JSONB, now()),
  ('support.open_from_hour', '9'::JSONB, now()),
  ('support.open_to_hour', '18'::JSONB, now()),
  ('support.timezone', '"America/Chicago"'::JSONB, now()),
  ('support.auto_reply', 'true'::JSONB, now()),
  ('support.auto_close_resolved_days', '7'::JSONB, now()),
  ('rewards.enabled', 'false'::JSONB, now()),
  ('rewards.auto_award', 'true'::JSONB, now()),
  ('rewards.period', '"month"'::JSONB, now())
ON CONFLICT ("key") DO NOTHING;
-- Owner 2026-10-05: case urgency as a level or a concrete date. New
-- levels (within_month, very_urgent) and `by_date`, which keeps the date
-- in deadline_at and what it is in deadline_kind. Additive: existing
-- flexible / soon / urgent values stay valid.
ALTER TABLE cases ADD COLUMN IF NOT EXISTS deadline_at DATE;

ALTER TABLE cases ADD COLUMN IF NOT EXISTS deadline_kind TEXT;

ALTER TABLE cases DROP CONSTRAINT IF EXISTS cases_urgency_check;

ALTER TABLE cases ADD CONSTRAINT cases_urgency_check
  CHECK (urgency IS NULL OR urgency IN
    ('flexible', 'within_month', 'soon', 'urgent', 'very_urgent', 'by_date'));

ALTER TABLE cases ADD CONSTRAINT cases_deadline_check
  CHECK (CASE WHEN urgency = 'by_date' THEN deadline_at IS NOT NULL
              ELSE deadline_at IS NULL END);

ALTER TABLE cases ADD CONSTRAINT cases_deadline_kind_check
  CHECK (deadline_kind IS NULL OR (deadline_at IS NOT NULL AND deadline_kind IN
    ('court_hearing', 'filing_deadline', 'meeting', 'signing', 'other')));

CREATE INDEX IF NOT EXISTS cases_deadline_at_idx ON cases (deadline_at);

-- Attorneys may limit new-case alerts to urgent cases.
ALTER TABLE attorney_profiles
  ADD COLUMN IF NOT EXISTS new_case_alerts_urgent_only BOOL NOT NULL DEFAULT false;

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'case_deadline_soon';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'case_deadline_today';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'case_deadline_passed';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'case_deadline_changed';

ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'new_urgent_case';
-- Owner 2026-10-05: countries LawBid works in, switched on one by one in
-- the admin (Система → Страны), like the app languages. All ISO 3166-1
-- countries are listed; only the United States starts switched on.
CREATE TABLE "countries" (
    "code" CHAR(2) NOT NULL,
    "name" TEXT NOT NULL,
    "is_enabled" BOOL NOT NULL DEFAULT false,
    "calling_code" TEXT NOT NULL,
    "currency" CHAR(3) NOT NULL,
    "language" TEXT NOT NULL DEFAULT 'en',
    "region_kind" TEXT NOT NULL DEFAULT 'region',
    "timezone" TEXT,
    "stripe_supported" BOOL NOT NULL DEFAULT false,
    "sort" INTEGER NOT NULL,
    "enabled_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "countries_pkey" PRIMARY KEY ("code")
);

CREATE INDEX "countries_is_enabled_sort_idx" ON "countries"("is_enabled", "sort");

-- People who tried LawBid in a country that is not on yet; e-mailed
-- automatically when it is switched on.
CREATE TABLE "country_waitlist" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "country_code" CHAR(2) NOT NULL,
    "email" TEXT NOT NULL,
    "locale" TEXT NOT NULL DEFAULT 'en',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "notified_at" TIMESTAMPTZ,

    CONSTRAINT "country_waitlist_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "country_waitlist_country_code_email_key" ON "country_waitlist"("country_code", "email");

CREATE INDEX "country_waitlist_country_code_notified_at_idx" ON "country_waitlist"("country_code", "notified_at");

ALTER TABLE "country_waitlist" ADD CONSTRAINT "country_waitlist_country_code_fkey" FOREIGN KEY ("country_code") REFERENCES "countries"("code") ON DELETE CASCADE ON UPDATE CASCADE;

-- Reference data (src/common/reference-data/countries.ts).
INSERT INTO "countries" ("code", "name", "is_enabled", "calling_code", "currency", "language", "region_kind", "timezone", "stripe_supported", "sort") VALUES
  ('US', 'United States', true, '1', 'USD', 'en', 'state', 'America/New_York', true, 1),
  ('CA', 'Canada', false, '1', 'CAD', 'en', 'province', 'America/Toronto', true, 2),
  ('MX', 'Mexico', false, '52', 'MXN', 'es', 'state', 'America/Mexico_City', true, 3),
  ('AF', 'Afghanistan', false, '93', 'AFN', 'fa', 'region', NULL, false, 4),
  ('AX', 'Åland Islands', false, '358', 'EUR', 'en', 'region', NULL, false, 5),
  ('AL', 'Albania', false, '355', 'ALL', 'en', 'region', NULL, false, 6),
  ('DZ', 'Algeria', false, '213', 'DZD', 'ar', 'region', NULL, false, 7),
  ('AS', 'American Samoa', false, '1', 'USD', 'en', 'region', NULL, false, 8),
  ('AD', 'Andorra', false, '376', 'EUR', 'en', 'region', NULL, false, 9),
  ('AO', 'Angola', false, '244', 'AOA', 'en', 'region', NULL, false, 10),
  ('AI', 'Anguilla', false, '1', 'XCD', 'en', 'region', NULL, false, 11),
  ('AG', 'Antigua & Barbuda', false, '1', 'XCD', 'en', 'region', NULL, false, 12),
  ('AR', 'Argentina', false, '54', 'ARS', 'es', 'region', NULL, false, 13),
  ('AM', 'Armenia', false, '374', 'AMD', 'hy', 'region', NULL, false, 14),
  ('AW', 'Aruba', false, '297', 'AWG', 'en', 'region', NULL, false, 15),
  ('AU', 'Australia', false, '61', 'AUD', 'en', 'region', NULL, true, 16),
  ('AT', 'Austria', false, '43', 'EUR', 'de', 'region', NULL, true, 17),
  ('AZ', 'Azerbaijan', false, '994', 'AZN', 'az', 'region', NULL, false, 18),
  ('BS', 'Bahamas', false, '1', 'BSD', 'en', 'region', NULL, false, 19),
  ('BH', 'Bahrain', false, '973', 'BHD', 'ar', 'region', NULL, false, 20),
  ('BD', 'Bangladesh', false, '880', 'BDT', 'bn', 'region', NULL, false, 21),
  ('BB', 'Barbados', false, '1', 'BBD', 'en', 'region', NULL, false, 22),
  ('BY', 'Belarus', false, '375', 'BYN', 'ru', 'region', NULL, false, 23),
  ('BE', 'Belgium', false, '32', 'EUR', 'fr', 'region', NULL, true, 24),
  ('BZ', 'Belize', false, '501', 'BZD', 'en', 'region', NULL, false, 25),
  ('BJ', 'Benin', false, '229', 'XOF', 'en', 'region', NULL, false, 26),
  ('BM', 'Bermuda', false, '1', 'BMD', 'en', 'region', NULL, false, 27),
  ('BT', 'Bhutan', false, '975', 'BTN', 'en', 'region', NULL, false, 28),
  ('BO', 'Bolivia', false, '591', 'BOB', 'es', 'region', NULL, false, 29),
  ('BA', 'Bosnia & Herzegovina', false, '387', 'BAM', 'en', 'region', NULL, false, 30),
  ('BW', 'Botswana', false, '267', 'BWP', 'en', 'region', NULL, false, 31),
  ('BR', 'Brazil', false, '55', 'BRL', 'pt', 'region', NULL, true, 32),
  ('IO', 'British Indian Ocean Territory', false, '246', 'USD', 'en', 'region', NULL, false, 33),
  ('VG', 'British Virgin Islands', false, '1', 'USD', 'en', 'region', NULL, false, 34),
  ('BN', 'Brunei', false, '673', 'BND', 'en', 'region', NULL, false, 35),
  ('BG', 'Bulgaria', false, '359', 'BGN', 'bg', 'region', NULL, true, 36),
  ('BF', 'Burkina Faso', false, '226', 'XOF', 'en', 'region', NULL, false, 37),
  ('BI', 'Burundi', false, '257', 'BIF', 'en', 'region', NULL, false, 38),
  ('KH', 'Cambodia', false, '855', 'KHR', 'en', 'region', NULL, false, 39),
  ('CM', 'Cameroon', false, '237', 'XAF', 'en', 'region', NULL, false, 40),
  ('CV', 'Cape Verde', false, '238', 'CVE', 'en', 'region', NULL, false, 41),
  ('BQ', 'Caribbean Netherlands', false, '599', 'USD', 'en', 'region', NULL, false, 42),
  ('KY', 'Cayman Islands', false, '1', 'KYD', 'en', 'region', NULL, false, 43),
  ('CF', 'Central African Republic', false, '236', 'XAF', 'en', 'region', NULL, false, 44),
  ('TD', 'Chad', false, '235', 'XAF', 'en', 'region', NULL, false, 45),
  ('CL', 'Chile', false, '56', 'CLP', 'es', 'region', NULL, false, 46),
  ('CN', 'China', false, '86', 'CNY', 'zh', 'region', NULL, false, 47),
  ('CX', 'Christmas Island', false, '61', 'AUD', 'en', 'region', NULL, false, 48),
  ('CC', 'Cocos (Keeling) Islands', false, '61', 'AUD', 'en', 'region', NULL, false, 49),
  ('CO', 'Colombia', false, '57', 'COP', 'es', 'region', NULL, false, 50),
  ('KM', 'Comoros', false, '269', 'KMF', 'en', 'region', NULL, false, 51),
  ('CG', 'Congo - Brazzaville', false, '242', 'XAF', 'en', 'region', NULL, false, 52),
  ('CD', 'Congo - Kinshasa', false, '243', 'CDF', 'en', 'region', NULL, false, 53),
  ('CK', 'Cook Islands', false, '682', 'NZD', 'en', 'region', NULL, false, 54),
  ('CR', 'Costa Rica', false, '506', 'CRC', 'es', 'region', NULL, false, 55),
  ('CI', 'Côte d’Ivoire', false, '225', 'XOF', 'en', 'region', NULL, false, 56),
  ('HR', 'Croatia', false, '385', 'EUR', 'hr', 'region', NULL, true, 57),
  ('CU', 'Cuba', false, '53', 'CUP', 'es', 'region', NULL, false, 58),
  ('CW', 'Curaçao', false, '599', 'XCG', 'en', 'region', NULL, false, 59),
  ('CY', 'Cyprus', false, '357', 'EUR', 'en', 'region', NULL, true, 60),
  ('CZ', 'Czechia', false, '420', 'CZK', 'cs', 'region', NULL, true, 61),
  ('DK', 'Denmark', false, '45', 'DKK', 'da', 'region', NULL, true, 62),
  ('DJ', 'Djibouti', false, '253', 'DJF', 'en', 'region', NULL, false, 63),
  ('DM', 'Dominica', false, '1', 'XCD', 'en', 'region', NULL, false, 64),
  ('DO', 'Dominican Republic', false, '1', 'DOP', 'es', 'region', NULL, false, 65),
  ('EC', 'Ecuador', false, '593', 'USD', 'es', 'region', NULL, false, 66),
  ('EG', 'Egypt', false, '20', 'EGP', 'ar', 'region', NULL, false, 67),
  ('SV', 'El Salvador', false, '503', 'USD', 'es', 'region', NULL, false, 68),
  ('GQ', 'Equatorial Guinea', false, '240', 'XAF', 'en', 'region', NULL, false, 69),
  ('ER', 'Eritrea', false, '291', 'ERN', 'en', 'region', NULL, false, 70),
  ('EE', 'Estonia', false, '372', 'EUR', 'et', 'region', NULL, true, 71),
  ('SZ', 'Eswatini', false, '268', 'SZL', 'en', 'region', NULL, false, 72),
  ('ET', 'Ethiopia', false, '251', 'ETB', 'en', 'region', NULL, false, 73),
  ('FK', 'Falkland Islands', false, '500', 'FKP', 'en', 'region', NULL, false, 74),
  ('FO', 'Faroe Islands', false, '298', 'DKK', 'en', 'region', NULL, false, 75),
  ('FJ', 'Fiji', false, '679', 'FJD', 'en', 'region', NULL, false, 76),
  ('FI', 'Finland', false, '358', 'EUR', 'fi', 'region', NULL, true, 77),
  ('FR', 'France', false, '33', 'EUR', 'fr', 'region', NULL, true, 78),
  ('GF', 'French Guiana', false, '594', 'EUR', 'en', 'region', NULL, false, 79),
  ('PF', 'French Polynesia', false, '689', 'XPF', 'en', 'region', NULL, false, 80),
  ('GA', 'Gabon', false, '241', 'XAF', 'en', 'region', NULL, false, 81),
  ('GM', 'Gambia', false, '220', 'GMD', 'en', 'region', NULL, false, 82),
  ('GE', 'Georgia', false, '995', 'GEL', 'ka', 'region', NULL, false, 83),
  ('DE', 'Germany', false, '49', 'EUR', 'de', 'region', NULL, true, 84),
  ('GH', 'Ghana', false, '233', 'GHS', 'en', 'region', NULL, false, 85),
  ('GI', 'Gibraltar', false, '350', 'GIP', 'en', 'region', NULL, true, 86),
  ('GR', 'Greece', false, '30', 'EUR', 'el', 'region', NULL, true, 87),
  ('GL', 'Greenland', false, '299', 'DKK', 'en', 'region', NULL, false, 88),
  ('GD', 'Grenada', false, '1', 'XCD', 'en', 'region', NULL, false, 89),
  ('GP', 'Guadeloupe', false, '590', 'EUR', 'en', 'region', NULL, false, 90),
  ('GU', 'Guam', false, '1', 'USD', 'en', 'region', NULL, false, 91),
  ('GT', 'Guatemala', false, '502', 'GTQ', 'es', 'region', NULL, false, 92),
  ('GG', 'Guernsey', false, '44', 'GBP', 'en', 'region', NULL, false, 93),
  ('GN', 'Guinea', false, '224', 'GNF', 'en', 'region', NULL, false, 94),
  ('GW', 'Guinea-Bissau', false, '245', 'XOF', 'en', 'region', NULL, false, 95),
  ('GY', 'Guyana', false, '592', 'GYD', 'en', 'region', NULL, false, 96),
  ('HT', 'Haiti', false, '509', 'HTG', 'en', 'region', NULL, false, 97),
  ('HN', 'Honduras', false, '504', 'HNL', 'es', 'region', NULL, false, 98),
  ('HK', 'Hong Kong SAR China', false, '852', 'HKD', 'zh', 'region', NULL, true, 99),
  ('HU', 'Hungary', false, '36', 'HUF', 'hu', 'region', NULL, true, 100),
  ('IS', 'Iceland', false, '354', 'ISK', 'en', 'region', NULL, false, 101),
  ('IN', 'India', false, '91', 'INR', 'hi', 'region', NULL, false, 102),
  ('ID', 'Indonesia', false, '62', 'IDR', 'id', 'region', NULL, false, 103),
  ('IR', 'Iran', false, '98', 'IRR', 'fa', 'region', NULL, false, 104),
  ('IQ', 'Iraq', false, '964', 'IQD', 'ar', 'region', NULL, false, 105),
  ('IE', 'Ireland', false, '353', 'EUR', 'en', 'region', NULL, true, 106),
  ('IM', 'Isle of Man', false, '44', 'GBP', 'en', 'region', NULL, false, 107),
  ('IL', 'Israel', false, '972', 'ILS', 'he', 'region', NULL, false, 108),
  ('IT', 'Italy', false, '39', 'EUR', 'it', 'region', NULL, true, 109),
  ('JM', 'Jamaica', false, '1', 'JMD', 'en', 'region', NULL, false, 110),
  ('JP', 'Japan', false, '81', 'JPY', 'ja', 'region', NULL, true, 111),
  ('JE', 'Jersey', false, '44', 'GBP', 'en', 'region', NULL, false, 112),
  ('JO', 'Jordan', false, '962', 'JOD', 'ar', 'region', NULL, false, 113),
  ('KZ', 'Kazakhstan', false, '7', 'KZT', 'ru', 'region', NULL, false, 114),
  ('KE', 'Kenya', false, '254', 'KES', 'en', 'region', NULL, false, 115),
  ('KI', 'Kiribati', false, '686', 'AUD', 'en', 'region', NULL, false, 116),
  ('XK', 'Kosovo', false, '383', 'EUR', 'en', 'region', NULL, false, 117),
  ('KW', 'Kuwait', false, '965', 'KWD', 'ar', 'region', NULL, false, 118),
  ('KG', 'Kyrgyzstan', false, '996', 'KGS', 'ru', 'region', NULL, false, 119),
  ('LA', 'Laos', false, '856', 'LAK', 'en', 'region', NULL, false, 120),
  ('LV', 'Latvia', false, '371', 'EUR', 'lv', 'region', NULL, true, 121),
  ('LB', 'Lebanon', false, '961', 'LBP', 'ar', 'region', NULL, false, 122),
  ('LS', 'Lesotho', false, '266', 'LSL', 'en', 'region', NULL, false, 123),
  ('LR', 'Liberia', false, '231', 'LRD', 'en', 'region', NULL, false, 124),
  ('LY', 'Libya', false, '218', 'LYD', 'en', 'region', NULL, false, 125),
  ('LI', 'Liechtenstein', false, '423', 'CHF', 'en', 'region', NULL, true, 126),
  ('LT', 'Lithuania', false, '370', 'EUR', 'lt', 'region', NULL, true, 127),
  ('LU', 'Luxembourg', false, '352', 'EUR', 'en', 'region', NULL, true, 128),
  ('MO', 'Macao SAR China', false, '853', 'MOP', 'en', 'region', NULL, false, 129),
  ('MG', 'Madagascar', false, '261', 'MGA', 'en', 'region', NULL, false, 130),
  ('MW', 'Malawi', false, '265', 'MWK', 'en', 'region', NULL, false, 131),
  ('MY', 'Malaysia', false, '60', 'MYR', 'ms', 'region', NULL, false, 132),
  ('MV', 'Maldives', false, '960', 'MVR', 'en', 'region', NULL, false, 133),
  ('ML', 'Mali', false, '223', 'XOF', 'en', 'region', NULL, false, 134),
  ('MT', 'Malta', false, '356', 'EUR', 'en', 'region', NULL, true, 135),
  ('MH', 'Marshall Islands', false, '692', 'USD', 'en', 'region', NULL, false, 136),
  ('MQ', 'Martinique', false, '596', 'EUR', 'en', 'region', NULL, false, 137),
  ('MR', 'Mauritania', false, '222', 'MRU', 'en', 'region', NULL, false, 138),
  ('MU', 'Mauritius', false, '230', 'MUR', 'en', 'region', NULL, false, 139),
  ('YT', 'Mayotte', false, '262', 'EUR', 'en', 'region', NULL, false, 140),
  ('FM', 'Micronesia', false, '691', 'USD', 'en', 'region', NULL, false, 141),
  ('MD', 'Moldova', false, '373', 'MDL', 'en', 'region', NULL, false, 142),
  ('MC', 'Monaco', false, '377', 'EUR', 'en', 'region', NULL, false, 143),
  ('MN', 'Mongolia', false, '976', 'MNT', 'en', 'region', NULL, false, 144),
  ('ME', 'Montenegro', false, '382', 'EUR', 'en', 'region', NULL, false, 145),
  ('MS', 'Montserrat', false, '1', 'XCD', 'en', 'region', NULL, false, 146),
  ('MA', 'Morocco', false, '212', 'MAD', 'ar', 'region', NULL, false, 147),
  ('MZ', 'Mozambique', false, '258', 'MZN', 'en', 'region', NULL, false, 148),
  ('MM', 'Myanmar (Burma)', false, '95', 'MMK', 'en', 'region', NULL, false, 149),
  ('NA', 'Namibia', false, '264', 'NAD', 'en', 'region', NULL, false, 150),
  ('NR', 'Nauru', false, '674', 'AUD', 'en', 'region', NULL, false, 151),
  ('NP', 'Nepal', false, '977', 'NPR', 'en', 'region', NULL, false, 152),
  ('NL', 'Netherlands', false, '31', 'EUR', 'nl', 'region', NULL, true, 153),
  ('NC', 'New Caledonia', false, '687', 'XPF', 'en', 'region', NULL, false, 154),
  ('NZ', 'New Zealand', false, '64', 'NZD', 'en', 'region', NULL, true, 155),
  ('NI', 'Nicaragua', false, '505', 'NIO', 'es', 'region', NULL, false, 156),
  ('NE', 'Niger', false, '227', 'XOF', 'en', 'region', NULL, false, 157),
  ('NG', 'Nigeria', false, '234', 'NGN', 'en', 'region', NULL, false, 158),
  ('NU', 'Niue', false, '683', 'NZD', 'en', 'region', NULL, false, 159),
  ('NF', 'Norfolk Island', false, '672', 'AUD', 'en', 'region', NULL, false, 160),
  ('KP', 'North Korea', false, '850', 'KPW', 'en', 'region', NULL, false, 161),
  ('MK', 'North Macedonia', false, '389', 'MKD', 'en', 'region', NULL, false, 162),
  ('MP', 'Northern Mariana Islands', false, '1', 'USD', 'en', 'region', NULL, false, 163),
  ('NO', 'Norway', false, '47', 'NOK', 'nb', 'region', NULL, true, 164),
  ('OM', 'Oman', false, '968', 'OMR', 'ar', 'region', NULL, false, 165),
  ('PK', 'Pakistan', false, '92', 'PKR', 'ur', 'region', NULL, false, 166),
  ('PW', 'Palau', false, '680', 'USD', 'en', 'region', NULL, false, 167),
  ('PS', 'Palestinian Territories', false, '970', 'ILS', 'en', 'region', NULL, false, 168),
  ('PA', 'Panama', false, '507', 'PAB', 'es', 'region', NULL, false, 169),
  ('PG', 'Papua New Guinea', false, '675', 'PGK', 'en', 'region', NULL, false, 170),
  ('PY', 'Paraguay', false, '595', 'PYG', 'es', 'region', NULL, false, 171),
  ('PE', 'Peru', false, '51', 'PEN', 'es', 'region', NULL, false, 172),
  ('PH', 'Philippines', false, '63', 'PHP', 'en', 'region', NULL, false, 173),
  ('PL', 'Poland', false, '48', 'PLN', 'pl', 'region', NULL, true, 174),
  ('PT', 'Portugal', false, '351', 'EUR', 'pt', 'region', NULL, true, 175),
  ('PR', 'Puerto Rico', false, '1', 'USD', 'es', 'region', NULL, false, 176),
  ('QA', 'Qatar', false, '974', 'QAR', 'ar', 'region', NULL, false, 177),
  ('RE', 'Réunion', false, '262', 'EUR', 'en', 'region', NULL, false, 178),
  ('RO', 'Romania', false, '40', 'RON', 'ro', 'region', NULL, true, 179),
  ('RU', 'Russia', false, '7', 'RUB', 'ru', 'region', NULL, false, 180),
  ('RW', 'Rwanda', false, '250', 'RWF', 'en', 'region', NULL, false, 181),
  ('WS', 'Samoa', false, '685', 'WST', 'en', 'region', NULL, false, 182),
  ('SM', 'San Marino', false, '378', 'EUR', 'en', 'region', NULL, false, 183),
  ('ST', 'São Tomé & Príncipe', false, '239', 'STN', 'en', 'region', NULL, false, 184),
  ('SA', 'Saudi Arabia', false, '966', 'SAR', 'ar', 'region', NULL, false, 185),
  ('SN', 'Senegal', false, '221', 'XOF', 'en', 'region', NULL, false, 186),
  ('RS', 'Serbia', false, '381', 'RSD', 'sr', 'region', NULL, false, 187),
  ('SC', 'Seychelles', false, '248', 'SCR', 'en', 'region', NULL, false, 188),
  ('SL', 'Sierra Leone', false, '232', 'SLE', 'en', 'region', NULL, false, 189),
  ('SG', 'Singapore', false, '65', 'SGD', 'en', 'region', NULL, true, 190),
  ('SX', 'Sint Maarten', false, '1', 'XCG', 'en', 'region', NULL, false, 191),
  ('SK', 'Slovakia', false, '421', 'EUR', 'sk', 'region', NULL, true, 192),
  ('SI', 'Slovenia', false, '386', 'EUR', 'sl', 'region', NULL, true, 193),
  ('SB', 'Solomon Islands', false, '677', 'SBD', 'en', 'region', NULL, false, 194),
  ('SO', 'Somalia', false, '252', 'SOS', 'en', 'region', NULL, false, 195),
  ('ZA', 'South Africa', false, '27', 'ZAR', 'en', 'region', NULL, false, 196),
  ('KR', 'South Korea', false, '82', 'KRW', 'ko', 'region', NULL, false, 197),
  ('SS', 'South Sudan', false, '211', 'SSP', 'en', 'region', NULL, false, 198),
  ('ES', 'Spain', false, '34', 'EUR', 'es', 'region', NULL, true, 199),
  ('LK', 'Sri Lanka', false, '94', 'LKR', 'en', 'region', NULL, false, 200),
  ('BL', 'St. Barthélemy', false, '590', 'EUR', 'en', 'region', NULL, false, 201),
  ('SH', 'St. Helena', false, '290', 'SHP', 'en', 'region', NULL, false, 202),
  ('KN', 'St. Kitts & Nevis', false, '1', 'XCD', 'en', 'region', NULL, false, 203),
  ('LC', 'St. Lucia', false, '1', 'XCD', 'en', 'region', NULL, false, 204),
  ('MF', 'St. Martin', false, '590', 'EUR', 'en', 'region', NULL, false, 205),
  ('PM', 'St. Pierre & Miquelon', false, '508', 'EUR', 'en', 'region', NULL, false, 206),
  ('VC', 'St. Vincent & Grenadines', false, '1', 'XCD', 'en', 'region', NULL, false, 207),
  ('SD', 'Sudan', false, '249', 'SDG', 'en', 'region', NULL, false, 208),
  ('SR', 'Suriname', false, '597', 'SRD', 'en', 'region', NULL, false, 209),
  ('SJ', 'Svalbard & Jan Mayen', false, '47', 'NOK', 'en', 'region', NULL, false, 210),
  ('SE', 'Sweden', false, '46', 'SEK', 'sv', 'region', NULL, true, 211),
  ('CH', 'Switzerland', false, '41', 'CHF', 'de', 'region', NULL, true, 212),
  ('SY', 'Syria', false, '963', 'SYP', 'en', 'region', NULL, false, 213),
  ('TW', 'Taiwan', false, '886', 'TWD', 'zh', 'region', NULL, false, 214),
  ('TJ', 'Tajikistan', false, '992', 'TJS', 'en', 'region', NULL, false, 215),
  ('TZ', 'Tanzania', false, '255', 'TZS', 'en', 'region', NULL, false, 216),
  ('TH', 'Thailand', false, '66', 'THB', 'th', 'region', NULL, true, 217),
  ('TL', 'Timor-Leste', false, '670', 'USD', 'en', 'region', NULL, false, 218),
  ('TG', 'Togo', false, '228', 'XOF', 'en', 'region', NULL, false, 219),
  ('TK', 'Tokelau', false, '690', 'NZD', 'en', 'region', NULL, false, 220),
  ('TO', 'Tonga', false, '676', 'TOP', 'en', 'region', NULL, false, 221),
  ('TT', 'Trinidad & Tobago', false, '1', 'TTD', 'en', 'region', NULL, false, 222),
  ('TN', 'Tunisia', false, '216', 'TND', 'ar', 'region', NULL, false, 223),
  ('TR', 'Türkiye', false, '90', 'TRY', 'tr', 'region', NULL, false, 224),
  ('TM', 'Turkmenistan', false, '993', 'TMT', 'en', 'region', NULL, false, 225),
  ('TC', 'Turks & Caicos Islands', false, '1', 'USD', 'en', 'region', NULL, false, 226),
  ('TV', 'Tuvalu', false, '688', 'AUD', 'en', 'region', NULL, false, 227),
  ('VI', 'U.S. Virgin Islands', false, '1', 'USD', 'en', 'region', NULL, false, 228),
  ('UG', 'Uganda', false, '256', 'UGX', 'en', 'region', NULL, false, 229),
  ('UA', 'Ukraine', false, '380', 'UAH', 'uk', 'region', NULL, false, 230),
  ('AE', 'United Arab Emirates', false, '971', 'AED', 'ar', 'region', NULL, true, 231),
  ('GB', 'United Kingdom', false, '44', 'GBP', 'en', 'region', NULL, true, 232),
  ('UY', 'Uruguay', false, '598', 'UYU', 'es', 'region', NULL, false, 233),
  ('UZ', 'Uzbekistan', false, '998', 'UZS', 'uz', 'region', NULL, false, 234),
  ('VU', 'Vanuatu', false, '678', 'VUV', 'en', 'region', NULL, false, 235),
  ('VA', 'Vatican City', false, '39', 'EUR', 'en', 'region', NULL, false, 236),
  ('VE', 'Venezuela', false, '58', 'VES', 'es', 'region', NULL, false, 237),
  ('VN', 'Vietnam', false, '84', 'VND', 'vi', 'region', NULL, false, 238),
  ('WF', 'Wallis & Futuna', false, '681', 'XPF', 'en', 'region', NULL, false, 239),
  ('EH', 'Western Sahara', false, '212', 'MAD', 'en', 'region', NULL, false, 240),
  ('YE', 'Yemen', false, '967', 'YER', 'ar', 'region', NULL, false, 241),
  ('ZM', 'Zambia', false, '260', 'ZMW', 'en', 'region', NULL, false, 242),
  ('ZW', 'Zimbabwe', false, '263', 'ZWG', 'en', 'region', NULL, false, 243)
ON CONFLICT ("code") DO NOTHING;

UPDATE "countries" SET "enabled_at" = CURRENT_TIMESTAMP WHERE "code" = 'US' AND "enabled_at" IS NULL;

-- Owner 2026-10-05: «Страны» settings — e-mail the waiting list when a
-- country is switched on (auto by default).
INSERT INTO "app_config" ("key", "value", "updated_at") VALUES
  ('countries.notify_waitlist', 'true'::JSONB, now())
ON CONFLICT ("key") DO NOTHING;
-- Owner 2026-10-05: every state/province, person and support ticket
-- belongs to a country. Everything that exists today is in the US.
ALTER TABLE "states" ADD COLUMN "country_code" CHAR(2) NOT NULL DEFAULT 'US';

ALTER TABLE "states" ADD COLUMN "iso_code" TEXT;

ALTER TABLE "users" ADD COLUMN "country_code" CHAR(2) NOT NULL DEFAULT 'US';

ALTER TABLE "support_tickets" ADD COLUMN "country_code" CHAR(2) NOT NULL DEFAULT 'US';

CREATE INDEX "states_country_code_idx" ON "states"("country_code");

CREATE INDEX "users_country_code_idx" ON "users"("country_code");

CREATE INDEX "support_tickets_country_code_status_idx" ON "support_tickets"("country_code", "status");

ALTER TABLE "states" ADD CONSTRAINT "states_country_code_fkey" FOREIGN KEY ("country_code") REFERENCES "countries"("code") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "users" ADD CONSTRAINT "users_country_code_fkey" FOREIGN KEY ("country_code") REFERENCES "countries"("code") ON DELETE RESTRICT ON UPDATE CASCADE;
-- Owner 2026-10-05: Canada's provinces/territories (postal codes, none
-- clashes with a US code) and Mexico's states (INEGI numbers 01–32). They
-- stay unusable until their country is switched on in the admin.
UPDATE "states" SET "iso_code" = 'US-' || "code" WHERE "country_code" = 'US' AND "iso_code" IS NULL;

INSERT INTO "states" ("code", "name", "is_active", "country_code", "iso_code") VALUES
  ('AB', 'Alberta', true, 'CA', 'CA-AB'),
  ('BC', 'British Columbia', true, 'CA', 'CA-BC'),
  ('MB', 'Manitoba', true, 'CA', 'CA-MB'),
  ('NB', 'New Brunswick', true, 'CA', 'CA-NB'),
  ('NL', 'Newfoundland and Labrador', true, 'CA', 'CA-NL'),
  ('NS', 'Nova Scotia', true, 'CA', 'CA-NS'),
  ('NT', 'Northwest Territories', true, 'CA', 'CA-NT'),
  ('NU', 'Nunavut', true, 'CA', 'CA-NU'),
  ('ON', 'Ontario', true, 'CA', 'CA-ON'),
  ('PE', 'Prince Edward Island', true, 'CA', 'CA-PE'),
  ('QC', 'Quebec', true, 'CA', 'CA-QC'),
  ('SK', 'Saskatchewan', true, 'CA', 'CA-SK'),
  ('YT', 'Yukon', true, 'CA', 'CA-YT'),
  ('01', 'Aguascalientes', true, 'MX', 'MX-AGU'),
  ('02', 'Baja California', true, 'MX', 'MX-BCN'),
  ('03', 'Baja California Sur', true, 'MX', 'MX-BCS'),
  ('04', 'Campeche', true, 'MX', 'MX-CAM'),
  ('05', 'Coahuila', true, 'MX', 'MX-COA'),
  ('06', 'Colima', true, 'MX', 'MX-COL'),
  ('07', 'Chiapas', true, 'MX', 'MX-CHP'),
  ('08', 'Chihuahua', true, 'MX', 'MX-CHH'),
  ('09', 'Ciudad de México', true, 'MX', 'MX-CMX'),
  ('10', 'Durango', true, 'MX', 'MX-DUR'),
  ('11', 'Guanajuato', true, 'MX', 'MX-GUA'),
  ('12', 'Guerrero', true, 'MX', 'MX-GRO'),
  ('13', 'Hidalgo', true, 'MX', 'MX-HID'),
  ('14', 'Jalisco', true, 'MX', 'MX-JAL'),
  ('15', 'Estado de México', true, 'MX', 'MX-MEX'),
  ('16', 'Michoacán', true, 'MX', 'MX-MIC'),
  ('17', 'Morelos', true, 'MX', 'MX-MOR'),
  ('18', 'Nayarit', true, 'MX', 'MX-NAY'),
  ('19', 'Nuevo León', true, 'MX', 'MX-NLE'),
  ('20', 'Oaxaca', true, 'MX', 'MX-OAX'),
  ('21', 'Puebla', true, 'MX', 'MX-PUE'),
  ('22', 'Querétaro', true, 'MX', 'MX-QUE'),
  ('23', 'Quintana Roo', true, 'MX', 'MX-ROO'),
  ('24', 'San Luis Potosí', true, 'MX', 'MX-SLP'),
  ('25', 'Sinaloa', true, 'MX', 'MX-SIN'),
  ('26', 'Sonora', true, 'MX', 'MX-SON'),
  ('27', 'Tabasco', true, 'MX', 'MX-TAB'),
  ('28', 'Tamaulipas', true, 'MX', 'MX-TAM'),
  ('29', 'Tlaxcala', true, 'MX', 'MX-TLA'),
  ('30', 'Veracruz', true, 'MX', 'MX-VER'),
  ('31', 'Yucatán', true, 'MX', 'MX-YUC'),
  ('32', 'Zacatecas', true, 'MX', 'MX-ZAC')
ON CONFLICT ("code") DO NOTHING;
-- Owner 2026-10-05 (docs/CLIENT_FRAUD.md): a blocked fraudster must not
-- come back with the same phone, e-mail, Apple / Google account, card or
-- device. Hashed identity signals per account, the client risk score and
-- an append-only decision history.
CREATE TABLE "identity_fingerprints" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "user_id" UUID NOT NULL,
  "kind" VARCHAR(16) NOT NULL,
  "hash" VARCHAR(64) NOT NULL,
  "first_seen_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "last_seen_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "banned_at" TIMESTAMPTZ,
  CONSTRAINT "identity_fingerprints_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "identity_fingerprints_user_id_kind_hash_key" ON "identity_fingerprints"("user_id", "kind", "hash");

CREATE INDEX "identity_fingerprints_kind_hash_idx" ON "identity_fingerprints"("kind", "hash");

CREATE INDEX "identity_fingerprints_last_seen_at_idx" ON "identity_fingerprints"("last_seen_at");

CREATE TABLE "client_fraud_profiles" (
  "user_id" UUID NOT NULL,
  "score" INTEGER NOT NULL DEFAULT 0,
  "status" VARCHAR(16) NOT NULL DEFAULT 'ok',
  "signals" JSONB NOT NULL DEFAULT '[]',
  "linked_user_id" UUID,
  "queue_reason" VARCHAR(16),
  "queued_at" TIMESTAMPTZ,
  "cleared_score" INTEGER,
  "cleared_by" UUID,
  "cleared_at" TIMESTAMPTZ,
  "computed_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ NOT NULL,
  CONSTRAINT "client_fraud_profiles_pkey" PRIMARY KEY ("user_id")
);

CREATE INDEX "client_fraud_profiles_status_score_idx" ON "client_fraud_profiles"("status", "score" DESC);

CREATE TABLE "client_fraud_events" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "user_id" UUID,
  "kind" VARCHAR(32) NOT NULL,
  "actor_type" VARCHAR(16) NOT NULL DEFAULT 'system',
  "actor_id" UUID,
  "note" VARCHAR(500),
  "details" JSONB NOT NULL DEFAULT '{}',
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT "client_fraud_events_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "client_fraud_events_user_id_created_at_idx" ON "client_fraud_events"("user_id", "created_at" DESC);

CREATE INDEX "client_fraud_events_kind_created_at_idx" ON "client_fraud_events"("kind", "created_at" DESC);

CREATE INDEX "client_fraud_events_actor_id_created_at_idx" ON "client_fraud_events"("actor_id", "created_at" DESC);
-- Owner 2026-10-05: storage like Telegram — every file kept once, cleaned
-- up automatically, the database kept small.
--
-- 1. Deduplication: identical uploads share one S3 object, so s3_key is no
--    longer unique. source_sha256 is the hash of the bytes as uploaded
--    (sha256 describes the stored, processed object) and the lookup key.
DROP INDEX IF EXISTS "files_s3_key_key"  CASCADE;

ALTER TABLE "files" ADD COLUMN IF NOT EXISTS "source_sha256" TEXT;

ALTER TABLE "files" ADD COLUMN IF NOT EXISTS "deleted_reason" VARCHAR(16);

ALTER TABLE "files" ADD COLUMN IF NOT EXISTS "purged_at" TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS "files_s3_bucket_s3_key_idx" ON "files"("s3_bucket", "s3_key");

CREATE INDEX IF NOT EXISTS "files_s3_bucket_source_sha256_idx" ON "files"("s3_bucket", "source_sha256");

CREATE INDEX IF NOT EXISTS "files_deleted_at_created_at_idx" ON "files"("deleted_at", "created_at");

-- 2. Per-user storage cap set by an admin (NULL = the app_config default).
ALTER TABLE "users" ADD COLUMN IF NOT EXISTS "storage_quota_mb" INTEGER;

-- 3. The cleanup asks "does anything still use this file?" — indexed.
CREATE INDEX IF NOT EXISTS "users_avatar_file_id_idx" ON "users"("avatar_file_id");

CREATE INDEX IF NOT EXISTS "post_media_file_id_idx" ON "post_media"("file_id");

CREATE INDEX IF NOT EXISTS "reviews_photo_ids_idx" ON "reviews" USING GIN ("photo_ids");

CREATE INDEX IF NOT EXISTS "client_reviews_photo_ids_idx" ON "client_reviews" USING GIN ("photo_ids");

CREATE INDEX IF NOT EXISTS "attorney_tasks_file_ids_idx" ON "attorney_tasks" USING GIN ("file_ids");

-- The nightly retention removes old assistant activity by date.
CREATE INDEX IF NOT EXISTS "assistant_activity_created_at_idx" ON "assistant_activity"("created_at");

-- 4. A daily snapshot of what storage and the database take.
CREATE TABLE IF NOT EXISTS "storage_snapshots" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "day" DATE NOT NULL,
    "files_bytes" BIGINT NOT NULL,
    "stored_bytes" BIGINT NOT NULL,
    "files_count" INTEGER NOT NULL,
    "by_purpose" JSONB NOT NULL,
    "db_tables" JSONB NOT NULL,
    "db_bytes" BIGINT NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "storage_snapshots_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX IF NOT EXISTS "storage_snapshots_day_key" ON "storage_snapshots"("day");
-- Owner 2026-10-05: demo world for bloggers («Продвижение») + partners
-- without an app account. Demo data itself lives in a separate database
-- (<db>_demo) that replays these same migrations; this table is the
-- registry in the real database.
ALTER TABLE "users" ADD COLUMN IF NOT EXISTS "placeholder_kind" VARCHAR(24);

ALTER TABLE "partners" ADD COLUMN IF NOT EXISTS "external_name" VARCHAR(120);

ALTER TABLE "partners" ADD COLUMN IF NOT EXISTS "external_contact" VARCHAR(200);

ALTER TABLE "partners" ADD COLUMN IF NOT EXISTS "demo_access" BOOL NOT NULL DEFAULT false;

CREATE TABLE IF NOT EXISTS "demo_accounts" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "demo_user_id" UUID NOT NULL,
    "role" VARCHAR(16) NOT NULL,
    "display_name" VARCHAR(120) NOT NULL,
    "label" VARCHAR(200),
    "created_by_user_id" UUID,
    "created_by_admin_id" UUID,
    "invite_code_hash" VARCHAR(64),
    "invite_expires_at" TIMESTAMPTZ,
    "last_seen_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "demo_accounts_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX IF NOT EXISTS "demo_accounts_demo_user_id_key" ON "demo_accounts"("demo_user_id");

CREATE UNIQUE INDEX IF NOT EXISTS "demo_accounts_invite_code_hash_key" ON "demo_accounts"("invite_code_hash");

CREATE INDEX IF NOT EXISTS "demo_accounts_created_by_user_id_created_at_idx" ON "demo_accounts"("created_by_user_id", "created_at");

CREATE INDEX IF NOT EXISTS "demo_accounts_last_seen_at_idx" ON "demo_accounts"("last_seen_at");
-- Owner 2026-10-05 (legal): outreach compliance — do-not-contact flag on
-- leads (TCPA / National Do-Not-Call), the source/consent note, per-lead
-- email counters, and a stop-list of phones/e-mails that must never be
-- contacted again (also fed by the retention job before it deletes a
-- do-not-contact lead).
ALTER TABLE "outreach_leads" ADD COLUMN "do_not_contact_at" TIMESTAMPTZ;

ALTER TABLE "outreach_leads" ADD COLUMN "do_not_contact_reason" VARCHAR(24);

ALTER TABLE "outreach_leads" ADD COLUMN "source_note" VARCHAR(300);

ALTER TABLE "outreach_leads" ADD COLUMN "emails_sent" INTEGER NOT NULL DEFAULT 0;

ALTER TABLE "outreach_leads" ADD COLUMN "last_email_at" TIMESTAMPTZ;

CREATE INDEX "outreach_leads_do_not_contact_at_idx" ON "outreach_leads"("do_not_contact_at");

CREATE TABLE "outreach_suppressions" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "kind" VARCHAR(8) NOT NULL,
  "value" VARCHAR(254) NOT NULL,
  "note" VARCHAR(200),
  "created_by" UUID NOT NULL,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT "outreach_suppressions_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "outreach_suppressions_kind_value_key" ON "outreach_suppressions"("kind", "value");
-- Owner 2026-10-05 (legal): DMCA / copyright notices.
-- A new report reason: the mobile report sheet routes «copyright» to the
-- DMCA form, which files a report with this reason next to the notice.
ALTER TYPE "report_reason" ADD VALUE IF NOT EXISTS 'copyright';

-- Repeat-infringer counter (17 U.S.C. §512(i)): every DMCA removal adds
-- one; at legal.settings.dmcaStrikesToSuspend (default 3) the account is
-- suspended. A restore after a counter-notice takes one back.
ALTER TABLE "users" ADD COLUMN IF NOT EXISTS "copyright_strikes" INTEGER NOT NULL DEFAULT 0;

-- The notice itself with the §512(c)(3) elements, the decision and the
-- author's counter-notice (§512(g)).
CREATE TABLE "dmca_notices" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "report_id" UUID,
    "target_type" "report_target_type",
    "target_id" UUID,
    "infringing_url" VARCHAR(1000),
    "complainant_name" VARCHAR(200) NOT NULL,
    "complainant_email" VARCHAR(254) NOT NULL,
    "complainant_address" VARCHAR(500) NOT NULL,
    "complainant_phone" VARCHAR(40),
    "work_description" VARCHAR(4000) NOT NULL,
    "good_faith" BOOL NOT NULL,
    "accuracy_sworn" BOOL NOT NULL,
    "signature" VARCHAR(200) NOT NULL,
    "status" VARCHAR(24) NOT NULL DEFAULT 'new',
    "submitted_by_user_id" UUID,
    "author_user_id" UUID,
    "counter" JSONB,
    "decided_by" UUID,
    "decided_at" TIMESTAMPTZ,
    "decision_note" VARCHAR(1000),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "dmca_notices_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "dmca_notices_status_created_at_idx" ON "dmca_notices"("status", "created_at");

CREATE INDEX "dmca_notices_submitted_by_user_id_idx" ON "dmca_notices"("submitted_by_user_id");

CREATE INDEX "dmca_notices_target_type_target_id_idx" ON "dmca_notices"("target_type", "target_id");

ALTER TABLE "dmca_notices" ADD CONSTRAINT "dmca_notices_report_id_fkey" FOREIGN KEY ("report_id") REFERENCES "reports"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "dmca_notices" ADD CONSTRAINT "dmca_notices_submitted_by_user_id_fkey" FOREIGN KEY ("submitted_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
-- Owner 2026-10-05 (legal): partner rules and tax paperwork.
-- The partner accepts the rules (FTC Endorsement Guides disclosure, no
-- spam / cold calls, independent contractor, ...) in the app: when, which
-- version and from which IP. A W-9 (or W-8) must be on file before the
-- first payout when partners.program.requireW9 is on.
ALTER TABLE "partners" ADD COLUMN IF NOT EXISTS "terms_accepted_at" TIMESTAMPTZ;

ALTER TABLE "partners" ADD COLUMN IF NOT EXISTS "terms_version" VARCHAR(16);

ALTER TABLE "partners" ADD COLUMN IF NOT EXISTS "terms_ip" VARCHAR(45);

ALTER TABLE "partners" ADD COLUMN IF NOT EXISTS "w9_received_at" TIMESTAMPTZ;
-- Owner 2026-10-05: promo codes can be deleted from the admin; a code that
-- was already used is archived instead so payment history stays intact.
ALTER TABLE "promo_codes" ADD COLUMN "archived_at" TIMESTAMPTZ;
-- Owner 2026-10-05: Instagram-style promotion for posts and cases without a
-- subscription: budget → impressions at the admin's CPM, audience, reach,
-- clicks, per-person frequency cap (promotion_views).
-- AlterTable
ALTER TABLE "case_promotions" ADD COLUMN     "audience" JSONB;

ALTER TABLE "case_promotions" ADD COLUMN     "clicks" INTEGER NOT NULL DEFAULT 0;

ALTER TABLE "case_promotions" ADD COLUMN     "cpm_cents" INTEGER;

ALTER TABLE "case_promotions" ADD COLUMN     "post_id" UUID;

ALTER TABLE "case_promotions" ADD COLUMN     "reach" INTEGER NOT NULL DEFAULT 0;

ALTER TABLE "case_promotions" ADD COLUMN     "refunded_cents" INTEGER NOT NULL DEFAULT 0;

ALTER TABLE "case_promotions" ADD COLUMN     "reviewed_at" TIMESTAMPTZ;

ALTER TABLE "case_promotions" ADD COLUMN     "reviewed_by" UUID;

ALTER TABLE "case_promotions" ADD COLUMN     "target_impressions" INTEGER;

ALTER TABLE "case_promotions" ADD COLUMN     "target_type" VARCHAR(8) NOT NULL DEFAULT 'case';

ALTER TABLE "case_promotions" ALTER COLUMN "case_id" DROP NOT NULL;

-- CreateTable
CREATE TABLE "promotion_views" (
    "promotion_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "impressions" INTEGER NOT NULL DEFAULT 0,
    "day_key" VARCHAR(10) NOT NULL,
    "day_count" INTEGER NOT NULL DEFAULT 0,
    "clicked" BOOL NOT NULL DEFAULT false,
    "first_seen_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "last_seen_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "promotion_views_pkey" PRIMARY KEY ("promotion_id","user_id")
);

-- CreateIndex
CREATE INDEX "promotion_views_user_id_last_seen_at_idx" ON "promotion_views"("user_id", "last_seen_at" DESC);

-- CreateIndex
CREATE INDEX "case_promotions_post_id_idx" ON "case_promotions"("post_id");

-- CreateIndex
CREATE INDEX "case_promotions_target_type_status_ends_at_idx" ON "case_promotions"("target_type", "status", "ends_at");

-- AddForeignKey
ALTER TABLE "promotion_views" ADD CONSTRAINT "promotion_views_promotion_id_fkey" FOREIGN KEY ("promotion_id") REFERENCES "case_promotions"("id") ON DELETE CASCADE ON UPDATE CASCADE;
-- Owner 2026-10-05: legal posts vs general (personal) posts. Every post is
-- 'legal' (a law topic, News, or marked by its author) or 'general'; a
-- viewer can hide general posts from the feed, search and recommendations.
ALTER TABLE "posts" ADD COLUMN "content_class" VARCHAR(16) NOT NULL DEFAULT 'general';

ALTER TABLE "posts" ADD COLUMN "content_class_locked" BOOL NOT NULL DEFAULT false;

ALTER TABLE "users" ADD COLUMN "feed_content_mode" VARCHAR(16);
-- Existing posts: a law topic or News = legal, the rest stay general.
-- A separate migration: CockroachDB can't use a column added in the same
-- transaction.
UPDATE "posts" SET "content_class" = 'legal'
  WHERE "practice_area_id" IS NOT NULL OR "kind" = 'news';

CREATE INDEX "posts_content_class_created_at_idx" ON "posts"("content_class", "created_at" DESC);
-- Owner 2026-10-05 «Прибыль и резерв»: only net profit reaches the owner's
-- card; the money for services, salaries and partners stays apart.
-- Additive (new tables only).

-- 1. What the services charge the expense card a month.
CREATE TABLE IF NOT EXISTS treasury_expenses (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  name VARCHAR(80) NOT NULL,
  monthly_cents INTEGER NOT NULL,
  source VARCHAR(16) NOT NULL DEFAULT 'manual',
  active BOOL NOT NULL DEFAULT true,
  sort INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT treasury_expenses_pkey PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS treasury_expenses_active_sort_idx ON treasury_expenses (active, sort);

-- Starting list (estimates; the owner corrects them in Деньги → Прибыль и
-- резерв). Inserted only into an empty table, so a re-run adds nothing.
INSERT INTO treasury_expenses (name, monthly_cents, source, sort)
SELECT v.name, v.monthly_cents, v.source, v.sort
FROM (VALUES
  ('AWS (серверы, файлы, почта)', 14000, 'aws', 0),
  ('CockroachDB Cloud (база)', 0, 'manual', 1),
  ('Twilio (SMS)', 2000, 'manual', 2),
  ('Bunny Stream (видео)', 1000, 'manual', 3),
  ('Firebase (пуши)', 0, 'manual', 4),
  ('Apple Developer ($99 в год)', 825, 'manual', 5),
  ('Домен lawbid.dev', 200, 'manual', 6)
) AS v(name, monthly_cents, source, sort)
WHERE NOT EXISTS (SELECT 1 FROM treasury_expenses);

-- 2. Payouts of the monthly split (Stripe balance → a bank in Stripe).
CREATE TABLE IF NOT EXISTS treasury_payouts (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  key VARCHAR(80) NOT NULL,
  period VARCHAR(7) NOT NULL,
  kind VARCHAR(16) NOT NULL,
  trigger VARCHAR(8) NOT NULL DEFAULT 'auto',
  amount_cents INTEGER NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'usd',
  destination_id VARCHAR(64) NULL,
  destination_label VARCHAR(80) NULL,
  stripe_payout_id VARCHAR(64) NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'pending',
  failure VARCHAR(300) NULL,
  plan JSONB NULL,
  created_by UUID NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT treasury_payouts_pkey PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS treasury_payouts_key_key ON treasury_payouts (key);

CREATE INDEX IF NOT EXISTS treasury_payouts_period_kind_idx ON treasury_payouts (period, kind);

CREATE INDEX IF NOT EXISTS treasury_payouts_status_idx ON treasury_payouts (status);

CREATE INDEX IF NOT EXISTS treasury_payouts_created_at_idx ON treasury_payouts (created_at DESC);
-- Owner 2026-10-06: country partners («Главный партнёр страны») and their
-- monthly settlements (paid through payroll).
CREATE TABLE "country_partners" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "country_code" CHAR(2) NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "contact" VARCHAR(200),
    "lead_admin_id" UUID NOT NULL,
    "share_bps" INTEGER NOT NULL,
    "status" VARCHAR(16) NOT NULL DEFAULT 'active',
    "max_admins" INTEGER NOT NULL DEFAULT 10,
    "payouts_enabled" BOOL NOT NULL DEFAULT false,
    "payroll_employee_id" UUID,
    "contract_starts_at" TIMESTAMPTZ,
    "contract_ends_at" TIMESTAMPTZ,
    "contract_version" INTEGER,
    "contract_accepted_at" TIMESTAMPTZ,
    "contract_accepted_ip" VARCHAR(64),
    "goals" JSONB NOT NULL DEFAULT '[]',
    "suspended_admin_ids" TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
    "note" VARCHAR(1000),
    "created_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,
    "disabled_at" TIMESTAMPTZ,

    CONSTRAINT "country_partners_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "country_partners_lead_admin_id_key" ON "country_partners"("lead_admin_id");

CREATE INDEX "country_partners_country_code_status_idx" ON "country_partners"("country_code", "status");

CREATE TABLE "country_partner_settlements" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "partner_id" UUID NOT NULL,
    "period" VARCHAR(7) NOT NULL,
    "currency" VARCHAR(3) NOT NULL DEFAULT 'usd',
    "gross_cents" INTEGER NOT NULL,
    "refunds_cents" INTEGER NOT NULL DEFAULT 0,
    "fees_cents" INTEGER NOT NULL DEFAULT 0,
    "net_cents" INTEGER NOT NULL,
    "share_bps" INTEGER NOT NULL,
    "amount_cents" INTEGER NOT NULL,
    "status" VARCHAR(16) NOT NULL DEFAULT 'held',
    "accrual_ref" VARCHAR(120),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "country_partner_settlements_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "country_partner_settlements_partner_id_period_currency_key" ON "country_partner_settlements"("partner_id", "period", "currency");

CREATE INDEX "country_partner_settlements_status_period_idx" ON "country_partner_settlements"("status", "period");

ALTER TABLE "country_partner_settlements" ADD CONSTRAINT "country_partner_settlements_partner_id_fkey" FOREIGN KEY ("partner_id") REFERENCES "country_partners"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
-- Owner 2026-10-06: back to the original rule — an attorney is reviewed
-- only by a client who completed a case with them (the review is tied to
-- that case). Reviews written without a case under the 2026-10-01 "anyone
-- reviews" rule are hidden, not deleted: staff can still see and restore
-- them in admin moderation. Client reviews are unchanged (anyone).
UPDATE "reviews"
SET "status" = 'hidden', "updated_at" = now()
WHERE "case_id" IS NULL AND "status" = 'published';

-- Same expression as review-rating.ts (RATING_AVG_SQL); the nightly
-- rating reconcile job would converge on these values too.
UPDATE "attorney_profiles" AS ap
SET ("rating_avg", "rating_count", "updated_at") = (
  SELECT COALESCE(round(avg(r."rating")::DECIMAL, 2), 0), count(r."id"), now()
  FROM "reviews" AS r
  WHERE r."attorney_id" = ap."user_id" AND r."status" = 'published'
)
WHERE ap."user_id" IN (SELECT DISTINCT "attorney_id" FROM "reviews" WHERE "case_id" IS NULL);
-- Owner 2026-10-05 (legal documents): every legal text is edited in the
-- admin (Система → Юридические документы). New document types and the
-- consents given to the role agreements. Enum values are added on their
-- own (CockroachDB cannot use a new value in the transaction that adds it).
ALTER TYPE legal_doc_type ADD VALUE IF NOT EXISTS 'attorney_agreement';

ALTER TYPE legal_doc_type ADD VALUE IF NOT EXISTS 'client_agreement';

ALTER TYPE legal_doc_type ADD VALUE IF NOT EXISTS 'eula';

ALTER TYPE legal_doc_type ADD VALUE IF NOT EXISTS 'refund';

ALTER TYPE legal_doc_type ADD VALUE IF NOT EXISTS 'cookies';

ALTER TYPE legal_doc_type ADD VALUE IF NOT EXISTS 'third_party_services';

ALTER TYPE legal_doc_type ADD VALUE IF NOT EXISTS 'partner_terms';

ALTER TYPE legal_doc_type ADD VALUE IF NOT EXISTS 'dmca_policy';

ALTER TYPE consent_type ADD VALUE IF NOT EXISTS 'attorney_agreement';

ALTER TYPE consent_type ADD VALUE IF NOT EXISTS 'client_agreement';

ALTER TYPE consent_type ADD VALUE IF NOT EXISTS 'eula';
-- Owner 2026-10-05 (legal documents): drafts, history and rollback.
-- status: draft (version 'draft', one per type + locale) / published (the
-- current version) / archived (a former version, kept for the record of
-- what users accepted). The next migration marks the existing rows.
ALTER TABLE "legal_documents" ADD COLUMN IF NOT EXISTS "status" VARCHAR(16) NOT NULL DEFAULT 'draft';

ALTER TABLE "legal_documents" ADD COLUMN IF NOT EXISTS "requires_reacceptance" BOOL NOT NULL DEFAULT true;

ALTER TABLE "legal_documents" ADD COLUMN IF NOT EXISTS "created_by" UUID;

ALTER TABLE "legal_documents" ADD COLUMN IF NOT EXISTS "changed_by" UUID;

ALTER TABLE "legal_documents" ADD COLUMN IF NOT EXISTS "change_note" VARCHAR(1000);

ALTER TABLE "legal_documents" ADD COLUMN IF NOT EXISTS "rollback_of_id" UUID;

CREATE INDEX IF NOT EXISTS "legal_documents_doc_type_locale_status_idx" ON "legal_documents"("doc_type", "locale", "status");
-- Owner 2026-10-05 (legal documents): existing rows keep their meaning —
-- the current ones are published, other published ones archived,
-- unpublished ones stay drafts. (Separate from ADD COLUMN: CockroachDB
-- cannot backfill a column in the transaction that adds it.)
UPDATE "legal_documents" SET "status" = 'published' WHERE "is_current" = true;

UPDATE "legal_documents" SET "status" = 'archived' WHERE "is_current" = false AND "published_at" IS NOT NULL;
-- Owner 2026-10-06: the News system is switched off for now (a News post and
-- a regular post land in the same feed). The code stays behind the
-- `news_posts` flag (Admin → Система → Функции); off by default.
INSERT INTO feature_flags (key, enabled, rollout_percent, description, updated_at)
VALUES ('news_posts', false, 100, 'News: the News topic, the Post/News switch and the profile News tab', now())
ON CONFLICT (key) DO NOTHING;
-- Owner 2026-10-06: a country partner stops on its own on the contract end
-- date («Договор до»). The daily sweep sets this when it switches the
-- partner off; money earned up to that date is still paid out.
ALTER TABLE "country_partners" ADD COLUMN IF NOT EXISTS "contract_expired_at" TIMESTAMPTZ;
-- Owner 2026-10-06: clients and attorneys settle the agreed fee between
-- themselves; LawBid does not take part. In-app case payments (Stripe
-- Connect) are switched OFF everywhere. The code stays: switch it back on
-- in Admin → Система → Функции (`payments_in_app`).
UPDATE feature_flags SET enabled = false, updated_at = now() WHERE key = 'payments_in_app';
-- Owner 2026-10-07: Admin → Система → Функции → «Вход и письма по почте».
-- Amazon SES keeps the account in its sandbox (mail reaches only
-- pre-verified addresses), so every e-mail flow in the app is switched off
-- until production access is granted. One switch: the existing
-- `email_login` flag now covers sign-in, adding an e-mail, the client's
-- e-mail step, the firm e-mail check, e-mail notifications and the
-- country waiting list (apps/api/src/modules/feature-flags/email-flows.ts).
INSERT INTO feature_flags (key, enabled, rollout_percent, description, updated_at)
VALUES ('email_login', false, 100, 'E-mail sign-in and every e-mail flow in the app (add e-mail, client e-mail step, firm e-mail, e-mail notifications, waiting list). Off: phone, Google and Apple only.', now())
ON CONFLICT (key) DO UPDATE
SET enabled = false, description = excluded.description, updated_at = now();
-- Owner 2026-10-07: Threads-style reposts — "someone reposted your post".
-- The enum value is added on its own (CockroachDB cannot use a new value
-- in the transaction that adds it).
ALTER TYPE "notification_type" ADD VALUE IF NOT EXISTS 'post_repost';
-- Owner 2026-10-07: Threads-style reposts. One row per user and post
-- (POST/DELETE /posts/:id/repost, idempotent); not of one's own post
-- (checked in the service). Rows go with the post or the user.
CREATE TABLE IF NOT EXISTS "post_reposts" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "post_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "post_reposts_pkey" PRIMARY KEY ("id")
);

CREATE INDEX IF NOT EXISTS "post_reposts_post_id_idx" ON "post_reposts"("post_id");

CREATE INDEX IF NOT EXISTS "post_reposts_user_id_created_at_idx" ON "post_reposts"("user_id", "created_at" DESC);

CREATE UNIQUE INDEX IF NOT EXISTS "post_reposts_user_id_post_id_key" ON "post_reposts"("user_id", "post_id");

ALTER TABLE "post_reposts" ADD CONSTRAINT "post_reposts_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "posts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "post_reposts" ADD CONSTRAINT "post_reposts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
-- Owner 2026-10-07: strikethrough "old price" per plan price (additive).
-- Shown only while show_discount is on AND compare_at_cents > amount_cents,
-- so raising the price later never turns the discount into a "plus".
ALTER TABLE plan_prices ADD COLUMN IF NOT EXISTS compare_at_cents INTEGER;

ALTER TABLE plan_prices ADD COLUMN IF NOT EXISTS show_discount BOOL NOT NULL DEFAULT false;
