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

 Date: 08/11/2024 20:32:58
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
-- Table structure for user_sessions
-- ----------------------------
DROP TABLE IF EXISTS "public"."user_sessions";
CREATE TABLE "public"."user_sessions" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "token" text COLLATE "pg_catalog"."default" NOT NULL,
  "ip_address" text COLLATE "pg_catalog"."default",
  "user_agent" text COLLATE "pg_catalog"."default",
  "payload" text COLLATE "pg_catalog"."default",
  "last_activity" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "created_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "expires_at" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of user_sessions
-- ----------------------------
INSERT INTO "public"."user_sessions" VALUES ('cd38d217-8873-436e-865e-13b0ac26371a', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiJjZDM4ZDIxNy04ODczLTQzNmUtODY1ZS0xM2IwYWMyNjM3MWEiLCJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6ImZhMWZjNWNlLTE0YTQtNDQ0Yy1iZDRlLTg4YWQ0OWZjMTMxZiIsImlhdCI6MTczMDg4NjMxMywiZXhwIjoxNzMxNDkxMTEzfQ.ekbgFEE0I07fBkoCyCqdCxcuC_Cr72ca5mh5Jsa07mY', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', NULL, '2024-11-06 09:45:13.286', '2024-11-06 09:45:13.286', '2024-11-13 09:45:13');
INSERT INTO "public"."user_sessions" VALUES ('8d476567-e388-4f82-80a1-d121139082db', '6a31a93a-a961-48d6-963e-0645f99de8e4', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiI4ZDQ3NjU2Ny1lMzg4LTRmODItODBhMS1kMTIxMTM5MDgyZGIiLCJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6ImI1NGVjZjI0LWRlMTAtNDNjOC1iNWRjLTI3OTBiZjQ5NTk0YiIsImlhdCI6MTczMDg4NjU0MywiZXhwIjoxNzMxNDkxMzQzfQ.tMw8nBcZADteXrQh2hH1mqm7VHZA6Cu_75iTAeCEDSA', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', NULL, '2024-11-06 09:49:03.897', '2024-11-06 09:49:03.897', '2024-11-13 09:49:03');
INSERT INTO "public"."user_sessions" VALUES ('a548094d-6984-48ee-adce-d2cff821f497', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiJhNTQ4MDk0ZC02OTg0LTQ4ZWUtYWRjZS1kMmNmZjgyMWY0OTciLCJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6ImYyMGJhYjVmLTU0MGMtNGE0OC04MDY4LTUzNzNmZDA5NjZmZiIsImlhdCI6MTczMDkwOTUwMCwiZXhwIjoxNzMxNTE0MzAwfQ.BYL_Tr8J1qqkD2mbJxQBoZBNSlNrn_eRu3MLiNORFLs', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', NULL, '2024-11-06 16:11:40.57', '2024-11-06 16:11:40.57', '2024-11-13 16:11:40');
INSERT INTO "public"."user_sessions" VALUES ('e4034ed9-9ce6-4738-bc93-5b4e75e1a6f6', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiJlNDAzNGVkOS05Y2U2LTQ3MzgtYmM5My01YjRlNzVlMWE2ZjYiLCJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjUzYmE2YWI4LTIwNmUtNGFjZi05ODkwLTUxMWM5OTQwNjA2NSIsImlhdCI6MTczMDk2NzQ4OSwiZXhwIjoxNzMxNTcyMjg5fQ.JP_fV9Y6n5pHVipUR1uxrlwSvCfrTKGtWkmRzXQL360', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', NULL, '2024-11-07 08:18:09.377', '2024-11-07 08:18:09.377', '2024-11-14 08:18:09');
INSERT INTO "public"."user_sessions" VALUES ('7474bc96-0964-46b5-83f7-d717518462e1', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiI3NDc0YmM5Ni0wOTY0LTQ2YjUtODNmNy1kNzE3NTE4NDYyZTEiLCJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjI3MWVmOThlLWZhMWYtNGM3MC05YzQ4LTdkODA5ZmViNzRkMCIsImlhdCI6MTczMDk5MzczNSwiZXhwIjoxNzMxNTk4NTM1fQ.IsigaL8F6Yb5Ydare3tyWXQwyje5Pq5HAr8oeRUtCfg', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', NULL, '2024-11-07 15:35:35.701', '2024-11-07 15:35:35.701', '2024-11-14 15:35:35');
INSERT INTO "public"."user_sessions" VALUES ('4238f308-9703-4423-a173-d84a28a3bd00', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiI0MjM4ZjMwOC05NzAzLTQ0MjMtYTE3My1kODRhMjhhM2JkMDAiLCJ1c2VySWQiOiIwMmFkMjQxZS02NmE3LTRlNDQtOTlmZC0zNmZjZWQwY2EzODYiLCJ1c2VybmFtZSI6ImRldll1a2kyMDA1Iiwia2V5IjoiZjk0MTAwMDQtMWFmYS00ZTcwLTk5ZDQtNjdjMTk4Mzg0NjEzIiwiaWF0IjoxNzMxMDY3NDE5LCJleHAiOjE3MzE2NzIyMTl9.x40lazTTpDNT_JV2qWCUkSU8xEazMiRj09fKSsEnGHM', '::ffff:10.210.105.192', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', NULL, '2024-11-08 12:03:39.014', '2024-11-08 12:03:39.014', '2024-11-15 12:03:39');
INSERT INTO "public"."user_sessions" VALUES ('86e0ee6e-c06b-483e-81ff-81b9dbb8f14d', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiI4NmUwZWU2ZS1jMDZiLTQ4M2UtODFmZi04MWI5ZGJiOGYxNGQiLCJ1c2VySWQiOiIwMmFkMjQxZS02NmE3LTRlNDQtOTlmZC0zNmZjZWQwY2EzODYiLCJ1c2VybmFtZSI6ImRldll1a2kyMDA1Iiwia2V5IjoiMDE3MzMxNzEtMzBjOS00YzA1LWI2ZjMtZTBjMjUxOGVkMmVmIiwiaWF0IjoxNzMxMDY4OTEwLCJleHAiOjE3MzE2NzM3MTB9.ZvNNMV5H0UfnS2F_PIZiQx1ffJ9_M1FhfZ4h3g5dN4c', '::ffff:10.210.105.192', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', NULL, '2024-11-08 12:28:31.059', '2024-11-08 12:28:31.059', '2024-11-15 12:28:30');
INSERT INTO "public"."user_sessions" VALUES ('0592cf11-96af-4dd6-abf3-4c29c3f15650', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiIwNTkyY2YxMS05NmFmLTRkZDYtYWJmMy00YzI5YzNmMTU2NTAiLCJ1c2VySWQiOiIwMmFkMjQxZS02NmE3LTRlNDQtOTlmZC0zNmZjZWQwY2EzODYiLCJ1c2VybmFtZSI6ImRldll1a2kyMDA1Iiwia2V5IjoiN2JkOTRiMTctMjc4ZC00ZTg0LWI5YjMtNWUzYzQzMmMzZjljIiwiaWF0IjoxNzMxMDY4OTg5LCJleHAiOjE3MzE2NzM3ODl9.jHMoKvRh0vnhmVIDvBP7fUh0szyxbp-qnUTp_FQp1LI', '::ffff:10.210.238.67', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', NULL, '2024-11-08 12:29:49.474', '2024-11-08 12:29:49.474', '2024-11-15 12:29:49');
INSERT INTO "public"."user_sessions" VALUES ('0c6b7920-495b-411b-8a4f-75d55f012307', '02ad241e-66a7-4e44-99fd-36fced0ca386', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiIwYzZiNzkyMC00OTViLTQxMWItOGE0Zi03NWQ1NWYwMTIzMDciLCJ1c2VySWQiOiIwMmFkMjQxZS02NmE3LTRlNDQtOTlmZC0zNmZjZWQwY2EzODYiLCJ1c2VybmFtZSI6ImRldll1a2kyMDA1Iiwia2V5IjoiZjNiNjM0MGYtOTY1MC00M2JjLTlhYmQtYTA4YTM3NjI2Yzk2IiwiaWF0IjoxNzMxMDY5MDYxLCJleHAiOjE3MzE2NzM4NjF9.JYT5VCONqqTmWCP-JZhzd5PT9uI1o31ca8pet5S1SZY', '::ffff:10.210.105.192', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0', NULL, '2024-11-08 12:31:01.284', '2024-11-08 12:31:01.284', '2024-11-15 12:31:01');

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
INSERT INTO "public"."users" VALUES ('02ad241e-66a7-4e44-99fd-36fced0ca386', 'devYuki2005', 'ogyminecraft497@gmail.com', 'Dang Hoang Thien An', 'Dang Yuki ', '$2b$10$ad05fk3RE8U90WLvHhjNwusDw4CXZ5RbotJ8mHVDB03xK9OwdgdRS', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiIwYzZiNzkyMC00OTViLTQxMWItOGE0Zi03NWQ1NWYwMTIzMDciLCJ1c2VySWQiOiIwMmFkMjQxZS02NmE3LTRlNDQtOTlmZC0zNmZjZWQwY2EzODYiLCJ1c2VybmFtZSI6ImRldll1a2kyMDA1Iiwia2V5IjoiZjNiNjM0MGYtOTY1MC00M2JjLTlhYmQtYTA4YTM3NjI2Yzk2IiwiaWF0IjoxNzMxMDY5MDYxLCJleHAiOjE3MzM2NjEwNjF9.556gBNDY1c15maU1UT-Qc4u3JFCdA30QodghOn3Clyc', NULL, 'f', 'f', 'f', '2024-11-05 13:25:27.937', '2024-11-08 12:31:01.204', 0);
INSERT INTO "public"."users" VALUES ('6a31a93a-a961-48d6-963e-0645f99de8e4', 'lucan2', 'lucan2@gmail.com', 'Luca N', 'Luca N2', '$2b$10$E399bydm4h2sAFu2Q4zCBuU8azipGf2KDjLf.Id9VcxGf28Rnq2bS', '588b1a65-426a-468c-9365-dc1c9b851a79', '0909090909', 23, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiI4ZDQ3NjU2Ny1lMzg4LTRmODItODBhMS1kMTIxMTM5MDgyZGIiLCJ1c2VySWQiOiI2YTMxYTkzYS1hOTYxLTQ4ZDYtOTYzZS0wNjQ1Zjk5ZGU4ZTQiLCJ1c2VybmFtZSI6Imx1Y2FuMiIsImtleSI6ImI1NGVjZjI0LWRlMTAtNDNjOC1iNWRjLTI3OTBiZjQ5NTk0YiIsImlhdCI6MTczMDg4NjU0MywiZXhwIjoxNzMzNDc4NTQzfQ.6JWNS6HmR0PvdqZdglMsSpER1qKr3BfXJ1wKUrPeMDo', NULL, 'f', 'f', 'f', '2024-11-06 09:49:03.576', '2024-11-07 08:48:33.31', 0);
INSERT INTO "public"."users" VALUES ('d66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'lucan1', 'lucan1@gmail.com', 'Luca Nguyen', 'Luca Nguyen 1', '$2b$10$fCvpEVrdjINF2mloEiISKu4Yo1wMveQkg5t/4IuHcqE3gm1dmgFVq', '588b1a65-426a-468c-9365-dc1c9b851a79', '0909090909', 22, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiI3NDc0YmM5Ni0wOTY0LTQ2YjUtODNmNy1kNzE3NTE4NDYyZTEiLCJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6IjI3MWVmOThlLWZhMWYtNGM3MC05YzQ4LTdkODA5ZmViNzRkMCIsImlhdCI6MTczMDk5MzczNSwiZXhwIjoxNzMzNTg1NzM1fQ.Na9iwrQwFUtxZ5GsaCbbljUil5US-YYtuE6v2u1KosI', NULL, 'f', 'f', 'f', '2024-11-04 18:19:27.651', '2024-11-07 15:35:35.628', 99999999);

-- ----------------------------
-- Primary Key structure for table auth_codes
-- ----------------------------
ALTER TABLE "public"."auth_codes" ADD CONSTRAINT "auth_codes_pkey" PRIMARY KEY ("id");

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
-- Foreign Keys structure for table user_sessions
-- ----------------------------
ALTER TABLE "public"."user_sessions" ADD CONSTRAINT "user_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_type_fkey" FOREIGN KEY ("type") REFERENCES "public"."user_types" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
