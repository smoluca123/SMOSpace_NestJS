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

 Date: 22/12/2024 01:42:20
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
INSERT INTO "public"."post_likes" VALUES ('3bb1cdd4-7431-4b24-9fc6-c05bfd833a68', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '7c7bb021-eafd-448f-a93b-0b42596fae09', '2024-12-19 06:28:31.114');
INSERT INTO "public"."post_likes" VALUES ('26aa1686-2204-4a33-ad96-36aa58747f6f', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '454bdff3-f2a2-4041-8d75-80d15ce5c683', '2024-12-19 14:10:46.526');
INSERT INTO "public"."post_likes" VALUES ('48ed919f-4cab-4f22-aa07-8f68e733b94b', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '9bd04ce1-3187-4ad4-b096-666bacd7c810', '2024-12-20 14:21:19.788');
INSERT INTO "public"."post_likes" VALUES ('3e23fd0d-ea74-4cdb-8d17-370e3b515da7', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '128e9eec-60e4-4d10-8868-24bddfe01d7e', '2024-12-20 14:28:59.256');
INSERT INTO "public"."post_likes" VALUES ('32a4b9cd-e584-4a14-96ba-c766e38cffba', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '98233ab4-abda-4db5-8b75-b0fc8909f9ef', '2024-12-20 14:29:01.388');
INSERT INTO "public"."post_likes" VALUES ('483b01a2-23c6-40ce-a9ef-7ba108fe91a6', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '7c7bb021-eafd-448f-a93b-0b42596fae09', '2024-12-20 14:29:02.719');
INSERT INTO "public"."post_likes" VALUES ('1749e5b1-f091-4f9a-b267-387548542873', '9e0c791c-c424-43fa-9c48-d73b11796ec9', 'b5cc9911-e908-45e5-afb3-981e15399c9e', '2024-12-20 14:29:04.394');
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
INSERT INTO "public"."posts" VALUES ('454bdff3-f2a2-4041-8d75-80d15ce5c683', '<p>dont''t forget drink 2l water on day :))))</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-19 14:01:29.117', '2024-12-19 14:10:46.526', 'f', 1);
INSERT INTO "public"."posts" VALUES ('7c7bb021-eafd-448f-a93b-0b42596fae09', '<p>Trong tim em có Kanavi đứng đợi, Faker lao vào đẩy được Ruler về và Oner hứng - mạng shutdown dành cho Zeus…  </p><p>                              Tê  con  cho hay  <br>#Faker #T1</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-19 06:27:07.517', '2024-12-20 14:29:02.719', 'f', 2);
INSERT INTO "public"."posts" VALUES ('b5cc9911-e908-45e5-afb3-981e15399c9e', 'NextJS so good<br>#NextJS_so_good #NextJS_so_good2 #NextJS_so_good3', '6a31a93a-a961-48d6-963e-0645f99de8e4', '2023-11-11 14:31:11.379', '2024-12-20 14:29:04.394', 'f', 2);
INSERT INTO "public"."posts" VALUES ('1aae5ce9-b2b9-44b7-8081-13b6b0154db1', '<p>hi</p>', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '2024-12-21 18:41:21.745', '2024-12-21 18:41:21.745', 'f', 0);
INSERT INTO "public"."posts" VALUES ('f37911bd-23fd-4625-a7b6-0056992dac29', '<p>yuki ngu 1</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-20 13:55:12.674', '2024-12-20 13:55:12.674', 't', 0);
INSERT INTO "public"."posts" VALUES ('1d24031c-07c5-44f1-a796-9eeed4330893', '<p>js  so goood</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-20 14:00:40.742', '2024-12-20 14:00:40.742', 't', 0);
INSERT INTO "public"."posts" VALUES ('9bd04ce1-3187-4ad4-b096-666bacd7c810', '<p><strong class="font-bold">FAP TV</strong> là một trong những nhóm hài nổi tiếng tại Việt Nam, được thành lập vào năm 2013. Nhóm nổi bật với các video hài hước, những clip ngắn đầy tính giải trí và ý nghĩa. <em class="font-italic">FAP TV không chỉ mang đến cho khán giả tiếng cười, mà còn là những thông điệp sâu sắc về cuộc sống, tình bạn, tình yêu và gia đình.</em> <br><br>Các thành viên của nhóm bao gồm những người trẻ tài năng như: Hiếu Nguyễn, Vinh Râu, và một số nghệ sĩ trẻ khác. Họ đã xây dựng một lượng fan hùng hậu nhờ vào sự sáng tạo và đam mê trong từng sản phẩm. <strong class="font-bold">Với những video đậm chất giải trí, FAP TV đã thu hút hàng triệu lượt xem và theo dõi trên các nền tảng mạng xã hội.</strong><br><br>Hãy cùng đón xem và ủng hộ những sản phẩm mới của FAP TV nhé! <br><br>#FAPTV #ComedyVietnam #HilariousContent #comnguoi</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-20 14:21:14.88', '2024-12-20 14:27:00.212', 'f', 1);
INSERT INTO "public"."posts" VALUES ('128e9eec-60e4-4d10-8868-24bddfe01d7e', '<p>Trong thời đại công nghệ thông tin bùng nổ, trí tuệ nhân tạo (AI) đang trở thành một phần không thể thiếu trong cuộc sống và công việc hàng ngày. Tuy nhiên, <strong classname="font-bold">lạm dụng AI trong lập trình có thể dẫn đến những hệ lụy nghiêm trọng, khiến chúng ta trở nên "ngu đi".</strong> <br><br>Khi chúng ta quá phụ thuộc vào các công cụ AI để viết mã, kiểm tra lỗi hay tối ưu hóa quá trình phát triển phần mềm, <em classname="font-italic">kỹ năng lập trình và khả năng giải quyết vấn đề của con người sẽ dần mai một.</em> Chúng ta có thể rơi vào tình trạng "thuộc lòng" các lệnh và phương pháp mà AI đưa ra mà không hiểu rõ bản chất và logic phía sau chúng. <br><br>Việc quá dựa dẫm vào AI không chỉ ảnh hưởng đến trình độ cá nhân mà còn đến chất lượng chung của sản phẩm. Khi lập trình viên không còn thảo luận và tranh luận về các giải pháp, những sai sót có thể xuất hiện mà không ai nhận ra. Hơn nữa, các thuật toán có thể dẫn đến những quyết định sai lầm nếu không có sự cân nhắc kỹ lưỡng từ con người. <br><br><strong classname="font-bold">Do đó, chúng ta cần phải tìm ra cách cân bằng giữa sử dụng AI và giữ vững khả năng tư duy và giải quyết vấn đề của bản thân.</strong> Hãy luôn tự rèn luyện, học hỏi và nhớ rằng <em classname="font-italic">AI chỉ là một công cụ hỗ trợ, không phải là một giải pháp thay thế cho con người.</em> <br><br>#AIDependency #CodingSkills #TechBalance #StayCurious #LearnToCode</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-20 08:39:50.039', '2024-12-20 14:28:59.256', 'f', 1);
INSERT INTO "public"."posts" VALUES ('98233ab4-abda-4db5-8b75-b0fc8909f9ef', '<p><span class=\"font-bold\">Công nghệ trí tuệ nhân tạo (AI)</span> đang trở thành một trong những xu hướng phát triển mạnh mẽ nhất trong thời đại số ngày nay. Từ việc tự động hóa quy trình làm việc đến nâng cao trải nghiệm người dùng, AI đang góp phần thay đổi cách chúng ta sống và làm việc. <br> <span class=\"font-italic\">Bạn có bao giờ nghĩ rằng một ngày nào đó máy tính có thể hiểu và học hỏi giống như con người?</span> Thực tế, chúng ta đang sống trong thời kỳ mà điều đó không chỉ là một giấc mơ nữa. <br> <span class=\"font-bold\">Những ứng dụng của AI</span> rất đa dạng, từ chatbot hỗ trợ khách hàng, trợ lý ảo như Siri hay Google Assistant, cho đến các hệ thống phân tích dữ liệu để giúp doanh nghiệp ra quyết định nhanh chóng hơn. Hơn thế nữa, AI còn được ứng dụng trong lĩnh vực y tế, tài chính và nhiều ngành nghề khác, mang lại hiệu quả và giá trị to lớn. <br> Chắc chắn rằng trong tương lai, công nghệ này sẽ tiếp tục phát triển và đem lại nhiều điều kỳ diệu hơn nữa. Hãy cùng nhau chờ xem những điều gì thú vị đang chờ đón chúng ta! <br> <span class=\"font-italic\">Công nghệ là tương lai, và AI chính là cầu nối để chúng ta bước vào thế giới mới!</span></p><br><br>#Technology #AI #Innovation #Future #Digitization', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-19 10:07:57.744', '2024-12-20 14:29:01.388', 'f', 1);
INSERT INTO "public"."posts" VALUES ('8f285b33-6e15-48b4-9fc1-46d09ac5dde6', '<p><strong classname="font-bold">Ribi Sachi - Nàng công chúa trong lòng khán giả</strong> <br><br>Ribi Sachi, một cái tên không còn xa lạ với cộng đồng yêu thích phim ảnh Việt Nam, đặc biệt là những người hâm mộ FAP TV. Cô không chỉ được biết đến với tài năng diễn xuất xuất sắc mà còn chinh phục khán giả bằng vẻ đẹp và phong cách độc đáo của mình. <br><br><em classname="font-italic">Với sự nghiệp diễn xuất đầy ấn tượng, Ribi đã ghi dấu ấn trong nhiều bộ phim hài hước và những chương trình giải trí hấp dẫn. Hình ảnh của cô trong các video của FAP TV luôn mang đến những tiếng cười vui vẻ, đầy ngẫu hứng và khiến người xem phải trầm trồ. Sự duyên dáng và khả năng biểu cảm sinh động của cô đã khiến nhân vật của Ribi trở nên gần gũi và dễ mến.</em> <br><br>Bên cạnh đó, Ribi Sachi còn là một người năng động trên mạng xã hội. Cô thường xuyên chia sẻ những khoảnh khắc đời thường, những buổi chụp hình vui vẻ và cả những câu chuyện ý nghĩa trong cuộc sống. Điều này không chỉ giúp khán giả hiểu rõ hơn về cô mà còn tạo nên một cộng đồng gắn kết và thân thiện.<br><br><strong classname="font-bold">Với những nỗ lực không ngừng, Ribi Sachi xứng đáng là một trong những ngôi sao triển vọng của làng giải trí Việt Nam.</strong> Hãy cùng theo dõi và ủng hộ cô trong các dự án sắp tới nhé!<br><br>#RibiSachi #FAPTV #VietnameseActress #Comedy #Entertainment</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-20 14:44:33.172', '2024-12-20 14:44:33.172', 'f', 0);
INSERT INTO "public"."posts" VALUES ('5943e205-8dff-49f9-8eb5-9947336c9343', '<p><strong classname="font-bold">Hành trình lập trình của bạn có thể không giống ai, nhưng đó chính là sức mạnh của bạn!</strong> <br><br>Khiếm thị không phải là rào cản mà là một cơ hội để phát triển những kỹ năng độc đáo mà chỉ bạn mới có. <em classname="font-italic">Hãy tưởng tượng</em> bạn đang tạo ra những dòng mã mà không cần nhìn thấy màn hình. Đó chính là sự sáng tạo và sức mạnh của trí tưởng tượng! <br><br>Bước vào thế giới lập trình, bạn đang khám phá không chỉ là những cú pháp hay thuật toán mà còn là khả năng tự vượt qua chính mình. <strong classname="font-bold">Mỗi dòng mã bạn viết ra là một bước tiến, mỗi lỗi sai là một bài học quý giá.</strong> Hãy nhận ra rằng bạn không đơn độc trên con đường này. Có rất nhiều tài nguyên hỗ trợ cho người khiếm thị, từ phần mềm đọc màn hình đến cộng đồng lập trình viên sẵn lòng giúp đỡ. <br><br>Hãy đặt mục tiêu cho bản thân và kiên trì theo đuổi. <em classname="font-italic">Chắc chắn rằng bạn có thể biến đam mê lập trình thành hiện thực</em>, và bạn sẽ chứng minh cho thế giới thấy rằng không gì là không thể! <br><br>Hãy nhớ, mỗi cú click chuột hay mỗi dòng lệnh đều đang khẳng định giá trị của bạn. Bạn có thể làm được! <br><br>#Inspiration #BlindProgramming #CodingJourney</p>', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '2024-12-21 06:28:24.722', '2024-12-21 06:28:24.722', 'f', 0);

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
INSERT INTO "public"."user_sessions" VALUES ('cfacea91-369c-400b-92b9-08a51d61f139', '49d9e3c0-ec00-48f0-86d3-293549c246dd', '171.250.162.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', NULL, '2024-12-19 05:05:45.298', '2024-12-19 05:05:45.299', '2024-12-20 05:05:45.298', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0OWQ5ZTNjMC1lYzAwLTQ4ZjAtODZkMy0yOTM1NDljMjQ2ZGQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2Iiwia2V5IjoiMjRmYzc5ZjktNjc3ZC00MmRiLTg3ZWEtODRhMGUwOTU0MWViIiwiaWF0IjoxNzM0NTg0NzQ1LCJleHAiOjE3MzUxODk1NDV9.kHZDRrfBkVJ1ypB2Z7KbJ2xEw6Nqq4X8wwebTbDXA7w');
INSERT INTO "public"."user_sessions" VALUES ('2184b5f1-178c-4b86-86e1-8455c65fc996', 'd66d20e6-d9cc-4218-9de6-8eeae42ea9ca', '116.111.184.248', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', NULL, '2024-12-21 09:31:56.391', '2024-12-15 15:09:56.32', '2024-12-22 09:31:56.391', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6Ijk1OGZiYjU1LTY5YTEtNDk2Yi05NzE4LTAyMTYxMjVmYjFiZiIsImlhdCI6MTczNDc3MzUxNiwiZXhwIjoxNzM1Mzc4MzE2fQ.uEySCNRxAu-NrMXQm_VkhRWQvDL_T-d89Tj95w1vrBY');
INSERT INTO "public"."user_sessions" VALUES ('fe20c941-ddb8-4bde-9996-3f5d1c05586e', '9e0c791c-c424-43fa-9c48-d73b11796ec9', '171.250.162.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', NULL, '2024-12-21 09:07:54.398', '2024-12-17 14:43:31.961', '2024-12-22 09:07:54.398', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiZDk0ZTE1NTktMGMwMC00ZDBlLWEzMWQtZGViYWQ1MjM2ZWYyIiwiaWF0IjoxNzM0NzcyMDc0LCJleHAiOjE3MzUzNzY4NzR9._O7sMHdIzQ7lr_z-yIYBl8Ws4Qu5ZAHWZlPTAOnymuY');

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
INSERT INTO "public"."users" VALUES ('9e0c791c-c424-43fa-9c48-d73b11796ec9', 'yukicute123', 'yenvy280605@gmail.com', 'Pham Thi Yen Vy', 'Nana Haru', '$2a$10$aFlVH426/pzmmwrC.Te/jOtVfNz/OUtYNg1A08rPD94wn95F64vBK', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356658758', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5ZTBjNzkxYy1jNDI0LTQzZmEtOWM0OC1kNzNiMTE3OTZlYzkiLCJ1c2VybmFtZSI6Inl1a2ljdXRlMTIzIiwia2V5IjoiZDk0ZTE1NTktMGMwMC00ZDBlLWEzMWQtZGViYWQ1MjM2ZWYyIiwiaWF0IjoxNzM0NzcyMDc0LCJleHAiOjE3MzczNjQwNzR9.QHh9Mc14VEcTtvwu34tIXzSMuamWfanxZ68W82-qHbU', 'https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1734772177931_photo_2024-03-11_12-05-41.jpg', 't', 'f', 'f', '2024-12-17 14:43:31.915', '2024-12-21 09:09:38.929', 5622);
INSERT INTO "public"."users" VALUES ('37739086-9b6f-42ac-96ce-1cc81a56dd6d', 'yenvydethuong2806+2', 'ogyminecraft497+2@gmail.com', 'pham thi yen vy', 'yenvydethuong2806', '$2a$10$d8LtvWWPNC5Yi7u9Iscl2urGTH0VV18QZ4e.S0sBXpU01ziKZ.Byy', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 0, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiJmYTQ5YmFiZS02NzZlLTQyMDQtODgyZC0xODcxZDYyNGM5MWEiLCJ1c2VySWQiOiIzNzczOTA4Ni05YjZmLTQyYWMtOTZjZS0xY2M4MWE1NmRkNmQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2KzIiLCJrZXkiOiIxNDlkZTQ5Ny0yNGUzLTRjNWItYWIxMC1mMTMxYTA2MDk2MDgiLCJpYXQiOjE3MzIzMzYwMTQsImV4cCI6MTczNDkyODAxNH0.z_8lobLg-kMlNPYb2JgsZfiaqTzFAE-1-XhAA4XzchA', NULL, 'f', 'f', 'f', '2024-11-23 04:26:53.327', '2024-11-23 04:26:54.108', 0);
INSERT INTO "public"."users" VALUES ('084b617e-c89c-44ff-8dc9-7c1aa4f7730e', 'yenvydethuong28063', 'ogyminecraft497+4@gmail.com', 'pham thi yen vy', 'yenvydethuong28063', '$2a$10$2pTODRB0PCD9wvkTeGn68.1U5arkkBavuLlExIbLg0hzg05..0Wkq', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiIyODdkOTQwYi1hNmJhLTQzZTgtOGI1Yi02NjE1NGEzZjZjNGQiLCJ1c2VySWQiOiIwODRiNjE3ZS1jODljLTQ0ZmYtOGRjOS03YzFhYTRmNzczMGUiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2MyIsImtleSI6IjVlMGM3MDgxLTI2MDYtNDk3Zi04MzkyLTc5MzRjNGE2MjUxOCIsImlhdCI6MTczMjg0ODk2MywiZXhwIjoxNzM1NDQwOTYzfQ.evUtjD_1TiKFnqq0PDaTPgBCwRvmDDjzT6dbVQRe5aE', NULL, 'f', 'f', 'f', '2024-11-29 02:56:03.329', '2024-11-29 02:56:03.996', 0);
INSERT INTO "public"."users" VALUES ('65904792-fdd5-45e3-a892-830a4640fd9b', 'yenvydethuong28062', 'ogyminecraft497+3@gmail.com', 'pham thi yen vy', 'yenvydethuong28062', '$2a$10$Jl8Pytx1EBPd0.fauD/qvOISkLnKBwpIIgBjT1n4H9dvbqC2GHn4m', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 22, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiIyNDQ3ODI1NC1jZjA3LTQ3YzgtOTE4My1hNmZhNWRlNGI1ZWEiLCJ1c2VySWQiOiI2NTkwNDc5Mi1mZGQ1LTQ1ZTMtYTg5Mi04MzBhNDY0MGZkOWIiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2MiIsImtleSI6IjA3N2M2NDUzLTRmNWMtNGVhNC1iZWZkLTI0YzdlMjc0ZTRjMyIsImlhdCI6MTczMjg1MDE2NSwiZXhwIjoxNzM1NDQyMTY1fQ.V0h9mYuiOTVlnQBL8SkkIfFvTD_EG-KN1ZzwzkWgOSw', NULL, 'f', 'f', 'f', '2024-11-25 04:25:10.321', '2024-11-29 03:16:05.298', 0);
INSERT INTO "public"."users" VALUES ('02ad241e-66a7-4e44-99fd-36fced0ca386', 'devYuki2005', 'ogyminecraft497@gmail.com', 'Dang Hoang Thien An', 'devYuki', '$2b$10$ad05fk3RE8U90WLvHhjNwusDw4CXZ5RbotJ8mHVDB03xK9OwdgdRS', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiI4NDA3MmE0Ny1hNTRjLTQ1MzUtYTYwYS02NWY5Nzk1Zjc5YTAiLCJ1c2VySWQiOiIwMmFkMjQxZS02NmE3LTRlNDQtOTlmZC0zNmZjZWQwY2EzODYiLCJ1c2VybmFtZSI6ImRldll1a2kyMDA1Iiwia2V5IjoiZDEyMDMwNjItZTEwMS00ODc5LTg2NWMtY2FkOTFiMTBjMDdjIiwiaWF0IjoxNzMzMjc5MDUyLCJleHAiOjE3MzU4NzEwNTJ9.QkEEUKvzkBPMnrLFcdiOt9tKCU2ymGHiW4jY4-4Stfg', 'https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1731476400251_photo_2024-03-11_12-05-41.jpg', 't', 'f', 'f', '2024-11-05 13:25:27.937', '2024-12-04 02:24:12.228', 0);
INSERT INTO "public"."users" VALUES ('ba1b25ea-053b-4100-a4ad-a92959914eeb', 'lucan3', 'icaluca12+2@gmail.com', 'Kan Jame', 'N', '$2a$10$Rnfw5j96Z9X7hXS424b.D.F3o0wro1N.xm8cy/VDIgOmE2tXs5FNi', '588b1a65-426a-468c-9365-dc1c9b851a79', NULL, 0, NULL, NULL, 'f', 'f', 'f', '2024-12-06 15:33:49.042', '2024-12-06 15:33:49.043', 0);
INSERT INTO "public"."users" VALUES ('49d9e3c0-ec00-48f0-86d3-293549c246dd', 'yenvydethuong2806', 'ogyminecraft497+1@gmail.com', 'pham thi yen vy', 'yenvydethuong2806', '$2a$10$7TYIFS8ZqDbn/.z6o9A2HuNY5G.6HxnM8.iEyKs3zsDkr4d6rsSyy', '588b1a65-426a-468c-9365-dc1c9b851a79', '0356618560', 19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0OWQ5ZTNjMC1lYzAwLTQ4ZjAtODZkMy0yOTM1NDljMjQ2ZGQiLCJ1c2VybmFtZSI6InllbnZ5ZGV0aHVvbmcyODA2Iiwia2V5IjoiMjRmYzc5ZjktNjc3ZC00MmRiLTg3ZWEtODRhMGUwOTU0MWViIiwiaWF0IjoxNzM0NTg0NzQ1LCJleHAiOjE3MzcxNzY3NDV9.HLJ5xWAqmMu4VClRbohAU_0xG-Meq-a6hcEYxQPRzHk', NULL, 't', 'f', 'f', '2024-11-23 04:19:05.711', '2024-12-19 05:05:45.286', 0);
INSERT INTO "public"."users" VALUES ('d66d20e6-d9cc-4218-9de6-8eeae42ea9ca', 'lucan1', 'icaluca12@gmail.com', 'Luca Nguyen', 'Luca Nguyen 1', '$2b$10$fCvpEVrdjINF2mloEiISKu4Yo1wMveQkg5t/4IuHcqE3gm1dmgFVq', '588b1a65-426a-468c-9365-dc1c9b851a79', '0909090909', 25, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkNjZkMjBlNi1kOWNjLTQyMTgtOWRlNi04ZWVhZTQyZWE5Y2EiLCJ1c2VybmFtZSI6Imx1Y2FuMSIsImtleSI6Ijk1OGZiYjU1LTY5YTEtNDk2Yi05NzE4LTAyMTYxMjVmYjFiZiIsImlhdCI6MTczNDc3MzUxNiwiZXhwIjoxNzM3MzY1NTE2fQ.ne5UF0aSTpVujjXllem6aMgATZn2_e4Q9anvk0-WnLg', 'https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/Pinterrest_upload/1731137327615_00002-1468083896.png', 'f', 't', 'f', '2024-11-04 18:19:27.651', '2024-12-21 09:31:56.37', 99992);

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
ALTER TABLE "public"."post_likes" ADD CONSTRAINT "post_likes_postId_fkey" FOREIGN KEY ("postId") REFERENCES "public"."posts" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
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