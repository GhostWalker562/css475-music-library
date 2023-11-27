-- File: create_tables_fk.sql
DROP TABLE IF EXISTS `password_reset`;

DROP TABLE IF EXISTS `user_session`;

DROP TABLE IF EXISTS `user_key`;

DROP TABLE IF EXISTS `user_song_recommendations`;

DROP TABLE IF EXISTS `user_likes`;

DROP TABLE IF EXISTS `playlist_songs`;

DROP TABLE IF EXISTS `album_songs`;

DROP TABLE IF EXISTS `playlist`;

DROP TABLE IF EXISTS `album`;

DROP TABLE IF EXISTS `song`;

DROP TABLE IF EXISTS `artist`;

DROP TABLE IF EXISTS `auth_user`;

-- Auth Tables
CREATE TABLE `auth_user` (
    `id` varchar(15) NOT NULL,
    `username` varchar(128) NOT NULL,
    `github_username` varchar(255) UNIQUE,
    `email` varchar(255) UNIQUE,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `profile_image_url` varchar(255),
    CONSTRAINT `auth_user_id` PRIMARY KEY(`id`)
);

CREATE TABLE `user_key` (
    `id` varchar(255) NOT NULL,
    `user_id` varchar(15) NOT NULL,
    `hashed_password` varchar(255),
    CONSTRAINT `user_key_id` PRIMARY KEY(`id`),
    FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
);

CREATE TABLE `user_session` (
    `id` varchar(128) NOT NULL,
    `user_id` varchar(15) NOT NULL,
    `active_expires` bigint NOT NULL,
    `idle_expires` bigint NOT NULL,
    CONSTRAINT `user_session_id` PRIMARY KEY(`id`),
    FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
);

CREATE TABLE `password_reset` (
    `id` varchar(128) NOT NULL,
    `expires` bigint NOT NULL,
    `user_id` varchar(15) NOT NULL,
    CONSTRAINT `password_reset_id` PRIMARY KEY(`id`),
    FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
);

-- Application Tables
CREATE TABLE `artist`(
    `id` varchar(15) NOT NULL,
    `bio` varchar(400) NOT NULL,
    `name` varchar(128) NOT NULL,
    CONSTRAINT `artist_id_pk` PRIMARY KEY (`id`),
    FOREIGN KEY (`id`) REFERENCES `auth_user` (`id`)
);

CREATE TABLE `album`(
    `id` varchar(128) NOT NULL,
    `artist_id` varchar(15) NOT NULL,
    `cover_image_url` varchar(255),
    `name` varchar(128) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `albums_id_pk` PRIMARY KEY (`id`),
    FOREIGN KEY (`artist_id`) REFERENCES `artist` (`id`)
);

CREATE TABLE `song` (
    `id` varchar(128) NOT NULL,
    `name` varchar (128) NOT NULL,
    `artist_id` varchar(15) NOT NULL,
    `duration` int NOT NULL,
    `genre` ENUM (
        'COUNTRY',
        'POP',
        'RAP',
        'ROCK',
        'CLASSICAL',
        'JAZZ'
    ) NOT NULL,
    `spotify_id` varchar(128),
    `preview_url` varchar(255),
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `songs_id_pk` PRIMARY KEY (`id`),
    FOREIGN KEY (`artist_id`) REFERENCES `artist` (`id`)
);

CREATE TABLE `playlist` (
    `id` varchar(128) NOT NULL,
    `name` varchar (128) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `creator_id` varchar(128) NOT NULL,
    CONSTRAINT `playlists_id_pk` PRIMARY KEY (`id`),
    FOREIGN KEY (`creator_id`) REFERENCES `auth_user` (`id`)
);

-- Index Tables
CREATE TABLE `album_songs` (
    `album_id` varchar(128) NOT NULL,
    `song_id` varchar(128) NOT NULL,
    `order` int NOT NULL DEFAULT 0,
    CONSTRAINT `album_songs_album_id_song_id_pk` PRIMARY KEY(`album_id`, `song_id`),
    UNIQUE (song_id),
    FOREIGN KEY (`album_id`) REFERENCES `album` (`id`)
);

CREATE TABLE `playlist_songs` (
    `playlist_id` varchar(128) NOT NULL,
    `song_id` varchar(128) NOT NULL,
    `order` int NOT NULL DEFAULT 0,
    CONSTRAINT `playlist_songs_playlist_id_song_id_pk` PRIMARY KEY(`playlist_id`, `song_id`),
    FOREIGN KEY (`playlist_id`) REFERENCES `playlist` (`id`),
    FOREIGN KEY (`song_id`) REFERENCES `song` (`id`)
);

CREATE TABLE `user_likes` (
    `user_id` varchar(15) NOT NULL,
    `song_id` varchar(128) NOT NULL,
    CONSTRAINT `user_likes_user_id_song_id_pk` PRIMARY KEY(`user_id`, `song_id`),
    FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
    FOREIGN KEY (`song_id`) REFERENCES `song` (`id`)
);

CREATE TABLE `user_song_recommendations` (
    `id` varchar(128) NOT NULL,
    `user_id` varchar(15) NOT NULL,
    `song_id` varchar(128) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `user_song_recommendations_id_user_id_song_id_pk` PRIMARY KEY(`id`, `user_id`, `song_id`),
    FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
    FOREIGN KEY (`song_id`) REFERENCES `song` (`id`)
);

-- File: insert_admin.sql
INSERT INTO
    `auth_user` (
        `id`,
        `username`,
        `email`,
        `created_at`
    )
VALUES
    (
        'icqlt67n2fd7p34',
        'Admin',
        'g@g.com',
        '2023-11-17 17:00:08.000'
    );

INSERT INTO
    `user_key` (`id`, `user_id`, `hashed_password`)
VALUES
    (
        'email:g@g.com',
        'icqlt67n2fd7p34',
        's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189'
    );

-- File: insert_songs.sql
-- Latto
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('154ky3bw3get4eo', 'Latto', '0@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:0@artist.com', '154ky3bw3get4eo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('154ky3bw3get4eo', 'A bold and dynamic rapper, making waves with her fiery lyrics.', 'Latto');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('3wraa3tcff9xprt9je01aw0fivh9xw9l91khhcskceh09zwzc9','154ky3bw3get4eo', NULL, 'Latto Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ysxijbl2285t6fkflq5fi7tnfhweae0bm6a741eg5vi0svnvx4','Seven (feat. Latto) (Explicit Ver.)','154ky3bw3get4eo',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('3wraa3tcff9xprt9je01aw0fivh9xw9l91khhcskceh09zwzc9', 'ysxijbl2285t6fkflq5fi7tnfhweae0bm6a741eg5vi0svnvx4', '0');
-- Myke Towers
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('aflslgfgkvj8stu', 'Myke Towers', '1@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9e35c3c5de877f99a8f6192f','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:1@artist.com', 'aflslgfgkvj8stu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('aflslgfgkvj8stu', 'A rising star in Latin music, known for his distinctive flow.', 'Myke Towers');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('97bczfp2if0pap3uu5hy5zfz6k4deo4vkdyaud5hxlg23u0npn','aflslgfgkvj8stu', 'https://i.scdn.co/image/ab67616d0000b2730656d5ce813ca3cc4b677e05', 'Myke Towers Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('qay4f71tumhp9bdq91lu3it4cwshpa8kghusro0zj7yg9n7oy9','LALA','aflslgfgkvj8stu',100,'POP','7ABLbnD53cQK00mhcaOUVG','https://p.scdn.co/mp3-preview/42772b16b4e575d1b15b0ec7f94e335539390d2d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('97bczfp2if0pap3uu5hy5zfz6k4deo4vkdyaud5hxlg23u0npn', 'qay4f71tumhp9bdq91lu3it4cwshpa8kghusro0zj7yg9n7oy9', '0');
-- Olivia Rodrigo
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('bb329z8tuqh8jv9', 'Olivia Rodrigo', '2@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe03a98785f3658f0b6461ec4','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:2@artist.com', 'bb329z8tuqh8jv9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('bb329z8tuqh8jv9', 'A new voice in pop, channeling raw emotions into her songs.', 'Olivia Rodrigo');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('g1we3fpsvuqs9rnci7dj39n5ej4b7hl463sf0zw7irdjdx3tg7','bb329z8tuqh8jv9', 'https://i.scdn.co/image/ab67616d0000b273e85259a1cae29a8d91f2093d', 'Olivia Rodrigo Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('jyqdqsy8zcbagldt9qxenx3snmiv75u9ke30571lrkm9rkpos3','vampire','bb329z8tuqh8jv9',100,'POP','1kuGVB7EU95pJObxwvfwKS',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('g1we3fpsvuqs9rnci7dj39n5ej4b7hl463sf0zw7irdjdx3tg7', 'jyqdqsy8zcbagldt9qxenx3snmiv75u9ke30571lrkm9rkpos3', '0');
-- Taylor Swift
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('nqedkac7q25mb2a', 'Taylor Swift', '3@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb859e4c14fa59296c8649e0e4','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:3@artist.com', 'nqedkac7q25mb2a', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('nqedkac7q25mb2a', 'A storytelling icon, weaving life experiences into musical masterpieces.', 'Taylor Swift');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('w4shww0sztxofic4wcy6mjoadxi3kw2lgj3se9ps1pagn0eush','nqedkac7q25mb2a', 'https://i.scdn.co/image/ab67616d0000b273e787cffec20aa2a396a61647', 'Taylor Swift Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('nz09khtnw7rrc5jtgqvg8mfa2kpvrmf8r3td2x3j4wa8avld6r','Cruel Summer','nqedkac7q25mb2a',100,'POP','1BxfuPKGuaTgP7aM0Bbdwr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('w4shww0sztxofic4wcy6mjoadxi3kw2lgj3se9ps1pagn0eush', 'nz09khtnw7rrc5jtgqvg8mfa2kpvrmf8r3td2x3j4wa8avld6r', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('fyxr3eq4s63vvs12n4p38uqp60xh3juqd66btb2ikw8bc2bdbk','I Can See You (Taylors Version) (From The ','nqedkac7q25mb2a',100,'POP','5kHMfzgLZP95O9NBy0ku4v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('w4shww0sztxofic4wcy6mjoadxi3kw2lgj3se9ps1pagn0eush', 'fyxr3eq4s63vvs12n4p38uqp60xh3juqd66btb2ikw8bc2bdbk', '1');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('cg6jzc9x2zavuenbl9ncgs1p7ydk2je0hixeew6kg6xlm2ikva','Anti-Hero','nqedkac7q25mb2a',100,'POP','0V3wPSX9ygBnCm8psDIegu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('w4shww0sztxofic4wcy6mjoadxi3kw2lgj3se9ps1pagn0eush', 'cg6jzc9x2zavuenbl9ncgs1p7ydk2je0hixeew6kg6xlm2ikva', '2');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('sxadq9i4dy8vyyc3291sek3pm2bf9maxu5ghpcrvutapzl4xsq','Blank Space','nqedkac7q25mb2a',100,'POP','1p80LdxRV74UKvL8gnD7ky',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('w4shww0sztxofic4wcy6mjoadxi3kw2lgj3se9ps1pagn0eush', 'sxadq9i4dy8vyyc3291sek3pm2bf9maxu5ghpcrvutapzl4xsq', '3');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('1ayoikhpq7w6ayat7mex5ecmocum5tjtzxb0ebgk0o2dppi9a2','Style','nqedkac7q25mb2a',100,'POP','1hjRhYpWyqDpPahmSlUTlc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('w4shww0sztxofic4wcy6mjoadxi3kw2lgj3se9ps1pagn0eush', '1ayoikhpq7w6ayat7mex5ecmocum5tjtzxb0ebgk0o2dppi9a2', '4');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('bnq3bpwattd8lv7jr84gr6rxpftf3keljjnb82mbrrhoth2vs1','cardigan','nqedkac7q25mb2a',100,'POP','4R2kfaDFhslZEMJqAFNpdd',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('w4shww0sztxofic4wcy6mjoadxi3kw2lgj3se9ps1pagn0eush', 'bnq3bpwattd8lv7jr84gr6rxpftf3keljjnb82mbrrhoth2vs1', '5');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('u5irm04m9fkkfo1gqfry0t4srzvpd6ns9did690da83ubgzs3k','Karma','nqedkac7q25mb2a',100,'POP','7KokYm8cMIXCsGVmUvKtqf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('w4shww0sztxofic4wcy6mjoadxi3kw2lgj3se9ps1pagn0eush', 'u5irm04m9fkkfo1gqfry0t4srzvpd6ns9did690da83ubgzs3k', '6');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('rhd3jsbfjrihkby8ku9wwlu6f0ubaf59jtzueqsb4eqe019gjq','Enchanted (Taylors Version)','nqedkac7q25mb2a',100,'POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('w4shww0sztxofic4wcy6mjoadxi3kw2lgj3se9ps1pagn0eush', 'rhd3jsbfjrihkby8ku9wwlu6f0ubaf59jtzueqsb4eqe019gjq', '7');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('o1zzbnli3jgvlgvixz1tunxo8ggvcaso93fwxvidnl2cc9cdjx','Back To December (Taylors Version)','nqedkac7q25mb2a',100,'POP','79uDOz0zuuWS7HWxzMmTa2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('w4shww0sztxofic4wcy6mjoadxi3kw2lgj3se9ps1pagn0eush', 'o1zzbnli3jgvlgvixz1tunxo8ggvcaso93fwxvidnl2cc9cdjx', '8');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('9o7k6il1ab2spzgthmp3biyyqgh89qaq97fgbnrwbyvfu0b2le','Dont Bl','nqedkac7q25mb2a',100,'POP','59ZmeIz57cGU5Gp9omjlYB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('w4shww0sztxofic4wcy6mjoadxi3kw2lgj3se9ps1pagn0eush', '9o7k6il1ab2spzgthmp3biyyqgh89qaq97fgbnrwbyvfu0b2le', '9');
-- Bad Bunny
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('vug2o4j3tw1isu8', 'Bad Bunny', '4@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9ad50e478a469448c6f369df','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:4@artist.com', 'vug2o4j3tw1isu8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('vug2o4j3tw1isu8', 'A trailblazer in Latin trap and reggaeton, known for his charismatic style and innovative music.', 'Bad Bunny');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('wijzke20k0axte2mc9rb1abr0nk0p0tjkhd8zj6p8dbyah7686','vug2o4j3tw1isu8', 'https://i.scdn.co/image/ab67616d0000b273ab5c9cd818ad6ed3e9b79cd1', 'Bad Bunny Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('z9dclpz6f081k0hbdbwsg5xnwt29w2q8ow82te9o8szsw6x3s6','WHERE SHE GOES','vug2o4j3tw1isu8',100,'POP','7ro0hRteUMfnOioTFI5TG1','https://p.scdn.co/mp3-preview/b9b7e4c982b33ee23c4867f7a3025e3598c35760?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('wijzke20k0axte2mc9rb1abr0nk0p0tjkhd8zj6p8dbyah7686', 'z9dclpz6f081k0hbdbwsg5xnwt29w2q8ow82te9o8szsw6x3s6', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('64konu8sgvi58qfvnq5lixxis8e641yj7mpxyv3gno2rdy8psj','un x100to','vug2o4j3tw1isu8',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('wijzke20k0axte2mc9rb1abr0nk0p0tjkhd8zj6p8dbyah7686', '64konu8sgvi58qfvnq5lixxis8e641yj7mpxyv3gno2rdy8psj', '1');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('6f5sg3u0kfnx0r1gqzyq41qp34jotba2itl2lqxii4wf4g9ok7','Coco Chanel','vug2o4j3tw1isu8',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('wijzke20k0axte2mc9rb1abr0nk0p0tjkhd8zj6p8dbyah7686', '6f5sg3u0kfnx0r1gqzyq41qp34jotba2itl2lqxii4wf4g9ok7', '2');
-- Dave
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('pc1fabw6scz6d1f', 'Dave', '5@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5fe7cabb8de1c0266cd2179c','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:5@artist.com', 'pc1fabw6scz6d1f', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('pc1fabw6scz6d1f', 'A master of words, blending rap with social commentary and raw emotion.', 'Dave');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('68zv3joimjm3te69bf83stcn79cgv73fnpvgs7h0q4t8q5po6b','pc1fabw6scz6d1f', 'https://i.scdn.co/image/ab67616d0000b273e3a09a9ae3f1fa102c110e60', 'Dave Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('5ft25u5manpwy7x0ldjiwlgl2nob4829qz44hjg4lky28pjamv','Sprinter','pc1fabw6scz6d1f',100,'POP','2FDTHlrBguDzQkp7PVj16Q',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('68zv3joimjm3te69bf83stcn79cgv73fnpvgs7h0q4t8q5po6b', '5ft25u5manpwy7x0ldjiwlgl2nob4829qz44hjg4lky28pjamv', '0');
-- Eslabon Armado
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('cgxeogg8dfapmmp', 'Eslabon Armado', '6@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:6@artist.com', 'cgxeogg8dfapmmp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('cgxeogg8dfapmmp', 'Bringing a fresh take to traditional music, weaving in modern influences.', 'Eslabon Armado');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('4zfwlhd7vzqznql4fczmxkhxfn3hp6shzj0do161zw9vj61cew','cgxeogg8dfapmmp', 'https://i.scdn.co/image/ab67616d0000b2732071a0c79802d9375a53bfef', 'Eslabon Armado Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('o3bmgbxpnp9sm1rcgxd7f5wc2vknisv0h3u4e17h66nfn58jfx','Ella Baila Sola','cgxeogg8dfapmmp',100,'POP','3dnP0JxCgygwQH9Gm7q7nb','https://p.scdn.co/mp3-preview/5d39f3e17f1e20e2711d033001e48b8d4249b992?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('4zfwlhd7vzqznql4fczmxkhxfn3hp6shzj0do161zw9vj61cew', 'o3bmgbxpnp9sm1rcgxd7f5wc2vknisv0h3u4e17h66nfn58jfx', '0');
-- Quevedo
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('qejemf09fvpilj8', 'Quevedo', '7@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2394e996716534bc2c937a1a','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:7@artist.com', 'qejemf09fvpilj8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('qejemf09fvpilj8', 'Merging lyrical depth with compelling urban beats.', 'Quevedo');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('wbzjfuy1oh2260bz6tmpcsk88m6bkxghswcj1b1rh76t1fyjto','qejemf09fvpilj8', 'https://i.scdn.co/image/ab67616d0000b273a00a817b017c6f6bf8460be9', 'Quevedo Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('jrvwc5qw7fvyyivwzldp9c2zoudwxswbr1a8gyden6nf4djz3b','Columbia','qejemf09fvpilj8',100,'POP','6XbtvPmIpyCbjuT0e8cQtp','https://p.scdn.co/mp3-preview/e3d6df66fe67f618166a2cab858580ac8a96486a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('wbzjfuy1oh2260bz6tmpcsk88m6bkxghswcj1b1rh76t1fyjto', 'jrvwc5qw7fvyyivwzldp9c2zoudwxswbr1a8gyden6nf4djz3b', '0');
-- Gunna
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('i6kcnoedfqw4uie', 'Gunna', '8@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6501f8a7d50c56e86e46f920','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:8@artist.com', 'i6kcnoedfqw4uie', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('i6kcnoedfqw4uie', 'A trailblazer in trap music, known for his smooth flow and catchy beats.', 'Gunna');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('1vaav6onk9g3f45enai2kg40a4xsw7odozf4avrev5c4c2otvt','i6kcnoedfqw4uie', 'https://i.scdn.co/image/ab67616d0000b273017d5e26552345c4b1575b6c', 'Gunna Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('l013u5bfmgepqlvk08ipcs2wg6d8nwxogohu42p1m4bqqgak0h','fukumean','i6kcnoedfqw4uie',100,'POP','4rXLjWdF2ZZpXCVTfWcshS','https://p.scdn.co/mp3-preview/f237ab921af697ba9b49e12fa167c2ce1a82d6b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('1vaav6onk9g3f45enai2kg40a4xsw7odozf4avrev5c4c2otvt', 'l013u5bfmgepqlvk08ipcs2wg6d8nwxogohu42p1m4bqqgak0h', '0');
-- Peso Pluma
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('7u5sb9wl5yvtb6w', 'Peso Pluma', '9@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3df5eb47e5d93bd2ca536a5a','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:9@artist.com', '7u5sb9wl5yvtb6w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('7u5sb9wl5yvtb6w', 'Infusing music with energetic beats and captivating lyrics.', 'Peso Pluma');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('q0npgq0hgl9lcqnu3lu7gvx8i2f15o6dups21m9l0i29g0kz5a','7u5sb9wl5yvtb6w', NULL, 'Peso Pluma Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('7448vm3uthm9itvb5svlbjc70d0m017f7cy0slrouksyjqovr8','La Bebe - Remix','7u5sb9wl5yvtb6w',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('q0npgq0hgl9lcqnu3lu7gvx8i2f15o6dups21m9l0i29g0kz5a', '7448vm3uthm9itvb5svlbjc70d0m017f7cy0slrouksyjqovr8', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('iccb1vufzaxjixmtyrt2xf5wcx2uhkuj2jvtdtkf0qyck0gy5l','TULUM','7u5sb9wl5yvtb6w',100,'POP','7bPp2NmpmyhLJ7zWazAXMu','https://p.scdn.co/mp3-preview/164468e67b8da8053036c68533ffa473ab680c51?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('q0npgq0hgl9lcqnu3lu7gvx8i2f15o6dups21m9l0i29g0kz5a', 'iccb1vufzaxjixmtyrt2xf5wcx2uhkuj2jvtdtkf0qyck0gy5l', '1');
-- NewJeans
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('9aosrfi4kd9cxoo', 'NewJeans', '10@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5da361915b1fa48895d4f23f','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:10@artist.com', '9aosrfi4kd9cxoo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('9aosrfi4kd9cxoo', 'Redefining K-pop with their fresh style and energetic performances.', 'NewJeans');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('6kwmdiit67dw65qj4n9269gy7slo9feqx0vq9rnrs627beimxm','9aosrfi4kd9cxoo', 'https://i.scdn.co/image/ab67616d0000b2733d98a0ae7c78a3a9babaf8af', 'NewJeans Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('mvr177aanaqkb8e0wvta7mtg58bs6jkok2a73o5y6yhysojhqt','Super Shy','9aosrfi4kd9cxoo',100,'POP','5sdQOyqq2IDhvmx2lHOpwd','https://p.scdn.co/mp3-preview/dab062e2cc708a2680ce84953a3581c5a679a230?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('6kwmdiit67dw65qj4n9269gy7slo9feqx0vq9rnrs627beimxm', 'mvr177aanaqkb8e0wvta7mtg58bs6jkok2a73o5y6yhysojhqt', '0');
-- Miley Cyrus
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('tti2kzgk4m7hpxi', 'Miley Cyrus', '11@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5af3b38f053486ab0784dee','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:11@artist.com', 'tti2kzgk4m7hpxi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('tti2kzgk4m7hpxi', 'Constantly evolving, from pop sensation to rock powerhouse.', 'Miley Cyrus');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('uk3iw10wsaz76zckn52daovzb5iqnfcquw5cif5a5o5klm91ci','tti2kzgk4m7hpxi', 'https://i.scdn.co/image/ab67616d0000b273cd222052a2594be29a6616b5', 'Miley Cyrus Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('hu1gw442u7b6q74oft4lsgdqrooesvbm4rp860o2z0ecu93kho','Flowers','tti2kzgk4m7hpxi',100,'POP','7DSAEUvxU8FajXtRloy8M0','https://p.scdn.co/mp3-preview/5184d19d1b7fcc3e7c067e38af45a7cc80851440?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('uk3iw10wsaz76zckn52daovzb5iqnfcquw5cif5a5o5klm91ci', 'hu1gw442u7b6q74oft4lsgdqrooesvbm4rp860o2z0ecu93kho', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('pet7be4mig3e6vrn2f6xcyf9w4t9r4zkstgzcpinbucehs99yl','Angels Like You','tti2kzgk4m7hpxi',100,'POP','1daDRI9ahBonbWD8YcxOIB','https://p.scdn.co/mp3-preview/4db8314199c0d49e95c786792ecd06eadae9f510?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('uk3iw10wsaz76zckn52daovzb5iqnfcquw5cif5a5o5klm91ci', 'pet7be4mig3e6vrn2f6xcyf9w4t9r4zkstgzcpinbucehs99yl', '1');
-- David Kushner
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('kwx8krw8w21iyg2', 'David Kushner', '12@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb12fd1bd22516e35ef8c2e591','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:12@artist.com', 'kwx8krw8w21iyg2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('kwx8krw8w21iyg2', 'A rising talent, creating music that resonates with a generation.', 'David Kushner');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('mai97mtrs2enz3l406cxtu9mrs6hd60ltkhsfjovzbn8shtxbm','kwx8krw8w21iyg2', 'https://i.scdn.co/image/ab67616d0000b27395ca6a9b4083a86c149934ae', 'David Kushner Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('2xyjjufdv8nr0ef45oe36ctgfes5svsc2wjfip5raslkhccv60','Daylight','kwx8krw8w21iyg2',100,'POP','1odExI7RdWc4BT515LTAwj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('mai97mtrs2enz3l406cxtu9mrs6hd60ltkhsfjovzbn8shtxbm', '2xyjjufdv8nr0ef45oe36ctgfes5svsc2wjfip5raslkhccv60', '0');
-- Harry Styles
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('ymb9cwjp3w8k4kh', 'Harry Styles', '13@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf7db7c8ede90a019c54590bb','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:13@artist.com', 'ymb9cwjp3w8k4kh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ymb9cwjp3w8k4kh', 'Defining modern pop-rock with his charismatic presence and bold choices.', 'Harry Styles');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('kr8froiuzmenwuoqz2t6ve5llufzfbcs4pt3mwvduspduuvgv5','ymb9cwjp3w8k4kh', 'https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0', 'Harry Styles Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('mitlucyj8sxacx8iiu12amh98k2fi9n1uz9nzoat8306ukhlvr','As It Was','ymb9cwjp3w8k4kh',100,'POP','4Dvkj6JhhA12EX05fT7y2e','https://p.scdn.co/mp3-preview/c43dd07043b29e800c1a65b3a0102861fa3cf418?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('kr8froiuzmenwuoqz2t6ve5llufzfbcs4pt3mwvduspduuvgv5', 'mitlucyj8sxacx8iiu12amh98k2fi9n1uz9nzoat8306ukhlvr', '0');
-- SZA
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('qgneffjtjwrwycz', 'SZA', '14@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7eb7f6371aad8e67e01f0a03','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:14@artist.com', 'qgneffjtjwrwycz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('qgneffjtjwrwycz', 'An avant-garde R&B artist painting vivid stories through her music.', 'SZA');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('2dqi2s861nmxocr0allmaqzjdjqr6yjf0z3vaxlt7dcmv5u2hj','qgneffjtjwrwycz', 'https://i.scdn.co/image/ab67616d0000b2730c471c36970b9406233842a5', 'SZA Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('799n4hub7qjh3zlfwbwznjxb7wh7lptdafyhvzv7a6eoqu9my7','Kill Bill','qgneffjtjwrwycz',100,'POP','1Qrg8KqiBpW07V7PNxwwwL','https://p.scdn.co/mp3-preview/4bd2dc84016f3743add7eea8b988407b1b900672?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('2dqi2s861nmxocr0allmaqzjdjqr6yjf0z3vaxlt7dcmv5u2hj', '799n4hub7qjh3zlfwbwznjxb7wh7lptdafyhvzv7a6eoqu9my7', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('56lzn2vdvc3lta5qf9rkhuiupcxfvrhemp9xxoezaqxbzmu644','Snooze','qgneffjtjwrwycz',100,'POP','4iZ4pt7kvcaH6Yo8UoZ4s2','https://p.scdn.co/mp3-preview/8c53920b5fd2c3178afa36cac9eec68b5ee9204a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('2dqi2s861nmxocr0allmaqzjdjqr6yjf0z3vaxlt7dcmv5u2hj', '56lzn2vdvc3lta5qf9rkhuiupcxfvrhemp9xxoezaqxbzmu644', '1');
-- Fifty Fifty
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('yqa8e5cle9afm2k', 'Fifty Fifty', '15@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5a60b0f886b5deb8518e4a41','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:15@artist.com', 'yqa8e5cle9afm2k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('yqa8e5cle9afm2k', 'Blending a rich array of genres to create a unique musical experience.', 'Fifty Fifty');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('k8arlywvj4lxjaa57dfeezbrs4ex7kbog51x1r9x5qilnffe9m','yqa8e5cle9afm2k', 'https://i.scdn.co/image/ab67616d0000b27337c0b3670236c067c8e8bbcb', 'Fifty Fifty Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('8z6acsr5mak4jpyt76mjogjo63rieewntna9is1zkv0i2pcq5v','Cupid - Twin Ver.','yqa8e5cle9afm2k',100,'POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('k8arlywvj4lxjaa57dfeezbrs4ex7kbog51x1r9x5qilnffe9m', '8z6acsr5mak4jpyt76mjogjo63rieewntna9is1zkv0i2pcq5v', '0');
-- Billie Eilish
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('dqpsi8tim7msoi2', 'Billie Eilish', '16@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd8b9980db67272cb4d2c3daf','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:16@artist.com', 'dqpsi8tim7msoi2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('dqpsi8tim7msoi2', 'An icon in modern pop, known for her haunting vocals and introspective lyrics.', 'Billie Eilish');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('pxe2n6i8gtj7ktea3mtr6ym6tndwd2sngft24lz7ys3bsrg36y','dqpsi8tim7msoi2', NULL, 'Billie Eilish Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('sy5guip2vvvrv2yiqkp0z6lqvs9qm4g4viu8vp357qbzx0d62n','What Was I Made For? [From The Motion Picture "Barbie"]','dqpsi8tim7msoi2',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('pxe2n6i8gtj7ktea3mtr6ym6tndwd2sngft24lz7ys3bsrg36y', 'sy5guip2vvvrv2yiqkp0z6lqvs9qm4g4viu8vp357qbzx0d62n', '0');
-- Feid
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('ccsusue1a3sgs4r', 'Feid', '17@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0a248d29f8faa91f971e5cae','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:17@artist.com', 'ccsusue1a3sgs4r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ccsusue1a3sgs4r', 'A standout artist in urban Latin music, known for his catchy melodies and smooth vocals.', 'Feid');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('zxkqjvp0ob28k2k86ucku47whz3okeey79nfpsgak2w7hs7a6f','ccsusue1a3sgs4r', 'https://i.scdn.co/image/ab67616d0000b27329ebee2b5fb008871fcd201a', 'Feid Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('tlq43l7ym21pdanyvunbjvsqtaywbe589tmezl7xjxk9iy1281','Classy 101','ccsusue1a3sgs4r',100,'POP','6XSqqQIy7Lm7SnwxS4NrGx',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('zxkqjvp0ob28k2k86ucku47whz3okeey79nfpsgak2w7hs7a6f', 'tlq43l7ym21pdanyvunbjvsqtaywbe589tmezl7xjxk9iy1281', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('1b6ite8u90t8mdg986t4wrkx5v1js2zxsxa42xiwdgtck67xp8','El Cielo','ccsusue1a3sgs4r',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('zxkqjvp0ob28k2k86ucku47whz3okeey79nfpsgak2w7hs7a6f', '1b6ite8u90t8mdg986t4wrkx5v1js2zxsxa42xiwdgtck67xp8', '1');
-- Jimin
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('qxj40br5s9fux8n', 'Jimin', '18@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb59f8cfc8e71dcaf8c6ec4bde','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:18@artist.com', 'qxj40br5s9fux8n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('qxj40br5s9fux8n', 'Known for his expressive voice and mesmerizing dance moves in BTS.', 'Jimin');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('v549dgv1grsrjqo3zk7fhfa6a2auboaizeohehqo5fo00f13yx','qxj40br5s9fux8n', 'https://i.scdn.co/image/ab67616d0000b2732b46078245d0120690eb560d', 'Jimin Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('uei4x8dvj12phd656gme0mf22pf7gfjru0sgliorbfw0y4sc1z','Like Crazy','qxj40br5s9fux8n',100,'POP','3Ua0m0YmEjrMi9XErKcNiR','https://p.scdn.co/mp3-preview/2db5f36096963d97afc870c50990d62d27858a43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('v549dgv1grsrjqo3zk7fhfa6a2auboaizeohehqo5fo00f13yx', 'uei4x8dvj12phd656gme0mf22pf7gfjru0sgliorbfw0y4sc1z', '0');
-- Gabito Ballesteros
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('w2m7q7nk03cvjt4', 'Gabito Ballesteros', '19@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:19@artist.com', 'w2m7q7nk03cvjt4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('w2m7q7nk03cvjt4', 'A vibrant force in the music scene, infusing every performance with passion.', 'Gabito Ballesteros');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ta5e5wmb1rh8g2dscquxvmo3tw68u9cl6ba3uxmk62h6607uy8','w2m7q7nk03cvjt4', NULL, 'Gabito Ballesteros Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('1yh97m2g4831p8u8c4v11e2lfbpyh49rtjjbftytip5m7eetyj','LADY GAGA','w2m7q7nk03cvjt4',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ta5e5wmb1rh8g2dscquxvmo3tw68u9cl6ba3uxmk62h6607uy8', '1yh97m2g4831p8u8c4v11e2lfbpyh49rtjjbftytip5m7eetyj', '0');
-- Arctic Monkeys
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('hv5mok6o0jzqx49', 'Arctic Monkeys', '20@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:20@artist.com', 'hv5mok6o0jzqx49', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('hv5mok6o0jzqx49', 'Rock innovators, known for their sharp lyrics and compelling sound.', 'Arctic Monkeys');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('z6rmmywyn3hx00ovm6cw3ybh75d328ufz9l3ov3nm5wxdpehw8','hv5mok6o0jzqx49', 'https://i.scdn.co/image/ab67616d0000b2734ae1c4c5c45aabe565499163', 'Arctic Monkeys Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('0zksl209wi1fw13ltu79bsbsqu34ooxg8qqqxj0qo97v05c8at','I Wanna Be Yours','hv5mok6o0jzqx49',100,'POP','5XeFesFbtLpXzIVDNQP22n','https://p.scdn.co/mp3-preview/07de30bde8363d9ff78b72339245c151f67af451?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('z6rmmywyn3hx00ovm6cw3ybh75d328ufz9l3ov3nm5wxdpehw8', '0zksl209wi1fw13ltu79bsbsqu34ooxg8qqqxj0qo97v05c8at', '0');
-- Bizarrap
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('rx8jo8ufgmvupif', 'Bizarrap', '21@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:21@artist.com', 'rx8jo8ufgmvupif', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('rx8jo8ufgmvupif', 'Revolutionizing the music scene with his unique production style and collaborations.', 'Bizarrap');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('62evzorx2ww2keakfja5k2nd0rq6n9dc9o1zd6ara1mlxhoq0n','rx8jo8ufgmvupif', 'https://i.scdn.co/image/ab67616d0000b27315583045b2fdb7d7bab10e81', 'Bizarrap Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('bzvf7zwp44wmc01gejcigfl3byis7m97bafkf4f84k51itocvl','Peso Pluma: Bzrp Music Sessions, Vol. 55','rx8jo8ufgmvupif',100,'POP','5AqiaZwhmC6dIbgWrD5SzV','https://p.scdn.co/mp3-preview/9d61998a29c2e8b52a7d46885352f5507eb219e2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('62evzorx2ww2keakfja5k2nd0rq6n9dc9o1zd6ara1mlxhoq0n', 'bzvf7zwp44wmc01gejcigfl3byis7m97bafkf4f84k51itocvl', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('myhpbl12n2lyu69znfctleyhx6mu0leimehlimzt6koocg11dp','Quevedo: Bzrp Music Sessions, Vol. 52','rx8jo8ufgmvupif',100,'POP','2tTmW7RDtMQtBk7m2rYeSw','https://p.scdn.co/mp3-preview/e9c0ed735e611f6af45bc946bd4c31590df09ed6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('62evzorx2ww2keakfja5k2nd0rq6n9dc9o1zd6ara1mlxhoq0n', 'myhpbl12n2lyu69znfctleyhx6mu0leimehlimzt6koocg11dp', '1');
-- The Weeknd
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('uwjoqhdtyaer9io', 'The Weeknd', '22@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:22@artist.com', 'uwjoqhdtyaer9io', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('uwjoqhdtyaer9io', 'A trailblazer in the world of R&B, constantly redefining the genre.', 'The Weeknd');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('4gawn3sj5ybch9b9f9tzl92k1irnsnoz9b1ja26nbvm0amlyrz','uwjoqhdtyaer9io', NULL, 'The Weeknd Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('v3plvamvwqknucn1djmlhgpg3mmf668s0cphrrh481qfnhgobh','Popular (with Playboi Carti & Madonna) - The Idol Vol. 1 (Music from the HBO Original Series)','uwjoqhdtyaer9io',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('4gawn3sj5ybch9b9f9tzl92k1irnsnoz9b1ja26nbvm0amlyrz', 'v3plvamvwqknucn1djmlhgpg3mmf668s0cphrrh481qfnhgobh', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('yg2a201npsgvq1d3v7slrlx1qw1fjm1cfz67vfkt82scjdznn7','Creepin','uwjoqhdtyaer9io',100,'POP','0GVaOXDGwtnH8gCURYyEaK','https://p.scdn.co/mp3-preview/a2b11e2f0cb8ef4a0316a686e73da9ec2b203e6e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('4gawn3sj5ybch9b9f9tzl92k1irnsnoz9b1ja26nbvm0amlyrz', 'yg2a201npsgvq1d3v7slrlx1qw1fjm1cfz67vfkt82scjdznn7', '1');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('nb45kpx2g0szmp2plcnac8mqzmslqfgxwmldfviwp0sl9x2yf5','Die For You','uwjoqhdtyaer9io',100,'POP','2LBqCSwhJGcFQeTHMVGwy3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('4gawn3sj5ybch9b9f9tzl92k1irnsnoz9b1ja26nbvm0amlyrz', 'nb45kpx2g0szmp2plcnac8mqzmslqfgxwmldfviwp0sl9x2yf5', '2');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('dvhd4uk1kwq1fh0pkvym5dh87surzmv2fjb2lthy1t38gi86su','Starboy','uwjoqhdtyaer9io',100,'POP','7MXVkk9YMctZqd1Srtv4MB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('4gawn3sj5ybch9b9f9tzl92k1irnsnoz9b1ja26nbvm0amlyrz', 'dvhd4uk1kwq1fh0pkvym5dh87surzmv2fjb2lthy1t38gi86su', '3');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('if4lo46r1mbz0pgzljkv3uud7stbr445lefyvxrwd8ouu2chvi','Blinding Lights','uwjoqhdtyaer9io',100,'POP','0VjIjW4GlUZAMYd2vXMi3b',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('4gawn3sj5ybch9b9f9tzl92k1irnsnoz9b1ja26nbvm0amlyrz', 'if4lo46r1mbz0pgzljkv3uud7stbr445lefyvxrwd8ouu2chvi', '4');
-- Fuerza Regida
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('10tcocqx884solc', 'Fuerza Regida', '23@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1b85fbf9507041aab224336d','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:23@artist.com', '10tcocqx884solc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('10tcocqx884solc', 'Revitalizing the regional music scene with their unique sound and powerful lyrics.', 'Fuerza Regida');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('9wsvsuoeff9viroa24dx05j7pn6c746ze8mtp1f7ku2rvj2dfp','10tcocqx884solc', 'https://i.scdn.co/image/ab67616d0000b273cfe3eb72c48b93971e53efd9', 'Fuerza Regida Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('m39v06lx533u5880xvvrgvbgyz9z48aw20fgw7fnuqnkzercyu','SABOR FRESA','10tcocqx884solc',100,'POP','1UMm1Qs3u59Wvk53zBUE8r','https://p.scdn.co/mp3-preview/590ae0b69465339d97ef5db9f7e36fe0c452fbb4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('9wsvsuoeff9viroa24dx05j7pn6c746ze8mtp1f7ku2rvj2dfp', 'm39v06lx533u5880xvvrgvbgyz9z48aw20fgw7fnuqnkzercyu', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('zp0kxerye8254u1i3rzbj0yty3shrsh2ezetj1jvcphq1wmfib','TQM','10tcocqx884solc',100,'POP','368eeEO3Y2uZUQ6S5oIjcu','https://p.scdn.co/mp3-preview/63f6b66cfcc3d7bd396dcbe18d6e3dee05fdb956?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('9wsvsuoeff9viroa24dx05j7pn6c746ze8mtp1f7ku2rvj2dfp', 'zp0kxerye8254u1i3rzbj0yty3shrsh2ezetj1jvcphq1wmfib', '1');
-- Rma
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('zungbvj62tl0ajc', 'Rma', '24@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0c8eb928813cd06614c0710d','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:24@artist.com', 'zungbvj62tl0ajc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('zungbvj62tl0ajc', 'Pioneering new sounds and delivering electrifying performances.', 'Rma');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('gokrauy37yz2030x5r65o2i8dffo5huz03iwz92pjbktuhqc39','zungbvj62tl0ajc', NULL, 'Rma Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('lfmlxcxjoik1romdhjsbbsso6w1m4o2n7bx0fdzsoa881cw62y','Calm Down (with Selena Gomez)','zungbvj62tl0ajc',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('gokrauy37yz2030x5r65o2i8dffo5huz03iwz92pjbktuhqc39', 'lfmlxcxjoik1romdhjsbbsso6w1m4o2n7bx0fdzsoa881cw62y', '0');
-- Tainy
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('rkds4qvv77d37hx', 'Tainy', '25@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb50d43598b9074f0d6146127','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:25@artist.com', 'rkds4qvv77d37hx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('rkds4qvv77d37hx', 'Revolutionizing reggaeton and Latin music with groundbreaking production.', 'Tainy');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('bpfjooht6e47czk99g2xvmuiv7uxcf5rm5qcnizc6sxjzswins','rkds4qvv77d37hx', 'https://i.scdn.co/image/ab67616d0000b273de7b9af78fbdda96c5a0635b', 'Tainy Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('qa71m2r9fqo0d4xxaro2m7lwjaorwalm0nxcvi8rs7uys7af52','MOJABI GHOST','rkds4qvv77d37hx',100,'POP','4eMKD8MRroxCqugpsxCCNb','https://p.scdn.co/mp3-preview/a6d8180d52b759c3e3db9aa78e841ffc06e26c17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('bpfjooht6e47czk99g2xvmuiv7uxcf5rm5qcnizc6sxjzswins', 'qa71m2r9fqo0d4xxaro2m7lwjaorwalm0nxcvi8rs7uys7af52', '0');
-- Morgan Wallen
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('gyx92w58o8zrehm', 'Morgan Wallen', '26@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb21ed0100a3a4e5aa3c57f6dd','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:26@artist.com', 'gyx92w58o8zrehm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('gyx92w58o8zrehm', 'Blending country charm with rock energy to create memorable tunes.', 'Morgan Wallen');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('p8ta43wzq5gl9rstg7lhtcgdlj1w5dbbddfguxn82lzl1wht4z','gyx92w58o8zrehm', 'https://i.scdn.co/image/ab67616d0000b273705079df9a25a28b452c1fc9', 'Morgan Wallen Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('t6qx0zyhap7rcod4p4gb3kourb7kq4j6zpbpq6k5hbybgzswtp','Last Night','gyx92w58o8zrehm',100,'POP','7K3BhSpAxZBznislvUMVtn',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('p8ta43wzq5gl9rstg7lhtcgdlj1w5dbbddfguxn82lzl1wht4z', 't6qx0zyhap7rcod4p4gb3kourb7kq4j6zpbpq6k5hbybgzswtp', '0');
-- Dua Lipa
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('jqjb1ehgl9wisio', 'Dua Lipa', '27@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1bbee4a02f85ecc58d385c3e','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:27@artist.com', 'jqjb1ehgl9wisio', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('jqjb1ehgl9wisio', 'A pop phenomenon, known for her empowering anthems and dynamic presence.', 'Dua Lipa');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('f5kvm7l57y6ibe65jwb9z3jty67ydqk36y5okelvtrrp41bw1k','jqjb1ehgl9wisio', 'https://i.scdn.co/image/ab67616d0000b2737dd3ba455ee3390cb55b0192', 'Dua Lipa Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('o6w97jmg7cwuhy51ebl70juapchvgz2ft03kpky0n9yynfk4v4','Dance The Night (From Barbie The Album)','jqjb1ehgl9wisio',100,'POP','1vYXt7VSjH9JIM5oRRo7vA','https://p.scdn.co/mp3-preview/acaea048f50a3b30ca24b348c84a6047373baabb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('f5kvm7l57y6ibe65jwb9z3jty67ydqk36y5okelvtrrp41bw1k', 'o6w97jmg7cwuhy51ebl70juapchvgz2ft03kpky0n9yynfk4v4', '0');
-- Troye Sivan
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('3fcjnk3icrzd6zl', 'Troye Sivan', '28@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb26e8cb3ff6fc7744b312811b','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:28@artist.com', '3fcjnk3icrzd6zl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('3fcjnk3icrzd6zl', 'A voice that encapsulates the spirit of modern pop.', 'Troye Sivan');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('nd2mbhk5ugmutexui93ivu6omlzkzgui46licfw1cbjltk26u0','3fcjnk3icrzd6zl', 'https://i.scdn.co/image/ab67616d0000b27367103283a4eb57578a428252', 'Troye Sivan Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('luj5ehcsyyvyt1s3txwadbjaz9rlro8zcztxp1sugirsuloefz','Rush','3fcjnk3icrzd6zl',100,'POP','4ZnkygoWLzcGbQYCm3lkae',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('nd2mbhk5ugmutexui93ivu6omlzkzgui46licfw1cbjltk26u0', 'luj5ehcsyyvyt1s3txwadbjaz9rlro8zcztxp1sugirsuloefz', '0');
-- Karol G
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('lwxgcfkqsb4mcmz', 'Karol G', '29@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeb97a2403d7b9a631ce0f59c','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:29@artist.com', 'lwxgcfkqsb4mcmz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('lwxgcfkqsb4mcmz', 'A queen of reggaeton, known for her empowering anthems and vibrant performances.', 'Karol G');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('y380efjliqnl2obppa660vkhtm74tfq9e3tzjo3b0i6pkalkf3','lwxgcfkqsb4mcmz', 'https://i.scdn.co/image/ab67616d0000b27382de1ca074ae63cb18fce335', 'Karol G Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('8fxoe0py6aityi7yobp0x6hj4t1lym8jbzoez78dbc43e9tb6t','TQG','lwxgcfkqsb4mcmz',100,'POP','0DWdj2oZMBFSzRsi2Cvfzf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('y380efjliqnl2obppa660vkhtm74tfq9e3tzjo3b0i6pkalkf3', '8fxoe0py6aityi7yobp0x6hj4t1lym8jbzoez78dbc43e9tb6t', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('1h2bn8fhac68m4oo9xpyn8m30nzj007uh4raakhvgd706tkcu0','AMARGURA','lwxgcfkqsb4mcmz',100,'POP','505v13epFXodT9fVAJ6h8k',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('y380efjliqnl2obppa660vkhtm74tfq9e3tzjo3b0i6pkalkf3', '1h2bn8fhac68m4oo9xpyn8m30nzj007uh4raakhvgd706tkcu0', '1');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('gcbecuozdgjaiojnbekez6915gxn13z37l1oc51aov4yk5tar9','S91','lwxgcfkqsb4mcmz',100,'POP','7EpOXgSRgnglRWr86pZfGU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('y380efjliqnl2obppa660vkhtm74tfq9e3tzjo3b0i6pkalkf3', 'gcbecuozdgjaiojnbekez6915gxn13z37l1oc51aov4yk5tar9', '2');
-- Big One
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('fbzotuu0jjge0l9', 'Big One', '30@artist.com', 'https://i.scdn.co/image/ab67616d0000b273ba9f82cc282b2de6cf7c0246','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:30@artist.com', 'fbzotuu0jjge0l9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('fbzotuu0jjge0l9', 'Bringing a unique energy to every track, fusing various styles into a cohesive sound.', 'Big One');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('l8rmkx7gfp0raseltavrw48mlq86l0sfwiwqr5by2xetc9q4ar','fbzotuu0jjge0l9', NULL, 'Big One Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('0qqwfa8pd6fb69v2qaixll53y5dvxyo8bxj8f978v81kba7eys','Los del Espacio','fbzotuu0jjge0l9',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('l8rmkx7gfp0raseltavrw48mlq86l0sfwiwqr5by2xetc9q4ar', '0qqwfa8pd6fb69v2qaixll53y5dvxyo8bxj8f978v81kba7eys', '0');
-- Yahritza Y Su Esencia
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('0insi15lvphzxza', 'Yahritza Y Su Esencia', '31@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb68d4ccdc175f594122f1eee1','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:31@artist.com', '0insi15lvphzxza', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('0insi15lvphzxza', 'Infusing traditional melodies with youthful vigor.', 'Yahritza Y Su Esencia');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('fffasoqsc60425h6zatajym0scj2dx8idoucal9fcm1lnlnryh','0insi15lvphzxza', NULL, 'Yahritza Y Su Esencia Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('zvjgkqh39hbfdvdmgl8f5cya7x6hq5ga2vksaifnakx6un4bwj','Frgil (feat. Grupo Front','0insi15lvphzxza',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('fffasoqsc60425h6zatajym0scj2dx8idoucal9fcm1lnlnryh', 'zvjgkqh39hbfdvdmgl8f5cya7x6hq5ga2vksaifnakx6un4bwj', '0');
-- Junior H
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('jawky53hawxzmsd', 'Junior H', '32@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5ccab5d3dc10a08d89cbd76','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:32@artist.com', 'jawky53hawxzmsd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('jawky53hawxzmsd', 'A fresh voice in regional Mexican music, blending tradition with modernity.', 'Junior H');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ywounlji6ucva5kxph1ghwo3xg2lf3xi2z02gcooqxgihrmc01','jawky53hawxzmsd', 'https://i.scdn.co/image/ab67616d0000b27333ed356efed99b158c4267c6', 'Junior H Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('dcznt7iashvjql4whpv597jg1dogmvjwh0bgby203hh27jwefy','El Azul','jawky53hawxzmsd',100,'POP','1haJsMtoBhHfvuM7XWuT3W','https://p.scdn.co/mp3-preview/f9df136c3a2d3c0c5424e2c4b75a303f35c08af5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ywounlji6ucva5kxph1ghwo3xg2lf3xi2z02gcooqxgihrmc01', 'dcznt7iashvjql4whpv597jg1dogmvjwh0bgby203hh27jwefy', '0');
-- Post Malone
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('9vv5g46tb4so419', 'Post Malone', '33@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf1be22786da29b0a1284c0a5','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:33@artist.com', '9vv5g46tb4so419', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('9vv5g46tb4so419', 'Blurring genre lines with his unique blend of hip-hop and pop.', 'Post Malone');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('rwkl19tdqgth43q05z43uplkf3sniht6sh2oxrspeu7ac32key','9vv5g46tb4so419', 'https://i.scdn.co/image/ab67616d0000b2739478c87599550dd73bfa7e02', 'Post Malone Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('5duyx4uharooftpsplp7pr3fpvgxp2cvdjc0i2gbu5fb7kvtk6','Sunflower - Spider-Man: Into the Spider-Verse','9vv5g46tb4so419',100,'POP','0RiRZpuVRbi7oqRdSMwhQY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('rwkl19tdqgth43q05z43uplkf3sniht6sh2oxrspeu7ac32key', '5duyx4uharooftpsplp7pr3fpvgxp2cvdjc0i2gbu5fb7kvtk6', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('b2bvbervcizkr2kbzqgf1f9jeo9m7j757x8jhsnkf6be9s0ncd','Overdrive','9vv5g46tb4so419',100,'POP','3t0ic4mkhvhamrKDkulB8v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('rwkl19tdqgth43q05z43uplkf3sniht6sh2oxrspeu7ac32key', 'b2bvbervcizkr2kbzqgf1f9jeo9m7j757x8jhsnkf6be9s0ncd', '1');
-- Bebe Rexha
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('kjt7i5o45173hvd', 'Bebe Rexha', '34@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc692afc666512dc946a7358f','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:34@artist.com', 'kjt7i5o45173hvd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('kjt7i5o45173hvd', 'A dynamic voice in pop music, known for her powerful vocals and catchy tunes.', 'Bebe Rexha');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('g6ef6l3k05tet59cuzik0emtdaj3d0c5kt7s0o6x5wykn2kij5','kjt7i5o45173hvd', NULL, 'Bebe Rexha Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('k9h2pwtb9i2gpoo7go337fpptxxgucxrvblwnpp56m1pac8gfd','Im Good (Blue)','kjt7i5o45173hvd',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('g6ef6l3k05tet59cuzik0emtdaj3d0c5kt7s0o6x5wykn2kij5', 'k9h2pwtb9i2gpoo7go337fpptxxgucxrvblwnpp56m1pac8gfd', '0');
-- Tyler The Creator
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('573fjyjj6nvs6zg', 'Tyler The Creator', '35@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8278b782cbb5a3963db88ada','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:35@artist.com', '573fjyjj6nvs6zg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('573fjyjj6nvs6zg', 'Pushing the boundaries of music with unique style and bold lyrics.', 'Tyler The Creator');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('svr5h04nyxw2pjfer5utek7tdkiaip5j4mhwfotne1hfcyi10t','573fjyjj6nvs6zg', 'https://i.scdn.co/image/ab67616d0000b2738940ac99f49e44f59e6f7fb3', 'Tyler The Creator Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('usnqyr7xfw547evzlj4l1f02re4oekn1necepykmsgb65ykfyq','See You Again','573fjyjj6nvs6zg',100,'POP','7KA4W4McWYRpgf0fWsJZWB','https://p.scdn.co/mp3-preview/c703198293891e3b276800ea6b187cf7951d3d7d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('svr5h04nyxw2pjfer5utek7tdkiaip5j4mhwfotne1hfcyi10t', 'usnqyr7xfw547evzlj4l1f02re4oekn1necepykmsgb65ykfyq', '0');
-- Nicki Minaj
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('ogp1dirund55vol', 'Nicki Minaj', '36@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03578c92e15089c645b794f5','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:36@artist.com', 'ogp1dirund55vol', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ogp1dirund55vol', 'A rap icon known for her versatile flow and bold personality.', 'Nicki Minaj');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('cxn6u7mbpijgkusqeye0w46v60ib95zz2zgz4qsk0oo5k3werw','ogp1dirund55vol', 'https://i.scdn.co/image/ab67616d0000b2737e8f938c02fac3b564931116', 'Nicki Minaj Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('0z9isuw79ip6ocr8olxdlob16s122o1hqn4znfpg6dlk1pdhyz','Barbie World (with Aqua) [From Barbie The Album]','ogp1dirund55vol',100,'POP','741UUVE2kuITl0c6zuqqbO','https://p.scdn.co/mp3-preview/f654928ccaa4e6a9fb09a6eb3f208383eccc12a9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cxn6u7mbpijgkusqeye0w46v60ib95zz2zgz4qsk0oo5k3werw', '0z9isuw79ip6ocr8olxdlob16s122o1hqn4znfpg6dlk1pdhyz', '0');
-- OneRepublic
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('8q8fcidruodg1f0', 'OneRepublic', '37@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb57138b98e7ddd5a86ee97a9b','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:37@artist.com', '8q8fcidruodg1f0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('8q8fcidruodg1f0', 'Delivering anthemic pop-rock tracks that resonate globally.', 'OneRepublic');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('vftlgqmp80l6shxx5irbqacsah00lfztxqdn78yawde3loge7c','8q8fcidruodg1f0', 'https://i.scdn.co/image/ab67616d0000b273ec96e006b8bdfc582610ec13', 'OneRepublic Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('d3ewjfa03ngg07k5trxa6a7qfx2kiddt1vzn2hdd49ejblyi9t','I Aint Worried','8q8fcidruodg1f0',100,'POP','4h9wh7iOZ0GGn8QVp4RAOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('vftlgqmp80l6shxx5irbqacsah00lfztxqdn78yawde3loge7c', 'd3ewjfa03ngg07k5trxa6a7qfx2kiddt1vzn2hdd49ejblyi9t', '0');
-- Ariana Grande
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('akrn0rvb1ndxnap', 'Ariana Grande', '38@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb456c82553e0efcb7e13365b1','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:38@artist.com', 'akrn0rvb1ndxnap', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('akrn0rvb1ndxnap', 'A powerhouse vocalist, dominating pop with her range and iconic style.', 'Ariana Grande');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('v9pzbdr86vqejbild38jilwredty4dzn4oqfg1wzkvk5ygblva','akrn0rvb1ndxnap', NULL, 'Ariana Grande Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('k8v0wux17d4mbjnvgjstabcnv62gk4jho4j86qkcz7bbh7t8b7','Die For You - Remix','akrn0rvb1ndxnap',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('v9pzbdr86vqejbild38jilwredty4dzn4oqfg1wzkvk5ygblva', 'k8v0wux17d4mbjnvgjstabcnv62gk4jho4j86qkcz7bbh7t8b7', '0');
-- David Guetta
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('ssd2thnrg39a1si', 'David Guetta', '39@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0448096d85094a6ec5e8fab','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:39@artist.com', 'ssd2thnrg39a1si', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ssd2thnrg39a1si', 'A legend in the electronic music world, constantly innovating and entertaining.', 'David Guetta');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('0kri2h33oxq4wgw4fr7967z3w2fsam1h7xkvt7b7qy8bz8zj9e','ssd2thnrg39a1si', 'https://i.scdn.co/image/ab67616d0000b2730b4ef75c3728599aa4104f7a', 'David Guetta Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('qvyash7bhxx0fldwrk7es2wfn73shggj7kz9cejljfh9fqe63b','Baby Dont Hurt Me','ssd2thnrg39a1si',100,'POP','3BKD1PwArikchz2Zrlp1qi','https://p.scdn.co/mp3-preview/a8f2e176e17e0f6298b42ef8e96118318fdd2b89?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('0kri2h33oxq4wgw4fr7967z3w2fsam1h7xkvt7b7qy8bz8zj9e', 'qvyash7bhxx0fldwrk7es2wfn73shggj7kz9cejljfh9fqe63b', '0');
-- Peggy Gou
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('2k3l3wcps0zx30h', 'Peggy Gou', '40@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf5c17aa075c03c5c4d2c693','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:40@artist.com', '2k3l3wcps0zx30h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('2k3l3wcps0zx30h', 'A dynamic force in the electronic music scene, known for her eclectic mixes.', 'Peggy Gou');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('5nk13apclctb7jvuva1gfas7zpa2aa5qvsgjjhl6y1jyq9brjm','2k3l3wcps0zx30h', 'https://i.scdn.co/image/ab67616d0000b27388d71aadd009fe1a83df88f2', 'Peggy Gou Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('g0yc7t18x703wxx8g547xwx4p4it883iq8rf4my8a46mu7yqy3','(It Goes Like) Nanana - Edit','2k3l3wcps0zx30h',100,'POP','23RoR84KodL5HWvUTneQ1w','https://p.scdn.co/mp3-preview/e36e0bd4714844f1f9d992398b41a3e333f15cc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('5nk13apclctb7jvuva1gfas7zpa2aa5qvsgjjhl6y1jyq9brjm', 'g0yc7t18x703wxx8g547xwx4p4it883iq8rf4my8a46mu7yqy3', '0');
-- Tom Odell
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('yo9w9wbwrt8ahrj', 'Tom Odell', '41@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb532e8dd8ba9fbd5e78105a78','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:41@artist.com', 'yo9w9wbwrt8ahrj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('yo9w9wbwrt8ahrj', 'Stirring emotions with piano-driven melodies and poetic lyrics.', 'Tom Odell');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('2f574epa3yaajwza4114hbzlbva0kxbr603yrtbzyoc22crl3x','yo9w9wbwrt8ahrj', 'https://i.scdn.co/image/ab67616d0000b2731917a0f3f4152622a040913f', 'Tom Odell Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('nqzdkoak2wcwvlp53hd3k1ds8u4q6bjg3rqvghprr0pyfm3zh7','Another Love','yo9w9wbwrt8ahrj',100,'POP','3JvKfv6T31zO0ini8iNItO','https://p.scdn.co/mp3-preview/0369cb748bc968ffd34fb4ac60f5403f2aad032f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('2f574epa3yaajwza4114hbzlbva0kxbr603yrtbzyoc22crl3x', 'nqzdkoak2wcwvlp53hd3k1ds8u4q6bjg3rqvghprr0pyfm3zh7', '0');
-- Kali Uchis
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('tisuq2vnbgcvd45', 'Kali Uchis', '42@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb51dfdac248da65a860963b68','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:42@artist.com', 'tisuq2vnbgcvd45', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('tisuq2vnbgcvd45', 'A fusion of soul, R&B, and Latin beats, creating a unique sound experience.', 'Kali Uchis');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('2b326cc441jgmkld1xyczb4hqktjax17mrggwi6uq56yp96eqz','tisuq2vnbgcvd45', 'https://i.scdn.co/image/ab67616d0000b27381fccd758776d16b87721b17', 'Kali Uchis Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('8xb3d4ilbxitkwf7l78gvq8wa2vmb7dppng3a6l3dd2lmvc3dr','Moonlight','tisuq2vnbgcvd45',100,'POP','0JmnkIqdlnUzPaf8sqBRs3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('2b326cc441jgmkld1xyczb4hqktjax17mrggwi6uq56yp96eqz', '8xb3d4ilbxitkwf7l78gvq8wa2vmb7dppng3a6l3dd2lmvc3dr', '0');
-- Manuel Turizo
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('8u6dnmye0yrr0dd', 'Manuel Turizo', '43@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebabd3e69b432d6187cf4e28c3','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:43@artist.com', '8u6dnmye0yrr0dd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('8u6dnmye0yrr0dd', 'A standout in reggaeton, known for his smooth voice and romantic lyrics.', 'Manuel Turizo');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ny1barjjkv3nz3slfn2817ld6k0knmdf6h3agxkj8etni5alb5','8u6dnmye0yrr0dd', 'https://i.scdn.co/image/ab67616d0000b273c9f744b0d62da795bc21d04a', 'Manuel Turizo Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('dowrfkxf3gujf4y6gs4bh99lhd54abksjs6g9knkq6sd9f0bb4','La Bachata','8u6dnmye0yrr0dd',100,'POP','5ww2BF9slyYgNOk37BlC4u','https://p.scdn.co/mp3-preview/0232b53fd7849e6696e1ab3099dd01dd00823f17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ny1barjjkv3nz3slfn2817ld6k0knmdf6h3agxkj8etni5alb5', 'dowrfkxf3gujf4y6gs4bh99lhd54abksjs6g9knkq6sd9f0bb4', '0');
-- dennis
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('1s07azuwn0rz8pp', 'dennis', '44@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8a1ec9781a1542458b3b961b','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:44@artist.com', '1s07azuwn0rz8pp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('1s07azuwn0rz8pp', 'Crafting soundscapes that transport listeners to another world.', 'dennis');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('emcux0k1wcqe8zsf8f6q0tvlpy25lvg8zziquzc9nelvs6d8f3','1s07azuwn0rz8pp', 'https://i.scdn.co/image/ab67616d0000b273ddfc406de0d7dbc2e339f016', 'dennis Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('2m6y901ud28jeg0fnqqs20z8tzmw1pamddafxpu6u4tougucrx','T','1s07azuwn0rz8pp',100,'POP','35FW5OEe4p38LdjK1KqT2X','https://p.scdn.co/mp3-preview/eaa522f48564e43e33e00c011aef0489526d1072?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('emcux0k1wcqe8zsf8f6q0tvlpy25lvg8zziquzc9nelvs6d8f3', '2m6y901ud28jeg0fnqqs20z8tzmw1pamddafxpu6u4tougucrx', '0');
-- PinkPantheress
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('vkaz6c6ykp3ix7i', 'PinkPantheress', '45@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5168e912bd9bd91607cd07dd','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:45@artist.com', 'vkaz6c6ykp3ix7i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('vkaz6c6ykp3ix7i', 'Redefining pop music with her distinct sound and style.', 'PinkPantheress');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('0nvofqww0o34f3346yuq487zl28o7vo5umi7kx4k0jumkwlwd0','vkaz6c6ykp3ix7i', 'https://i.scdn.co/image/ab67616d0000b2739567e1aa41657425d046733b', 'PinkPantheress Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('gtqt96ixqdoob3hrk77nnoo2w7fdgumn38enuo2wd1c45gml7a','Boys a liar Pt. 2','vkaz6c6ykp3ix7i',100,'POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('0nvofqww0o34f3346yuq487zl28o7vo5umi7kx4k0jumkwlwd0', 'gtqt96ixqdoob3hrk77nnoo2w7fdgumn38enuo2wd1c45gml7a', '0');
-- Charlie Puth
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('f2izbjcauqxyrto', 'Charlie Puth', '46@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:46@artist.com', 'f2izbjcauqxyrto', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('f2izbjcauqxyrto', 'A pop maestro, combining catchy melodies with his exceptional musical talent.', 'Charlie Puth');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('pafpzho2wgcf1pizvh9q58iz8naqn5zwr3lfg9k9ho1sh2wchy','f2izbjcauqxyrto', 'https://i.scdn.co/image/ab67616d0000b27335d2e0ed94a934f2cc46fa49', 'Charlie Puth Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('nyl9dqzaakbmvs2ecme50mbg9kj03x5ns4er9hl1rih5y6bg7p','Left and Right (Feat. Jung Kook of BTS)','f2izbjcauqxyrto',100,'POP','5Odq8ohlgIbQKMZivbWkEo','https://p.scdn.co/mp3-preview/9e4342eefa4f33df4e9b199e60dbce0f59e46eff?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('pafpzho2wgcf1pizvh9q58iz8naqn5zwr3lfg9k9ho1sh2wchy', 'nyl9dqzaakbmvs2ecme50mbg9kj03x5ns4er9hl1rih5y6bg7p', '0');
-- Rauw Alejandro
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('tcmvax4iwkmdlx6', 'Rauw Alejandro', '47@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9047f938310ea16b68a5bdeb','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:47@artist.com', 'tcmvax4iwkmdlx6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('tcmvax4iwkmdlx6', 'A fusion of Latin trap and reggaeton, setting the stage on fire.', 'Rauw Alejandro');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('es69f9z4vvur41zryswch20ex6oaylkychckc4sw8g4ykgzznc','tcmvax4iwkmdlx6', NULL, 'Rauw Alejandro Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('1pjt6prl3btj4uctb1ct9n5w8hft27fu05f2b36c2cby4x4n2w','BESO','tcmvax4iwkmdlx6',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('es69f9z4vvur41zryswch20ex6oaylkychckc4sw8g4ykgzznc', '1pjt6prl3btj4uctb1ct9n5w8hft27fu05f2b36c2cby4x4n2w', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('41v4eex9jdzht0gwt474ye8r6jb9cyqhk863fjkg2hdrvzb7v7','BABY HELLO','tcmvax4iwkmdlx6',100,'POP','2SOvWt6igzXViIjIiWNWEP','https://p.scdn.co/mp3-preview/8a9ca6c81e6e6ad48758f02017456405fd7a476d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('es69f9z4vvur41zryswch20ex6oaylkychckc4sw8g4ykgzznc', '41v4eex9jdzht0gwt474ye8r6jb9cyqhk863fjkg2hdrvzb7v7', '1');
-- Ozuna
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('aryl9npriknn0vz', 'Ozuna', '48@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd45efec1d439cfd8bd936421','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:48@artist.com', 'aryl9npriknn0vz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('aryl9npriknn0vz', 'Dominating reggaeton and Latin trap with catchy tunes and charismatic energy.', 'Ozuna');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('waqo9s0uhsyvr25ie7fm18cnunuwyivnfxxyxwlb6pi0pjxmgi','aryl9npriknn0vz', 'https://i.scdn.co/image/ab67616d0000b273125624f2e04f5a1ccb0dfb45', 'Ozuna Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('p6l84yz9usenf15xtfrneu9kgrqj4qcu7i4xhjughzk9dqxodx','Hey Mor','aryl9npriknn0vz',100,'POP','1zsPaEkglFvxjAhrM8yhpr','https://p.scdn.co/mp3-preview/cd2d2242b748408da15c2b66f47d54b3f0793ae0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('waqo9s0uhsyvr25ie7fm18cnunuwyivnfxxyxwlb6pi0pjxmgi', 'p6l84yz9usenf15xtfrneu9kgrqj4qcu7i4xhjughzk9dqxodx', '0');
-- Chris Molitor
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('dx9ium8xd9ij8jl', 'Chris Molitor', '49@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03851b1c2471a8c0b57371c4','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:49@artist.com', 'dx9ium8xd9ij8jl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('dx9ium8xd9ij8jl', 'Delivering heartfelt music that speaks to the soul, blending folk and indie vibes.', 'Chris Molitor');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('bhpkzbwtqukwwlrm364ee29hs4y3mkhb6fo0ynu7zpq4uizjuu','dx9ium8xd9ij8jl', 'https://i.scdn.co/image/ab67616d0000b273be011d16b9360a7dee109774', 'Chris Molitor Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('8319ordx1a08jyywp2e684kjx9jetp7nwqs8a5hjuzsyqin8lm','Yellow','dx9ium8xd9ij8jl',100,'POP','6tvs7zEP8d1SBgSqZQ84OT','https://p.scdn.co/mp3-preview/ea93f9b43fc638111ad661719037bfb88cd9c05d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('bhpkzbwtqukwwlrm364ee29hs4y3mkhb6fo0ynu7zpq4uizjuu', '8319ordx1a08jyywp2e684kjx9jetp7nwqs8a5hjuzsyqin8lm', '0');
-- Libianca
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('i80e23rhcglqfn7', 'Libianca', '50@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a42e7c32ead029c0285c12f','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:50@artist.com', 'i80e23rhcglqfn7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('i80e23rhcglqfn7', 'A fresh talent, blending Afrobeat rhythms with soulful melodies.', 'Libianca');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('cbc09oy14esikierl4uoqyci7skn250fhxx6dwh4x8qv5rnthh','i80e23rhcglqfn7', 'https://i.scdn.co/image/ab67616d0000b273fc342f95f117d48dbdde9735', 'Libianca Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('tstwtginacm98tpv9gjkf5rgdfonmcyvb9ba79jbqdfzqheyco','People','i80e23rhcglqfn7',100,'POP','26b3oVLrRUaaybJulow9kz','https://p.scdn.co/mp3-preview/abcbc9adf10ae4901b40b80a30dc194d589c2d62?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cbc09oy14esikierl4uoqyci7skn250fhxx6dwh4x8qv5rnthh', 'tstwtginacm98tpv9gjkf5rgdfonmcyvb9ba79jbqdfzqheyco', '0');
-- Glass Animals
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('hqjiqag184rfn5e', 'Glass Animals', '51@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb66b27eccb69756f8eceabc23','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:51@artist.com', 'hqjiqag184rfn5e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('hqjiqag184rfn5e', 'Crafting psychedelic pop with intricate melodies and immersive soundscapes.', 'Glass Animals');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('mr61ps62prdi2pk1mol9cgqp8c5ox1ous847mkw7hrbipj8qcg','hqjiqag184rfn5e', 'https://i.scdn.co/image/ab67616d0000b273712701c5e263efc8726b1464', 'Glass Animals Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('5uqmhii9amnf28eziql8kibrcfo49aat2cpglvgmorr7eluqgh','Heat Waves','hqjiqag184rfn5e',100,'POP','3USxtqRwSYz57Ewm6wWRMp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('mr61ps62prdi2pk1mol9cgqp8c5ox1ous847mkw7hrbipj8qcg', '5uqmhii9amnf28eziql8kibrcfo49aat2cpglvgmorr7eluqgh', '0');
-- JVKE
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('o4pnx4jx4sowdyj', 'JVKE', '52@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebce33386a81a202e149934ec1','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:52@artist.com', 'o4pnx4jx4sowdyj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('o4pnx4jx4sowdyj', 'A rising star, blending heartfelt lyrics with catchy pop melodies.', 'JVKE');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('8wwqwk463zsy8bkikv90bgcft84tthvx7sv443nx87kc229nyj','o4pnx4jx4sowdyj', 'https://i.scdn.co/image/ab67616d0000b273c2504e80ba2f258697ab2954', 'JVKE Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('gm8ruhcut3oanjptkx5kq4rbzajt5f62hp20dr6frapkgvqw5q','golden hour','o4pnx4jx4sowdyj',100,'POP','5odlY52u43F5BjByhxg7wg','https://p.scdn.co/mp3-preview/bcc17f30841d6fbf3cd7954c3e3cf669f11b6a21?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('8wwqwk463zsy8bkikv90bgcft84tthvx7sv443nx87kc229nyj', 'gm8ruhcut3oanjptkx5kq4rbzajt5f62hp20dr6frapkgvqw5q', '0');
-- The Neighbourhood
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('0yemrc6nxifmh43', 'The Neighbourhood', '53@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf0b5ac84376a0a4b2166816','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:53@artist.com', '0yemrc6nxifmh43', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('0yemrc6nxifmh43', 'Melding alternative rock with introspective lyrics.', 'The Neighbourhood');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('177vghosz0c9ytjekznp04gqqak69tpdcz4x9qqryxi3u9fufh','0yemrc6nxifmh43', 'https://i.scdn.co/image/ab67616d0000b2738265a736a1eb838ad5a0b921', 'The Neighbourhood Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('h2qn9b12hbl9jmuqbzs5k93dutwtwdbnh6u37f0pjippu6tpz5','Sweater Weather','0yemrc6nxifmh43',100,'POP','2QjOHCTQ1Jl3zawyYOpxh6','https://p.scdn.co/mp3-preview/877602f424a9dea277b13301ffc516f9fd1fbe7e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('177vghosz0c9ytjekznp04gqqak69tpdcz4x9qqryxi3u9fufh', 'h2qn9b12hbl9jmuqbzs5k93dutwtwdbnh6u37f0pjippu6tpz5', '0');
-- Coldplay
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('ioiivx0uuc7a5nf', 'Coldplay', '54@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb989ed05e1f0570cc4726c2d3','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:54@artist.com', 'ioiivx0uuc7a5nf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ioiivx0uuc7a5nf', 'Global icons in rock, known for their anthemic songs and impactful lyrics.', 'Coldplay');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('6oqyopuovfy6cswwthg94m9o73zjh7nfdfixxt222rt8slhpur','ioiivx0uuc7a5nf', 'https://i.scdn.co/image/ab67616d0000b273e21cc1db05580b6f2d2a3b6e', 'Coldplay Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('cs1a4njbjxmqlj4uippwrns47ewaedeq9126f7gkxtp8d0lkzd','Viva La Vida','ioiivx0uuc7a5nf',100,'POP','1mea3bSkSGXuIRvnydlB5b','https://p.scdn.co/mp3-preview/fb9f4a9b0887326776b4fb7c6d331acd167a7778?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('6oqyopuovfy6cswwthg94m9o73zjh7nfdfixxt222rt8slhpur', 'cs1a4njbjxmqlj4uippwrns47ewaedeq9126f7gkxtp8d0lkzd', '0');
-- d4vd
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('uzt0dmih4ahw1kx', 'd4vd', '55@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebad447187a35f422307e88ad3','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:55@artist.com', 'uzt0dmih4ahw1kx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('uzt0dmih4ahw1kx', 'Sculpting soundwaves into masterpieces of auditory art.', 'd4vd');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('4e8kad5w4jzit1i2v0gkgylczv2k1lened7v1w50fcstefaq4a','uzt0dmih4ahw1kx', 'https://i.scdn.co/image/ab67616d0000b27364fa1bda999f4fbd2b7c4bb7', 'd4vd Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('089sno7hj5g2sfthtf3xocy278xh4hjlgx0ovpl689hvsw7xi7','Here With Me','uzt0dmih4ahw1kx',100,'POP','5LrN7yUQAzvthd4QujgPFr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('4e8kad5w4jzit1i2v0gkgylczv2k1lened7v1w50fcstefaq4a', '089sno7hj5g2sfthtf3xocy278xh4hjlgx0ovpl689hvsw7xi7', '0');
-- Sam Smith
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('fscfdr740b4f0yy', 'Sam Smith', '56@artist.com', 'https://i.scdn.co/image/c589b50021995a40811097e48a9c65f9c4b423ea','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:56@artist.com', 'fscfdr740b4f0yy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('fscfdr740b4f0yy', 'A soulful voice delivering deep emotional resonance.', 'Sam Smith');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('7ov4j0u1ejudhyxhdo9zkg2p1hnzig580opehigyf2fgntb2na','fscfdr740b4f0yy', 'https://i.scdn.co/image/ab67616d0000b273a935e4689f15953311772cc4', 'Sam Smith Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('yr55zerbfh376gugwjls58wrmsaaf9it0oixpn0uwmq5oixdc0','Unholy (feat. Kim Petras)','fscfdr740b4f0yy',100,'POP','3nqQXoyQOWXiESFLlDF1hG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('7ov4j0u1ejudhyxhdo9zkg2p1hnzig580opehigyf2fgntb2na', 'yr55zerbfh376gugwjls58wrmsaaf9it0oixpn0uwmq5oixdc0', '0');
-- Yandel
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('2jv4n9teci7ek48', 'Yandel', '57@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7dbaf2fabcbd4b37168397fd','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:57@artist.com', '2jv4n9teci7ek48', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('2jv4n9teci7ek48', 'A powerhouse of reggaeton, blending rhythms that move the soul.', 'Yandel');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('5jc4p3menkh2hpjcrcy4zqh1sszpp13f7019kbho98ouwbszx2','2jv4n9teci7ek48', 'https://i.scdn.co/image/ab67616d0000b273b2aec01b56eeb74610532700', 'Yandel Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('hf3prhvjlip7yfwutktw6on8po7ixc5pmum0gw5g0ml23jgu8h','Yandel 150','2jv4n9teci7ek48',100,'POP','4FAKtPVycI4DxoOHC01YqD','https://p.scdn.co/mp3-preview/338ed053ce26ccc3313b00b5e6153e60ffd2eb19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('5jc4p3menkh2hpjcrcy4zqh1sszpp13f7019kbho98ouwbszx2', 'hf3prhvjlip7yfwutktw6on8po7ixc5pmum0gw5g0ml23jgu8h', '0');
-- Maria Becerra
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('mdl2ksmryfgm3s9', 'Maria Becerra', '58@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb6cfa517b8f5a152d63c4ffb','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:58@artist.com', 'mdl2ksmryfgm3s9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('mdl2ksmryfgm3s9', 'A vibrant new voice in Latin pop, fusing catchy melodies with urban sounds.', 'Maria Becerra');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('sa6vt59xgp850h1vbtbrtn43zixbujaz9mm62pwjopovv6ksf3','mdl2ksmryfgm3s9', NULL, 'Maria Becerra Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('52ala31buxhnf2h2h1jjantdgtmwi8qe9oo9g173k6qupkryza','CORAZN VA','mdl2ksmryfgm3s9',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('sa6vt59xgp850h1vbtbrtn43zixbujaz9mm62pwjopovv6ksf3', '52ala31buxhnf2h2h1jjantdgtmwi8qe9oo9g173k6qupkryza', '0');
-- Vance Joy
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('k67nvq98fxtltfz', 'Vance Joy', '59@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f074ec8c25406680bf26422','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:59@artist.com', 'k67nvq98fxtltfz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('k67nvq98fxtltfz', 'Crafting folk-pop anthems that resonate with heartfelt sincerity.', 'Vance Joy');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('fobjcchqrh9rmd0iy2zq570y959e8za34ilrwjmeh0iyz4etym','k67nvq98fxtltfz', 'https://i.scdn.co/image/ab67616d0000b273a9929deb093a6617d2493b03', 'Vance Joy Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('gznwvd9l3ootp02efqcwpj4lq6jbm77fs82oyosu92axgusx15','Riptide','k67nvq98fxtltfz',100,'POP','3JvrhDOgAt6p7K8mDyZwRd','https://p.scdn.co/mp3-preview/74698d907d114f4ba0b2c129bbf260724be80b64?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('fobjcchqrh9rmd0iy2zq570y959e8za34ilrwjmeh0iyz4etym', 'gznwvd9l3ootp02efqcwpj4lq6jbm77fs82oyosu92axgusx15', '0');
-- Em Beihold
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('11h4ui77qz0oelx', 'Em Beihold', '60@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1e97fce6fa6fc4ebc3ebda25','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:60@artist.com', '11h4ui77qz0oelx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('11h4ui77qz0oelx', 'A voice that captivates, combining depth of lyrics with a melodic finesse.', 'Em Beihold');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('3s9wsr5b6854vpjz4gk2pj2z86oko7bksq1tenmq5dprvwxs3r','11h4ui77qz0oelx', NULL, 'Em Beihold Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('0xzbik6v6ws86ymrk3lcafzjxrlgh08dwwq1p3bexwfehvrh5d','Until I Found You (with Em Beihold) - Em Beihold Version','11h4ui77qz0oelx',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('3s9wsr5b6854vpjz4gk2pj2z86oko7bksq1tenmq5dprvwxs3r', '0xzbik6v6ws86ymrk3lcafzjxrlgh08dwwq1p3bexwfehvrh5d', '0');
-- Mc Livinho
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('38es3z4l3ylcn99', 'Mc Livinho', '61@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd353ef9564cfbb5f2b3bffb2','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:61@artist.com', '38es3z4l3ylcn99', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('38es3z4l3ylcn99', 'Bringing Brazilian funk rhythms to the global music stage.', 'Mc Livinho');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('cn9b2pr957b5o72n13cynixejdohj0y2w30jmf7i8ps9oenuiz','38es3z4l3ylcn99', 'https://i.scdn.co/image/ab67616d0000b273369c960fed23353176da1218', 'Mc Livinho Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('lcn7n05wixw7vo3o0yh9mdto7j4kun5yvbux0v5horwxt4q2a4','Novidade na ','38es3z4l3ylcn99',100,'POP','2uhw2oYbugGJbn10wipNX5','https://p.scdn.co/mp3-preview/6bff8c1079d87a672d6b9ee5c3c6ca5e7d9ff45b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cn9b2pr957b5o72n13cynixejdohj0y2w30jmf7i8ps9oenuiz', 'lcn7n05wixw7vo3o0yh9mdto7j4kun5yvbux0v5horwxt4q2a4', '0');
-- Justin Bieber
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('82xqaflf1amu7yd', 'Justin Bieber', '62@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:62@artist.com', '82xqaflf1amu7yd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('82xqaflf1amu7yd', 'From teen idol to global pop star, constantly evolving his sound.', 'Justin Bieber');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('im1xakn5fcz7ypx6y184fjdgf70njkcberl9aecig0y2g1p4vj','82xqaflf1amu7yd', NULL, 'Justin Bieber Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('991xvidubdgsqddxwtdjhypkstwj50y0h61b2lj068n87dpopo','STAY (with Justin Bieber)','82xqaflf1amu7yd',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('im1xakn5fcz7ypx6y184fjdgf70njkcberl9aecig0y2g1p4vj', '991xvidubdgsqddxwtdjhypkstwj50y0h61b2lj068n87dpopo', '0');
-- Marshmello
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('80n9jnni8yzsgft', 'Marshmello', '63@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41e4a3b8c1d45a9e49b6de21','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:63@artist.com', '80n9jnni8yzsgft', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('80n9jnni8yzsgft', 'An electronic music maestro known for his infectious beats.', 'Marshmello');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('alq41tdt60asx24ncax3qh5bhspy3e386p3j9mogenr65397gt','80n9jnni8yzsgft', 'https://i.scdn.co/image/ab67616d0000b273f404676577626a87d92cf33f', 'Marshmello Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('msixgxqksaob27khfol3mpukwk7s23sttvm4l0qix5tihbx0ru','El Merengue','80n9jnni8yzsgft',100,'POP','51FvjPEGKq2zByeeEQ43V9','https://p.scdn.co/mp3-preview/a933b6e1d6a47e591c13192f2b5e58739d3d5a06?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('alq41tdt60asx24ncax3qh5bhspy3e386p3j9mogenr65397gt', 'msixgxqksaob27khfol3mpukwk7s23sttvm4l0qix5tihbx0ru', '0');
-- Lewis Capaldi
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('zbzk588fjy4tsm8', 'Lewis Capaldi', '64@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebea7538654040e553a7b0fc28','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:64@artist.com', 'zbzk588fjy4tsm8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('zbzk588fjy4tsm8', 'Delivering emotional ballads with his powerful, soul-stirring voice.', 'Lewis Capaldi');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('fqmcg3hbnwe2o2etz8rspzkjoio7yu4dva6d1m3cdhpyahzvyp','zbzk588fjy4tsm8', 'https://i.scdn.co/image/ab67616d0000b273fc2101e6889d6ce9025f85f2', 'Lewis Capaldi Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('rtxuzblkb1secg7hsxywdvta6enpficqw53no6v8mlv8xt9upo','Someone You Loved','zbzk588fjy4tsm8',100,'POP','7qEHsqek33rTcFNT9PFqLf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('fqmcg3hbnwe2o2etz8rspzkjoio7yu4dva6d1m3cdhpyahzvyp', 'rtxuzblkb1secg7hsxywdvta6enpficqw53no6v8mlv8xt9upo', '0');
-- Chencho Corleone
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('ijyd6a2d67dk1i9', 'Chencho Corleone', '65@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2e862710857d2b3e1b5fb4f4','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:65@artist.com', 'ijyd6a2d67dk1i9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ijyd6a2d67dk1i9', 'A dynamic presence in reggaeton, known for his catchy beats and vibrant performances.', 'Chencho Corleone');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('chi5yamu6jjvhdgpfjgmetwtbzx04b5mgqek0biwjvzzj5cvkj','ijyd6a2d67dk1i9', NULL, 'Chencho Corleone Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('tfnfdl9wbmi3rh0hdgtknvgfumo60rgz6hyfh2yb2halpfs72d','Me Porto Bonito','ijyd6a2d67dk1i9',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('chi5yamu6jjvhdgpfjgmetwtbzx04b5mgqek0biwjvzzj5cvkj', 'tfnfdl9wbmi3rh0hdgtknvgfumo60rgz6hyfh2yb2halpfs72d', '0');
-- Jain
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('jxcv2ztl55u6c2g', 'Jain', '66@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb673f287fead1f6c83b9b68ea','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:66@artist.com', 'jxcv2ztl55u6c2g', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('jxcv2ztl55u6c2g', 'Mixing electronic beats with multicultural influences to create a unique sound.', 'Jain');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ayyzt0f1s2e6kon66udt9s0jjt10yukly4orwodl4xr4cief6v','jxcv2ztl55u6c2g', 'https://i.scdn.co/image/ab67616d0000b27364ba66f8a81c52364e55db50', 'Jain Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('btp0a81wrpcz21hbgqhzx2w18q3ywa8qvmgrw6j9al94dg38hg','Makeba','jxcv2ztl55u6c2g',100,'POP','4TNFLwe6DhtR3Wn1JKMqMJ','https://p.scdn.co/mp3-preview/41db29480f9d12734adf491d3b5dd4da1005047c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ayyzt0f1s2e6kon66udt9s0jjt10yukly4orwodl4xr4cief6v', 'btp0a81wrpcz21hbgqhzx2w18q3ywa8qvmgrw6j9al94dg38hg', '0');
-- Ayparia
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('r4hn3lwsnt51hgz', 'Ayparia', '67@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb85a54675cc99eca02c11797a','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:67@artist.com', 'r4hn3lwsnt51hgz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('r4hn3lwsnt51hgz', 'Delivering a unique blend of sounds, showcasing versatility and artistic depth.', 'Ayparia');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('lkxrc07zz5kdqeszlp0u06yfu8npiyd0j2xo7ans1ro7hyyohl','r4hn3lwsnt51hgz', NULL, 'Ayparia Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('xv3ao7lg2znfel4xcgfw7nkf4q0awuac6di00iyib3gzi3rk6w','MONTAGEM - FR PUNK','r4hn3lwsnt51hgz',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('lkxrc07zz5kdqeszlp0u06yfu8npiyd0j2xo7ans1ro7hyyohl', 'xv3ao7lg2znfel4xcgfw7nkf4q0awuac6di00iyib3gzi3rk6w', '0');
-- Luke Combs
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('87m3a6y7zuj0ilo', 'Luke Combs', '68@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5db6179b28f7e3654898b279','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:68@artist.com', '87m3a6y7zuj0ilo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('87m3a6y7zuj0ilo', 'Reigniting country music with his powerful voice and relatable songs.', 'Luke Combs');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('q3zf6rchdcy8ok8zmehm5nv0w807ie59xo78qzknneqfdjycts','87m3a6y7zuj0ilo', 'https://i.scdn.co/image/ab67616d0000b273ca650d3a95022e0490434ba1', 'Luke Combs Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('8u1bad956l95dg53t3vnl1wsbyyv3hig6shsk1qoo0stoa28n5','Fast Car','87m3a6y7zuj0ilo',100,'POP','1Lo0QY9cvc8sUB2vnIOxDT','https://p.scdn.co/mp3-preview/1dc0426c95058783e0fe1d70c41583ca98317108?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('q3zf6rchdcy8ok8zmehm5nv0w807ie59xo78qzknneqfdjycts', '8u1bad956l95dg53t3vnl1wsbyyv3hig6shsk1qoo0stoa28n5', '0');
-- Doechii
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('h4qqdb4aywo5a67', 'Doechii', '69@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5f9f729e1e5182fbf1030dbe','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:69@artist.com', 'h4qqdb4aywo5a67', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('h4qqdb4aywo5a67', 'Breaking barriers with her unique sound and powerful lyrical storytelling.', 'Doechii');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('uhv4aliejubebm157met0m6w15mxluffww26m242o4uff54eh7','h4qqdb4aywo5a67', 'https://i.scdn.co/image/ab67616d0000b2732ee85751f6f503fa9a533eba', 'Doechii Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('9jcldjzwvsw3mfxr9tqpgo3mu5dv91nt32yh7kmfb35va39p4x','What It Is (Solo Version)','h4qqdb4aywo5a67',100,'POP','73RbfOTJIjHzi2pcVHjeHM',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('uhv4aliejubebm157met0m6w15mxluffww26m242o4uff54eh7', '9jcldjzwvsw3mfxr9tqpgo3mu5dv91nt32yh7kmfb35va39p4x', '0');
-- Jung Kook
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('6ak6e30rbl1qyos', 'Jung Kook', '70@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:70@artist.com', '6ak6e30rbl1qyos', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('6ak6e30rbl1qyos', 'A member of BTS, captivating fans with his powerful vocals and dynamic performances.', 'Jung Kook');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('mfnuftzizj9zc5sninknh0t3atz4ltbftfy2fhyyjs9r94pfjg','6ak6e30rbl1qyos', 'https://i.scdn.co/image/ab67616d0000b273a7f42c375578df426b37638d', 'Jung Kook Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('tzvcdxi3p3ztk6wtifx4ado9zjeyi6kchyykzbknf2xaakintt','Still With You','6ak6e30rbl1qyos',100,'POP','0eFMbKCRw8KByXyWBw8WO7','https://p.scdn.co/mp3-preview/af2a740e10a6956dedd7e7f66fd65d7166e9187f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('mfnuftzizj9zc5sninknh0t3atz4ltbftfy2fhyyjs9r94pfjg', 'tzvcdxi3p3ztk6wtifx4ado9zjeyi6kchyykzbknf2xaakintt', '0');
-- J. Cole
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('o0xbad3rksz5w8h', 'J. Cole', '71@artist.com', 'https://i.scdn.co/image/ab67616d0000b273d092fc596478080bb0e06aea','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:71@artist.com', 'o0xbad3rksz5w8h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('o0xbad3rksz5w8h', 'A profound lyricist and rapper, known for his thought-provoking music.', 'J. Cole');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('xrrcxckefzlurculklbtcji6tfvi1vf61wl5u83gt34yfoxwj2','o0xbad3rksz5w8h', NULL, 'J. Cole Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('r5l9ff4qn3uopvtpuapqudq1jefvskh4i7ynb24vpzr9bet8cn','All My Life (feat. J. Cole)','o0xbad3rksz5w8h',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('xrrcxckefzlurculklbtcji6tfvi1vf61wl5u83gt34yfoxwj2', 'r5l9ff4qn3uopvtpuapqudq1jefvskh4i7ynb24vpzr9bet8cn', '0');
-- Lana Del Rey
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('kwj8bukw756hk49', 'Lana Del Rey', '72@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb99cacf8acd5378206767261','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:72@artist.com', 'kwj8bukw756hk49', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('kwj8bukw756hk49', 'An ethereal presence in music, known for her cinematic and nostalgic sound.', 'Lana Del Rey');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('5bgkn2kdrduuqtv35dp1tlkqxxbg10kx2lqywmkvhqee6ve73a','kwj8bukw756hk49', 'https://i.scdn.co/image/ab67616d0000b273aa27708d07f49c82ff0d0dae', 'Lana Del Rey Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('acs49j4e0okxsy221q5tqgz0mda9cykcy1v2ttcm4mp84poml3','Say Yes To Heaven','kwj8bukw756hk49',100,'POP','6GGtHZgBycCgGBUhZo81xe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('5bgkn2kdrduuqtv35dp1tlkqxxbg10kx2lqywmkvhqee6ve73a', 'acs49j4e0okxsy221q5tqgz0mda9cykcy1v2ttcm4mp84poml3', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('uj6n3h4zul22spfidm5lh6uy16c4kvieber1wanz2t45bmk8zc','Summertime Sadness','kwj8bukw756hk49',100,'POP','1Ist6PR2BZR3n2z2Y5R6S1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('5bgkn2kdrduuqtv35dp1tlkqxxbg10kx2lqywmkvhqee6ve73a', 'uj6n3h4zul22spfidm5lh6uy16c4kvieber1wanz2t45bmk8zc', '1');
-- BTS
INSERT INTO `auth_user` (`id`, `username`, `email`, `profile_image_url`, `created_at`) VALUES ('9xq4a4ei0jnl7wk', 'BTS', '73@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd642648235ebf3460d2d1f6a','2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:73@artist.com', '9xq4a4ei0jnl7wk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('9xq4a4ei0jnl7wk', 'A global phenomenon, setting new standards in K-pop with their music and performances.', 'BTS');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('usicxseo83defgpothnchvvrqoib3tvxy6wx6cv9ljfd9gn1kg','9xq4a4ei0jnl7wk', 'https://i.scdn.co/image/ab67616d0000b2738a701e76e8845928f6cd81c8', 'BTS Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('wtmpd6jyivtyugk2lxl0mdkkna9z3enzhz3tgxq06gtihzwp4n','Take Two','9xq4a4ei0jnl7wk',100,'POP','5IAESfJjmOYu7cHyX557kz','https://p.scdn.co/mp3-preview/ef43da30a06fcad16898e9fff1cadd0ccf953fc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('usicxseo83defgpothnchvvrqoib3tvxy6wx6cv9ljfd9gn1kg', 'wtmpd6jyivtyugk2lxl0mdkkna9z3enzhz3tgxq06gtihzwp4n', '0');


-- File: insert_relationships.sql
-- Playlists
INSERT INTO `playlist` (`id`, `name`, `created_at`, `creator_id`) VALUES ('wic1vfouyne931cjdcaktr13ef9fex3qk7p29rbfdtvkrri790', 'Playlist 0', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('acs49j4e0okxsy221q5tqgz0mda9cykcy1v2ttcm4mp84poml3', 'wic1vfouyne931cjdcaktr13ef9fex3qk7p29rbfdtvkrri790', 0);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('yg2a201npsgvq1d3v7slrlx1qw1fjm1cfz67vfkt82scjdznn7', 'wic1vfouyne931cjdcaktr13ef9fex3qk7p29rbfdtvkrri790', 4);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('dvhd4uk1kwq1fh0pkvym5dh87surzmv2fjb2lthy1t38gi86su', 'wic1vfouyne931cjdcaktr13ef9fex3qk7p29rbfdtvkrri790', 2);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('nb45kpx2g0szmp2plcnac8mqzmslqfgxwmldfviwp0sl9x2yf5', 'wic1vfouyne931cjdcaktr13ef9fex3qk7p29rbfdtvkrri790', 1);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('1h2bn8fhac68m4oo9xpyn8m30nzj007uh4raakhvgd706tkcu0', 'wic1vfouyne931cjdcaktr13ef9fex3qk7p29rbfdtvkrri790', 3);
INSERT INTO `playlist` (`id`, `name`, `created_at`, `creator_id`) VALUES ('z1em98yh6mjmm9yrt18d78zcg58v1vmbgbropq6462z2zr3yy0', 'Playlist 1', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('h2qn9b12hbl9jmuqbzs5k93dutwtwdbnh6u37f0pjippu6tpz5', 'z1em98yh6mjmm9yrt18d78zcg58v1vmbgbropq6462z2zr3yy0', 0);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('41v4eex9jdzht0gwt474ye8r6jb9cyqhk863fjkg2hdrvzb7v7', 'z1em98yh6mjmm9yrt18d78zcg58v1vmbgbropq6462z2zr3yy0', 3);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('1pjt6prl3btj4uctb1ct9n5w8hft27fu05f2b36c2cby4x4n2w', 'z1em98yh6mjmm9yrt18d78zcg58v1vmbgbropq6462z2zr3yy0', 4);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('1ayoikhpq7w6ayat7mex5ecmocum5tjtzxb0ebgk0o2dppi9a2', 'z1em98yh6mjmm9yrt18d78zcg58v1vmbgbropq6462z2zr3yy0', 2);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('uei4x8dvj12phd656gme0mf22pf7gfjru0sgliorbfw0y4sc1z', 'z1em98yh6mjmm9yrt18d78zcg58v1vmbgbropq6462z2zr3yy0', 1);
-- User Likes
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'zvjgkqh39hbfdvdmgl8f5cya7x6hq5ga2vksaifnakx6un4bwj');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'nqzdkoak2wcwvlp53hd3k1ds8u4q6bjg3rqvghprr0pyfm3zh7');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', '8319ordx1a08jyywp2e684kjx9jetp7nwqs8a5hjuzsyqin8lm');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'wtmpd6jyivtyugk2lxl0mdkkna9z3enzhz3tgxq06gtihzwp4n');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', '8fxoe0py6aityi7yobp0x6hj4t1lym8jbzoez78dbc43e9tb6t');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'k8v0wux17d4mbjnvgjstabcnv62gk4jho4j86qkcz7bbh7t8b7');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'sy5guip2vvvrv2yiqkp0z6lqvs9qm4g4viu8vp357qbzx0d62n');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'gtqt96ixqdoob3hrk77nnoo2w7fdgumn38enuo2wd1c45gml7a');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', '0z9isuw79ip6ocr8olxdlob16s122o1hqn4znfpg6dlk1pdhyz');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'rhd3jsbfjrihkby8ku9wwlu6f0ubaf59jtzueqsb4eqe019gjq');
-- User Song Recommendations
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('zvd8b1plgxbja89lvijjzpjc73uf3gmzdhx3yw4vv4oasvrwhv', 'icqlt67n2fd7p34', 'gcbecuozdgjaiojnbekez6915gxn13z37l1oc51aov4yk5tar9', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('niw8sk2pgl36k1iojxfud8w5idj5v6uvj9vwtfrwhpsbs90x6k', 'icqlt67n2fd7p34', 'gtqt96ixqdoob3hrk77nnoo2w7fdgumn38enuo2wd1c45gml7a', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('4akijmnkf5sup91lge4x7c7rkpk7cnkz2nfr21zgukvqk2pwfo', 'icqlt67n2fd7p34', 'hf3prhvjlip7yfwutktw6on8po7ixc5pmum0gw5g0ml23jgu8h', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('cb77miyehyom2l64iyn7h4clvxdci299qpce2r2np1pwg376lz', 'icqlt67n2fd7p34', 'tlq43l7ym21pdanyvunbjvsqtaywbe589tmezl7xjxk9iy1281', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('7u5k023bqn99cu43cilpbv9mlb09m7fq04em0t595vfmeijssx', 'icqlt67n2fd7p34', '0zksl209wi1fw13ltu79bsbsqu34ooxg8qqqxj0qo97v05c8at', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('pz8acovg5mhrpos17baxiq9nfas9ubb7fc66a8ukdtlqtzak5o', 'icqlt67n2fd7p34', '5ft25u5manpwy7x0ldjiwlgl2nob4829qz44hjg4lky28pjamv', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('vuenv7olncclfqlndw6f98f0pqv6k0usvltjw3lbrixf1b56tk', 'icqlt67n2fd7p34', 'rhd3jsbfjrihkby8ku9wwlu6f0ubaf59jtzueqsb4eqe019gjq', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('6pnsvylncy0ojsas2xkpz233i573suek6rh9b22b4ble73aj43', 'icqlt67n2fd7p34', 'luj5ehcsyyvyt1s3txwadbjaz9rlro8zcztxp1sugirsuloefz', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('ive8fpycrtuc2m4x7a5clzme73dcusva4uxtg42xqjdfcr1vnm', 'icqlt67n2fd7p34', 'lcn7n05wixw7vo3o0yh9mdto7j4kun5yvbux0v5horwxt4q2a4', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('03j5r33fxgc0s9n09k48cxrrsvvpgeesxtl1xr1kccg1b593v2', 'icqlt67n2fd7p34', 'pet7be4mig3e6vrn2f6xcyf9w4t9r4zkstgzcpinbucehs99yl', '2023-11-17 17:00:08.000');


