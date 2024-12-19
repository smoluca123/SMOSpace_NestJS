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

 Date: 19/12/2024 13:31:15
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
INSERT INTO "public"."auth_codes" VALUES ('b7893e2b-5b76-48f8-82c8-cc6b10f7a2eb', 'SMOTeam', 3);

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
INSERT INTO "public"."post_likes" VALUES ('b76a9e4f-4664-47f6-847e-3d1c73c74c3b', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'e28f8ace-f619-40f2-ba60-f8aa0afec786', '2024-12-19 06:24:59.278');
INSERT INTO "public"."post_likes" VALUES ('30a36e7a-f5b2-4880-8949-d7fc4071aeac', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'b5cc9911-e908-45e5-afb3-981e15399c9e', '2024-12-19 06:25:16.965');
INSERT INTO "public"."post_likes" VALUES ('d4b17740-8a95-4905-87e8-f49eec081b0b', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '3205a905-2d8e-4416-9557-dc0d95546c4e', '2024-12-19 06:25:20.631');
INSERT INTO "public"."post_likes" VALUES ('4a315c08-909c-4c98-9eb6-fd12f56f99ec', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '7c7bb021-eafd-448f-a93b-0b42596fae09', '2024-12-19 06:28:22.791');
INSERT INTO "public"."post_likes" VALUES ('3bb1cdd4-7431-4b24-9fc6-c05bfd833a68', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '7c7bb021-eafd-448f-a93b-0b42596fae09', '2024-12-19 06:28:31.114');
INSERT INTO "public"."post_likes" VALUES ('554345b5-ac34-4ca6-a1db-143e6b6d0f69', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '3205a905-2d8e-4416-9557-dc0d95546c4e', '2024-12-18 06:49:18.505');
INSERT INTO "public"."post_likes" VALUES ('2a2a311d-3ba6-4410-938a-643e9bfd039c', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '3205a905-2d8e-4416-9557-dc0d95546c4e', '2024-12-19 05:50:14.81');
INSERT INTO "public"."post_likes" VALUES ('2f0c6b28-fe7e-459e-8f91-27542df3ba2e', '49d9e3c0-ec00-48f0-86d3-293549c246dd', 'b5cc9911-e908-45e5-afb3-981e15399c9e', '2024-12-19 06:02:38.066');

-- ----------------------------
-- Table structure for posts
-- ----------------------------
DROP TABLE IF EXISTS "public"."posts";
CREATE TABLE "public"."posts" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "authorId" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(3) NOT NULL,
  "is_private" bool NOT NULL,
  "like_count" int4 NOT NULL DEFAULT 0
)
;

-- ----------------------------
-- Records of posts
-- ----------------------------
INSERT INTO "public"."posts" VALUES ('e28f8ace-f619-40f2-ba60-f8aa0afec786', '<p>Yuki cute :)))<br>yuki ngây ngo<br>#Yuki_ngu #Yuki_simp_ngu</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-18 08:31:55.859', '2024-12-19 06:24:59.278', 'f', 1);
INSERT INTO "public"."posts" VALUES ('b5cc9911-e908-45e5-afb3-981e15399c9e', 'NextJS so good<br>#NextJS_so_good #NextJS_so_good2 #NextJS_so_good3', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2024-11-11 14:31:11.379', '2024-12-19 06:25:16.965', 'f', 2);
INSERT INTO "public"."posts" VALUES ('3205a905-2d8e-4416-9557-dc0d95546c4e', 'yuki cuta ế', '02ad241e-66a7-4e44-99fd-36fced0ca386', '2024-12-03 10:08:08.253', '2024-12-19 06:25:20.631', 'f', 3);
INSERT INTO "public"."posts" VALUES ('7c7bb021-eafd-448f-a93b-0b42596fae09', '<p>Trong tim em có Kanavi đứng đợi, Faker lao vào đẩy được Ruler về và Oner hứng - mạng shutdown dành cho Zeus…  </p><p>                              Tê  con  cho hay  <br>#Faker #T1</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-19 06:27:07.517', '2024-12-19 06:28:31.114', 'f', 2);

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
INSERT INTO "public"."user_sessions" VALUES ('2184b5f1-178c-4b86-86e1-8455c65fc996', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '43.228.126.61', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', NULL, '2024-12-18 12:48:09.408', '2024-12-15 15:09:56.32', '2024-12-19 12:48:09.408', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjIzNzBkOGJlLTk0YWYtNGY3MC04N2JmLTNjMDE2NjA2YzRmOSIsImlhdCI6MTczNDUyNjA4OSwiZXhwIjoxNzM1MTMwODg5fQ.XFyYHqyYyt9Y8WhgmzOqxKms3pWTWaC87g4jDtbdW_g');
INSERT INTO "public"."user_sessions" VALUES ('cfacea91-369c-400b-92b9-08a51d61f139', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '171.250.162.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', NULL, '2024-12-19 05:05:45.298', '2024-12-19 05:05:45.299', '2024-12-20 05:05:45.298', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0OWQ5ZTNjMC1lYzAwLTQ4ZjAtODZkMy0yOTM1NDljMjQ2ZGQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2Iiwia2V5IjoiMjRmYzc5ZjktNjc3ZC00MmRiLTg3ZWEtODRhMGUwOTU0MWViIiwiaWF0IjoxNzM0NTg0NzQ1LCJleHAiOjE3MzUxODk1NDV9.kHZDRrfBkVJ1ypB2Z7KbJ2xEw6Nqq4X8wwebTbDXA7w');
INSERT INTO "public"."user_sessions" VALUES ('fe20c941-ddb8-4bde-9996-3f5d1c05586e', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '171.250.162.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', NULL, '2024-12-19 02:47:06.642', '2024-12-17 14:43:31.961', '2024-12-20 02:47:06.642', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiYzZmZTQ4NTctMTNhYi00MjFhLWI3NGItYmI5ZWEzMjUyMGUwIiwiaWF0IjoxNzM0NTc2NDI2LCJleHAiOjE3MzUxODEyMjZ9.HPVP_d2ftC851gBLzKl34GuSBczRBo05yE3pUaT2lL8');

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
  "email" text COLLATE "pg_catalog"."default",
  "full_name" text COLLATE "pg_catalog"."default" NOT NULL,
  "display_name" text COLLATE "pg_catalog"."default",
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
  "credits" int4 DEFAULT 0
)
;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO "public"."users" VALUES ('9df351a4-a867-460f-9453-7105223b9e80', 'hgphienn', 'hgphien@gmail.com', 'pham tran hong phien', 'hongphiencute254', '$2a$10$VPmWSIXXHURJsQVUjTG5BO2XKGDeserf463Lq4Bw0tPXjFYanHzLe', '588b1a65-426a-468c-9365-dc1c9b851a79', '034444444', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiJjMjI2MTMzNC03MThlLTRkMmItOThjNi0wMDhmZjU4YjQ0NjUiLCJ1c2VySWQiOiI5ZGYzNTFhNC1hODY3LTQ2MGYtOTQ1My03MTA1MjIzYjllODAiLCJ1c2VybmFtZSI6ImhncGhpZW5uIiwia2V5IjoiNjBhYzdkYzItMmUyMS00MTM2LWJhNDItYmIyY2I5N2UxZTJlIiwiaWF0IjoxNzMyMjY5MDk0LCJleHAiOjE3MzQ4NjEwOTR9.jSn-oaWPHzeqWjw2lAq1c58z42ZlNLzt5KpSOIvAwRw', NULL, 'f', 'f', 'f', '2024-11-22 09:51:32.629', '2024-11-22 09:51:34.895', 0);
INSERT INTO "public"."users" VALUES ('caa2265d-5196-4a67-831e-85f91866fb8b', 'kanjame', 'kanjame@gmail.com', 'Kan Jame', 'Kan Jame', '$2a$10$hmzfMs28YHK46KQ8jcN4guxrObSsBL6hUSVsn/nwppUNIIe5DonuW', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, 0, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiI2ZjYwOTkzOS1jM2RlLTQ3M2ItYjcyMy00ZTQ2YWExNjE2ZWIiLCJ1c2VySWQiOiJjYWEyMjY1ZC01MTk2LTRhNjctODMxZS04NWY5MTg2NmZiOGIiLCJ1c2VybmFtZSI6ImthbmphbWUiLCJrZXkiOiJlN2UyMDkwNS0wNzJlLTRjNTItYjlkZS01NTYxYzEyYWQ2MzIiLCJpYXQiOjE3MzE0OTY0ODgsImV4cCI6MTczNDA4ODQ4OH0.EDsz6V5ET6JWif5-V1QtocnaPtRxD3s1y4obp6MCFoA', NULL, 'f', 'f', 'f', '2024-11-13 11:14:48.721', '2024-11-13 11:14:48.724', 0);
INSERT INTO "public"."users" VALUES ('6a31a93a-a961-48d6-963e-0645f99de8e4', 'lucan2', 'lucan2@gmail.com', 'Luca N', 'Luca N2', '$2b$10$E399bydm4h2sAFu2Q4zCBuU8azipGf2KDjLf.Id9VcxGf28Rnq2bS', '588b1a65-426a-468c-9365-dc1c9b851a79', '0909090909', 23, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiI5MWJmNjVkNi1hYmEzLTRkYjItOTQ3ZC0zYjhhOWFkODYwMDgiLCJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6IjdiNTNjNTgzLTk2YWMtNDEzZS04OTBjLWQyMDk4NmEyNmM3YiIsImlhdCI6MTczMTIyNzE3NiwiZXhwIjoxNzMzODE5MTc2fQ.JJ2M3NNSXg3s31NAalk4sdGkwsesjjndhZq-9EQIoqE', NULL, 'f', 'f', 'f', '2024-11-06 09:49:03.576', '2024-11-10 08:26:16.418', 0);
INSERT INTO "public"."users" VALUES ('37739086-9b6f-42ac-96ce-1cc81a56dd6d', 'yenvydethuong2806+2', 'ogyminecraft497+2@gmail.com', 'pham thi yen vy', 'yenvydethuong2806', '$2a$10$d8LtvWWPNC5Yi7u9Iscl2urGTH0VV18QZ4e.S0sBXpU01ziKZ.Byy', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 0, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiJmYTQ5YmFiZS02NzZlLTQyMDQtODgyZC0xODcxZDYyNGM5MWEiLCJ1c2VySWQiOiIzNzczOTA4Ni05YjZmLTQyYWMtOTZjZS0xY2M4MWE1NmRkNmQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2KzIiLCJrZXkiOiIxNDlkZTQ5Ny0yNGUzLTRjNWItYWIxMC1mMTMxYTA2MDk2MDgiLCJpYXQiOjE3MzIzMzYwMTQsImV4cCI6MTczNDkyODAxNH0.z_8lobLg-kMlNPYb2JgsZfiaqTzFAE-1-XhAA4XzchA', NULL, 'f', 'f', 'f', '2024-11-23 04:26:53.327', '2024-11-23 04:26:54.108', 0);
INSERT INTO "public"."users" VALUES ('9e0c791c-c424-43fa-9c48-d73b11796ec9', 'yukicute123', 'yenvy280605@gmail.com', 'Pham Thi Yen Vy', 'Nana Haru', '$2a$10$aFlVH426/pzmmwrC.Te/jOtVfNz/OUtYNg1A08rPD94wn95F64vBK', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356658758', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiYzZmZTQ4NTctMTNhYi00MjFhLWI3NGItYmI5ZWEzMjUyMGUwIiwiaWF0IjoxNzM0NTc2NDI2LCJleHAiOjE3MzcxNjg0MjZ9.CxbXjKmEMAw3Zwwg1xOEZz62B4R5cT9PcF1Ok_74efo', NULL, 't', 'f', 'f', '2024-12-17 14:43:31.915', '2024-12-19 02:47:06.622', 0);
INSERT INTO "public"."users" VALUES ('084b617e-c89c-44ff-8dc9-7c1aa4f7730e', 'yenvydethuong28063', 'ogyminecraft497+4@gmail.com', 'pham thi yen vy', 'yenvydethuong28063', '$2a$10$2pTODRB0PCD9wvkTeGn68.1U5arkkBavuLlExIbLg0hzg05..0Wkq', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiIyODdkOTQwYi1hNmJhLTQzZTgtOGI1Yi02NjE1NGEzZjZjNGQiLCJ1c2VySWQiOiIwODRiNjE3ZS1jODljLTQ0ZmYtOGRjOS03YzFhYTRmNzczMGUiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2MyIsImtleSI6IjVlMGM3MDgxLTI2MDYtNDk3Zi04MzkyLTc5MzRjNGE2MjUxOCIsImlhdCI6MTczMjg0ODk2MywiZXhwIjoxNzM1NDQwOTYzfQ.evUtjD_1TiKFnqq0PDaTPgBCwRvmDDjzT6dbVQRe5aE', NULL, 'f', 'f', 'f', '2024-11-29 02:56:03.329', '2024-11-29 02:56:03.996', 0);
INSERT INTO "public"."users" VALUES ('65904792-fdd5-45e3-a892-830a4640fd9b', 'yenvydethuong28062', 'ogyminecraft497+3@gmail.com', 'pham thi yen vy', 'yenvydethuong28062', '$2a$10$Jl8Pytx1EBPd0.fauD/qvOISkLnKBwpIIgBjT1n4H9dvbqC2GHn4m', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 22, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiIyNDQ3ODI1NC1jZjA3LTQ3YzgtOTE4My1hNmZhNWRlNGI1ZWEiLCJ1c2VySWQiOiI2NTkwNDc5Mi1mZGQ1LTQ1ZTMtYTg5Mi04MzBhNDY0MGZkOWIiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2MiIsImtleSI6IjA3N2M2NDUzLTRmNWMtNGVhNC1iZWZkLTI0YzdlMjc0ZTRjMyIsImlhdCI6MTczMjg1MDE2NSwiZXhwIjoxNzM1NDQyMTY1fQ.V0h9mYuiOTVlnQBL8SkkIfFvTD_EG-KN1ZzwzkWgOSw', NULL, 'f', 'f', 'f', '2024-11-25 04:25:10.321', '2024-11-29 03:16:05.298', 0);
INSERT INTO "public"."users" VALUES ('02ad241e-66a7-4e44-99fd-36fced0ca386', 'devYuki2005', 'ogyminecraft497@gmail.com', 'Dang Hoang Thien An', 'devYuki', '$2b$10$ad05fk3RE8U90WLvHhjNwusDw4CXZ5RbotJ8mHVDB03xK9OwdgdRS', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiI4NDA3MmE0Ny1hNTRjLTQ1MzUtYTYwYS02NWY5Nzk1Zjc5YTAiLCJ1c2VySWQiOiIwMmFkMjQxZS02NmE3LTRlNDQtOTlmZC0zNmZjZWQwY2EzODYiLCJ1c2VybmFtZSI6ImRldll1a2kyMDA1Iiwia2V5IjoiZDEyMDMwNjItZTEwMS00ODc5LTg2NWMtY2FkOTFiMTBjMDdjIiwiaWF0IjoxNzMzMjc5MDUyLCJleHAiOjE3MzU4NzEwNTJ9.QkEEUKvzkBPMnrLFcdiOt9tKCU2ymGHiW4jY4-4Stfg', 'https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1731476400251_photo_2024-03-11_12-05-41.jpg', 't', 'f', 'f', '2024-11-05 13:25:27.937', '2024-12-04 02:24:12.228', 0);
INSERT INTO "public"."users" VALUES ('ba1b25ea-053b-4100-a4ad-a92959914eeb', 'lucan3', 'icaluca12+2@gmail.com', 'Kan Jame', 'N', '$2a$10$Rnfw5j96Z9X7hXS424b.D.F3o0wro1N.xm8cy/VDIgOmE2tXs5FNi', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, 0, NULL, NULL, 'f', 'f', 'f', '2024-12-06 15:33:49.042', '2024-12-06 15:33:49.043', 0);
INSERT INTO "public"."users" VALUES ('49d9e3c0-ec00-48f0-86d3-293549c246dd', 'yenvydethuong2806', 'ogyminecraft497+1@gmail.com', 'pham thi yen vy', 'yenvydethuong2806', '$2a$10$7TYIFS8ZqDbn/.z6o9A2HuNY5G.6HxnM8.iEyKs3zsDkr4d6rsSyy', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0OWQ5ZTNjMC1lYzAwLTQ4ZjAtODZkMy0yOTM1NDljMjQ2ZGQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2Iiwia2V5IjoiMjRmYzc5ZjktNjc3ZC00MmRiLTg3ZWEtODRhMGUwOTU0MWViIiwiaWF0IjoxNzM0NTg0NzQ1LCJleHAiOjE3MzcxNzY3NDV9.HLJ5xWAqmMu4VClRbohAU_0xG-Meq-a6hcEYxQPRzHk', NULL, 't', 'f', 'f', '2024-11-23 04:19:05.711', '2024-12-19 05:05:45.286', 0);
INSERT INTO "public"."users" VALUES ('d66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'lucan1', 'icaluca12@gmail.com', 'Luca Nguyen', 'Luca Nguyen 1', '$2b$10$fCvpEVrdjINF2mloEiISKu4Yo1wMveQkg5t/4IuHcqE3gm1dmgFVq', '588b1a65-426a-468c-9365-dc1c9b851a79', '0909090909', 25, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjIzNzBkOGJlLTk0YWYtNGY3MC04N2JmLTNjMDE2NjA2YzRmOSIsImlhdCI6MTczNDUyNjA4OSwiZXhwIjoxNzM3MTE4MDg5fQ.0cE_TUT5O1uZ5S49gyc37hgOsANUAqegpfsJM28IXRU', 'https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1731137327615_00002-1468083896.png', 'f', 't', 'f', '2024-11-04 18:19:27.651', '2024-12-18 12:48:09.391', 100000);

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
-- Primary Key structure for table post_likes
-- ----------------------------
ALTER TABLE "public"."post_likes" ADD CONSTRAINT "post_likes_pkey" PRIMARY KEY ("id");

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
-- Foreign Keys structure for table post_likes
-- ----------------------------
ALTER TABLE "public"."post_likes" ADD CONSTRAINT "post_likes_postId_fkey" FOREIGN KEY ("postId") REFERENCES "public"."posts" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "public"."post_likes" ADD CONSTRAINT "post_likes_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table posts
-- ----------------------------
ALTER TABLE "public"."posts" ADD CONSTRAINT "posts_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "public"."users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table user_sessions
-- ----------------------------
ALTER TABLE "public"."user_sessions" ADD CONSTRAINT "user_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_type_fkey" FOREIGN KEY ("type") REFERENCES "public"."user_types" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
