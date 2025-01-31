/*
 Navicat Premium Data Transfer

 Source Server         : smo_space_postgre
 Source Server Type    : PostgreSQL
 Source Server Version : 150008 (150008)
 Source Host           : be2pkmohflpkwo91kyhn-postgresql.services.clever-cloud.com:7234
 Source Catalog        : be2pkmohflpkwo91kyhn
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 150008 (150008)
 File Encoding         : 65001

 Date: 29/01/2025 15:34:10
*/


-- ----------------------------
-- Table structure for active_codes
-- ----------------------------
DROP TABLE IF EXISTS "public"."active_codes";
CREATE TABLE "public"."active_codes" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "code" text COLLATE "pg_catalog"."default" NOT NULL,
  "isActive" bool NOT NULL DEFAULT false,
  "expires_at" timestamp(3) NOT NULL,
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of active_codes
-- ----------------------------
INSERT INTO "public"."active_codes" VALUES ('3c1d3b23-efba-4a3e-94db-0c753198ed34', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'C58490', 'f', '2024-11-10 11:36:36.005', '2024-11-10 11:26:36.005');
INSERT INTO "public"."active_codes" VALUES ('f3674a59-2317-49ba-b443-69b17b1f321c', '37739086-9b6f-42ac-96ce-1cc81a56dd6d', '8E20FC', 'f', '2024-11-23 04:36:54.337', '2024-11-23 04:26:54.337');
INSERT INTO "public"."active_codes" VALUES ('41eb97ff-56ea-4acd-8cff-0397c3f8c4e8', '65904792-fdd5-45e3-a892-830a4640fd9b', '09913D', 'f', '2024-11-25 04:35:12.46', '2024-11-25 04:25:12.46');
INSERT INTO "public"."active_codes" VALUES ('3976c305-53fb-497d-b12b-8c35766c7b96', '084b617e-c89c-44ff-8dc9-7c1aa4f7730e', '3D8DB6', 'f', '2024-11-29 03:16:29.482', '2024-11-29 03:06:29.482');

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
INSERT INTO "public"."follows" VALUES ('5934c8d8-c4bd-49c6-b897-c1db671d10ad', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '9df351a4-a867-460f-9453-7105223b9e80', '2024-12-28 09:29:25.501');
INSERT INTO "public"."follows" VALUES ('d905fa20-38ae-4308-ba1c-a48f6f25ad23', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-01-03 17:35:06.79');
INSERT INTO "public"."follows" VALUES ('759dad42-abeb-4ddb-89db-63cb3855d587', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'caa2265d-5196-4a67-831e-85f91866fb8b', '2024-12-30 07:09:42.166');
INSERT INTO "public"."follows" VALUES ('2253c169-9362-4f33-a814-f3ca27b31cdc', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '37739086-9b6f-42ac-96ce-1cc81a56dd6d', '2025-01-06 07:28:40.003');
INSERT INTO "public"."follows" VALUES ('64f7354a-6264-4849-b77a-4d66fec85465', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2025-01-06 08:13:56.758');
INSERT INTO "public"."follows" VALUES ('25ee59b3-d963-4b54-98a3-9bfd6720f814', '49d9e3c0-ec00-48f0-86d3-293549c246dd', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-01-07 06:13:55.7');
INSERT INTO "public"."follows" VALUES ('0eb19c4f-a9da-48e5-a3b5-59d13ae89ad3', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-01-07 06:14:03.555');
INSERT INTO "public"."follows" VALUES ('23fbfb8b-6f42-461a-a81f-97e5f3fec363', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '2025-01-07 09:26:12.902');
INSERT INTO "public"."follows" VALUES ('7c515fbe-3d1f-4f67-b8b8-8b95bd05bc56', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2025-01-07 09:30:41.232');
INSERT INTO "public"."follows" VALUES ('f21b2c56-a16e-4bb4-8c7b-0ad47b72d842', '084b617e-c89c-44ff-8dc9-7c1aa4f7730e', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-01-08 04:16:46.655');
INSERT INTO "public"."follows" VALUES ('03f88e03-76d6-4f5a-84fb-b1b2cb874c77', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', '2025-01-07 04:34:43.148');
INSERT INTO "public"."follows" VALUES ('7bb6671c-0a0d-4ae3-84a3-a8d14cf9281d', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '084b617e-c89c-44ff-8dc9-7c1aa4f7730e', '2025-01-08 06:14:11.594');
INSERT INTO "public"."follows" VALUES ('a46a3f6f-00fc-4ebc-8681-b4ea96b08b0e', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-01-08 09:07:05.047');
INSERT INTO "public"."follows" VALUES ('a0c40316-d126-4112-81fa-03ac0a704ced', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', '2025-01-27 11:40:28.984');

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
INSERT INTO "public"."notifications" VALUES ('2be3cdb5-6174-44f3-bf00-473377730692', 'a804b1bb-e92d-448d-a3b4-cd648c0f7985', 'FOLLOW', 'NORMAL', 'f', 'f', '{"title": "New Follower", "message": "lucan1 started following you"}', '{"follower": {"id": "a0c40316-d126-4112-81fa-03ac0a704ced", "avatar": "https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1731137327615_00002-1468083896.png", "fullName": "Luca Nguyen", "username": "lucan1"}}', 'ba1b25ea-053b-4100-a4ad-a92959914eeb', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-01-27 11:40:29.757', NULL);

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
INSERT INTO "public"."post_comments" VALUES ('294427b9-8685-4de2-907d-fd90daf0d251', 'Có thể bạn chưa biết : Đây là 1 cái comment<br>#Comment', '1a5c682b-f562-4019-ac10-de63f1aa0649', NULL, '2025-01-13 08:11:56.98', '2025-01-19 07:21:30.397', 0, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 1);
INSERT INTO "public"."post_comments" VALUES ('0c4b605b-df25-428a-89be-c754edca1a5b', '<p>đúng đúng<br>anh BE gánh còng lưng</p>', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', 'b76a3a74-e582-4253-ba5c-fe8f16bb8465', '2025-01-18 06:23:24.747', '2025-01-18 06:23:59.387', 2, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 1);
INSERT INTO "public"."post_comments" VALUES ('b76a3a74-e582-4253-ba5c-fe8f16bb8465', '<p>về  system thì 10 điểm :3</p>', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', '0dce815c-eb60-4146-bb1a-d8de5c4ecf33', '2025-01-18 06:23:12.979', '2025-01-18 06:24:22.503', 1, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 0);
INSERT INTO "public"."post_comments" VALUES ('0dce815c-eb60-4146-bb1a-d8de5c4ecf33', '<p>về mặt trải nghiệm thì mình thấy  hiệu năng của mxh này rất tối<br>các tính năng <strong classname="font-bold"><em classname="font-italic">AI  </em></strong>cực kỳ bắt trend :3</p>', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', NULL, '2025-01-18 06:22:33.508', '2025-01-18 06:23:12.979', 0, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 1);
INSERT INTO "public"."post_comments" VALUES ('db6eabd7-1f34-42f3-a820-176157a74472', '<p>hic :(( thằng FE thì <strong classname="font-bold">mất dạy</strong> gặp ông BE <strong classname="font-bold">chu đáo </strong>:(( tự mình phá huỷ chính mình :))) thật hài hước đúng chứ <strong classname="font-bold"><em classname="font-italic">Duki </em></strong>💘</p><p></p>', '7cf32254-dc2d-44ff-904b-6d23d6aba6e7', NULL, '2025-01-13 14:46:24.286', '2025-01-14 15:33:28.928', 0, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 1);
INSERT INTO "public"."post_comments" VALUES ('0908a9ea-09e3-4809-b409-9e5404246303', '<p>chia sẽ cho thầy đi </p><p></p>', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', NULL, '2025-01-18 13:48:05.911', '2025-01-18 13:49:28.636', 0, '49d9e3c0-ec00-48f0-86d3-293549c246dd', 0);
INSERT INTO "public"."post_comments" VALUES ('f8af652a-8313-4a55-b069-fb59a33961bc', '<p><strong classname="font-bold">Lorem Ipsum</strong> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p>', 'de33bbdb-3bcc-4094-a392-0403f0f20cbd', NULL, '2025-01-17 06:27:49.561', '2025-01-20 09:51:53.811', 0, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 0);
INSERT INTO "public"."post_comments" VALUES ('5222308b-9ab6-431e-b27c-67cb36187d9b', '<p>Ồ :))</p>', '1a5c682b-f562-4019-ac10-de63f1aa0649', '294427b9-8685-4de2-907d-fd90daf0d251', '2025-01-19 07:21:30.397', '2025-01-20 06:34:44.48', 1, 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 0);
INSERT INTO "public"."post_comments" VALUES ('459011d9-c8be-4011-b4e0-6eb66523d1f7', '<p>mình chỉ còn một mình họ :((  mất họ rồi mình chẳng còn gì nữa :(( mình cố tình trở nên hài hước thú vị để họ vui  nhưng có  vẻ như mình đã chợt quên mất rằng bản thân cư  sử  đúng mực  cậu ạ :((<br>đúng não cá vàng luôn :(( ngu ơi là nguuuu</p>', '7cf32254-dc2d-44ff-904b-6d23d6aba6e7', 'db6eabd7-1f34-42f3-a820-176157a74472', '2025-01-14 13:57:43.521', '2025-01-20 13:14:05.33', 1, '9e0c791c-c424-43fa-9c48-d73b11796ec9', 0);

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
INSERT INTO "public"."post_likes" VALUES ('3e23fd0d-ea74-4cdb-8d17-370e3b515da7', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '128e9eec-60e4-4d10-8868-24bddfe01d7e', '2024-12-20 14:28:59.256');
INSERT INTO "public"."post_likes" VALUES ('32a4b9cd-e584-4a14-96ba-c766e38cffba', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '98233ab4-abda-4db5-8b75-b0fc8909f9ef', '2024-12-20 14:29:01.388');
INSERT INTO "public"."post_likes" VALUES ('b1c62bc7-c511-4d65-8037-47334247c63c', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '0a2b1901-c2fc-437d-b0f7-cb95895735f9', '2025-01-11 06:35:26.142');
INSERT INTO "public"."post_likes" VALUES ('cb951ec9-9ac3-4e91-81d0-bb94a714ebd3', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '9bd04ce1-3187-4ad4-b096-666bacd7c810', '2025-01-06 08:19:40.63');
INSERT INTO "public"."post_likes" VALUES ('d08624d4-c387-4947-8dd3-f84a1195ed27', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '59f85f60-a7b7-43f2-a2c8-ab75fc66bb48', '2025-01-08 09:33:36');
INSERT INTO "public"."post_likes" VALUES ('77c1e54f-07e4-4ea1-af55-5b3007cbb4ce', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '8f285b33-6e15-48b4-9fc1-46d09ac5dde6', '2025-01-06 08:23:51.38');
INSERT INTO "public"."post_likes" VALUES ('d970fcd0-e1ed-4de5-ae8b-285d2d85eea1', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '10374432-832f-4135-b87e-d00ef6b1d3d5', '2025-01-11 09:55:42.815');
INSERT INTO "public"."post_likes" VALUES ('00ab6680-36f4-4011-a2b0-904362a1d04a', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '5943e205-8dff-49f9-8eb5-9947336c9343', '2025-01-07 09:12:04.782');
INSERT INTO "public"."post_likes" VALUES ('0af39c47-5dae-4e94-8a38-2154aef128fe', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '10374432-832f-4135-b87e-d00ef6b1d3d5', '2025-01-06 08:49:04.472');
INSERT INTO "public"."post_likes" VALUES ('644db4fa-682a-4f15-9403-7b07d3712685', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'b5cc9911-e908-45e5-afb3-981e15399c9e', '2025-01-06 08:49:32.415');
INSERT INTO "public"."post_likes" VALUES ('392ecbbc-6bac-4e83-ac99-c6f157ee7cef', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', '2025-01-12 15:04:42.463');
INSERT INTO "public"."post_likes" VALUES ('2f0c6b28-fe7e-459e-8f91-27542df3ba2e', '49d9e3c0-ec00-48f0-86d3-293549c246dd', 'b5cc9911-e908-45e5-afb3-981e15399c9e', '2024-12-19 06:02:38.066');
INSERT INTO "public"."post_likes" VALUES ('5a744d4c-3491-407e-a750-ae3816c2e19e', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'ee207bbe-481f-4c0f-ad31-a29fddd0d350', '2025-01-15 13:19:44.988');
INSERT INTO "public"."post_likes" VALUES ('9eecbc0e-5473-408d-b637-e44a104586bd', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '1a5c682b-f562-4019-ac10-de63f1aa0649', '2025-01-17 08:57:29.33');
INSERT INTO "public"."post_likes" VALUES ('dd01d1a2-055f-4596-b3f7-2468f556eabd', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '1a5c682b-f562-4019-ac10-de63f1aa0649', '2025-01-18 12:03:23.503');

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
INSERT INTO "public"."posts" VALUES ('1d24031c-07c5-44f1-a796-9eeed4330893', '<p>js  so goood</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-20 14:00:40.742', '2025-01-10 09:24:05.539', 'f', 0, 0);
INSERT INTO "public"."posts" VALUES ('98233ab4-abda-4db5-8b75-b0fc8909f9ef', '<p><span class=\"font-bold\">Công nghệ trí tuệ nhân tạo (AI)</span> đang trở thành một trong những xu hướng phát triển mạnh mẽ nhất trong thời đại số ngày nay. Từ việc tự động hóa quy trình làm việc đến nâng cao trải nghiệm người dùng, AI đang góp phần thay đổi cách chúng ta sống và làm việc. <br> <span class=\"font-italic\">Bạn có bao giờ nghĩ rằng một ngày nào đó máy tính có thể hiểu và học hỏi giống như con người?</span> Thực tế, chúng ta đang sống trong thời kỳ mà điều đó không chỉ là một giấc mơ nữa. <br> <span class=\"font-bold\">Những ứng dụng của AI</span> rất đa dạng, từ chatbot hỗ trợ khách hàng, trợ lý ảo như Siri hay Google Assistant, cho đến các hệ thống phân tích dữ liệu để giúp doanh nghiệp ra quyết định nhanh chóng hơn. Hơn thế nữa, AI còn được ứng dụng trong lĩnh vực y tế, tài chính và nhiều ngành nghề khác, mang lại hiệu quả và giá trị to lớn. <br> Chắc chắn rằng trong tương lai, công nghệ này sẽ tiếp tục phát triển và đem lại nhiều điều kỳ diệu hơn nữa. Hãy cùng nhau chờ xem những điều gì thú vị đang chờ đón chúng ta! <br> <span class=\"font-italic\">Công nghệ là tương lai, và AI chính là cầu nối để chúng ta bước vào thế giới mới!</span></p><br><br>#Technology #AI #Innovation #Future #Digitization', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-19 10:07:57.744', '2025-01-06 15:00:08.032', 'f', 1, 0);
INSERT INTO "public"."posts" VALUES ('59f85f60-a7b7-43f2-a2c8-ab75fc66bb48', '<p><em class="font-italic">Họ cười tôi vì tôi đang cười họ,</em></p><p><em class="font-italic">Tôi cười họ, họ bu lại cười tôi!</em></p><p></p><p>#suyngam #đáng_tiền_mạng #chữa_lành</p>', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2024-12-21 18:44:45.273', '2025-01-08 09:33:36', 'f', 2, 0);
INSERT INTO "public"."posts" VALUES ('9bd04ce1-3187-4ad4-b096-666bacd7c810', '<p><strong class="font-bold">FAP TV</strong> là một trong những nhóm hài nổi tiếng tại Việt Nam, được thành lập vào năm 2013. Nhóm nổi bật với các video hài hước, những clip ngắn đầy tính giải trí và ý nghĩa. <em class="font-italic">FAP TV không chỉ mang đến cho khán giả tiếng cười, mà còn là những thông điệp sâu sắc về cuộc sống, tình bạn, tình yêu và gia đình.</em> <br><br>Các thành viên của nhóm bao gồm những người trẻ tài năng như: Hiếu Nguyễn, Vinh Râu, và một số nghệ sĩ trẻ khác. Họ đã xây dựng một lượng fan hùng hậu nhờ vào sự sáng tạo và đam mê trong từng sản phẩm. <strong class="font-bold">Với những video đậm chất giải trí, FAP TV đã thu hút hàng triệu lượt xem và theo dõi trên các nền tảng mạng xã hội.</strong><br><br>Hãy cùng đón xem và ủng hộ những sản phẩm mới của FAP TV nhé! <br><br>#FAPTV #ComedyVietnam #HilariousContent #comnguoi</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-20 14:21:14.88', '2025-01-06 08:19:40.63', 'f', 1, 0);
INSERT INTO "public"."posts" VALUES ('8f285b33-6e15-48b4-9fc1-46d09ac5dde6', '<p><strong classname="font-bold">Ribi Sachi - Nàng công chúa trong lòng khán giả</strong> <br><br>Ribi Sachi, một cái tên không còn xa lạ với cộng đồng yêu thích phim ảnh Việt Nam, đặc biệt là những người hâm mộ FAP TV. Cô không chỉ được biết đến với tài năng diễn xuất xuất sắc mà còn chinh phục khán giả bằng vẻ đẹp và phong cách độc đáo của mình. <br><br><em classname="font-italic">Với sự nghiệp diễn xuất đầy ấn tượng, Ribi đã ghi dấu ấn trong nhiều bộ phim hài hước và những chương trình giải trí hấp dẫn. Hình ảnh của cô trong các video của FAP TV luôn mang đến những tiếng cười vui vẻ, đầy ngẫu hứng và khiến người xem phải trầm trồ. Sự duyên dáng và khả năng biểu cảm sinh động của cô đã khiến nhân vật của Ribi trở nên gần gũi và dễ mến.</em> <br><br>Bên cạnh đó, Ribi Sachi còn là một người năng động trên mạng xã hội. Cô thường xuyên chia sẻ những khoảnh khắc đời thường, những buổi chụp hình vui vẻ và cả những câu chuyện ý nghĩa trong cuộc sống. Điều này không chỉ giúp khán giả hiểu rõ hơn về cô mà còn tạo nên một cộng đồng gắn kết và thân thiện.<br><br><strong classname="font-bold">Với những nỗ lực không ngừng, Ribi Sachi xứng đáng là một trong những ngôi sao triển vọng của làng giải trí Việt Nam.</strong> Hãy cùng theo dõi và ủng hộ cô trong các dự án sắp tới nhé!<br><br>#RibiSachi #FAPTV #VietnameseActress #Comedy #Entertainment</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-20 14:44:33.172', '2025-01-06 14:40:27.111', 'f', 1, 0);
INSERT INTO "public"."posts" VALUES ('1a5c682b-f562-4019-ac10-de63f1aa0649', '<p><strong class="font-bold">hihi2</strong></p>', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-01-11 06:43:24.502', '2025-01-20 06:34:44.48', 'f', 2, 2);
INSERT INTO "public"."posts" VALUES ('de33bbdb-3bcc-4094-a392-0403f0f20cbd', '<p>💕LucaN/LeoN💕</p><p>#Friend</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-01-08 07:47:56.517', '2025-01-20 12:54:41.298', 't', 0, 1);
INSERT INTO "public"."posts" VALUES ('e0c5c74b-c2d8-420c-8d88-b8463af80f5b', '<p>tại cái não cá vàng hết 😢</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-01-20 13:15:41.883', '2025-01-21 06:50:17.052', 't', 0, 0);
INSERT INTO "public"."posts" VALUES ('0a2b1901-c2fc-437d-b0f7-cb95895735f9', '<p>Trong năm 2024, <strong class="font-bold">câu chuyện về AI trong lập trình đang trở nên ngày càng thú vị và đầy hứa hẹn</strong>. Nhiều nhà phát triển đã bắt đầu áp dụng trí tuệ nhân tạo để tự động hóa các quy trình lập trình. Điều này giúp họ tiết kiệm thời gian và nâng cao hiệu suất làm việc.<br><br><strong class="font-bold">Hệ thống lập trình tự động được phát triển ngày càng tinh vi</strong>, không chỉ giúp viết mã mà còn đưa ra các đề xuất tối ưu hóa. Các công cụ như GitHub Copilot đã trở thành người bạn đồng hành không thể thiếu của lập trình viên. Ngoài ra, AI còn hỗ trợ trong việc kiểm tra lỗi và bảo trì mã nguồn, từ đó cải thiện chất lượng sản phẩm.<br><br><em class="font-italic">Một trong những xu hướng nổi bật là sử dụng AI để phân tích dữ liệu lớn, từ đó giúp các nhóm lập trình đưa ra quyết định tốt hơn trong việc phát triển sản phẩm</em>. Chúng ta có thể thấy những cải tiến trong việc phát triển ứng dụng di động, phần mềm doanh nghiệp và thậm chí là trong lĩnh vực trí tuệ nhân tạo.<br><br>Năm 2024 hứa hẹn sẽ mang đến nhiều cơ hội mới cho lập trình viên khi họ có thể tận dụng sức mạnh của AI. Hãy cùng theo dõi và khám phá những điều bất ngờ mà AI mang lại cho ngành lập trình nhé!<br><br>#AI #Programming #TechTrends</p>', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2024-12-22 15:33:22.377', '2025-01-11 09:55:31.736', 'f', 1, 0);
INSERT INTO "public"."posts" VALUES ('128e9eec-60e4-4d10-8868-24bddfe01d7e', '<p>Trong thời đại công nghệ thông tin bùng nổ, trí tuệ nhân tạo (AI) đang trở thành một phần không thể thiếu trong cuộc sống và công việc hàng ngày. Tuy nhiên, <strong classname="font-bold">lạm dụng AI trong lập trình có thể dẫn đến những hệ lụy nghiêm trọng, khiến chúng ta trở nên "ngu đi".</strong> <br><br>Khi chúng ta quá phụ thuộc vào các công cụ AI để viết mã, kiểm tra lỗi hay tối ưu hóa quá trình phát triển phần mềm, <em classname="font-italic">kỹ năng lập trình và khả năng giải quyết vấn đề của con người sẽ dần mai một.</em> Chúng ta có thể rơi vào tình trạng "thuộc lòng" các lệnh và phương pháp mà AI đưa ra mà không hiểu rõ bản chất và logic phía sau chúng. <br><br>Việc quá dựa dẫm vào AI không chỉ ảnh hưởng đến trình độ cá nhân mà còn đến chất lượng chung của sản phẩm. Khi lập trình viên không còn thảo luận và tranh luận về các giải pháp, những sai sót có thể xuất hiện mà không ai nhận ra. Hơn nữa, các thuật toán có thể dẫn đến những quyết định sai lầm nếu không có sự cân nhắc kỹ lưỡng từ con người. <br><br><strong classname="font-bold">Do đó, chúng ta cần phải tìm ra cách cân bằng giữa sử dụng AI và giữ vững khả năng tư duy và giải quyết vấn đề của bản thân.</strong> Hãy luôn tự rèn luyện, học hỏi và nhớ rằng <em classname="font-italic">AI chỉ là một công cụ hỗ trợ, không phải là một giải pháp thay thế cho con người.</em> <br><br>#AIDependency #CodingSkills #TechBalance #StayCurious #LearnToCode</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-20 08:39:50.039', '2025-01-07 08:56:50.4', 'f', 1, 0);
INSERT INTO "public"."posts" VALUES ('7cf32254-dc2d-44ff-904b-6d23d6aba6e7', '<p>Yuki đã tìm đc điểm để  dừng chân :3 trao trọn con tym bé nhỏ đầy vết  xước</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2025-01-07 06:46:42.842', '2025-01-20 13:49:31.894', 'f', 1, 2);
INSERT INTO "public"."posts" VALUES ('5943e205-8dff-49f9-8eb5-9947336c9343', '<p><strong classname="font-bold">Hành trình lập trình của bạn có thể không giống ai, nhưng đó chính là sức mạnh của bạn!</strong> <br><br>Khiếm thị không phải là rào cản mà là một cơ hội để phát triển những kỹ năng độc đáo mà chỉ bạn mới có. <em classname="font-italic">Hãy tưởng tượng</em> bạn đang tạo ra những dòng mã mà không cần nhìn thấy màn hình. Đó chính là sự sáng tạo và sức mạnh của trí tưởng tượng! <br><br>Bước vào thế giới lập trình, bạn đang khám phá không chỉ là những cú pháp hay thuật toán mà còn là khả năng tự vượt qua chính mình. <strong classname="font-bold">Mỗi dòng mã bạn viết ra là một bước tiến, mỗi lỗi sai là một bài học quý giá.</strong> Hãy nhận ra rằng bạn không đơn độc trên con đường này. Có rất nhiều tài nguyên hỗ trợ cho người khiếm thị, từ phần mềm đọc màn hình đến cộng đồng lập trình viên sẵn lòng giúp đỡ. <br><br>Hãy đặt mục tiêu cho bản thân và kiên trì theo đuổi. <em classname="font-italic">Chắc chắn rằng bạn có thể biến đam mê lập trình thành hiện thực</em>, và bạn sẽ chứng minh cho thế giới thấy rằng không gì là không thể! <br><br>Hãy nhớ, mỗi cú click chuột hay mỗi dòng lệnh đều đang khẳng định giá trị của bạn. Bạn có thể làm được! <br><br>#Inspiration #BlindProgramming #CodingJourney</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-21 06:28:24.722', '2025-01-07 09:12:04.782', 'f', 1, 0);
INSERT INTO "public"."posts" VALUES ('352053c2-d22d-4896-95b9-6fe47e71c915', '<p>test private</p>', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2025-01-04 07:34:15.824', '2025-01-04 07:34:15.824', 't', 0, 0);
INSERT INTO "public"."posts" VALUES ('10374432-832f-4135-b87e-d00ef6b1d3d5', '<p>Trong JavaScript, <strong classname="font-bold">bất đồng bộ</strong> đề cập đến khả năng thực hiện các tác vụ mà không làm tắc nghẽn luồng chính của chương trình. Điều này có nghĩa là khi một tác vụ kéo dài (như một yêu cầu đến server hoặc một hoạt động đọc file) diễn ra, JavaScript vẫn có thể tiếp tục thực hiện các đoạn mã khác mà không bị chờ đợi.<br><br>Một trong những cách phổ biến để xử lý bất đồng bộ trong JavaScript là thông qua <em classname="font-italic">callback</em>, <em classname="font-italic">Promise</em> và <em classname="font-italic">async/await</em>. Các kỹ thuật này cho phép bạn quản lý các tác vụ chờ đợi một cách hiệu quả hơn, giúp mã của bạn trở nên dễ hiểu hơn.<br><br>Ví dụ, khi sử dụng <em classname="font-italic">Promise</em>, bạn có thể xử lý kết quả của một tác vụ bất đồng bộ một cách rõ ràng mà không cần phải lồng nhiều callback, đảm bảo mã của bạn vẫn dễ đọc và dễ bảo trì. <br><br><strong classname="font-bold">Bất đồng bộ</strong> là một phần quan trọng trong lập trình JavaScript, đặc biệt khi làm việc với các ứng dụng web, nơi nhiều tác vụ cần được thực hiện đồng thời mà không làm ảnh hưởng đến trải nghiệm người dùng.<br><br>#JavaScript #Asynchronous #Programming</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-22 14:56:41.677', '2025-01-17 09:06:53.338', 'f', 2, 0);
INSERT INTO "public"."posts" VALUES ('8f9db143-2783-4a2a-947e-2896560fad89', '<p><strong classname="font-bold">Mùa Noel luôn mang đến cho chúng ta những cảm xúc đặc biệt, và không gì tuyệt vời hơn khi được trải nghiệm không khí lạnh lẽo của mùa đông cùng người bạn đồng hành, anh mentor thân mến.</strong> <br><br><em classname="font-italic">Mỗi năm, khi những bông tuyết bắt đầu rơi, thành phố như chuyển mình trong một tấm áo mới. Đường phố được trang trí lấp lánh với đèn trang trí, những cây thông Noel đầy màu sắc. Những ngày này, việc ngồi bên cạnh anh mentor, cùng nhau thưởng thức ly cacao nóng, ngắm nhìn bầu trời đầy sao thật sự là những kỉ niệm không thể nào quên.</em> <br><br><strong classname="font-bold">Dưới cái lạnh của mùa đông, chúng ta có thể trò chuyện về bao điều, từ những giấc mơ trong năm tới cho đến những kỷ niệm đáng nhớ trong quá khứ. Anh mentor luôn biết cách mang lại cho tôi những lời khuyên quý giá, giúp tôi trưởng thành hơn từng ngày.</strong> <br><br><em classname="font-italic">Chúng ta cùng nhau trải qua những giây phút ấm áp bên ngọn nến lung linh, nhâm nhi những chiếc bánh mật ngọt ngào và chia sẻ những cảm xúc trong lòng giữa không gian lạnh lẽo nhưng đầy yêu thương.</em> <br><br><strong classname="font-bold">Noel không chỉ là dịp để nhận quà mà còn là thời điểm để tri ân, để yêu thương và kết nối với những người thân yêu. Hy vọng rằng mỗi mùa Noel đến, chúng ta lại có thêm những kỷ niệm đẹp bên nhau.</strong> <br><br>#Christmas #Friendship #HolidayVibes</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-22 13:16:31.9', '2025-01-18 07:04:55.013', 'f', 1, 0);
INSERT INTO "public"."posts" VALUES ('ee207bbe-481f-4c0f-ad31-a29fddd0d350', '<p>Chắc hẳn bạn đã từng nghe đến những mạng xã hội lớn như Facebook hay Instagram, nhưng đã bao giờ bạn thử khám phá một mạng xã hội thú vị mang tên Yukibook chưa? <strong classname="font-bold">Yukibook là một sản phẩm được phát triển bởi một bạn intern Frontend và một bạn Middle Backend siêu đỉnh, hứa hẹn mang đến cho người dùng những trải nghiệm mới mẻ và độc đáo.</strong><br><br>Khi lần đầu đăng nhập vào Yukibook, tôi cảm thấy vô cùng ấn tượng với giao diện thân thiện và dễ sử dụng. <em classname="font-italic">Mọi thứ đều rất trực quan, từ việc tạo bài viết cho đến kết bạn hay nhắn tin với bạn bè. Bạn sẽ không phải lo lắng về việc "lạc trôi" giữa những tính năng phức tạp.</em> <br><br>Điều đặc biệt ở Yukibook là cộng đồng thật sự gần gũi. Bạn có thể chia sẻ những khoảnh khắc đáng nhớ trong cuộc sống của mình và nhận được nhiều phản hồi tích cực từ những người bạn mới. <strong classname="font-bold">Những tính năng như tạo bài viết, bình luận, và thả tim rất dễ dàng, giúp bạn kết nối và thể hiện bản thân một cách tự nhiên nhất.</strong><br><br>Yukibook không chỉ đơn thuần là một nơi để kết nối, mà còn là một nền tảng để sáng tạo và chia sẻ. Bạn sẽ có cơ hội khám phá sở thích mới và tham gia vào những hoạt động thú vị từ cộng đồng. Hãy cùng khám phá Yukibook, chắc chắn rằng bạn sẽ tìm thấy niềm vui và sự kết nối mà bấy lâu nay mình tìm kiếm! <br><br>#Yukibook #SocialMedia #UserExperience #Community #Fun</p>', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '2025-01-06 14:29:55.718', '2025-01-18 13:54:23.073', 'f', 3, 4);

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

-- ----------------------------
-- Table structure for user_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."user_types";
CREATE TABLE "public"."user_types" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "type_name" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of user_types
-- ----------------------------
INSERT INTO "public"."user_types" VALUES ('588b1a65-426a-468c-9365-dc1c9b851a79', 'Member');
INSERT INTO "public"."user_types" VALUES ('7c2f4d9a-b10a-4746-9e5b-f9551660bd4c', 'VIP Member');
INSERT INTO "public"."user_types" VALUES ('0c2d5733-69d0-4268-8a60-b39997f656b6', 'Manager');
INSERT INTO "public"."user_types" VALUES ('e741110a-432d-4c02-acf4-4ba4428f37b7', 'Administrator');

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
  "cover_image" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO "public"."users" VALUES ('02ad241e-66a7-4e44-99fd-36fced0ca386', 'devYuki2005', 'ogyminecraft497@gmail.com', 'Dang Hoang Thien An', '$2b$10$ad05fk3RE8U90WLvHhjNwusDw4CXZ5RbotJ8mHVDB03xK9OwdgdRS', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiI4NDA3MmE0Ny1hNTRjLTQ1MzUtYTYwYS02NWY5Nzk1Zjc5YTAiLCJ1c2VySWQiOiIwMmFkMjQxZS02NmE3LTRlNDQtOTlmZC0zNmZjZWQwY2EzODYiLCJ1c2VybmFtZSI6ImRldll1a2kyMDA1Iiwia2V5IjoiZDEyMDMwNjItZTEwMS00ODc5LTg2NWMtY2FkOTFiMTBjMDdjIiwiaWF0IjoxNzMzMjc5MDUyLCJleHAiOjE3MzU4NzEwNTJ9.QkEEUKvzkBPMnrLFcdiOt9tKCU2ymGHiW4jY4-4Stfg', 'https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1731476400251_photo_2024-03-11_12-05-41.jpg', 't', 'f', 'f', '2024-11-05 13:25:27.937', '2025-01-07 09:30:41.232', 0.00, 1, 0, 0, NULL, NULL, NULL);
INSERT INTO "public"."users" VALUES ('9df351a4-a867-460f-9453-7105223b9e80', 'hgphienn', 'hgphien@gmail.com', 'pham tran hong phien', '$2a$10$VPmWSIXXHURJsQVUjTG5BO2XKGDeserf463Lq4Bw0tPXjFYanHzLe', '588b1a65-426a-468c-9365-dc1c9b851a79', '034444444', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiJjMjI2MTMzNC03MThlLTRkMmItOThjNi0wMDhmZjU4YjQ0NjUiLCJ1c2VySWQiOiI5ZGYzNTFhNC1hODY3LTQ2MGYtOTQ1My03MTA1MjIzYjllODAiLCJ1c2VybmFtZSI6ImhncGhpZW5uIiwia2V5IjoiNjBhYzdkYzItMmUyMS00MTM2LWJhNDItYmIyY2I5N2UxZTJlIiwiaWF0IjoxNzMyMjY5MDk0LCJleHAiOjE3MzQ4NjEwOTR9.jSn-oaWPHzeqWjw2lAq1c58z42ZlNLzt5KpSOIvAwRw', NULL, 'f', 'f', 'f', '2024-11-22 09:51:32.629', '2024-12-28 09:29:25.501', 0.00, 1, 0, 0, NULL, NULL, NULL);
INSERT INTO "public"."users" VALUES ('caa2265d-5196-4a67-831e-85f91866fb8b', 'kanjame', 'kanjame@gmail.com', 'Kan Jame', '$2a$10$hmzfMs28YHK46KQ8jcN4guxrObSsBL6hUSVsn/nwppUNIIe5DonuW', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, 0, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiI2ZjYwOTkzOS1jM2RlLTQ3M2ItYjcyMy00ZTQ2YWExNjE2ZWIiLCJ1c2VySWQiOiJjYWEyMjY1ZC01MTk2LTRhNjctODMxZS04NWY5MTg2NmZiOGIiLCJ1c2VybmFtZSI6ImthbmphbWUiLCJrZXkiOiJlN2UyMDkwNS0wNzJlLTRjNTItYjlkZS01NTYxYzEyYWQ2MzIiLCJpYXQiOjE3MzE0OTY0ODgsImV4cCI6MTczNDA4ODQ4OH0.EDsz6V5ET6JWif5-V1QtocnaPtRxD3s1y4obp6MCFoA', NULL, 'f', 'f', 'f', '2024-11-13 11:14:48.721', '2024-12-30 07:09:42.166', 0.00, 1, 0, 0, NULL, NULL, NULL);
INSERT INTO "public"."users" VALUES ('37739086-9b6f-42ac-96ce-1cc81a56dd6d', 'yenvydethuong2806+2', 'ogyminecraft497+2@gmail.com', 'pham thi yen vy', '$2a$10$d8LtvWWPNC5Yi7u9Iscl2urGTH0VV18QZ4e.S0sBXpU01ziKZ.Byy', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 0, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiJmYTQ5YmFiZS02NzZlLTQyMDQtODgyZC0xODcxZDYyNGM5MWEiLCJ1c2VySWQiOiIzNzczOTA4Ni05YjZmLTQyYWMtOTZjZS0xY2M4MWE1NmRkNmQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2KzIiLCJrZXkiOiIxNDlkZTQ5Ny0yNGUzLTRjNWItYWIxMC1mMTMxYTA2MDk2MDgiLCJpYXQiOjE3MzIzMzYwMTQsImV4cCI6MTczNDkyODAxNH0.z_8lobLg-kMlNPYb2JgsZfiaqTzFAE-1-XhAA4XzchA', NULL, 'f', 'f', 'f', '2024-11-23 04:26:53.327', '2025-01-06 07:28:40.003', 0.00, 1, 0, 0, NULL, NULL, NULL);
INSERT INTO "public"."users" VALUES ('49d9e3c0-ec00-48f0-86d3-293549c246dd', 'yenvydethuong2806', 'ogyminecraft497+1@gmail.com', 'Nana Haru', '$2a$10$7TYIFS8ZqDbn/.z6o9A2HuNY5G.6HxnM8.iEyKs3zsDkr4d6rsSyy', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0OWQ5ZTNjMC1lYzAwLTQ4ZjAtODZkMy0yOTM1NDljMjQ2ZGQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2Iiwia2V5IjoiMDgzNzRmYjEtMzAxMS00YWQ5LWEwNDMtMjllZTdjMTM1YzQwIiwiaWF0IjoxNzM3MzgwOTQ0LCJleHAiOjE3Mzk5NzI5NDR9.qXfLZlxt0f18NhrrkZYFlIVQF73vDRhcebSvn_a0wZo', 'https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1737210405917_photo_2024-03-11_12-05-44.jpg', 't', 'f', 'f', '2024-11-23 04:19:05.711', '2025-01-20 13:49:04.462', 2.20, 1, 2, 1, NULL, NULL, NULL);
INSERT INTO "public"."users" VALUES ('084b617e-c89c-44ff-8dc9-7c1aa4f7730e', 'yenvydethuong28063', 'ogyminecraft497+4@gmail.com', 'pham thi yen vy', '$2a$10$2pTODRB0PCD9wvkTeGn68.1U5arkkBavuLlExIbLg0hzg05..0Wkq', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIwODRiNjE3ZS1jODljLTQ0ZmYtOGRjOS03YzFhYTRmNzczMGUiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2MyIsImtleSI6ImViNzc1OTZkLWQ3MzAtNDhjNS04ZmI1LWMyYjU3NWQyODJmYSIsImlhdCI6MTczNjMwOTc5OCwiZXhwIjoxNzM4OTAxNzk4fQ.Nfeiwh6UEPlnyjd2kyOp-wwabURjTgUphRdROLVhOs0', NULL, 'f', 'f', 'f', '2024-11-29 02:56:03.329', '2025-01-08 06:14:11.594', 0.00, 1, 1, 0, NULL, NULL, NULL);
INSERT INTO "public"."users" VALUES ('65904792-fdd5-45e3-a892-830a4640fd9b', 'yenvydethuong28062', 'ogyminecraft497+3@gmail.com', 'pham thi yen vy', '$2a$10$Jl8Pytx1EBPd0.fauD/qvOISkLnKBwpIIgBjT1n4H9dvbqC2GHn4m', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 22, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTkwNDc5Mi1mZGQ1LTQ1ZTMtYTg5Mi04MzBhNDY0MGZkOWIiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2MiIsImtleSI6ImU2MDBjMmRiLWE0ZDUtNGJiZC05MjZlLTYwYmEzOTY1N2ZiOSIsImlhdCI6MTczNzQ0NjYwNywiZXhwIjoxNzQwMDM4NjA3fQ.8jp3tXjmt4slYtxQuPuWZ5FXy_WtFe7CYrCyWxzplX0', NULL, 'f', 'f', 'f', '2024-11-25 04:25:10.321', '2025-01-21 08:03:40.825', 0.00, 0, 0, 0, NULL, NULL, NULL);
INSERT INTO "public"."users" VALUES ('6a31a93a-a961-48d6-963e-0645f99de8e4', 'lucan2', 'lucan2@gmail.com', 'Luca N', '$2b$10$E399bydm4h2sAFu2Q4zCBuU8azipGf2KDjLf.Id9VcxGf28Rnq2bS', '588b1a65-426a-468c-9365-dc1c9b851a79', '0909090909', 23, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6IjQyMDE4NzY4LWQwNTEtNGM2OS05OTUyLTI2NmFkZDBhZWRkMSIsImlhdCI6MTczNzEwNDM2MiwiZXhwIjoxNzM5Njk2MzYyfQ.pUDFDTXC_YHkKbS10A2uz40iu0kdUDP8PhuzwhhYHMI', 'https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1734971185363_Snaptik.app_744868353203508353820.jpg', 'f', 'f', 'f', '2024-11-06 09:49:03.576', '2025-01-17 09:03:05.977', 1.40, 1, 1, 4, NULL, NULL, NULL);
INSERT INTO "public"."users" VALUES ('9e0c791c-c424-43fa-9c48-d73b11796ec9', 'yukicute123', 'yukidev2k5@smoteam.com', 'Dang Yuki (Frontend Developer)', '$2a$10$aFlVH426/pzmmwrC.Te/jOtVfNz/OUtYNg1A08rPD94wn95F64vBK', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356658758', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiNWE3ZGJhZDktMjQ1YS00M2JjLWE3YTUtMTM5ODNkZTRhNWJlIiwiaWF0IjoxNzM4MDkxNDkzLCJleHAiOjE3NDA2ODM0OTN9.kGHX2O0N2yiC2LMYzthUSAso6G1UltDFvgjEuuyQAx4', 'https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1736431193291_438196156_1002248498129871_1016470206629337226_n.jpg', 't', 't', 'f', '2024-12-17 14:43:31.915', '2025-01-28 19:11:33.378', 5627.20, 3, 9, 12, 'devYuki', '<p><strong classname="bold"><em classname="italic">      SMO Team</em></strong><br>❤️LucaN/LeoN❤️</p>', 'https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1737537614074_christmatebg.jpg');
INSERT INTO "public"."users" VALUES ('ba1b25ea-053b-4100-a4ad-a92959914eeb', 'lucan3', 'icaluca12+2@gmail.com', 'Kan Jame', '$2a$10$Rnfw5j96Z9X7hXS424b.D.F3o0wro1N.xm8cy/VDIgOmE2tXs5FNi', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, 0, NULL, NULL, 'f', 'f', 'f', '2024-12-06 15:33:49.042', '2025-01-27 11:40:28.984', 0.00, 2, 0, 0, NULL, NULL, NULL);
INSERT INTO "public"."users" VALUES ('d66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'lucan1', 'icaluca12@gmail.com', 'Luca Nguyen', '$2b$10$fCvpEVrdjINF2mloEiISKu4Yo1wMveQkg5t/4IuHcqE3gm1dmgFVq', '588b1a65-426a-468c-9365-dc1c9b851a79', '0909090909', 25, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6ImVhYWEyNGQxLTBiZDMtNGE0MC04OWFiLWI5NjEyOTU2OGJjYiIsImlhdCI6MTczODEzOTU4MywiZXhwIjoxNzQwNzMxNTgzfQ.BErYXfeUI_6z8tEdphab8nLLm3BuMjX5LW93fHBr1ZA', 'https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1731137327615_00002-1468083896.png', 'f', 't', 'f', '2024-11-04 18:19:27.651', '2025-01-29 08:33:03.099', 99950.00, 2, 2, 23, NULL, '<p>I am who i am</p>', 'https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1737382729273_5987-shooting-stars-8-bit.gif');

-- ----------------------------
-- Indexes structure for table active_codes
-- ----------------------------
CREATE UNIQUE INDEX "active_codes_code_key" ON "public"."active_codes" USING btree (
  "code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table active_codes
-- ----------------------------
ALTER TABLE "public"."active_codes" ADD CONSTRAINT "active_codes_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table auth_codes
-- ----------------------------
ALTER TABLE "public"."auth_codes" ADD CONSTRAINT "auth_codes_pkey" PRIMARY KEY ("id");

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
CREATE UNIQUE INDEX "notifications_recipient_id_sender_id_type_id_key" ON "public"."notifications" USING btree (
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
-- Foreign Keys structure for table active_codes
-- ----------------------------
ALTER TABLE "public"."active_codes" ADD CONSTRAINT "active_codes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table follows
-- ----------------------------
ALTER TABLE "public"."follows" ADD CONSTRAINT "follows_followerId_fkey" FOREIGN KEY ("followerId") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "public"."follows" ADD CONSTRAINT "follows_followingId_fkey" FOREIGN KEY ("followingId") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

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
ALTER TABLE "public"."post_comments" ADD CONSTRAINT "post_comments_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "public"."posts" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
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
