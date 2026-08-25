/*
 Navicat Premium Data Transfer

 Source Server         : smo_space_postgre
 Source Server Type    : PostgreSQL
 Source Server Version : 180003 (180003)
 Source Host           : primary.smospacedb--ytn8rzrn4mjk.addon.code.run:28081
 Source Catalog        : _515e38d818c6
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 180003 (180003)
 File Encoding         : 65001

 Date: 08/08/2026 21:33:03
*/


-- ----------------------------
-- Type structure for ChatRole
-- ----------------------------
DROP TYPE IF EXISTS "public"."ChatRole";
CREATE TYPE "public"."ChatRole" AS ENUM (
  'ADMIN',
  'MODERATOR',
  'MEMBER'
);
ALTER TYPE "public"."ChatRole" OWNER TO "_af5df1244606e168";

-- ----------------------------
-- Type structure for ChatRoomStatus
-- ----------------------------
DROP TYPE IF EXISTS "public"."ChatRoomStatus";
CREATE TYPE "public"."ChatRoomStatus" AS ENUM (
  'PENDING',
  'APPROVED',
  'REJECTED'
);
ALTER TYPE "public"."ChatRoomStatus" OWNER TO "_af5df1244606e168";

-- ----------------------------
-- Type structure for ChatType
-- ----------------------------
DROP TYPE IF EXISTS "public"."ChatType";
CREATE TYPE "public"."ChatType" AS ENUM (
  'DIRECT',
  'GROUP'
);
ALTER TYPE "public"."ChatType" OWNER TO "_af5df1244606e168";

-- ----------------------------
-- Type structure for EntityType
-- ----------------------------
DROP TYPE IF EXISTS "public"."EntityType";
CREATE TYPE "public"."EntityType" AS ENUM (
  'POST',
  'COMMENT',
  'PHOTO',
  'USER',
  'GROUP',
  'EVENT',
  'MESSAGE',
  'FOLLOW',
  'FRIENDSHIP'
);
ALTER TYPE "public"."EntityType" OWNER TO "_af5df1244606e168";

-- ----------------------------
-- Type structure for FriendStatus
-- ----------------------------
DROP TYPE IF EXISTS "public"."FriendStatus";
CREATE TYPE "public"."FriendStatus" AS ENUM (
  'PENDING',
  'ACCEPTED',
  'REJECTED',
  'BLOCKED'
);
ALTER TYPE "public"."FriendStatus" OWNER TO "_af5df1244606e168";

-- ----------------------------
-- Type structure for MediaType
-- ----------------------------
DROP TYPE IF EXISTS "public"."MediaType";
CREATE TYPE "public"."MediaType" AS ENUM (
  'IMAGE',
  'VIDEO'
);
ALTER TYPE "public"."MediaType" OWNER TO "_af5df1244606e168";

-- ----------------------------
-- Type structure for MessageType
-- ----------------------------
DROP TYPE IF EXISTS "public"."MessageType";
CREATE TYPE "public"."MessageType" AS ENUM (
  'TEXT',
  'IMAGE',
  'FILE',
  'SYSTEM',
  'POST_SHARE',
  'VOICE'
);
ALTER TYPE "public"."MessageType" OWNER TO "_af5df1244606e168";

-- ----------------------------
-- Type structure for NotificationPriority
-- ----------------------------
DROP TYPE IF EXISTS "public"."NotificationPriority";
CREATE TYPE "public"."NotificationPriority" AS ENUM (
  'LOW',
  'NORMAL',
  'HIGH',
  'URGENT'
);
ALTER TYPE "public"."NotificationPriority" OWNER TO "_af5df1244606e168";

-- ----------------------------
-- Type structure for NotificationType_Type
-- ----------------------------
DROP TYPE IF EXISTS "public"."NotificationType_Type";
CREATE TYPE "public"."NotificationType_Type" AS ENUM (
  'LIKE_POST',
  'LIKE_COMMENT',
  'LIKE_PHOTO',
  'COMMENT_POST',
  'REPLY_COMMENT',
  'SHARE_POST',
  'POST_MENTION',
  'COMMENT_MENTION',
  'FRIEND_REQUEST',
  'FRIEND_ACCEPT',
  'FOLLOW_USER',
  'FOLLOW_ACCEPT',
  'UNFOLLOW_USER',
  'GROUP_INVITE',
  'GROUP_JOIN_REQUEST',
  'GROUP_JOIN_ACCEPT',
  'GROUP_POST',
  'GROUP_ROLE_CHANGE',
  'NEW_POST_FROM_FOLLOWING',
  'POST_IN_GROUP',
  'TAGGED_IN_POST',
  'TAGGED_IN_PHOTO',
  'ACCOUNT_UPDATE',
  'SECURITY_ALERT',
  'PASSWORD_CHANGE',
  'EMAIL_VERIFICATION',
  'ACCOUNT_MILESTONE',
  'NEW_MESSAGE',
  'MESSAGE_REQUEST',
  'MESSAGE_READ',
  'EVENT_INVITE',
  'EVENT_REMINDER',
  'EVENT_CHANGE',
  'EVENT_CANCELLED'
);
ALTER TYPE "public"."NotificationType_Type" OWNER TO "_af5df1244606e168";

-- ----------------------------
-- Type structure for ReactionType
-- ----------------------------
DROP TYPE IF EXISTS "public"."ReactionType";
CREATE TYPE "public"."ReactionType" AS ENUM (
  'LIKE',
  'LOVE',
  'HAHA',
  'WOW',
  'SAD',
  'ANGRY'
);
ALTER TYPE "public"."ReactionType" OWNER TO "_af5df1244606e168";

-- ----------------------------
-- Type structure for UserGender
-- ----------------------------
DROP TYPE IF EXISTS "public"."UserGender";
CREATE TYPE "public"."UserGender" AS ENUM (
  'MALE',
  'FEMALE',
  'OTHER'
);
ALTER TYPE "public"."UserGender" OWNER TO "_af5df1244606e168";

-- ----------------------------
-- Type structure for UserTypeEnum
-- ----------------------------
DROP TYPE IF EXISTS "public"."UserTypeEnum";
CREATE TYPE "public"."UserTypeEnum" AS ENUM (
  'USER',
  'VIP_USER',
  'ADMIN',
  'MODERATOR',
  'SUPER_ADMIN'
);
ALTER TYPE "public"."UserTypeEnum" OWNER TO "_af5df1244606e168";

-- ----------------------------
-- Type structure for VerificationType
-- ----------------------------
DROP TYPE IF EXISTS "public"."VerificationType";
CREATE TYPE "public"."VerificationType" AS ENUM (
  'ACTIVE_ACCOUNT',
  'FORGOT_PASSWORD'
);
ALTER TYPE "public"."VerificationType" OWNER TO "_af5df1244606e168";

-- ----------------------------
-- Table structure for auth_codes
-- ----------------------------
DROP TABLE IF EXISTS "public"."auth_codes";
CREATE TABLE "public"."auth_codes" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "auth_code" text COLLATE "pg_catalog"."default",
  "role_level" int4 DEFAULT 0
)
;

-- ----------------------------
-- Records of auth_codes
-- ----------------------------
INSERT INTO "public"."auth_codes" VALUES ('b7893e2b-5b76-48f8-82c8-cc6b10f7a2eb', 'SMOTeam', 2);

-- ----------------------------
-- Table structure for bookmarks
-- ----------------------------
DROP TABLE IF EXISTS "public"."bookmarks";
CREATE TABLE "public"."bookmarks" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "post_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of bookmarks
-- ----------------------------
INSERT INTO "public"."bookmarks" VALUES ('96b47057-023a-464a-bdd6-dcc311421b04', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9', '2026-06-09 07:03:10.24');
INSERT INTO "public"."bookmarks" VALUES ('a2b0f7bb-5fd2-47a7-8c08-1ac5b4b3fcc2', '6a31a93a-a961-48d6-963e-0645f99de8e4', '445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9', '2026-06-30 06:19:58.203');
INSERT INTO "public"."bookmarks" VALUES ('4cfd0c56-3f42-440e-8fc3-35dfcc9224f4', '19315748-376c-4aab-9307-936d740fbfec', '445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9', '2026-07-27 09:44:29.822');

-- ----------------------------
-- Table structure for chat_message_reactions
-- ----------------------------
DROP TABLE IF EXISTS "public"."chat_message_reactions";
CREATE TABLE "public"."chat_message_reactions" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "message_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "type" "public"."ReactionType" NOT NULL DEFAULT 'LIKE'::"ReactionType",
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of chat_message_reactions
-- ----------------------------
INSERT INTO "public"."chat_message_reactions" VALUES ('2ee37b39-4946-46d6-8b30-565d11c53ed8', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '17f60a32-c171-4f38-ba53-78dbbe03cdf8', 'ANGRY', '2026-06-07 15:44:30.287');
INSERT INTO "public"."chat_message_reactions" VALUES ('4743bd5f-e9c6-4cc8-9e85-7f01af241f98', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'c6ee4fc4-6fd7-48ce-9a53-61d13b78a5a3', 'SAD', '2026-06-07 15:44:38.814');
INSERT INTO "public"."chat_message_reactions" VALUES ('1ed2c988-697b-4a1b-950b-caf2733cfc9d', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', '7ac0ec10-9bd9-406c-9a03-f40f57e33732', 'LOVE', '2026-06-08 16:59:10.805');
INSERT INTO "public"."chat_message_reactions" VALUES ('ea8257ed-7a06-462c-9082-dee6e48c3a8f', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2849218f-a2f0-4b6d-988d-17bab896bfa2', 'LOVE', '2026-06-09 07:05:33.63');
INSERT INTO "public"."chat_message_reactions" VALUES ('2dd28eea-0eff-4fe5-8201-c240969c7f41', '19315748-376c-4aab-9307-936d740fbfec', 'db2fb979-293d-4687-9b5d-56c43a91d7ca', 'LOVE', '2026-07-27 09:47:04.966');

-- ----------------------------
-- Table structure for chat_messages
-- ----------------------------
DROP TABLE IF EXISTS "public"."chat_messages";
CREATE TABLE "public"."chat_messages" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "room_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "sender_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "type" "public"."MessageType" NOT NULL DEFAULT 'TEXT'::"MessageType",
  "reply_to_id" text COLLATE "pg_catalog"."default",
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(3) NOT NULL,
  "read_by" text[] COLLATE "pg_catalog"."default",
  "is_forwarded" bool NOT NULL DEFAULT false
)
;

-- ----------------------------
-- Records of chat_messages
-- ----------------------------
INSERT INTO "public"."chat_messages" VALUES ('13b05140-4a43-4013-ba7a-fb4537e1372a', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'chào', 'TEXT', NULL, '2025-06-17 08:21:34.615', '2025-06-17 08:21:34.615', '{6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('2c45e133-58b8-42ca-9b72-9a9d6dc29c0e', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'Xin chào! Đây là tin nhắn đầu tiên.', 'TEXT', NULL, '2025-06-13 17:35:36.445', '2026-06-06 19:26:10.943', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('13b05140-4a43-4013-ba7a-fb4537e1372d', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'abc', 'TEXT', NULL, '2025-06-17 08:21:34.615', '2026-06-06 19:26:10.943', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('5d5a849d-2579-4124-bf1d-98d4ae7ee56b', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'ohh hi', 'TEXT', NULL, '2026-06-06 18:56:08.713', '2026-06-06 19:26:10.943', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('4918fae7-458b-47d2-baf0-4cdee8264c88', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'hi', 'TEXT', NULL, '2026-06-06 19:06:23.983', '2026-06-06 19:26:10.943', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('6bdf31dc-669d-4a75-ae2b-6a770001dc4e', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'alo', 'TEXT', NULL, '2026-06-06 19:09:12.058', '2026-06-06 19:26:10.943', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('5357047f-f573-4435-83c5-7af48e70db53', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'hi', 'TEXT', NULL, '2026-06-06 18:55:58.085', '2026-06-06 19:26:17.304', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('2222534d-35d1-4cdb-9dde-5e96431ce14b', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'hii', 'TEXT', NULL, '2026-06-06 19:27:29.925', '2026-06-06 19:35:48.042', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('fa9c7a51-012b-45bd-a438-086c02b8a46d', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'hi', 'TEXT', NULL, '2026-06-06 19:36:43.816', '2026-06-06 19:36:47.303', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('499cddf7-cb75-4d60-a639-cce9366050ac', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'hi', 'TEXT', NULL, '2026-06-06 19:36:59.845', '2026-06-06 19:37:00.795', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('d19a8907-b808-486e-9d5d-6e3b2718f98b', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'hi', 'TEXT', NULL, '2026-06-06 19:36:59.877', '2026-06-06 19:37:00.795', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('4698cc67-85ce-440f-b6e2-d5ff3ecd3576', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'hi', 'TEXT', NULL, '2026-06-06 19:37:13.283', '2026-06-06 19:37:14.353', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('a7826030-10b6-4290-a2c8-e2dded4212ec', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'hihi', 'TEXT', NULL, '2026-06-06 19:37:49.216', '2026-06-06 19:37:50.088', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('c40da8b0-417a-4adf-8aac-4da11191223c', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'hihi', 'TEXT', NULL, '2026-06-06 19:37:58.294', '2026-06-06 19:37:59.071', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('22f6f8bd-8dd9-45b4-8983-89345269bc1e', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'hi', 'TEXT', NULL, '2026-06-06 19:38:08.727', '2026-06-06 19:38:09.386', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('89944f9d-ce89-4e67-a75f-78e64dee8608', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'okok', 'TEXT', NULL, '2026-06-06 19:48:14.819', '2026-06-06 19:48:15.643', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('eab65270-37ae-4fe2-9359-4f70fc4995aa', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'h', 'TEXT', NULL, '2026-06-06 19:48:21.478', '2026-06-06 19:48:22.686', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('c012e347-b8c1-4e0c-a514-dcb87d7d603c', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:48:21.646', '2026-06-06 19:48:22.686', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('dc6c4609-2b32-4db2-80d1-8095c2a6bea6', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:48:21.787', '2026-06-06 19:48:22.686', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('878cfd97-555e-4573-a9b3-46af604cbc0a', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:48:21.901', '2026-06-06 19:48:22.686', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('85f4c38f-6ca6-4edd-8b20-79e5e8e4862b', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:48:22.012', '2026-06-06 19:48:22.686', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('7e6955c3-b516-4a8a-b933-4cee6523e7f4', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:48:22.135', '2026-06-06 19:48:22.686', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('a0831eb9-3b9a-4af9-aecb-b4343bad8c88', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'hi', 'TEXT', NULL, '2026-06-06 19:50:58.389', '2026-06-06 19:50:58.973', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('32cfbb4a-010a-4289-91fe-d63e079006c0', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'hi', 'TEXT', NULL, '2026-06-06 19:51:04.944', '2026-06-06 19:51:05.442', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('c49202e9-9feb-4f93-bdba-9c6de5217484', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '...', 'TEXT', NULL, '2026-06-06 19:51:15.411', '2026-06-06 19:51:15.904', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('ad2532b8-0c70-47d3-99ec-fd9d6f5019bd', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'hi', 'TEXT', NULL, '2026-06-06 19:52:20.629', '2026-06-06 19:52:21.277', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('2b208f13-b203-4dd2-9fa7-122ee8d94ce4', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '..', 'TEXT', NULL, '2026-06-06 19:52:59.148', '2026-06-06 19:52:59.846', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('56a4db86-cf7a-4e5d-a898-2ff20dc49189', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '/', 'TEXT', NULL, '2026-06-06 19:52:26.382', '2026-06-06 19:52:27.558', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('729c4b7c-fbc5-4fc7-85a3-76f973173776', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '/', 'TEXT', NULL, '2026-06-06 19:52:26.63', '2026-06-06 19:52:27.558', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b4f27d56-c6b6-4b88-9a78-2c40c65e9aea', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '/', 'TEXT', NULL, '2026-06-06 19:52:26.927', '2026-06-06 19:52:27.558', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('1a742b89-7fb8-4a5c-9722-ed60bc82a0e0', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:52:59.356', '2026-06-06 19:52:59.846', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('d52dd958-0c15-4b5d-8396-9e285534b9b9', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '...', 'TEXT', NULL, '2026-06-06 19:52:59.757', '2026-06-06 19:53:01.992', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('3e1439ed-4208-4ae1-9964-32f90d4ecffb', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:52:59.874', '2026-06-06 19:53:01.992', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('f3d33523-3604-420b-a107-1232204e9a50', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:53:00.581', '2026-06-06 19:53:01.992', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('4ff31923-22f5-4f26-98b7-adbd76028644', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:52:59.961', '2026-06-06 19:53:01.992', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('56c8b7f0-2a19-4663-a84f-4e5e06304572', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:53:01.329', '2026-06-06 19:53:01.992', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('606eb225-d147-482e-b675-f3723d0548ae', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:53:01.282', '2026-06-06 19:53:01.992', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('74200993-7ca9-4c5c-9f8b-c3ca24c1afb6', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:53:00.097', '2026-06-06 19:53:01.992', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('40598294-d7bf-4c77-a856-797c2f5fe31d', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:53:00.941', '2026-06-06 19:53:01.992', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('5307412b-b8df-4cf7-b99f-41684a4128f7', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:53:00.941', '2026-06-06 19:53:01.992', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('bc0686f4-c340-4b35-ab76-f80f4d601969', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:53:00.963', '2026-06-06 19:53:01.992', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('6604d596-26f3-4522-86a2-c811b3dbf95e', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:53:01.33', '2026-06-06 19:53:01.992', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('3b90046b-79fd-40bb-8679-e6c46d018c5e', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:53:01.416', '2026-06-06 19:53:01.992', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('e33930b1-58fe-487c-8439-888e2d5f442e', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '.', 'TEXT', NULL, '2026-06-06 19:53:16.89', '2026-06-06 19:53:17.485', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('3678f30a-f87f-4333-b126-645e5d2a8ea3', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'hihiihi', 'TEXT', NULL, '2026-06-06 19:58:16.526', '2026-06-06 19:58:17.148', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('a683f2fb-e3a2-452e-bc24-9352e669636d', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '.', 'TEXT', NULL, '2026-06-06 20:00:52.407', '2026-06-06 20:00:53.223', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('7127bb7f-bffd-49f8-8403-c3a1c4892dc4', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '.', 'TEXT', NULL, '2026-06-06 20:00:56.201', '2026-06-06 20:00:57.103', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('852e884e-74df-42eb-a7c2-02e8f188c894', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '.', 'TEXT', NULL, '2026-06-06 20:00:56.456', '2026-06-06 20:00:57.103', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('8d6d7197-4a75-408b-acc1-ec5063d29b87', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780776252753_ccc839332d89d6150db61b7e47da89f1.gif.webp', 'IMAGE', NULL, '2026-06-06 20:04:16.728', '2026-06-06 20:04:17.345', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('0ab8f7d3-6847-4e9a-9a77-8f8d2682a06c', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780776639557_image.png.webp', 'IMAGE', NULL, '2026-06-06 20:10:40.701', '2026-06-06 20:10:41.367', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('5d36a5f5-1f24-4e1a-aa2d-05e672e01065', 'a28b6227-498e-4dfe-85df-26b8bda65814', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ê', 'TEXT', NULL, '2026-06-06 20:17:20.83', '2026-06-06 20:17:20.83', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('73b23ff6-796d-4ad9-b586-80a3ff72a4ee', 'b172148a-754a-478e-a45c-6434202859c2', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'cccd5333-3355-4a54-b566-1a137fd28a1b', 'POST_SHARE', NULL, '2026-06-08 09:10:27.62', '2026-06-08 09:10:27.62', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 't');
INSERT INTO "public"."chat_messages" VALUES ('0d3647d9-8ac2-49a4-9503-3e0c52a3bbea', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '????????', 'TEXT', NULL, '2026-06-14 12:12:53.747', '2026-06-14 12:13:00.08', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('53682b3c-e46b-4020-b48f-e61c9dc3aff8', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'hi sếp', 'TEXT', NULL, '2026-06-06 20:27:12.377', '2026-06-06 20:34:29.974', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('a1921203-6a15-4fe4-b089-5d812bd9d48e', '7caba933-0236-4a2f-b486-a5e94d0a1311', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ok', 'TEXT', NULL, '2026-06-06 20:34:43.985', '2026-06-06 20:34:48.242', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,9b00b60c-005d-4ad2-832b-d2d0abcd5fc8}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('097714c6-5ad8-4772-b22d-40434c220322', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'kk', 'TEXT', NULL, '2026-06-06 20:34:52.959', '2026-06-06 20:34:53.723', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('7e7443fa-c3d0-4865-904a-4fe73d3225f6', '7caba933-0236-4a2f-b486-a5e94d0a1311', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ád', 'TEXT', NULL, '2026-06-06 20:35:06.853', '2026-06-06 20:38:18.812', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,9b00b60c-005d-4ad2-832b-d2d0abcd5fc8}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('6e9e2b78-a2b6-45f8-bcf3-670a84da713c', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'dâf', 'TEXT', NULL, '2026-06-06 20:35:10.102', '2026-06-06 20:35:10.913', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('2d8e7c69-e332-4152-917f-cc16ac724962', 'b172148a-754a-478e-a45c-6434202859c2', '2b707d22-77db-4861-b148-ff41a49f1ea9', 'hi sếp', 'TEXT', NULL, '2026-06-06 20:41:17.078', '2026-06-06 20:59:08.013', '{2b707d22-77db-4861-b148-ff41a49f1ea9,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,9b00b60c-005d-4ad2-832b-d2d0abcd5fc8}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('8a0e1886-35dd-4a5c-b294-5a978a495475', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'hi', 'TEXT', NULL, '2026-06-06 20:59:27.132', '2026-06-06 20:59:27.894', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b537111c-0ba5-4925-8cec-3da7c5ce4600', '808afebe-bdca-4d04-bfaf-9e838a4e6ce9', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', '...', 'TEXT', NULL, '2026-06-06 20:18:00.103', '2026-06-06 20:59:58.103', '{ba1b25ea-053b-4100-a4ad-a92959914eeb,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,9b00b60c-005d-4ad2-832b-d2d0abcd5fc8}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('8eeb60a2-9f9a-4041-843e-8fb946d33110', '808afebe-bdca-4d04-bfaf-9e838a4e6ce9', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', '..', 'TEXT', NULL, '2026-06-06 20:24:52.747', '2026-06-06 20:59:58.103', '{ba1b25ea-053b-4100-a4ad-a92959914eeb,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,9b00b60c-005d-4ad2-832b-d2d0abcd5fc8}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('60616c9f-f198-4f69-a362-2e3aedc9f204', '808afebe-bdca-4d04-bfaf-9e838a4e6ce9', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', '.', 'TEXT', NULL, '2026-06-06 20:25:35.42', '2026-06-06 20:59:58.103', '{ba1b25ea-053b-4100-a4ad-a92959914eeb,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,9b00b60c-005d-4ad2-832b-d2d0abcd5fc8}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('1c1e45f7-00b7-4577-90ab-2dbf1d1c3380', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'hi', 'TEXT', NULL, '2026-06-06 21:04:12.567', '2026-06-06 21:04:13.184', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('17f60a32-c171-4f38-ba53-78dbbe03cdf8', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'aloooooooo', 'TEXT', NULL, '2026-06-07 10:28:48.749', '2026-06-07 10:28:56.389', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('684fc07b-4199-49df-82b5-a5e7c795e3d5', '75489092-c7e9-491f-98ee-b784d87df2f2', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ê', 'TEXT', NULL, '2026-06-07 13:42:14.279', '2026-06-07 13:42:40.163', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,02ad241e-66a7-4e44-99fd-36fced0ca386}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('3c71bca8-f32c-4acc-a768-700e29c643fb', '75489092-c7e9-491f-98ee-b784d87df2f2', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'tesst 123', 'TEXT', NULL, '2026-06-07 13:42:44.265', '2026-06-07 13:42:54.88', '{02ad241e-66a7-4e44-99fd-36fced0ca386,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('9fbf216e-d561-4a92-903d-52760f106121', '75489092-c7e9-491f-98ee-b784d87df2f2', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'hi', 'TEXT', NULL, '2026-06-07 13:43:11.331', '2026-06-07 13:43:18.123', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,02ad241e-66a7-4e44-99fd-36fced0ca386}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('7ce91fdf-6114-4acf-9bc9-5f7bea8e4b4a', '75489092-c7e9-491f-98ee-b784d87df2f2', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'dfasdf', 'TEXT', NULL, '2026-06-07 13:43:17.518', '2026-06-07 13:43:29.998', '{02ad241e-66a7-4e44-99fd-36fced0ca386,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('842eab6a-2330-4e55-8583-0f53ffc6b664', '75489092-c7e9-491f-98ee-b784d87df2f2', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'hi', 'TEXT', NULL, '2026-06-07 13:43:29.455', '2026-06-07 13:43:54.511', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,02ad241e-66a7-4e44-99fd-36fced0ca386}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('48b19186-6519-4180-bfb9-024c2fa0dc88', '75489092-c7e9-491f-98ee-b784d87df2f2', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'yêu Dâu Vãi', 'TEXT', NULL, '2026-06-07 13:44:05.14', '2026-06-07 13:54:07.394', '{02ad241e-66a7-4e44-99fd-36fced0ca386,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('93cca6c2-0818-456c-9a7a-966afc3ba32c', '75489092-c7e9-491f-98ee-b784d87df2f2', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '123', 'TEXT', NULL, '2026-06-07 13:54:39.875', '2026-06-07 13:54:54.178', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,02ad241e-66a7-4e44-99fd-36fced0ca386}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('e3a9c13c-6ce7-48a6-baf1-5f5d92143a55', 'd493ea86-8a7b-4e84-b2a6-4e2c82899d52', 'c260b4cf-e769-4656-9073-f595b748a69b', 'ahihi', 'TEXT', NULL, '2026-06-07 13:57:09.761', '2026-06-07 13:57:18.941', '{c260b4cf-e769-4656-9073-f595b748a69b,02ad241e-66a7-4e44-99fd-36fced0ca386}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('e9cb471c-05fe-415c-a6e0-b7a98b31b5d4', 'd493ea86-8a7b-4e84-b2a6-4e2c82899d52', 'c260b4cf-e769-4656-9073-f595b748a69b', 'dsfsadfsdfsadfasdf', 'TEXT', NULL, '2026-06-07 13:57:39.849', '2026-06-07 13:57:40.428', '{c260b4cf-e769-4656-9073-f595b748a69b,02ad241e-66a7-4e44-99fd-36fced0ca386}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('553272a5-b872-416f-bd0a-d069c19cf017', 'd493ea86-8a7b-4e84-b2a6-4e2c82899d52', 'c260b4cf-e769-4656-9073-f595b748a69b', 'fsdfsadfadsf', 'TEXT', NULL, '2026-06-07 13:57:42.295', '2026-06-07 13:57:42.783', '{c260b4cf-e769-4656-9073-f595b748a69b,02ad241e-66a7-4e44-99fd-36fced0ca386}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('73b857fa-ec77-4cad-97bf-ed1ff46caf5d', 'd493ea86-8a7b-4e84-b2a6-4e2c82899d52', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'fadsfasdfasdfasdfasdfadsfadsfasdfasdfasdfasdf', 'TEXT', NULL, '2026-06-07 13:57:59.93', '2026-06-07 13:58:00.45', '{02ad241e-66a7-4e44-99fd-36fced0ca386,c260b4cf-e769-4656-9073-f595b748a69b}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('6b589d0e-40fb-4ae5-9d72-8c47ebbba695', 'd493ea86-8a7b-4e84-b2a6-4e2c82899d52', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'fsdafasdfasdffasdfasdfasdf', 'TEXT', NULL, '2026-06-07 13:58:04.722', '2026-06-07 13:58:05.251', '{02ad241e-66a7-4e44-99fd-36fced0ca386,c260b4cf-e769-4656-9073-f595b748a69b}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('dc86d8e7-611d-4de9-8431-5c81510f7199', 'd493ea86-8a7b-4e84-b2a6-4e2c82899d52', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'sdfasdfasdfasdfasdfasdf', 'TEXT', NULL, '2026-06-07 13:58:07.416', '2026-06-07 13:58:08.077', '{02ad241e-66a7-4e44-99fd-36fced0ca386,c260b4cf-e769-4656-9073-f595b748a69b}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('c11e6239-b12e-4d85-a39a-142f31870f58', '75489092-c7e9-491f-98ee-b784d87df2f2', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'yeu dau vai o', 'TEXT', NULL, '2026-06-07 13:54:59.108', '2026-06-07 13:58:34.864', '{02ad241e-66a7-4e44-99fd-36fced0ca386,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('373e2983-c57e-470e-9b3a-87f08a6d608d', '7732493e-30f8-4f7b-ae33-c5403e8d789e', 'c260b4cf-e769-4656-9073-f595b748a69b', 'mochi Dau', 'TEXT', NULL, '2026-06-07 13:58:41.525', '2026-06-07 13:58:53.698', '{c260b4cf-e769-4656-9073-f595b748a69b,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('13764eec-25e7-4483-8767-b9d2f2882f0d', '7732493e-30f8-4f7b-ae33-c5403e8d789e', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ê', 'TEXT', NULL, '2026-06-07 13:59:07.894', '2026-06-07 13:59:18.478', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,c260b4cf-e769-4656-9073-f595b748a69b}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('3bee3bd9-f930-4e23-9918-48acd04e5ef6', '7732493e-30f8-4f7b-ae33-c5403e8d789e', 'c260b4cf-e769-4656-9073-f595b748a69b', 'dsfsdafasdfasdfasdf', 'TEXT', NULL, '2026-06-07 13:59:22.762', '2026-06-07 14:01:12.858', '{c260b4cf-e769-4656-9073-f595b748a69b,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('17663ea4-741d-4e53-9ae2-a7992f8ec5ef', '7732493e-30f8-4f7b-ae33-c5403e8d789e', 'c260b4cf-e769-4656-9073-f595b748a69b', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780840827925_1775729853311_blob.jpg.webp', 'IMAGE', NULL, '2026-06-07 14:00:32.076', '2026-06-07 14:01:12.858', '{c260b4cf-e769-4656-9073-f595b748a69b,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('c6ee4fc4-6fd7-48ce-9a53-61d13b78a5a3', '7caba933-0236-4a2f-b486-a5e94d0a1311', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'spam à ?', 'TEXT', NULL, '2026-06-07 15:44:34.18', '2026-06-07 15:44:34.916', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,9b00b60c-005d-4ad2-832b-d2d0abcd5fc8}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('d2272c75-6d40-4032-a5fc-b602ad047a34', 'b172148a-754a-478e-a45c-6434202859c2', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'cccd5333-3355-4a54-b566-1a137fd28a1b', 'POST_SHARE', NULL, '2026-06-08 09:09:55.106', '2026-06-08 09:09:55.106', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('bd821c73-b168-46ca-8bfb-09c0a7488cb1', 'b172148a-754a-478e-a45c-6434202859c2', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'aloooooooo', 'TEXT', NULL, '2026-06-08 09:10:41.988', '2026-06-08 09:10:41.988', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 't');
INSERT INTO "public"."chat_messages" VALUES ('65eff929-b38a-4e46-a529-dddc152ce2cd', 'b172148a-754a-478e-a45c-6434202859c2', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '{"url":"https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/chat/d66d20e6-d9cc-4218-9de6-8eeae42ea9ca/2026/1780915215783_voice-1780915215626.webm","duration":5,"size":89168}', 'VOICE', NULL, '2026-06-08 10:40:17.169', '2026-06-08 10:40:17.169', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('6a7af4bf-e0d0-47b8-9a0d-381c40d184bb', '7caba933-0236-4a2f-b486-a5e94d0a1311', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', ':))', 'TEXT', NULL, '2026-06-07 15:45:12.587', '2026-06-08 14:36:32.666', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,9b00b60c-005d-4ad2-832b-d2d0abcd5fc8}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('8e9efe49-81b1-4a80-830a-e3b0cfcec4ed', '7caba933-0236-4a2f-b486-a5e94d0a1311', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '3faf3afd-24eb-4fd1-ac14-5d5db1dd268d', 'POST_SHARE', NULL, '2026-06-08 09:09:32.359', '2026-06-08 14:36:32.666', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,9b00b60c-005d-4ad2-832b-d2d0abcd5fc8}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('7ac0ec10-9bd9-406c-9a03-f40f57e33732', '7caba933-0236-4a2f-b486-a5e94d0a1311', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'cccd5333-3355-4a54-b566-1a137fd28a1b', 'POST_SHARE', NULL, '2026-06-08 09:09:54.509', '2026-06-08 14:36:32.666', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,9b00b60c-005d-4ad2-832b-d2d0abcd5fc8}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('3c231797-f8bd-451f-ada9-cf7a037cb5aa', '7caba933-0236-4a2f-b486-a5e94d0a1311', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '{"kind":"call","callType":"audio","status":"missed","duration":0}', 'SYSTEM', NULL, '2026-06-08 16:58:30.627', '2026-06-08 16:58:31.527', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,9b00b60c-005d-4ad2-832b-d2d0abcd5fc8}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b538d50f-73c6-497e-b7cc-fb6d14edfa0c', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', '{"kind":"call","callType":"audio","status":"ended","duration":8}', 'SYSTEM', NULL, '2026-06-08 16:59:02.746', '2026-06-08 16:59:03.751', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('9895952e-18fa-4b53-b0a4-4160e8290225', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', '{"kind":"call","callType":"audio","status":"missed","duration":0}', 'SYSTEM', NULL, '2026-06-08 17:25:24.418', '2026-06-08 17:25:25.295', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('dfdbd848-887b-4992-9bb1-fc6978132310', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'ê', 'TEXT', NULL, '2026-06-08 18:30:50.44', '2026-06-08 18:41:24.087', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('56280d5d-d550-4149-9402-6696538de700', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'ê', 'TEXT', NULL, '2026-06-08 18:30:59.182', '2026-06-08 18:41:24.087', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b95265f4-b53b-4055-a5a2-40dd41180378', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'hihi', 'TEXT', NULL, '2026-06-08 18:41:12.148', '2026-06-08 18:41:24.087', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('382cba01-97de-40c5-b590-a5de1ed94aa8', 'b1a3608d-cc7e-4991-a2a0-4e721948de31', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'dac8d203-2286-49a1-a863-6288aedd31a5', 'POST_SHARE', NULL, '2026-06-09 06:58:27.214', '2026-06-09 06:58:27.214', '{9e0c791c-c424-43fa-9c48-d73b11796ec9}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b8c6038f-1acd-427f-a169-a3b327ca899b', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ê', 'TEXT', NULL, '2026-06-08 20:44:36.926', '2026-06-14 11:59:12.393', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('87d9f69f-519f-4e00-9298-a8b614901768', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'ee', 'TEXT', NULL, '2026-06-08 18:48:02.435', '2026-06-14 12:02:07.525', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('f6f536e9-d967-4bc2-9389-80e645efc98e', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'eeee', 'TEXT', NULL, '2026-06-08 18:48:07.565', '2026-06-14 12:02:07.525', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('f5d9737e-0887-44b8-9749-312e3082b2c2', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'aloooo', 'TEXT', NULL, '2026-06-08 18:48:18.875', '2026-06-14 12:02:07.525', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b6983879-f008-4b49-98a9-0d785a5ab243', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'aaa', 'TEXT', NULL, '2026-06-08 18:48:59.891', '2026-06-14 12:02:07.525', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('c2a1f6e4-e5e6-4743-bc54-b685057f0965', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'alo', 'TEXT', NULL, '2026-06-08 19:21:27.702', '2026-06-14 12:02:07.525', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('de6eaa70-b662-4442-9276-603c88b48768', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'aaaaaaaaaa', 'TEXT', NULL, '2026-06-08 19:21:53.882', '2026-06-14 12:02:07.525', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('3c9d3fdd-e1f5-4bab-b1c3-80d11dbd83ef', 'b1a3608d-cc7e-4991-a2a0-4e721948de31', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '{"url":"https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/chat/9e0c791c-c424-43fa-9c48-d73b11796ec9/2026/1780988331602_voice-1780988331486.webm","duration":6,"size":104624}', 'VOICE', NULL, '2026-06-09 06:58:53.345', '2026-06-09 06:58:53.345', '{9e0c791c-c424-43fa-9c48-d73b11796ec9}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('440648bd-6d8a-4395-b2c2-82703c9cefbd', '7338776b-b23f-48f4-930f-5cd093963b2e', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'hi', 'TEXT', NULL, '2026-06-09 06:59:55.143', '2026-06-09 07:00:02.618', '{9e0c791c-c424-43fa-9c48-d73b11796ec9,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('99194d44-a62f-4336-aed9-590a33b5dc3f', '7338776b-b23f-48f4-930f-5cd093963b2e', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '?', 'TEXT', NULL, '2026-06-09 07:00:06.493', '2026-06-09 07:00:07.223', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,9e0c791c-c424-43fa-9c48-d73b11796ec9}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('5ba937b9-6a86-4ece-bcc8-fda10ff56771', '7338776b-b23f-48f4-930f-5cd093963b2e', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'hi sep', 'TEXT', NULL, '2026-06-09 07:02:09.866', '2026-06-09 07:05:46.585', '{9e0c791c-c424-43fa-9c48-d73b11796ec9,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('8c0ba9f0-1cce-4de6-80e6-73549e574537', '7338776b-b23f-48f4-930f-5cd093963b2e', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '{"kind":"call","callType":"audio","status":"ended","duration":35}', 'SYSTEM', NULL, '2026-06-09 07:01:23.997', '2026-06-09 07:01:44.918', '{9e0c791c-c424-43fa-9c48-d73b11796ec9,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b3d3e388-9b3b-4364-afc5-9b1e6751da6b', '7338776b-b23f-48f4-930f-5cd093963b2e', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'hi', 'TEXT', NULL, '2026-06-09 07:02:39.544', '2026-06-09 07:05:46.585', '{9e0c791c-c424-43fa-9c48-d73b11796ec9,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('2849218f-a2f0-4b6d-988d-17bab896bfa2', '7338776b-b23f-48f4-930f-5cd093963b2e', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'lll', 'TEXT', NULL, '2026-06-09 07:02:53.813', '2026-06-09 07:05:46.585', '{9e0c791c-c424-43fa-9c48-d73b11796ec9,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b3480fa7-4c21-4890-a4fe-e198a0f82425', 'b172148a-754a-478e-a45c-6434202859c2', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '..', 'TEXT', NULL, '2026-06-14 11:54:45.081', '2026-06-14 11:54:45.081', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b0c5344b-2085-4566-b334-bbb93ed12fc5', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'cc', 'TEXT', NULL, '2026-06-08 21:03:10.525', '2026-06-14 11:59:12.393', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('f8d71eae-c276-4769-a609-474790edc1ce', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'alo', 'TEXT', NULL, '2026-06-08 21:04:06.107', '2026-06-14 11:59:12.393', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('d85295ac-e0c7-4238-9e57-487cb66215b5', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ê', 'TEXT', NULL, '2026-06-08 21:04:15.016', '2026-06-14 11:59:12.393', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('6597429a-2516-41ca-bf09-ddb2e181b733', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'aa', 'TEXT', NULL, '2026-06-08 21:04:29.923', '2026-06-14 11:59:12.393', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('75e8d548-555f-4c98-a804-b169b450d2f5', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'jjkn', 'TEXT', NULL, '2026-06-08 21:34:13.763', '2026-06-14 11:59:12.393', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('ecc6a596-aa60-4620-a0bb-f819593309f9', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'knk', 'TEXT', NULL, '2026-06-08 21:34:24.338', '2026-06-14 11:59:12.393', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('a2648b8c-612d-4a88-841c-2ea9b76cd3e4', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ee', 'TEXT', NULL, '2026-06-14 11:51:03.533', '2026-06-14 11:59:12.393', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b832acd7-ba95-4460-a1ea-068202c8aa7c', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'aaA?', 'TEXT', NULL, '2026-06-14 11:51:16.517', '2026-06-14 11:59:12.393', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('7997f502-2270-44b1-bc80-9ee27691475e', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ee', 'TEXT', NULL, '2026-06-14 11:51:26.696', '2026-06-14 11:59:12.393', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b0309282-c3c7-4582-9cf3-e05b3c9f2bc9', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'alo', 'TEXT', NULL, '2026-06-14 11:51:43.983', '2026-06-14 11:59:12.393', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('ac5455c8-f715-4444-b337-f65c531c22ef', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'aaaaaaaa', 'TEXT', NULL, '2026-06-14 11:52:11.588', '2026-06-14 11:59:12.393', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('23b91b5c-e77a-4e6d-a692-7dc43988fbc9', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ee333', 'TEXT', NULL, '2026-06-14 11:59:20.501', '2026-06-14 11:59:20.658', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('68c6aaca-bc58-4cf5-a482-8d5e4e7dd616', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'hi', 'TEXT', NULL, '2026-06-08 20:20:01.855', '2026-06-14 12:02:07.525', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('d34170e8-db26-4335-b1ca-1534bc2b6bf6', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'alo', 'TEXT', NULL, '2026-06-08 20:20:12.212', '2026-06-14 12:02:07.525', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('595da81a-1f2f-4029-9127-3f02005a6634', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'eeeee', 'TEXT', NULL, '2026-06-08 20:20:31.727', '2026-06-14 12:02:07.525', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('926a239a-7b74-4c94-9ec3-bc7df0e02091', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'alo', 'TEXT', NULL, '2026-06-08 20:24:25.713', '2026-06-14 12:02:07.525', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('1cece1da-c06b-44fa-9d5b-b770cb88e881', '7caba933-0236-4a2f-b486-a5e94d0a1311', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'hey', 'TEXT', NULL, '2026-06-08 20:24:51.174', '2026-06-14 12:02:07.525', '{9b00b60c-005d-4ad2-832b-d2d0abcd5fc8,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('ca409cf0-1f9c-4b19-bbf1-a95a85886023', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'alo', 'TEXT', NULL, '2026-06-14 12:05:39.934', '2026-06-14 12:06:25.484', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('beb017a0-ec9d-4947-8050-0defd90e6d9a', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ee', 'TEXT', NULL, '2026-06-14 12:05:45.648', '2026-06-14 12:06:25.484', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('205ee537-d15f-44ed-8136-d2f8c7e45054', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '🤭', 'TEXT', NULL, '2026-06-14 12:05:59.679', '2026-06-14 12:06:25.484', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('a5ce271a-db13-483e-99fe-deefa9324d55', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'hey', 'TEXT', NULL, '2026-06-14 12:06:28.838', '2026-06-14 12:06:29.726', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('cab93ea8-2f4d-4e89-809b-aba094e5c033', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '?', 'TEXT', NULL, '2026-06-14 12:06:33.287', '2026-06-14 12:08:04.275', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('910e6387-6274-4076-815d-99e7165d10cf', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '????', 'TEXT', NULL, '2026-06-14 12:06:38.039', '2026-06-14 12:08:04.275', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('6d701568-0b06-40e9-853f-05faf003d49b', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'hey', 'TEXT', NULL, '2026-06-14 12:08:48.565', '2026-06-14 12:12:48.362', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('36fc7329-fd3f-40fd-8f20-2210895f6e21', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'eee', 'TEXT', NULL, '2026-06-14 12:13:12.325', '2026-06-14 12:21:22.982', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b5cb634e-1ecc-4048-be2c-57d541e82c0e', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'ágas', 'TEXT', NULL, '2026-06-14 12:13:17.879', '2026-06-14 12:21:22.982', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('24f78a3b-f534-4a15-a767-14821375099e', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'agasg', 'TEXT', NULL, '2026-06-14 12:13:06.759', '2026-06-14 12:21:22.982', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('e8d147d5-82a3-43ab-a46e-f7146cc6c607', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'hey', 'TEXT', NULL, '2026-06-14 12:27:33.951', '2026-06-14 12:28:15.032', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('2f8b31eb-08db-476c-b04a-6ed83f002904', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'ey', 'TEXT', NULL, '2026-06-14 12:27:42.609', '2026-06-14 12:28:15.032', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('24f7c377-a67c-45a3-aca3-ac132c143e66', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'yo', 'TEXT', NULL, '2026-06-14 12:27:52.378', '2026-06-14 12:28:15.032', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('7af7ea43-12cc-48f3-a0fa-a6f398b1cd39', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'ấgasgasg', 'TEXT', NULL, '2026-06-14 12:27:57.118', '2026-06-14 12:28:15.032', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('5a2abbc9-e768-4010-a90a-dcd5e9e897cc', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ê', 'TEXT', NULL, '2026-06-14 12:54:03.153', '2026-06-14 12:54:09.743', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b46e1620-7263-460e-b2e1-070955cbbdaf', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '???', 'TEXT', NULL, '2026-06-14 12:58:12.684', '2026-06-14 12:58:12.797', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('11206f5d-3d77-424a-9ece-6ee045cfbdac', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ee', 'TEXT', NULL, '2026-06-14 13:27:03.407', '2026-06-14 13:27:11.527', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('6cdcc1fa-4979-4535-8c63-5a86dcbdd4a3', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'qwqe', 'TEXT', NULL, '2026-06-14 13:27:09.088', '2026-06-14 13:27:11.527', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('621d2e65-aad1-4eeb-8a80-d072132bfff1', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'ee', 'TEXT', NULL, '2026-06-14 13:27:13.686', '2026-06-14 13:27:13.76', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('acdd2eeb-9ae8-42a6-81a8-0d9c7fa0dcf4', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'hey zo', 'TEXT', NULL, '2026-06-14 13:27:14.663', '2026-06-14 13:27:14.774', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('1120333c-8534-46f6-ab6b-209bd8c41edf', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '11', 'TEXT', NULL, '2026-06-16 18:55:21.236', '2026-06-16 18:55:59.568', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('7c0a82de-635b-466b-a208-c88d20190cd3', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '24', 'TEXT', NULL, '2026-06-16 18:55:43.457', '2026-06-16 18:55:59.568', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('f2b32f2c-23d6-4eb7-a94d-7b3690a3513b', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '142', 'TEXT', NULL, '2026-06-16 18:55:51.998', '2026-06-16 18:55:59.568', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('1ed5b5ef-4101-4206-bf24-b05a73e4ff92', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '123123', 'TEXT', NULL, '2026-06-16 18:56:02.917', '2026-06-16 18:56:03.474', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('193ff52e-d1da-43a9-9bd1-91b8ab78a509', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '124124', 'TEXT', NULL, '2026-06-16 18:56:06.88', '2026-06-16 18:56:22.132', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('e863a34e-2925-4a03-8ee1-584045f36ee8', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'e', 'TEXT', NULL, '2026-06-16 18:56:11.16', '2026-06-16 18:56:22.132', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('8e0bc2a3-ae8d-4721-aeaf-28e0220f2c1a', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '123123132', 'TEXT', NULL, '2026-06-16 18:56:17.923', '2026-06-16 18:56:22.132', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('cac0e13f-794d-4500-9f5d-dd14903ace72', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'alo', 'TEXT', NULL, '2026-06-16 18:56:31.242', '2026-06-16 18:57:06.493', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('0220291d-1b01-4e3b-97d0-0c2eb45c6fc5', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee', 'TEXT', NULL, '2026-06-16 18:56:48.973', '2026-06-16 18:57:06.493', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('828ac616-9c37-400c-be37-8e3bf2957dae', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'qưeqwe', 'TEXT', NULL, '2026-06-16 18:57:29.669', '2026-06-16 18:57:32.371', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('a783811d-aca3-4c79-8c21-2ae2ac9f4e07', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'qưeqwe', 'TEXT', NULL, '2026-06-16 18:58:09.794', '2026-06-16 18:58:10.36', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('eabeacac-59d6-4354-8349-c01bd42c5558', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'eee', 'TEXT', NULL, '2026-06-16 18:58:15.407', '2026-06-16 18:58:16.189', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('cd81834c-293d-4748-8d10-e17e20ce1fac', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'qưe', 'TEXT', NULL, '2026-06-16 18:58:30.737', '2026-06-16 18:58:31.249', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('22df2e33-c02c-4a97-bd22-39b99a1e21dc', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'alo', 'TEXT', NULL, '2026-06-16 18:59:07.681', '2026-06-16 18:59:17.068', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('05491260-b83d-47fd-a3c8-83266bb3f981', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'eee', 'TEXT', NULL, '2026-06-16 18:59:20.492', '2026-06-16 18:59:27.32', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('fb368e6d-d6d8-4c82-9433-c7757e412639', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'alo', 'TEXT', NULL, '2026-06-16 18:59:29.427', '2026-06-16 18:59:29.503', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('ed750e3f-8e11-4ddb-9fe5-c3a0f8fd812a', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'elo', 'TEXT', NULL, '2026-06-16 18:59:31.73', '2026-06-16 18:59:31.8', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('bddee702-9715-407a-abd3-0d0935ca809d', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'aaaaa', 'TEXT', NULL, '2026-06-16 18:59:37.347', '2026-06-16 18:59:40.053', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('41b34af6-df2f-48fb-863f-54108684755b', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '{"kind":"call","callType":"audio","status":"ended","duration":6}', 'SYSTEM', NULL, '2026-06-16 19:00:14.19', '2026-06-16 19:00:14.305', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('c201e553-a706-4984-9bdf-0e2c0863a885', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'a', 'TEXT', NULL, '2026-06-16 19:07:34.434', '2026-06-16 19:12:46.65', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('1937eed6-76ce-4575-88f7-6887c89c37f7', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'sfisniasjf', 'TEXT', NULL, '2026-06-16 19:07:39.901', '2026-06-16 19:12:46.65', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('8e583df7-078d-4a53-904d-91f7f689d993', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'a', 'TEXT', NULL, '2026-06-16 19:07:51.092', '2026-06-16 19:12:46.65', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('8ab4c84b-3f4c-4f17-8c4f-4f152908def4', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'fsafskgmdg', 'TEXT', NULL, '2026-06-16 19:08:01.856', '2026-06-16 19:12:46.65', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('9223a425-3e85-4341-8b5d-8a5adbe18e1f', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'aa', 'TEXT', NULL, '2026-06-16 19:12:42.918', '2026-06-16 19:12:46.65', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b6bf6547-e18a-43ad-b7f3-a28736c07a46', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ee', 'TEXT', NULL, '2026-06-16 19:58:52.811', '2026-06-16 20:05:38.699', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('8f6d1ed0-1a81-405b-a736-8c5c6a0809bf', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'qưeqwe', 'TEXT', NULL, '2026-06-16 19:58:57.8', '2026-06-16 20:05:38.699', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('273fc555-7a09-4bc0-8681-4ad208a1367b', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ee', 'TEXT', NULL, '2026-06-16 19:59:57.131', '2026-06-16 20:05:38.699', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('a7e3db85-6295-4cdb-9bc2-dea0deab176b', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ee', 'TEXT', NULL, '2026-06-16 20:05:34.71', '2026-06-16 20:05:38.699', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('4f5eb2e3-6164-4084-8805-074e33597ee9', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'qưe', 'TEXT', NULL, '2026-06-16 20:05:40.834', '2026-06-16 20:06:26.072', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('81754668-721e-4568-ab89-9e66ccccef9a', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'qưe', 'TEXT', NULL, '2026-06-16 20:09:45.393', '2026-06-16 20:10:04.682', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('aa3bc46f-4b25-4f6a-905f-f48bdc9b5ea3', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'alo', 'TEXT', NULL, '2026-06-16 20:10:06.299', '2026-06-16 20:11:47.711', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('a1081804-5b02-442f-83ed-c960356a91f3', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'alo', 'TEXT', NULL, '2026-06-16 20:10:09.668', '2026-06-16 20:11:47.746', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('c39eeb5c-2b09-428f-bcf7-7f5fb1e6084e', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'eeeeeee', 'TEXT', NULL, '2026-06-16 20:15:43.669', '2026-06-16 20:17:21.192', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('a617adc9-a75c-4b7d-b301-4c8c3edec542', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'ey', 'TEXT', NULL, '2026-06-16 20:18:53.612', '2026-06-16 20:24:15.615', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('fb720cb9-64c6-4988-a92a-1968e4fd263d', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'alo', 'TEXT', NULL, '2026-06-16 20:25:47.997', '2026-06-16 20:30:59.313', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('de7bb4cc-7751-4b73-9ae7-913385886ce2', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '123', 'TEXT', NULL, '2026-06-16 20:29:24.192', '2026-06-16 20:30:59.313', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('32557f5b-e709-4603-a0ed-9daf58598b79', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ávasv', 'TEXT', NULL, '2026-06-16 20:31:41.092', '2026-06-16 20:35:03.221', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('82af02fd-717d-46eb-b0fa-7a6cc1c4e556', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '1111111111111111111', 'TEXT', NULL, '2026-06-16 20:31:46.821', '2026-06-16 20:35:03.221', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('e5d0944b-015f-4122-8d2a-c934bc9d0c1a', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '123123', 'TEXT', NULL, '2026-06-16 20:44:26.708', '2026-06-16 20:44:45.362', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('54882baa-93a1-44dc-a74b-f22f6be99569', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'aALOO', 'TEXT', NULL, '2026-06-16 20:44:50.656', '2026-06-16 20:44:51.49', '{d66d20e6-d9cc-4218-9de6-8eeae42ea9ca,6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('4ae03c9f-89fc-476a-8e0f-526c3e3a8ce4', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'ngon r', 'TEXT', NULL, '2026-06-16 20:44:57.583', '2026-06-16 20:44:58.398', '{6a31a93a-a961-48d6-963e-0645f99de8e4,d66d20e6-d9cc-4218-9de6-8eeae42ea9ca}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('f53186e6-faa5-4112-88c6-641108393f7c', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '?', 'TEXT', NULL, '2026-06-25 18:59:14.796', '2026-06-25 18:59:14.796', '{6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('ac0ea7a8-8329-40ae-a129-e00ad0360769', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', '?', 'TEXT', NULL, '2026-06-25 18:59:18.814', '2026-06-25 18:59:18.814', '{6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('4fbb89a2-e4f9-40a1-bfab-20f41ec43d84', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'e', 'TEXT', NULL, '2026-06-25 18:59:27.761', '2026-06-25 18:59:27.761', '{6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('acba9019-0216-4f3b-b433-dcf1b15598ed', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'ê', 'TEXT', NULL, '2026-06-25 21:07:13.525', '2026-06-25 21:07:13.525', '{6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('9fe0575c-d0a9-4d1c-a540-a36fa93357bf', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'ee', 'TEXT', NULL, '2026-06-25 21:07:15.411', '2026-06-25 21:07:15.411', '{6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('d85dee27-f7f3-41a7-b7ea-0e7187b863dc', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'zcx', 'TEXT', NULL, '2026-06-25 21:11:48.92', '2026-06-25 21:11:48.92', '{6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('ef92a17b-4f87-44f9-a512-108d5816c760', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'zcx', 'TEXT', NULL, '2026-06-25 21:11:51.97', '2026-06-25 21:11:51.97', '{6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('0cd437ea-a082-4628-a0cc-fc4ec943e887', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'zxc', 'TEXT', NULL, '2026-06-25 21:11:54.086', '2026-06-25 21:11:54.086', '{6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('aa42743d-ead7-479f-a194-c76b65aa795d', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'á', 'TEXT', NULL, '2026-06-25 21:11:54.942', '2026-06-25 21:11:54.942', '{6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('f5274ec7-86ae-442a-8532-f63d325c7d30', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'zxc', 'TEXT', NULL, '2026-06-25 21:12:08.79', '2026-06-25 21:12:08.79', '{6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('3b75e024-5de8-4e1a-a9b0-3cfb00f60000', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'ee', 'TEXT', NULL, '2026-06-25 21:12:23.864', '2026-06-25 21:12:23.864', '{6a31a93a-a961-48d6-963e-0645f99de8e4}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('db2fb979-293d-4687-9b5d-56c43a91d7ca', '5efea9f7-6ff1-47cf-bf86-4f60e5cbb5c7', '19315748-376c-4aab-9307-936d740fbfec', 'nhớ em quá', 'TEXT', NULL, '2026-07-27 09:44:55.898', '2026-07-27 09:44:55.898', '{19315748-376c-4aab-9307-936d740fbfec}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('b167f13c-dce5-4730-872c-932e1f4208cc', '0006169e-fb97-4060-b499-da5d75833034', '19315748-376c-4aab-9307-936d740fbfec', 'shit@!', 'TEXT', NULL, '2026-07-27 14:33:23.223', '2026-07-27 14:33:23.223', '{19315748-376c-4aab-9307-936d740fbfec}', 'f');
INSERT INTO "public"."chat_messages" VALUES ('ad16b305-ba19-496e-8533-d8163ccdffde', '0006169e-fb97-4060-b499-da5d75833034', '19315748-376c-4aab-9307-936d740fbfec', 'fgdfgsf', 'TEXT', NULL, '2026-07-27 15:11:30.253', '2026-07-27 15:11:30.253', '{19315748-376c-4aab-9307-936d740fbfec}', 'f');

-- ----------------------------
-- Table structure for chat_participants
-- ----------------------------
DROP TABLE IF EXISTS "public"."chat_participants";
CREATE TABLE "public"."chat_participants" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "room_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "role" "public"."ChatRole" NOT NULL DEFAULT 'MEMBER'::"ChatRole",
  "joined_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "left_at" timestamp(3),
  "is_muted" bool NOT NULL DEFAULT false
)
;

-- ----------------------------
-- Records of chat_participants
-- ----------------------------
INSERT INTO "public"."chat_participants" VALUES ('edd6ec96-a120-44d0-9548-af62a74eea9b', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'MEMBER', '2025-06-13 17:35:36.21', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('16246c95-4c1d-4889-9050-dcd91dbb2c9e', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'MEMBER', '2025-06-13 17:35:36.21', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('034d310b-4aaa-41de-9ee1-6ce2edc80405', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'a28b6227-498e-4dfe-85df-26b8bda65814', 'MEMBER', '2026-06-06 20:17:14.344', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('d735b051-788b-4959-9f5a-97ae353f4f45', '4efe35df-757f-4ee4-b5bd-7aa7349ce5c8', 'a28b6227-498e-4dfe-85df-26b8bda65814', 'MEMBER', '2026-06-06 20:17:14.344', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('f2820bb4-8670-416f-948e-f0d1899464c7', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', '808afebe-bdca-4d04-bfaf-9e838a4e6ce9', 'MEMBER', '2026-06-06 20:17:56.154', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('286d8f58-0362-49e3-8a81-accc45c26aef', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '808afebe-bdca-4d04-bfaf-9e838a4e6ce9', 'MEMBER', '2026-06-06 20:17:56.154', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('1cc6c446-f6c2-4c26-9b37-7f6d40045b63', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', '7caba933-0236-4a2f-b486-a5e94d0a1311', 'MEMBER', '2026-06-06 20:27:03.643', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('81d19b5b-2aac-4df1-ac1d-5091882eaf6f', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '7caba933-0236-4a2f-b486-a5e94d0a1311', 'MEMBER', '2026-06-06 20:27:03.643', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('a5b9e9db-6e0c-4a1b-9b67-80004c2711e2', '2b707d22-77db-4861-b148-ff41a49f1ea9', 'b172148a-754a-478e-a45c-6434202859c2', 'MEMBER', '2026-06-06 20:40:44.621', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('b1c1bb1c-7f74-4920-97db-b4ae68265380', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'b172148a-754a-478e-a45c-6434202859c2', 'MEMBER', '2026-06-06 20:40:44.621', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('2c77a18a-6da2-4c45-8978-1aa23b14c26b', '02ad241e-66a7-4e44-99fd-36fced0ca386', '75489092-c7e9-491f-98ee-b784d87df2f2', 'MEMBER', '2026-06-07 13:41:19.684', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('03763936-dc98-40c4-b604-6022754e6abc', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '75489092-c7e9-491f-98ee-b784d87df2f2', 'MEMBER', '2026-06-07 13:41:19.684', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('9b434fc8-56a1-4e56-ae07-08a68578bdbe', 'c260b4cf-e769-4656-9073-f595b748a69b', 'd493ea86-8a7b-4e84-b2a6-4e2c82899d52', 'MEMBER', '2026-06-07 13:57:00.332', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('e32abe93-49f0-4b8c-b658-18e8c2af0b8e', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'd493ea86-8a7b-4e84-b2a6-4e2c82899d52', 'MEMBER', '2026-06-07 13:57:00.332', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('f78330b7-09cb-4808-8979-19f244503787', 'c260b4cf-e769-4656-9073-f595b748a69b', '7732493e-30f8-4f7b-ae33-c5403e8d789e', 'MEMBER', '2026-06-07 13:58:37.188', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('821fd0f5-14c4-4553-8ec1-88c0ed479cf1', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '7732493e-30f8-4f7b-ae33-c5403e8d789e', 'MEMBER', '2026-06-07 13:58:37.188', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('61154170-5249-4c5b-aa19-6bd7958f8272', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'b1a3608d-cc7e-4991-a2a0-4e721948de31', 'MEMBER', '2026-06-09 06:58:26.699', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('16bc1ec6-c60a-4408-9447-8f563ca1ab1f', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'b1a3608d-cc7e-4991-a2a0-4e721948de31', 'MEMBER', '2026-06-09 06:58:26.699', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('83c1bcee-3c7f-4ef1-8859-a2e426986794', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '7338776b-b23f-48f4-930f-5cd093963b2e', 'MEMBER', '2026-06-09 06:59:51.343', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('ad77d1a8-dadb-4308-8683-91d8da7b5642', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '7338776b-b23f-48f4-930f-5cd093963b2e', 'MEMBER', '2026-06-09 06:59:51.343', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('a2aa2b1d-be73-4a1f-b832-d9758abc810f', '19315748-376c-4aab-9307-936d740fbfec', '5efea9f7-6ff1-47cf-bf86-4f60e5cbb5c7', 'MEMBER', '2026-07-27 09:44:52.662', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('dca4ff77-55f0-435c-88af-2a6767601f2a', 'c260b4cf-e769-4656-9073-f595b748a69b', '5efea9f7-6ff1-47cf-bf86-4f60e5cbb5c7', 'MEMBER', '2026-07-27 09:44:52.662', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('2e8602dd-7f1a-48ee-bf76-a5091ab770d6', '19315748-376c-4aab-9307-936d740fbfec', '0006169e-fb97-4060-b499-da5d75833034', 'MEMBER', '2026-07-27 14:33:16.558', NULL, 'f');
INSERT INTO "public"."chat_participants" VALUES ('30bb41d6-2ce3-437c-9feb-55eea670d0dd', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '0006169e-fb97-4060-b499-da5d75833034', 'MEMBER', '2026-07-27 14:33:16.558', NULL, 'f');

-- ----------------------------
-- Table structure for chat_rooms
-- ----------------------------
DROP TABLE IF EXISTS "public"."chat_rooms";
CREATE TABLE "public"."chat_rooms" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "name" text COLLATE "pg_catalog"."default",
  "type" "public"."ChatType" NOT NULL DEFAULT 'DIRECT'::"ChatType",
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(3) NOT NULL,
  "status" "public"."ChatRoomStatus" NOT NULL DEFAULT 'PENDING'::"ChatRoomStatus",
  "last_message_id" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of chat_rooms
-- ----------------------------
INSERT INTO "public"."chat_rooms" VALUES ('b1a3608d-cc7e-4991-a2a0-4e721948de31', NULL, 'DIRECT', '2026-06-09 06:58:26.699', '2026-06-09 06:58:53.878', 'PENDING', '3c9d3fdd-e1f5-4bab-b1c3-80d11dbd83ef');
INSERT INTO "public"."chat_rooms" VALUES ('7338776b-b23f-48f4-930f-5cd093963b2e', NULL, 'DIRECT', '2026-06-09 06:59:51.343', '2026-06-09 07:02:54.598', 'APPROVED', '2849218f-a2f0-4b6d-988d-17bab896bfa2');
INSERT INTO "public"."chat_rooms" VALUES ('75489092-c7e9-491f-98ee-b784d87df2f2', NULL, 'DIRECT', '2026-06-07 13:41:19.684', '2026-06-07 13:54:59.714', 'APPROVED', 'c11e6239-b12e-4d85-a39a-142f31870f58');
INSERT INTO "public"."chat_rooms" VALUES ('b172148a-754a-478e-a45c-6434202859c2', NULL, 'DIRECT', '2026-06-06 20:40:44.621', '2026-06-14 11:54:45.105', 'PENDING', 'b3480fa7-4c21-4890-a4fe-e198a0f82425');
INSERT INTO "public"."chat_rooms" VALUES ('d493ea86-8a7b-4e84-b2a6-4e2c82899d52', NULL, 'DIRECT', '2026-06-07 13:57:00.332', '2026-06-07 13:58:07.909', 'APPROVED', 'dc86d8e7-611d-4de9-8431-5c81510f7199');
INSERT INTO "public"."chat_rooms" VALUES ('7732493e-30f8-4f7b-ae33-c5403e8d789e', NULL, 'DIRECT', '2026-06-07 13:58:37.188', '2026-06-07 14:00:32.545', 'APPROVED', '17663ea4-741d-4e53-9ae2-a7992f8ec5ef');
INSERT INTO "public"."chat_rooms" VALUES ('fa7eca5e-233e-419c-82b9-83f4f35e9816', NULL, 'DIRECT', '2025-06-13 17:35:36.21', '2026-06-25 21:12:23.879', 'APPROVED', '3b75e024-5de8-4e1a-a9b0-3cfb00f60000');
INSERT INTO "public"."chat_rooms" VALUES ('a28b6227-498e-4dfe-85df-26b8bda65814', NULL, 'DIRECT', '2026-06-06 20:17:14.344', '2026-06-06 20:17:21.248', 'APPROVED', '5d36a5f5-1f24-4e1a-aa2d-05e672e01065');
INSERT INTO "public"."chat_rooms" VALUES ('5efea9f7-6ff1-47cf-bf86-4f60e5cbb5c7', NULL, 'DIRECT', '2026-07-27 09:44:52.662', '2026-07-27 09:44:55.929', 'PENDING', 'db2fb979-293d-4687-9b5d-56c43a91d7ca');
INSERT INTO "public"."chat_rooms" VALUES ('808afebe-bdca-4d04-bfaf-9e838a4e6ce9', NULL, 'DIRECT', '2026-06-06 20:17:56.154', '2026-06-06 20:25:35.945', 'APPROVED', '60616c9f-f198-4f69-a362-2e3aedc9f204');
INSERT INTO "public"."chat_rooms" VALUES ('0006169e-fb97-4060-b499-da5d75833034', NULL, 'DIRECT', '2026-07-27 14:33:16.558', '2026-07-27 15:11:30.303', 'PENDING', 'ad16b305-ba19-496e-8533-d8163ccdffde');
INSERT INTO "public"."chat_rooms" VALUES ('7caba933-0236-4a2f-b486-a5e94d0a1311', NULL, 'DIRECT', '2026-06-06 20:27:03.643', '2026-06-08 20:24:51.9', 'APPROVED', '1cece1da-c06b-44fa-9d5b-b770cb88e881');

-- ----------------------------
-- Table structure for follows
-- ----------------------------
DROP TABLE IF EXISTS "public"."follows";
CREATE TABLE "public"."follows" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "followerId" text COLLATE "pg_catalog"."default" NOT NULL,
  "followingId" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of follows
-- ----------------------------
INSERT INTO "public"."follows" VALUES ('25ee59b3-d963-4b54-98a3-9bfd6720f814', '49d9e3c0-ec00-48f0-86d3-293549c246dd', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-01-07 06:13:55.7');
INSERT INTO "public"."follows" VALUES ('0eb19c4f-a9da-48e5-a3b5-59d13ae89ad3', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-01-07 06:14:03.555');
INSERT INTO "public"."follows" VALUES ('f21b2c56-a16e-4bb4-8c7b-0ad47b72d842', '084b617e-c89c-44ff-8dc9-7c1aa4f7730e', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-01-08 04:16:46.655');
INSERT INTO "public"."follows" VALUES ('b85fbc1c-9ec6-4a68-890b-2e15761078ad', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2025-02-28 09:18:19.716');
INSERT INTO "public"."follows" VALUES ('ef38ebbf-f7a7-4ec2-ab94-83e72254f73e', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '2025-02-28 08:16:38.417');
INSERT INTO "public"."follows" VALUES ('e862f299-a451-4e02-8fc3-2d768bdbfcd5', '65904792-fdd5-45e3-a892-830a4640fd9b', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-03-20 07:11:44.027');
INSERT INTO "public"."follows" VALUES ('58f1c997-33e6-4c6a-aa88-b0bf4afd3651', '898c5eed-1650-4a27-9ae1-45fec186d37e', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '2025-06-19 06:57:18.239');
INSERT INTO "public"."follows" VALUES ('847ebae4-e0b6-4d69-9f00-442a74ed75c4', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2026-06-07 13:41:44.792');
INSERT INTO "public"."follows" VALUES ('f820523a-18af-43d0-93b7-1dfcbf2b936a', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-09 07:06:10.315');
INSERT INTO "public"."follows" VALUES ('437a217e-6383-4530-8a2f-103599d50bbf', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2026-06-09 07:06:24.888');
INSERT INTO "public"."follows" VALUES ('9b114eee-0083-48cb-a6bf-7c5c9d3774c4', '19315748-376c-4aab-9307-936d740fbfec', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-07-27 14:33:15.509');

-- ----------------------------
-- Table structure for friends
-- ----------------------------
DROP TABLE IF EXISTS "public"."friends";
CREATE TABLE "public"."friends" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "friend_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "status" "public"."FriendStatus" NOT NULL DEFAULT 'PENDING'::"FriendStatus",
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(3) NOT NULL,
  "is_requested_by_friend" bool NOT NULL DEFAULT false,
  "is_requested_by_me" bool NOT NULL DEFAULT false
)
;

-- ----------------------------
-- Records of friends
-- ----------------------------
INSERT INTO "public"."friends" VALUES ('2b78f254-4b3a-4983-ba20-d25eeb164290', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ACCEPTED', '2026-06-09 07:06:12.209', '2026-06-09 07:06:25.67', 'f', 't');
INSERT INTO "public"."friends" VALUES ('cb1e2167-d92a-48c0-b9a7-31ad2d4a736c', '19315748-376c-4aab-9307-936d740fbfec', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'PENDING', '2026-07-27 14:33:15.567', '2026-07-27 14:33:15.567', 'f', 't');

-- ----------------------------
-- Table structure for media
-- ----------------------------
DROP TABLE IF EXISTS "public"."media";
CREATE TABLE "public"."media" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "url" text COLLATE "pg_catalog"."default" NOT NULL,
  "type" "public"."MediaType" NOT NULL,
  "size" int4 NOT NULL,
  "width" int4,
  "height" int4,
  "duration" int4,
  "format" text COLLATE "pg_catalog"."default" NOT NULL,
  "is_deleted" bool NOT NULL DEFAULT false,
  "post_id" text COLLATE "pg_catalog"."default",
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(3) NOT NULL
)
;

-- ----------------------------
-- Records of media
-- ----------------------------
INSERT INTO "public"."media" VALUES ('fb5aaba8-ad7e-4688-b680-10533f784a08', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745572507323_1745572507120_image', 'IMAGE', 55299, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-25 09:15:08.043', '2025-04-25 09:15:08.043');
INSERT INTO "public"."media" VALUES ('96c82964-9125-4179-a416-3d875bda44e3', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745572613835_1745572613712_image', 'IMAGE', 93489, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-25 09:16:54.523', '2025-04-25 09:16:54.523');
INSERT INTO "public"."media" VALUES ('78daed2b-ecc3-43aa-90eb-20ad88a797ab', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745573342195_1745573342075_image', 'IMAGE', 146183, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-25 09:29:03.038', '2025-04-25 09:29:03.038');
INSERT INTO "public"."media" VALUES ('66d907f7-bf06-4be8-9cc0-eab950700853', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745573646587_1745573645805_image', 'IMAGE', 342718, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-25 09:34:07.44', '2025-04-25 09:34:07.44');
INSERT INTO "public"."media" VALUES ('9b067429-86d5-4409-8c2b-44d0418246e4', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745653528535_Thoa_em_n.jpg', 'IMAGE', 8480, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-26 07:45:29.191', '2025-04-26 07:45:29.191');
INSERT INTO "public"."media" VALUES ('595d1dfc-51a0-4f7d-bb6c-8cce0e481861', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745653528582_TÄng_PhÆ°Æ¡ng_Tháº£o.jpg', 'IMAGE', 100197, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-26 07:45:29.296', '2025-04-26 07:45:29.296');
INSERT INTO "public"."media" VALUES ('929c8096-38e6-4e9c-b587-e78dbc3dd6ff', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745835278793_Thoa_em_n.jpg', 'IMAGE', 8480, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:14:39.402', '2025-04-28 10:14:39.402');
INSERT INTO "public"."media" VALUES ('10d1df4d-1108-4c91-83bb-e7b348c6406d', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745835571374_Thoa_em_n.jpg', 'IMAGE', 8480, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:19:32.055', '2025-04-28 10:19:32.055');
INSERT INTO "public"."media" VALUES ('cf3a9c98-2417-42de-88d8-4d5efdd703aa', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745835752211_Thoa_em_n.jpg', 'IMAGE', 8480, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:22:32.852', '2025-04-28 10:22:32.852');
INSERT INTO "public"."media" VALUES ('13caf4c4-e1e5-4bb5-a5ba-b8332a0e5a14', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745835802367_Thoa_em_n.jpg', 'IMAGE', 8480, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:23:22.851', '2025-04-28 10:23:22.851');
INSERT INTO "public"."media" VALUES ('dbe6363e-387f-4bd7-a5e4-ee8dad5f4629', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745835921448_320517814_5655601404487763_8089247440371653670_n.jpg', 'IMAGE', 176652, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:25:22.211', '2025-04-28 10:25:22.211');
INSERT INTO "public"."media" VALUES ('4c47d5e5-8d0a-47fc-9a5f-8a5e37697915', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745836079260_320517814_5655601404487763_8089247440371653670_n.jpg', 'IMAGE', 176652, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:28:00.114', '2025-04-28 10:28:00.114');
INSERT INTO "public"."media" VALUES ('41e27ee3-e02d-4066-ada9-e6d563a9f83e', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745836127792_320517814_5655601404487763_8089247440371653670_n.jpg', 'IMAGE', 176652, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:28:48.632', '2025-04-28 10:28:48.632');
INSERT INTO "public"."media" VALUES ('78929381-e1a1-4d85-8d91-a3aa4be4679f', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745836192493_320517814_5655601404487763_8089247440371653670_n.jpg', 'IMAGE', 176652, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:29:53.229', '2025-04-28 10:29:53.229');
INSERT INTO "public"."media" VALUES ('fc17f2d4-e97f-4471-a077-d6ea0943c554', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745836269886_320517814_5655601404487763_8089247440371653670_n.jpg', 'IMAGE', 176652, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:31:10.694', '2025-04-28 10:31:10.694');
INSERT INTO "public"."media" VALUES ('d3d6e3dd-5263-474d-a7aa-dd323486dbaf', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745836373556_320517814_5655601404487763_8089247440371653670_n.jpg', 'IMAGE', 176652, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:32:54.391', '2025-04-28 10:32:54.391');
INSERT INTO "public"."media" VALUES ('73bd342d-2613-44c5-a1d3-817f2bc16636', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745836490198_320517814_5655601404487763_8089247440371653670_n.jpg', 'IMAGE', 176652, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:34:50.994', '2025-04-28 10:34:50.994');
INSERT INTO "public"."media" VALUES ('c3043ac0-6444-4268-bda2-f56617c9002b', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745836751069_320517814_5655601404487763_8089247440371653670_n.jpg', 'IMAGE', 176652, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:39:11.876', '2025-04-28 10:39:11.876');
INSERT INTO "public"."media" VALUES ('813823b1-e76f-481f-a42d-b4cd8b2825f7', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745836866803_320517814_5655601404487763_8089247440371653670_n.jpg', 'IMAGE', 176652, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:41:07.662', '2025-04-28 10:41:07.662');
INSERT INTO "public"."media" VALUES ('6f95ee6d-db00-4807-a5c6-34f10e089f80', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745836954747_320517814_5655601404487763_8089247440371653670_n.jpg', 'IMAGE', 176652, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:42:35.516', '2025-04-28 10:42:35.516');
INSERT INTO "public"."media" VALUES ('38dbb46a-9770-4cc1-8720-a8b195676a9f', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745837179325_320517814_5655601404487763_8089247440371653670_n.jpg', 'IMAGE', 176652, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 10:46:20.148', '2025-04-28 10:46:20.148');
INSERT INTO "public"."media" VALUES ('71c205cf-0463-4ec5-9910-405dbf01715b', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1745852514274_Sunshine''s.jpg', 'IMAGE', 123275, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-04-28 15:01:55.063', '2025-04-28 15:01:55.063');
INSERT INTO "public"."media" VALUES ('21ed72f8-73ef-41bf-bcdb-3487dee05e8f', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1746526359174_1746526358858_image', 'IMAGE', 3510222, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-05-06 10:12:40.935', '2025-05-06 10:12:40.935');
INSERT INTO "public"."media" VALUES ('4dc413f1-2d50-4b3a-bee4-19a887246f81', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1747029339067_1747029338312_image', 'IMAGE', 2470924, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-05-12 05:55:41.925', '2025-05-12 05:55:41.925');
INSERT INTO "public"."media" VALUES ('0c67c192-3262-43a6-af39-1663416a6e84', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1747245470178_1747245469938_image', 'IMAGE', 1069734, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-05-14 17:57:51.274', '2025-05-14 17:57:51.274');
INSERT INTO "public"."media" VALUES ('89743a02-65b0-45f4-9ec2-967e725afa68', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1747378125328_00009-4100874166-caadc88c06a642459ee4c3899e155f36.png', 'IMAGE', 896934, NULL, NULL, NULL, 'image/png', 'f', NULL, 'ba1b25ea-053b-4100-a4ad-a92959914eeb', '2025-05-16 06:48:46.515', '2025-05-16 06:48:46.515');
INSERT INTO "public"."media" VALUES ('0b67aa61-076e-44dd-98d1-621fa292b3f2', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1748184525864_4db00e17-dd8c-48a4-9733-8761fb6e7498.png', 'IMAGE', 343488, NULL, NULL, NULL, 'image/png', 'f', NULL, '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-05-25 14:48:46.838', '2025-05-25 14:48:46.838');
INSERT INTO "public"."media" VALUES ('4a5b32ed-e116-433e-82ef-b0ce9ede79d7', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1748945194351_1748945208525_image', 'IMAGE', 1533783, NULL, NULL, NULL, 'image/png', 'f', NULL, '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-06-03 10:06:35.404', '2025-06-03 10:06:35.404');
INSERT INTO "public"."media" VALUES ('4e9502a5-b2b9-4a99-b190-b219e9e49b02', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1748945289776_1748945289535_image', 'IMAGE', 2258436, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-06-03 10:08:11.198', '2025-06-03 10:08:11.198');
INSERT INTO "public"."media" VALUES ('a43ab38b-cfe2-49a9-8a3c-55e62f7600ab', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1748945308304_1748945308188_image', 'IMAGE', 16403, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-06-03 10:08:28.866', '2025-06-03 10:08:28.866');
INSERT INTO "public"."media" VALUES ('8925ace2-b59c-4e27-b148-0c037efd2840', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1748945410033_1748945409800_image', 'IMAGE', 2249562, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-06-03 10:10:11.009', '2025-06-03 10:10:11.009');
INSERT INTO "public"."media" VALUES ('2b200197-467b-4145-8b94-7223d46a3c2e', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1749196673660_1749196672973_image', 'IMAGE', 6892836, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-06-06 07:57:55.189', '2025-06-06 07:57:55.189');
INSERT INTO "public"."media" VALUES ('4dac05fd-7019-4b7c-aa68-44853ef8bff9', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1749571152071_testbg.png', 'IMAGE', 198935, NULL, NULL, NULL, 'image/png', 'f', NULL, '6a31a93a-a961-48d6-963e-0645f99de8e4', '2025-06-10 15:59:13.159', '2025-06-10 15:59:13.159');
INSERT INTO "public"."media" VALUES ('ab3b39b0-641b-4c43-b326-2e622912764f', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1750777040252_1750777040194_image', 'IMAGE', 3396569, NULL, NULL, NULL, 'image/png', 'f', NULL, '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-06-24 14:57:21.861', '2025-06-24 14:57:21.861');
INSERT INTO "public"."media" VALUES ('0967306a-6712-482a-bea9-988e1a1eec54', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1750777130008_504193226_716185870920601_1900189960928916806_n.jpg', 'IMAGE', 113210, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-06-24 14:58:50.732', '2025-06-24 14:58:50.732');
INSERT INTO "public"."media" VALUES ('1b1afbdc-47ef-49de-959f-a5648de3b238', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1750777185209_504193226_716185870920601_1900189960928916806_n.jpg', 'IMAGE', 113210, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-06-24 14:59:45.603', '2025-06-24 14:59:45.603');
INSERT INTO "public"."media" VALUES ('f40f4dcb-4887-4a2f-bf59-aa39ab99b2b4', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1750777304556_507685408_1783043819303238_5660615239598313317_n.jpg', 'IMAGE', 138360, NULL, NULL, NULL, 'image/jpeg', 'f', 'cccd5333-3355-4a54-b566-1a137fd28a1b', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-06-24 15:01:45.066', '2025-06-24 15:01:45.066');
INSERT INTO "public"."media" VALUES ('42ee275a-24c5-4b8d-9b09-8ed64befe43e', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751217042134_1751217042282_image', 'IMAGE', 1774828, NULL, NULL, NULL, 'image/png', 'f', NULL, '6a31a93a-a961-48d6-963e-0645f99de8e4', '2025-06-29 17:10:43.389', '2025-06-29 17:10:43.389');
INSERT INTO "public"."media" VALUES ('a5a8dd06-1849-4cbd-bf69-3e811cd964da', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751966206242_ai-image-1751966204280.png', 'IMAGE', 2347908, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-08 09:16:47.769', '2025-07-08 09:16:47.769');
INSERT INTO "public"."media" VALUES ('58d383c4-5cf0-4322-83fd-e70a74801329', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751967322719_ai-image-1751967320784.png', 'IMAGE', 2344146, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-08 09:35:24.255', '2025-07-08 09:35:24.255');
INSERT INTO "public"."media" VALUES ('90e1367d-4c7e-416d-b7c9-1304afc00733', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751968176506_ai-image-0.png', 'IMAGE', 1576517, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-08 09:49:37.77', '2025-07-08 09:49:37.77');
INSERT INTO "public"."media" VALUES ('0cb80162-b6e8-4522-9e06-9026a06dd7c8', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751968246045_ai-image-0.png', 'IMAGE', 2361943, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-08 09:50:47.6', '2025-07-08 09:50:47.6');
INSERT INTO "public"."media" VALUES ('c94f6303-4e56-4514-a9ab-c414c20038f6', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751968379653_ai-image-0.png', 'IMAGE', 830949, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-08 09:53:02.126', '2025-07-08 09:53:02.126');
INSERT INTO "public"."media" VALUES ('c8647c31-45cc-4faf-a713-ced1a3d704e5', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751968450590_ai-image-0.png', 'IMAGE', 1722784, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-08 09:54:11.902', '2025-07-08 09:54:11.902');
INSERT INTO "public"."media" VALUES ('9f7cadd0-601f-4658-a47d-c7bb95a5b26b', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751968519512_ai-image-0.png', 'IMAGE', 2356053, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-08 09:55:21.579', '2025-07-08 09:55:21.579');
INSERT INTO "public"."media" VALUES ('8e2697f9-88f7-42de-90fd-15907f3b9244', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751968796932_ai-image-0.png', 'IMAGE', 2175925, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-08 09:59:58.241', '2025-07-08 09:59:58.241');
INSERT INTO "public"."media" VALUES ('51f39edd-f68a-439f-af28-402864e90020', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751968837315_ai-image-0.png', 'IMAGE', 2801523, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-08 10:00:38.35', '2025-07-08 10:00:38.35');
INSERT INTO "public"."media" VALUES ('1dfdc65a-cb3f-4434-a023-d0c6c53492c6', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751985053168_ai-image-3.png', 'IMAGE', 987574, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-08 14:30:54.402', '2025-07-08 14:30:54.402');
INSERT INTO "public"."media" VALUES ('44738dbf-8bdc-4f2d-b803-6da34edcb242', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751985053236_ai-image-2.png', 'IMAGE', 962222, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-08 14:30:54.526', '2025-07-08 14:30:54.526');
INSERT INTO "public"."media" VALUES ('bd0722f5-fab4-450b-be41-935c7af48e0d', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751985053440_ai-image-1.png', 'IMAGE', 2245061, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-08 14:30:54.868', '2025-07-08 14:30:54.868');
INSERT INTO "public"."media" VALUES ('eac80d72-82a2-4664-83d9-3a21c54741c6', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751985053470_ai-image-0.png', 'IMAGE', 2554603, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-08 14:30:54.985', '2025-07-08 14:30:54.985');
INSERT INTO "public"."media" VALUES ('73ecefec-296b-40f1-b87e-cb6266a3485b', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752049183167_ai-image-0.png', 'IMAGE', 2783753, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-09 08:19:44.684', '2025-07-09 08:19:44.684');
INSERT INTO "public"."media" VALUES ('27d239b4-71dc-4e05-84ca-04957a321bc6', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752049243809_ai-image-0.png', 'IMAGE', 1539927, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-09 08:20:44.571', '2025-07-09 08:20:44.571');
INSERT INTO "public"."media" VALUES ('9b381058-528b-4aa6-ba17-c65220693dae', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752049287103_ai-image-0.png', 'IMAGE', 1073585, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-09 08:21:27.826', '2025-07-09 08:21:27.826');
INSERT INTO "public"."media" VALUES ('d7785ebc-d1c7-4eb7-beab-a99dc6814ab0', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752297059233_ai-image-0.png', 'IMAGE', 1008685, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-12 05:11:00.52', '2025-07-12 05:11:00.52');
INSERT INTO "public"."media" VALUES ('cee141cc-cbc8-4b22-9f53-7b6ebeab892d', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752297059388_ai-image-1.png', 'IMAGE', 1878301, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-12 05:11:00.91', '2025-07-12 05:11:00.91');
INSERT INTO "public"."media" VALUES ('8c09f85f-3355-434c-bf19-84c893d10d82', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752312909102_ai-image-0.png', 'IMAGE', 1940553, NULL, NULL, NULL, 'image/png', 'f', NULL, '6a31a93a-a961-48d6-963e-0645f99de8e4', '2025-07-12 09:35:10.359', '2025-07-12 09:35:10.359');
INSERT INTO "public"."media" VALUES ('7fea875c-c8a8-4535-88ef-042630fa30bf', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752314111204_ai-image-1.png', 'IMAGE', 1236337, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-12 09:55:12.327', '2025-07-12 09:55:12.327');
INSERT INTO "public"."media" VALUES ('5dd65015-9498-4d4e-87f3-4bc23908f04b', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752314111130_ai-image-3.png', 'IMAGE', 1505515, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-12 09:55:12.381', '2025-07-12 09:55:12.381');
INSERT INTO "public"."media" VALUES ('a8775330-828d-403a-8c43-3770d56a7445', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752314111356_ai-image-0.png', 'IMAGE', 1737041, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-12 09:55:12.484', '2025-07-12 09:55:12.484');
INSERT INTO "public"."media" VALUES ('21124fab-4f37-439b-9895-f7cd24652931', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752314111392_ai-image-2.png', 'IMAGE', 2883274, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-12 09:55:12.644', '2025-07-12 09:55:12.644');
INSERT INTO "public"."media" VALUES ('166183ff-fa5a-424d-aeeb-90496b8942d3', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752314217024_ai-image-1.png', 'IMAGE', 1634729, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-12 09:56:58.324', '2025-07-12 09:56:58.324');
INSERT INTO "public"."media" VALUES ('c6dd72cd-38d7-4511-a167-992497f109fc', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752314217063_ai-image-2.png', 'IMAGE', 2374158, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-12 09:56:58.507', '2025-07-12 09:56:58.507');
INSERT INTO "public"."media" VALUES ('91c424fa-4331-48b0-aecc-162506012b7d', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752314217070_ai-image-0.png', 'IMAGE', 2950591, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-12 09:56:58.543', '2025-07-12 09:56:58.543');
INSERT INTO "public"."media" VALUES ('08798845-20d9-4d42-9cd9-e3ef3cf44436', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752314851421_ai-image-2.png', 'IMAGE', 1027267, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-12 10:07:32.417', '2025-07-12 10:07:32.417');
INSERT INTO "public"."media" VALUES ('cd1668d4-3e90-45b4-b60b-5d58d45d9a32', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752314851592_ai-image-1.png', 'IMAGE', 1746032, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-12 10:07:32.755', '2025-07-12 10:07:32.755');
INSERT INTO "public"."media" VALUES ('db46ca7f-88e1-4066-b850-8b8fc70c9efb', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1752314851619_ai-image-0.png', 'IMAGE', 2714474, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-07-12 10:07:34.263', '2025-07-12 10:07:34.263');
INSERT INTO "public"."media" VALUES ('1ca507d2-959d-4f56-825f-ff8fd1065091', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754504204748_ai-image-0.png', 'IMAGE', 1004178, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 18:16:46.044', '2025-08-06 18:16:46.044');
INSERT INTO "public"."media" VALUES ('219ef08c-0015-4fff-b436-182f4ccf7aa3', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754504204784_ai-image-1.png', 'IMAGE', 2259055, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 18:16:46.388', '2025-08-06 18:16:46.388');
INSERT INTO "public"."media" VALUES ('b43126ee-d6c4-44bc-8742-861bd5b15a38', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754507817125_ai-image-0.png', 'IMAGE', 1963172, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:16:59.454', '2025-08-06 19:16:59.454');
INSERT INTO "public"."media" VALUES ('4569bf77-1b3f-4d7d-9bb6-18fb99bf9e9f', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754507817198_ai-image-2.png', 'IMAGE', 2566852, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:16:59.607', '2025-08-06 19:16:59.607');
INSERT INTO "public"."media" VALUES ('a1a47449-6051-4578-a0e8-8084b05123c4', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754507817090_ai-image-3.png', 'IMAGE', 1398320, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:17:00.398', '2025-08-06 19:17:00.398');
INSERT INTO "public"."media" VALUES ('b4d38f08-888d-4767-88e7-937642f1329e', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754507817157_ai-image-1.png', 'IMAGE', 2189724, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:17:00.927', '2025-08-06 19:17:00.927');
INSERT INTO "public"."media" VALUES ('bc0cfe2e-beaa-446e-8149-18c4edbac6d8', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754507922823_ai-image-1.png', 'IMAGE', 1556112, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:18:43.954', '2025-08-06 19:18:43.954');
INSERT INTO "public"."media" VALUES ('4dc12f4c-3581-4d7a-be7d-dfb1816d4e3a', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754507922813_ai-image-3.png', 'IMAGE', 1171716, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:18:43.966', '2025-08-06 19:18:43.966');
INSERT INTO "public"."media" VALUES ('c00b2a6b-c56a-4aba-aede-04a5c33a9be3', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754507922818_ai-image-0.png', 'IMAGE', 1485635, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:18:43.992', '2025-08-06 19:18:43.992');
INSERT INTO "public"."media" VALUES ('74fa27b4-06b5-42c2-825e-c124a482ce5c', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754507922759_ai-image-2.png', 'IMAGE', 1455541, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:18:44.003', '2025-08-06 19:18:44.003');
INSERT INTO "public"."media" VALUES ('78c7b7b3-f49a-4b52-ab6d-c9dddce5b195', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508014420_ai-image-3.png', 'IMAGE', 1617156, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:20:15.618', '2025-08-06 19:20:15.618');
INSERT INTO "public"."media" VALUES ('6e5d7850-fcbc-4fc9-a322-68b5a2705cab', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508014426_ai-image-2.png', 'IMAGE', 1543777, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:20:15.63', '2025-08-06 19:20:15.63');
INSERT INTO "public"."media" VALUES ('ec6c7ff6-f158-4d62-a4d9-94c7454de9b6', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508014350_ai-image-1.png', 'IMAGE', 1473732, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:20:15.747', '2025-08-06 19:20:15.747');
INSERT INTO "public"."media" VALUES ('e242866e-57c3-4bce-9c38-d96b0d52f680', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508014529_ai-image-0.png', 'IMAGE', 1651091, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:20:15.751', '2025-08-06 19:20:15.751');
INSERT INTO "public"."media" VALUES ('7f2fa748-adcb-4b26-9f01-6c7a79ca91ef', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508061674_ai-image-0.png', 'IMAGE', 1217918, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:21:02.424', '2025-08-06 19:21:02.424');
INSERT INTO "public"."media" VALUES ('3a8e0acd-6187-4967-b098-3637b5ed3e01', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508061629_ai-image-1.png', 'IMAGE', 1287663, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:21:02.438', '2025-08-06 19:21:02.438');
INSERT INTO "public"."media" VALUES ('2af77c64-0141-4164-8ff0-a4a28d24ea12', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508061721_ai-image-3.png', 'IMAGE', 1506590, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:21:02.482', '2025-08-06 19:21:02.482');
INSERT INTO "public"."media" VALUES ('b80bc028-a5e5-4e7c-a8d0-94f471ba8bc9', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508061859_ai-image-2.png', 'IMAGE', 1892433, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:21:02.697', '2025-08-06 19:21:02.697');
INSERT INTO "public"."media" VALUES ('f801add1-1dfc-4236-9d85-d71904986eff', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508089334_ai-image-2.png', 'IMAGE', 1197476, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:21:30.047', '2025-08-06 19:21:30.047');
INSERT INTO "public"."media" VALUES ('f577163f-6f7a-4f0e-aee0-105ad4b94188', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508172092_ai-image-2.png', 'IMAGE', 1607542, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:22:53.262', '2025-08-06 19:22:53.262');
INSERT INTO "public"."media" VALUES ('f2189730-2d56-4638-a80e-15d13f9e6cad', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508172310_ai-image-0.png', 'IMAGE', 1737040, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:22:53.687', '2025-08-06 19:22:53.687');
INSERT INTO "public"."media" VALUES ('5929f4a5-1341-42c5-8402-37e32c2eece9', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508089372_ai-image-3.png', 'IMAGE', 961134, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:21:29.952', '2025-08-06 19:21:29.952');
INSERT INTO "public"."media" VALUES ('88e3e9b2-f5e6-41af-923d-5091d1876035', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508089367_ai-image-0.png', 'IMAGE', 1512056, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:21:30.153', '2025-08-06 19:21:30.153');
INSERT INTO "public"."media" VALUES ('1c77480d-eec9-4691-a2fa-a2e4d306a8ff', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508172054_ai-image-1.png', 'IMAGE', 1041632, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:22:53.225', '2025-08-06 19:22:53.225');
INSERT INTO "public"."media" VALUES ('0ea41eae-fbaf-490f-b5ae-4c0422cc30f0', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508089388_ai-image-1.png', 'IMAGE', 1129524, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:21:30.09', '2025-08-06 19:21:30.09');
INSERT INTO "public"."media" VALUES ('450c2a2e-08f6-43cb-95f7-b4b6943e4f04', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508172166_ai-image-3.png', 'IMAGE', 1328899, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:22:53.169', '2025-08-06 19:22:53.169');
INSERT INTO "public"."media" VALUES ('b438c20a-718b-4675-ba9d-04258428bdd9', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754561787774_ai-image-2.png', 'IMAGE', 939554, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-07 10:16:28.922', '2025-08-07 10:16:28.922');
INSERT INTO "public"."media" VALUES ('706b99fb-b957-4ed6-94f4-09ed730f2afa', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754561787743_ai-image-1.png', 'IMAGE', 1052862, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-07 10:16:28.967', '2025-08-07 10:16:28.967');
INSERT INTO "public"."media" VALUES ('fd5c71d1-23e7-4bc4-b4c7-e91f93ef114d', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754561787904_ai-image-3.png', 'IMAGE', 2288001, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-07 10:16:29.152', '2025-08-07 10:16:29.152');
INSERT INTO "public"."media" VALUES ('630b98c3-2c83-441f-9ac8-954df708b7d0', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754561787915_ai-image-0.png', 'IMAGE', 2301635, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-07 10:16:29.604', '2025-08-07 10:16:29.604');
INSERT INTO "public"."media" VALUES ('e5468efc-bf40-4369-b018-2a1b69cf9c61', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753246235_1780753245697_image.webp', 'IMAGE', 2539623, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:40:48.928', '2026-06-06 13:40:48.928');
INSERT INTO "public"."media" VALUES ('e43b40d6-6f3e-4923-be25-12865e2b5595', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753264495_smo_baclground.gif.webp', 'IMAGE', 2737343, NULL, NULL, NULL, 'image/gif', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:41:07.285', '2026-06-06 13:41:07.285');
INSERT INTO "public"."media" VALUES ('01831da8-9bdc-4428-8524-e3230f215acf', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753300944_ai-image-2.png', 'IMAGE', 2071117, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:41:43.321', '2026-06-06 13:41:43.321');
INSERT INTO "public"."media" VALUES ('93d28143-d517-44b5-a861-fcd5e992ec3d', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753301013_ai-image-1.png', 'IMAGE', 2095266, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:41:43.521', '2026-06-06 13:41:43.521');
INSERT INTO "public"."media" VALUES ('6f55f669-b41e-42fc-8f66-b20a53d23c48', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753301142_ai-image-0.png', 'IMAGE', 2541173, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:41:43.691', '2026-06-06 13:41:43.691');
INSERT INTO "public"."media" VALUES ('8c45a469-2050-470f-86b2-e9c0a5507b51', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753301633_ai-image-3.png', 'IMAGE', 2471817, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:41:44.146', '2026-06-06 13:41:44.146');
INSERT INTO "public"."media" VALUES ('6f6ef01e-d74b-499a-a92a-fd660ba1fae1', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753328949_ai-image-0.png', 'IMAGE', 1225693, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:42:09.643', '2026-06-06 13:42:09.643');
INSERT INTO "public"."media" VALUES ('4acde3fd-c37f-4283-a307-29e528093b72', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753329691_ai-image-3.png', 'IMAGE', 2072939, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:42:10.405', '2026-06-06 13:42:10.405');
INSERT INTO "public"."media" VALUES ('eb7e55c5-dbda-4636-bc89-51da8476f580', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753329178_ai-image-1.png', 'IMAGE', 2243010, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:42:11.781', '2026-06-06 13:42:11.781');
INSERT INTO "public"."media" VALUES ('948cb8f3-6ebe-4920-9333-61f8800e51f3', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753329122_ai-image-2.png', 'IMAGE', 2162420, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:42:11.931', '2026-06-06 13:42:11.931');
INSERT INTO "public"."media" VALUES ('e72a5ac6-9160-4f23-8f8b-3036f4278f36', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753509716_ai-image-0.png', 'IMAGE', 2539830, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:45:12.468', '2026-06-06 13:45:12.468');
INSERT INTO "public"."media" VALUES ('1f6ec987-ff5c-45c6-9870-b318e19fa355', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753553248_ai-image-2.png', 'IMAGE', 967640, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:45:53.799', '2026-06-06 13:45:53.799');
INSERT INTO "public"."media" VALUES ('c361c2dc-2f87-4656-91b6-1cdcd252324b', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753553223_ai-image-3.png', 'IMAGE', 1489978, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:45:53.989', '2026-06-06 13:45:53.989');
INSERT INTO "public"."media" VALUES ('7bfdb10e-8bb3-4ba3-94d6-a1adb3596c48', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753553332_ai-image-0.png', 'IMAGE', 1383425, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:45:55.675', '2026-06-06 13:45:55.675');
INSERT INTO "public"."media" VALUES ('97497d7d-973d-406d-9796-0e204fe628fb', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753553326_ai-image-1.png', 'IMAGE', 1788823, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:45:55.726', '2026-06-06 13:45:55.726');
INSERT INTO "public"."media" VALUES ('15336edb-9588-40d2-8454-63184a6233b2', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753791396_ai-image-3.png', 'IMAGE', 1340604, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:49:51.979', '2026-06-06 13:49:51.979');
INSERT INTO "public"."media" VALUES ('0048d1b7-1297-4462-b269-f66fad609df3', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753791565_ai-image-0.png', 'IMAGE', 2028713, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:49:52.342', '2026-06-06 13:49:52.342');
INSERT INTO "public"."media" VALUES ('0b5d6ed4-aa98-44ee-8004-aff3a3eb0d9d', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753791489_ai-image-1.png', 'IMAGE', 1488317, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:49:52.388', '2026-06-06 13:49:52.388');
INSERT INTO "public"."media" VALUES ('11766acb-bb59-42d6-b09e-04079b9c8509', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753791528_ai-image-2.png', 'IMAGE', 1809593, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:49:52.273', '2026-06-06 13:49:52.273');
INSERT INTO "public"."media" VALUES ('42c6a97e-ac1b-4bac-9074-5109c9fdba8a', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753871654_ai-image-3.png', 'IMAGE', 2464564, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:51:14.324', '2026-06-06 13:51:14.324');
INSERT INTO "public"."media" VALUES ('cc20493d-12df-4ec3-90e5-d83adbbdba4f', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753871547_ai-image-1.png', 'IMAGE', 2555290, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:51:14.411', '2026-06-06 13:51:14.411');
INSERT INTO "public"."media" VALUES ('bfeda484-2400-4341-8ba4-0327da2db2c2', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753871591_ai-image-2.png', 'IMAGE', 2504525, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:51:14.555', '2026-06-06 13:51:14.555');
INSERT INTO "public"."media" VALUES ('f8d33647-dd06-4cd6-8332-b246f6130d8f', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753871695_ai-image-0.png', 'IMAGE', 2112383, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:51:14.593', '2026-06-06 13:51:14.593');
INSERT INTO "public"."media" VALUES ('f9a643c4-59f9-4142-a485-88551784b795', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780754004613_ai-image-2.png', 'IMAGE', 1408422, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:53:25.203', '2026-06-06 13:53:25.203');
INSERT INTO "public"."media" VALUES ('c8e4c2c5-6c1e-4ad5-ba23-7dbc0355829b', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780754004865_ai-image-3.png', 'IMAGE', 2607926, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:53:27.426', '2026-06-06 13:53:27.426');
INSERT INTO "public"."media" VALUES ('e6964876-7355-4c09-8ddb-91e078dff6c8', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780754004765_ai-image-0.png', 'IMAGE', 2426761, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:53:27.522', '2026-06-06 13:53:27.522');
INSERT INTO "public"."media" VALUES ('568eb057-34c1-4b70-ac4f-56d2bf76c22b', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780754004840_ai-image-1.png', 'IMAGE', 2227700, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:53:27.723', '2026-06-06 13:53:27.723');
INSERT INTO "public"."media" VALUES ('75a4624f-281f-4ee5-91ef-1c30a80f4b31', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780754020480_ai-image-1780754016146-3.png.webp', 'IMAGE', 332799, NULL, NULL, NULL, 'image/png', 'f', '445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:53:41.002', '2026-06-06 13:53:41.002');
INSERT INTO "public"."media" VALUES ('d9c387b0-5586-4ee8-bbe1-43c5f5529126', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780754021084_ai-image-1780754016149-1.png.webp', 'IMAGE', 555445, NULL, NULL, NULL, 'image/png', 'f', '445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:53:41.637', '2026-06-06 13:53:41.637');
INSERT INTO "public"."media" VALUES ('1e47393e-57b4-4491-82b2-15b070a74c1f', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780754021129_ai-image-1780754016031-0.png.webp', 'IMAGE', 688549, NULL, NULL, NULL, 'image/png', 'f', '445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:53:41.676', '2026-06-06 13:53:41.676');
INSERT INTO "public"."media" VALUES ('287e6c2a-00af-43de-9c18-bbd40d44b18b', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780754021156_ai-image-1780754016149-2.png.webp', 'IMAGE', 654892, NULL, NULL, NULL, 'image/png', 'f', '445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:53:41.71', '2026-06-06 13:53:41.71');
INSERT INTO "public"."media" VALUES ('afdf1173-bda3-4125-b78c-34358dc0bc3c', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780776252753_ccc839332d89d6150db61b7e47da89f1.gif.webp', 'IMAGE', 3500742, NULL, NULL, NULL, 'image/gif', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 20:04:16.456', '2026-06-06 20:04:16.456');
INSERT INTO "public"."media" VALUES ('54d53987-a33a-410e-8900-3df569a767ee', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780776639557_image.png.webp', 'IMAGE', 3375, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 20:10:40.351', '2026-06-06 20:10:40.351');
INSERT INTO "public"."media" VALUES ('dc1678d5-7588-47a0-9846-60d0b5629805', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780839260620_1780839259848_image.webp', 'IMAGE', 5305324, NULL, NULL, NULL, 'image/png', 'f', NULL, '02ad241e-66a7-4e44-99fd-36fced0ca386', '2026-06-07 13:34:24.082', '2026-06-07 13:34:24.082');
INSERT INTO "public"."media" VALUES ('0e49260c-2659-4520-8546-b33ffbde38d9', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780840827925_1775729853311_blob.jpg.webp', 'IMAGE', 81349, NULL, NULL, NULL, 'image/jpeg', 'f', NULL, 'c260b4cf-e769-4656-9073-f595b748a69b', '2026-06-07 14:00:31.8', '2026-06-07 14:00:31.8');
INSERT INTO "public"."media" VALUES ('bcf80bd3-07a4-4d1e-bfaa-dfd55d557b32', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780841425587_1780841425359_image.webp', 'IMAGE', 1941098, NULL, NULL, NULL, 'image/png', 'f', NULL, '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2026-06-07 14:10:28.547', '2026-06-07 14:10:28.547');
INSERT INTO "public"."media" VALUES ('a12c22a3-1b56-4fce-87ce-75a952b0be0a', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780849813679_ai-image-0.png', 'IMAGE', 2202240, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-07 16:30:16.419', '2026-06-07 16:30:16.419');
INSERT INTO "public"."media" VALUES ('ca0f5524-cc12-4cf0-83f3-66b9eac7489c', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780919682665_story-1780919682437.webp', 'IMAGE', 3585277, NULL, NULL, NULL, 'image/gif', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-08 11:54:45.84', '2026-06-08 11:54:45.84');
INSERT INTO "public"."media" VALUES ('800e1c96-5e85-4b79-a602-fed16c4ee821', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1783156149444_ai-image-3.png', 'IMAGE', 1582115, NULL, NULL, NULL, 'image/png', 'f', NULL, '6a31a93a-a961-48d6-963e-0645f99de8e4', '2026-07-04 09:09:12.06', '2026-07-04 09:09:12.06');
INSERT INTO "public"."media" VALUES ('9fa0b114-ca37-42ec-af55-325ad0584ba0', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1783156149628_ai-image-1.png', 'IMAGE', 1911192, NULL, NULL, NULL, 'image/png', 'f', NULL, '6a31a93a-a961-48d6-963e-0645f99de8e4', '2026-07-04 09:09:12.298', '2026-07-04 09:09:12.298');
INSERT INTO "public"."media" VALUES ('748a8d7c-8c7a-424e-8ed1-ac492617bbd9', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1783156149934_ai-image-0.png', 'IMAGE', 2838453, NULL, NULL, NULL, 'image/png', 'f', NULL, '6a31a93a-a961-48d6-963e-0645f99de8e4', '2026-07-04 09:09:12.569', '2026-07-04 09:09:12.569');
INSERT INTO "public"."media" VALUES ('21ee94e2-a5a3-4737-bd15-6710b772ec30', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1783156149721_ai-image-2.png', 'IMAGE', 2511051, NULL, NULL, NULL, 'image/png', 'f', NULL, '6a31a93a-a961-48d6-963e-0645f99de8e4', '2026-07-04 09:09:12.583', '2026-07-04 09:09:12.583');
INSERT INTO "public"."media" VALUES ('686fc48d-c916-4d5b-a453-57b8973c84fe', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1785145424261_blob.webp', 'IMAGE', 144393, NULL, NULL, NULL, 'image/jpeg', 'f', 'deff67f2-deee-435d-ac5a-9bc6b58ce3de', '19315748-376c-4aab-9307-936d740fbfec', '2026-07-27 09:43:46.367', '2026-07-27 09:43:46.367');
INSERT INTO "public"."media" VALUES ('a386f1df-f2da-4005-986e-ea2a803724b3', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1785145424057_blob.webp', 'IMAGE', 183486, NULL, NULL, NULL, 'image/jpeg', 'f', 'deff67f2-deee-435d-ac5a-9bc6b58ce3de', '19315748-376c-4aab-9307-936d740fbfec', '2026-07-27 09:43:46.362', '2026-07-27 09:43:46.362');
INSERT INTO "public"."media" VALUES ('7f52e714-6879-44bd-9253-1ff297347aa4', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1785145424359_blob.webp', 'IMAGE', 149140, NULL, NULL, NULL, 'image/jpeg', 'f', 'deff67f2-deee-435d-ac5a-9bc6b58ce3de', '19315748-376c-4aab-9307-936d740fbfec', '2026-07-27 09:43:46.404', '2026-07-27 09:43:46.404');
INSERT INTO "public"."media" VALUES ('6db00145-9363-4082-bba0-cd28a05cfb35', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1785145424263_blob.webp', 'IMAGE', 168175, NULL, NULL, NULL, 'image/jpeg', 'f', 'deff67f2-deee-435d-ac5a-9bc6b58ce3de', '19315748-376c-4aab-9307-936d740fbfec', '2026-07-27 09:43:46.413', '2026-07-27 09:43:46.413');
INSERT INTO "public"."media" VALUES ('f6a396b6-f5cb-4350-a9ba-a93d3dff8edb', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1785145425361_blob.webp', 'IMAGE', 137369, NULL, NULL, NULL, 'image/jpeg', 'f', 'deff67f2-deee-435d-ac5a-9bc6b58ce3de', '19315748-376c-4aab-9307-936d740fbfec', '2026-07-27 09:43:46.753', '2026-07-27 09:43:46.753');
INSERT INTO "public"."media" VALUES ('ee287516-aec0-4aef-95dc-d6940afd7134', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1785145425268_blob.webp', 'IMAGE', 186711, NULL, NULL, NULL, 'image/jpeg', 'f', 'deff67f2-deee-435d-ac5a-9bc6b58ce3de', '19315748-376c-4aab-9307-936d740fbfec', '2026-07-27 09:43:46.803', '2026-07-27 09:43:46.803');

-- ----------------------------
-- Table structure for notification_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."notification_types";
CREATE TABLE "public"."notification_types" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "type" "public"."NotificationType_Type" NOT NULL
)
;

-- ----------------------------
-- Records of notification_types
-- ----------------------------
INSERT INTO "public"."notification_types" VALUES ('a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW_USER');
INSERT INTO "public"."notification_types" VALUES ('eae05c50-deab-4f00-97e9-44416e7b45f9', 'REPLY_COMMENT');
INSERT INTO "public"."notification_types" VALUES ('fb34c97e-34c2-45f0-9c48-53cc4d6e8fdc', 'COMMENT_POST');
INSERT INTO "public"."notification_types" VALUES ('e8970efa-14ae-43d4-8c2d-4511239753b7', 'FRIEND_REQUEST');
INSERT INTO "public"."notification_types" VALUES ('73d364ef-1377-4323-8bb4-a1a66314aca0', 'LIKE_POST');
INSERT INTO "public"."notification_types" VALUES ('e9af6fc1-bd29-4027-a170-48e4941e9af6', 'LIKE_COMMENT');
INSERT INTO "public"."notification_types" VALUES ('2e333739-bc20-4e6b-8320-34db2a3fb767', 'FRIEND_ACCEPT');
INSERT INTO "public"."notification_types" VALUES ('6e43b575-3e0e-4b08-a395-2ced3a0a86fe', 'SHARE_POST');
INSERT INTO "public"."notification_types" VALUES ('cfa10bec-e534-4a20-9674-0c29a97baf8e', 'COMMENT_MENTION');

-- ----------------------------
-- Table structure for notifications
-- ----------------------------
DROP TABLE IF EXISTS "public"."notifications";
CREATE TABLE "public"."notifications" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "type_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "entity_type" "public"."EntityType",
  "priority" "public"."NotificationPriority" NOT NULL DEFAULT 'NORMAL'::"NotificationPriority",
  "is_read" bool NOT NULL DEFAULT false,
  "is_deleted" bool NOT NULL DEFAULT false,
  "content" jsonb,
  "metadata" jsonb,
  "recipient_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "sender_id" text COLLATE "pg_catalog"."default",
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "read_at" timestamp(3)
)
;

-- ----------------------------
-- Records of notifications
-- ----------------------------
INSERT INTO "public"."notifications" VALUES ('2eed5bfc-6c0a-42ac-bca8-dd83c7a3caf5', 'fb34c97e-34c2-45f0-9c48-53cc4d6e8fdc', 'COMMENT', 'NORMAL', 'f', 't', '{"title": "New Comment", "message": "lucan2 commented on your post"}', '{"postId": "e2238074-7e92-4f57-a19c-36851a083bc3", "commentId": "6d2ced68-0459-41e3-b8d1-ad23201738bb", "commentAuthor": {"avatar": "https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1734971185363_Snaptik.app_744868353203508353820.jpg", "fullName": "Luca N", "username": "lucan2"}}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2025-03-29 08:45:32.756', NULL);
INSERT INTO "public"."notifications" VALUES ('43d4d77d-3711-42b4-88fe-98c1bed7a4a0', 'fb34c97e-34c2-45f0-9c48-53cc4d6e8fdc', 'COMMENT', 'NORMAL', 'f', 't', '{"title": "New Comment", "message": "lucan2 commented on your post"}', '{"postId": "e2238074-7e92-4f57-a19c-36851a083bc3", "commentId": "8d377d7e-4e4a-42ae-884f-5737706db6b7", "commentAuthor": {"avatar": "https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1734971185363_Snaptik.app_744868353203508353820.jpg", "fullName": "Luca N", "username": "lucan2"}}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2025-03-29 08:48:56.681', NULL);
INSERT INTO "public"."notifications" VALUES ('7ba4da65-1739-4cef-9fe0-2d9bfe1e9e41', 'fb34c97e-34c2-45f0-9c48-53cc4d6e8fdc', 'COMMENT', 'NORMAL', 't', 'f', '{"title": "New Comment", "message": "lucan2 commented on your post"}', '{"postId": "e2238074-7e92-4f57-a19c-36851a083bc3", "commentId": "4d5b5a87-6bfc-47f7-b3b5-c7d9e21b20d0", "commentAuthor": {"avatar": "https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1734971185363_Snaptik.app_744868353203508353820.jpg", "fullName": "Luca N", "username": "lucan2"}}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2025-06-10 16:00:08.378', '2025-07-09 08:16:54.03');
INSERT INTO "public"."notifications" VALUES ('a7e46bed-2fb0-4127-a7cc-829f3adcee7e', 'fb34c97e-34c2-45f0-9c48-53cc4d6e8fdc', 'COMMENT', 'NORMAL', 'f', 't', '{"title": "New Comment", "message": "lucan2 commented on your post"}', '{"postId": "e2238074-7e92-4f57-a19c-36851a083bc3", "commentId": "b2c98c4e-3006-4e20-b61c-fdf0352ddbe7", "commentAuthor": {"avatar": "https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1734971185363_Snaptik.app_744868353203508353820.jpg", "fullName": "Luca N", "username": "lucan2"}}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2025-05-06 14:11:32.686', NULL);
INSERT INTO "public"."notifications" VALUES ('01e499d8-c818-465b-a285-07184303af07', 'a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW', 'NORMAL', 'f', 'f', '{"title": "New Follower", "message": "propro2421 started following you"}', '{"follower": {"id": "898c5eed-1650-4a27-9ae1-45fec186d37e", "avatar": null, "fullName": "tx123", "username": "propro2421"}}', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '898c5eed-1650-4a27-9ae1-45fec186d37e', '2025-06-19 06:57:18.264', NULL);
INSERT INTO "public"."notifications" VALUES ('70795540-1419-4c67-8217-d8c82b5a9fb0', 'a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW', 'NORMAL', 'f', 't', '{"title": "New Follower", "message": "lucan1 started following you"}', '{"follower": {"id": "d66d20e6-d9cc-4218-9de6-8eeae42ea9ca", "avatar": "https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1749196673660_1749196672973_image", "fullName": "Luca Nguyen", "username": "lucan1"}}', '46d96705-4f8d-475d-8527-995ff185ca89', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-07 15:49:23.812', NULL);
INSERT INTO "public"."notifications" VALUES ('c169c40a-0163-4089-ae80-238558847b6b', 'e8970efa-14ae-43d4-8c2d-4511239753b7', 'FRIENDSHIP', 'NORMAL', 'f', 't', '{"title": "New Friend Request", "message": "lucan1 sent you a friend request"}', '{"friend": {"id": "46d96705-4f8d-475d-8527-995ff185ca89", "avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753246235_1780753245697_image.webp", "fullName": "Luca Nguyen", "username": "lucan1"}}', '46d96705-4f8d-475d-8527-995ff185ca89', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:54:32.147', NULL);
INSERT INTO "public"."notifications" VALUES ('6d225cc0-fa9d-4ca0-a93d-fc5dbd55ee5a', 'a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW', 'NORMAL', 'f', 't', '{"title": "New Follower", "message": "lucan1 started following you"}', '{"follower": {"id": "d66d20e6-d9cc-4218-9de6-8eeae42ea9ca", "avatar": "https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1749196673660_1749196672973_image", "fullName": "Luca Nguyen", "username": "lucan1"}}', '49d9e3c0-ec00-48f0-86d3-293549c246dd', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-07 15:43:45.025', NULL);
INSERT INTO "public"."notifications" VALUES ('7c0a5d19-5506-4777-8cf7-89dfbea451f2', 'e8970efa-14ae-43d4-8c2d-4511239753b7', 'FRIENDSHIP', 'NORMAL', 'f', 't', '{"title": "New Friend Request", "message": "lucan1 sent you a friend request"}', '{"friend": {"id": "49d9e3c0-ec00-48f0-86d3-293549c246dd", "avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753246235_1780753245697_image.webp", "fullName": "Luca Nguyen", "username": "lucan1"}}', '49d9e3c0-ec00-48f0-86d3-293549c246dd', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:54:59.282', NULL);
INSERT INTO "public"."notifications" VALUES ('b122a716-6f7d-4b98-a3ef-c99ed2179bb1', 'a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW', 'NORMAL', 'f', 't', '{"title": "New Follower", "message": "lucan1 started following you"}', '{"follower": {"id": "d66d20e6-d9cc-4218-9de6-8eeae42ea9ca", "avatar": "https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1747245470178_1747245469938_image", "fullName": "Luca Nguyen", "username": "lucan1"}}', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-05-25 14:11:13.658', NULL);
INSERT INTO "public"."notifications" VALUES ('4fd4eaf9-ba5d-4762-8a15-21970e48ed8d', 'a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW', 'NORMAL', 't', 't', '{"title": "New Follower", "message": "lucan2 started following you"}', '{"follower": {"id": "6a31a93a-a961-48d6-963e-0645f99de8e4", "avatar": "https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1734971185363_Snaptik.app_744868353203508353820.jpg", "fullName": "Luca N", "username": "lucan2"}}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2025-03-29 10:05:01.745', '2025-06-03 09:05:51.705');
INSERT INTO "public"."notifications" VALUES ('778e164e-fa6a-46f1-b2c8-4e02904ce6fe', 'a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW', 'NORMAL', 'f', 't', '{"title": "New Follower", "message": "lucan1 started following you"}', '{"follower": {"id": "d66d20e6-d9cc-4218-9de6-8eeae42ea9ca", "avatar": "https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1748945410033_1748945409800_image", "fullName": "Luca Nguyen", "username": "lucan1"}}', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-06-03 10:28:35.463', NULL);
INSERT INTO "public"."notifications" VALUES ('38353510-601a-43c2-a72a-4e6b854f8aee', 'e8970efa-14ae-43d4-8c2d-4511239753b7', 'FRIENDSHIP', 'NORMAL', 'f', 't', '{"title": "New Friend Request", "message": "lucan2 sent you a friend request"}', '{"friend": {"id": "d66d20e6-d9cc-4218-9de6-8eeae42ea9ca", "avatar": "https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751217042134_1751217042282_image", "fullName": "Luca N", "username": "lucan2"}}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2026-06-06 16:47:17.43', NULL);
INSERT INTO "public"."notifications" VALUES ('9a63a1f9-0872-468e-b75f-6aeef2cb2e20', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 'f', 'f', '{"title": "New Like", "message": "lucan1 liked your post"}', '{"liker": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753246235_1780753245697_image.webp", "fullName": "Luca Nguyen", "username": "lucan1"}, "postId": "b5cc9911-e908-45e5-afb3-981e15399c9e"}', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-07 10:52:24.937', NULL);
INSERT INTO "public"."notifications" VALUES ('32ec4b7f-f0d3-46d4-aec4-f51300c3a5f8', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 'f', 'f', '{"title": "New Like", "message": "lucan1 liked your post"}', '{"liker": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753246235_1780753245697_image.webp", "fullName": "Luca Nguyen", "username": "lucan1"}, "postId": "5943e205-8dff-49f9-8eb5-9947336c9343"}', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-07 10:52:29.305', NULL);
INSERT INTO "public"."notifications" VALUES ('92dc9fe9-6afd-4942-a5e2-b1fc446f0f55', 'e9af6fc1-bd29-4027-a170-48e4941e9af6', 'COMMENT', 'NORMAL', 'f', 'f', '{"title": "New Like", "message": "lucan1 liked your comment"}', '{"liker": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753246235_1780753245697_image.webp", "fullName": "Luca Nguyen", "username": "lucan1"}, "postId": "ee207bbe-481f-4c0f-ad31-a29fddd0d350", "commentId": "0dce815c-eb60-4146-bb1a-d8de5c4ecf33"}', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-07 13:21:55.535', NULL);
INSERT INTO "public"."notifications" VALUES ('d65aa9d9-be43-43f9-ae59-17f37faa09fc', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 'f', 't', '{"title": "New Like", "message": "devYuki2005 liked your post"}', '{"liker": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780839260620_1780839259848_image.webp", "fullName": "Dang Hoang Thien An", "username": "devYuki2005"}, "postId": "445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9"}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2026-06-07 13:36:51.626', NULL);
INSERT INTO "public"."notifications" VALUES ('53528195-c8a2-4291-b6ec-a6fc21002481', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 'f', 't', '{"title": "New Like", "message": "devYuki2005 liked your post"}', '{"liker": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780839260620_1780839259848_image.webp", "fullName": "Dang Hoang Thien An", "username": "devYuki2005"}, "postId": "445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9"}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2026-06-07 13:36:58.226', NULL);
INSERT INTO "public"."notifications" VALUES ('758eac3a-921a-4c14-83ad-c9983dd8b0fc', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 'f', 't', '{"title": "New Like", "message": "devYuki2005 liked your post"}', '{"liker": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780839260620_1780839259848_image.webp", "fullName": "Dang Hoang Thien An", "username": "devYuki2005"}, "postId": "445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9"}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2026-06-07 13:37:03.346', NULL);
INSERT INTO "public"."notifications" VALUES ('6328fa88-88c3-4ba4-be05-27ef1aeaaf99', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 'f', 't', '{"title": "New Like", "message": "devYuki2005 liked your post"}', '{"liker": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780839260620_1780839259848_image.webp", "fullName": "Dang Hoang Thien An", "username": "devYuki2005"}, "postId": "445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9"}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2026-06-07 13:37:12.861', NULL);
INSERT INTO "public"."notifications" VALUES ('97182062-ac0f-41d4-bef1-f042dd2c8ca1', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 'f', 't', '{"title": "New Like", "message": "devYuki2005 liked your post"}', '{"liker": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780839260620_1780839259848_image.webp", "fullName": "Dang Hoang Thien An", "username": "devYuki2005"}, "postId": "445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9"}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2026-06-07 13:37:17.719', NULL);
INSERT INTO "public"."notifications" VALUES ('3ff65396-a5c8-49ed-88ef-c3245ae18391', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 'f', 't', '{"title": "New Like", "message": "devYuki2005 liked your post"}', '{"liker": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780839260620_1780839259848_image.webp", "fullName": "Dang Hoang Thien An", "username": "devYuki2005"}, "postId": "445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9"}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2026-06-07 13:37:23.284', NULL);
INSERT INTO "public"."notifications" VALUES ('aedde128-7db4-4804-b012-911c9cdde707', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 'f', 't', '{"title": "New Like", "message": "devYuki2005 liked your post"}', '{"liker": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780839260620_1780839259848_image.webp", "fullName": "Dang Hoang Thien An", "username": "devYuki2005"}, "postId": "445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9"}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2026-06-07 13:37:31.636', NULL);
INSERT INTO "public"."notifications" VALUES ('e920002a-9940-4a79-b044-1dd056e867f5', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 'f', 't', '{"title": "New Like", "message": "devYuki2005 liked your post"}', '{"liker": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780839260620_1780839259848_image.webp", "fullName": "Dang Hoang Thien An", "username": "devYuki2005"}, "postId": "445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9"}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2026-06-07 13:37:41.11', NULL);
INSERT INTO "public"."notifications" VALUES ('0cb19544-6e1a-4657-bc82-003f2cad3d56', '2e333739-bc20-4e6b-8320-34db2a3fb767', 'FRIENDSHIP', 'NORMAL', 'f', 'f', '{"title": "Friend Request Accepted", "message": "lucan1 accepted your friend request"}', '{"friend": {"id": "d66d20e6-d9cc-4218-9de6-8eeae42ea9ca", "avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753246235_1780753245697_image.webp", "fullName": "Luca Nguyen", "username": "lucan1"}}', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-07 13:41:46.347', NULL);
INSERT INTO "public"."notifications" VALUES ('8365ba29-d300-4542-b1d3-7c47d6369bf7', 'e8970efa-14ae-43d4-8c2d-4511239753b7', 'FRIENDSHIP', 'NORMAL', 't', 't', '{"title": "New Friend Request", "message": "devYuki2005 sent you a friend request"}', '{"friend": {"id": "d66d20e6-d9cc-4218-9de6-8eeae42ea9ca", "avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780839260620_1780839259848_image.webp", "fullName": "Dang Hoang Thien An", "username": "devYuki2005"}}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2026-06-07 13:41:18.374', '2026-06-07 13:41:35.461');
INSERT INTO "public"."notifications" VALUES ('fa18dc5a-63cc-4db4-bad4-43a2dfa128f7', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 't', 'f', '{"title": "New Like", "message": "devYuki2005 liked your post"}', '{"liker": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780839260620_1780839259848_image.webp", "fullName": "Dang Hoang Thien An", "username": "devYuki2005"}, "postId": "445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9"}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2026-06-07 13:37:56.675', '2026-06-07 16:31:43.191');
INSERT INTO "public"."notifications" VALUES ('3cb5da91-b17c-41b4-8b45-3ba4ad3b3383', 'fb34c97e-34c2-45f0-9c48-53cc4d6e8fdc', 'COMMENT', 'NORMAL', 'f', 't', '{"title": "New Comment", "message": "devYuki2005 commented on your post"}', '{"postId": "445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9", "commentId": "b7460b2f-185f-4155-b20e-5931f71b68a0", "commentAuthor": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780839260620_1780839259848_image.webp", "fullName": "Dang Hoang Thien An", "username": "devYuki2005"}}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2026-06-07 14:02:36.475', NULL);
INSERT INTO "public"."notifications" VALUES ('c4e8e80a-cc68-4fb9-8685-75a60126b664', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 't', 'f', '{"title": "New Like", "message": "devYuki2005 liked your post"}', '{"liker": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780839260620_1780839259848_image.webp", "fullName": "Dang Hoang Thien An", "username": "devYuki2005"}, "postId": "cccd5333-3355-4a54-b566-1a137fd28a1b"}', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2026-06-07 13:40:55.641', '2026-06-07 14:12:56.592');
INSERT INTO "public"."notifications" VALUES ('300c232a-013c-4b4d-a3a4-a091b88d9cfb', '6e43b575-3e0e-4b08-a395-2ced3a0a86fe', 'POST', 'NORMAL', 'f', 'f', '{"title": "New Share", "message": "lucan1 shared your post"}', '{"postId": "cccd5333-3355-4a54-b566-1a137fd28a1b", "sharer": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753246235_1780753245697_image.webp", "fullName": "Luca Nguyen", "username": "lucan1"}, "sharePostId": "3faf3afd-24eb-4fd1-ac14-5d5db1dd268d"}', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-07 16:25:52.574', NULL);
INSERT INTO "public"."notifications" VALUES ('2839b418-fed0-4d16-afb1-a282a8a4e69c', '6e43b575-3e0e-4b08-a395-2ced3a0a86fe', 'POST', 'NORMAL', 'f', 'f', '{"title": "New Share", "message": "yukicute123 shared your post"}', '{"postId": "445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9", "sharer": {"avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780841425587_1780841425359_image.webp", "fullName": "Dang Yuki", "username": "yukicute123"}, "sharePostId": "dac8d203-2286-49a1-a863-6288aedd31a5"}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2026-06-09 06:58:03.217', NULL);
INSERT INTO "public"."notifications" VALUES ('ae62596a-b479-4a06-9ece-a00c84f4c86c', 'a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW', 'NORMAL', 'f', 'f', '{"title": "New Follower", "message": "yukicute123 started following you"}', '{"follower": {"id": "9e0c791c-c424-43fa-9c48-d73b11796ec9", "avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780841425587_1780841425359_image.webp", "fullName": "Dang Yuki", "username": "yukicute123"}}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2026-06-09 07:06:11.046', NULL);
INSERT INTO "public"."notifications" VALUES ('92d05e44-5b9f-42bc-b843-07cec06996fd', 'e8970efa-14ae-43d4-8c2d-4511239753b7', 'FRIENDSHIP', 'NORMAL', 'f', 't', '{"title": "New Friend Request", "message": "yukicute123 sent you a friend request"}', '{"friend": {"id": "d66d20e6-d9cc-4218-9de6-8eeae42ea9ca", "avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780841425587_1780841425359_image.webp", "fullName": "Dang Yuki", "username": "yukicute123"}}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2026-06-09 07:06:12.598', NULL);
INSERT INTO "public"."notifications" VALUES ('3f688578-70bf-499c-ba5f-4e28b6d59d01', '2e333739-bc20-4e6b-8320-34db2a3fb767', 'FRIENDSHIP', 'NORMAL', 'f', 'f', '{"title": "Friend Request Accepted", "message": "lucan1 accepted your friend request"}', '{"friend": {"id": "d66d20e6-d9cc-4218-9de6-8eeae42ea9ca", "avatar": "https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753246235_1780753245697_image.webp", "fullName": "Luca Nguyen", "username": "lucan1"}}', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-09 07:06:26.288', NULL);
INSERT INTO "public"."notifications" VALUES ('e1517bd5-9f69-4cf9-9d4b-807ec6e48b99', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 'f', 'f', '{"title": "New Like", "message": "lucan2 liked your post"}', '{"liker": {"avatar": "https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751217042134_1751217042282_image", "fullName": "Luca N", "username": "lucan2"}, "postId": "445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9"}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2026-06-30 06:19:52.116', NULL);
INSERT INTO "public"."notifications" VALUES ('2e3a1781-8a5b-4ee9-8a10-05b2075b3c2c', 'cfa10bec-e534-4a20-9674-0c29a97baf8e', 'COMMENT', 'NORMAL', 'f', 'f', '{"title": "Mentioned in Comment", "message": "taynguyen52636 mentioned you in a comment"}', '{"postId": "deff67f2-deee-435d-ac5a-9bc6b58ce3de", "commentId": "80ebb24c-2e6d-4bf6-8a72-9cbc730a8e31", "mentionedBy": {"avatar": null, "fullName": "tay", "username": "taynguyen52636"}}', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', '19315748-376c-4aab-9307-936d740fbfec', '2026-07-27 09:44:16.173', NULL);
INSERT INTO "public"."notifications" VALUES ('d0c3f910-8df1-4cf0-ae81-7f3aaf6da67c', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 'f', 'f', '{"title": "New Like", "message": "taynguyen52636 liked your post"}', '{"liker": {"avatar": null, "fullName": "tay", "username": "taynguyen52636"}, "postId": "0a2b1901-c2fc-437d-b0f7-cb95895735f9"}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '19315748-376c-4aab-9307-936d740fbfec', '2026-07-27 09:47:26.704', NULL);
INSERT INTO "public"."notifications" VALUES ('7a1a0491-4ff7-4868-a9fd-bd016dd9bd66', '73d364ef-1377-4323-8bb4-a1a66314aca0', 'POST', 'NORMAL', 'f', 't', '{"title": "New Like", "message": "taynguyen52636 liked your post"}', '{"liker": {"avatar": null, "fullName": "tay", "username": "taynguyen52636"}, "postId": "445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9"}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '19315748-376c-4aab-9307-936d740fbfec', '2026-07-27 09:47:22.368', NULL);
INSERT INTO "public"."notifications" VALUES ('d303d836-e815-409d-b9c8-0e03125bf203', 'e8970efa-14ae-43d4-8c2d-4511239753b7', 'FRIENDSHIP', 'NORMAL', 'f', 'f', '{"title": "New Friend Request", "message": "taynguyen52636 sent you a friend request"}', '{"friend": {"id": "d66d20e6-d9cc-4218-9de6-8eeae42ea9ca", "avatar": null, "fullName": "tay", "username": "taynguyen52636"}}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '19315748-376c-4aab-9307-936d740fbfec', '2026-07-27 14:33:15.596', NULL);

-- ----------------------------
-- Table structure for post_comment_likes
-- ----------------------------
DROP TABLE IF EXISTS "public"."post_comment_likes";
CREATE TABLE "public"."post_comment_likes" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "comment_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "type" "public"."ReactionType" NOT NULL DEFAULT 'LIKE'::"ReactionType",
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of post_comment_likes
-- ----------------------------
INSERT INTO "public"."post_comment_likes" VALUES ('12764d21-ab6b-49bf-b77f-0f0cc4b5dcd0', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '0dce815c-eb60-4146-bb1a-d8de5c4ecf33', 'LOVE', '2026-06-07 13:21:54.804');

-- ----------------------------
-- Table structure for post_comments
-- ----------------------------
DROP TABLE IF EXISTS "public"."post_comments";
CREATE TABLE "public"."post_comments" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "content" varchar(3000) COLLATE "pg_catalog"."default" NOT NULL,
  "post_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "reply_to_id" text COLLATE "pg_catalog"."default",
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(3) NOT NULL,
  "level" int4 NOT NULL DEFAULT 0,
  "author_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "replies_count" int4 NOT NULL DEFAULT 0,
  "like_count" int4 NOT NULL DEFAULT 0
)
;

-- ----------------------------
-- Records of post_comments
-- ----------------------------
INSERT INTO "public"."post_comments" VALUES ('0c4b605b-df25-428a-89be-c754edca1a5b', '<p>đúng đúng<br>anh BE gánh còng lưng</p>', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', 'b76a3a74-e582-4253-ba5c-fe8f16bb8465', '2025-01-18 06:23:24.747', '2025-01-18 06:23:59.387', 2, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 1, 0);
INSERT INTO "public"."post_comments" VALUES ('b76a3a74-e582-4253-ba5c-fe8f16bb8465', '<p>về  system thì 10 điểm :3</p>', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', '0dce815c-eb60-4146-bb1a-d8de5c4ecf33', '2025-01-18 06:23:12.979', '2025-01-18 06:24:22.503', 1, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 0, 0);
INSERT INTO "public"."post_comments" VALUES ('db6eabd7-1f34-42f3-a820-176157a74472', '<p>hic :(( thằng FE thì <strong classname="font-bold">mất dạy</strong> gặp ông BE <strong classname="font-bold">chu đáo </strong>:(( tự mình phá huỷ chính mình :))) thật hài hước đúng chứ <strong classname="font-bold"><em classname="font-italic">Duki </em></strong>💘</p><p></p>', '7cf32254-dc2d-44ff-904b-6d23d6aba6e7', NULL, '2025-01-13 14:46:24.286', '2025-01-14 15:33:28.928', 0, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 1, 0);
INSERT INTO "public"."post_comments" VALUES ('0908a9ea-09e3-4809-b409-9e5404246303', '<p>chia sẽ cho thầy đi </p><p></p>', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', NULL, '2025-01-18 13:48:05.911', '2025-01-18 13:49:28.636', 0, '49d9e3c0-ec00-48f0-86d3-293549c246dd', 0, 0);
INSERT INTO "public"."post_comments" VALUES ('f8af652a-8313-4a55-b069-fb59a33961bc', '<p><strong classname="font-bold">Lorem Ipsum</strong> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p>', 'de33bbdb-3bcc-4094-a392-0403f0f20cbd', NULL, '2025-01-17 06:27:49.561', '2025-01-20 09:51:53.811', 0, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 0, 0);
INSERT INTO "public"."post_comments" VALUES ('459011d9-c8be-4011-b4e0-6eb66523d1f7', '<p>mình chỉ còn một mình họ :((  mất họ rồi mình chẳng còn gì nữa :(( mình cố tình trở nên hài hước thú vị để họ vui  nhưng có  vẻ như mình đã chợt quên mất rằng bản thân cư  sử  đúng mực  cậu ạ :((<br>đúng não cá vàng luôn :(( ngu ơi là nguuuu</p>', '7cf32254-dc2d-44ff-904b-6d23d6aba6e7', 'db6eabd7-1f34-42f3-a820-176157a74472', '2025-01-14 13:57:43.521', '2025-01-20 13:14:05.33', 1, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 0, 0);
INSERT INTO "public"."post_comments" VALUES ('bd5407d9-fb1f-48bf-8599-29999e48605f', '<p>đáng suy ngẫm :))</p>', '59f85f60-a7b7-43f2-a2c8-ab75fc66bb48', NULL, '2025-03-03 04:09:55.043', '2025-03-03 04:09:55.043', 0, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 0, 0);
INSERT INTO "public"."post_comments" VALUES ('4d5b5a87-6bfc-47f7-b3b5-c7d9e21b20d0', '<p>hay qua anh</p>', 'e2238074-7e92-4f57-a19c-36851a083bc3', NULL, '2025-06-10 16:00:08.358', '2025-06-10 16:00:08.358', 0, '6a31a93a-a961-48d6-963e-0645f99de8e4', 0, 0);
INSERT INTO "public"."post_comments" VALUES ('0dce815c-eb60-4146-bb1a-d8de5c4ecf33', '<p>về mặt trải nghiệm thì mình thấy  hiệu năng của mxh này rất tối<br>các tính năng <strong classname="font-bold"><em classname="font-italic">AI  </em></strong>cực kỳ bắt trend :3</p>', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', NULL, '2025-01-18 06:22:33.508', '2026-06-07 13:21:54.91', 0, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 1, 1);
INSERT INTO "public"."post_comments" VALUES ('80ebb24c-2e6d-4bf6-8a72-9cbc730a8e31', '<p>đẹp ko</p><p><a href="/profile/lucan4" data-type="mention" class="mention" data-id="9b00b60c-005d-4ad2-832b-d2d0abcd5fc8" data-label="Luca Nguyen" data-username="lucan4">@Luca Nguyen</a> </p><p></p><p></p>', 'deff67f2-deee-435d-ac5a-9bc6b58ce3de', NULL, '2026-07-27 09:44:16.126', '2026-07-27 09:44:16.126', 0, '19315748-376c-4aab-9307-936d740fbfec', 0, 0);

-- ----------------------------
-- Table structure for post_likes
-- ----------------------------
DROP TABLE IF EXISTS "public"."post_likes";
CREATE TABLE "public"."post_likes" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "userId" text COLLATE "pg_catalog"."default" NOT NULL,
  "postId" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "type" "public"."ReactionType" NOT NULL DEFAULT 'LIKE'::"ReactionType"
)
;

-- ----------------------------
-- Records of post_likes
-- ----------------------------
INSERT INTO "public"."post_likes" VALUES ('6999d43e-c76f-4928-8f13-e76b37794f0d', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '7cf32254-dc2d-44ff-904b-6d23d6aba6e7', '2025-01-11 06:10:14.936', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('50c575eb-be48-49f2-a95b-5afffead6a22', '49d9e3c0-ec00-48f0-86d3-293549c246dd', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', '2025-01-06 14:31:14.542', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('d49e13ed-79d9-4b8a-9bf4-bd7c639b6bc3', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '59f85f60-a7b7-43f2-a2c8-ab75fc66bb48', '2025-01-06 07:04:07.894', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('eb135d60-a37d-4427-962e-4be6e5159dad', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '8f9db143-2783-4a2a-947e-2896560fad89', '2025-01-08 07:38:53.228', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('b1c62bc7-c511-4d65-8037-47334247c63c', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '0a2b1901-c2fc-437d-b0f7-cb95895735f9', '2025-01-11 06:35:26.142', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('d970fcd0-e1ed-4de5-ae8b-285d2d85eea1', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '10374432-832f-4135-b87e-d00ef6b1d3d5', '2025-01-11 09:55:42.815', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('00ab6680-36f4-4011-a2b0-904362a1d04a', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '5943e205-8dff-49f9-8eb5-9947336c9343', '2025-01-07 09:12:04.782', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('0af39c47-5dae-4e94-8a38-2154aef128fe', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '10374432-832f-4135-b87e-d00ef6b1d3d5', '2025-01-06 08:49:04.472', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('644db4fa-682a-4f15-9403-7b07d3712685', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'b5cc9911-e908-45e5-afb3-981e15399c9e', '2025-01-06 08:49:32.415', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('2f0c6b28-fe7e-459e-8f91-27542df3ba2e', '49d9e3c0-ec00-48f0-86d3-293549c246dd', 'b5cc9911-e908-45e5-afb3-981e15399c9e', '2024-12-19 06:02:38.066', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('c01d6c6d-3cde-40a2-93c4-77274a0cdab2', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'de33bbdb-3bcc-4094-a392-0403f0f20cbd', '2025-04-25 06:01:03.941', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('1f56d808-bb82-4349-afce-6885bca20482', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'e2238074-7e92-4f57-a19c-36851a083bc3', '2025-03-01 09:15:54.184', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('61591cc8-3673-46bb-a927-87472b0a5379', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'e2238074-7e92-4f57-a19c-36851a083bc3', '2025-03-27 07:02:08.355', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('1817f70d-d033-45a6-bb27-572c1a171505', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'e2238074-7e92-4f57-a19c-36851a083bc3', '2025-04-23 11:08:13.006', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('c70461a5-066f-4f21-9f53-8ddf6810db57', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', '2025-05-12 06:26:21.345', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('7e6f5270-11c7-4c11-a84e-1c8bda3acae9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '352053c2-d22d-4896-95b9-6fe47e71c915', '2025-06-03 10:33:11.718', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('aa81a1bf-c003-4d58-b744-fc452d8b7e49', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'cccd5333-3355-4a54-b566-1a137fd28a1b', '2025-06-27 09:02:14.042', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('41e4d898-84d9-4b61-9774-a12396816a0c', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9', '2026-06-07 10:44:08.068', 'LOVE');
INSERT INTO "public"."post_likes" VALUES ('d27df663-23a7-4e03-962d-5859f53fe8b1', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '0a2b1901-c2fc-437d-b0f7-cb95895735f9', '2025-04-23 10:52:58.497', 'LOVE');
INSERT INTO "public"."post_likes" VALUES ('72cce936-72b1-47b2-9cb0-9cdcead10c26', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'b5cc9911-e908-45e5-afb3-981e15399c9e', '2026-06-07 10:52:24.396', 'HAHA');
INSERT INTO "public"."post_likes" VALUES ('883e5803-c350-436d-8319-701dc5f35b6d', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '5943e205-8dff-49f9-8eb5-9947336c9343', '2026-06-07 10:52:28.893', 'HAHA');
INSERT INTO "public"."post_likes" VALUES ('d08624d4-c387-4947-8dd3-f84a1195ed27', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '59f85f60-a7b7-43f2-a2c8-ab75fc66bb48', '2025-01-08 09:33:36', 'HAHA');
INSERT INTO "public"."post_likes" VALUES ('392ecbbc-6bac-4e83-ac99-c6f157ee7cef', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', '2025-01-12 15:04:42.463', 'LOVE');
INSERT INTO "public"."post_likes" VALUES ('bcf337f7-ed6c-4905-a498-be5bdaf973b5', '02ad241e-66a7-4e44-99fd-36fced0ca386', '445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9', '2026-06-07 13:37:56.181', 'LOVE');
INSERT INTO "public"."post_likes" VALUES ('8b97e85d-7bdd-41ec-9503-a524a453b6c2', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'cccd5333-3355-4a54-b566-1a137fd28a1b', '2026-06-07 13:40:55.11', 'LOVE');
INSERT INTO "public"."post_likes" VALUES ('c62bb5be-8a0c-4c87-9a13-047da435d9d2', '6a31a93a-a961-48d6-963e-0645f99de8e4', '445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9', '2026-06-30 06:19:52.079', 'HAHA');
INSERT INTO "public"."post_likes" VALUES ('fb839dc7-4874-42d4-be46-2c0a3cbbf20a', '19315748-376c-4aab-9307-936d740fbfec', 'deff67f2-deee-435d-ac5a-9bc6b58ce3de', '2026-07-27 09:44:04.206', 'LIKE');
INSERT INTO "public"."post_likes" VALUES ('0af57567-3282-4eab-8f3d-fb48401f68a2', '19315748-376c-4aab-9307-936d740fbfec', '0a2b1901-c2fc-437d-b0f7-cb95895735f9', '2026-07-27 09:47:26.684', 'LIKE');

-- ----------------------------
-- Table structure for posts
-- ----------------------------
DROP TABLE IF EXISTS "public"."posts";
CREATE TABLE "public"."posts" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "content" varchar(8000) COLLATE "pg_catalog"."default" NOT NULL,
  "author_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(3) NOT NULL,
  "is_private" bool NOT NULL,
  "like_count" int4 NOT NULL DEFAULT 0,
  "comment_count" int4 NOT NULL DEFAULT 0,
  "share_count" int4 NOT NULL DEFAULT 0,
  "shared_post_id" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of posts
-- ----------------------------
INSERT INTO "public"."posts" VALUES ('59f85f60-a7b7-43f2-a2c8-ab75fc66bb48', '<p><em class="font-italic">Họ cười tôi vì tôi đang cười họ,</em></p><p><em class="font-italic">Tôi cười họ, họ bu lại đập tôi!</em></p><p></p><p>#suyngam #đáng_tiền_mạng #chữa_lành</p>', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2024-12-21 18:44:45.273', '2025-03-03 04:09:55.043', 'f', 2, 1, 0, NULL);
INSERT INTO "public"."posts" VALUES ('de33bbdb-3bcc-4094-a392-0403f0f20cbd', '<p>💕LucaN/LeoN💕</p><p>#Friend</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-01-08 07:47:56.517', '2025-04-25 06:01:03.941', 't', 1, 1, 0, NULL);
INSERT INTO "public"."posts" VALUES ('10374432-832f-4135-b87e-d00ef6b1d3d5', '<p>Trong JavaScript, <strong classname="font-bold">bất đồng bộ</strong> đề cập đến khả năng thực hiện các tác vụ mà không làm tắc nghẽn luồng chính của chương trình. Điều này có nghĩa là khi một tác vụ kéo dài (như một yêu cầu đến server hoặc một hoạt động đọc file) diễn ra, JavaScript vẫn có thể tiếp tục thực hiện các đoạn mã khác mà không bị chờ đợi.<br><br>Một trong những cách phổ biến để xử lý bất đồng bộ trong JavaScript là thông qua <em classname="font-italic">callback</em>, <em classname="font-italic">Promise</em> và <em classname="font-italic">async/await</em>. Các kỹ thuật này cho phép bạn quản lý các tác vụ chờ đợi một cách hiệu quả hơn, giúp mã của bạn trở nên dễ hiểu hơn.<br><br>Ví dụ, khi sử dụng <em classname="font-italic">Promise</em>, bạn có thể xử lý kết quả của một tác vụ bất đồng bộ một cách rõ ràng mà không cần phải lồng nhiều callback, đảm bảo mã của bạn vẫn dễ đọc và dễ bảo trì. <br><br><strong classname="font-bold">Bất đồng bộ</strong> là một phần quan trọng trong lập trình JavaScript, đặc biệt khi làm việc với các ứng dụng web, nơi nhiều tác vụ cần được thực hiện đồng thời mà không làm ảnh hưởng đến trải nghiệm người dùng.<br><br>#JavaScript #Asynchronous #Programming</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-22 14:56:41.677', '2025-01-17 09:06:53.338', 'f', 2, 0, 0, NULL);
INSERT INTO "public"."posts" VALUES ('8f9db143-2783-4a2a-947e-2896560fad89', '<p><strong classname="font-bold">Mùa Noel luôn mang đến cho chúng ta những cảm xúc đặc biệt, và không gì tuyệt vời hơn khi được trải nghiệm không khí lạnh lẽo của mùa đông cùng người bạn đồng hành, anh mentor thân mến.</strong> <br><br><em classname="font-italic">Mỗi năm, khi những bông tuyết bắt đầu rơi, thành phố như chuyển mình trong một tấm áo mới. Đường phố được trang trí lấp lánh với đèn trang trí, những cây thông Noel đầy màu sắc. Những ngày này, việc ngồi bên cạnh anh mentor, cùng nhau thưởng thức ly cacao nóng, ngắm nhìn bầu trời đầy sao thật sự là những kỉ niệm không thể nào quên.</em> <br><br><strong classname="font-bold">Dưới cái lạnh của mùa đông, chúng ta có thể trò chuyện về bao điều, từ những giấc mơ trong năm tới cho đến những kỷ niệm đáng nhớ trong quá khứ. Anh mentor luôn biết cách mang lại cho tôi những lời khuyên quý giá, giúp tôi trưởng thành hơn từng ngày.</strong> <br><br><em classname="font-italic">Chúng ta cùng nhau trải qua những giây phút ấm áp bên ngọn nến lung linh, nhâm nhi những chiếc bánh mật ngọt ngào và chia sẻ những cảm xúc trong lòng giữa không gian lạnh lẽo nhưng đầy yêu thương.</em> <br><br><strong classname="font-bold">Noel không chỉ là dịp để nhận quà mà còn là thời điểm để tri ân, để yêu thương và kết nối với những người thân yêu. Hy vọng rằng mỗi mùa Noel đến, chúng ta lại có thêm những kỷ niệm đẹp bên nhau.</strong> <br><br>#Christmas #Friendship #HolidayVibes</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-22 13:16:31.9', '2025-01-18 07:04:55.013', 'f', 1, 0, 0, NULL);
INSERT INTO "public"."posts" VALUES ('7cf32254-dc2d-44ff-904b-6d23d6aba6e7', '<p>Yuki đã tìm đc điểm để  dừng chân :3 trao trọn con tym bé nhỏ đầy vết  xước</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-01-07 06:46:42.842', '2025-03-26 07:05:12.5', 't', 1, 2, 0, NULL);
INSERT INTO "public"."posts" VALUES ('0a2b1901-c2fc-437d-b0f7-cb95895735f9', '<p>Trong năm 2024, <strong class="font-bold">câu chuyện về AI trong lập trình đang trở nên ngày càng thú vị và đầy hứa hẹn</strong>. Nhiều nhà phát triển đã bắt đầu áp dụng trí tuệ nhân tạo để tự động hóa các quy trình lập trình. Điều này giúp họ tiết kiệm thời gian và nâng cao hiệu suất làm việc.<br><br><strong class="font-bold">Hệ thống lập trình tự động được phát triển ngày càng tinh vi</strong>, không chỉ giúp viết mã mà còn đưa ra các đề xuất tối ưu hóa. Các công cụ như GitHub Copilot đã trở thành người bạn đồng hành không thể thiếu của lập trình viên. Ngoài ra, AI còn hỗ trợ trong việc kiểm tra lỗi và bảo trì mã nguồn, từ đó cải thiện chất lượng sản phẩm.<br><br><em class="font-italic">Một trong những xu hướng nổi bật là sử dụng AI để phân tích dữ liệu lớn, từ đó giúp các nhóm lập trình đưa ra quyết định tốt hơn trong việc phát triển sản phẩm</em>. Chúng ta có thể thấy những cải tiến trong việc phát triển ứng dụng di động, phần mềm doanh nghiệp và thậm chí là trong lĩnh vực trí tuệ nhân tạo.<br><br>Năm 2024 hứa hẹn sẽ mang đến nhiều cơ hội mới cho lập trình viên khi họ có thể tận dụng sức mạnh của AI. Hãy cùng theo dõi và khám phá những điều bất ngờ mà AI mang lại cho ngành lập trình nhé!<br><br>#AI #Programming #TechTrends</p>', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2024-12-22 15:33:22.377', '2026-07-27 09:47:26.689', 'f', 3, 0, 0, NULL);
INSERT INTO "public"."posts" VALUES ('352053c2-d22d-4896-95b9-6fe47e71c915', '<p>test private</p>', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-01-04 07:34:15.824', '2025-06-03 10:33:11.718', 't', 1, 0, 0, NULL);
INSERT INTO "public"."posts" VALUES ('ee207bbe-481f-4c0f-ad31-a29fddd0d350', '<p>Chắc hẳn bạn đã từng nghe đến những mạng xã hội lớn như Facebook hay Instagram, nhưng đã bao giờ bạn thử khám phá một mạng xã hội thú vị mang tên Yukibook chưa? <strong classname="font-bold">Yukibook là một sản phẩm được phát triển bởi một bạn intern Frontend và một bạn Middle Backend siêu đỉnh, hứa hẹn mang đến cho người dùng những trải nghiệm mới mẻ và độc đáo.</strong><br><br>Khi lần đầu đăng nhập vào Yukibook, tôi cảm thấy vô cùng ấn tượng với giao diện thân thiện và dễ sử dụng. <em classname="font-italic">Mọi thứ đều rất trực quan, từ việc tạo bài viết cho đến kết bạn hay nhắn tin với bạn bè. Bạn sẽ không phải lo lắng về việc "lạc trôi" giữa những tính năng phức tạp.</em> <br><br>Điều đặc biệt ở Yukibook là cộng đồng thật sự gần gũi. Bạn có thể chia sẻ những khoảnh khắc đáng nhớ trong cuộc sống của mình và nhận được nhiều phản hồi tích cực từ những người bạn mới. <strong classname="font-bold">Những tính năng như tạo bài viết, bình luận, và thả tim rất dễ dàng, giúp bạn kết nối và thể hiện bản thân một cách tự nhiên nhất.</strong><br><br>Yukibook không chỉ đơn thuần là một nơi để kết nối, mà còn là một nền tảng để sáng tạo và chia sẻ. Bạn sẽ có cơ hội khám phá sở thích mới và tham gia vào những hoạt động thú vị từ cộng đồng. Hãy cùng khám phá Yukibook, chắc chắn rằng bạn sẽ tìm thấy niềm vui và sự kết nối mà bấy lâu nay mình tìm kiếm! <br><br>#Yukibook #SocialMedia #UserExperience #Community #Fun</p>', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '2025-01-06 14:29:55.718', '2025-05-12 06:26:21.345', 'f', 3, 4, 0, NULL);
INSERT INTO "public"."posts" VALUES ('e2238074-7e92-4f57-a19c-36851a083bc3', '<p>Xin chào các bạn! Hôm nay, chúng ta cùng nhau khám phá một chủ đề thú vị: <strong class="font-bold">lợi ích của việc đọc sách</strong>. Đọc sách không chỉ giúp bạn mở mang kiến thức mà còn mang lại rất nhiều lợi ích cho tinh thần và cảm xúc của chúng ta.<br><br>Đầu tiên, <strong class="font-bold">đọc sách giúp tăng cường khả năng tập trung</strong>. Khi bạn thả mình vào những trang sách, não bộ sẽ hoạt động mạnh mẽ để theo dõi mạch truyện và các nhân vật. Điều này giúp chúng ta rèn luyện khả năng tập trung trong cuộc sống hàng ngày.<br><br>Ngoài ra, <strong class="font-bold">đọc sách còn là cách giải tỏa căng thẳng hiệu quả</strong>. Một cuốn tiểu thuyết hay hay một cuốn sách về tâm lý sẽ đưa bạn vào một thế giới khác, nơi mà bạn có thể tạm quên đi những lo âu, căng thẳng trong cuộc sống.<br><br>Cuối cùng, <strong class="font-bold">việc đọc sách thường xuyên cũng giúp cải thiện kỹ năng viết</strong> và khả năng giao tiếp. Bạn có thể học hỏi từ cách thức diễn đạt, cấu trúc câu, và phong cách viết của tác giả.<br><br><em class="font-italic">Vậy tại sao không dành chút thời gian mỗi ngày để đọc sách nhỉ? Bạn sẽ ngạc nhiên về những gì mình có thể học hỏi và cảm nhận được.</em> <br><br>Hãy cùng nhau hòa mình vào những trang sách để khám phá thế giới kỳ diệu này nhé!!<br><br>#Reading #BookLovers #BenefitsOfReading</p>', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-02-22 05:43:13.101', '2025-06-10 16:00:08.358', 'f', 3, 1, 0, NULL);
INSERT INTO "public"."posts" VALUES ('cccd5333-3355-4a54-b566-1a137fd28a1b', 'Chơi đàn guitar không chỉ là một sở thích tuyệt vời mà còn mang lại nhiều lợi ích cho cuộc sống. <strong class="font-bold">Khi bạn chơi guitar, bạn đang mở ra cánh cửa đến thế giới âm nhạc đầy sắc màu và thú vị.</strong> <br><br><em class="font-italic">Âm nhạc có khả năng kết nối con người với nhau, giúp chúng ta cảm thấy gần gũi hơn. Khi chơi guitar, bạn có thể chia sẻ những khoảnh khắc vui vẻ bên bạn bè hoặc gia đình, tạo ra những kỷ niệm đáng nhớ.</em> <br><br>Một trong những lợi ích nổi bật của việc chơi guitar chính là giảm stress. <strong class="font-bold">Âm nhạc có thể giúp bạn thư giãn, xua tan đi những căng thẳng trong cuộc sống hàng ngày.</strong> Nghe hoặc tự mình chơi đàn, não bộ sẽ tiết ra các hormone hạnh phúc, khiến tâm trạng của bạn trở nên tích cực hơn.<br><br>Hơn nữa, <strong class="font-bold">việc học và chơi guitar cũng rèn luyện tính kiên nhẫn và sự kiên trì.</strong> Bạn sẽ phát triển kỹ năng giải quyết vấn đề và tư duy logic khi thực hành từng hợp âm, cho phép bạn trở nên tự tin hơn.<br><br>Cuối cùng, hãy nhớ rằng <strong class="font-bold">ngày nào cũng dành một ít thời gian cho guitar, bạn sẽ thấy cuộc sống của mình trở nên phong phú và vui vẻ hơn.</strong> Hãy bắt đầu hành trình âm nhạc của bạn ngay hôm nay!<br><br>#Guitar #MusicBenefits #LiveHappily', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-06-24 15:01:44.476', '2026-06-07 16:25:51.631', 'f', 2, 0, 1, NULL);
INSERT INTO "public"."posts" VALUES ('b5cc9911-e908-45e5-afb3-981e15399c9e', 'NextJS so good<br>#NextJS_so_good #NextJS_so_good2 #NextJS_so_good3', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2023-11-11 14:31:11.379', '2026-06-07 10:52:24.466', 'f', 3, 0, 0, NULL);
INSERT INTO "public"."posts" VALUES ('5943e205-8dff-49f9-8eb5-9947336c9343', '<p><strong classname="font-bold">Hành trình lập trình của bạn có thể không giống ai, nhưng đó chính là sức mạnh của bạn!</strong> <br><br>Khiếm thị không phải là rào cản mà là một cơ hội để phát triển những kỹ năng độc đáo mà chỉ bạn mới có. <em classname="font-italic">Hãy tưởng tượng</em> bạn đang tạo ra những dòng mã mà không cần nhìn thấy màn hình. Đó chính là sự sáng tạo và sức mạnh của trí tưởng tượng! <br><br>Bước vào thế giới lập trình, bạn đang khám phá không chỉ là những cú pháp hay thuật toán mà còn là khả năng tự vượt qua chính mình. <strong classname="font-bold">Mỗi dòng mã bạn viết ra là một bước tiến, mỗi lỗi sai là một bài học quý giá.</strong> Hãy nhận ra rằng bạn không đơn độc trên con đường này. Có rất nhiều tài nguyên hỗ trợ cho người khiếm thị, từ phần mềm đọc màn hình đến cộng đồng lập trình viên sẵn lòng giúp đỡ. <br><br>Hãy đặt mục tiêu cho bản thân và kiên trì theo đuổi. <em classname="font-italic">Chắc chắn rằng bạn có thể biến đam mê lập trình thành hiện thực</em>, và bạn sẽ chứng minh cho thế giới thấy rằng không gì là không thể! <br><br>Hãy nhớ, mỗi cú click chuột hay mỗi dòng lệnh đều đang khẳng định giá trị của bạn. Bạn có thể làm được! <br><br>#Inspiration #BlindProgramming #CodingJourney</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-21 06:28:24.722', '2026-06-07 10:52:28.928', 'f', 2, 0, 0, NULL);
INSERT INTO "public"."posts" VALUES ('3faf3afd-24eb-4fd1-ac14-5d5db1dd268d', '<p><strong class="font-bold">hay</strong></p>', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-07 16:25:51.631', '2026-06-07 16:31:15.987', 'f', 0, 0, 0, 'cccd5333-3355-4a54-b566-1a137fd28a1b');
INSERT INTO "public"."posts" VALUES ('445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9', 'Đổ vỡ trong tình yêu luôn là một chủ đề nhạy cảm và ám ảnh đối với nhiều người. Khi tình yêu tan vỡ, cảm giác đau đớn và hụt hẫng là điều khó tránh khỏi. <strong class="font-bold">Nó có thể khiến bạn cảm thấy như thế giới xung quanh đang sụp đổ, và mọi thứ trở nên vô nghĩa.</strong> <br><br>Nhưng những lúc khó khăn nhất chính là cơ hội để chúng ta trưởng thành và tìm kiếm bản thân. <em class="font-italic">Đôi khi, việc chấm dứt một mối quan hệ cũng mang lại cơ hội để phát triển cá nhân, sửa chữa những sai lầm và học hỏi từ kinh nghiệm.</em> <br><br>Hãy dành thời gian để tự chăm sóc bản thân, làm những điều mà bạn yêu thích, và gặp gỡ những người bạn mới. Điều quan trọng là luôn nhớ rằng, sau cơn mưa trời lại sáng. Bạn không đơn độc, và luôn có những người sẵn lòng hỗ trợ bạn trong những lúc khó khăn.<br><br>Hãy coi đổ vỡ trong tình yêu như một chương mới trong cuốn sách cuộc đời của bạn. <strong class="font-bold">Nó không phải là kết thúc, mà là khởi đầu cho những hành trình mới.</strong> <br><br>#LoveRecovery #Heartbreak #PersonalGrowth', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2026-06-06 13:53:38.758', '2026-07-27 14:32:58.273', 'f', 3, 0, 1, NULL);
INSERT INTO "public"."posts" VALUES ('dac8d203-2286-49a1-a863-6288aedd31a5', '', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2026-06-09 06:58:02.319', '2026-06-09 06:58:02.319', 'f', 0, 0, 0, '445e4ba5-330e-4e5a-a7f2-ee74ae38d3b9');
INSERT INTO "public"."posts" VALUES ('deff67f2-deee-435d-ac5a-9bc6b58ce3de', '<p>căn hộ empire 2PN</p>', '19315748-376c-4aab-9307-936d740fbfec', '2026-07-27 09:43:39.362', '2026-07-27 09:44:16.126', 'f', 1, 1, 0, NULL);

-- ----------------------------
-- Table structure for push_subscriptions
-- ----------------------------
DROP TABLE IF EXISTS "public"."push_subscriptions";
CREATE TABLE "public"."push_subscriptions" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "endpoint" text COLLATE "pg_catalog"."default" NOT NULL,
  "p256dh" text COLLATE "pg_catalog"."default" NOT NULL,
  "auth" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_agent" text COLLATE "pg_catalog"."default",
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of push_subscriptions
-- ----------------------------
INSERT INTO "public"."push_subscriptions" VALUES ('abc2b51f-0cde-46b9-b89f-4f0275fa89c5', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'https://wns2-pn1p.notify.windows.com/w/?token=BQYAAABRtIIrWx5gWBPJLUKhDht%2bamGvNrVtD577FuqMJtZEzWp1WErOlpLQAem%2b8nm8l2QQtPRDtcqkYe81lF%2frUpVz87aBmVmvXxrhdC%2baRYsWrqTATzgt1MY88U2QSa9Rcj9CONAwGq32oseDoMrM03vp8YpTZDxiNQNmI4QpmEk7ROKz5vjEtKxte0XM01z5AMta8%2buL%2fFbe05i%2bfzzxaNXt2hJbPXv6RpBwOrDqiw1ULI4o9kksYFRbM3%2fG6vF75qxGqPhFHExuHlg6UNkOwzuSJldAH2swh7p5sMOZY84SthmZVqo1Yxpw7j5Bc6TSZAk%3d', 'BGkfOZ1hD1Ku8WewcNxg58Zrgwtj10Pa1XQqeH7Q_10gBeRbPoaEEFKNgNKqYUvtx_tz_1RUhKObQCmkzYnaPCc', 'kO5trn6O6uM7sr9-UCs2IQ', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-09 07:04:41.968');
INSERT INTO "public"."push_subscriptions" VALUES ('fff62139-f97a-44bd-bc4f-ecf39d4e2dd3', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'https://fcm.googleapis.com/fcm/send/c6VVIhzpkrc:APA91bHdeABTg3le_pYtNqGyHF5o-6YAsk-5QUCxOfnXVjBI5M45pqAsFlGO6FhizZNQHn0REnx59ACZiKe4Icruc_zGxcDdnqgt3uLu4H7cKlViPUw-OlV7kfg96Rzzm2sTQR5_T56P', 'BCEKluw7fqz-ZXN2jgKhdz564EVRB-Iz0R-3hGxu4RsofHYrnPdiSlWwnw7RIXueiFybIoex2e5XEuBGTdLQmN0', 'sw5YmtnU7HcX2arCmvwEkQ', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-08 21:34:18.541');
INSERT INTO "public"."push_subscriptions" VALUES ('82291747-2d2c-400e-aede-2ff837c3b6ea', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'https://wns2-pn1p.notify.windows.com/w/?token=BQYAAAAD0dfFWW7ro%2btfEdCR99pKhWfJd4iObm800kauwLNFlw8U3ItGmkkxJFMZgWCOqOgui76FDw4T8g%2f88vJQbZ8%2bR%2bIMjqHpXCE2euSrUpj%2f2q8fHlGgDpsqSIYK6svqUsyzZFxb5BPiNBTw3Ng4%2bPM1LABfHgaVkt%2bHxjVQSerYTVMJ9BLhzmps5O%2bnKwGPPwjUXhNT07xMryVAls268SkJKKgqGOFeaoZ0XGaa4oAMrbJbcuQiZtCleNfCzPG4nByTpJkOvFRL5OXKrDJA8wMVX6j61FiMHLbqugBPCUsf1C%2bCeM6IiG4v40wolRAPRX2zNsiBXELgNiwzY1e5YS3j', 'BM8CZ2yqUVmLIGsXGfGMrmuNJb2IRKq0-jwlC1ZSQQi0EA_WUg9_JqeOZ-XzQUfl0Q6eAgsqqra3f4PE8TXTAKY', 'cQlKn7Cm7VhCFdE5zexIqA', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-14 12:05:29.271');
INSERT INTO "public"."push_subscriptions" VALUES ('44f94d67-9506-4c0a-a581-8635e84a989a', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'https://wns2-pn1p.notify.windows.com/w/?token=BQYAAAB4KDZxSH2gP4XV43YNm3Tk6Bw4SCxxlEHl5Ga%2fHbQ545SOP7ZBXM%2f%2fDoKimmQFIC8phNqSWRXXage%2bUdwojdxaG2x8R3xmZF2K%2bMpJVjTDN5qn2hVjAeTOxYUCGQcxq8hSmt3FrgyxfH1ZXVuCs1ohwtR6fj7Ga4827bHGt%2f3bxYUNR0EsE9KBb%2frpcGpEs09uLkQDReiWREFUc9hFcq%2bQAX4oBbJqUOBssT4WZKPPnTJGmlBLFWO%2f9B8axZWbmUW5dvior2UtuCXkqtzfG1EPEswabw%2bmM%2fkGYep1GdjQ35w09MiwToYC7DQdsGMHwsakHknRXuSAQUwnYbVmGjR6', 'BC1lvEIUWbxpxIDwgNupKkso9gzMQjY7RT81ZSDV7ee2M30k_AoMuPev-JILxG0tHlq6DuBMRG1pCWzJ6fASREw', 'UT8Eqv3ZWhQVO6lK3kxSBQ', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-07-01 07:46:24.247');
INSERT INTO "public"."push_subscriptions" VALUES ('8c3c1629-7d28-4673-8aa6-8adf7a820273', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'https://fcm.googleapis.com/fcm/send/chEFjVuvR2k:APA91bGbo0HDfcD9ttYMtpnXu4tdXchGocJeZx0bMRLPnDF9wifDM4TSVHwCPncbu2YKefX1BaVn7zV1VsSQCsq3VotBFu9Qa2NWFV1updBF11zh2EQSLG-hthk6WqGuhWDgWvuOu5wX', 'BMA_8yHaG78yQgMrMx1gwLxNWY3snE024VIpSQjsta7PWIO-qaH1CUJ06gQrbCcxeExr0lyWuGLUYRIVO6llOYk', 'WCE6OaPz65HJhE59l4TN1A', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-09 07:02:40.084');

-- ----------------------------
-- Table structure for stories
-- ----------------------------
DROP TABLE IF EXISTS "public"."stories";
CREATE TABLE "public"."stories" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "author_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "media_url" text COLLATE "pg_catalog"."default" NOT NULL,
  "type" "public"."MediaType" NOT NULL DEFAULT 'IMAGE'::"MediaType",
  "thumbnail_url" text COLLATE "pg_catalog"."default",
  "duration" int4,
  "view_count" int4 NOT NULL DEFAULT 0,
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "expires_at" timestamp(3) NOT NULL
)
;

-- ----------------------------
-- Records of stories
-- ----------------------------
INSERT INTO "public"."stories" VALUES ('3baba825-b240-4ff9-af22-80748151241a', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/stories/d66d20e6-d9cc-4218-9de6-8eeae42ea9ca/2026/1780924927499_VID_16.mp4', 'VIDEO', NULL, 20, 1, '2026-06-08 13:22:11.085', '2026-06-09 13:22:11.083');
INSERT INTO "public"."stories" VALUES ('280a293d-29bb-4689-a024-9881be0fb739', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/stories/d66d20e6-d9cc-4218-9de6-8eeae42ea9ca/2026/1780952556509_IMG_46.jpg', 'IMAGE', NULL, NULL, 1, '2026-06-08 21:02:40.263', '2026-06-09 21:02:40.262');

-- ----------------------------
-- Table structure for story_views
-- ----------------------------
DROP TABLE IF EXISTS "public"."story_views";
CREATE TABLE "public"."story_views" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "story_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "viewer_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of story_views
-- ----------------------------
INSERT INTO "public"."story_views" VALUES ('1d9a79b9-e6e2-4ecc-9d96-c44ed5b05ed3', '3baba825-b240-4ff9-af22-80748151241a', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2026-06-09 07:04:16.683');
INSERT INTO "public"."story_views" VALUES ('0c74eda4-ee35-468d-a20b-c14b0c36a959', '280a293d-29bb-4689-a024-9881be0fb739', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2026-06-09 07:04:20.652');

-- ----------------------------
-- Table structure for user_additional_info
-- ----------------------------
DROP TABLE IF EXISTS "public"."user_additional_info";
CREATE TABLE "public"."user_additional_info" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "living" text COLLATE "pg_catalog"."default",
  "hometown" text COLLATE "pg_catalog"."default",
  "jobs" text[] COLLATE "pg_catalog"."default",
  "birth_date" timestamp(3),
  "websites" text[] COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of user_additional_info
-- ----------------------------
INSERT INTO "public"."user_additional_info" VALUES ('d0b2a90d-01d1-4bea-b67c-67eff0597f5e', '65904792-fdd5-45e3-a892-830a4640fd9b', NULL, NULL, '{"student at Cao Dang Hoa Binh Xuan Loc"}', '1990-01-01 09:08:03', '{}');
INSERT INTO "public"."user_additional_info" VALUES ('764a4de1-6d8d-4ce3-8afd-89085bbc500c', '49d9e3c0-ec00-48f0-86d3-293549c246dd', NULL, NULL, '{}', '2005-06-28 08:49:17', '{}');
INSERT INTO "public"."user_additional_info" VALUES ('61ccaa46-79b6-4d92-911c-8cc8007ac4ac', 'b6dcff8d-c61b-4346-a60d-682da15baef9', NULL, NULL, '{}', NULL, '{}');
INSERT INTO "public"."user_additional_info" VALUES ('101ae694-b615-426a-a2f0-ce9801f569f9', '64d76b9c-cbe0-410f-b1fd-853cca983aa5', NULL, NULL, '{}', '2003-06-20 08:56:48', '{}');
INSERT INTO "public"."user_additional_info" VALUES ('0e353df0-b3b8-446b-92ce-c77c17222feb', '9df351a4-a867-460f-9453-7105223b9e80', 'Vũng Tàu', NULL, '{"bác sĩ"}', NULL, '{}');
INSERT INTO "public"."user_additional_info" VALUES ('62692e7b-7b44-4c8c-95c9-e8b0be483359', '898c5eed-1650-4a27-9ae1-45fec186d37e', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."user_additional_info" VALUES ('fdf0f92c-c659-4501-b9c6-645ca8f20985', 'me', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."user_additional_info" VALUES ('e54984d0-4546-40e3-ac23-0bdecd016642', '46d96705-4f8d-475d-8527-995ff185ca89', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."user_additional_info" VALUES ('54b220fc-c8bd-4814-b1ed-3360ef61e830', '95cf9878-6d9f-469a-a07d-331453dce2', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."user_additional_info" VALUES ('e7e2e7e4-ae5d-4be0-a9f6-1a2ebbd291bf', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', NULL, NULL, '{}', NULL, '{}');
INSERT INTO "public"."user_additional_info" VALUES ('176dd3e1-77e9-4fa3-b1ac-7e109316aba1', '4efe35df-757f-4ee4-b5bd-7aa7349ce5c8', NULL, NULL, '{}', NULL, '{}');
INSERT INTO "public"."user_additional_info" VALUES ('e0d3535e-7eec-4fcc-92ba-0a615b52c413', '95cf9878-6d9f-469a-a07d-331453dce25c', NULL, NULL, '{}', NULL, '{}');
INSERT INTO "public"."user_additional_info" VALUES ('33f69a03-6508-4a34-9b78-2ff667445e99', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."user_additional_info" VALUES ('e972ad20-69a3-42bd-a4e2-e6bcf77bed85', '2b707d22-77db-4861-b148-ff41a49f1ea9', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."user_additional_info" VALUES ('28742952-6db2-4647-8b98-6d60da76c3c6', 'c260b4cf-e769-4656-9073-f595b748a69b', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."user_additional_info" VALUES ('a3ce227d-9052-4f0d-97a9-18995ac26980', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '', '', '{"Admin SMOTeam"}', '1999-08-27 14:12:33', '{https://smoteam.com,https://smogroup.com}');
INSERT INTO "public"."user_additional_info" VALUES ('20458e81-ed65-4c03-8812-668167e0278a', '02ad241e-66a7-4e44-99fd-36fced0ca386', NULL, NULL, '{}', NULL, '{}');
INSERT INTO "public"."user_additional_info" VALUES ('82ea8d96-c699-462e-8dfd-1790da054be4', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'TP. Hồ Chí Minh', 'Đồng Nai', '{"Frontend Developer at SMO Team","Software Development Engineer at VNG Corporation"}', '2005-09-10 05:55:18', '{https://Yukidev.its.moe}');
INSERT INTO "public"."user_additional_info" VALUES ('5d4f885d-8a9e-4120-a343-a356f9872393', '6a31a93a-a961-48d6-963e-0645f99de8e4', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."user_additional_info" VALUES ('cba21d2d-53e0-49f8-a620-db6938610d60', '19315748-376c-4aab-9307-936d740fbfec', NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for user_sessions
-- ----------------------------
DROP TABLE IF EXISTS "public"."user_sessions";
CREATE TABLE "public"."user_sessions" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "ip_address" text COLLATE "pg_catalog"."default",
  "user_agent" text COLLATE "pg_catalog"."default",
  "payload" text COLLATE "pg_catalog"."default",
  "last_activity" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "expires_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "token" text COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of user_sessions
-- ----------------------------
INSERT INTO "public"."user_sessions" VALUES ('b8389832-74e6-4c2b-956b-e926e005f3f0', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '171.250.162.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', NULL, '2025-01-01 13:58:33.18', '2025-01-01 13:58:33.181', '2025-01-02 13:58:33.18', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiNjU5YWI1OTMtNWE5Yi00NTM1LTgwY2EtMWRjOGE2NmEyNmExIiwiaWF0IjoxNzM1NzM5OTEzLCJleHAiOjE3MzYzNDQ3MTN9.kYiL-U6bM-5XR_vTIEg___j5U0ea12f95XkY2_x_Ylo');
INSERT INTO "public"."user_sessions" VALUES ('5f45db0c-5771-401f-85a3-f20a285328dc', '084b617e-c89c-44ff-8dc9-7c1aa4f7730e', '171.252.154.61', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', NULL, '2025-01-08 04:16:38.844', '2025-01-08 04:16:38.845', '2025-01-09 04:16:38.844', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIwODRiNjE3ZS1jODljLTQ0ZmYtOGRjOS03YzFhYTRmNzczMGUiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2MyIsImtleSI6ImViNzc1OTZkLWQ3MzAtNDhjNS04ZmI1LWMyYjU3NWQyODJmYSIsImlhdCI6MTczNjMwOTc5OCwiZXhwIjoxNzM2OTE0NTk4fQ.vYItBx3mkTtFmowFmvJoOCXkWz3b1KWH34Cgh-JxIas');
INSERT INTO "public"."user_sessions" VALUES ('e0a11592-f4d5-4a6f-87d4-3d00238b0ad2', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', NULL, '2025-01-17 08:59:23.109', '2024-12-26 09:17:42.057', '2025-01-18 08:59:23.109', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6IjQyMDE4NzY4LWQwNTEtNGM2OS05OTUyLTI2NmFkZDBhZWRkMSIsImlhdCI6MTczNzEwNDM2MiwiZXhwIjoxNzM3NzA5MTYyfQ.6qfdN5Y76mbit0XYmS1zoYXK3wQAEcZslKvDMoVn_4Q');
INSERT INTO "public"."user_sessions" VALUES ('2184b5f1-178c-4b86-86e1-8455c65fc996', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '116.111.184.185', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', NULL, '2025-01-17 13:49:35.622', '2024-12-15 15:09:56.32', '2025-01-18 13:49:35.622', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6ImMzZDMzNmZjLWU4MmMtNDk5Mi04OGUxLTYwNWU1ZDczNDBhNyIsImlhdCI6MTczNzEyMTc3NSwiZXhwIjoxNzM3NzI2NTc1fQ.ZxXK8UrYPTKiYtmimOE1fmxyD5zRh_ViIpfFqiVI8Ng');
INSERT INTO "public"."user_sessions" VALUES ('cfacea91-369c-400b-92b9-08a51d61f139', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '104.28.205.73', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', NULL, '2025-01-18 13:06:12.745', '2024-12-19 05:05:45.299', '2025-01-19 13:06:12.745', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0OWQ5ZTNjMC1lYzAwLTQ4ZjAtODZkMy0yOTM1NDljMjQ2ZGQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2Iiwia2V5IjoiM2M1Mzg5OTktMWI2Yi00MzhhLWIwMmEtYTg3OWUxNjYxNDc5IiwiaWF0IjoxNzM3MjA1NTcyLCJleHAiOjE3Mzc4MTAzNzJ9.MwSUIlPsieNWVC1YVGrxvrbKArMdhTiDsI4QUbLgdYo');
INSERT INTO "public"."user_sessions" VALUES ('8c04053c-f36c-4686-b1e7-c4497085eee3', '65904792-fdd5-45e3-a892-830a4640fd9b', '104.28.205.74', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 Edg/132.0.0.0', NULL, '2025-01-21 08:03:27.191', '2025-01-21 08:03:27.194', '2025-01-22 08:03:27.191', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTkwNDc5Mi1mZGQ1LTQ1ZTMtYTg5Mi04MzBhNDY0MGZkOWIiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2MiIsImtleSI6ImU2MDBjMmRiLWE0ZDUtNGJiZC05MjZlLTYwYmEzOTY1N2ZiOSIsImlhdCI6MTczNzQ0NjYwNywiZXhwIjoxNzM4MDUxNDA3fQ.dpdE1orqiaKmW4OA9PHtTx7GwYHl_LHL_lEOLOmdqsc');
INSERT INTO "public"."user_sessions" VALUES ('c1310ae5-5fc9-478d-aa2e-61b8ccb3532c', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '171.252.154.61', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', NULL, '2025-01-06 13:47:32.427', '2025-01-06 13:47:32.429', '2025-01-07 13:47:32.427', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0OWQ5ZTNjMC1lYzAwLTQ4ZjAtODZkMy0yOTM1NDljMjQ2ZGQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2Iiwia2V5IjoiYTcwNzY2MzItNmYyYi00NDkyLWI5NDktMTcwZDBkZjg0YWFkIiwiaWF0IjoxNzM2MTcxMjUyLCJleHAiOjE3MzY3NzYwNTJ9.bHuXfbJcITSOCaVj9qvAOjizbN8wU0rUWWfDGt1q3AE');
INSERT INTO "public"."user_sessions" VALUES ('9fd5d505-786e-41c1-9177-f99d54936af3', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '171.252.154.182', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', NULL, '2025-01-18 07:43:41.217', '2025-01-18 07:43:41.219', '2025-01-19 07:43:41.217', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiZmRkM2ZkZTItZDA5YS00MTY0LTgxNjgtOGMwOTA5MGY5NjE5IiwiaWF0IjoxNzM3MTg2MjIxLCJleHAiOjE3Mzc3OTEwMjF9.eBzCo14wJvTsfpS1WkHELy_sp1sO5MTXoMpfZh5phuo');
INSERT INTO "public"."user_sessions" VALUES ('fe20c941-ddb8-4bde-9996-3f5d1c05586e', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '104.28.205.74', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', NULL, '2025-01-18 14:36:18.736', '2024-12-17 14:43:31.961', '2025-01-19 14:36:18.736', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiOGE3YWE1MWMtOGYzMS00MWMwLWE1MDktY2NhMjgyYzY1NzQ5IiwiaWF0IjoxNzM3MjEwOTc4LCJleHAiOjE3Mzc4MTU3Nzh9.JBTRoBDTmzVPwKzXQ6nOeEvBdkz3I1grPxAGrt7Tiwk');
INSERT INTO "public"."user_sessions" VALUES ('936fcfc2-5ba3-4dc0-a412-596acd50a32b', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '171.252.154.134', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', NULL, '2025-01-20 13:49:04.471', '2025-01-20 13:49:04.472', '2025-01-21 13:49:04.471', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0OWQ5ZTNjMC1lYzAwLTQ4ZjAtODZkMy0yOTM1NDljMjQ2ZGQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2Iiwia2V5IjoiMDgzNzRmYjEtMzAxMS00YWQ5LWEwNDMtMjllZTdjMTM1YzQwIiwiaWF0IjoxNzM3MzgwOTQ0LCJleHAiOjE3Mzc5ODU3NDR9.mPsyH_5zPScURD8Gi1LHBCGej3Bg4_7w8_KUnj36Ync');
INSERT INTO "public"."user_sessions" VALUES ('3ca5c8a7-c795-476b-a477-69fbb50d1478', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '116.111.185.105', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36', NULL, '2024-12-28 13:16:46.421', '2024-12-28 13:16:46.422', '2024-12-29 13:16:46.421', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjNkZTg4ODk5LTYwYmUtNDU2OS1iZTE2LWY0YTQ4NWY4MjE0NCIsImlhdCI6MTczNTM5MTgwNiwiZXhwIjoxNzM1OTk2NjA2fQ.gfDTobSy2Rjq_0IsFieE65j0MamPexz2lMzJMGMrxkM');
INSERT INTO "public"."user_sessions" VALUES ('707dd640-5146-4567-8f27-75ed711e63ed', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '171.252.155.241', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 Edg/132.0.0.0', NULL, '2025-01-28 19:11:33.39', '2025-01-21 08:39:47.946', '2025-01-29 19:11:33.39', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiNWE3ZGJhZDktMjQ1YS00M2JjLWE3YTUtMTM5ODNkZTRhNWJlIiwiaWF0IjoxNzM4MDkxNDkzLCJleHAiOjE3Mzg2OTYyOTN9.jLy3sN8T-6AcRTLHRHpn3-W6ATAKuWjr2h15_MFWZdA');
INSERT INTO "public"."user_sessions" VALUES ('9ad2772d-b092-4736-93a1-68fff172d080', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 Edg/132.0.0.0', NULL, '2025-01-29 08:33:03.346', '2025-01-20 08:04:01.587', '2025-01-30 08:33:03.346', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6ImVhYWEyNGQxLTBiZDMtNGE0MC04OWFiLWI5NjEyOTU2OGJjYiIsImlhdCI6MTczODEzOTU4MywiZXhwIjoxNzM4NzQ0MzgzfQ.Vk50czVq_QDyHiGdXjV4tUWoUpAFKx-HqZnd3t8eaW0');
INSERT INTO "public"."user_sessions" VALUES ('698de6f5-347d-4eb5-a430-e6d6940f4434', '65904792-fdd5-45e3-a892-830a4640fd9b', '171.252.188.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', NULL, '2025-03-20 09:06:39.26', '2025-03-20 07:04:07.856', '2025-03-21 09:06:39.26', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTkwNDc5Mi1mZGQ1LTQ1ZTMtYTg5Mi04MzBhNDY0MGZkOWIiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2MiIsImtleSI6IjdiMzhjZDliLTRiZTItNGZjMi1hYWZhLWM5NjE2OTMwYjNmNSIsImlhdCI6MTc0MjQ2MTU5OSwiZXhwIjoxNzQzMDY2Mzk5fQ.ljUXSd11OojRzP1aqy-J-qVZ-OFGpMFQtuZ2D8rPHpg');
INSERT INTO "public"."user_sessions" VALUES ('abccf719-d7a9-485b-b4e4-a21d5307bdbd', '1ea6fe50-6ebb-43cc-acd1-e3b094e36238', '171.252.189.0', 'node', NULL, '2025-02-22 07:21:27.549', '2025-02-22 07:21:27.134', '2025-02-23 07:21:27.549', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxZWE2ZmU1MC02ZWJiLTQzY2MtYWNkMS1lM2IwOTRlMzYyMzgiLCJ1c2VybmFtZSI6Im5vZGVqczEiLCJrZXkiOiJmYWFmMWMwNi02NzU5LTQ3NTgtOTg4Yy0zYjQyNTBlZTFiOTYiLCJpYXQiOjE3NDAyMDg4ODcsImV4cCI6MTc0MDgxMzY4N30.yvVJoQqpAGCjvKOL8-9A2abk8Jx5DdtRwD9vff5J4Hk');
INSERT INTO "public"."user_sessions" VALUES ('76898016-9af4-4e9b-b1cc-ef263937544a', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '171.252.189.0', 'node', NULL, '2025-02-22 14:31:47.244', '2025-02-21 17:59:58.003', '2025-02-23 14:31:47.244', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjRlZGZiYjM1LTRkYmMtNDJmOS1iNDZmLWJmNDgzNTFlN2YyNSIsImlhdCI6MTc0MDIzNDcwNywiZXhwIjoxNzQwODM5NTA3fQ.Lnzka-DcXKSOuKDLrHuGj5cS1oB07gfz2WoHpB1QWO0');
INSERT INTO "public"."user_sessions" VALUES ('3a22f2e3-5e81-4810-bc6e-63e4780fbe00', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '171.252.155.217', 'node', NULL, '2025-02-22 15:25:51.054', '2025-02-22 14:37:11.467', '2025-02-23 15:25:51.054', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiMzhjNTk0MjAtZWU5ZS00YjE2LTkzYzUtNTEzOTQ3YWU0YTc0IiwiaWF0IjoxNzQwMjM3OTUxLCJleHAiOjE3NDA4NDI3NTF9.1JqQ8TXhYqih2R7dJ0pM6BGZVMvPb2NkKyQq7rP3asE');
INSERT INTO "public"."user_sessions" VALUES ('2734c4e8-5f10-4f77-b93d-318ed840dfb8', '6a31a93a-a961-48d6-963e-0645f99de8e4', '3.93.60.192', 'node', NULL, '2025-02-22 15:26:35.975', '2025-02-22 05:44:02.243', '2025-02-23 15:26:35.975', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6IjVjZDk5YzE0LTAxNGYtNDNiOC1iNDI4LWQ1MTUxNDI4OGU3NSIsImlhdCI6MTc0MDIzNzk5NSwiZXhwIjoxNzQwODQyNzk1fQ.qag2gvXcuJ6rfmSIs5SU7KtLf9witiXoyfKXDC2Ily8');
INSERT INTO "public"."user_sessions" VALUES ('1e72a14d-a43d-4316-85e8-0782add1a69a', '6a31a93a-a961-48d6-963e-0645f99de8e4', '171.252.188.228', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', NULL, '2025-03-29 08:40:38.521', '2025-03-09 15:18:24.677', '2025-03-30 08:40:38.521', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6ImZjNzQxNTNkLTg2MGEtNDM3ZS1iYTEyLTRkOWU5Y2EzZDBiNCIsImlhdCI6MTc0MzIzNzYzOCwiZXhwIjoxNzQzODQyNDM4fQ.OKA-2sUDMzfvwtPXLTSIFv5hEdATBfqRuFxxDMsTvW4');
INSERT INTO "public"."user_sessions" VALUES ('9c242ca9-dc04-44a3-bf9f-30fc9b2784d2', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '104.28.205.73', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', NULL, '2025-03-31 08:43:23.579', '2025-03-19 08:48:16.066', '2025-04-01 08:43:23.579', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0OWQ5ZTNjMC1lYzAwLTQ4ZjAtODZkMy0yOTM1NDljMjQ2ZGQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2Iiwia2V5IjoiY2IzY2QwNDEtMDJmYS00M2NlLThhZDMtMmEyMzg3NzIyMTcyIiwiaWF0IjoxNzQzNDEwNjAzLCJleHAiOjE3NDQwMTU0MDN9.DZO4E8Dow6YE9FCg_izVbHMn1sxFPNYYq1R-XQCqDVk');
INSERT INTO "public"."user_sessions" VALUES ('31ade2cc-3610-48af-a43d-3bb3a8f7146d', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '171.252.188.228', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', NULL, '2025-04-04 16:47:04.489', '2025-03-08 06:13:17.013', '2025-04-05 16:47:04.489', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjUzNmQxNjliLWM4MGItNDhlMy05YTRjLTdlOGQzYjkxY2M4NyIsImlhdCI6MTc0Mzc4NTIyNCwiZXhwIjoxNzQ0MzkwMDI0fQ.iYmO2Xo8eACIjZFQuGIG0z6OqKUw4tlDrkzXqhEBOIs');
INSERT INTO "public"."user_sessions" VALUES ('1f695167-0019-4df9-aa11-6b53667e4bfa', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '171.252.189.246', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', NULL, '2025-04-05 08:38:48.602', '2025-03-10 06:34:34.76', '2025-04-06 08:38:48.602', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiOTdjZTk5NGQtOWI3MC00OWJkLTg3ZjgtNjBjYTExY2JjZDFiIiwiaWF0IjoxNzQzODQyMzI4LCJleHAiOjE3NDQ0NDcxMjh9.O3pK5oCEc2taJwXHwx2JuXAyXWQJ4wzSjGZeDrS1eK4');
INSERT INTO "public"."user_sessions" VALUES ('90302b20-1abe-496d-bee9-0baf8b8e1e38', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '171.252.155.217', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, '2025-02-27 08:30:41.462', '2025-02-27 08:30:41.463', '2025-02-28 08:30:41.462', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0OWQ5ZTNjMC1lYzAwLTQ4ZjAtODZkMy0yOTM1NDljMjQ2ZGQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2Iiwia2V5IjoiYmEwMjliNmYtZTlmYS00MjI5LWJiNTAtNDg4ZjQzYTU1OWU1IiwiaWF0IjoxNzQwNjQ1MDQxLCJleHAiOjE3NDEyNDk4NDF9.NAJaC1-FeyeG5RHF3yGp4Ah3LmX47hlAhL5nTbe9CAc');
INSERT INTO "public"."user_sessions" VALUES ('38952647-d126-44b7-8f30-c6cc178e4e23', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '171.252.188.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36 Edg/133.0.0.0', NULL, '2025-03-07 08:07:36.154', '2025-02-25 07:42:35.712', '2025-03-08 08:07:36.154', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiNGU1MzJkMGEtMzUzZC00ZTM0LWFjZjctNzhiNThmYzQ0MzcyIiwiaWF0IjoxNzQxMzM0ODU2LCJleHAiOjE3NDE5Mzk2NTZ9.444U60e2UxggqDgOb0SOTsZ0MKKxLDMqVldnBng76vA');
INSERT INTO "public"."user_sessions" VALUES ('aa1dc632-9942-4ccb-afe3-2cafa9275c62', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '171.252.155.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36 Edg/133.0.0.0', NULL, '2025-03-07 08:39:03.663', '2025-02-25 07:44:55.107', '2025-03-08 08:39:03.663', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6ImU3YmIwZTgxLTY1NTYtNDUzYS05NDA4LTRiYmIyNTk4NDBkOSIsImlhdCI6MTc0MTMzNjc0MywiZXhwIjoxNzQxOTQxNTQzfQ.FCm_-JtWqU4qHKZhP-s1wDs_xXZfGRWVbFGuqrWqxwI');
INSERT INTO "public"."user_sessions" VALUES ('2f556429-b52d-4bd1-8221-e926cdd7bf07', 'b6dcff8d-c61b-4346-a60d-682da15baef9', '171.250.162.51', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', NULL, '2025-03-12 16:17:44.045', '2025-03-12 16:16:35.509', '2025-03-13 16:17:44.045', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiNmRjZmY4ZC1jNjFiLTQzNDYtYTYwZC02ODJkYTE1YmFlZjkiLCJ1c2VybmFtZSI6Im5vZGVqczIiLCJrZXkiOiI0NmM2M2QwMC04YTg4LTQwODUtOTMyNS05MGFlM2ZkNjhmMTIiLCJpYXQiOjE3NDE3OTYyNjQsImV4cCI6MTc0MjQwMTA2NH0.T3t9OpaFii44GDoxaG230ONmtTaIAT6wBarH0VY4q70');
INSERT INTO "public"."user_sessions" VALUES ('2cc5cc35-8b48-4c4b-939f-0eb1c71a5afa', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', '171.252.188.228', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', NULL, '2025-04-04 10:31:09.913', '2025-04-04 10:30:05.573', '2025-04-05 10:31:09.913', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiYTFiMjVlYS0wNTNiLTQxMDAtYTRhZC1hOTI5NTk5MTRlZWIiLCJ1c2VybmFtZSI6Imx1Y2FuMyIsImtleSI6ImFkOWVmY2ZiLTQ1M2ItNDYzNS05ZmFjLTU3NjFiMGM4NTA0YSIsImlhdCI6MTc0Mzc2MjY2OSwiZXhwIjoxNzQ0MzY3NDY5fQ.IZtYTq8VvvyBeKywK1w77-MkuaceYE95icPVSJbFIT0');
INSERT INTO "public"."user_sessions" VALUES ('f8aa78e5-d63b-45c7-8bc7-3db5490f906f', '64d76b9c-cbe0-410f-b1fd-853cca983aa5', '113.161.83.56', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0', NULL, '2025-04-05 11:20:32.695', '2025-04-05 11:20:32.425', '2025-04-06 11:20:32.695', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NGQ3NmI5Yy1jYmUwLTQxMGYtYjFmZC04NTNjY2E5ODNhYTUiLCJ1c2VybmFtZSI6InRheTUyNjM2Iiwia2V5IjoiMWZjOWFmNTYtZmE4MS00MGM5LWI3MzUtOGNhNGZkMDg0NzQ4IiwiaWF0IjoxNzQzODUyMDMyLCJleHAiOjE3NDQ0NTY4MzJ9.X1Umy6uO9vVz7Nka3fc3n5Etd2ghgyNLK7IQJrE_jXc');
INSERT INTO "public"."user_sessions" VALUES ('7b28d73c-7c25-4781-b253-167dbb6906be', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', '171.252.188.228', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0', NULL, '2025-04-11 09:21:48.28', '2025-04-11 08:30:22.35', '2025-04-12 09:21:48.28', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiYTFiMjVlYS0wNTNiLTQxMDAtYTRhZC1hOTI5NTk5MTRlZWIiLCJ1c2VybmFtZSI6Imx1Y2FuMyIsImtleSI6ImQ2MGFkYzMzLWI1YzktNDhjYy04M2U1LTQxZWFmMzE0NzA0ZSIsImlhdCI6MTc0NDM2MzMwOCwiZXhwIjoxNzQ0OTY4MTA4fQ.Rn1F99ALdT_glc6QfyVNLdZyu5h5n5IjAPiDfXx4FEs');
INSERT INTO "public"."user_sessions" VALUES ('b4978e06-1248-40c1-9628-abf956738d96', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0', NULL, '2025-04-28 16:08:11.134', '2025-04-16 07:24:32.826', '2025-04-29 16:08:11.134', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6IjdlMWNmNDNiLTc3YjAtNGEwYS04ZTEyLWEzOTg3MDliZDg2ZSIsImlhdCI6MTc0NTg1NjQ5MCwiZXhwIjoxNzQ2NDYxMjkwfQ.eas-7ZKDyNdC2APMMHRYxTm9PFBjIM7TWjzIvBgQWt4');
INSERT INTO "public"."user_sessions" VALUES ('48b4cafc-b633-4d13-b2b5-19fe6b8b8ceb', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0', NULL, '2025-05-01 13:46:29.353', '2025-04-09 09:03:08.247', '2025-05-02 13:46:29.353', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6ImNjYjBjMTZjLThhZTctNGE3OS05NmE2LThlNDgzOTBhZTA1NiIsImlhdCI6MTc0NjEwNzE4OSwiZXhwIjoxNzQ2NzExOTg5fQ.z01uCx5RFEs0EfwtYPPbqDm5p4pLcvBPM9ErkAfTnEQ');
INSERT INTO "public"."user_sessions" VALUES ('9da3d5d9-d276-4475-a55d-a523a37dd9f9', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '171.252.153.163', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0', NULL, '2025-05-03 03:34:32.655', '2025-04-08 05:57:51.957', '2025-05-04 03:34:32.655', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiNTJhMzIzMGQtYTQxYS00NDJiLWIxN2MtM2M4OTEzOTVlMWQ1IiwiaWF0IjoxNzQ2MjQzMjcyLCJleHAiOjE3NDY4NDgwNzJ9.D5_S9WjpbMgBDwT1mIw6L_nW3i2zOY3Gcom-0vtyEY4');
INSERT INTO "public"."user_sessions" VALUES ('c327fbb2-fffa-4870-9506-60ea03d21415', '64d76b9c-cbe0-410f-b1fd-853cca983aa5', '113.185.77.207', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', NULL, '2025-05-06 04:46:30.342', '2025-05-06 04:46:30.35', '2025-05-07 04:46:30.342', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NGQ3NmI5Yy1jYmUwLTQxMGYtYjFmZC04NTNjY2E5ODNhYTUiLCJ1c2VybmFtZSI6InRheTUyNjM2Iiwia2V5IjoiNTFiNTVhMTMtMDkwYS00MjViLWI1MzAtOWNkMTNjZjUzNzRjIiwiaWF0IjoxNzQ2NTA2NzkwLCJleHAiOjE3NDcxMTE1OTB9.RkL-Isyja4cZp_fY1geAsXKkhkbxvoePKw-uW8nEho4');
INSERT INTO "public"."user_sessions" VALUES ('76a8d17e-5970-4add-bfad-b1e78ce2bc9f', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '171.252.188.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', NULL, '2025-04-01 08:29:32.247', '2025-03-26 06:33:45.677', '2026-04-02 08:29:32.247', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0OWQ5ZTNjMC1lYzAwLTQ4ZjAtODZkMy0yOTM1NDljMjQ2ZGQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2Iiwia2V5IjoiOTdkYjFmNjktZDA2OS00ZTI0LTkwYzktM2M2NzgyYTBlMmI5IiwiaWF0IjoxNzQzNDk2MTcyLCJleHAiOjE3NDQxMDA5NzJ9.hp9OaWglS8NZFtpK5D5NKPHWsHH-7_mwyo7cXbqGYDU');
INSERT INTO "public"."user_sessions" VALUES ('62c7bfae-8615-4596-9e43-c53197b48b49', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '171.253.140.226', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Mobile Safari/537.36', NULL, '2025-05-21 10:52:57.335', '2025-05-21 10:52:57.336', '2025-05-22 10:52:57.335', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjhmYjNmMTFlLTY3ZmMtNGE0Mi1hNjVjLTI0ZmExYjJhNWE3ZSIsImlhdCI6MTc0NzgyNDc3NywiZXhwIjoxNzQ4NDI5NTc3fQ.B_bxw9uvlQ-lNz0nPmatcbKBr0DDKMJFi2_XxYzGGBs');
INSERT INTO "public"."user_sessions" VALUES ('59df0ca6-5c1a-495c-afa1-1cb6bebcb3d8', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', NULL, '2025-05-24 06:18:22.419', '2025-05-08 17:29:39.609', '2025-05-25 06:18:22.419', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjA4MGFkZjAyLTkyYWYtNGM4NC05Y2M1LTlhZDhhYTZjMGZmMCIsImlhdCI6MTc0ODA2NzUwMSwiZXhwIjoxNzQ4NjcyMzAxfQ.bDOM5IU0Ym7iZP5nyYOqCiKDfeFCosGKP_QFC1qjHgQ');
INSERT INTO "public"."user_sessions" VALUES ('b22459ae-782c-4448-8622-8fe86c03da80', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', NULL, '2025-05-27 15:28:44.197', '2025-05-16 06:45:39.788', '2025-05-28 15:28:44.197', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiYTFiMjVlYS0wNTNiLTQxMDAtYTRhZC1hOTI5NTk5MTRlZWIiLCJ1c2VybmFtZSI6Imx1Y2FuMyIsImtleSI6ImRjNjAxOTk2LTY5MmUtNDNjNi1hNzM1LWQwYmQyMmU3ZGFjNiIsImlhdCI6MTc0ODM1OTcyMywiZXhwIjoxNzQ4OTY0NTIzfQ.2uzgtAwm0bbnvlK5mmEwqVpxr4Mx46CEoVDwHOGARQg');
INSERT INTO "public"."user_sessions" VALUES ('d787bfe2-6904-4349-9ff8-b57a7bba886a', '6a31a93a-a961-48d6-963e-0645f99de8e4', '171.252.154.215', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', NULL, '2025-05-27 16:15:43.916', '2025-05-06 14:09:43.927', '2025-05-28 16:15:43.916', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6IjQwYzYzOWYwLTY4NjYtNDQ1Ny04ZWQ4LWNjM2QyZDNiOTcyYSIsImlhdCI6MTc0ODM2MjU0MywiZXhwIjoxNzQ4OTY3MzQzfQ.cAdSQA4RjdMi6NGImfhhk5q6dTBF4XSXsF2gS7w-LAI');
INSERT INTO "public"."user_sessions" VALUES ('0deb7fd8-e6b3-4542-9e6e-ff5c36a2d35a', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '171.252.189.221', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0', NULL, '2025-06-02 07:34:44.992', '2025-05-12 06:23:31.337', '2025-06-03 07:34:44.992', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiOWRiMzg4YWQtMmUxNi00YTJhLTkxZGEtYWE3N2FhMDc5NmVkIiwiaWF0IjoxNzQ4ODQ5Njg0LCJleHAiOjE3NDk0NTQ0ODR9.tLjmEZVSz9HD4sgDVoJtxZl6N8s5y9BSDrpZdbu6Enw');
INSERT INTO "public"."user_sessions" VALUES ('12980e2c-55fb-4c31-aa22-ff7d3cdd09c4', '6a31a93a-a961-48d6-963e-0645f99de8e4', '171.250.162.94', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36 Edg/137.0.0.0', NULL, '2025-06-24 08:32:15.456', '2025-06-03 07:33:32.143', '2025-06-25 08:32:15.456', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6IjA5NjNhOGRjLTBlMDctNGQ5Yi04MWQ1LTZhZjFlZDIwN2VhZiIsImlhdCI6MTc1MDc1MzkzNSwiZXhwIjoxNzUxMzU4NzM1fQ.MbfwaA5t8b81K9Asfm48XDiWUWd1xRHva5lvhlGc4Jk');
INSERT INTO "public"."user_sessions" VALUES ('65fa1067-b8ce-4c36-8cc4-2715da0d5a97', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '171.250.162.94', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36 Edg/137.0.0.0', NULL, '2025-06-27 13:22:44.341', '2025-06-02 07:35:34.957', '2025-06-28 13:22:44.341', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjAzNWUyMWM2LTNkM2UtNGMzOS1hY2NlLTNlOTU3NTk1MjMxYyIsImlhdCI6MTc1MTAzMDU2NCwiZXhwIjoxNzUxNjM1MzY0fQ.arBVgNk49AcwH2OAKYTI6OFY_46krM-x9IL_KXaJDcU');
INSERT INTO "public"."user_sessions" VALUES ('83b2d342-bc10-4139-a4dc-560630ce039b', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36 Edg/137.0.0.0', NULL, '2025-06-06 10:03:38.691', '2025-06-03 07:33:50.57', '2025-06-07 10:03:38.691', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiYTFiMjVlYS0wNTNiLTQxMDAtYTRhZC1hOTI5NTk5MTRlZWIiLCJ1c2VybmFtZSI6Imx1Y2FuMyIsImtleSI6ImVjZWFmYjQ1LTljNDctNGFmOC05NDg4LTdjZWEwZTNhZjJiNyIsImlhdCI6MTc0OTIwNDIxOCwiZXhwIjoxNzQ5ODA5MDE4fQ.0qta282d6pLQP6cIgw02pJ_VnNkg52Pq0pnETYHMnkw');
INSERT INTO "public"."user_sessions" VALUES ('7c5848e2-acd8-482b-94c7-7def5da2cf3c', '6a31a93a-a961-48d6-963e-0645f99de8e4', ':', 'PostmanRuntime/7.44.0', NULL, '2025-06-13 09:42:54.326', '2025-06-13 09:42:54.328', '2025-06-14 09:42:54.326', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6IjNiN2U4NjE3LWU5NzItNDg2Yy1iMjYyLWY1NDk5ODc4N2ZkNCIsImlhdCI6MTc0OTgwNzc3NCwiZXhwIjoxNzUwNDEyNTc0fQ.dE73pFBFkDeSrxvjRypC4pu9j8MylDJ6cuJ2yhOlFzQ');
INSERT INTO "public"."user_sessions" VALUES ('35834a22-e44f-4f12-b4b0-a1ca628abebd', '898c5eed-1650-4a27-9ae1-45fec186d37e', '113.185.72.34', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36 Edg/137.0.0.0', NULL, '2025-06-19 06:57:08.424', '2025-06-19 06:57:07.975', '2025-06-20 06:57:08.424', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI4OThjNWVlZC0xNjUwLTRhMjctOWFlMS00NWZlYzE4NmQzN2UiLCJ1c2VybmFtZSI6InByb3BybzI0MjEiLCJrZXkiOiI5NjdkYTExMy03Zjg2LTQ3M2UtYmRhMC1mYmI4NTM0Y2FlZmMiLCJpYXQiOjE3NTAzMTYyMjgsImV4cCI6MTc1MDkyMTAyOH0.aUsxHGW3B7olBJYmWRZPXeVjLAmXCXkoCazC5-WJ_8M');
INSERT INTO "public"."user_sessions" VALUES ('d5c4e1a8-95d6-4d48-90d5-ca1aad53a687', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '171.252.153.221', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36 Edg/137.0.0.0', NULL, '2025-06-28 09:13:42.407', '2025-06-17 06:56:55.557', '2025-06-29 09:13:42.407', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiZjQzYWRkYzctZjM2MC00ZWMzLTlmMDItNmE3MTEyYzBhYjVmIiwiaWF0IjoxNzUxMTAyMDIyLCJleHAiOjE3NTE3MDY4MjJ9.GlN1KoJdIpfUhvZ26_cXacNQZOn0MEH_2J_yvB3nQzM');
INSERT INTO "public"."user_sessions" VALUES ('dfd948ca-9660-499a-9f64-64b83f16c887', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0', NULL, '2025-07-02 07:52:15.501', '2025-07-02 07:52:15.505', '2025-07-03 07:52:15.501', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiYTFiMjVlYS0wNTNiLTQxMDAtYTRhZC1hOTI5NTk5MTRlZWIiLCJ1c2VybmFtZSI6Imx1Y2FuMyIsImtleSI6ImM4ZDViYTMzLTBiZGItNDhhMi04NTkyLWMxNDEzNjE3ZWMzMCIsImlhdCI6MTc1MTQ0MjczNSwiZXhwIjoxNzUyMDQ3NTM1fQ.rvtrhJdETtphsrGcJbDZyb8rkKiXh0WTBZ-Tg65BrS8');
INSERT INTO "public"."user_sessions" VALUES ('e77138f9-f89a-4763-b93a-51ed3117960a', '02ad241e-66a7-4e44-99fd-36fced0ca386', '171.250.162.145', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0', NULL, '2025-08-01 15:27:00.267', '2025-08-01 15:27:00.27', '2025-08-02 15:27:00.267', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIwMmFkMjQxZS02NmE3LTRlNDQtOTlmZC0zNmZjZWQwY2EzODYiLCJ1c2VybmFtZSI6ImRldll1a2kyMDA1Iiwia2V5IjoiMDcxYWJlZTctNWE5NC00MzQ5LTgwNzMtOWE4ZDBiZDdlMmZmIiwiaWF0IjoxNzU0MDYyMDIwLCJleHAiOjE3NTQ2NjY4MjB9.mkqIRG9lt4xVwUGQzbNvvNGUHQeCsOn9HDpCf9k3H0Y');
INSERT INTO "public"."user_sessions" VALUES ('9da1286d-5c32-4eb7-9458-52bc955f7228', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '171.250.162.145', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0', NULL, '2025-08-01 15:28:21.596', '2025-07-07 07:01:37.748', '2025-08-02 15:28:21.596', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiYTM0YTQxNzItNjRjMC00ZDJkLTg4YmMtYWZjYjk0NGM5NzIyIiwiaWF0IjoxNzU0MDYyMTAxLCJleHAiOjE3NTQ2NjY5MDF9.IRapXASi9YD4aL0EOdqyHvqhkCZ9rzaeUAbM1Q0pJkY');
INSERT INTO "public"."user_sessions" VALUES ('daa9ce7a-5cb9-4464-955e-8bfbfe16ca1a', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0', NULL, '2025-08-06 19:11:39.562', '2025-06-28 06:43:28.329', '2025-08-07 19:11:47.256', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6ImI1YmU5MWM0LWUyNzItNGFhOS1hNzI4LTcxNWQ4MjI1M2M1YSIsImlhdCI6MTc1NDUwNzUwNywiZXhwIjoxNzU1MTEyMzA3fQ.KwmFEewM7qn2lS7wY_BtThlF6puTLFCyS3bqQy-PGo4');
INSERT INTO "public"."user_sessions" VALUES ('0f879fef-9c76-49a2-9843-596b1bb76d1c', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0', NULL, '2025-08-06 19:12:06.004', '2025-07-02 09:55:58.192', '2025-08-07 19:12:31.977', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjUzMGVjY2E3LTM2YWMtNDRmZS05Nzc0LWIwYmMxNWJlMzI5YSIsImlhdCI6MTc1NDUwNzU1MiwiZXhwIjoxNzU1MTEyMzUyfQ.6JWAKM-ff84zuAONAp3Sb_3wVqo9fZu2rsJ7jPIFbdo');
INSERT INTO "public"."user_sessions" VALUES ('b3963eb4-949a-45b7-a25f-dc091e856c04', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', NULL, '2026-06-06 20:17:50.284', '2026-06-06 20:17:50.3', '2026-06-07 20:17:50.284', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiYTFiMjVlYS0wNTNiLTQxMDAtYTRhZC1hOTI5NTk5MTRlZWIiLCJ1c2VybmFtZSI6Imx1Y2FuMyIsImtleSI6IjcxMmExZjlkLTExMWYtNGU0ZS04ZjUwLTgxYTFkYjVmZGJiYiIsImlhdCI6MTc4MDc3NzA3MCwiZXhwIjoxNzgxMzgxODcwfQ.8ffDFfckVCKtkCAjA58m2blaeu4LM_8FVUdY614xgN0');
INSERT INTO "public"."user_sessions" VALUES ('36f5e74a-2747-41f2-8289-2fee71c5c97b', '2b707d22-77db-4861-b148-ff41a49f1ea9', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', NULL, '2026-06-06 20:40:29.517', '2026-06-06 20:40:28.726', '2026-06-07 20:40:29.517', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIyYjcwN2QyMi03N2RiLTQ4NjEtYjE0OC1mZjQxYTQ5ZjFlYTkiLCJ1c2VybmFtZSI6Imx1Y2FuNSIsImtleSI6ImNlOTkwNzE3LTZhNDAtNDg0NC1hNjNkLTgxMjY5ZDFmYjE4OSIsImlhdCI6MTc4MDc3ODQyOSwiZXhwIjoxNzgxMzgzMjI5fQ.CyPsJRWtuTovKmcN__bsyjFLLfezhhEYTzZbaS6Ie9Q');
INSERT INTO "public"."user_sessions" VALUES ('97457098-bd23-4036-9382-1443bdad8c0d', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', NULL, '2026-06-07 13:33:42.968', '2026-06-07 13:33:42.972', '2026-06-08 13:33:42.968', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIwMmFkMjQxZS02NmE3LTRlNDQtOTlmZC0zNmZjZWQwY2EzODYiLCJ1c2VybmFtZSI6ImRldll1a2kyMDA1Iiwia2V5IjoiNzUyZjFlMWUtNzdjZS00M2E2LThmYWYtY2Q2ZmZiNTZjMWRhIiwiaWF0IjoxNzgwODM5MjIyLCJleHAiOjE3ODE0NDQwMjJ9.bJlo1eaFgASNtDm0h1AuDSlWrZ437DpLF1XAuNZcN8k');
INSERT INTO "public"."user_sessions" VALUES ('34fe5696-2bbc-455c-a185-8f571ec3c42b', '9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', NULL, '2026-06-08 14:36:22.241', '2026-06-06 20:26:58.965', '2026-06-09 14:36:22.241', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5YjAwYjYwYy0wMDVkLTRhZDItODMyYi1kMmQwYWJjZDVmYzgiLCJ1c2VybmFtZSI6Imx1Y2FuNCIsImtleSI6IjczNGFlNWQwLTYyNjMtNDc0NC1iNDYyLWM5ZTIwMjk1MDgwNSIsImlhdCI6MTc4MDkyOTM4MiwiZXhwIjoxNzgxNTM0MTgyfQ.8RAjjkTRdJtQUWExb2bAen_VkMQ1w2AUC-v2BPgyJmI');
INSERT INTO "public"."user_sessions" VALUES ('04737407-2db8-42bc-b056-121778dae994', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', NULL, '2026-06-16 20:44:44.736', '2026-06-06 13:40:23.886', '2026-06-17 20:44:44.736', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjY0NmE4YTkwLTI0ZjMtNDFjYi04YjM3LTk5OWJiNGM5NGQ2MyIsImlhdCI6MTc4MTY0MjY4NCwiZXhwIjoxNzgyMjQ3NDg0fQ.fNu-wk68KPZ0pVdPw-EHqoF7uqyMDBENzRfnDuO-zsQ');
INSERT INTO "public"."user_sessions" VALUES ('f66c00e2-4570-4213-b4a4-1a6e6e974754', '6a31a93a-a961-48d6-963e-0645f99de8e4', '116.108.170.156', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', NULL, '2026-06-25 21:12:18.906', '2026-06-06 16:22:58.924', '2026-06-26 21:12:18.906', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6IjdjMWU3OTdhLTQyYjItNGNmZS1iZmQ4LWUwOTAzYTBlNmRjYyIsImlhdCI6MTc4MjQyMTkzOCwiZXhwIjoxNzgzMDI2NzM4fQ.w6se-Nip4QTi9QalHNcgRf1K9KEM3CWxeG5g14mSJPk');
INSERT INTO "public"."user_sessions" VALUES ('d2051aaf-4596-4d50-9c01-dbced62c2f54', 'c260b4cf-e769-4656-9073-f595b748a69b', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', NULL, '2026-06-07 13:56:39.808', '2026-06-07 13:56:39.024', '2026-06-08 13:56:39.808', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJjMjYwYjRjZi1lNzY5LTQ2NTYtOTA3My1mNTk1Yjc0OGE2OWIiLCJ1c2VybmFtZSI6Im5oaWN1dGUxMjMiLCJrZXkiOiIxNmQ0NjRiMi0yMGEyLTRiMTYtYmEyYi01YWVhNGJmMWUyNGQiLCJpYXQiOjE3ODA4NDA1OTksImV4cCI6MTc4MTQ0NTM5OX0.hiuASw29K9G0fQeAV3gl1Wy5x_lFwkKmQki5efqWAR0');
INSERT INTO "public"."user_sessions" VALUES ('122f84b3-43cd-49a6-b4aa-ccf1a01afb83', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', NULL, '2026-06-08 20:43:50.127', '2026-06-08 20:43:50.128', '2026-06-09 20:43:50.127', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6ImQ4MWU0OTBlLWExN2UtNDUwZC05OWU2LTQ1ZTJiZmM3OTExMCIsImlhdCI6MTc4MDk1MTQyOSwiZXhwIjoxNzgxNTU2MjI5fQ.7YYgfriCdAF4ZFr_Z1R3v9qcgFzIyaAus6WaaFL8UWA');
INSERT INTO "public"."user_sessions" VALUES ('56bfef72-0cea-4323-81a9-9a48ff1a7e8a', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', NULL, '2026-06-09 06:59:31.809', '2026-06-09 06:59:31.811', '2026-06-10 06:59:31.809', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjdjYWZkNDIyLTQ4OTAtNDM2NS04OGRlLWQ0MmZiNDQ2OTUyZiIsImlhdCI6MTc4MDk4ODM3MSwiZXhwIjoxNzgxNTkzMTcxfQ.enLdvvaBMtxrrcqT2mwAjugAfvbZy5GMWP0-0MTunPg');
INSERT INTO "public"."user_sessions" VALUES ('ed67b364-bfa3-4c31-b036-b80fc0c1e394', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'localhost', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', NULL, '2026-06-09 09:02:33.236', '2026-06-07 14:05:12.785', '2026-06-10 09:02:33.236', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiZGExNGM1NDAtMmY5ZC00NjY1LTlmNDgtOGM3NzI0Yjk1NmQyIiwiaWF0IjoxNzgwOTk1NzUyLCJleHAiOjE3ODE2MDA1NTJ9.ATseU40v8TTdVypkmI3PY17RZ2xetuMpQYGDOyQPl0Q');
INSERT INTO "public"."user_sessions" VALUES ('5114a282-8839-4f8b-8a14-933951337f1a', '6a31a93a-a961-48d6-963e-0645f99de8e4', '116.108.72.157', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', NULL, '2026-07-04 09:06:32.665', '2026-07-04 09:06:32.667', '2026-07-05 09:06:32.665', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6IjhlZTc2ODYzLWRiMDUtNDc5MS1iM2QzLWQ5OTk5Nzc2MWIzMCIsImlhdCI6MTc4MzE1NTk5MiwiZXhwIjoxNzgzNzYwNzkyfQ._pGPCzJbQvxdzmZsWmtlmqSlaZk7qknvuUVFfc1Hnww');
INSERT INTO "public"."user_sessions" VALUES ('29a2d676-f3af-4d2d-9837-940affee7eba', '19315748-376c-4aab-9307-936d740fbfec', '125.234.97.46', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', NULL, '2026-07-27 09:43:15.159', '2026-07-27 09:43:14.611', '2026-07-28 09:43:15.159', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxOTMxNTc0OC0zNzZjLTRhYWItOTMwNy05MzZkNzQwZmJmZWMiLCJ1c2VybmFtZSI6InRheW5ndXllbjUyNjM2Iiwia2V5IjoiY2M4NTgwM2ItMzZiZC00NjM3LWE4NDItZWE4ZTE3NmM5MmYwIiwiaWF0IjoxNzg1MTQ1Mzk1LCJleHAiOjE3ODU3NTAxOTV9.6S-gzbmrbYSUm0DaFA-DAUjfL2c1LC9aq8STUdyMUtc');

-- ----------------------------
-- Table structure for user_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."user_types";
CREATE TABLE "public"."user_types" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "type_name" "public"."UserTypeEnum" NOT NULL DEFAULT 'USER'::"UserTypeEnum"
)
;

-- ----------------------------
-- Records of user_types
-- ----------------------------
INSERT INTO "public"."user_types" VALUES ('0c2d5733-69d0-4268-8a60-b39997f656b6', 'USER');
INSERT INTO "public"."user_types" VALUES ('e741110a-432d-4c02-acf4-4ba4428f37b7', 'VIP_USER');
INSERT INTO "public"."user_types" VALUES ('588b1a65-426a-468c-9365-dc1c9b851a79', 'MODERATOR');
INSERT INTO "public"."user_types" VALUES ('7c2f4d9a-b10a-4746-9e5b-f9551660bd4c', 'SUPER_ADMIN');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS "public"."users";
CREATE TABLE "public"."users" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "username" text COLLATE "pg_catalog"."default" NOT NULL,
  "email" text COLLATE "pg_catalog"."default" NOT NULL,
  "full_name" text COLLATE "pg_catalog"."default" NOT NULL,
  "password" text COLLATE "pg_catalog"."default",
  "type" text COLLATE "pg_catalog"."default" NOT NULL,
  "phone_number" text COLLATE "pg_catalog"."default",
  "age" int4,
  "refresh_token" text COLLATE "pg_catalog"."default",
  "avatar" text COLLATE "pg_catalog"."default",
  "is_active" bool DEFAULT false,
  "is_verified" bool DEFAULT false,
  "is_banned" bool DEFAULT false,
  "created_at" timestamp(3) DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(3) DEFAULT CURRENT_TIMESTAMP,
  "credits" numeric(10,2) DEFAULT 0,
  "follower_count" int4 NOT NULL DEFAULT 0,
  "following_count" int4 NOT NULL DEFAULT 0,
  "post_count" int4 NOT NULL DEFAULT 0,
  "display_name" text COLLATE "pg_catalog"."default",
  "bio" varchar(1000) COLLATE "pg_catalog"."default",
  "cover_image" text COLLATE "pg_catalog"."default",
  "userAdditionalInfoId" text COLLATE "pg_catalog"."default",
  "friend_count" int4 NOT NULL DEFAULT 0,
  "gender" "public"."UserGender",
  "show_online_status" bool DEFAULT true
)
;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO "public"."users" VALUES ('9df351a4-a867-460f-9453-7105223b9e80', 'hgphienn', 'hgphien@gmail.com', 'Phạm Trần Hồng PHiên', '$2a$10$VPmWSIXXHURJsQVUjTG5BO2XKGDeserf463Lq4Bw0tPXjFYanHzLe', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiJjMjI2MTMzNC03MThlLTRkMmItOThjNi0wMDhmZjU4YjQ0NjUiLCJ1c2VySWQiOiI5ZGYzNTFhNC1hODY3LTQ2MGYtOTQ1My03MTA1MjIzYjllODAiLCJ1c2VybmFtZSI6ImhncGhpZW5uIiwia2V5IjoiNjBhYzdkYzItMmUyMS00MTM2LWJhNDItYmIyY2I5N2UxZTJlIiwiaWF0IjoxNzMyMjY5MDk0LCJleHAiOjE3MzQ4NjEwOTR9.jSn-oaWPHzeqWjw2lAq1c58z42ZlNLzt5KpSOIvAwRw', NULL, 'f', 'f', 'f', '2024-11-22 09:51:32.629', '2025-06-10 10:31:04.281', 0.00, 0, 0, 0, NULL, '', NULL, '0e353df0-b3b8-446b-92ce-c77c17222feb', 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('65904792-fdd5-45e3-a892-830a4640fd9b', 'yenvydethuong28062', 'ogyminecraft497+3@gmail.com', 'Nguyen Ngoc Tram ANh', '', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTkwNDc5Mi1mZGQ1LTQ1ZTMtYTg5Mi04MzBhNDY0MGZkOWIiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2MiIsImtleSI6IjdiMzhjZDliLTRiZTItNGZjMi1hYWZhLWM5NjE2OTMwYjNmNSIsImlhdCI6MTc0MjQ2MTU5OSwiZXhwIjoxNzQ1MDUzNTk5fQ.w2usJK6rWKt8X5_xtONOG0NeY0Catc7Rsjg3PDMsJW8', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1742454687239_1742454692630_image', 'f', 'f', 'f', '2024-11-25 04:25:10.321', '2025-06-26 08:15:55.393', 0.00, 0, 1, 0, 'nguyen ngoc tram anh', '', NULL, 'd0b2a90d-01d1-4bea-b67c-67eff0597f5e', 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('caa2265d-5196-4a67-831e-85f91866fb8b', 'kanjame', 'kanjame@gmail.com', 'Kan Jame', '$2a$10$hmzfMs28YHK46KQ8jcN4guxrObSsBL6hUSVsn/nwppUNIIe5DonuW', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, 0, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiI2ZjYwOTkzOS1jM2RlLTQ3M2ItYjcyMy00ZTQ2YWExNjE2ZWIiLCJ1c2VySWQiOiJjYWEyMjY1ZC01MTk2LTRhNjctODMxZS04NWY5MTg2NmZiOGIiLCJ1c2VybmFtZSI6ImthbmphbWUiLCJrZXkiOiJlN2UyMDkwNS0wNzJlLTRjNTItYjlkZS01NTYxYzEyYWQ2MzIiLCJpYXQiOjE3MzE0OTY0ODgsImV4cCI6MTczNDA4ODQ4OH0.EDsz6V5ET6JWif5-V1QtocnaPtRxD3s1y4obp6MCFoA', NULL, 'f', 'f', 'f', '2024-11-13 11:14:48.721', '2025-02-28 09:05:29.179', 0.00, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('084b617e-c89c-44ff-8dc9-7c1aa4f7730e', 'yenvydethuong28063', 'ogyminecraft497+4@gmail.com', 'pham thi yen vy', '$2a$10$2pTODRB0PCD9wvkTeGn68.1U5arkkBavuLlExIbLg0hzg05..0Wkq', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIwODRiNjE3ZS1jODljLTQ0ZmYtOGRjOS03YzFhYTRmNzczMGUiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2MyIsImtleSI6ImViNzc1OTZkLWQ3MzAtNDhjNS04ZmI1LWMyYjU3NWQyODJmYSIsImlhdCI6MTczNjMwOTc5OCwiZXhwIjoxNzM4OTAxNzk4fQ.Nfeiwh6UEPlnyjd2kyOp-wwabURjTgUphRdROLVhOs0', NULL, 'f', 'f', 't', '2024-11-29 02:56:03.329', '2025-06-26 08:16:17.471', 0.00, 0, 1, 0, NULL, NULL, NULL, NULL, 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('64d76b9c-cbe0-410f-b1fd-853cca983aa5', 'tay52636', 'tay0505@gmail.com', 'Tây Tệ', '$2a$10$7r1VlDib4iT5lUlw2sSqOeAV7UuodpCAPNH9mIFY3uDD3tH/dLNZy', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, 22, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NGQ3NmI5Yy1jYmUwLTQxMGYtYjFmZC04NTNjY2E5ODNhYTUiLCJ1c2VybmFtZSI6InRheTUyNjM2Iiwia2V5IjoiNTFiNTVhMTMtMDkwYS00MjViLWI1MzAtOWNkMTNjZjUzNzRjIiwiaWF0IjoxNzQ2NTA2NzkwLCJleHAiOjE3NDkwOTg3OTB9.h_Nbm3NH1ndipGBWsYZzDqwcg2Yk2wmhhN5RZu9b5Ag', NULL, 'f', 'f', 't', '2025-04-05 11:20:32.399', '2025-06-26 08:16:17.471', 0.00, 0, 0, 0, 'tay dep trai', '<p>anh em thì vẫn thua trái banh thôi</p>', NULL, '101ae694-b615-426a-a2f0-ce9801f569f9', 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('898c5eed-1650-4a27-9ae1-45fec186d37e', 'propro2421', 'user131@example.com', 'tx123', '$2a$10$bF3p05GcdHW2j3Z187rF2O74NOsK.WA14doFxpz2HheiUlckVuAAq', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI4OThjNWVlZC0xNjUwLTRhMjctOWFlMS00NWZlYzE4NmQzN2UiLCJ1c2VybmFtZSI6InByb3BybzI0MjEiLCJrZXkiOiI5NjdkYTExMy03Zjg2LTQ3M2UtYmRhMC1mYmI4NTM0Y2FlZmMiLCJpYXQiOjE3NTAzMTYyMjgsImV4cCI6MTc1MjkwODIyOH0.W1RnU9eEZiMNvE2JiYY8bi0wrmCaBvFo_OXl9zma5BY', NULL, 'f', 'f', 't', '2025-06-19 06:57:07.945', '2025-06-26 08:16:17.471', 0.00, 0, 1, 0, 'devpro', NULL, NULL, '62692e7b-7b44-4c8c-95c9-e8b0be483359', 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('49d9e3c0-ec00-48f0-86d3-293549c246dd', 'yenvydethuong2806', 'ogyminecraft497+1@gmail.com', 'Nana Haru', '$2a$10$7TYIFS8ZqDbn/.z6o9A2HuNY5G.6HxnM8.iEyKs3zsDkr4d6rsSyy', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0OWQ5ZTNjMC1lYzAwLTQ4ZjAtODZkMy0yOTM1NDljMjQ2ZGQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2Iiwia2V5IjoiOTdkYjFmNjktZDA2OS00ZTI0LTkwYzktM2M2NzgyYTBlMmI5IiwiaWF0IjoxNzQzNDk2MTcyLCJleHAiOjE3NDYwODgxNzJ9.Qlc0bHoziTuRlSjYLGt8jAtwEZHT4jJHZECtr84kprs', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1742306320612_1742306324337_image', 't', 'f', 'f', '2024-11-23 04:19:05.711', '2026-06-06 13:55:01.552', 2.60, 2, 2, 1, 'Pham Thi Yen Vy', '', NULL, '764a4de1-6d8d-4ce3-8afd-89085bbc500c', 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('ba1b25ea-053b-4100-a4ad-a92959914eeb', 'lucan3', 'icaluca12+2@gmail.com', 'Kan Jame', '$2a$10$VaehRb39lzZab1orwAEUQ.W3xBEIsXJ3WzqRELlUwUnEZ2535OHAK', '7c2f4d9a-b10a-4746-9e5b-f9551660bd4c', NULL, 0, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiYTFiMjVlYS0wNTNiLTQxMDAtYTRhZC1hOTI5NTk5MTRlZWIiLCJ1c2VybmFtZSI6Imx1Y2FuMyIsImtleSI6IjcxMmExZjlkLTExMWYtNGU0ZS04ZjUwLTgxYTFkYjVmZGJiYiIsImlhdCI6MTc4MDc3NzA3MCwiZXhwIjoxNzgzMzY5MDcwfQ.RnNe23uQSlfkPEOGQhQB-dEzwWaHltxcxnlMmFXxPtU', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1747378125328_00009-4100874166-caadc88c06a642459ee4c3899e155f36.png', 'f', 'f', 'f', '2024-12-06 15:33:49.042', '2026-06-06 20:17:50.142', 1.00, 0, 0, 0, NULL, '', NULL, 'e7e2e7e4-ae5d-4be0-a9f6-1a2ebbd291bf', 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('02ad241e-66a7-4e44-99fd-36fced0ca386', 'devYuki2005', 'ogyminecraft497@gmail.com', 'Dang Hoang Thien An', '$2a$10$62LOlFv9qXvDELSVa4CIZOFZOV1Qtk/HBchmMuWNNo0j7ypOy6rzm', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIwMmFkMjQxZS02NmE3LTRlNDQtOTlmZC0zNmZjZWQwY2EzODYiLCJ1c2VybmFtZSI6ImRldll1a2kyMDA1Iiwia2V5IjoiNzUyZjFlMWUtNzdjZS00M2E2LThmYWYtY2Q2ZmZiNTZjMWRhIiwiaWF0IjoxNzgwODM5MjIyLCJleHAiOjE3ODM0MzEyMjJ9.pbg142y_0YAccDUlgMyRBkDrRUGn9mwnCOAcVu9oFSM', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780839260620_1780839259848_image.webp', 't', 'f', 'f', '2024-11-05 13:25:27.937', '2026-06-09 06:35:52.037', 0.00, 1, 0, 0, NULL, '<p>💕Phạm Thị Yến Vyyyy💕</p>', NULL, '20458e81-ed65-4c03-8812-668167e0278a', 1, NULL, 't');
INSERT INTO "public"."users" VALUES ('6a31a93a-a961-48d6-963e-0645f99de8e4', 'lucan2', 'icaluca12+lucan2@gmail.com', 'Luca N', '$2b$10$E399bydm4h2sAFu2Q4zCBuU8azipGf2KDjLf.Id9VcxGf28Rnq2bS', '588b1a65-426a-468c-9365-dc1c9b851a79', '0909090909', 23, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6IjhlZTc2ODYzLWRiMDUtNDc5MS1iM2QzLWQ5OTk5Nzc2MWIzMCIsImlhdCI6MTc4MzE1NTk5MiwiZXhwIjoxNzg1NzQ3OTkyfQ.Vd_4o29viLrKpbt9lzMqQ8PvdqsYlvul2CB6VS6CS88', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751217042134_1751217042282_image', 't', 'f', 'f', '2024-11-06 09:49:03.576', '2026-07-04 09:12:35.981', 477.60, 1, 1, 5, NULL, NULL, 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1744788362245_00002-1468083896.png', '5d4f885d-8a9e-4120-a343-a356f9872393', 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('b6dcff8d-c61b-4346-a60d-682da15baef9', 'nodejs2', 'nodejs.ica1+n1@gmail.com', 'Kiím MS', '$2a$10$oYXRKwdXLyU/MHXYI5fxlOJcQRiCpd5FML1aTGIJIrhkCcvw/h9lW', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, 22, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiNmRjZmY4ZC1jNjFiLTQzNDYtYTYwZC02ODJkYTE1YmFlZjkiLCJ1c2VybmFtZSI6Im5vZGVqczIiLCJrZXkiOiI0NmM2M2QwMC04YTg4LTQwODUtOTMyNS05MGFlM2ZkNjhmMTIiLCJpYXQiOjE3NDE3OTYyNjQsImV4cCI6MTc0NDM4ODI2NH0.Ji9PXM1C_XEK0_tLMD1CFPg56TonaaMJc3UPMold9oU', NULL, 'f', 'f', 'f', '2025-03-12 16:16:35.462', '2025-06-26 08:15:55.393', 0.00, 0, 0, 0, 'Kiím MS', '<p></p>', NULL, '61ccaa46-79b6-4d92-911c-8cc8007ac4ac', 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('1ea6fe50-6ebb-43cc-acd1-e3b094e36238', 'nodejs1', 'nodejs.ica1@gmail.com', 'Kiím MS', '$2a$10$u5numZ8XSsmd1Z9jCse7VOrn/xvET3Rp24ZsZApD3Ys2nIy3.Ze7.', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxZWE2ZmU1MC02ZWJiLTQzY2MtYWNkMS1lM2IwOTRlMzYyMzgiLCJ1c2VybmFtZSI6Im5vZGVqczEiLCJrZXkiOiJmYWFmMWMwNi02NzU5LTQ3NTgtOTg4Yy0zYjQyNTBlZTFiOTYiLCJpYXQiOjE3NDAyMDg4ODcsImV4cCI6MTc0MjgwMDg4N30.4ZuZCSaRZgIk5urUo_f26oY2alh6_fOX93-rHQC_XZk', NULL, 'f', 'f', 'f', '2025-02-22 07:21:27.074', '2025-06-26 08:15:55.393', 0.00, 0, 0, 0, 'Kiím MS', NULL, NULL, NULL, 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('37739086-9b6f-42ac-96ce-1cc81a56dd6d', 'yenvydethuong2806+2', 'ogyminecraft497+2@gmail.com', 'pham thi yen vy', '$2a$10$d8LtvWWPNC5Yi7u9Iscl2urGTH0VV18QZ4e.S0sBXpU01ziKZ.Byy', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 0, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiJmYTQ5YmFiZS02NzZlLTQyMDQtODgyZC0xODcxZDYyNGM5MWEiLCJ1c2VySWQiOiIzNzczOTA4Ni05YjZmLTQyYWMtOTZjZS0xY2M4MWE1NmRkNmQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2KzIiLCJrZXkiOiIxNDlkZTQ5Ny0yNGUzLTRjNWItYWIxMC1mMTMxYTA2MDk2MDgiLCJpYXQiOjE3MzIzMzYwMTQsImV4cCI6MTczNDkyODAxNH0.z_8lobLg-kMlNPYb2JgsZfiaqTzFAE-1-XhAA4XzchA', NULL, 'f', 'f', 't', '2024-11-23 04:26:53.327', '2025-06-26 08:16:17.471', 0.00, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('4efe35df-757f-4ee4-b5bd-7aa7349ce5c8', 'haosinguoiao', 'minhnghi22@riotgame.com', 'Trần Nguyễn MInh Nghi', '$2a$10$4ceaGS8S/TXITJGrNoD/R.3yO2dJ2R7mIOFaqeupV6ULBkwARQcHi', 'e741110a-432d-4c02-acf4-4ba4428f37b7', NULL, 0, NULL, NULL, 't', 't', 't', '2025-06-28 06:59:41.946', '2025-07-02 08:38:43.841', 0.00, 0, 0, 0, 'minhnghineeee', '<p>toi ghet lien minh</p>', NULL, '176dd3e1-77e9-4fa3-b1ac-7e109316aba1', 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('95cf9878-6d9f-469a-a07d-331453dce25c', 'ThoBiGay', 'tientho2004@gmail.com', 'Nguyễn Tiến Thọ', '$2a$10$9mt.FpWLK7NPMh3id5tXH.n/7wbfQtm8Isggq9vHagYFH4vHIL3FO', 'e741110a-432d-4c02-acf4-4ba4428f37b7', NULL, 0, NULL, NULL, 't', 'f', 'f', '2025-06-27 09:05:06.97', '2025-07-12 06:41:29.662', 999.00, 0, 0, 0, 'ThoGyGo', '<p>lòng tôi đâu đớn khi nhân ra <br><strong class="font-bold">TÔI LÀ GAY</strong></p>', NULL, 'e0d3535e-7eec-4fcc-92ba-0a615b52c413', 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('46d96705-4f8d-475d-8527-995ff185ca89', 'testuser1', 'testuser1@gmail.com', 'Luca Test', '$2a$10$q8KxJieBlWeOPkQhcNKtGuWfqJ/V.tqRp55RKTEdLn8PFxO9c5Gum', '588b1a65-426a-468c-9365-dc1c9b851a79', '0909090909', 22, NULL, NULL, 't', 'f', 'f', '2025-06-25 17:31:19.638', '2026-06-06 13:54:34.47', 1.00, 0, 0, 0, 'testuser1', 'aaa', NULL, 'e54984d0-4546-40e3-ac23-0bdecd016642', 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('2b707d22-77db-4861-b148-ff41a49f1ea9', 'lucan5', 'lucan5@gmail.com', 'Luca Nguyen', '$2a$10$UJTk3/Iu47EFJ9q97y7oouL84YcV33m3bYbSn/9PNxg8tBbcuv5va', '0c2d5733-69d0-4268-8a60-b39997f656b6', NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIyYjcwN2QyMi03N2RiLTQ4NjEtYjE0OC1mZjQxYTQ5ZjFlYTkiLCJ1c2VybmFtZSI6Imx1Y2FuNSIsImtleSI6ImNlOTkwNzE3LTZhNDAtNDg0NC1hNjNkLTgxMjY5ZDFmYjE4OSIsImlhdCI6MTc4MDc3ODQyOSwiZXhwIjoxNzgzMzcwNDI5fQ.3v6IchtriBshgj-615L5SacA3MhVKUGOVwHK6jKG38o', NULL, 'f', 'f', 'f', '2026-06-06 20:40:28.049', '2026-06-06 20:40:29.37', 0.00, 0, 0, 0, 'Luca', NULL, NULL, 'e972ad20-69a3-42bd-a4e2-e6bcf77bed85', 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('9e0c791c-c424-43fa-9c48-d73b11796ec9', 'yukicute123', 'ogyminecraft497+yummi@gmail.com', 'Dang Yuki', '$2a$10$auxtCL7wLyhFDP1ob4RxxO1F72w93pWGEt9WHnXZT.XscZmuxUr36', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 21, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiZGExNGM1NDAtMmY5ZC00NjY1LTlmNDgtOGM3NzI0Yjk1NmQyIiwiaWF0IjoxNzgwOTk1NzUzLCJleHAiOjE3ODM1ODc3NTN9.PKqRAxcrN-bKwC0AGCGXu4DvpIvJEyDIcTPI2J9y2bo', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780841425587_1780841425359_image.webp', 't', 't', 'f', '2024-12-17 14:43:31.915', '2026-06-09 09:02:33.004', 5615.80, 4, 3, 14, 'devYuki', '<p><strong class="font-bold"><em class="font-italic">SMO Team</em></strong><br>❤️LucaN/LeoN❤️</p><p>🔥 Web Developer<br>🌸YouTube Premium, Adobe, Vercel Pro, Mega,...</p>', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1750777185209_504193226_716185870920601_1900189960928916806_n.jpg', '82ea8d96-c699-462e-8dfd-1790da054be4', 1, NULL, 't');
INSERT INTO "public"."users" VALUES ('9b00b60c-005d-4ad2-832b-d2d0abcd5fc8', 'lucan4', 'lucan4@gmail.com', 'Luca Nguyen', '$2a$10$4GVuk3Ojx7oOdyO5sJavf.l1Vki0XkoTqa4TjoGY.JJodwnpTqIhq', '0c2d5733-69d0-4268-8a60-b39997f656b6', NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5YjAwYjYwYy0wMDVkLTRhZDItODMyYi1kMmQwYWJjZDVmYzgiLCJ1c2VybmFtZSI6Imx1Y2FuNCIsImtleSI6IjczNGFlNWQwLTYyNjMtNDc0NC1iNDYyLWM5ZTIwMjk1MDgwNSIsImlhdCI6MTc4MDkyOTM4MiwiZXhwIjoxNzgzNTIxMzgyfQ.kGwqd155KM13I2m1z3U36u9cZBuPT5Hy5TO424CsJ1M', NULL, 'f', 'f', 'f', '2026-06-06 20:26:58.341', '2026-06-08 14:36:22.022', 0.00, 0, 0, 0, 'Luca', NULL, NULL, '33f69a03-6508-4a34-9b78-2ff667445e99', 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('c260b4cf-e769-4656-9073-f595b748a69b', 'nhicute123', 'ogyminecraft497+55555@gmail.com', 'nguyen ngoc uyen  nhi', '$2a$10$YwFVh.qh1osPacosNEpZ/uPiTHtg0qfR6GQOBX04oEKxP6FTTrN4O', '0c2d5733-69d0-4268-8a60-b39997f656b6', NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJjMjYwYjRjZi1lNzY5LTQ2NTYtOTA3My1mNTk1Yjc0OGE2OWIiLCJ1c2VybmFtZSI6Im5oaWN1dGUxMjMiLCJrZXkiOiIxNmQ0NjRiMi0yMGEyLTRiMTYtYmEyYi01YWVhNGJmMWUyNGQiLCJpYXQiOjE3ODA4NDA1OTksImV4cCI6MTc4MzQzMjU5OX0.Y6eyquKcxbYeEXUT4q6L8as1z5thGNgwER4cXmClPM0', NULL, 'f', 'f', 'f', '2026-06-07 13:56:38.329', '2026-06-07 13:56:39.669', 0.00, 0, 0, 0, 'cute dua', NULL, NULL, '28742952-6db2-4647-8b98-6d60da76c3c6', 0, NULL, 't');
INSERT INTO "public"."users" VALUES ('d66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'lucan1', 'lucan1@gmail.com', 'Luca Nguyen', '$2a$10$nHZoRuHdJ.aS1GLAZSG3oOKxJg9ymwpP9ephqPS9zByCD097adtra', '7c2f4d9a-b10a-4746-9e5b-f9551660bd4c', '0123456789', 27, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjY0NmE4YTkwLTI0ZjMtNDFjYi04YjM3LTk5OWJiNGM5NGQ2MyIsImlhdCI6MTc4MTY0MjY4NCwiZXhwIjoxNzg0MjM0Njg0fQ.z9ozd_4rK9nPG81tsM4kjthY6CIkqOtNgaqtt6m8m_U', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753246235_1780753245697_image.webp', 't', 't', 'f', '2024-11-04 18:19:27.651', '2026-07-27 14:33:15.509', 2941.00, 3, 2, 6, '', '<p><strong class="font-bold">I am who Iam</strong></p>', 'https://link.storjshare.io/raw/ju6qfjjzlrv43hostrz2apaxbqha/smospace/uploads/public/2026/1780753264495_smo_baclground.gif.webp', 'a3ce227d-9052-4f0d-97a9-18995ac26980', 2, NULL, 'f');
INSERT INTO "public"."users" VALUES ('19315748-376c-4aab-9307-936d740fbfec', 'taynguyen52636', 'taynguyen@gmail.com', 'tay', '$2a$10$jZXH9nZfyQ3wffp9KsWke.js21OsrusdKsoZoYsTekWtJsmTR2vSa', '0c2d5733-69d0-4268-8a60-b39997f656b6', NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxOTMxNTc0OC0zNzZjLTRhYWItOTMwNy05MzZkNzQwZmJmZWMiLCJ1c2VybmFtZSI6InRheW5ndXllbjUyNjM2Iiwia2V5IjoiY2M4NTgwM2ItMzZiZC00NjM3LWE4NDItZWE4ZTE3NmM5MmYwIiwiaWF0IjoxNzg1MTQ1Mzk1LCJleHAiOjE3ODc3MzczOTV9.QwW4_A-lrFw9AQNK9Wd0vkqWZmQSe_OTKmfnCAYlyu4', NULL, 'f', 'f', 'f', '2026-07-27 09:43:14.373', '2026-07-27 14:33:15.509', 0.20, 0, 1, 1, 'nguyen', NULL, NULL, 'cba21d2d-53e0-49f8-a620-db6938610d60', 0, NULL, 't');

-- ----------------------------
-- Table structure for verification_codes
-- ----------------------------
DROP TABLE IF EXISTS "public"."verification_codes";
CREATE TABLE "public"."verification_codes" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "code" text COLLATE "pg_catalog"."default" NOT NULL,
  "isActive" bool NOT NULL DEFAULT false,
  "expires_at" timestamp(3) NOT NULL,
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "type" "public"."VerificationType" NOT NULL
)
;

-- ----------------------------
-- Records of verification_codes
-- ----------------------------
INSERT INTO "public"."verification_codes" VALUES ('a384331d-8429-4961-bafc-08e19fd9f201', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', '5A8B59', 'f', '2025-04-04 10:30:17.657', '2025-04-04 10:20:17.657', 'ACTIVE_ACCOUNT');
INSERT INTO "public"."verification_codes" VALUES ('c52cabae-d8c9-4168-9981-57faa0b0d7f2', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'E98847', 'f', '2025-04-18 07:21:52.332', '2025-04-18 07:11:52.332', 'FORGOT_PASSWORD');
INSERT INTO "public"."verification_codes" VALUES ('b2923e28-b561-4631-acff-db5bf6b7e94f', '02ad241e-66a7-4e44-99fd-36fced0ca386', '357C36', 'f', '2025-08-01 15:35:26.458', '2025-08-01 15:25:26.458', 'FORGOT_PASSWORD');
INSERT INTO "public"."verification_codes" VALUES ('593a8133-e6b1-434c-a5d2-bbbca022e03a', '19315748-376c-4aab-9307-936d740fbfec', '494889', 'f', '2026-07-27 09:57:32.709', '2026-07-27 09:47:32.709', 'ACTIVE_ACCOUNT');

-- ----------------------------
-- Function structure for pg_stat_kcache
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pg_stat_kcache"(OUT "queryid" int8, OUT "top" bool, OUT "userid" oid, OUT "dbid" oid, OUT "plan_reads" int8, OUT "plan_writes" int8, OUT "plan_user_time" float8, OUT "plan_system_time" float8, OUT "plan_minflts" int8, OUT "plan_majflts" int8, OUT "plan_nswaps" int8, OUT "plan_msgsnds" int8, OUT "plan_msgrcvs" int8, OUT "plan_nsignals" int8, OUT "plan_nvcsws" int8, OUT "plan_nivcsws" int8, OUT "exec_reads" int8, OUT "exec_writes" int8, OUT "exec_user_time" float8, OUT "exec_system_time" float8, OUT "exec_minflts" int8, OUT "exec_majflts" int8, OUT "exec_nswaps" int8, OUT "exec_msgsnds" int8, OUT "exec_msgrcvs" int8, OUT "exec_nsignals" int8, OUT "exec_nvcsws" int8, OUT "exec_nivcsws" int8, OUT "stats_since" timestamptz);
CREATE OR REPLACE FUNCTION "public"."pg_stat_kcache"(OUT "queryid" int8, OUT "top" bool, OUT "userid" oid, OUT "dbid" oid, OUT "plan_reads" int8, OUT "plan_writes" int8, OUT "plan_user_time" float8, OUT "plan_system_time" float8, OUT "plan_minflts" int8, OUT "plan_majflts" int8, OUT "plan_nswaps" int8, OUT "plan_msgsnds" int8, OUT "plan_msgrcvs" int8, OUT "plan_nsignals" int8, OUT "plan_nvcsws" int8, OUT "plan_nivcsws" int8, OUT "exec_reads" int8, OUT "exec_writes" int8, OUT "exec_user_time" float8, OUT "exec_system_time" float8, OUT "exec_minflts" int8, OUT "exec_majflts" int8, OUT "exec_nswaps" int8, OUT "exec_msgsnds" int8, OUT "exec_msgrcvs" int8, OUT "exec_nsignals" int8, OUT "exec_nvcsws" int8, OUT "exec_nivcsws" int8, OUT "stats_since" timestamptz)
  RETURNS SETOF "pg_catalog"."record" AS '$libdir/pg_stat_kcache', 'pg_stat_kcache_2_3'
  LANGUAGE c VOLATILE
  COST 1000
  ROWS 1000;

-- ----------------------------
-- Function structure for pg_stat_kcache_reset
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pg_stat_kcache_reset"();
CREATE OR REPLACE FUNCTION "public"."pg_stat_kcache_reset"()
  RETURNS "pg_catalog"."void" AS '$libdir/pg_stat_kcache', 'pg_stat_kcache_reset'
  LANGUAGE c VOLATILE
  COST 1000;

-- ----------------------------
-- Function structure for pg_stat_statements
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pg_stat_statements"("showtext" bool, OUT "userid" oid, OUT "dbid" oid, OUT "toplevel" bool, OUT "queryid" int8, OUT "query" text, OUT "plans" int8, OUT "total_plan_time" float8, OUT "min_plan_time" float8, OUT "max_plan_time" float8, OUT "mean_plan_time" float8, OUT "stddev_plan_time" float8, OUT "calls" int8, OUT "total_exec_time" float8, OUT "min_exec_time" float8, OUT "max_exec_time" float8, OUT "mean_exec_time" float8, OUT "stddev_exec_time" float8, OUT "rows" int8, OUT "shared_blks_hit" int8, OUT "shared_blks_read" int8, OUT "shared_blks_dirtied" int8, OUT "shared_blks_written" int8, OUT "local_blks_hit" int8, OUT "local_blks_read" int8, OUT "local_blks_dirtied" int8, OUT "local_blks_written" int8, OUT "temp_blks_read" int8, OUT "temp_blks_written" int8, OUT "shared_blk_read_time" float8, OUT "shared_blk_write_time" float8, OUT "local_blk_read_time" float8, OUT "local_blk_write_time" float8, OUT "temp_blk_read_time" float8, OUT "temp_blk_write_time" float8, OUT "wal_records" int8, OUT "wal_fpi" int8, OUT "wal_bytes" numeric, OUT "wal_buffers_full" int8, OUT "jit_functions" int8, OUT "jit_generation_time" float8, OUT "jit_inlining_count" int8, OUT "jit_inlining_time" float8, OUT "jit_optimization_count" int8, OUT "jit_optimization_time" float8, OUT "jit_emission_count" int8, OUT "jit_emission_time" float8, OUT "jit_deform_count" int8, OUT "jit_deform_time" float8, OUT "parallel_workers_to_launch" int8, OUT "parallel_workers_launched" int8, OUT "stats_since" timestamptz, OUT "minmax_stats_since" timestamptz);
CREATE OR REPLACE FUNCTION "public"."pg_stat_statements"(IN "showtext" bool, OUT "userid" oid, OUT "dbid" oid, OUT "toplevel" bool, OUT "queryid" int8, OUT "query" text, OUT "plans" int8, OUT "total_plan_time" float8, OUT "min_plan_time" float8, OUT "max_plan_time" float8, OUT "mean_plan_time" float8, OUT "stddev_plan_time" float8, OUT "calls" int8, OUT "total_exec_time" float8, OUT "min_exec_time" float8, OUT "max_exec_time" float8, OUT "mean_exec_time" float8, OUT "stddev_exec_time" float8, OUT "rows" int8, OUT "shared_blks_hit" int8, OUT "shared_blks_read" int8, OUT "shared_blks_dirtied" int8, OUT "shared_blks_written" int8, OUT "local_blks_hit" int8, OUT "local_blks_read" int8, OUT "local_blks_dirtied" int8, OUT "local_blks_written" int8, OUT "temp_blks_read" int8, OUT "temp_blks_written" int8, OUT "shared_blk_read_time" float8, OUT "shared_blk_write_time" float8, OUT "local_blk_read_time" float8, OUT "local_blk_write_time" float8, OUT "temp_blk_read_time" float8, OUT "temp_blk_write_time" float8, OUT "wal_records" int8, OUT "wal_fpi" int8, OUT "wal_bytes" numeric, OUT "wal_buffers_full" int8, OUT "jit_functions" int8, OUT "jit_generation_time" float8, OUT "jit_inlining_count" int8, OUT "jit_inlining_time" float8, OUT "jit_optimization_count" int8, OUT "jit_optimization_time" float8, OUT "jit_emission_count" int8, OUT "jit_emission_time" float8, OUT "jit_deform_count" int8, OUT "jit_deform_time" float8, OUT "parallel_workers_to_launch" int8, OUT "parallel_workers_launched" int8, OUT "stats_since" timestamptz, OUT "minmax_stats_since" timestamptz)
  RETURNS SETOF "pg_catalog"."record" AS '$libdir/pg_stat_statements', 'pg_stat_statements_1_12'
  LANGUAGE c VOLATILE STRICT
  COST 1
  ROWS 1000;

-- ----------------------------
-- Function structure for pg_stat_statements_info
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pg_stat_statements_info"(OUT "dealloc" int8, OUT "stats_reset" timestamptz);
CREATE OR REPLACE FUNCTION "public"."pg_stat_statements_info"(OUT "dealloc" int8, OUT "stats_reset" timestamptz)
  RETURNS "pg_catalog"."record" AS '$libdir/pg_stat_statements', 'pg_stat_statements_info'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pg_stat_statements_reset
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pg_stat_statements_reset"("userid" oid, "dbid" oid, "queryid" int8, "minmax_only" bool);
CREATE OR REPLACE FUNCTION "public"."pg_stat_statements_reset"("userid" oid=0, "dbid" oid=0, "queryid" int8=0, "minmax_only" bool=false)
  RETURNS "pg_catalog"."timestamptz" AS '$libdir/pg_stat_statements', 'pg_stat_statements_reset_1_11'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- View structure for pg_stat_kcache_detail
-- ----------------------------
DROP VIEW IF EXISTS "public"."pg_stat_kcache_detail";
CREATE VIEW "public"."pg_stat_kcache_detail" AS  SELECT s.query,
    k.top,
    d.datname,
    r.rolname,
    k.plan_user_time,
    k.plan_system_time,
    k.plan_minflts,
    k.plan_majflts,
    k.plan_nswaps,
    k.plan_reads,
    k.plan_reads / current_setting('block_size'::text)::integer AS plan_reads_blks,
    k.plan_writes,
    k.plan_writes / current_setting('block_size'::text)::integer AS plan_writes_blks,
    k.plan_msgsnds,
    k.plan_msgrcvs,
    k.plan_nsignals,
    k.plan_nvcsws,
    k.plan_nivcsws,
    k.exec_user_time,
    k.exec_system_time,
    k.exec_minflts,
    k.exec_majflts,
    k.exec_nswaps,
    k.exec_reads,
    k.exec_reads / current_setting('block_size'::text)::integer AS exec_reads_blks,
    k.exec_writes,
    k.exec_writes / current_setting('block_size'::text)::integer AS exec_writes_blks,
    k.exec_msgsnds,
    k.exec_msgrcvs,
    k.exec_nsignals,
    k.exec_nvcsws,
    k.exec_nivcsws,
    k.stats_since
   FROM pg_stat_kcache() k(queryid, top, userid, dbid, plan_reads, plan_writes, plan_user_time, plan_system_time, plan_minflts, plan_majflts, plan_nswaps, plan_msgsnds, plan_msgrcvs, plan_nsignals, plan_nvcsws, plan_nivcsws, exec_reads, exec_writes, exec_user_time, exec_system_time, exec_minflts, exec_majflts, exec_nswaps, exec_msgsnds, exec_msgrcvs, exec_nsignals, exec_nvcsws, exec_nivcsws, stats_since)
     JOIN pg_stat_statements s ON k.queryid = s.queryid AND k.dbid = s.dbid AND k.userid = s.userid
     JOIN pg_database d ON d.oid = s.dbid
     JOIN pg_roles r ON r.oid = s.userid;

-- ----------------------------
-- View structure for pg_stat_kcache
-- ----------------------------
DROP VIEW IF EXISTS "public"."pg_stat_kcache";
CREATE VIEW "public"."pg_stat_kcache" AS  SELECT datname,
    sum(plan_user_time) AS plan_user_time,
    sum(plan_system_time) AS plan_system_time,
    sum(plan_minflts) AS plan_minflts,
    sum(plan_majflts) AS plan_majflts,
    sum(plan_nswaps) AS plan_nswaps,
    sum(plan_reads) AS plan_reads,
    sum(plan_reads_blks) AS plan_reads_blks,
    sum(plan_writes) AS plan_writes,
    sum(plan_writes_blks) AS plan_writes_blks,
    sum(plan_msgsnds) AS plan_msgsnds,
    sum(plan_msgrcvs) AS plan_msgrcvs,
    sum(plan_nsignals) AS plan_nsignals,
    sum(plan_nvcsws) AS plan_nvcsws,
    sum(plan_nivcsws) AS plan_nivcsws,
    sum(exec_user_time) AS exec_user_time,
    sum(exec_system_time) AS exec_system_time,
    sum(exec_minflts) AS exec_minflts,
    sum(exec_majflts) AS exec_majflts,
    sum(exec_nswaps) AS exec_nswaps,
    sum(exec_reads) AS exec_reads,
    sum(exec_reads_blks) AS exec_reads_blks,
    sum(exec_writes) AS exec_writes,
    sum(exec_writes_blks) AS exec_writes_blks,
    sum(exec_msgsnds) AS exec_msgsnds,
    sum(exec_msgrcvs) AS exec_msgrcvs,
    sum(exec_nsignals) AS exec_nsignals,
    sum(exec_nvcsws) AS exec_nvcsws,
    sum(exec_nivcsws) AS exec_nivcsws,
    min(stats_since) AS stats_since
   FROM pg_stat_kcache_detail
  WHERE top IS TRUE
  GROUP BY datname;

-- ----------------------------
-- View structure for pg_stat_statements_info
-- ----------------------------
DROP VIEW IF EXISTS "public"."pg_stat_statements_info";
CREATE VIEW "public"."pg_stat_statements_info" AS  SELECT dealloc,
    stats_reset
   FROM pg_stat_statements_info() pg_stat_statements_info(dealloc, stats_reset);

-- ----------------------------
-- View structure for pg_stat_statements
-- ----------------------------
DROP VIEW IF EXISTS "public"."pg_stat_statements";
CREATE VIEW "public"."pg_stat_statements" AS  SELECT userid,
    dbid,
    toplevel,
    queryid,
    query,
    plans,
    total_plan_time,
    min_plan_time,
    max_plan_time,
    mean_plan_time,
    stddev_plan_time,
    calls,
    total_exec_time,
    min_exec_time,
    max_exec_time,
    mean_exec_time,
    stddev_exec_time,
    rows,
    shared_blks_hit,
    shared_blks_read,
    shared_blks_dirtied,
    shared_blks_written,
    local_blks_hit,
    local_blks_read,
    local_blks_dirtied,
    local_blks_written,
    temp_blks_read,
    temp_blks_written,
    shared_blk_read_time,
    shared_blk_write_time,
    local_blk_read_time,
    local_blk_write_time,
    temp_blk_read_time,
    temp_blk_write_time,
    wal_records,
    wal_fpi,
    wal_bytes,
    wal_buffers_full,
    jit_functions,
    jit_generation_time,
    jit_inlining_count,
    jit_inlining_time,
    jit_optimization_count,
    jit_optimization_time,
    jit_emission_count,
    jit_emission_time,
    jit_deform_count,
    jit_deform_time,
    parallel_workers_to_launch,
    parallel_workers_launched,
    stats_since,
    minmax_stats_since
   FROM pg_stat_statements(true) pg_stat_statements(userid, dbid, toplevel, queryid, query, plans, total_plan_time, min_plan_time, max_plan_time, mean_plan_time, stddev_plan_time, calls, total_exec_time, min_exec_time, max_exec_time, mean_exec_time, stddev_exec_time, rows, shared_blks_hit, shared_blks_read, shared_blks_dirtied, shared_blks_written, local_blks_hit, local_blks_read, local_blks_dirtied, local_blks_written, temp_blks_read, temp_blks_written, shared_blk_read_time, shared_blk_write_time, local_blk_read_time, local_blk_write_time, temp_blk_read_time, temp_blk_write_time, wal_records, wal_fpi, wal_bytes, wal_buffers_full, jit_functions, jit_generation_time, jit_inlining_count, jit_inlining_time, jit_optimization_count, jit_optimization_time, jit_emission_count, jit_emission_time, jit_deform_count, jit_deform_time, parallel_workers_to_launch, parallel_workers_launched, stats_since, minmax_stats_since);

-- ----------------------------
-- Primary Key structure for table auth_codes
-- ----------------------------
ALTER TABLE "public"."auth_codes" ADD CONSTRAINT "auth_codes_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table bookmarks
-- ----------------------------
CREATE INDEX "bookmarks_user_id_created_at_idx" ON "public"."bookmarks" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "created_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "bookmarks_user_id_post_id_key" ON "public"."bookmarks" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "post_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table bookmarks
-- ----------------------------
ALTER TABLE "public"."bookmarks" ADD CONSTRAINT "bookmarks_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table chat_message_reactions
-- ----------------------------
CREATE INDEX "chat_message_reactions_message_id_type_idx" ON "public"."chat_message_reactions" USING btree (
  "message_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "type" "pg_catalog"."enum_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "chat_message_reactions_user_id_message_id_key" ON "public"."chat_message_reactions" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "message_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table chat_message_reactions
-- ----------------------------
ALTER TABLE "public"."chat_message_reactions" ADD CONSTRAINT "chat_message_reactions_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table chat_messages
-- ----------------------------
CREATE INDEX "chat_messages_room_id_created_at_idx" ON "public"."chat_messages" USING btree (
  "room_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "created_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table chat_messages
-- ----------------------------
ALTER TABLE "public"."chat_messages" ADD CONSTRAINT "chat_messages_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table chat_participants
-- ----------------------------
CREATE UNIQUE INDEX "chat_participants_user_id_room_id_key" ON "public"."chat_participants" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "room_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table chat_participants
-- ----------------------------
ALTER TABLE "public"."chat_participants" ADD CONSTRAINT "chat_participants_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table chat_rooms
-- ----------------------------
CREATE UNIQUE INDEX "chat_rooms_last_message_id_key" ON "public"."chat_rooms" USING btree (
  "last_message_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table chat_rooms
-- ----------------------------
ALTER TABLE "public"."chat_rooms" ADD CONSTRAINT "chat_rooms_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table follows
-- ----------------------------
CREATE INDEX "follows_followerId_followingId_idx" ON "public"."follows" USING btree (
  "followerId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "followingId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "follows_followerId_followingId_key" ON "public"."follows" USING btree (
  "followerId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "followingId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table follows
-- ----------------------------
ALTER TABLE "public"."follows" ADD CONSTRAINT "follows_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table friends
-- ----------------------------
CREATE INDEX "friends_friend_id_status_is_requested_by_friend_idx" ON "public"."friends" USING btree (
  "friend_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "status" "pg_catalog"."enum_ops" ASC NULLS LAST,
  "is_requested_by_friend" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "friends_user_id_friend_id_key" ON "public"."friends" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "friend_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "friends_user_id_status_is_requested_by_me_idx" ON "public"."friends" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "status" "pg_catalog"."enum_ops" ASC NULLS LAST,
  "is_requested_by_me" "pg_catalog"."bool_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table friends
-- ----------------------------
ALTER TABLE "public"."friends" ADD CONSTRAINT "friends_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table media
-- ----------------------------
CREATE INDEX "media_post_id_idx" ON "public"."media" USING btree (
  "post_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "media_user_id_idx" ON "public"."media" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table media
-- ----------------------------
ALTER TABLE "public"."media" ADD CONSTRAINT "media_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table notification_types
-- ----------------------------
CREATE UNIQUE INDEX "notification_types_type_key" ON "public"."notification_types" USING btree (
  "type" "pg_catalog"."enum_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table notification_types
-- ----------------------------
ALTER TABLE "public"."notification_types" ADD CONSTRAINT "notification_types_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table notifications
-- ----------------------------
CREATE INDEX "notifications_recipient_id_idx" ON "public"."notifications" USING btree (
  "recipient_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "notifications_recipient_id_sender_id_type_id_idx" ON "public"."notifications" USING btree (
  "recipient_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "sender_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "type_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "notifications_type_id_idx" ON "public"."notifications" USING btree (
  "type_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table notifications
-- ----------------------------
ALTER TABLE "public"."notifications" ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table post_comment_likes
-- ----------------------------
CREATE INDEX "post_comment_likes_comment_id_type_idx" ON "public"."post_comment_likes" USING btree (
  "comment_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "type" "pg_catalog"."enum_ops" ASC NULLS LAST
);
CREATE INDEX "post_comment_likes_user_id_comment_id_idx" ON "public"."post_comment_likes" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "comment_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table post_comment_likes
-- ----------------------------
ALTER TABLE "public"."post_comment_likes" ADD CONSTRAINT "post_comment_likes_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table post_comments
-- ----------------------------
CREATE INDEX "post_comments_post_id_author_id_reply_to_id_created_at_idx" ON "public"."post_comments" USING btree (
  "post_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "author_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "reply_to_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "created_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table post_comments
-- ----------------------------
ALTER TABLE "public"."post_comments" ADD CONSTRAINT "post_comments_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table post_likes
-- ----------------------------
CREATE INDEX "post_likes_postId_type_idx" ON "public"."post_likes" USING btree (
  "postId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "type" "pg_catalog"."enum_ops" ASC NULLS LAST
);
CREATE INDEX "post_likes_userId_postId_idx" ON "public"."post_likes" USING btree (
  "userId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "postId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table post_likes
-- ----------------------------
ALTER TABLE "public"."post_likes" ADD CONSTRAINT "post_likes_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table posts
-- ----------------------------
CREATE INDEX "posts_author_id_created_at_idx" ON "public"."posts" USING btree (
  "author_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "created_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "posts_shared_post_id_idx" ON "public"."posts" USING btree (
  "shared_post_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table posts
-- ----------------------------
ALTER TABLE "public"."posts" ADD CONSTRAINT "posts_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table push_subscriptions
-- ----------------------------
CREATE UNIQUE INDEX "push_subscriptions_endpoint_key" ON "public"."push_subscriptions" USING btree (
  "endpoint" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "push_subscriptions_user_id_idx" ON "public"."push_subscriptions" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table push_subscriptions
-- ----------------------------
ALTER TABLE "public"."push_subscriptions" ADD CONSTRAINT "push_subscriptions_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table stories
-- ----------------------------
CREATE INDEX "stories_author_id_expires_at_idx" ON "public"."stories" USING btree (
  "author_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "expires_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "stories_expires_at_idx" ON "public"."stories" USING btree (
  "expires_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table stories
-- ----------------------------
ALTER TABLE "public"."stories" ADD CONSTRAINT "stories_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table story_views
-- ----------------------------
CREATE INDEX "story_views_story_id_idx" ON "public"."story_views" USING btree (
  "story_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "story_views_story_id_viewer_id_key" ON "public"."story_views" USING btree (
  "story_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "viewer_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table story_views
-- ----------------------------
ALTER TABLE "public"."story_views" ADD CONSTRAINT "story_views_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table user_additional_info
-- ----------------------------
CREATE UNIQUE INDEX "user_additional_info_user_id_key" ON "public"."user_additional_info" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table user_additional_info
-- ----------------------------
ALTER TABLE "public"."user_additional_info" ADD CONSTRAINT "user_additional_info_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table user_sessions
-- ----------------------------
CREATE UNIQUE INDEX "user_sessions_token_key" ON "public"."user_sessions" USING btree (
  "token" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "user_sessions_user_id_last_activity_token_idx" ON "public"."user_sessions" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "last_activity" "pg_catalog"."timestamp_ops" ASC NULLS LAST,
  "token" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table user_sessions
-- ----------------------------
ALTER TABLE "public"."user_sessions" ADD CONSTRAINT "user_sessions_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table user_types
-- ----------------------------
CREATE UNIQUE INDEX "user_types_type_name_key" ON "public"."user_types" USING btree (
  "type_name" "pg_catalog"."enum_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table user_types
-- ----------------------------
ALTER TABLE "public"."user_types" ADD CONSTRAINT "user_types_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table users
-- ----------------------------
CREATE UNIQUE INDEX "users_email_key" ON "public"."users" USING btree (
  "email" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "users_userAdditionalInfoId_key" ON "public"."users" USING btree (
  "userAdditionalInfoId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "users_username_email_type_idx" ON "public"."users" USING btree (
  "username" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "email" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "users_username_key" ON "public"."users" USING btree (
  "username" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table verification_codes
-- ----------------------------
CREATE UNIQUE INDEX "verification_codes_code_key" ON "public"."verification_codes" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table verification_codes
-- ----------------------------
ALTER TABLE "public"."verification_codes" ADD CONSTRAINT "verification_codes_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table bookmarks
-- ----------------------------
ALTER TABLE "public"."bookmarks" ADD CONSTRAINT "bookmarks_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "public"."posts" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."bookmarks" ADD CONSTRAINT "bookmarks_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table chat_message_reactions
-- ----------------------------
ALTER TABLE "public"."chat_message_reactions" ADD CONSTRAINT "chat_message_reactions_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "public"."chat_messages" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."chat_message_reactions" ADD CONSTRAINT "chat_message_reactions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table chat_messages
-- ----------------------------
ALTER TABLE "public"."chat_messages" ADD CONSTRAINT "chat_messages_reply_to_id_fkey" FOREIGN KEY ("reply_to_id") REFERENCES "public"."chat_messages" ("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "public"."chat_messages" ADD CONSTRAINT "chat_messages_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "public"."chat_rooms" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "public"."chat_messages" ADD CONSTRAINT "chat_messages_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table chat_participants
-- ----------------------------
ALTER TABLE "public"."chat_participants" ADD CONSTRAINT "chat_participants_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "public"."chat_rooms" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "public"."chat_participants" ADD CONSTRAINT "chat_participants_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table chat_rooms
-- ----------------------------
ALTER TABLE "public"."chat_rooms" ADD CONSTRAINT "chat_rooms_last_message_id_fkey" FOREIGN KEY ("last_message_id") REFERENCES "public"."chat_messages" ("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table follows
-- ----------------------------
ALTER TABLE "public"."follows" ADD CONSTRAINT "follows_followerId_fkey" FOREIGN KEY ("followerId") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "public"."follows" ADD CONSTRAINT "follows_followingId_fkey" FOREIGN KEY ("followingId") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table friends
-- ----------------------------
ALTER TABLE "public"."friends" ADD CONSTRAINT "friends_friend_id_fkey" FOREIGN KEY ("friend_id") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "public"."friends" ADD CONSTRAINT "friends_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table media
-- ----------------------------
ALTER TABLE "public"."media" ADD CONSTRAINT "media_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "public"."posts" ("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "public"."media" ADD CONSTRAINT "media_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table notifications
-- ----------------------------
ALTER TABLE "public"."notifications" ADD CONSTRAINT "notifications_recipient_id_fkey" FOREIGN KEY ("recipient_id") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "public"."notifications" ADD CONSTRAINT "notifications_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."users" ("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "public"."notifications" ADD CONSTRAINT "notifications_type_id_fkey" FOREIGN KEY ("type_id") REFERENCES "public"."notification_types" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table post_comment_likes
-- ----------------------------
ALTER TABLE "public"."post_comment_likes" ADD CONSTRAINT "post_comment_likes_comment_id_fkey" FOREIGN KEY ("comment_id") REFERENCES "public"."post_comments" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."post_comment_likes" ADD CONSTRAINT "post_comment_likes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table post_comments
-- ----------------------------
ALTER TABLE "public"."post_comments" ADD CONSTRAINT "post_comments_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "public"."post_comments" ADD CONSTRAINT "post_comments_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "public"."posts" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."post_comments" ADD CONSTRAINT "post_comments_reply_to_id_fkey" FOREIGN KEY ("reply_to_id") REFERENCES "public"."post_comments" ("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table post_likes
-- ----------------------------
ALTER TABLE "public"."post_likes" ADD CONSTRAINT "post_likes_postId_fkey" FOREIGN KEY ("postId") REFERENCES "public"."posts" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."post_likes" ADD CONSTRAINT "post_likes_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table posts
-- ----------------------------
ALTER TABLE "public"."posts" ADD CONSTRAINT "posts_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "public"."posts" ADD CONSTRAINT "posts_shared_post_id_fkey" FOREIGN KEY ("shared_post_id") REFERENCES "public"."posts" ("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table push_subscriptions
-- ----------------------------
ALTER TABLE "public"."push_subscriptions" ADD CONSTRAINT "push_subscriptions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table stories
-- ----------------------------
ALTER TABLE "public"."stories" ADD CONSTRAINT "stories_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table story_views
-- ----------------------------
ALTER TABLE "public"."story_views" ADD CONSTRAINT "story_views_story_id_fkey" FOREIGN KEY ("story_id") REFERENCES "public"."stories" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."story_views" ADD CONSTRAINT "story_views_viewer_id_fkey" FOREIGN KEY ("viewer_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table user_sessions
-- ----------------------------
ALTER TABLE "public"."user_sessions" ADD CONSTRAINT "user_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_type_fkey" FOREIGN KEY ("type") REFERENCES "public"."user_types" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "public"."users" ADD CONSTRAINT "users_userAdditionalInfoId_fkey" FOREIGN KEY ("userAdditionalInfoId") REFERENCES "public"."user_additional_info" ("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table verification_codes
-- ----------------------------
ALTER TABLE "public"."verification_codes" ADD CONSTRAINT "verification_codes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
