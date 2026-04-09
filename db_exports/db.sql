/*
 Navicat Premium Data Transfer

 Source Server         : smo_space_postgre
 Source Server Type    : PostgreSQL
 Source Server Version : 150008 (150008)
 Source Host           : bmgnwpkcvehlso6w4irp-postgresql.services.clever-cloud.com:5999
 Source Catalog        : bmgnwpkcvehlso6w4irp
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 150008 (150008)
 File Encoding         : 65001

 Date: 09/08/2025 00:55:39
*/


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
  "read_by" text[] COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of chat_messages
-- ----------------------------
INSERT INTO "public"."chat_messages" VALUES ('2c45e133-58b8-42ca-9b72-9a9d6dc29c0e', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'Xin chào! Đây là tin nhắn đầu tiên.', 'TEXT', NULL, '2025-06-13 17:35:36.445', '2025-06-13 17:35:36.445', '{6a31a93a-a961-48d6-963e-0645f99de8e4}');
INSERT INTO "public"."chat_messages" VALUES ('13b05140-4a43-4013-ba7a-fb4537e1372d', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'abc', 'TEXT', NULL, '2025-06-17 08:21:34.615', '2025-06-17 08:21:34.615', '{6a31a93a-a961-48d6-963e-0645f99de8e4}');
INSERT INTO "public"."chat_messages" VALUES ('13b05140-4a43-4013-ba7a-fb4537e1372a', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'chào', 'TEXT', NULL, '2025-06-17 08:21:34.615', '2025-06-17 08:21:34.615', '{6a31a93a-a961-48d6-963e-0645f99de8e4}');

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
  "left_at" timestamp(3)
)
;

-- ----------------------------
-- Records of chat_participants
-- ----------------------------
INSERT INTO "public"."chat_participants" VALUES ('edd6ec96-a120-44d0-9548-af62a74eea9b', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'MEMBER', '2025-06-13 17:35:36.21', NULL);
INSERT INTO "public"."chat_participants" VALUES ('16246c95-4c1d-4889-9050-dcd91dbb2c9e', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'fa7eca5e-233e-419c-82b9-83f4f35e9816', 'MEMBER', '2025-06-13 17:35:36.21', NULL);

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
INSERT INTO "public"."chat_rooms" VALUES ('fa7eca5e-233e-419c-82b9-83f4f35e9816', NULL, 'DIRECT', '2025-06-13 17:35:36.21', '2025-06-13 17:35:36.21', 'APPROVED', '13b05140-4a43-4013-ba7a-fb4537e1372a');

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
INSERT INTO "public"."follows" VALUES ('929698a6-8576-4681-ace5-367ab3a4b4db', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-03-08 06:29:08.977');
INSERT INTO "public"."follows" VALUES ('e862f299-a451-4e02-8fc3-2d768bdbfcd5', '65904792-fdd5-45e3-a892-830a4640fd9b', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-03-20 07:11:44.027');
INSERT INTO "public"."follows" VALUES ('c3edd4f2-5a16-4d93-8e9c-710c920d87ec', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-03-29 10:05:01.035');
INSERT INTO "public"."follows" VALUES ('05af7e2a-e7c5-4c92-b7fd-1ff57f2ac504', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-05-25 14:11:04.644');
INSERT INTO "public"."follows" VALUES ('b03039cd-8f35-4339-9c1e-5f65ea9bc45e', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2025-06-03 10:28:34.793');
INSERT INTO "public"."follows" VALUES ('58f1c997-33e6-4c6a-aa88-b0bf4afd3651', '898c5eed-1650-4a27-9ae1-45fec186d37e', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '2025-06-19 06:57:18.239');
INSERT INTO "public"."follows" VALUES ('f9c7d46a-eb4c-4bd3-aeb9-cd8772197903', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '2025-08-07 15:43:43.947');
INSERT INTO "public"."follows" VALUES ('97216a7e-2916-4e53-a07f-35b3ed5effce', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '46d96705-4f8d-475d-8527-995ff185ca89', '2025-08-07 15:49:22.752');

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
INSERT INTO "public"."friends" VALUES ('6365cffe-30b3-4f21-916b-608bb8eff789', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ACCEPTED', '2025-05-13 18:08:18.637', '2025-05-15 16:17:49.788', 'f', 't');

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
INSERT INTO "public"."media" VALUES ('71be560b-bd66-4109-b2c3-6ede341e9c1a', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508285346_ai-image-1754507993935-1.png', 'IMAGE', 291875, NULL, NULL, NULL, 'image/png', 'f', 'c8c21913-f9c0-4daa-8ce9-6ffadb8582ef', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:24:46.123', '2025-08-06 19:24:46.123');
INSERT INTO "public"."media" VALUES ('292d4427-3f60-4b49-9020-970fb8bd45ba', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508285272_ai-image-1754507993920-0.png', 'IMAGE', 188233, NULL, NULL, NULL, 'image/png', 'f', 'c8c21913-f9c0-4daa-8ce9-6ffadb8582ef', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:24:46.124', '2025-08-06 19:24:46.124');
INSERT INTO "public"."media" VALUES ('ee0c9857-33e5-4407-83ba-e9444bb96c76', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508285318_ai-image-1754508261372-0.png', 'IMAGE', 292219, NULL, NULL, NULL, 'image/png', 'f', 'c8c21913-f9c0-4daa-8ce9-6ffadb8582ef', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:24:46.151', '2025-08-06 19:24:46.151');
INSERT INTO "public"."media" VALUES ('2e632ca9-dcca-4a6b-b85c-fe1865bc83f4', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754508285352_ai-image-1754508261357-1.png', 'IMAGE', 284820, NULL, NULL, NULL, 'image/png', 'f', 'c8c21913-f9c0-4daa-8ce9-6ffadb8582ef', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:24:46.183', '2025-08-06 19:24:46.183');
INSERT INTO "public"."media" VALUES ('b438c20a-718b-4675-ba9d-04258428bdd9', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754561787774_ai-image-2.png', 'IMAGE', 939554, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-07 10:16:28.922', '2025-08-07 10:16:28.922');
INSERT INTO "public"."media" VALUES ('706b99fb-b957-4ed6-94f4-09ed730f2afa', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754561787743_ai-image-1.png', 'IMAGE', 1052862, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-07 10:16:28.967', '2025-08-07 10:16:28.967');
INSERT INTO "public"."media" VALUES ('fd5c71d1-23e7-4bc4-b4c7-e91f93ef114d', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754561787904_ai-image-3.png', 'IMAGE', 2288001, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-07 10:16:29.152', '2025-08-07 10:16:29.152');
INSERT INTO "public"."media" VALUES ('630b98c3-2c83-441f-9ac8-954df708b7d0', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1754561787915_ai-image-0.png', 'IMAGE', 2301635, NULL, NULL, NULL, 'image/png', 'f', NULL, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-07 10:16:29.604', '2025-08-07 10:16:29.604');

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
INSERT INTO "public"."notifications" VALUES ('70795540-1419-4c67-8217-d8c82b5a9fb0', 'a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW', 'NORMAL', 'f', 'f', '{"title": "New Follower", "message": "lucan1 started following you"}', '{"follower": {"id": "d66d20e6-d9cc-4218-9de6-8eeae42ea9ca", "avatar": "https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1749196673660_1749196672973_image", "fullName": "Luca Nguyen", "username": "lucan1"}}', '46d96705-4f8d-475d-8527-995ff185ca89', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-07 15:49:23.812', NULL);
INSERT INTO "public"."notifications" VALUES ('a7e46bed-2fb0-4127-a7cc-829f3adcee7e', 'fb34c97e-34c2-45f0-9c48-53cc4d6e8fdc', 'COMMENT', 'NORMAL', 'f', 't', '{"title": "New Comment", "message": "lucan2 commented on your post"}', '{"postId": "e2238074-7e92-4f57-a19c-36851a083bc3", "commentId": "b2c98c4e-3006-4e20-b61c-fdf0352ddbe7", "commentAuthor": {"avatar": "https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1734971185363_Snaptik.app_744868353203508353820.jpg", "fullName": "Luca N", "username": "lucan2"}}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2025-05-06 14:11:32.686', NULL);
INSERT INTO "public"."notifications" VALUES ('b122a716-6f7d-4b98-a3ef-c99ed2179bb1', 'a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW', 'NORMAL', 'f', 'f', '{"title": "New Follower", "message": "lucan1 started following you"}', '{"follower": {"id": "d66d20e6-d9cc-4218-9de6-8eeae42ea9ca", "avatar": "https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1747245470178_1747245469938_image", "fullName": "Luca Nguyen", "username": "lucan1"}}', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-05-25 14:11:13.658', NULL);
INSERT INTO "public"."notifications" VALUES ('4fd4eaf9-ba5d-4762-8a15-21970e48ed8d', 'a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW', 'NORMAL', 't', 'f', '{"title": "New Follower", "message": "lucan2 started following you"}', '{"follower": {"id": "6a31a93a-a961-48d6-963e-0645f99de8e4", "avatar": "https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1734971185363_Snaptik.app_744868353203508353820.jpg", "fullName": "Luca N", "username": "lucan2"}}', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2025-03-29 10:05:01.745', '2025-06-03 09:05:51.705');
INSERT INTO "public"."notifications" VALUES ('01e499d8-c818-465b-a285-07184303af07', 'a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW', 'NORMAL', 'f', 'f', '{"title": "New Follower", "message": "propro2421 started following you"}', '{"follower": {"id": "898c5eed-1650-4a27-9ae1-45fec186d37e", "avatar": null, "fullName": "tx123", "username": "propro2421"}}', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '898c5eed-1650-4a27-9ae1-45fec186d37e', '2025-06-19 06:57:18.264', NULL);
INSERT INTO "public"."notifications" VALUES ('6d225cc0-fa9d-4ca0-a93d-fc5dbd55ee5a', 'a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW', 'NORMAL', 'f', 'f', '{"title": "New Follower", "message": "lucan1 started following you"}', '{"follower": {"id": "d66d20e6-d9cc-4218-9de6-8eeae42ea9ca", "avatar": "https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1749196673660_1749196672973_image", "fullName": "Luca Nguyen", "username": "lucan1"}}', '49d9e3c0-ec00-48f0-86d3-293549c246dd', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-07 15:43:45.025', NULL);
INSERT INTO "public"."notifications" VALUES ('778e164e-fa6a-46f1-b2c8-4e02904ce6fe', 'a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW', 'NORMAL', 'f', 'f', '{"title": "New Follower", "message": "lucan1 started following you"}', '{"follower": {"id": "d66d20e6-d9cc-4218-9de6-8eeae42ea9ca", "avatar": "https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1748945410033_1748945409800_image", "fullName": "Luca Nguyen", "username": "lucan1"}}', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-06-03 10:28:35.463', NULL);

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
  "replies_count" int4 NOT NULL DEFAULT 0
)
;

-- ----------------------------
-- Records of post_comments
-- ----------------------------
INSERT INTO "public"."post_comments" VALUES ('0c4b605b-df25-428a-89be-c754edca1a5b', '<p>đúng đúng<br>anh BE gánh còng lưng</p>', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', 'b76a3a74-e582-4253-ba5c-fe8f16bb8465', '2025-01-18 06:23:24.747', '2025-01-18 06:23:59.387', 2, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 1);
INSERT INTO "public"."post_comments" VALUES ('b76a3a74-e582-4253-ba5c-fe8f16bb8465', '<p>về  system thì 10 điểm :3</p>', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', '0dce815c-eb60-4146-bb1a-d8de5c4ecf33', '2025-01-18 06:23:12.979', '2025-01-18 06:24:22.503', 1, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 0);
INSERT INTO "public"."post_comments" VALUES ('0dce815c-eb60-4146-bb1a-d8de5c4ecf33', '<p>về mặt trải nghiệm thì mình thấy  hiệu năng của mxh này rất tối<br>các tính năng <strong classname="font-bold"><em classname="font-italic">AI  </em></strong>cực kỳ bắt trend :3</p>', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', NULL, '2025-01-18 06:22:33.508', '2025-01-18 06:23:12.979', 0, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 1);
INSERT INTO "public"."post_comments" VALUES ('db6eabd7-1f34-42f3-a820-176157a74472', '<p>hic :(( thằng FE thì <strong classname="font-bold">mất dạy</strong> gặp ông BE <strong classname="font-bold">chu đáo </strong>:(( tự mình phá huỷ chính mình :))) thật hài hước đúng chứ <strong classname="font-bold"><em classname="font-italic">Duki </em></strong>💘</p><p></p>', '7cf32254-dc2d-44ff-904b-6d23d6aba6e7', NULL, '2025-01-13 14:46:24.286', '2025-01-14 15:33:28.928', 0, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 1);
INSERT INTO "public"."post_comments" VALUES ('0908a9ea-09e3-4809-b409-9e5404246303', '<p>chia sẽ cho thầy đi </p><p></p>', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', NULL, '2025-01-18 13:48:05.911', '2025-01-18 13:49:28.636', 0, '49d9e3c0-ec00-48f0-86d3-293549c246dd', 0);
INSERT INTO "public"."post_comments" VALUES ('f8af652a-8313-4a55-b069-fb59a33961bc', '<p><strong classname="font-bold">Lorem Ipsum</strong> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p>', 'de33bbdb-3bcc-4094-a392-0403f0f20cbd', NULL, '2025-01-17 06:27:49.561', '2025-01-20 09:51:53.811', 0, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 0);
INSERT INTO "public"."post_comments" VALUES ('459011d9-c8be-4011-b4e0-6eb66523d1f7', '<p>mình chỉ còn một mình họ :((  mất họ rồi mình chẳng còn gì nữa :(( mình cố tình trở nên hài hước thú vị để họ vui  nhưng có  vẻ như mình đã chợt quên mất rằng bản thân cư  sử  đúng mực  cậu ạ :((<br>đúng não cá vàng luôn :(( ngu ơi là nguuuu</p>', '7cf32254-dc2d-44ff-904b-6d23d6aba6e7', 'db6eabd7-1f34-42f3-a820-176157a74472', '2025-01-14 13:57:43.521', '2025-01-20 13:14:05.33', 1, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 0);
INSERT INTO "public"."post_comments" VALUES ('bd5407d9-fb1f-48bf-8599-29999e48605f', '<p>đáng suy ngẫm :))</p>', '59f85f60-a7b7-43f2-a2c8-ab75fc66bb48', NULL, '2025-03-03 04:09:55.043', '2025-03-03 04:09:55.043', 0, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 0);
INSERT INTO "public"."post_comments" VALUES ('4d5b5a87-6bfc-47f7-b3b5-c7d9e21b20d0', '<p>hay qua anh</p>', 'e2238074-7e92-4f57-a19c-36851a083bc3', NULL, '2025-06-10 16:00:08.358', '2025-06-10 16:00:08.358', 0, '6a31a93a-a961-48d6-963e-0645f99de8e4', 0);

-- ----------------------------
-- Table structure for post_likes
-- ----------------------------
DROP TABLE IF EXISTS "public"."post_likes";
CREATE TABLE "public"."post_likes" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "userId" text COLLATE "pg_catalog"."default" NOT NULL,
  "postId" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of post_likes
-- ----------------------------
INSERT INTO "public"."post_likes" VALUES ('6999d43e-c76f-4928-8f13-e76b37794f0d', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '7cf32254-dc2d-44ff-904b-6d23d6aba6e7', '2025-01-11 06:10:14.936');
INSERT INTO "public"."post_likes" VALUES ('50c575eb-be48-49f2-a95b-5afffead6a22', '49d9e3c0-ec00-48f0-86d3-293549c246dd', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', '2025-01-06 14:31:14.542');
INSERT INTO "public"."post_likes" VALUES ('d49e13ed-79d9-4b8a-9bf4-bd7c639b6bc3', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '59f85f60-a7b7-43f2-a2c8-ab75fc66bb48', '2025-01-06 07:04:07.894');
INSERT INTO "public"."post_likes" VALUES ('eb135d60-a37d-4427-962e-4be6e5159dad', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '8f9db143-2783-4a2a-947e-2896560fad89', '2025-01-08 07:38:53.228');
INSERT INTO "public"."post_likes" VALUES ('b1c62bc7-c511-4d65-8037-47334247c63c', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '0a2b1901-c2fc-437d-b0f7-cb95895735f9', '2025-01-11 06:35:26.142');
INSERT INTO "public"."post_likes" VALUES ('d08624d4-c387-4947-8dd3-f84a1195ed27', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '59f85f60-a7b7-43f2-a2c8-ab75fc66bb48', '2025-01-08 09:33:36');
INSERT INTO "public"."post_likes" VALUES ('d970fcd0-e1ed-4de5-ae8b-285d2d85eea1', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '10374432-832f-4135-b87e-d00ef6b1d3d5', '2025-01-11 09:55:42.815');
INSERT INTO "public"."post_likes" VALUES ('00ab6680-36f4-4011-a2b0-904362a1d04a', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '5943e205-8dff-49f9-8eb5-9947336c9343', '2025-01-07 09:12:04.782');
INSERT INTO "public"."post_likes" VALUES ('0af39c47-5dae-4e94-8a38-2154aef128fe', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '10374432-832f-4135-b87e-d00ef6b1d3d5', '2025-01-06 08:49:04.472');
INSERT INTO "public"."post_likes" VALUES ('644db4fa-682a-4f15-9403-7b07d3712685', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'b5cc9911-e908-45e5-afb3-981e15399c9e', '2025-01-06 08:49:32.415');
INSERT INTO "public"."post_likes" VALUES ('392ecbbc-6bac-4e83-ac99-c6f157ee7cef', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', '2025-01-12 15:04:42.463');
INSERT INTO "public"."post_likes" VALUES ('2f0c6b28-fe7e-459e-8f91-27542df3ba2e', '49d9e3c0-ec00-48f0-86d3-293549c246dd', 'b5cc9911-e908-45e5-afb3-981e15399c9e', '2024-12-19 06:02:38.066');
INSERT INTO "public"."post_likes" VALUES ('c01d6c6d-3cde-40a2-93c4-77274a0cdab2', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'de33bbdb-3bcc-4094-a392-0403f0f20cbd', '2025-04-25 06:01:03.941');
INSERT INTO "public"."post_likes" VALUES ('1f56d808-bb82-4349-afce-6885bca20482', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'e2238074-7e92-4f57-a19c-36851a083bc3', '2025-03-01 09:15:54.184');
INSERT INTO "public"."post_likes" VALUES ('61591cc8-3673-46bb-a927-87472b0a5379', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'e2238074-7e92-4f57-a19c-36851a083bc3', '2025-03-27 07:02:08.355');
INSERT INTO "public"."post_likes" VALUES ('d27df663-23a7-4e03-962d-5859f53fe8b1', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '0a2b1901-c2fc-437d-b0f7-cb95895735f9', '2025-04-23 10:52:58.497');
INSERT INTO "public"."post_likes" VALUES ('1817f70d-d033-45a6-bb27-572c1a171505', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'e2238074-7e92-4f57-a19c-36851a083bc3', '2025-04-23 11:08:13.006');
INSERT INTO "public"."post_likes" VALUES ('c70461a5-066f-4f21-9f53-8ddf6810db57', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', '2025-05-12 06:26:21.345');
INSERT INTO "public"."post_likes" VALUES ('7e6f5270-11c7-4c11-a84e-1c8bda3acae9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '352053c2-d22d-4896-95b9-6fe47e71c915', '2025-06-03 10:33:11.718');
INSERT INTO "public"."post_likes" VALUES ('aa81a1bf-c003-4d58-b744-fc452d8b7e49', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'cccd5333-3355-4a54-b566-1a137fd28a1b', '2025-06-27 09:02:14.042');
INSERT INTO "public"."post_likes" VALUES ('8ff1497a-29a9-40fc-b46d-ce30000f6faa', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'c8c21913-f9c0-4daa-8ce9-6ffadb8582ef', '2025-08-06 19:25:05.347');

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
  "comment_count" int4 NOT NULL DEFAULT 0
)
;

-- ----------------------------
-- Records of posts
-- ----------------------------
INSERT INTO "public"."posts" VALUES ('b5cc9911-e908-45e5-afb3-981e15399c9e', 'NextJS so good<br>#NextJS_so_good #NextJS_so_good2 #NextJS_so_good3', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2023-11-11 14:31:11.379', '2025-01-07 06:52:41.528', 'f', 2, 0);
INSERT INTO "public"."posts" VALUES ('0a2b1901-c2fc-437d-b0f7-cb95895735f9', '<p>Trong năm 2024, <strong class="font-bold">câu chuyện về AI trong lập trình đang trở nên ngày càng thú vị và đầy hứa hẹn</strong>. Nhiều nhà phát triển đã bắt đầu áp dụng trí tuệ nhân tạo để tự động hóa các quy trình lập trình. Điều này giúp họ tiết kiệm thời gian và nâng cao hiệu suất làm việc.<br><br><strong class="font-bold">Hệ thống lập trình tự động được phát triển ngày càng tinh vi</strong>, không chỉ giúp viết mã mà còn đưa ra các đề xuất tối ưu hóa. Các công cụ như GitHub Copilot đã trở thành người bạn đồng hành không thể thiếu của lập trình viên. Ngoài ra, AI còn hỗ trợ trong việc kiểm tra lỗi và bảo trì mã nguồn, từ đó cải thiện chất lượng sản phẩm.<br><br><em class="font-italic">Một trong những xu hướng nổi bật là sử dụng AI để phân tích dữ liệu lớn, từ đó giúp các nhóm lập trình đưa ra quyết định tốt hơn trong việc phát triển sản phẩm</em>. Chúng ta có thể thấy những cải tiến trong việc phát triển ứng dụng di động, phần mềm doanh nghiệp và thậm chí là trong lĩnh vực trí tuệ nhân tạo.<br><br>Năm 2024 hứa hẹn sẽ mang đến nhiều cơ hội mới cho lập trình viên khi họ có thể tận dụng sức mạnh của AI. Hãy cùng theo dõi và khám phá những điều bất ngờ mà AI mang lại cho ngành lập trình nhé!<br><br>#AI #Programming #TechTrends</p>', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2024-12-22 15:33:22.377', '2025-04-23 11:02:32.554', 'f', 2, 0);
INSERT INTO "public"."posts" VALUES ('59f85f60-a7b7-43f2-a2c8-ab75fc66bb48', '<p><em class="font-italic">Họ cười tôi vì tôi đang cười họ,</em></p><p><em class="font-italic">Tôi cười họ, họ bu lại đập tôi!</em></p><p></p><p>#suyngam #đáng_tiền_mạng #chữa_lành</p>', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2024-12-21 18:44:45.273', '2025-03-03 04:09:55.043', 'f', 2, 1);
INSERT INTO "public"."posts" VALUES ('de33bbdb-3bcc-4094-a392-0403f0f20cbd', '<p>💕LucaN/LeoN💕</p><p>#Friend</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-01-08 07:47:56.517', '2025-04-25 06:01:03.941', 't', 1, 1);
INSERT INTO "public"."posts" VALUES ('5943e205-8dff-49f9-8eb5-9947336c9343', '<p><strong classname="font-bold">Hành trình lập trình của bạn có thể không giống ai, nhưng đó chính là sức mạnh của bạn!</strong> <br><br>Khiếm thị không phải là rào cản mà là một cơ hội để phát triển những kỹ năng độc đáo mà chỉ bạn mới có. <em classname="font-italic">Hãy tưởng tượng</em> bạn đang tạo ra những dòng mã mà không cần nhìn thấy màn hình. Đó chính là sự sáng tạo và sức mạnh của trí tưởng tượng! <br><br>Bước vào thế giới lập trình, bạn đang khám phá không chỉ là những cú pháp hay thuật toán mà còn là khả năng tự vượt qua chính mình. <strong classname="font-bold">Mỗi dòng mã bạn viết ra là một bước tiến, mỗi lỗi sai là một bài học quý giá.</strong> Hãy nhận ra rằng bạn không đơn độc trên con đường này. Có rất nhiều tài nguyên hỗ trợ cho người khiếm thị, từ phần mềm đọc màn hình đến cộng đồng lập trình viên sẵn lòng giúp đỡ. <br><br>Hãy đặt mục tiêu cho bản thân và kiên trì theo đuổi. <em classname="font-italic">Chắc chắn rằng bạn có thể biến đam mê lập trình thành hiện thực</em>, và bạn sẽ chứng minh cho thế giới thấy rằng không gì là không thể! <br><br>Hãy nhớ, mỗi cú click chuột hay mỗi dòng lệnh đều đang khẳng định giá trị của bạn. Bạn có thể làm được! <br><br>#Inspiration #BlindProgramming #CodingJourney</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-21 06:28:24.722', '2025-01-07 09:12:04.782', 'f', 1, 0);
INSERT INTO "public"."posts" VALUES ('10374432-832f-4135-b87e-d00ef6b1d3d5', '<p>Trong JavaScript, <strong classname="font-bold">bất đồng bộ</strong> đề cập đến khả năng thực hiện các tác vụ mà không làm tắc nghẽn luồng chính của chương trình. Điều này có nghĩa là khi một tác vụ kéo dài (như một yêu cầu đến server hoặc một hoạt động đọc file) diễn ra, JavaScript vẫn có thể tiếp tục thực hiện các đoạn mã khác mà không bị chờ đợi.<br><br>Một trong những cách phổ biến để xử lý bất đồng bộ trong JavaScript là thông qua <em classname="font-italic">callback</em>, <em classname="font-italic">Promise</em> và <em classname="font-italic">async/await</em>. Các kỹ thuật này cho phép bạn quản lý các tác vụ chờ đợi một cách hiệu quả hơn, giúp mã của bạn trở nên dễ hiểu hơn.<br><br>Ví dụ, khi sử dụng <em classname="font-italic">Promise</em>, bạn có thể xử lý kết quả của một tác vụ bất đồng bộ một cách rõ ràng mà không cần phải lồng nhiều callback, đảm bảo mã của bạn vẫn dễ đọc và dễ bảo trì. <br><br><strong classname="font-bold">Bất đồng bộ</strong> là một phần quan trọng trong lập trình JavaScript, đặc biệt khi làm việc với các ứng dụng web, nơi nhiều tác vụ cần được thực hiện đồng thời mà không làm ảnh hưởng đến trải nghiệm người dùng.<br><br>#JavaScript #Asynchronous #Programming</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-22 14:56:41.677', '2025-01-17 09:06:53.338', 'f', 2, 0);
INSERT INTO "public"."posts" VALUES ('8f9db143-2783-4a2a-947e-2896560fad89', '<p><strong classname="font-bold">Mùa Noel luôn mang đến cho chúng ta những cảm xúc đặc biệt, và không gì tuyệt vời hơn khi được trải nghiệm không khí lạnh lẽo của mùa đông cùng người bạn đồng hành, anh mentor thân mến.</strong> <br><br><em classname="font-italic">Mỗi năm, khi những bông tuyết bắt đầu rơi, thành phố như chuyển mình trong một tấm áo mới. Đường phố được trang trí lấp lánh với đèn trang trí, những cây thông Noel đầy màu sắc. Những ngày này, việc ngồi bên cạnh anh mentor, cùng nhau thưởng thức ly cacao nóng, ngắm nhìn bầu trời đầy sao thật sự là những kỉ niệm không thể nào quên.</em> <br><br><strong classname="font-bold">Dưới cái lạnh của mùa đông, chúng ta có thể trò chuyện về bao điều, từ những giấc mơ trong năm tới cho đến những kỷ niệm đáng nhớ trong quá khứ. Anh mentor luôn biết cách mang lại cho tôi những lời khuyên quý giá, giúp tôi trưởng thành hơn từng ngày.</strong> <br><br><em classname="font-italic">Chúng ta cùng nhau trải qua những giây phút ấm áp bên ngọn nến lung linh, nhâm nhi những chiếc bánh mật ngọt ngào và chia sẻ những cảm xúc trong lòng giữa không gian lạnh lẽo nhưng đầy yêu thương.</em> <br><br><strong classname="font-bold">Noel không chỉ là dịp để nhận quà mà còn là thời điểm để tri ân, để yêu thương và kết nối với những người thân yêu. Hy vọng rằng mỗi mùa Noel đến, chúng ta lại có thêm những kỷ niệm đẹp bên nhau.</strong> <br><br>#Christmas #Friendship #HolidayVibes</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-22 13:16:31.9', '2025-01-18 07:04:55.013', 'f', 1, 0);
INSERT INTO "public"."posts" VALUES ('7cf32254-dc2d-44ff-904b-6d23d6aba6e7', '<p>Yuki đã tìm đc điểm để  dừng chân :3 trao trọn con tym bé nhỏ đầy vết  xước</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-01-07 06:46:42.842', '2025-03-26 07:05:12.5', 't', 1, 2);
INSERT INTO "public"."posts" VALUES ('352053c2-d22d-4896-95b9-6fe47e71c915', '<p>test private</p>', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-01-04 07:34:15.824', '2025-06-03 10:33:11.718', 't', 1, 0);
INSERT INTO "public"."posts" VALUES ('c8c21913-f9c0-4daa-8ce9-6ffadb8582ef', 'Đổ vỡ trong tình yêu luôn là một trải nghiệm đau đớn mà ai cũng có thể gặp phải. <strong class="font-bold">Nếu bạn đang ở trong hoàn cảnh này, hãy nhớ rằng bạn không cô đơn.</strong> Mọi người đều đã từng trải qua những nỗi buồn như vậy và quan trọng là cách bạn xử lý nó.<br><br>Trước hết, <em class="font-italic">cho phép mình cảm thấy buồn bã</em>. Đây là cảm xúc hoàn toàn tự nhiên và không có gì xấu. Hãy dành thời gian cho bản thân, có thể là nghe nhạc, đọc sách hay thậm chí là đi dạo. Điều này không chỉ giúp bạn thư giãn mà còn giúp bạn nhìn nhận lại những gì đã xảy ra.<br><br>Tiếp theo, hãy chia sẻ cảm xúc của mình với người thân, bạn bè. <strong class="font-bold">Họ có thể không thể hiểu hết mọi thứ, nhưng sự đồng hành của họ sẽ giúp bạn vơi bớt nỗi buồn.</strong> Đôi khi, chỉ cần một cuộc trò chuyện cũng đủ để bạn cảm thấy nhẹ nhàng hơn rất nhiều.<br><br>Cuối cùng, đừng quên chăm sóc bản thân cả về mặt thể chất lẫn tinh thần. <em class="font-italic">Tập thể dục, ăn uống lành mạnh và tìm một sở thích mới sẽ giúp bạn lấy lại cân bằng trong cuộc sống.</em> <br><br>Nhìn chung, thời gian là liều thuốc tốt nhất. Hãy tin rằng bạn sẽ tìm thấy hạnh phúc một lần nữa! <br><br>#heartbreak #selfcare #movingon', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-08-06 19:24:44.504', '2025-08-06 19:25:05.347', 'f', 1, 0);
INSERT INTO "public"."posts" VALUES ('ee207bbe-481f-4c0f-ad31-a29fddd0d350', '<p>Chắc hẳn bạn đã từng nghe đến những mạng xã hội lớn như Facebook hay Instagram, nhưng đã bao giờ bạn thử khám phá một mạng xã hội thú vị mang tên Yukibook chưa? <strong classname="font-bold">Yukibook là một sản phẩm được phát triển bởi một bạn intern Frontend và một bạn Middle Backend siêu đỉnh, hứa hẹn mang đến cho người dùng những trải nghiệm mới mẻ và độc đáo.</strong><br><br>Khi lần đầu đăng nhập vào Yukibook, tôi cảm thấy vô cùng ấn tượng với giao diện thân thiện và dễ sử dụng. <em classname="font-italic">Mọi thứ đều rất trực quan, từ việc tạo bài viết cho đến kết bạn hay nhắn tin với bạn bè. Bạn sẽ không phải lo lắng về việc "lạc trôi" giữa những tính năng phức tạp.</em> <br><br>Điều đặc biệt ở Yukibook là cộng đồng thật sự gần gũi. Bạn có thể chia sẻ những khoảnh khắc đáng nhớ trong cuộc sống của mình và nhận được nhiều phản hồi tích cực từ những người bạn mới. <strong classname="font-bold">Những tính năng như tạo bài viết, bình luận, và thả tim rất dễ dàng, giúp bạn kết nối và thể hiện bản thân một cách tự nhiên nhất.</strong><br><br>Yukibook không chỉ đơn thuần là một nơi để kết nối, mà còn là một nền tảng để sáng tạo và chia sẻ. Bạn sẽ có cơ hội khám phá sở thích mới và tham gia vào những hoạt động thú vị từ cộng đồng. Hãy cùng khám phá Yukibook, chắc chắn rằng bạn sẽ tìm thấy niềm vui và sự kết nối mà bấy lâu nay mình tìm kiếm! <br><br>#Yukibook #SocialMedia #UserExperience #Community #Fun</p>', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '2025-01-06 14:29:55.718', '2025-05-12 06:26:21.345', 'f', 3, 4);
INSERT INTO "public"."posts" VALUES ('e2238074-7e92-4f57-a19c-36851a083bc3', '<p>Xin chào các bạn! Hôm nay, chúng ta cùng nhau khám phá một chủ đề thú vị: <strong class="font-bold">lợi ích của việc đọc sách</strong>. Đọc sách không chỉ giúp bạn mở mang kiến thức mà còn mang lại rất nhiều lợi ích cho tinh thần và cảm xúc của chúng ta.<br><br>Đầu tiên, <strong class="font-bold">đọc sách giúp tăng cường khả năng tập trung</strong>. Khi bạn thả mình vào những trang sách, não bộ sẽ hoạt động mạnh mẽ để theo dõi mạch truyện và các nhân vật. Điều này giúp chúng ta rèn luyện khả năng tập trung trong cuộc sống hàng ngày.<br><br>Ngoài ra, <strong class="font-bold">đọc sách còn là cách giải tỏa căng thẳng hiệu quả</strong>. Một cuốn tiểu thuyết hay hay một cuốn sách về tâm lý sẽ đưa bạn vào một thế giới khác, nơi mà bạn có thể tạm quên đi những lo âu, căng thẳng trong cuộc sống.<br><br>Cuối cùng, <strong class="font-bold">việc đọc sách thường xuyên cũng giúp cải thiện kỹ năng viết</strong> và khả năng giao tiếp. Bạn có thể học hỏi từ cách thức diễn đạt, cấu trúc câu, và phong cách viết của tác giả.<br><br><em class="font-italic">Vậy tại sao không dành chút thời gian mỗi ngày để đọc sách nhỉ? Bạn sẽ ngạc nhiên về những gì mình có thể học hỏi và cảm nhận được.</em> <br><br>Hãy cùng nhau hòa mình vào những trang sách để khám phá thế giới kỳ diệu này nhé!!<br><br>#Reading #BookLovers #BenefitsOfReading</p>', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-02-22 05:43:13.101', '2025-06-10 16:00:08.358', 'f', 3, 1);
INSERT INTO "public"."posts" VALUES ('cccd5333-3355-4a54-b566-1a137fd28a1b', 'Chơi đàn guitar không chỉ là một sở thích tuyệt vời mà còn mang lại nhiều lợi ích cho cuộc sống. <strong class="font-bold">Khi bạn chơi guitar, bạn đang mở ra cánh cửa đến thế giới âm nhạc đầy sắc màu và thú vị.</strong> <br><br><em class="font-italic">Âm nhạc có khả năng kết nối con người với nhau, giúp chúng ta cảm thấy gần gũi hơn. Khi chơi guitar, bạn có thể chia sẻ những khoảnh khắc vui vẻ bên bạn bè hoặc gia đình, tạo ra những kỷ niệm đáng nhớ.</em> <br><br>Một trong những lợi ích nổi bật của việc chơi guitar chính là giảm stress. <strong class="font-bold">Âm nhạc có thể giúp bạn thư giãn, xua tan đi những căng thẳng trong cuộc sống hàng ngày.</strong> Nghe hoặc tự mình chơi đàn, não bộ sẽ tiết ra các hormone hạnh phúc, khiến tâm trạng của bạn trở nên tích cực hơn.<br><br>Hơn nữa, <strong class="font-bold">việc học và chơi guitar cũng rèn luyện tính kiên nhẫn và sự kiên trì.</strong> Bạn sẽ phát triển kỹ năng giải quyết vấn đề và tư duy logic khi thực hành từng hợp âm, cho phép bạn trở nên tự tin hơn.<br><br>Cuối cùng, hãy nhớ rằng <strong class="font-bold">ngày nào cũng dành một ít thời gian cho guitar, bạn sẽ thấy cuộc sống của mình trở nên phong phú và vui vẻ hơn.</strong> Hãy bắt đầu hành trình âm nhạc của bạn ngay hôm nay!<br><br>#Guitar #MusicBenefits #LiveHappily', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-06-24 15:01:44.476', '2025-06-29 17:52:27.18', 'f', 1, 0);

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
INSERT INTO "public"."user_additional_info" VALUES ('a3ce227d-9052-4f0d-97a9-18995ac26980', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '', '', '{"Admin SMOTeam"}', '2002-04-15 14:43:23', '{https://smoteam.com,https://smogroup.com}');
INSERT INTO "public"."user_additional_info" VALUES ('d0b2a90d-01d1-4bea-b67c-67eff0597f5e', '65904792-fdd5-45e3-a892-830a4640fd9b', NULL, NULL, '{"student at Cao Dang Hoa Binh Xuan Loc"}', '1990-01-01 09:08:03', '{}');
INSERT INTO "public"."user_additional_info" VALUES ('764a4de1-6d8d-4ce3-8afd-89085bbc500c', '49d9e3c0-ec00-48f0-86d3-293549c246dd', NULL, NULL, '{}', '2005-06-28 08:49:17', '{}');
INSERT INTO "public"."user_additional_info" VALUES ('61ccaa46-79b6-4d92-911c-8cc8007ac4ac', 'b6dcff8d-c61b-4346-a60d-682da15baef9', NULL, NULL, '{}', NULL, '{}');
INSERT INTO "public"."user_additional_info" VALUES ('101ae694-b615-426a-a2f0-ce9801f569f9', '64d76b9c-cbe0-410f-b1fd-853cca983aa5', NULL, NULL, '{}', '2003-06-20 08:56:48', '{}');
INSERT INTO "public"."user_additional_info" VALUES ('0e353df0-b3b8-446b-92ce-c77c17222feb', '9df351a4-a867-460f-9453-7105223b9e80', 'Vũng Tàu', NULL, '{"bác sĩ"}', NULL, '{}');
INSERT INTO "public"."user_additional_info" VALUES ('62692e7b-7b44-4c8c-95c9-e8b0be483359', '898c5eed-1650-4a27-9ae1-45fec186d37e', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."user_additional_info" VALUES ('fdf0f92c-c659-4501-b9c6-645ca8f20985', 'me', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."user_additional_info" VALUES ('e54984d0-4546-40e3-ac23-0bdecd016642', '46d96705-4f8d-475d-8527-995ff185ca89', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."user_additional_info" VALUES ('20458e81-ed65-4c03-8812-668167e0278a', '02ad241e-66a7-4e44-99fd-36fced0ca386', NULL, NULL, '{}', NULL, '{}');
INSERT INTO "public"."user_additional_info" VALUES ('54b220fc-c8bd-4814-b1ed-3360ef61e830', '95cf9878-6d9f-469a-a07d-331453dce2', NULL, NULL, NULL, NULL, NULL);
INSERT INTO "public"."user_additional_info" VALUES ('e7e2e7e4-ae5d-4be0-a9f6-1a2ebbd291bf', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', NULL, NULL, '{}', NULL, '{}');
INSERT INTO "public"."user_additional_info" VALUES ('176dd3e1-77e9-4fa3-b1ac-7e109316aba1', '4efe35df-757f-4ee4-b5bd-7aa7349ce5c8', NULL, NULL, '{}', NULL, '{}');
INSERT INTO "public"."user_additional_info" VALUES ('e0d3535e-7eec-4fcc-92ba-0a615b52c413', '95cf9878-6d9f-469a-a07d-331453dce25c', NULL, NULL, '{}', NULL, '{}');
INSERT INTO "public"."user_additional_info" VALUES ('82ea8d96-c699-462e-8dfd-1790da054be4', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'TP. Hồ Chí Minh', 'Đồng Nai', '{"Frontend Developer at SMO Team","Software Development Engineer at VNG Corporation"}', '2005-09-10 05:55:18', '{Yukidev.its.moe}');

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
  "gender" "public"."UserGender"
)
;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO "public"."users" VALUES ('49d9e3c0-ec00-48f0-86d3-293549c246dd', 'yenvydethuong2806', 'ogyminecraft497+1@gmail.com', 'Nana Haru', '$2a$10$7TYIFS8ZqDbn/.z6o9A2HuNY5G.6HxnM8.iEyKs3zsDkr4d6rsSyy', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0OWQ5ZTNjMC1lYzAwLTQ4ZjAtODZkMy0yOTM1NDljMjQ2ZGQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2Iiwia2V5IjoiOTdkYjFmNjktZDA2OS00ZTI0LTkwYzktM2M2NzgyYTBlMmI5IiwiaWF0IjoxNzQzNDk2MTcyLCJleHAiOjE3NDYwODgxNzJ9.Qlc0bHoziTuRlSjYLGt8jAtwEZHT4jJHZECtr84kprs', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1742306320612_1742306324337_image', 't', 'f', 'f', '2024-11-23 04:19:05.711', '2025-08-07 15:43:43.947', 2.60, 3, 2, 1, 'Pham Thi Yen Vy', '', NULL, '764a4de1-6d8d-4ce3-8afd-89085bbc500c', 0, NULL);
INSERT INTO "public"."users" VALUES ('9df351a4-a867-460f-9453-7105223b9e80', 'hgphienn', 'hgphien@gmail.com', 'Phạm Trần Hồng PHiên', '$2a$10$VPmWSIXXHURJsQVUjTG5BO2XKGDeserf463Lq4Bw0tPXjFYanHzLe', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiJjMjI2MTMzNC03MThlLTRkMmItOThjNi0wMDhmZjU4YjQ0NjUiLCJ1c2VySWQiOiI5ZGYzNTFhNC1hODY3LTQ2MGYtOTQ1My03MTA1MjIzYjllODAiLCJ1c2VybmFtZSI6ImhncGhpZW5uIiwia2V5IjoiNjBhYzdkYzItMmUyMS00MTM2LWJhNDItYmIyY2I5N2UxZTJlIiwiaWF0IjoxNzMyMjY5MDk0LCJleHAiOjE3MzQ4NjEwOTR9.jSn-oaWPHzeqWjw2lAq1c58z42ZlNLzt5KpSOIvAwRw', NULL, 'f', 'f', 'f', '2024-11-22 09:51:32.629', '2025-06-10 10:31:04.281', 0.00, 0, 0, 0, NULL, '', NULL, '0e353df0-b3b8-446b-92ce-c77c17222feb', 0, NULL);
INSERT INTO "public"."users" VALUES ('65904792-fdd5-45e3-a892-830a4640fd9b', 'yenvydethuong28062', 'ogyminecraft497+3@gmail.com', 'Nguyen Ngoc Tram ANh', '', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTkwNDc5Mi1mZGQ1LTQ1ZTMtYTg5Mi04MzBhNDY0MGZkOWIiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2MiIsImtleSI6IjdiMzhjZDliLTRiZTItNGZjMi1hYWZhLWM5NjE2OTMwYjNmNSIsImlhdCI6MTc0MjQ2MTU5OSwiZXhwIjoxNzQ1MDUzNTk5fQ.w2usJK6rWKt8X5_xtONOG0NeY0Catc7Rsjg3PDMsJW8', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1742454687239_1742454692630_image', 'f', 'f', 'f', '2024-11-25 04:25:10.321', '2025-06-26 08:15:55.393', 0.00, 0, 1, 0, 'nguyen ngoc tram anh', '', NULL, 'd0b2a90d-01d1-4bea-b67c-67eff0597f5e', 0, NULL);
INSERT INTO "public"."users" VALUES ('caa2265d-5196-4a67-831e-85f91866fb8b', 'kanjame', 'kanjame@gmail.com', 'Kan Jame', '$2a$10$hmzfMs28YHK46KQ8jcN4guxrObSsBL6hUSVsn/nwppUNIIe5DonuW', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, 0, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiI2ZjYwOTkzOS1jM2RlLTQ3M2ItYjcyMy00ZTQ2YWExNjE2ZWIiLCJ1c2VySWQiOiJjYWEyMjY1ZC01MTk2LTRhNjctODMxZS04NWY5MTg2NmZiOGIiLCJ1c2VybmFtZSI6ImthbmphbWUiLCJrZXkiOiJlN2UyMDkwNS0wNzJlLTRjNTItYjlkZS01NTYxYzEyYWQ2MzIiLCJpYXQiOjE3MzE0OTY0ODgsImV4cCI6MTczNDA4ODQ4OH0.EDsz6V5ET6JWif5-V1QtocnaPtRxD3s1y4obp6MCFoA', NULL, 'f', 'f', 'f', '2024-11-13 11:14:48.721', '2025-02-28 09:05:29.179', 0.00, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL);
INSERT INTO "public"."users" VALUES ('6a31a93a-a961-48d6-963e-0645f99de8e4', 'lucan2', 'lucan2@gmail.com', 'Luca N', '$2b$10$E399bydm4h2sAFu2Q4zCBuU8azipGf2KDjLf.Id9VcxGf28Rnq2bS', '588b1a65-426a-468c-9365-dc1c9b851a79', '0909090909', 23, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6ImI1YmU5MWM0LWUyNzItNGFhOS1hNzI4LTcxNWQ4MjI1M2M1YSIsImlhdCI6MTc1NDUwNzUwNywiZXhwIjoxNzU3MDk5NTA3fQ.fBdZ8GS26G-zbzkAMBsPnZatL9SXDoGalITPtYYvXoU', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1751217042134_1751217042282_image', 'f', 'f', 'f', '2024-11-06 09:49:03.576', '2025-08-06 19:13:55.224', 487.60, 2, 2, 5, NULL, NULL, 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1744788362245_00002-1468083896.png', NULL, 1, NULL);
INSERT INTO "public"."users" VALUES ('02ad241e-66a7-4e44-99fd-36fced0ca386', 'devYuki2005', 'ogyminecraft497@gmail.com', 'Dang Hoang Thien An', '$2a$10$62LOlFv9qXvDELSVa4CIZOFZOV1Qtk/HBchmMuWNNo0j7ypOy6rzm', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIwMmFkMjQxZS02NmE3LTRlNDQtOTlmZC0zNmZjZWQwY2EzODYiLCJ1c2VybmFtZSI6ImRldll1a2kyMDA1Iiwia2V5IjoiMDcxYWJlZTctNWE5NC00MzQ5LTgwNzMtOWE4ZDBiZDdlMmZmIiwiaWF0IjoxNzU0MDYyMDIwLCJleHAiOjE3NTY2NTQwMjB9.CiZkMhjdfgwDgO5BoxdXKc5SlzXcsz2QAw_6eO5m4m8', 'https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1731476400251_photo_2024-03-11_12-05-41.jpg', 't', 'f', 'f', '2024-11-05 13:25:27.937', '2025-08-01 15:27:00.257', 0.00, 0, 0, 0, NULL, '<p>💕Phạm Thị Yến Vyyyy💕</p>', NULL, '20458e81-ed65-4c03-8812-668167e0278a', 0, NULL);
INSERT INTO "public"."users" VALUES ('084b617e-c89c-44ff-8dc9-7c1aa4f7730e', 'yenvydethuong28063', 'ogyminecraft497+4@gmail.com', 'pham thi yen vy', '$2a$10$2pTODRB0PCD9wvkTeGn68.1U5arkkBavuLlExIbLg0hzg05..0Wkq', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIwODRiNjE3ZS1jODljLTQ0ZmYtOGRjOS03YzFhYTRmNzczMGUiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2MyIsImtleSI6ImViNzc1OTZkLWQ3MzAtNDhjNS04ZmI1LWMyYjU3NWQyODJmYSIsImlhdCI6MTczNjMwOTc5OCwiZXhwIjoxNzM4OTAxNzk4fQ.Nfeiwh6UEPlnyjd2kyOp-wwabURjTgUphRdROLVhOs0', NULL, 'f', 'f', 't', '2024-11-29 02:56:03.329', '2025-06-26 08:16:17.471', 0.00, 0, 1, 0, NULL, NULL, NULL, NULL, 0, NULL);
INSERT INTO "public"."users" VALUES ('64d76b9c-cbe0-410f-b1fd-853cca983aa5', 'tay52636', 'tay0505@gmail.com', 'Tây Tệ', '$2a$10$7r1VlDib4iT5lUlw2sSqOeAV7UuodpCAPNH9mIFY3uDD3tH/dLNZy', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, 22, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NGQ3NmI5Yy1jYmUwLTQxMGYtYjFmZC04NTNjY2E5ODNhYTUiLCJ1c2VybmFtZSI6InRheTUyNjM2Iiwia2V5IjoiNTFiNTVhMTMtMDkwYS00MjViLWI1MzAtOWNkMTNjZjUzNzRjIiwiaWF0IjoxNzQ2NTA2NzkwLCJleHAiOjE3NDkwOTg3OTB9.h_Nbm3NH1ndipGBWsYZzDqwcg2Yk2wmhhN5RZu9b5Ag', NULL, 'f', 'f', 't', '2025-04-05 11:20:32.399', '2025-06-26 08:16:17.471', 0.00, 0, 0, 0, 'tay dep trai', '<p>anh em thì vẫn thua trái banh thôi</p>', NULL, '101ae694-b615-426a-a2f0-ce9801f569f9', 0, NULL);
INSERT INTO "public"."users" VALUES ('d66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'lucan1', 'lucan1@gmail.com', 'Luca Nguyen', '$2a$10$nHZoRuHdJ.aS1GLAZSG3oOKxJg9ymwpP9ephqPS9zByCD097adtra', '7c2f4d9a-b10a-4746-9e5b-f9551660bd4c', '0123456789', 23, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjUzMGVjY2E3LTM2YWMtNDRmZS05Nzc0LWIwYmMxNWJlMzI5YSIsImlhdCI6MTc1NDUwNzU1MiwiZXhwIjoxNzU3MDk5NTUyfQ.b94Im5y2MsYTgREMxaCZUQrA_LAJ3vwrxC7l1Jc-J4E', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1749196673660_1749196672973_image', 't', 't', 'f', '2024-11-04 18:19:27.651', '2025-08-07 15:49:22.752', 2984.60, 3, 4, 5, '', '<p><strong class="font-bold">I am who Iam</strong></p>', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1740646172213_smo_baclground.gif', 'a3ce227d-9052-4f0d-97a9-18995ac26980', 1, NULL);
INSERT INTO "public"."users" VALUES ('ba1b25ea-053b-4100-a4ad-a92959914eeb', 'lucan3', 'icaluca12+2@gmail.com', 'Kan Jame', '$2a$10$VaehRb39lzZab1orwAEUQ.W3xBEIsXJ3WzqRELlUwUnEZ2535OHAK', '7c2f4d9a-b10a-4746-9e5b-f9551660bd4c', NULL, 0, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiYTFiMjVlYS0wNTNiLTQxMDAtYTRhZC1hOTI5NTk5MTRlZWIiLCJ1c2VybmFtZSI6Imx1Y2FuMyIsImtleSI6ImM4ZDViYTMzLTBiZGItNDhhMi04NTkyLWMxNDEzNjE3ZWMzMCIsImlhdCI6MTc1MTQ0MjczNSwiZXhwIjoxNzU0MDM0NzM1fQ.XIL5M4uPmFUApc8QC1cyIOByq6a1b9KmlCeDQV5i6a8', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1747378125328_00009-4100874166-caadc88c06a642459ee4c3899e155f36.png', 'f', 'f', 'f', '2024-12-06 15:33:49.042', '2025-07-02 08:27:34.44', 1.00, 0, 0, 0, NULL, '', NULL, 'e7e2e7e4-ae5d-4be0-a9f6-1a2ebbd291bf', 0, NULL);
INSERT INTO "public"."users" VALUES ('898c5eed-1650-4a27-9ae1-45fec186d37e', 'propro2421', 'user131@example.com', 'tx123', '$2a$10$bF3p05GcdHW2j3Z187rF2O74NOsK.WA14doFxpz2HheiUlckVuAAq', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI4OThjNWVlZC0xNjUwLTRhMjctOWFlMS00NWZlYzE4NmQzN2UiLCJ1c2VybmFtZSI6InByb3BybzI0MjEiLCJrZXkiOiI5NjdkYTExMy03Zjg2LTQ3M2UtYmRhMC1mYmI4NTM0Y2FlZmMiLCJpYXQiOjE3NTAzMTYyMjgsImV4cCI6MTc1MjkwODIyOH0.W1RnU9eEZiMNvE2JiYY8bi0wrmCaBvFo_OXl9zma5BY', NULL, 'f', 'f', 't', '2025-06-19 06:57:07.945', '2025-06-26 08:16:17.471', 0.00, 0, 1, 0, 'devpro', NULL, NULL, '62692e7b-7b44-4c8c-95c9-e8b0be483359', 0, NULL);
INSERT INTO "public"."users" VALUES ('b6dcff8d-c61b-4346-a60d-682da15baef9', 'nodejs2', 'nodejs.ica1+n1@gmail.com', 'Kiím MS', '$2a$10$oYXRKwdXLyU/MHXYI5fxlOJcQRiCpd5FML1aTGIJIrhkCcvw/h9lW', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, 22, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiNmRjZmY4ZC1jNjFiLTQzNDYtYTYwZC02ODJkYTE1YmFlZjkiLCJ1c2VybmFtZSI6Im5vZGVqczIiLCJrZXkiOiI0NmM2M2QwMC04YTg4LTQwODUtOTMyNS05MGFlM2ZkNjhmMTIiLCJpYXQiOjE3NDE3OTYyNjQsImV4cCI6MTc0NDM4ODI2NH0.Ji9PXM1C_XEK0_tLMD1CFPg56TonaaMJc3UPMold9oU', NULL, 'f', 'f', 'f', '2025-03-12 16:16:35.462', '2025-06-26 08:15:55.393', 0.00, 0, 0, 0, 'Kiím MS', '<p></p>', NULL, '61ccaa46-79b6-4d92-911c-8cc8007ac4ac', 0, NULL);
INSERT INTO "public"."users" VALUES ('1ea6fe50-6ebb-43cc-acd1-e3b094e36238', 'nodejs1', 'nodejs.ica1@gmail.com', 'Kiím MS', '$2a$10$u5numZ8XSsmd1Z9jCse7VOrn/xvET3Rp24ZsZApD3Ys2nIy3.Ze7.', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxZWE2ZmU1MC02ZWJiLTQzY2MtYWNkMS1lM2IwOTRlMzYyMzgiLCJ1c2VybmFtZSI6Im5vZGVqczEiLCJrZXkiOiJmYWFmMWMwNi02NzU5LTQ3NTgtOTg4Yy0zYjQyNTBlZTFiOTYiLCJpYXQiOjE3NDAyMDg4ODcsImV4cCI6MTc0MjgwMDg4N30.4ZuZCSaRZgIk5urUo_f26oY2alh6_fOX93-rHQC_XZk', NULL, 'f', 'f', 'f', '2025-02-22 07:21:27.074', '2025-06-26 08:15:55.393', 0.00, 0, 0, 0, 'Kiím MS', NULL, NULL, NULL, 0, NULL);
INSERT INTO "public"."users" VALUES ('37739086-9b6f-42ac-96ce-1cc81a56dd6d', 'yenvydethuong2806+2', 'ogyminecraft497+2@gmail.com', 'pham thi yen vy', '$2a$10$d8LtvWWPNC5Yi7u9Iscl2urGTH0VV18QZ4e.S0sBXpU01ziKZ.Byy', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 0, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiJmYTQ5YmFiZS02NzZlLTQyMDQtODgyZC0xODcxZDYyNGM5MWEiLCJ1c2VySWQiOiIzNzczOTA4Ni05YjZmLTQyYWMtOTZjZS0xY2M4MWE1NmRkNmQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2KzIiLCJrZXkiOiIxNDlkZTQ5Ny0yNGUzLTRjNWItYWIxMC1mMTMxYTA2MDk2MDgiLCJpYXQiOjE3MzIzMzYwMTQsImV4cCI6MTczNDkyODAxNH0.z_8lobLg-kMlNPYb2JgsZfiaqTzFAE-1-XhAA4XzchA', NULL, 'f', 'f', 't', '2024-11-23 04:26:53.327', '2025-06-26 08:16:17.471', 0.00, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL);
INSERT INTO "public"."users" VALUES ('46d96705-4f8d-475d-8527-995ff185ca89', 'testuser1', 'testuser1@gmail.com', 'Luca Test', '$2a$10$q8KxJieBlWeOPkQhcNKtGuWfqJ/V.tqRp55RKTEdLn8PFxO9c5Gum', '588b1a65-426a-468c-9365-dc1c9b851a79', '0909090909', 22, NULL, NULL, 't', 'f', 'f', '2025-06-25 17:31:19.638', '2025-08-07 15:49:22.752', 1.00, 1, 0, 0, 'testuser1', 'aaa', NULL, 'e54984d0-4546-40e3-ac23-0bdecd016642', 0, NULL);
INSERT INTO "public"."users" VALUES ('4efe35df-757f-4ee4-b5bd-7aa7349ce5c8', 'haosinguoiao', 'minhnghi22@riotgame.com', 'Trần Nguyễn MInh Nghi', '$2a$10$4ceaGS8S/TXITJGrNoD/R.3yO2dJ2R7mIOFaqeupV6ULBkwARQcHi', 'e741110a-432d-4c02-acf4-4ba4428f37b7', NULL, 0, NULL, NULL, 't', 't', 't', '2025-06-28 06:59:41.946', '2025-07-02 08:38:43.841', 0.00, 0, 0, 0, 'minhnghineeee', '<p>toi ghet lien minh</p>', NULL, '176dd3e1-77e9-4fa3-b1ac-7e109316aba1', 0, NULL);
INSERT INTO "public"."users" VALUES ('95cf9878-6d9f-469a-a07d-331453dce25c', 'ThoBiGay', 'tientho2004@gmail.com', 'Nguyễn Tiến Thọ', '$2a$10$9mt.FpWLK7NPMh3id5tXH.n/7wbfQtm8Isggq9vHagYFH4vHIL3FO', 'e741110a-432d-4c02-acf4-4ba4428f37b7', NULL, 0, NULL, NULL, 't', 'f', 'f', '2025-06-27 09:05:06.97', '2025-07-12 06:41:29.662', 999.00, 0, 0, 0, 'ThoGyGo', '<p>lòng tôi đâu đớn khi nhân ra <br><strong class="font-bold">TÔI LÀ GAY</strong></p>', NULL, 'e0d3535e-7eec-4fcc-92ba-0a615b52c413', 0, NULL);
INSERT INTO "public"."users" VALUES ('9e0c791c-c424-43fa-9c48-d73b11796ec9', 'yukicute123', 'ogyminecraft497+yummi@gmail.com', 'Dang Yuki', '$2a$10$auxtCL7wLyhFDP1ob4RxxO1F72w93pWGEt9WHnXZT.XscZmuxUr36', '0c2d5733-69d0-4268-8a60-b39997f656b6', '0356618560', 20, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiYTM0YTQxNzItNjRjMC00ZDJkLTg4YmMtYWZjYjk0NGM5NzIyIiwiaWF0IjoxNzU0MDYyMTAxLCJleHAiOjE3NTY2NTQxMDF9.2H8ma29-Q2mygK4yLeD4I-u5THF8_JHjWUi_qCPgVz0', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1750777040252_1750777040194_image', 't', 't', 'f', '2024-12-17 14:43:31.915', '2025-08-06 18:26:52.503', 5615.40, 4, 3, 13, 'devYuki', '<p><strong class="font-bold"><em class="font-italic">SMO Team</em></strong><br>❤️LucaN/LeoN❤️</p><p>🔥 Web Developer<br>🌸YouTube Premium, Adobe, Vercel Pro, Mega,...</p>', 'https://link.storjshare.io/raw/jusfd6syx6gaux5wo6iyhqbyak6q/smo-space/uploads/public/2025/1750777185209_504193226_716185870920601_1900189960928916806_n.jpg', '82ea8d96-c699-462e-8dfd-1790da054be4', 0, NULL);

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

-- ----------------------------
-- Primary Key structure for table auth_codes
-- ----------------------------
ALTER TABLE "public"."auth_codes" ADD CONSTRAINT "auth_codes_pkey" PRIMARY KEY ("id");

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

-- ----------------------------
-- Primary Key structure for table posts
-- ----------------------------
ALTER TABLE "public"."posts" ADD CONSTRAINT "posts_pkey" PRIMARY KEY ("id");

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
