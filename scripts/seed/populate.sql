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

-- Latto
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('eou7eaud9uy1tnp', 'Latto', '0@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:0@artist.com', 'eou7eaud9uy1tnp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('eou7eaud9uy1tnp', 'My name is Latto', 'Latto');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('6hgx8ty8r0p2hn3sr1kahddhsa6m51k9sfa7kgacjb7an5froe','eou7eaud9uy1tnp', NULL, 'Latto Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('qzf6mrwdp4rz3tf1hq5rx86dwx3kqkqhl5xppiklk9yw7agq3b','Seven (feat. Latto) (Explicit Ver.)','eou7eaud9uy1tnp',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('6hgx8ty8r0p2hn3sr1kahddhsa6m51k9sfa7kgacjb7an5froe', 'qzf6mrwdp4rz3tf1hq5rx86dwx3kqkqhl5xppiklk9yw7agq3b', '0');
-- Myke Towers
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('1dojxjk7bespzvc', 'Myke Towers', '1@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:1@artist.com', '1dojxjk7bespzvc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('1dojxjk7bespzvc', 'My name is Myke Towers', 'Myke Towers');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('lc5ti40bm9lgyzxpb6st1w6hbm565ku97609ar5b3z3gnhxv2g','1dojxjk7bespzvc', 'https://i.scdn.co/image/ab67616d0000b2730656d5ce813ca3cc4b677e05', 'Myke Towers Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('bp1bxyxma59b1yju29ot4qanh61c2jb9m97yfmol85qprfm7a2','LALA','1dojxjk7bespzvc',100,'POP','7ABLbnD53cQK00mhcaOUVG','https://p.scdn.co/mp3-preview/42772b16b4e575d1b15b0ec7f94e335539390d2d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('lc5ti40bm9lgyzxpb6st1w6hbm565ku97609ar5b3z3gnhxv2g', 'bp1bxyxma59b1yju29ot4qanh61c2jb9m97yfmol85qprfm7a2', '0');
-- Olivia Rodrigo
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('tf56oroxnmmnrmr', 'Olivia Rodrigo', '2@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:2@artist.com', 'tf56oroxnmmnrmr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('tf56oroxnmmnrmr', 'My name is Olivia Rodrigo', 'Olivia Rodrigo');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ggtcrj94cum9aydy912m50x8a6lwcul71hnjcekr0cd4wfhsj9','tf56oroxnmmnrmr', 'https://i.scdn.co/image/ab67616d0000b273e85259a1cae29a8d91f2093d', 'Olivia Rodrigo Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ek7n7p9xiho40l3doyogxyd4127aqr4hrnbp980nyk2xjbhvnu','vampire','tf56oroxnmmnrmr',100,'POP','1kuGVB7EU95pJObxwvfwKS',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ggtcrj94cum9aydy912m50x8a6lwcul71hnjcekr0cd4wfhsj9', 'ek7n7p9xiho40l3doyogxyd4127aqr4hrnbp980nyk2xjbhvnu', '0');
-- Taylor Swift
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('qqmorv84iyhn1fh', 'Taylor Swift', '3@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:3@artist.com', 'qqmorv84iyhn1fh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('qqmorv84iyhn1fh', 'My name is Taylor Swift', 'Taylor Swift');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('cn29vbbbfg0xnget13crlo38v9jbe5mfy03zvgu8py84njs2jp','qqmorv84iyhn1fh', 'https://i.scdn.co/image/ab67616d0000b273e787cffec20aa2a396a61647', 'Taylor Swift Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('n5hc2pv72yse4f0l3ss1wtcyskuwse1cum6ungsjw7xbb722kf','Cruel Summer','qqmorv84iyhn1fh',100,'POP','1BxfuPKGuaTgP7aM0Bbdwr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cn29vbbbfg0xnget13crlo38v9jbe5mfy03zvgu8py84njs2jp', 'n5hc2pv72yse4f0l3ss1wtcyskuwse1cum6ungsjw7xbb722kf', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('dn3kbrczqiq1o6cjuzkryqmraerhpwkn9t81trnogcf0v8g3fi','I Can See You (Taylors Version) (From The ','qqmorv84iyhn1fh',100,'POP','5kHMfzgLZP95O9NBy0ku4v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cn29vbbbfg0xnget13crlo38v9jbe5mfy03zvgu8py84njs2jp', 'dn3kbrczqiq1o6cjuzkryqmraerhpwkn9t81trnogcf0v8g3fi', '1');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('qns2sn8e2th6gc8sxey1uhn7sg93fnn5c6kc97yk9i0nahqh19','Anti-Hero','qqmorv84iyhn1fh',100,'POP','0V3wPSX9ygBnCm8psDIegu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cn29vbbbfg0xnget13crlo38v9jbe5mfy03zvgu8py84njs2jp', 'qns2sn8e2th6gc8sxey1uhn7sg93fnn5c6kc97yk9i0nahqh19', '2');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('pcz0r1qaw36uq3jqqgorh1j7f055i44x64gn1n1uajqx8wkkge','Blank Space','qqmorv84iyhn1fh',100,'POP','1p80LdxRV74UKvL8gnD7ky',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cn29vbbbfg0xnget13crlo38v9jbe5mfy03zvgu8py84njs2jp', 'pcz0r1qaw36uq3jqqgorh1j7f055i44x64gn1n1uajqx8wkkge', '3');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('fe9qpkt99g08u0psz13b2rdpmhbojuwixd19qfrlrd1r6oner0','Style','qqmorv84iyhn1fh',100,'POP','1hjRhYpWyqDpPahmSlUTlc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cn29vbbbfg0xnget13crlo38v9jbe5mfy03zvgu8py84njs2jp', 'fe9qpkt99g08u0psz13b2rdpmhbojuwixd19qfrlrd1r6oner0', '4');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('le95csxuzpjo7mwlfzao5inxvbw9yyki5y0wky5luy6sbsjzzn','cardigan','qqmorv84iyhn1fh',100,'POP','4R2kfaDFhslZEMJqAFNpdd',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cn29vbbbfg0xnget13crlo38v9jbe5mfy03zvgu8py84njs2jp', 'le95csxuzpjo7mwlfzao5inxvbw9yyki5y0wky5luy6sbsjzzn', '5');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ee76xkrt46i0lz0fv2i7eftyo8zavrzto4s9ig595tkjjdwv0z','Karma','qqmorv84iyhn1fh',100,'POP','7KokYm8cMIXCsGVmUvKtqf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cn29vbbbfg0xnget13crlo38v9jbe5mfy03zvgu8py84njs2jp', 'ee76xkrt46i0lz0fv2i7eftyo8zavrzto4s9ig595tkjjdwv0z', '6');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('52usxlmyai5ca3zwhauyi7uwwftzk0fpbopris1ahlbphtibwh','Enchanted (Taylors Version)','qqmorv84iyhn1fh',100,'POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cn29vbbbfg0xnget13crlo38v9jbe5mfy03zvgu8py84njs2jp', '52usxlmyai5ca3zwhauyi7uwwftzk0fpbopris1ahlbphtibwh', '7');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('wm0xql5hojlwannq69soi4itnro8qb2f6hmayr7sutcqo9p5sa','Back To December (Taylors Version)','qqmorv84iyhn1fh',100,'POP','79uDOz0zuuWS7HWxzMmTa2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cn29vbbbfg0xnget13crlo38v9jbe5mfy03zvgu8py84njs2jp', 'wm0xql5hojlwannq69soi4itnro8qb2f6hmayr7sutcqo9p5sa', '8');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('rdxyxewcltfkc726c7nw79ws16f635atoynsi3hh3s82q3zens','Dont Bl','qqmorv84iyhn1fh',100,'POP','59ZmeIz57cGU5Gp9omjlYB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cn29vbbbfg0xnget13crlo38v9jbe5mfy03zvgu8py84njs2jp', 'rdxyxewcltfkc726c7nw79ws16f635atoynsi3hh3s82q3zens', '9');
-- Bad Bunny
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('wl81gj1cqvimojc', 'Bad Bunny', '4@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:4@artist.com', 'wl81gj1cqvimojc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('wl81gj1cqvimojc', 'My name is Bad Bunny', 'Bad Bunny');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('w1a4wqvkyn7v56yppcf3omsn9qqq83gv1ukuh0zc6vux9avb2o','wl81gj1cqvimojc', 'https://i.scdn.co/image/ab67616d0000b273ab5c9cd818ad6ed3e9b79cd1', 'Bad Bunny Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('xebqk6f78vgrjoay7owk5hxqbl4wjz3g9aidfglvjv2s1uxdiy','WHERE SHE GOES','wl81gj1cqvimojc',100,'POP','7ro0hRteUMfnOioTFI5TG1','https://p.scdn.co/mp3-preview/b9b7e4c982b33ee23c4867f7a3025e3598c35760?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('w1a4wqvkyn7v56yppcf3omsn9qqq83gv1ukuh0zc6vux9avb2o', 'xebqk6f78vgrjoay7owk5hxqbl4wjz3g9aidfglvjv2s1uxdiy', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('30r1pj49l8y4xsh2xzv0cf4lk7h4pk2ajctuc0v436ll6hzyh0','un x100to','wl81gj1cqvimojc',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('w1a4wqvkyn7v56yppcf3omsn9qqq83gv1ukuh0zc6vux9avb2o', '30r1pj49l8y4xsh2xzv0cf4lk7h4pk2ajctuc0v436ll6hzyh0', '1');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('yvjij92a15zl687yu7rdyi9vixickgy11xd48gld2yusxlyam8','Coco Chanel','wl81gj1cqvimojc',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('w1a4wqvkyn7v56yppcf3omsn9qqq83gv1ukuh0zc6vux9avb2o', 'yvjij92a15zl687yu7rdyi9vixickgy11xd48gld2yusxlyam8', '2');
-- Dave
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('ofo1ad47tfu2o1h', 'Dave', '5@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:5@artist.com', 'ofo1ad47tfu2o1h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ofo1ad47tfu2o1h', 'My name is Dave', 'Dave');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('rg85ca6e00ucots6yjuqp7ufx3pt23aib3hwfc58zl7bwoyk2q','ofo1ad47tfu2o1h', 'https://i.scdn.co/image/ab67616d0000b273e3a09a9ae3f1fa102c110e60', 'Dave Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ali2tr4mkqfd0vmike3edjcndxcf9hn8kp8pm0pwy9ax6lqn8i','Sprinter','ofo1ad47tfu2o1h',100,'POP','2FDTHlrBguDzQkp7PVj16Q',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('rg85ca6e00ucots6yjuqp7ufx3pt23aib3hwfc58zl7bwoyk2q', 'ali2tr4mkqfd0vmike3edjcndxcf9hn8kp8pm0pwy9ax6lqn8i', '0');
-- Eslabon Armado
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('ycg5cnoglkb8rhv', 'Eslabon Armado', '6@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:6@artist.com', 'ycg5cnoglkb8rhv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ycg5cnoglkb8rhv', 'My name is Eslabon Armado', 'Eslabon Armado');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('8nmzrz85wyogpip5d349rze7pp53dd7z1ifna94nrqpjyhae7r','ycg5cnoglkb8rhv', 'https://i.scdn.co/image/ab67616d0000b2732071a0c79802d9375a53bfef', 'Eslabon Armado Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('5rg29x8vi76dx5brc0v1lokz2ute2n488rd51m91rlj4bq6j63','Ella Baila Sola','ycg5cnoglkb8rhv',100,'POP','3dnP0JxCgygwQH9Gm7q7nb','https://p.scdn.co/mp3-preview/5d39f3e17f1e20e2711d033001e48b8d4249b992?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('8nmzrz85wyogpip5d349rze7pp53dd7z1ifna94nrqpjyhae7r', '5rg29x8vi76dx5brc0v1lokz2ute2n488rd51m91rlj4bq6j63', '0');
-- Quevedo
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('zetb8oknyius4n3', 'Quevedo', '7@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:7@artist.com', 'zetb8oknyius4n3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('zetb8oknyius4n3', 'My name is Quevedo', 'Quevedo');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('d3a4rtmvpbix6wugzd6clm3yum75fok90x5p0yh004izm4rc1r','zetb8oknyius4n3', 'https://i.scdn.co/image/ab67616d0000b273a00a817b017c6f6bf8460be9', 'Quevedo Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('z2wludjjznoseuw4g1r0mqjea4aoy9uaot6zo9zouzd0cn8wj8','Columbia','zetb8oknyius4n3',100,'POP','6XbtvPmIpyCbjuT0e8cQtp','https://p.scdn.co/mp3-preview/e3d6df66fe67f618166a2cab858580ac8a96486a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('d3a4rtmvpbix6wugzd6clm3yum75fok90x5p0yh004izm4rc1r', 'z2wludjjznoseuw4g1r0mqjea4aoy9uaot6zo9zouzd0cn8wj8', '0');
-- Gunna
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('qdyg1if1qkjwtim', 'Gunna', '8@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:8@artist.com', 'qdyg1if1qkjwtim', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('qdyg1if1qkjwtim', 'My name is Gunna', 'Gunna');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('k0eeiu271swd18d2qoyf3zmmgptgq0e74fq8l4uvp8b3b93osp','qdyg1if1qkjwtim', 'https://i.scdn.co/image/ab67616d0000b273017d5e26552345c4b1575b6c', 'Gunna Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('xqfiijo8nyrehfy5ct2xikbnsbfyr8yd5n8aob9g925g14favk','fukumean','qdyg1if1qkjwtim',100,'POP','4rXLjWdF2ZZpXCVTfWcshS','https://p.scdn.co/mp3-preview/f237ab921af697ba9b49e12fa167c2ce1a82d6b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('k0eeiu271swd18d2qoyf3zmmgptgq0e74fq8l4uvp8b3b93osp', 'xqfiijo8nyrehfy5ct2xikbnsbfyr8yd5n8aob9g925g14favk', '0');
-- Peso Pluma
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('px09f08yyzxmylc', 'Peso Pluma', '9@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:9@artist.com', 'px09f08yyzxmylc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('px09f08yyzxmylc', 'My name is Peso Pluma', 'Peso Pluma');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('48zczokam1epfdy69jhkasu3ajvqvv5wzgn98psaatsrws4wh5','px09f08yyzxmylc', NULL, 'Peso Pluma Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('47fbmw07fzxoozhhx5sbp0xg3xr79gocoyreskck2fkjl563sz','La Bebe - Remix','px09f08yyzxmylc',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('48zczokam1epfdy69jhkasu3ajvqvv5wzgn98psaatsrws4wh5', '47fbmw07fzxoozhhx5sbp0xg3xr79gocoyreskck2fkjl563sz', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('mf7gbsrgmlr5b373kd9fgt4kokrmwac4fjrx4dduxhpoh7z8x3','TULUM','px09f08yyzxmylc',100,'POP','7bPp2NmpmyhLJ7zWazAXMu','https://p.scdn.co/mp3-preview/164468e67b8da8053036c68533ffa473ab680c51?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('48zczokam1epfdy69jhkasu3ajvqvv5wzgn98psaatsrws4wh5', 'mf7gbsrgmlr5b373kd9fgt4kokrmwac4fjrx4dduxhpoh7z8x3', '1');
-- NewJeans
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('mnydlkyi34fclya', 'NewJeans', '10@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:10@artist.com', 'mnydlkyi34fclya', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('mnydlkyi34fclya', 'My name is NewJeans', 'NewJeans');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('66y1dioddnw4im49lglqs9q99f2lzqewwl5p092yyxlpiv1b3r','mnydlkyi34fclya', 'https://i.scdn.co/image/ab67616d0000b2733d98a0ae7c78a3a9babaf8af', 'NewJeans Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('mlyg9ouqy99wipf0lcybzor3780i0k1ec1yvbwumjq70ot1bjv','Super Shy','mnydlkyi34fclya',100,'POP','5sdQOyqq2IDhvmx2lHOpwd','https://p.scdn.co/mp3-preview/dab062e2cc708a2680ce84953a3581c5a679a230?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('66y1dioddnw4im49lglqs9q99f2lzqewwl5p092yyxlpiv1b3r', 'mlyg9ouqy99wipf0lcybzor3780i0k1ec1yvbwumjq70ot1bjv', '0');
-- Miley Cyrus
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('4tzoyowxvx9pqtp', 'Miley Cyrus', '11@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:11@artist.com', '4tzoyowxvx9pqtp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('4tzoyowxvx9pqtp', 'My name is Miley Cyrus', 'Miley Cyrus');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('k7pl58h89uhmreci5qb0tkabumh7mu82e38glytpue6aus7dc5','4tzoyowxvx9pqtp', 'https://i.scdn.co/image/ab67616d0000b273cd222052a2594be29a6616b5', 'Miley Cyrus Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('jluam5k8dfbbdqncbzx7wgpu1fhv0rpdsj16e2ahxg0b8y6n1m','Flowers','4tzoyowxvx9pqtp',100,'POP','7DSAEUvxU8FajXtRloy8M0','https://p.scdn.co/mp3-preview/5184d19d1b7fcc3e7c067e38af45a7cc80851440?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('k7pl58h89uhmreci5qb0tkabumh7mu82e38glytpue6aus7dc5', 'jluam5k8dfbbdqncbzx7wgpu1fhv0rpdsj16e2ahxg0b8y6n1m', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('9tw7svhon3go1mybsvzj74cd4z1ydntwijr4h3r7edhhdm1xjg','Angels Like You','4tzoyowxvx9pqtp',100,'POP','1daDRI9ahBonbWD8YcxOIB','https://p.scdn.co/mp3-preview/4db8314199c0d49e95c786792ecd06eadae9f510?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('k7pl58h89uhmreci5qb0tkabumh7mu82e38glytpue6aus7dc5', '9tw7svhon3go1mybsvzj74cd4z1ydntwijr4h3r7edhhdm1xjg', '1');
-- David Kushner
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('sv9hu0yn4xb9wdv', 'David Kushner', '12@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:12@artist.com', 'sv9hu0yn4xb9wdv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('sv9hu0yn4xb9wdv', 'My name is David Kushner', 'David Kushner');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('czhr26nfwj3lbfldjvqa5trm5ni6djg7oqxgll6bwamx0s58xc','sv9hu0yn4xb9wdv', 'https://i.scdn.co/image/ab67616d0000b27395ca6a9b4083a86c149934ae', 'David Kushner Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('xg9ni4m7scz3ko9xmj7cfjw37fcxenam07m82o9rnx4swpt6jr','Daylight','sv9hu0yn4xb9wdv',100,'POP','1odExI7RdWc4BT515LTAwj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('czhr26nfwj3lbfldjvqa5trm5ni6djg7oqxgll6bwamx0s58xc', 'xg9ni4m7scz3ko9xmj7cfjw37fcxenam07m82o9rnx4swpt6jr', '0');
-- Harry Styles
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('3d9lt4ttv33ouw6', 'Harry Styles', '13@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:13@artist.com', '3d9lt4ttv33ouw6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('3d9lt4ttv33ouw6', 'My name is Harry Styles', 'Harry Styles');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('r7fslj1ly6uhtkd9g2h6y231scvp85z9t4wu5gms3g7rbzmu7i','3d9lt4ttv33ouw6', 'https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0', 'Harry Styles Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('rzmb5laxrlf34dti93h8gt52ajotr67zkmnv5hzoqvvv2r57w8','As It Was','3d9lt4ttv33ouw6',100,'POP','4Dvkj6JhhA12EX05fT7y2e','https://p.scdn.co/mp3-preview/c43dd07043b29e800c1a65b3a0102861fa3cf418?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('r7fslj1ly6uhtkd9g2h6y231scvp85z9t4wu5gms3g7rbzmu7i', 'rzmb5laxrlf34dti93h8gt52ajotr67zkmnv5hzoqvvv2r57w8', '0');
-- SZA
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('temk1gzwhucwt06', 'SZA', '14@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:14@artist.com', 'temk1gzwhucwt06', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('temk1gzwhucwt06', 'My name is SZA', 'SZA');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('d9saq7gnhxfyoahe7wrzmjag31ety3i8upgxytmla3fv5t15ms','temk1gzwhucwt06', 'https://i.scdn.co/image/ab67616d0000b2730c471c36970b9406233842a5', 'SZA Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('1wmuqcd2lqtcysx7w07jy6rjz4odcvkpk041ojnkkwim1o7knw','Kill Bill','temk1gzwhucwt06',100,'POP','1Qrg8KqiBpW07V7PNxwwwL','https://p.scdn.co/mp3-preview/4bd2dc84016f3743add7eea8b988407b1b900672?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('d9saq7gnhxfyoahe7wrzmjag31ety3i8upgxytmla3fv5t15ms', '1wmuqcd2lqtcysx7w07jy6rjz4odcvkpk041ojnkkwim1o7knw', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('810zbg29w1zubgip8tep03eppoy7oy748s1tuio5w3g1abngb4','Snooze','temk1gzwhucwt06',100,'POP','4iZ4pt7kvcaH6Yo8UoZ4s2','https://p.scdn.co/mp3-preview/8c53920b5fd2c3178afa36cac9eec68b5ee9204a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('d9saq7gnhxfyoahe7wrzmjag31ety3i8upgxytmla3fv5t15ms', '810zbg29w1zubgip8tep03eppoy7oy748s1tuio5w3g1abngb4', '1');
-- Fifty Fifty
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('andvvabchc45j08', 'Fifty Fifty', '15@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:15@artist.com', 'andvvabchc45j08', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('andvvabchc45j08', 'My name is Fifty Fifty', 'Fifty Fifty');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('8xr8m70e8fh3rykmg24h3ugr16onyisjllelgtwsh5wtekds2z','andvvabchc45j08', 'https://i.scdn.co/image/ab67616d0000b27337c0b3670236c067c8e8bbcb', 'Fifty Fifty Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('qet7vujd2d0n34qxo1dvdoirxrgqx51idsvrf8g0ndb2ogfxtj','Cupid - Twin Ver.','andvvabchc45j08',100,'POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('8xr8m70e8fh3rykmg24h3ugr16onyisjllelgtwsh5wtekds2z', 'qet7vujd2d0n34qxo1dvdoirxrgqx51idsvrf8g0ndb2ogfxtj', '0');
-- Billie Eilish
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('yiwfrclidg0is8j', 'Billie Eilish', '16@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:16@artist.com', 'yiwfrclidg0is8j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('yiwfrclidg0is8j', 'My name is Billie Eilish', 'Billie Eilish');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('8dp0hz74zj59sk5eub7n0v319erh9fncmvyougurud6hp4i2o1','yiwfrclidg0is8j', NULL, 'Billie Eilish Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('j5lp0tjds2br5p7gh1shent7jqkggduca29cm8noecl274go0c','What Was I Made For? [From The Motion Picture "Barbie"]','yiwfrclidg0is8j',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('8dp0hz74zj59sk5eub7n0v319erh9fncmvyougurud6hp4i2o1', 'j5lp0tjds2br5p7gh1shent7jqkggduca29cm8noecl274go0c', '0');
-- Feid
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('wpj5itnuyl6svuk', 'Feid', '17@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:17@artist.com', 'wpj5itnuyl6svuk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('wpj5itnuyl6svuk', 'My name is Feid', 'Feid');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('mu6j1z3258w28c6zdq6vek78js4u79qb62m2sghmfcaj8qh1iv','wpj5itnuyl6svuk', 'https://i.scdn.co/image/ab67616d0000b27329ebee2b5fb008871fcd201a', 'Feid Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('z08822p7sj6bs1f2585uozapbl8aevl98p2te1tkl5osun9l41','Classy 101','wpj5itnuyl6svuk',100,'POP','6XSqqQIy7Lm7SnwxS4NrGx',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('mu6j1z3258w28c6zdq6vek78js4u79qb62m2sghmfcaj8qh1iv', 'z08822p7sj6bs1f2585uozapbl8aevl98p2te1tkl5osun9l41', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('593dzkvt73o3apstg3fgakibp1n9v36qesju7oc3ssjqko8ugk','El Cielo','wpj5itnuyl6svuk',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('mu6j1z3258w28c6zdq6vek78js4u79qb62m2sghmfcaj8qh1iv', '593dzkvt73o3apstg3fgakibp1n9v36qesju7oc3ssjqko8ugk', '1');
-- Jimin
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('oj761pmh1l4wg0h', 'Jimin', '18@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:18@artist.com', 'oj761pmh1l4wg0h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('oj761pmh1l4wg0h', 'My name is Jimin', 'Jimin');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('v9ghe2rs441nc99smz4ndp2nfx2j9iabfgb4jam0ruzxwlnqus','oj761pmh1l4wg0h', 'https://i.scdn.co/image/ab67616d0000b2732b46078245d0120690eb560d', 'Jimin Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('l59d2eibb6bta1j71d6zfbz9a78zjvgye5b7vqoxj01mnoob94','Like Crazy','oj761pmh1l4wg0h',100,'POP','3Ua0m0YmEjrMi9XErKcNiR','https://p.scdn.co/mp3-preview/2db5f36096963d97afc870c50990d62d27858a43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('v9ghe2rs441nc99smz4ndp2nfx2j9iabfgb4jam0ruzxwlnqus', 'l59d2eibb6bta1j71d6zfbz9a78zjvgye5b7vqoxj01mnoob94', '0');
-- Gabito Ballesteros
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('p0g8ln6zo28zr85', 'Gabito Ballesteros', '19@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:19@artist.com', 'p0g8ln6zo28zr85', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('p0g8ln6zo28zr85', 'My name is Gabito Ballesteros', 'Gabito Ballesteros');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('0zu76yz41yn0lsrlkqajmeqiap5fcfnxud4e5iqzxbmq7dju2b','p0g8ln6zo28zr85', NULL, 'Gabito Ballesteros Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('9ksshluua1smgyxr1nroghi61de6tpo1fr850in6rc0f4crymz','LADY GAGA','p0g8ln6zo28zr85',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('0zu76yz41yn0lsrlkqajmeqiap5fcfnxud4e5iqzxbmq7dju2b', '9ksshluua1smgyxr1nroghi61de6tpo1fr850in6rc0f4crymz', '0');
-- Arctic Monkeys
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('nsfluo1qraaz0b6', 'Arctic Monkeys', '20@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:20@artist.com', 'nsfluo1qraaz0b6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('nsfluo1qraaz0b6', 'My name is Arctic Monkeys', 'Arctic Monkeys');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('zjszyrkopwwlbffx2067i83tveo1mfps6k2mj2qx38cfq71xce','nsfluo1qraaz0b6', 'https://i.scdn.co/image/ab67616d0000b2734ae1c4c5c45aabe565499163', 'Arctic Monkeys Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('whunb195pagn9ea0rw03pw5a5dqevjw4qj21dtewmiknk7s38s','I Wanna Be Yours','nsfluo1qraaz0b6',100,'POP','5XeFesFbtLpXzIVDNQP22n','https://p.scdn.co/mp3-preview/07de30bde8363d9ff78b72339245c151f67af451?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('zjszyrkopwwlbffx2067i83tveo1mfps6k2mj2qx38cfq71xce', 'whunb195pagn9ea0rw03pw5a5dqevjw4qj21dtewmiknk7s38s', '0');
-- Bizarrap
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('rn409fo9nsdj6s8', 'Bizarrap', '21@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:21@artist.com', 'rn409fo9nsdj6s8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('rn409fo9nsdj6s8', 'My name is Bizarrap', 'Bizarrap');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('4u36urxibickudighr5ax6qoo8wucooga066l475wtrp0l5a2q','rn409fo9nsdj6s8', 'https://i.scdn.co/image/ab67616d0000b27315583045b2fdb7d7bab10e81', 'Bizarrap Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('u2os9i858g7mmpsdqgmrvkt2njem3mw82oy9d4825elwaib2rr','Peso Pluma: Bzrp Music Sessions, Vol. 55','rn409fo9nsdj6s8',100,'POP','5AqiaZwhmC6dIbgWrD5SzV','https://p.scdn.co/mp3-preview/9d61998a29c2e8b52a7d46885352f5507eb219e2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('4u36urxibickudighr5ax6qoo8wucooga066l475wtrp0l5a2q', 'u2os9i858g7mmpsdqgmrvkt2njem3mw82oy9d4825elwaib2rr', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('68tv3006jyw1mipuuh6wzair9wgtc4sz7wsulk0ntmkiptcisd','Quevedo: Bzrp Music Sessions, Vol. 52','rn409fo9nsdj6s8',100,'POP','2tTmW7RDtMQtBk7m2rYeSw','https://p.scdn.co/mp3-preview/e9c0ed735e611f6af45bc946bd4c31590df09ed6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('4u36urxibickudighr5ax6qoo8wucooga066l475wtrp0l5a2q', '68tv3006jyw1mipuuh6wzair9wgtc4sz7wsulk0ntmkiptcisd', '1');
-- The Weeknd
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('kooucee73cg8i3j', 'The Weeknd', '22@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:22@artist.com', 'kooucee73cg8i3j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('kooucee73cg8i3j', 'My name is The Weeknd', 'The Weeknd');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('n4w27dgcm8uymn5vk75rf34hp25viiodgfxb1xni10kq3tn6tv','kooucee73cg8i3j', NULL, 'The Weeknd Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('jcnqfu4bsoga1e6didhvn7apzw7dfyxkpnay21d07qryk1sjqk','Popular (with Playboi Carti & Madonna) - The Idol Vol. 1 (Music from the HBO Original Series)','kooucee73cg8i3j',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('n4w27dgcm8uymn5vk75rf34hp25viiodgfxb1xni10kq3tn6tv', 'jcnqfu4bsoga1e6didhvn7apzw7dfyxkpnay21d07qryk1sjqk', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('a637veqxgnn9csxox0n22bgvawnleemyocpve7cq402lp6nxl5','Creepin','kooucee73cg8i3j',100,'POP','0GVaOXDGwtnH8gCURYyEaK','https://p.scdn.co/mp3-preview/a2b11e2f0cb8ef4a0316a686e73da9ec2b203e6e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('n4w27dgcm8uymn5vk75rf34hp25viiodgfxb1xni10kq3tn6tv', 'a637veqxgnn9csxox0n22bgvawnleemyocpve7cq402lp6nxl5', '1');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('hm7gq5r67b9fqxwkckj5n0yg00hdj1khzq7lhwxu1p2xpvt17e','Die For You','kooucee73cg8i3j',100,'POP','2LBqCSwhJGcFQeTHMVGwy3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('n4w27dgcm8uymn5vk75rf34hp25viiodgfxb1xni10kq3tn6tv', 'hm7gq5r67b9fqxwkckj5n0yg00hdj1khzq7lhwxu1p2xpvt17e', '2');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('0wdwf77orf5iv3f84y4xvfb0wppwzlt9j5xslc3834rfwcqm4e','Starboy','kooucee73cg8i3j',100,'POP','7MXVkk9YMctZqd1Srtv4MB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('n4w27dgcm8uymn5vk75rf34hp25viiodgfxb1xni10kq3tn6tv', '0wdwf77orf5iv3f84y4xvfb0wppwzlt9j5xslc3834rfwcqm4e', '3');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('hbfu4k7eljt007hcg6wm7x1ryykl7ulim471muea1yqa423j0r','Blinding Lights','kooucee73cg8i3j',100,'POP','0VjIjW4GlUZAMYd2vXMi3b',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('n4w27dgcm8uymn5vk75rf34hp25viiodgfxb1xni10kq3tn6tv', 'hbfu4k7eljt007hcg6wm7x1ryykl7ulim471muea1yqa423j0r', '4');
-- Fuerza Regida
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('4wzmxm0ptiucauu', 'Fuerza Regida', '23@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:23@artist.com', '4wzmxm0ptiucauu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('4wzmxm0ptiucauu', 'My name is Fuerza Regida', 'Fuerza Regida');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('pipeniqg2tq8f0esb7iwn2wqezfddzfw0wua5h9o6f7lynn0h2','4wzmxm0ptiucauu', 'https://i.scdn.co/image/ab67616d0000b273cfe3eb72c48b93971e53efd9', 'Fuerza Regida Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('mngsok8eo6kdscge8fgv3isw8el16lua731afcgg7ao3d4c78g','SABOR FRESA','4wzmxm0ptiucauu',100,'POP','1UMm1Qs3u59Wvk53zBUE8r','https://p.scdn.co/mp3-preview/590ae0b69465339d97ef5db9f7e36fe0c452fbb4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('pipeniqg2tq8f0esb7iwn2wqezfddzfw0wua5h9o6f7lynn0h2', 'mngsok8eo6kdscge8fgv3isw8el16lua731afcgg7ao3d4c78g', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('f9wn9r9j3zpg148d0jcskisrdnwhiy6f6kck8w060ztgp2n9rq','TQM','4wzmxm0ptiucauu',100,'POP','368eeEO3Y2uZUQ6S5oIjcu','https://p.scdn.co/mp3-preview/63f6b66cfcc3d7bd396dcbe18d6e3dee05fdb956?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('pipeniqg2tq8f0esb7iwn2wqezfddzfw0wua5h9o6f7lynn0h2', 'f9wn9r9j3zpg148d0jcskisrdnwhiy6f6kck8w060ztgp2n9rq', '1');
-- Rma
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('i95dhexwnk8gi9y', 'Rma', '24@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:24@artist.com', 'i95dhexwnk8gi9y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('i95dhexwnk8gi9y', 'My name is Rma', 'Rma');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('7zdfqib9mgomd5wvxu2aa4iz6emcitwew9lsyk3m29o8twnnud','i95dhexwnk8gi9y', NULL, 'Rma Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('m3rfgxce24qtug7qjdcv8ujkgr6oezpnak0k821wr01u5jgqo5','Calm Down (with Selena Gomez)','i95dhexwnk8gi9y',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('7zdfqib9mgomd5wvxu2aa4iz6emcitwew9lsyk3m29o8twnnud', 'm3rfgxce24qtug7qjdcv8ujkgr6oezpnak0k821wr01u5jgqo5', '0');
-- Tainy
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('79rhi504k7yiz79', 'Tainy', '25@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:25@artist.com', '79rhi504k7yiz79', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('79rhi504k7yiz79', 'My name is Tainy', 'Tainy');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('pbet4hj7ohqlv90dxs9xlxso6tqglgx7pdzx87rqlovltydneg','79rhi504k7yiz79', 'https://i.scdn.co/image/ab67616d0000b273de7b9af78fbdda96c5a0635b', 'Tainy Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('qcdymb02zdvqwytkvmti34of9nnra65t2r94bp5s7d3n7f2rw9','MOJABI GHOST','79rhi504k7yiz79',100,'POP','4eMKD8MRroxCqugpsxCCNb','https://p.scdn.co/mp3-preview/a6d8180d52b759c3e3db9aa78e841ffc06e26c17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('pbet4hj7ohqlv90dxs9xlxso6tqglgx7pdzx87rqlovltydneg', 'qcdymb02zdvqwytkvmti34of9nnra65t2r94bp5s7d3n7f2rw9', '0');
-- Morgan Wallen
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('99qmly38bl5et8y', 'Morgan Wallen', '26@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:26@artist.com', '99qmly38bl5et8y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('99qmly38bl5et8y', 'My name is Morgan Wallen', 'Morgan Wallen');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('udj10ekslv6dzoatcgm1a17i54nll21ef4jfrtq8ii4pdfx1hu','99qmly38bl5et8y', 'https://i.scdn.co/image/ab67616d0000b273705079df9a25a28b452c1fc9', 'Morgan Wallen Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('a2c32x4c1n2n77f8iaqo56fvjc5os2l0cnni5bzcjc3n71elr1','Last Night','99qmly38bl5et8y',100,'POP','7K3BhSpAxZBznislvUMVtn',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('udj10ekslv6dzoatcgm1a17i54nll21ef4jfrtq8ii4pdfx1hu', 'a2c32x4c1n2n77f8iaqo56fvjc5os2l0cnni5bzcjc3n71elr1', '0');
-- Dua Lipa
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('4hao6t6lcvv761l', 'Dua Lipa', '27@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:27@artist.com', '4hao6t6lcvv761l', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('4hao6t6lcvv761l', 'My name is Dua Lipa', 'Dua Lipa');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('yeekox6gqim5qbwcsyvzr30hqn44avem3qfqp25drepengl4g2','4hao6t6lcvv761l', 'https://i.scdn.co/image/ab67616d0000b2737dd3ba455ee3390cb55b0192', 'Dua Lipa Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('52ulwbib3jqoydxd45bk7w8055ygsxih995il70w4jeu15mu4w','Dance The Night (From Barbie The Album)','4hao6t6lcvv761l',100,'POP','1vYXt7VSjH9JIM5oRRo7vA','https://p.scdn.co/mp3-preview/acaea048f50a3b30ca24b348c84a6047373baabb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('yeekox6gqim5qbwcsyvzr30hqn44avem3qfqp25drepengl4g2', '52ulwbib3jqoydxd45bk7w8055ygsxih995il70w4jeu15mu4w', '0');
-- Troye Sivan
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('iywc0a9731l2tvg', 'Troye Sivan', '28@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:28@artist.com', 'iywc0a9731l2tvg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('iywc0a9731l2tvg', 'My name is Troye Sivan', 'Troye Sivan');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('d0waacsxwse2lk6xhljabdy7a1frneo17o3dfxqdq1ysw4rnft','iywc0a9731l2tvg', 'https://i.scdn.co/image/ab67616d0000b27367103283a4eb57578a428252', 'Troye Sivan Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('pdr9tpsur67x0ytz955bmh6l8sw19m3y43ft09xugqhjh4hd4h','Rush','iywc0a9731l2tvg',100,'POP','4ZnkygoWLzcGbQYCm3lkae',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('d0waacsxwse2lk6xhljabdy7a1frneo17o3dfxqdq1ysw4rnft', 'pdr9tpsur67x0ytz955bmh6l8sw19m3y43ft09xugqhjh4hd4h', '0');
-- Karol G
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('1p480opp5drnv85', 'Karol G', '29@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:29@artist.com', '1p480opp5drnv85', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('1p480opp5drnv85', 'My name is Karol G', 'Karol G');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('8ylwiv9fbr9f15q0div2ty90q0pbrw7k4yc5pnn17ih0vsh1c7','1p480opp5drnv85', 'https://i.scdn.co/image/ab67616d0000b27382de1ca074ae63cb18fce335', 'Karol G Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('lc5ol9xxdm8illqlr48cnpbez2b8jx6nnjmpny59r0ptz57fjd','TQG','1p480opp5drnv85',100,'POP','0DWdj2oZMBFSzRsi2Cvfzf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('8ylwiv9fbr9f15q0div2ty90q0pbrw7k4yc5pnn17ih0vsh1c7', 'lc5ol9xxdm8illqlr48cnpbez2b8jx6nnjmpny59r0ptz57fjd', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('y1hnxsy5y8wwqmpowfdej06gxzks8ih1k3q2vpgzxy6i8ejfwl','AMARGURA','1p480opp5drnv85',100,'POP','505v13epFXodT9fVAJ6h8k',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('8ylwiv9fbr9f15q0div2ty90q0pbrw7k4yc5pnn17ih0vsh1c7', 'y1hnxsy5y8wwqmpowfdej06gxzks8ih1k3q2vpgzxy6i8ejfwl', '1');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('gmxhujrnue6vd3agbjs9vnttmhgrdx7v5aebi7wcwsi069iwdw','S91','1p480opp5drnv85',100,'POP','7EpOXgSRgnglRWr86pZfGU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('8ylwiv9fbr9f15q0div2ty90q0pbrw7k4yc5pnn17ih0vsh1c7', 'gmxhujrnue6vd3agbjs9vnttmhgrdx7v5aebi7wcwsi069iwdw', '2');
-- Big One
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('2bmk2zd135ao4oq', 'Big One', '30@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:30@artist.com', '2bmk2zd135ao4oq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('2bmk2zd135ao4oq', 'My name is Big One', 'Big One');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('787r6h3fbevnefbdbqorcxpimzu45tksfd90ykdknxa8oe8qaj','2bmk2zd135ao4oq', NULL, 'Big One Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('lu9oxj8nda0p4sm71mhf55imgriiqk304j2mjbisqgsa96l8pe','Los del Espacio','2bmk2zd135ao4oq',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('787r6h3fbevnefbdbqorcxpimzu45tksfd90ykdknxa8oe8qaj', 'lu9oxj8nda0p4sm71mhf55imgriiqk304j2mjbisqgsa96l8pe', '0');
-- Yahritza Y Su Esencia
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('pvgus480cy1hulk', 'Yahritza Y Su Esencia', '31@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:31@artist.com', 'pvgus480cy1hulk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('pvgus480cy1hulk', 'My name is Yahritza Y Su Esencia', 'Yahritza Y Su Esencia');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('yaf1mylf571nctb8g5kk15lqyzwpqb99kv4by9dm4ikf7wqter','pvgus480cy1hulk', NULL, 'Yahritza Y Su Esencia Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('qcjoihneg3xuzomvcrbuje8c44lref1qrxxrgyqpq2wpst4mbp','Frgil (feat. Grupo Front','pvgus480cy1hulk',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('yaf1mylf571nctb8g5kk15lqyzwpqb99kv4by9dm4ikf7wqter', 'qcjoihneg3xuzomvcrbuje8c44lref1qrxxrgyqpq2wpst4mbp', '0');
-- Junior H
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('xpa4rtkpxaqrwes', 'Junior H', '32@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:32@artist.com', 'xpa4rtkpxaqrwes', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('xpa4rtkpxaqrwes', 'My name is Junior H', 'Junior H');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('34umpqre31fu1fil48c4err39a70creqegmay4dbn3cz7xg72d','xpa4rtkpxaqrwes', 'https://i.scdn.co/image/ab67616d0000b27333ed356efed99b158c4267c6', 'Junior H Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ictd2pugfgwt0sm1pjbu1e412t576sa35bqc0uxkn7zuhzkcxk','El Azul','xpa4rtkpxaqrwes',100,'POP','1haJsMtoBhHfvuM7XWuT3W','https://p.scdn.co/mp3-preview/f9df136c3a2d3c0c5424e2c4b75a303f35c08af5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('34umpqre31fu1fil48c4err39a70creqegmay4dbn3cz7xg72d', 'ictd2pugfgwt0sm1pjbu1e412t576sa35bqc0uxkn7zuhzkcxk', '0');
-- Post Malone
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('rzh36oxqqu3bzd0', 'Post Malone', '33@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:33@artist.com', 'rzh36oxqqu3bzd0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('rzh36oxqqu3bzd0', 'My name is Post Malone', 'Post Malone');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('x31up5st3zuxx62vll4yfjc69ohm4fcccntfd84240ky9cnuce','rzh36oxqqu3bzd0', 'https://i.scdn.co/image/ab67616d0000b2739478c87599550dd73bfa7e02', 'Post Malone Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ito02l3gd2hlcfnnhrl3h03rg55lky0uyxmgjjm9oyc82xymjp','Sunflower - Spider-Man: Into the Spider-Verse','rzh36oxqqu3bzd0',100,'POP','0RiRZpuVRbi7oqRdSMwhQY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('x31up5st3zuxx62vll4yfjc69ohm4fcccntfd84240ky9cnuce', 'ito02l3gd2hlcfnnhrl3h03rg55lky0uyxmgjjm9oyc82xymjp', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('3z7m2e762ak7jdj073dhzqoiys5okfnnml7h6wwnvtlfooyyc2','Overdrive','rzh36oxqqu3bzd0',100,'POP','3t0ic4mkhvhamrKDkulB8v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('x31up5st3zuxx62vll4yfjc69ohm4fcccntfd84240ky9cnuce', '3z7m2e762ak7jdj073dhzqoiys5okfnnml7h6wwnvtlfooyyc2', '1');
-- Bebe Rexha
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('3w1af2mje9fabij', 'Bebe Rexha', '34@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:34@artist.com', '3w1af2mje9fabij', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('3w1af2mje9fabij', 'My name is Bebe Rexha', 'Bebe Rexha');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('bsh137li27g6z5ycndrhpk4dtk2653qsi0cax71izu2tpby1yf','3w1af2mje9fabij', NULL, 'Bebe Rexha Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('n8qu7ioydg0o2wzt3rtv8ahqctzganlqbvqqrvppstprf9zsff','Im Good (Blue)','3w1af2mje9fabij',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('bsh137li27g6z5ycndrhpk4dtk2653qsi0cax71izu2tpby1yf', 'n8qu7ioydg0o2wzt3rtv8ahqctzganlqbvqqrvppstprf9zsff', '0');
-- Tyler
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('04e7syopnrg4ejk', 'Tyler', '35@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:35@artist.com', '04e7syopnrg4ejk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('04e7syopnrg4ejk', 'My name is Tyler', 'Tyler');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('15vxsyl5eyhxp468k7skhjzccot2jvgdth63jvck21xfwpmqvi','04e7syopnrg4ejk', 'https://i.scdn.co/image/ab67616d0000b2738940ac99f49e44f59e6f7fb3', 'Tyler Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('jb7x3aw7htcu5rxlovqp12khiphmrzigqhhlbjpnjfelw3jdma','See You Again','04e7syopnrg4ejk',100,'POP','7KA4W4McWYRpgf0fWsJZWB','https://p.scdn.co/mp3-preview/c703198293891e3b276800ea6b187cf7951d3d7d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('15vxsyl5eyhxp468k7skhjzccot2jvgdth63jvck21xfwpmqvi', 'jb7x3aw7htcu5rxlovqp12khiphmrzigqhhlbjpnjfelw3jdma', '0');
-- Nicki Minaj
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('klnv61zd6ldbth8', 'Nicki Minaj', '36@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:36@artist.com', 'klnv61zd6ldbth8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('klnv61zd6ldbth8', 'My name is Nicki Minaj', 'Nicki Minaj');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('p49yy78drmidkfpyo7esg2ze15kn6o4pwmqp5dez2gwulwtpqi','klnv61zd6ldbth8', 'https://i.scdn.co/image/ab67616d0000b2737e8f938c02fac3b564931116', 'Nicki Minaj Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ae1fazjet1k2luq7eka58guhokomxhy7dknghcqpzeul482r0m','Barbie World (with Aqua) [From Barbie The Album]','klnv61zd6ldbth8',100,'POP','741UUVE2kuITl0c6zuqqbO','https://p.scdn.co/mp3-preview/f654928ccaa4e6a9fb09a6eb3f208383eccc12a9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('p49yy78drmidkfpyo7esg2ze15kn6o4pwmqp5dez2gwulwtpqi', 'ae1fazjet1k2luq7eka58guhokomxhy7dknghcqpzeul482r0m', '0');
-- OneRepublic
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('qyxjouuwththqrd', 'OneRepublic', '37@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:37@artist.com', 'qyxjouuwththqrd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('qyxjouuwththqrd', 'My name is OneRepublic', 'OneRepublic');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('5j78ee6f6pb9vc5yjzk643xkkya1f5894zgjeir66jndpqfnru','qyxjouuwththqrd', 'https://i.scdn.co/image/ab67616d0000b273ec96e006b8bdfc582610ec13', 'OneRepublic Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('13ocvqi55djujc3jmnnc1cne54yg15ngwkdj1qxm4teh6b9g4w','I Aint Worried','qyxjouuwththqrd',100,'POP','4h9wh7iOZ0GGn8QVp4RAOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('5j78ee6f6pb9vc5yjzk643xkkya1f5894zgjeir66jndpqfnru', '13ocvqi55djujc3jmnnc1cne54yg15ngwkdj1qxm4teh6b9g4w', '0');
-- Ariana Grande
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('4ekngq7d4vsbrpo', 'Ariana Grande', '38@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:38@artist.com', '4ekngq7d4vsbrpo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('4ekngq7d4vsbrpo', 'My name is Ariana Grande', 'Ariana Grande');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ar8vllxggkva30wd14ni3h5c6d13iybxp1bs327rcauv8cmqo8','4ekngq7d4vsbrpo', NULL, 'Ariana Grande Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('2gplo01as7xmukqtvt37426vcufaslsz1mp1pkaupims5lytve','Die For You - Remix','4ekngq7d4vsbrpo',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ar8vllxggkva30wd14ni3h5c6d13iybxp1bs327rcauv8cmqo8', '2gplo01as7xmukqtvt37426vcufaslsz1mp1pkaupims5lytve', '0');
-- David Guetta
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('r4we7uj2kdlegoz', 'David Guetta', '39@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:39@artist.com', 'r4we7uj2kdlegoz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('r4we7uj2kdlegoz', 'My name is David Guetta', 'David Guetta');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('tcl07qofb1j3asv56200kaolpzx0sbov9rzmnahuf4ax0o9zye','r4we7uj2kdlegoz', 'https://i.scdn.co/image/ab67616d0000b2730b4ef75c3728599aa4104f7a', 'David Guetta Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('63aofzn52lp4j1q1p7ted3w7o06sze568gb8cewf621ktlua7u','Baby Dont Hurt Me','r4we7uj2kdlegoz',100,'POP','3BKD1PwArikchz2Zrlp1qi','https://p.scdn.co/mp3-preview/a8f2e176e17e0f6298b42ef8e96118318fdd2b89?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('tcl07qofb1j3asv56200kaolpzx0sbov9rzmnahuf4ax0o9zye', '63aofzn52lp4j1q1p7ted3w7o06sze568gb8cewf621ktlua7u', '0');
-- Peggy Gou
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('2avzkqek1r06hvp', 'Peggy Gou', '40@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:40@artist.com', '2avzkqek1r06hvp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('2avzkqek1r06hvp', 'My name is Peggy Gou', 'Peggy Gou');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('6sfyzt3ejurrvim29tds5ji90mixosv4vmrnmica43xvr1ktha','2avzkqek1r06hvp', 'https://i.scdn.co/image/ab67616d0000b27388d71aadd009fe1a83df88f2', 'Peggy Gou Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('25clbqzdraqz8w4bielsipt087o4u57kppscrkx2z0fyowknnm','(It Goes Like) Nanana - Edit','2avzkqek1r06hvp',100,'POP','23RoR84KodL5HWvUTneQ1w','https://p.scdn.co/mp3-preview/e36e0bd4714844f1f9d992398b41a3e333f15cc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('6sfyzt3ejurrvim29tds5ji90mixosv4vmrnmica43xvr1ktha', '25clbqzdraqz8w4bielsipt087o4u57kppscrkx2z0fyowknnm', '0');
-- Tom Odell
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('k3dpvvdlhdg471o', 'Tom Odell', '41@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:41@artist.com', 'k3dpvvdlhdg471o', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('k3dpvvdlhdg471o', 'My name is Tom Odell', 'Tom Odell');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('jmxkobuim4qgi8ap39ahctbc8z1sya0yk3s6cssbw3zq2j9b3v','k3dpvvdlhdg471o', 'https://i.scdn.co/image/ab67616d0000b2731917a0f3f4152622a040913f', 'Tom Odell Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('vqpozsqb1i4gngpxeu3umkb1jjshatb8i10afpahq4sqqg08p3','Another Love','k3dpvvdlhdg471o',100,'POP','3JvKfv6T31zO0ini8iNItO','https://p.scdn.co/mp3-preview/0369cb748bc968ffd34fb4ac60f5403f2aad032f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('jmxkobuim4qgi8ap39ahctbc8z1sya0yk3s6cssbw3zq2j9b3v', 'vqpozsqb1i4gngpxeu3umkb1jjshatb8i10afpahq4sqqg08p3', '0');
-- Kali Uchis
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('p01igl4hnb85amw', 'Kali Uchis', '42@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:42@artist.com', 'p01igl4hnb85amw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('p01igl4hnb85amw', 'My name is Kali Uchis', 'Kali Uchis');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('5nshe1j01rxdj18mhneq0w4ykwg2uf9tgta1ip77ud7on1feia','p01igl4hnb85amw', 'https://i.scdn.co/image/ab67616d0000b27381fccd758776d16b87721b17', 'Kali Uchis Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('hkqnlbbb7nqzgdzhc3bb6les6icjtac20ei3ta9z99qkcnbkrv','Moonlight','p01igl4hnb85amw',100,'POP','0JmnkIqdlnUzPaf8sqBRs3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('5nshe1j01rxdj18mhneq0w4ykwg2uf9tgta1ip77ud7on1feia', 'hkqnlbbb7nqzgdzhc3bb6les6icjtac20ei3ta9z99qkcnbkrv', '0');
-- Manuel Turizo
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('9qnkwmwu7yqtddo', 'Manuel Turizo', '43@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:43@artist.com', '9qnkwmwu7yqtddo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('9qnkwmwu7yqtddo', 'My name is Manuel Turizo', 'Manuel Turizo');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('b46uryg7zh46v8m6c3olrk7zwad52cw62rfh0amhc5wqplx2wf','9qnkwmwu7yqtddo', 'https://i.scdn.co/image/ab67616d0000b273c9f744b0d62da795bc21d04a', 'Manuel Turizo Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('3g7ndv0xxjrdps1swo8cpj01t8pwcbouhydgxka8hrjx82mygt','La Bachata','9qnkwmwu7yqtddo',100,'POP','5ww2BF9slyYgNOk37BlC4u','https://p.scdn.co/mp3-preview/0232b53fd7849e6696e1ab3099dd01dd00823f17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('b46uryg7zh46v8m6c3olrk7zwad52cw62rfh0amhc5wqplx2wf', '3g7ndv0xxjrdps1swo8cpj01t8pwcbouhydgxka8hrjx82mygt', '0');
-- dennis
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('b8px1dn8s8zu8ms', 'dennis', '44@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:44@artist.com', 'b8px1dn8s8zu8ms', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('b8px1dn8s8zu8ms', 'My name is dennis', 'dennis');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('3v37xks2u8tfk1knonecp5v398y771ln21f47yskrvmq3vx1gg','b8px1dn8s8zu8ms', 'https://i.scdn.co/image/ab67616d0000b273ddfc406de0d7dbc2e339f016', 'dennis Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('f7prurmas0fsh0vgju5qlhu5mqjwwg31wehtgqcg5jj2234xj5','T','b8px1dn8s8zu8ms',100,'POP','35FW5OEe4p38LdjK1KqT2X','https://p.scdn.co/mp3-preview/eaa522f48564e43e33e00c011aef0489526d1072?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('3v37xks2u8tfk1knonecp5v398y771ln21f47yskrvmq3vx1gg', 'f7prurmas0fsh0vgju5qlhu5mqjwwg31wehtgqcg5jj2234xj5', '0');
-- PinkPantheress
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('kbzjblyg83a0p39', 'PinkPantheress', '45@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:45@artist.com', 'kbzjblyg83a0p39', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('kbzjblyg83a0p39', 'My name is PinkPantheress', 'PinkPantheress');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('z4ullb9qyil871raciynhbudtushv1emlrvysd33k014ud8xwa','kbzjblyg83a0p39', 'https://i.scdn.co/image/ab67616d0000b2739567e1aa41657425d046733b', 'PinkPantheress Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('0g4fi92462y0y67su59eixlhpxut7c07w5hc7bc1hlmx44d33m','Boys a liar Pt. 2','kbzjblyg83a0p39',100,'POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('z4ullb9qyil871raciynhbudtushv1emlrvysd33k014ud8xwa', '0g4fi92462y0y67su59eixlhpxut7c07w5hc7bc1hlmx44d33m', '0');
-- Charlie Puth
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('87lopgsy8s6l4um', 'Charlie Puth', '46@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:46@artist.com', '87lopgsy8s6l4um', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('87lopgsy8s6l4um', 'My name is Charlie Puth', 'Charlie Puth');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('f00uyh0r0cea0ke7f6qqralxyosbnar9cxq7an1basezjxzmed','87lopgsy8s6l4um', 'https://i.scdn.co/image/ab67616d0000b27335d2e0ed94a934f2cc46fa49', 'Charlie Puth Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('4xhhvvrdsii2ijr17qjlzgbhlyl8t7iv82rpan2zvm8xthxj63','Left and Right (Feat. Jung Kook of BTS)','87lopgsy8s6l4um',100,'POP','5Odq8ohlgIbQKMZivbWkEo','https://p.scdn.co/mp3-preview/9e4342eefa4f33df4e9b199e60dbce0f59e46eff?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('f00uyh0r0cea0ke7f6qqralxyosbnar9cxq7an1basezjxzmed', '4xhhvvrdsii2ijr17qjlzgbhlyl8t7iv82rpan2zvm8xthxj63', '0');
-- Rauw Alejandro
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('1vaswofqgs5ogeh', 'Rauw Alejandro', '47@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:47@artist.com', '1vaswofqgs5ogeh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('1vaswofqgs5ogeh', 'My name is Rauw Alejandro', 'Rauw Alejandro');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('tyqpcywfm928ao42taoevnx3faspkoajvzhxjc1gqty1gn6me9','1vaswofqgs5ogeh', NULL, 'Rauw Alejandro Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('3sjddgb4q5juihdt3h2ohwebllrofcvbpjgjmjrx20tvpuis9p','BESO','1vaswofqgs5ogeh',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('tyqpcywfm928ao42taoevnx3faspkoajvzhxjc1gqty1gn6me9', '3sjddgb4q5juihdt3h2ohwebllrofcvbpjgjmjrx20tvpuis9p', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('g5slzsi33tp19snoaqvl6qjr3snahb9v1z21xxm4a01nt0rjo6','BABY HELLO','1vaswofqgs5ogeh',100,'POP','2SOvWt6igzXViIjIiWNWEP','https://p.scdn.co/mp3-preview/8a9ca6c81e6e6ad48758f02017456405fd7a476d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('tyqpcywfm928ao42taoevnx3faspkoajvzhxjc1gqty1gn6me9', 'g5slzsi33tp19snoaqvl6qjr3snahb9v1z21xxm4a01nt0rjo6', '1');
-- Ozuna
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('bzynw8iy4gj3jmd', 'Ozuna', '48@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:48@artist.com', 'bzynw8iy4gj3jmd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('bzynw8iy4gj3jmd', 'My name is Ozuna', 'Ozuna');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('sjwfohfzlydg2o5mx8c5mmyphzpp78xt79rsrqg0nh518d8bk5','bzynw8iy4gj3jmd', 'https://i.scdn.co/image/ab67616d0000b273125624f2e04f5a1ccb0dfb45', 'Ozuna Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('vsv7ylrlxh1wqfu47pgmyue6mpz84ihezd370pvijjuu4q3lz4','Hey Mor','bzynw8iy4gj3jmd',100,'POP','1zsPaEkglFvxjAhrM8yhpr','https://p.scdn.co/mp3-preview/cd2d2242b748408da15c2b66f47d54b3f0793ae0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('sjwfohfzlydg2o5mx8c5mmyphzpp78xt79rsrqg0nh518d8bk5', 'vsv7ylrlxh1wqfu47pgmyue6mpz84ihezd370pvijjuu4q3lz4', '0');
-- Chris Molitor
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('zcjei1nxkurn7ro', 'Chris Molitor', '49@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:49@artist.com', 'zcjei1nxkurn7ro', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('zcjei1nxkurn7ro', 'My name is Chris Molitor', 'Chris Molitor');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('twhgdqci6pmhmjp1fz1fp5x0zfzlfjcz9ql4xsj64e57ze1wi5','zcjei1nxkurn7ro', 'https://i.scdn.co/image/ab67616d0000b273be011d16b9360a7dee109774', 'Chris Molitor Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('6spjz392ap7e2nkav0qly9sjf0hr58z4wx04wkxmgqo7vskypj','Yellow','zcjei1nxkurn7ro',100,'POP','6tvs7zEP8d1SBgSqZQ84OT','https://p.scdn.co/mp3-preview/ea93f9b43fc638111ad661719037bfb88cd9c05d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('twhgdqci6pmhmjp1fz1fp5x0zfzlfjcz9ql4xsj64e57ze1wi5', '6spjz392ap7e2nkav0qly9sjf0hr58z4wx04wkxmgqo7vskypj', '0');
-- Libianca
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('urlhh1crh1j500p', 'Libianca', '50@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:50@artist.com', 'urlhh1crh1j500p', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('urlhh1crh1j500p', 'My name is Libianca', 'Libianca');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('14y70eyvrqtk4z6y9kgql9kahws1915j8un7828k7hh4srm02s','urlhh1crh1j500p', 'https://i.scdn.co/image/ab67616d0000b273fc342f95f117d48dbdde9735', 'Libianca Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('t10nqlo57jty85c3i9cttaprxem95w0pocjy8ec6nbec68l7y5','People','urlhh1crh1j500p',100,'POP','26b3oVLrRUaaybJulow9kz','https://p.scdn.co/mp3-preview/abcbc9adf10ae4901b40b80a30dc194d589c2d62?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('14y70eyvrqtk4z6y9kgql9kahws1915j8un7828k7hh4srm02s', 't10nqlo57jty85c3i9cttaprxem95w0pocjy8ec6nbec68l7y5', '0');
-- Glass Animals
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('o5bxatv24fk3b13', 'Glass Animals', '51@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:51@artist.com', 'o5bxatv24fk3b13', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('o5bxatv24fk3b13', 'My name is Glass Animals', 'Glass Animals');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('qlg6l8wdfc8g5cqye9z7pxpaqw84eyi2l1s49lixo5lhd89alq','o5bxatv24fk3b13', 'https://i.scdn.co/image/ab67616d0000b273712701c5e263efc8726b1464', 'Glass Animals Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('crsfdu7hc7wn7o38k79ket1b8wfkhbq4huk9fg0exf3421e0he','Heat Waves','o5bxatv24fk3b13',100,'POP','3USxtqRwSYz57Ewm6wWRMp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('qlg6l8wdfc8g5cqye9z7pxpaqw84eyi2l1s49lixo5lhd89alq', 'crsfdu7hc7wn7o38k79ket1b8wfkhbq4huk9fg0exf3421e0he', '0');
-- JVKE
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('ljfhvi0a7idurkt', 'JVKE', '52@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:52@artist.com', 'ljfhvi0a7idurkt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ljfhvi0a7idurkt', 'My name is JVKE', 'JVKE');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ywib68iegi5p2k5hbhnwjd0h4dcimeh60stw0lg30yf9k1v7to','ljfhvi0a7idurkt', 'https://i.scdn.co/image/ab67616d0000b273c2504e80ba2f258697ab2954', 'JVKE Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('wize64eazevjvihp7z4g5g25qg7e5ajl62nm1tfxn6hzdr87bl','golden hour','ljfhvi0a7idurkt',100,'POP','5odlY52u43F5BjByhxg7wg','https://p.scdn.co/mp3-preview/bcc17f30841d6fbf3cd7954c3e3cf669f11b6a21?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ywib68iegi5p2k5hbhnwjd0h4dcimeh60stw0lg30yf9k1v7to', 'wize64eazevjvihp7z4g5g25qg7e5ajl62nm1tfxn6hzdr87bl', '0');
-- The Neighbourhood
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('82p79n5h6niqgrc', 'The Neighbourhood', '53@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:53@artist.com', '82p79n5h6niqgrc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('82p79n5h6niqgrc', 'My name is The Neighbourhood', 'The Neighbourhood');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('k9rwmxrpd9h9qg31btpcqrhf1j1oni14p867lc6ew7ye03j1ri','82p79n5h6niqgrc', 'https://i.scdn.co/image/ab67616d0000b2738265a736a1eb838ad5a0b921', 'The Neighbourhood Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('uzci3jx77191l1aits59jl3u1387ok264qrmkf4qe4l7kc9ghf','Sweater Weather','82p79n5h6niqgrc',100,'POP','2QjOHCTQ1Jl3zawyYOpxh6','https://p.scdn.co/mp3-preview/877602f424a9dea277b13301ffc516f9fd1fbe7e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('k9rwmxrpd9h9qg31btpcqrhf1j1oni14p867lc6ew7ye03j1ri', 'uzci3jx77191l1aits59jl3u1387ok264qrmkf4qe4l7kc9ghf', '0');
-- Coldplay
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('1an50xanyqse30b', 'Coldplay', '54@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:54@artist.com', '1an50xanyqse30b', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('1an50xanyqse30b', 'My name is Coldplay', 'Coldplay');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('o0vjmmge35x5r5it9ijipkmdfra59q60abfg0v0cg0w1qd83a7','1an50xanyqse30b', 'https://i.scdn.co/image/ab67616d0000b273e21cc1db05580b6f2d2a3b6e', 'Coldplay Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('tq16z6lsomplw1kkw2gsmbqp5bouhyehv56n5xu4r86nfjsybf','Viva La Vida','1an50xanyqse30b',100,'POP','1mea3bSkSGXuIRvnydlB5b','https://p.scdn.co/mp3-preview/fb9f4a9b0887326776b4fb7c6d331acd167a7778?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('o0vjmmge35x5r5it9ijipkmdfra59q60abfg0v0cg0w1qd83a7', 'tq16z6lsomplw1kkw2gsmbqp5bouhyehv56n5xu4r86nfjsybf', '0');
-- d4vd
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('ak9p9kt0uljb5j4', 'd4vd', '55@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:55@artist.com', 'ak9p9kt0uljb5j4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ak9p9kt0uljb5j4', 'My name is d4vd', 'd4vd');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('aytxpyajldeyl5u01fbwrq0i79dr32m5m1g8t65yzmbwus43yl','ak9p9kt0uljb5j4', 'https://i.scdn.co/image/ab67616d0000b27364fa1bda999f4fbd2b7c4bb7', 'd4vd Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('lt7xi540m0aphrkwqns1c9r0pnpanquwfuua8l5ujfdiy3w7rm','Here With Me','ak9p9kt0uljb5j4',100,'POP','5LrN7yUQAzvthd4QujgPFr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('aytxpyajldeyl5u01fbwrq0i79dr32m5m1g8t65yzmbwus43yl', 'lt7xi540m0aphrkwqns1c9r0pnpanquwfuua8l5ujfdiy3w7rm', '0');
-- Sam Smith
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('0i2b8bxnyp3b05q', 'Sam Smith', '56@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:56@artist.com', '0i2b8bxnyp3b05q', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('0i2b8bxnyp3b05q', 'My name is Sam Smith', 'Sam Smith');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('b2gc5nv28pajvy5tt62xalhulij2y6env39c8s2xphy3c8ardt','0i2b8bxnyp3b05q', 'https://i.scdn.co/image/ab67616d0000b273a935e4689f15953311772cc4', 'Sam Smith Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ib0ba3mlmwo447jul4rssbchnd332kaioy0ywei0su7vc7rknv','Unholy (feat. Kim Petras)','0i2b8bxnyp3b05q',100,'POP','3nqQXoyQOWXiESFLlDF1hG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('b2gc5nv28pajvy5tt62xalhulij2y6env39c8s2xphy3c8ardt', 'ib0ba3mlmwo447jul4rssbchnd332kaioy0ywei0su7vc7rknv', '0');
-- Yandel
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('tnl6a89gxspuunp', 'Yandel', '57@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:57@artist.com', 'tnl6a89gxspuunp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('tnl6a89gxspuunp', 'My name is Yandel', 'Yandel');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('wsc16fxe3rxc2bw7q3p8snq1npvr0mmbd7izkvcwdggvcj6410','tnl6a89gxspuunp', 'https://i.scdn.co/image/ab67616d0000b273b2aec01b56eeb74610532700', 'Yandel Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('pzpo36taguz1ugv6sc9jsc4mgcrpo2fqhsykjgyfmxoolwrr21','Yandel 150','tnl6a89gxspuunp',100,'POP','4FAKtPVycI4DxoOHC01YqD','https://p.scdn.co/mp3-preview/338ed053ce26ccc3313b00b5e6153e60ffd2eb19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('wsc16fxe3rxc2bw7q3p8snq1npvr0mmbd7izkvcwdggvcj6410', 'pzpo36taguz1ugv6sc9jsc4mgcrpo2fqhsykjgyfmxoolwrr21', '0');
-- Maria Becerra
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('ry02w17djjt11z5', 'Maria Becerra', '58@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:58@artist.com', 'ry02w17djjt11z5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ry02w17djjt11z5', 'My name is Maria Becerra', 'Maria Becerra');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('cr12o2nfe2xwjporuc0ffoczmvn2ilrnu88d20si1lnthdcmjo','ry02w17djjt11z5', NULL, 'Maria Becerra Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ixoo3i9s0ty7882xtkqwatrn3ll2ezfebj2m3pc9lpw37qm740','CORAZN VA','ry02w17djjt11z5',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cr12o2nfe2xwjporuc0ffoczmvn2ilrnu88d20si1lnthdcmjo', 'ixoo3i9s0ty7882xtkqwatrn3ll2ezfebj2m3pc9lpw37qm740', '0');
-- Vance Joy
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('6kdj42znjuy3bcx', 'Vance Joy', '59@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:59@artist.com', '6kdj42znjuy3bcx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('6kdj42znjuy3bcx', 'My name is Vance Joy', 'Vance Joy');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('o34wfl57cuhqber1b62waoweio5vvzczcfk00s7zq4l1aexj7s','6kdj42znjuy3bcx', 'https://i.scdn.co/image/ab67616d0000b273a9929deb093a6617d2493b03', 'Vance Joy Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('57l0g63fqoi6nkidl695dt44fa4ky8aqy7po9hy21xvpm5dk9b','Riptide','6kdj42znjuy3bcx',100,'POP','3JvrhDOgAt6p7K8mDyZwRd','https://p.scdn.co/mp3-preview/74698d907d114f4ba0b2c129bbf260724be80b64?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('o34wfl57cuhqber1b62waoweio5vvzczcfk00s7zq4l1aexj7s', '57l0g63fqoi6nkidl695dt44fa4ky8aqy7po9hy21xvpm5dk9b', '0');
-- Em Beihold
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('vejkk0tqwtq9obk', 'Em Beihold', '60@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:60@artist.com', 'vejkk0tqwtq9obk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('vejkk0tqwtq9obk', 'My name is Em Beihold', 'Em Beihold');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('im5n0lbl2np7ka253zuqlfkj7ug1rtad1y6z52149jeva7ofh5','vejkk0tqwtq9obk', NULL, 'Em Beihold Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ws1x6eqntozp8jjf6jy4h4c8ha3uo0tgcx4sy34hnh65cjddar','Until I Found You (with Em Beihold) - Em Beihold Version','vejkk0tqwtq9obk',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('im5n0lbl2np7ka253zuqlfkj7ug1rtad1y6z52149jeva7ofh5', 'ws1x6eqntozp8jjf6jy4h4c8ha3uo0tgcx4sy34hnh65cjddar', '0');
-- Mc Livinho
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('f9onpxsyulu88tc', 'Mc Livinho', '61@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:61@artist.com', 'f9onpxsyulu88tc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('f9onpxsyulu88tc', 'My name is Mc Livinho', 'Mc Livinho');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('xc8f2df92v80mpfhxa08beb1ylflqj0knlu7w5uu7mk7losyrw','f9onpxsyulu88tc', 'https://i.scdn.co/image/ab67616d0000b273369c960fed23353176da1218', 'Mc Livinho Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ww18v7bojq1jqvv71t6tmye4m5f0hy54nyylvggucj1znx7mmg','Novidade na ','f9onpxsyulu88tc',100,'POP','2uhw2oYbugGJbn10wipNX5','https://p.scdn.co/mp3-preview/6bff8c1079d87a672d6b9ee5c3c6ca5e7d9ff45b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('xc8f2df92v80mpfhxa08beb1ylflqj0knlu7w5uu7mk7losyrw', 'ww18v7bojq1jqvv71t6tmye4m5f0hy54nyylvggucj1znx7mmg', '0');
-- Justin Bieber
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('atmbdi507bnv5km', 'Justin Bieber', '62@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:62@artist.com', 'atmbdi507bnv5km', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('atmbdi507bnv5km', 'My name is Justin Bieber', 'Justin Bieber');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('n0rdwkvm92k15v7smj97x7iyv3ee7ov104kch7ubekd6enwshi','atmbdi507bnv5km', NULL, 'Justin Bieber Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('hvcqwbqa4i5w7t8ha8ird4tt4fta5ybdo2asi6p64vjscpzdvl','STAY (with Justin Bieber)','atmbdi507bnv5km',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('n0rdwkvm92k15v7smj97x7iyv3ee7ov104kch7ubekd6enwshi', 'hvcqwbqa4i5w7t8ha8ird4tt4fta5ybdo2asi6p64vjscpzdvl', '0');
-- Marshmello
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('gdl5g77j9q6kvvj', 'Marshmello', '63@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:63@artist.com', 'gdl5g77j9q6kvvj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('gdl5g77j9q6kvvj', 'My name is Marshmello', 'Marshmello');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('97othwso5gl2ihd7o0rdi1n85opgwl3r6jwg3wuzsg0nkvynaf','gdl5g77j9q6kvvj', 'https://i.scdn.co/image/ab67616d0000b273f404676577626a87d92cf33f', 'Marshmello Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('73f50dhl7gupff3jypi15rlkufo06rd8n7icitsahukcxkn8rl','El Merengue','gdl5g77j9q6kvvj',100,'POP','51FvjPEGKq2zByeeEQ43V9','https://p.scdn.co/mp3-preview/a933b6e1d6a47e591c13192f2b5e58739d3d5a06?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('97othwso5gl2ihd7o0rdi1n85opgwl3r6jwg3wuzsg0nkvynaf', '73f50dhl7gupff3jypi15rlkufo06rd8n7icitsahukcxkn8rl', '0');
-- Lewis Capaldi
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('euszqzhhgjt1p81', 'Lewis Capaldi', '64@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:64@artist.com', 'euszqzhhgjt1p81', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('euszqzhhgjt1p81', 'My name is Lewis Capaldi', 'Lewis Capaldi');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('zbs6b048c6l9br6goo5cgs70bfnkrqw1bca9qozf5xxbj8ct9g','euszqzhhgjt1p81', 'https://i.scdn.co/image/ab67616d0000b273fc2101e6889d6ce9025f85f2', 'Lewis Capaldi Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('61vgiatvh4uxry70490f6ivtlzpgh8nvodxikg7e3zi66gni0e','Someone You Loved','euszqzhhgjt1p81',100,'POP','7qEHsqek33rTcFNT9PFqLf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('zbs6b048c6l9br6goo5cgs70bfnkrqw1bca9qozf5xxbj8ct9g', '61vgiatvh4uxry70490f6ivtlzpgh8nvodxikg7e3zi66gni0e', '0');
-- Chencho Corleone
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('sipjbxmy3dviaf0', 'Chencho Corleone', '65@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:65@artist.com', 'sipjbxmy3dviaf0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('sipjbxmy3dviaf0', 'My name is Chencho Corleone', 'Chencho Corleone');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('m2u75jqwng927qe32t86z2weq4ixjmaupclmb0xney4qbsoyl5','sipjbxmy3dviaf0', NULL, 'Chencho Corleone Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('jb6tiws6nxxbbsswljvc91w3f52sra0ex9evdi3o5qvl0uv6j5','Me Porto Bonito','sipjbxmy3dviaf0',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('m2u75jqwng927qe32t86z2weq4ixjmaupclmb0xney4qbsoyl5', 'jb6tiws6nxxbbsswljvc91w3f52sra0ex9evdi3o5qvl0uv6j5', '0');
-- Jain
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('hvfubb4ppgn5u4m', 'Jain', '66@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:66@artist.com', 'hvfubb4ppgn5u4m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('hvfubb4ppgn5u4m', 'My name is Jain', 'Jain');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('t9vdv2vv72l603gisxf7ym136bvh13vxjsav4zy4y5vfcuubgu','hvfubb4ppgn5u4m', 'https://i.scdn.co/image/ab67616d0000b27364ba66f8a81c52364e55db50', 'Jain Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('d1d686ddjgamq4ypai2vvg2teomvv7s3pjshpybeeso0d300gy','Makeba','hvfubb4ppgn5u4m',100,'POP','4TNFLwe6DhtR3Wn1JKMqMJ','https://p.scdn.co/mp3-preview/41db29480f9d12734adf491d3b5dd4da1005047c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('t9vdv2vv72l603gisxf7ym136bvh13vxjsav4zy4y5vfcuubgu', 'd1d686ddjgamq4ypai2vvg2teomvv7s3pjshpybeeso0d300gy', '0');
-- Ayparia
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('b9r04lpianbbfgj', 'Ayparia', '67@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:67@artist.com', 'b9r04lpianbbfgj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('b9r04lpianbbfgj', 'My name is Ayparia', 'Ayparia');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('vi6u2j041fk2yxwkxrqcqzr9q7g4o9o9xbu1l3uxuxrapfgw0p','b9r04lpianbbfgj', NULL, 'Ayparia Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('upnagitzk1ed1lz0zrzq6fwkyohn7m77hgshvxdeqollyjok5g','MONTAGEM - FR PUNK','b9r04lpianbbfgj',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('vi6u2j041fk2yxwkxrqcqzr9q7g4o9o9xbu1l3uxuxrapfgw0p', 'upnagitzk1ed1lz0zrzq6fwkyohn7m77hgshvxdeqollyjok5g', '0');
-- Luke Combs
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('bjn7fxp37b3c0z2', 'Luke Combs', '68@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:68@artist.com', 'bjn7fxp37b3c0z2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('bjn7fxp37b3c0z2', 'My name is Luke Combs', 'Luke Combs');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('70r3fm5p0u5cd7ulzpz9evdhkbjgq715kd6c4b80r40fjj0uuf','bjn7fxp37b3c0z2', 'https://i.scdn.co/image/ab67616d0000b273ca650d3a95022e0490434ba1', 'Luke Combs Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('4kkfnr8vdix41r7h6i8oxsj6ajdobhr2yi533rnxztr6h8nea5','Fast Car','bjn7fxp37b3c0z2',100,'POP','1Lo0QY9cvc8sUB2vnIOxDT','https://p.scdn.co/mp3-preview/1dc0426c95058783e0fe1d70c41583ca98317108?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('70r3fm5p0u5cd7ulzpz9evdhkbjgq715kd6c4b80r40fjj0uuf', '4kkfnr8vdix41r7h6i8oxsj6ajdobhr2yi533rnxztr6h8nea5', '0');
-- Doechii
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('5e4gumre1rhusdg', 'Doechii', '69@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:69@artist.com', '5e4gumre1rhusdg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('5e4gumre1rhusdg', 'My name is Doechii', 'Doechii');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('con5ymect4xl1v8m8z4gbnb8j9pbab9s6cgvfezfu2n6i1qv2m','5e4gumre1rhusdg', 'https://i.scdn.co/image/ab67616d0000b2732ee85751f6f503fa9a533eba', 'Doechii Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ca9wosm049s4v052knoqcfbtrxzmhctdpaulpt04mdfugfe1dp','What It Is (Solo Version)','5e4gumre1rhusdg',100,'POP','73RbfOTJIjHzi2pcVHjeHM',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('con5ymect4xl1v8m8z4gbnb8j9pbab9s6cgvfezfu2n6i1qv2m', 'ca9wosm049s4v052knoqcfbtrxzmhctdpaulpt04mdfugfe1dp', '0');
-- Jung Kook
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('3q7wihqlpw9yi8a', 'Jung Kook', '70@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:70@artist.com', '3q7wihqlpw9yi8a', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('3q7wihqlpw9yi8a', 'My name is Jung Kook', 'Jung Kook');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('mn9f9th5nnrdjo0fjqn5vmyxbu9hah7pq8rwts65fnmznhk37j','3q7wihqlpw9yi8a', 'https://i.scdn.co/image/ab67616d0000b273a7f42c375578df426b37638d', 'Jung Kook Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('adxilvyl0urz5ygaz9jcm9m1nj4fdvli0azydasrapfhpmuuth','Still With You','3q7wihqlpw9yi8a',100,'POP','0eFMbKCRw8KByXyWBw8WO7','https://p.scdn.co/mp3-preview/af2a740e10a6956dedd7e7f66fd65d7166e9187f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('mn9f9th5nnrdjo0fjqn5vmyxbu9hah7pq8rwts65fnmznhk37j', 'adxilvyl0urz5ygaz9jcm9m1nj4fdvli0azydasrapfhpmuuth', '0');
-- J. Cole
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('9a4uiv3843kwzir', 'J. Cole', '71@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:71@artist.com', '9a4uiv3843kwzir', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('9a4uiv3843kwzir', 'My name is J. Cole', 'J. Cole');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('cz2oecnol222maqwjq2gvk9e38we5v71reellcoo3evvm4n845','9a4uiv3843kwzir', NULL, 'J. Cole Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('9316i4al1vxgsg9upc1ee10vkrmwlx1vujs638r5dh3eslbtzn','All My Life (feat. J. Cole)','9a4uiv3843kwzir',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('cz2oecnol222maqwjq2gvk9e38we5v71reellcoo3evvm4n845', '9316i4al1vxgsg9upc1ee10vkrmwlx1vujs638r5dh3eslbtzn', '0');
-- Lana Del Rey
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('0zxgxctemfo5wbv', 'Lana Del Rey', '72@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:72@artist.com', '0zxgxctemfo5wbv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('0zxgxctemfo5wbv', 'My name is Lana Del Rey', 'Lana Del Rey');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('8kmfpwblgrw9p5rclf05kedweyy07gieqx8muf4fg03cwf0gie','0zxgxctemfo5wbv', 'https://i.scdn.co/image/ab67616d0000b273aa27708d07f49c82ff0d0dae', 'Lana Del Rey Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('4itbfboer8fjl597w8ftt2lhabdeejyb8rmyk23m9e600qmdvd','Say Yes To Heaven','0zxgxctemfo5wbv',100,'POP','6GGtHZgBycCgGBUhZo81xe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('8kmfpwblgrw9p5rclf05kedweyy07gieqx8muf4fg03cwf0gie', '4itbfboer8fjl597w8ftt2lhabdeejyb8rmyk23m9e600qmdvd', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('e9twn7up2i6i6k5n9f2dalqi62u2egzpvuw2o5ayhmn0wvtvuk','Summertime Sadness','0zxgxctemfo5wbv',100,'POP','1Ist6PR2BZR3n2z2Y5R6S1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('8kmfpwblgrw9p5rclf05kedweyy07gieqx8muf4fg03cwf0gie', 'e9twn7up2i6i6k5n9f2dalqi62u2egzpvuw2o5ayhmn0wvtvuk', '1');
-- BTS
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('wl53werzs72prj8', 'BTS', '73@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:73@artist.com', 'wl53werzs72prj8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('wl53werzs72prj8', 'My name is BTS', 'BTS');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('xbxjsro50qo213ujirwuk7io4x2915c1zwvn70wgmf317uyomo','wl53werzs72prj8', 'https://i.scdn.co/image/ab67616d0000b2738a701e76e8845928f6cd81c8', 'BTS Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('r9heh6itacfn82f58g7cy46i9ql85mapqc8gei3puh4mjp9sh3','Take Two','wl53werzs72prj8',100,'POP','5IAESfJjmOYu7cHyX557kz','https://p.scdn.co/mp3-preview/ef43da30a06fcad16898e9fff1cadd0ccf953fc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('xbxjsro50qo213ujirwuk7io4x2915c1zwvn70wgmf317uyomo', 'r9heh6itacfn82f58g7cy46i9ql85mapqc8gei3puh4mjp9sh3', '0');
-- Playlists
INSERT INTO `playlist` (`id`, `name`, `created_at`, `creator_id`) VALUES ('n67h6gt1kpz9nht6ucvub7o6tshj36b9jpi9y47k70mglf2ba7', 'Playlist 0', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('tq16z6lsomplw1kkw2gsmbqp5bouhyehv56n5xu4r86nfjsybf', 'n67h6gt1kpz9nht6ucvub7o6tshj36b9jpi9y47k70mglf2ba7', 0);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('3g7ndv0xxjrdps1swo8cpj01t8pwcbouhydgxka8hrjx82mygt', 'n67h6gt1kpz9nht6ucvub7o6tshj36b9jpi9y47k70mglf2ba7', 1);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('rdxyxewcltfkc726c7nw79ws16f635atoynsi3hh3s82q3zens', 'n67h6gt1kpz9nht6ucvub7o6tshj36b9jpi9y47k70mglf2ba7', 2);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('jb6tiws6nxxbbsswljvc91w3f52sra0ex9evdi3o5qvl0uv6j5', 'n67h6gt1kpz9nht6ucvub7o6tshj36b9jpi9y47k70mglf2ba7', 3);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('qcdymb02zdvqwytkvmti34of9nnra65t2r94bp5s7d3n7f2rw9', 'n67h6gt1kpz9nht6ucvub7o6tshj36b9jpi9y47k70mglf2ba7', 4);
INSERT INTO `playlist` (`id`, `name`, `created_at`, `creator_id`) VALUES ('ca1xcupbf0nxajzykv22opkriekxa9mkbhb9kylmxdtz0n8ics', 'Playlist 1', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('rdxyxewcltfkc726c7nw79ws16f635atoynsi3hh3s82q3zens', 'ca1xcupbf0nxajzykv22opkriekxa9mkbhb9kylmxdtz0n8ics', 0);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('5rg29x8vi76dx5brc0v1lokz2ute2n488rd51m91rlj4bq6j63', 'ca1xcupbf0nxajzykv22opkriekxa9mkbhb9kylmxdtz0n8ics', 3);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('ww18v7bojq1jqvv71t6tmye4m5f0hy54nyylvggucj1znx7mmg', 'ca1xcupbf0nxajzykv22opkriekxa9mkbhb9kylmxdtz0n8ics', 1);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('1wmuqcd2lqtcysx7w07jy6rjz4odcvkpk041ojnkkwim1o7knw', 'ca1xcupbf0nxajzykv22opkriekxa9mkbhb9kylmxdtz0n8ics', 2);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('ca9wosm049s4v052knoqcfbtrxzmhctdpaulpt04mdfugfe1dp', 'ca1xcupbf0nxajzykv22opkriekxa9mkbhb9kylmxdtz0n8ics', 4);
-- User Likes
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', '810zbg29w1zubgip8tep03eppoy7oy748s1tuio5w3g1abngb4');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'qzf6mrwdp4rz3tf1hq5rx86dwx3kqkqhl5xppiklk9yw7agq3b');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'xg9ni4m7scz3ko9xmj7cfjw37fcxenam07m82o9rnx4swpt6jr');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'z08822p7sj6bs1f2585uozapbl8aevl98p2te1tkl5osun9l41');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'a637veqxgnn9csxox0n22bgvawnleemyocpve7cq402lp6nxl5');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', '2gplo01as7xmukqtvt37426vcufaslsz1mp1pkaupims5lytve');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'ae1fazjet1k2luq7eka58guhokomxhy7dknghcqpzeul482r0m');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'upnagitzk1ed1lz0zrzq6fwkyohn7m77hgshvxdeqollyjok5g');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'mlyg9ouqy99wipf0lcybzor3780i0k1ec1yvbwumjq70ot1bjv');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', '13ocvqi55djujc3jmnnc1cne54yg15ngwkdj1qxm4teh6b9g4w');
-- User Song Recommendations
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('w4ku7uvl85qlrqb9oe4pinvn2csud4iw0oo9p7o0f3dd68s93l', 'icqlt67n2fd7p34', '57l0g63fqoi6nkidl695dt44fa4ky8aqy7po9hy21xvpm5dk9b', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('ouo7cqgm158z9detdhkotshclb57b8jwikg5t5uzgmb6l7fg88', 'icqlt67n2fd7p34', 'ictd2pugfgwt0sm1pjbu1e412t576sa35bqc0uxkn7zuhzkcxk', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('0x6yitnbfuf8is10v8k7m18hq669qoxqrgx8s5paofd6ane45q', 'icqlt67n2fd7p34', 'pcz0r1qaw36uq3jqqgorh1j7f055i44x64gn1n1uajqx8wkkge', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('88u7ofda08xe1anrj0gewewjxynt4auzcdia51eotmlj8iojww', 'icqlt67n2fd7p34', '4xhhvvrdsii2ijr17qjlzgbhlyl8t7iv82rpan2zvm8xthxj63', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('vt38cmgtpuclrtf2mfm3fyvcsbflsr5t6o7uzl596577zapm64', 'icqlt67n2fd7p34', 'n5hc2pv72yse4f0l3ss1wtcyskuwse1cum6ungsjw7xbb722kf', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('ey18fegducf6qrvlqr0ktad2l6yy55jtv0bftr9tj87hjhdl1e', 'icqlt67n2fd7p34', 'lc5ol9xxdm8illqlr48cnpbez2b8jx6nnjmpny59r0ptz57fjd', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('khmuxbws8rax2s34fozd5yo8qji0mnov9avqdhdkbdogdggh14', 'icqlt67n2fd7p34', '5rg29x8vi76dx5brc0v1lokz2ute2n488rd51m91rlj4bq6j63', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('yc8feds3l6ll031g8vgm02hecw060z2fv770qvvqwuwieip2on', 'icqlt67n2fd7p34', 'jb7x3aw7htcu5rxlovqp12khiphmrzigqhhlbjpnjfelw3jdma', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('fww5e45c45y00cxjgc9l88rn21yv4kfw8pcwpztavvm9ftkqwy', 'icqlt67n2fd7p34', 'z2wludjjznoseuw4g1r0mqjea4aoy9uaot6zo9zouzd0cn8wj8', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('iyiubyufrnvy5c3c8dqw6azemxpwv9supj96no905ltbkfgapc', 'icqlt67n2fd7p34', '4kkfnr8vdix41r7h6i8oxsj6ajdobhr2yi533rnxztr6h8nea5', '2023-11-17 17:00:08.000');
