-- Latto
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('5r2ol3jp56tvp03', 'Latto', '0@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:0@artist.com', '5r2ol3jp56tvp03', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('5r2ol3jp56tvp03', 'My name is Latto', 'Latto');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('qup8t8fyq7nsx568mtkxqmxi01m1ydgbml6ky16xtt52867a80','5r2ol3jp56tvp03',NULL, 'Latto Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('uvf9fopnnos1kf1cx4iahgzo11181ja0brzc2fgh2fh3mrjo7p','Seven (feat. Latto) (Explicit Ver.)','5r2ol3jp56tvp03',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('qup8t8fyq7nsx568mtkxqmxi01m1ydgbml6ky16xtt52867a80', 'uvf9fopnnos1kf1cx4iahgzo11181ja0brzc2fgh2fh3mrjo7p', '0');
-- Myke Towers
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('pzus24nbmclx7ew', 'Myke Towers', '1@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:1@artist.com', 'pzus24nbmclx7ew', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('pzus24nbmclx7ew', 'My name is Myke Towers', 'Myke Towers');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('xu0ppnmh0l2m93xr3l5fjimbfgxzov7dbmixmsc26fa3egcejd','pzus24nbmclx7ew',NULL, 'Myke Towers Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('k2v4noidw7z33qlpnwl9fa4m8vcynwigxq83uzldbup045w242','LALA','pzus24nbmclx7ew',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('xu0ppnmh0l2m93xr3l5fjimbfgxzov7dbmixmsc26fa3egcejd', 'k2v4noidw7z33qlpnwl9fa4m8vcynwigxq83uzldbup045w242', '0');
-- Olivia Rodrigo
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('g2h869capadukr0', 'Olivia Rodrigo', '2@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:2@artist.com', 'g2h869capadukr0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('g2h869capadukr0', 'My name is Olivia Rodrigo', 'Olivia Rodrigo');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('wu0fdett9br5klkboqdpqlb5fvmhy2qvvxicfv8pyliiqpa16o','g2h869capadukr0',NULL, 'Olivia Rodrigo Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('teg7rsfsdyix51mfams67i5tmixy7rzu86m7itue05z3cqe7ce','vampire','g2h869capadukr0',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('wu0fdett9br5klkboqdpqlb5fvmhy2qvvxicfv8pyliiqpa16o', 'teg7rsfsdyix51mfams67i5tmixy7rzu86m7itue05z3cqe7ce', '0');
-- Taylor Swift
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('fjfuoiwbcn4j3y7', 'Taylor Swift', '3@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:3@artist.com', 'fjfuoiwbcn4j3y7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('fjfuoiwbcn4j3y7', 'My name is Taylor Swift', 'Taylor Swift');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('oisxtj5b4p78nlgugd2bcsrvp7gnneze77lm1uqmho6rq0eovd','fjfuoiwbcn4j3y7',NULL, 'Taylor Swift Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('3q5753bjorfpv3d0ugjlbcoba07q3xye0e6y7pie6dnzm9h5xi','Cruel Summer','fjfuoiwbcn4j3y7',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('oisxtj5b4p78nlgugd2bcsrvp7gnneze77lm1uqmho6rq0eovd', '3q5753bjorfpv3d0ugjlbcoba07q3xye0e6y7pie6dnzm9h5xi', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('dj08dxasjyl1wy5qlhu6iej371h915a3k33vzsyzi7o17ljbbu','I Can See You (Taylor���s Version) (From The ','fjfuoiwbcn4j3y7',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('oisxtj5b4p78nlgugd2bcsrvp7gnneze77lm1uqmho6rq0eovd', 'dj08dxasjyl1wy5qlhu6iej371h915a3k33vzsyzi7o17ljbbu', '1');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('b3tywwx9w925dxs5syop6ad0jx25n9pchwna7stoy2a16pdcco','Anti-Hero','fjfuoiwbcn4j3y7',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('oisxtj5b4p78nlgugd2bcsrvp7gnneze77lm1uqmho6rq0eovd', 'b3tywwx9w925dxs5syop6ad0jx25n9pchwna7stoy2a16pdcco', '2');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('fgqmx78mzqu9bnx86rtzrxo8sgdk5ljrewrv2xi7o0vfqkm2wm','Blank Space','fjfuoiwbcn4j3y7',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('oisxtj5b4p78nlgugd2bcsrvp7gnneze77lm1uqmho6rq0eovd', 'fgqmx78mzqu9bnx86rtzrxo8sgdk5ljrewrv2xi7o0vfqkm2wm', '3');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('r8bm36y7g3k37cwt7pod8ymya2rwyr9xms9o6wlt9w0s4s73f9','Style','fjfuoiwbcn4j3y7',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('oisxtj5b4p78nlgugd2bcsrvp7gnneze77lm1uqmho6rq0eovd', 'r8bm36y7g3k37cwt7pod8ymya2rwyr9xms9o6wlt9w0s4s73f9', '4');
-- Bad Bunny
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('g23br5kdzncsbnr', 'Bad Bunny', '4@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:4@artist.com', 'g23br5kdzncsbnr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('g23br5kdzncsbnr', 'My name is Bad Bunny', 'Bad Bunny');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('romfcuoz1hirvnj5jwaqp0q7kdd2ti0xz8049tym43kten8moi','g23br5kdzncsbnr',NULL, 'Bad Bunny Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('urbk7n6vsv08fpyy7dp3sxgstik7bd8hi2vd60281jbaz541p7','WHERE SHE GOES','g23br5kdzncsbnr',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('romfcuoz1hirvnj5jwaqp0q7kdd2ti0xz8049tym43kten8moi', 'urbk7n6vsv08fpyy7dp3sxgstik7bd8hi2vd60281jbaz541p7', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('sby2b94m7s55248xyio5q1905b50lck657nkl0zu5k0o442xlc','un x100to','g23br5kdzncsbnr',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('romfcuoz1hirvnj5jwaqp0q7kdd2ti0xz8049tym43kten8moi', 'sby2b94m7s55248xyio5q1905b50lck657nkl0zu5k0o442xlc', '1');
-- Dave
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('9uk7fv25sjmgrll', 'Dave', '5@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:5@artist.com', '9uk7fv25sjmgrll', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('9uk7fv25sjmgrll', 'My name is Dave', 'Dave');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('23bn9scsbu7u22verxw28id9z1j8wh8hpjgjea3uyyh56l41q3','9uk7fv25sjmgrll',NULL, 'Dave Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('oxnf87wlfz1rioj720qzw2cyck9950k6is1a7h49aj8kp6nwxk','Sprinter','9uk7fv25sjmgrll',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('23bn9scsbu7u22verxw28id9z1j8wh8hpjgjea3uyyh56l41q3', 'oxnf87wlfz1rioj720qzw2cyck9950k6is1a7h49aj8kp6nwxk', '0');
-- Eslabon Armado
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('o2p4wosqqjpv7vz', 'Eslabon Armado', '6@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:6@artist.com', 'o2p4wosqqjpv7vz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('o2p4wosqqjpv7vz', 'My name is Eslabon Armado', 'Eslabon Armado');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('468d34k14q3rzl4rbnamjctbsfy4lhxge7zig4icxy4g99ytlm','o2p4wosqqjpv7vz',NULL, 'Eslabon Armado Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('oaxqphkwz8vw1g40d6qopdz9cz9a10fr4qt2ksrrrvr9kvls89','Ella Baila Sola','o2p4wosqqjpv7vz',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('468d34k14q3rzl4rbnamjctbsfy4lhxge7zig4icxy4g99ytlm', 'oaxqphkwz8vw1g40d6qopdz9cz9a10fr4qt2ksrrrvr9kvls89', '0');
-- Quevedo
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('7cpn07qk1rquh6m', 'Quevedo', '7@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:7@artist.com', '7cpn07qk1rquh6m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('7cpn07qk1rquh6m', 'My name is Quevedo', 'Quevedo');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('qmeitel8oy4nd3vc0ry8fws1md7o7fuwl21w5b34k046im0mo3','7cpn07qk1rquh6m',NULL, 'Quevedo Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('xsfgzh99f1f40oz426jowmqpe7d96wwe2ge9wucemhcp9987ys','Columbia','7cpn07qk1rquh6m',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('qmeitel8oy4nd3vc0ry8fws1md7o7fuwl21w5b34k046im0mo3', 'xsfgzh99f1f40oz426jowmqpe7d96wwe2ge9wucemhcp9987ys', '0');
-- Gunna
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('h1zps9zejei43py', 'Gunna', '8@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:8@artist.com', 'h1zps9zejei43py', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('h1zps9zejei43py', 'My name is Gunna', 'Gunna');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('3haqh9foh4xyrb8p7jitxw9g7xvlezml6npz5ssyuc7d36cf89','h1zps9zejei43py',NULL, 'Gunna Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('kjaww1sa5a6x26xhyv9w42lpt2hntfu4s3kdax4qz4d9eqaodv','fukumean','h1zps9zejei43py',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('3haqh9foh4xyrb8p7jitxw9g7xvlezml6npz5ssyuc7d36cf89', 'kjaww1sa5a6x26xhyv9w42lpt2hntfu4s3kdax4qz4d9eqaodv', '0');
-- Peso Pluma
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('8mz0smi62jr1cfc', 'Peso Pluma', '9@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:9@artist.com', '8mz0smi62jr1cfc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('8mz0smi62jr1cfc', 'My name is Peso Pluma', 'Peso Pluma');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ivbeuksgdswx8v0qp25fh3yo99rpnx0ty3c8wbt7009pjd4e00','8mz0smi62jr1cfc',NULL, 'Peso Pluma Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('5xlltmj3xkadrfem48akfjif3hdbme6n2z68036uz9qgg8d1w4','La Bebe - Remix','8mz0smi62jr1cfc',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ivbeuksgdswx8v0qp25fh3yo99rpnx0ty3c8wbt7009pjd4e00', '5xlltmj3xkadrfem48akfjif3hdbme6n2z68036uz9qgg8d1w4', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('uuyo2ydok0mw4kldawl1azua0lrnrptnyl8y7pr9d5xkc3civ8','TULUM','8mz0smi62jr1cfc',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ivbeuksgdswx8v0qp25fh3yo99rpnx0ty3c8wbt7009pjd4e00', 'uuyo2ydok0mw4kldawl1azua0lrnrptnyl8y7pr9d5xkc3civ8', '1');
-- NewJeans
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('8dwlcnly6n2mo7l', 'NewJeans', '10@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:10@artist.com', '8dwlcnly6n2mo7l', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('8dwlcnly6n2mo7l', 'My name is NewJeans', 'NewJeans');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ux1slkmz1sx8cs5poxvio24teuj1fj5s9gzmj9zur9b6br0fyx','8dwlcnly6n2mo7l',NULL, 'NewJeans Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('hti8td9amk4y2ahpgdsonbbupfchkupm69zvruxc2h92ff3mhm','Super Shy','8dwlcnly6n2mo7l',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ux1slkmz1sx8cs5poxvio24teuj1fj5s9gzmj9zur9b6br0fyx', 'hti8td9amk4y2ahpgdsonbbupfchkupm69zvruxc2h92ff3mhm', '0');
-- Miley Cyrus
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('dbkce1jij381sk8', 'Miley Cyrus', '11@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:11@artist.com', 'dbkce1jij381sk8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('dbkce1jij381sk8', 'My name is Miley Cyrus', 'Miley Cyrus');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('6umtrqzdsk2p3obbu6qv1sanh0pkp138486x5n4em422gg5ah6','dbkce1jij381sk8',NULL, 'Miley Cyrus Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('o7lhk2qcqxypek5fwi4n1ru1lre4gbwqznk5f9fwmbc624ixe5','Flowers','dbkce1jij381sk8',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('6umtrqzdsk2p3obbu6qv1sanh0pkp138486x5n4em422gg5ah6', 'o7lhk2qcqxypek5fwi4n1ru1lre4gbwqznk5f9fwmbc624ixe5', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('nzfasmmsjhptmu1ipyqs6l25ydwdbsru7k6gozcu6wpnku6f0b','Angels Like You','dbkce1jij381sk8',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('6umtrqzdsk2p3obbu6qv1sanh0pkp138486x5n4em422gg5ah6', 'nzfasmmsjhptmu1ipyqs6l25ydwdbsru7k6gozcu6wpnku6f0b', '1');
-- David Kushner
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('axv5i33b57ydhl0', 'David Kushner', '12@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:12@artist.com', 'axv5i33b57ydhl0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('axv5i33b57ydhl0', 'My name is David Kushner', 'David Kushner');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('2yap57xpwyw55i68hml3rovasyp9a60hlrrdhz7gvqd4bsfgz5','axv5i33b57ydhl0',NULL, 'David Kushner Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('vc2sad1ynuefglfhwp3g7uec92352uflupbjc0ibs8p29oge7j','Daylight','axv5i33b57ydhl0',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('2yap57xpwyw55i68hml3rovasyp9a60hlrrdhz7gvqd4bsfgz5', 'vc2sad1ynuefglfhwp3g7uec92352uflupbjc0ibs8p29oge7j', '0');
-- Harry Styles
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('jdc4ct2gfp04p83', 'Harry Styles', '13@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:13@artist.com', 'jdc4ct2gfp04p83', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('jdc4ct2gfp04p83', 'My name is Harry Styles', 'Harry Styles');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('a7a0t8hi7kq6wd5gj21etu61cm8cp4wvt5pvcwp4k7izs3czco','jdc4ct2gfp04p83',NULL, 'Harry Styles Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('cj1mqvrr28eozbm8x1j93qz3275lh0rd1qcvees28v7enpuel1','As It Was','jdc4ct2gfp04p83',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('a7a0t8hi7kq6wd5gj21etu61cm8cp4wvt5pvcwp4k7izs3czco', 'cj1mqvrr28eozbm8x1j93qz3275lh0rd1qcvees28v7enpuel1', '0');
-- SZA
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('77tzquktaneu3zk', 'SZA', '14@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:14@artist.com', '77tzquktaneu3zk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('77tzquktaneu3zk', 'My name is SZA', 'SZA');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('3wm4axi3uzio2yopcfg0laco83y0jn4rgnrq2onr0e6mdb9882','77tzquktaneu3zk',NULL, 'SZA Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('43nux21ge1789t34g4t5776xb6ccr39rh67nacwebnbnrx6arg','Kill Bill','77tzquktaneu3zk',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('3wm4axi3uzio2yopcfg0laco83y0jn4rgnrq2onr0e6mdb9882', '43nux21ge1789t34g4t5776xb6ccr39rh67nacwebnbnrx6arg', '0');
-- Fifty Fifty
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('oxuamwa5q5gow5r', 'Fifty Fifty', '15@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:15@artist.com', 'oxuamwa5q5gow5r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('oxuamwa5q5gow5r', 'My name is Fifty Fifty', 'Fifty Fifty');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('gs3fmjbrnynxua3bnlmp8cnerxw13bzmaqc755zv97yf2l2ywh','oxuamwa5q5gow5r',NULL, 'Fifty Fifty Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('6no5ruwwo9h6qyvmhvvwdhzc592epqg2fjb2x3erzoyog9m9cv','Cupid - Twin Ver.','oxuamwa5q5gow5r',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('gs3fmjbrnynxua3bnlmp8cnerxw13bzmaqc755zv97yf2l2ywh', '6no5ruwwo9h6qyvmhvvwdhzc592epqg2fjb2x3erzoyog9m9cv', '0');
-- Billie Eilish
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('6b3iq820g8aquov', 'Billie Eilish', '16@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:16@artist.com', '6b3iq820g8aquov', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('6b3iq820g8aquov', 'My name is Billie Eilish', 'Billie Eilish');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('5tmtv0vzgsetybg1jvih8kjxu7or8tqve9v0b2xoyt88rkfk2e','6b3iq820g8aquov',NULL, 'Billie Eilish Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('8nyc9yxt9bu8n7xuni14dx4jiu02mmpd1l424baqi5hqhes9l0','What Was I Made For? [From The Motion Picture "Barbie"]','6b3iq820g8aquov',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('5tmtv0vzgsetybg1jvih8kjxu7or8tqve9v0b2xoyt88rkfk2e', '8nyc9yxt9bu8n7xuni14dx4jiu02mmpd1l424baqi5hqhes9l0', '0');
-- Feid
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('urxzx5h5t9f8f55', 'Feid', '17@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:17@artist.com', 'urxzx5h5t9f8f55', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('urxzx5h5t9f8f55', 'My name is Feid', 'Feid');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('gpg8s3leg2db7y7mcdip18e2yvabmsptjxf7mzynldh33cpzld','urxzx5h5t9f8f55',NULL, 'Feid Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('296o14bztvxyjz8kom9lwrtnndwchrpikpu5yy3tcys21qjiep','Classy 101','urxzx5h5t9f8f55',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('gpg8s3leg2db7y7mcdip18e2yvabmsptjxf7mzynldh33cpzld', '296o14bztvxyjz8kom9lwrtnndwchrpikpu5yy3tcys21qjiep', '0');
-- Jimin
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('kcizawy4ekzxrf5', 'Jimin', '18@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:18@artist.com', 'kcizawy4ekzxrf5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('kcizawy4ekzxrf5', 'My name is Jimin', 'Jimin');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('5o5tvf9sho4qal79wql53s3nct1vvanovoghynu8tk3umn5j42','kcizawy4ekzxrf5',NULL, 'Jimin Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('2kgs6il46fxcblxnpgnrbolsxwl4rkms7f7dy3n3lhlr1e1mc3','Like Crazy','kcizawy4ekzxrf5',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('5o5tvf9sho4qal79wql53s3nct1vvanovoghynu8tk3umn5j42', '2kgs6il46fxcblxnpgnrbolsxwl4rkms7f7dy3n3lhlr1e1mc3', '0');
-- Gabito Ballesteros
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('eghwdr7vfjas54t', 'Gabito Ballesteros', '19@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:19@artist.com', 'eghwdr7vfjas54t', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('eghwdr7vfjas54t', 'My name is Gabito Ballesteros', 'Gabito Ballesteros');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('8m74vwfrj6hnescqgji1mh4qitz10d09wfgm2kv0udg9r0y2sd','eghwdr7vfjas54t',NULL, 'Gabito Ballesteros Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('xua409iaosla0gsom6mbmd0cilgnlmhwox8h2uwbnaqfrgzxgp','LADY GAGA','eghwdr7vfjas54t',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('8m74vwfrj6hnescqgji1mh4qitz10d09wfgm2kv0udg9r0y2sd', 'xua409iaosla0gsom6mbmd0cilgnlmhwox8h2uwbnaqfrgzxgp', '0');
-- Arctic Monkeys
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('ychnfgyfyz42624', 'Arctic Monkeys', '20@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:20@artist.com', 'ychnfgyfyz42624', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ychnfgyfyz42624', 'My name is Arctic Monkeys', 'Arctic Monkeys');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('q76ip6o8ir82jzc6ssunraq3v2ey0sr2ezrmew5utspr6n0b0g','ychnfgyfyz42624',NULL, 'Arctic Monkeys Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('4gy6ezd7r4xyih7w6soveo2v7zkgs4rye45wruvgbymuvtgz1b','I Wanna Be Yours','ychnfgyfyz42624',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('q76ip6o8ir82jzc6ssunraq3v2ey0sr2ezrmew5utspr6n0b0g', '4gy6ezd7r4xyih7w6soveo2v7zkgs4rye45wruvgbymuvtgz1b', '0');
-- Bizarrap
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('txiqqp1z9t6d3st', 'Bizarrap', '21@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:21@artist.com', 'txiqqp1z9t6d3st', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('txiqqp1z9t6d3st', 'My name is Bizarrap', 'Bizarrap');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('mcdhkn3fizqgs12472j2rnhqoom5d1wwfl4yn25z14gv70eve7','txiqqp1z9t6d3st',NULL, 'Bizarrap Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('65dlz7cnjv3islplf8l113e2r4nmk8pxrq5i3pw28x8c8uyt7j','Peso Pluma: Bzrp Music Sessions, Vol. 55','txiqqp1z9t6d3st',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('mcdhkn3fizqgs12472j2rnhqoom5d1wwfl4yn25z14gv70eve7', '65dlz7cnjv3islplf8l113e2r4nmk8pxrq5i3pw28x8c8uyt7j', '0');
-- The Weeknd
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('ngyp2c9hhl2dfp8', 'The Weeknd', '22@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:22@artist.com', 'ngyp2c9hhl2dfp8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ngyp2c9hhl2dfp8', 'My name is The Weeknd', 'The Weeknd');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('wdgca1xe812lnhiida2lq8pz7jji5nf8bvxe375rm9tjk34445','ngyp2c9hhl2dfp8',NULL, 'The Weeknd Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('jcgf1d1as27rxjkxpq2f1xhcsbkqqt0htvs56105alo1xzefpm','Popular (with Playboi Carti & Madonna) - The Idol Vol. 1 (Music from the HBO Original Series)','ngyp2c9hhl2dfp8',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('wdgca1xe812lnhiida2lq8pz7jji5nf8bvxe375rm9tjk34445', 'jcgf1d1as27rxjkxpq2f1xhcsbkqqt0htvs56105alo1xzefpm', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('dfcljmbuywiz4tpdl9v9iidasl9qof8lhedhkseszb90n2dhzh','Creepin','ngyp2c9hhl2dfp8',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('wdgca1xe812lnhiida2lq8pz7jji5nf8bvxe375rm9tjk34445', 'dfcljmbuywiz4tpdl9v9iidasl9qof8lhedhkseszb90n2dhzh', '1');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('9p0sa0771633g3su7kttzgxvr8wd7glfbc57hnv7b5nm9ppr20','Die For You','ngyp2c9hhl2dfp8',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('wdgca1xe812lnhiida2lq8pz7jji5nf8bvxe375rm9tjk34445', '9p0sa0771633g3su7kttzgxvr8wd7glfbc57hnv7b5nm9ppr20', '2');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('9plisskxarqf51nof14mak4tl2a1u942vj6mkd1ojqchkakoa7','Starboy','ngyp2c9hhl2dfp8',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('wdgca1xe812lnhiida2lq8pz7jji5nf8bvxe375rm9tjk34445', '9plisskxarqf51nof14mak4tl2a1u942vj6mkd1ojqchkakoa7', '3');
-- Fuerza Regida
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('788qdn8wwe50z3g', 'Fuerza Regida', '23@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:23@artist.com', '788qdn8wwe50z3g', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('788qdn8wwe50z3g', 'My name is Fuerza Regida', 'Fuerza Regida');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('tu5wlg6uwpg5d0ojo3nn4u8w9dyo3zylfbsype5vmmnt6vdjlk','788qdn8wwe50z3g',NULL, 'Fuerza Regida Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('qbbc4yrxz62yzyxnx0x25u34qepqoqhzeu7njt8y7af86qw76g','SABOR FRESA','788qdn8wwe50z3g',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('tu5wlg6uwpg5d0ojo3nn4u8w9dyo3zylfbsype5vmmnt6vdjlk', 'qbbc4yrxz62yzyxnx0x25u34qepqoqhzeu7njt8y7af86qw76g', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('ywpx71wo5va22ljv0l0652k03hmiun9jxqut2mvbaknscu6q9f','TQM','788qdn8wwe50z3g',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('tu5wlg6uwpg5d0ojo3nn4u8w9dyo3zylfbsype5vmmnt6vdjlk', 'ywpx71wo5va22ljv0l0652k03hmiun9jxqut2mvbaknscu6q9f', '1');
-- R��ma
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('35xs4nu2tdtimha', 'R��ma', '24@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:24@artist.com', '35xs4nu2tdtimha', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('35xs4nu2tdtimha', 'My name is R��ma', 'R��ma');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('5zc5q9ftp6mjx5752ffml5a03rkil11ny7zb8t48zt22p842sd','35xs4nu2tdtimha',NULL, 'R��ma Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('0h6vcn68yc08zuu9kbiutaf50knl6x2d55rk75q7rkk0gnewag','Calm Down (with Selena Gomez)','35xs4nu2tdtimha',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('5zc5q9ftp6mjx5752ffml5a03rkil11ny7zb8t48zt22p842sd', '0h6vcn68yc08zuu9kbiutaf50knl6x2d55rk75q7rkk0gnewag', '0');
-- Tainy
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('8mez6vvwpi6xjcz', 'Tainy', '25@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:25@artist.com', '8mez6vvwpi6xjcz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('8mez6vvwpi6xjcz', 'My name is Tainy', 'Tainy');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('5hqw1rzoxwvwopfyi2totu9u2151plcvsz86xs5xb6qsrno07f','8mez6vvwpi6xjcz',NULL, 'Tainy Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('ztq7doc1qgwac2hrfbkg8i5haxbg9bz3yjbpfgg9nbmedjdvmg','MOJABI GHOST','8mez6vvwpi6xjcz',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('5hqw1rzoxwvwopfyi2totu9u2151plcvsz86xs5xb6qsrno07f', 'ztq7doc1qgwac2hrfbkg8i5haxbg9bz3yjbpfgg9nbmedjdvmg', '0');
-- Morgan Wallen
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('zr5jvykwet3gowp', 'Morgan Wallen', '26@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:26@artist.com', 'zr5jvykwet3gowp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('zr5jvykwet3gowp', 'My name is Morgan Wallen', 'Morgan Wallen');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('mqxg1du6osdhbcg0i4130xqeh7gqvv5kt9lvj5w129k1zlyh5g','zr5jvykwet3gowp',NULL, 'Morgan Wallen Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('npudd2hhqvhndiee96hyem3fm8m7ddprcs6orgmu5os08asf62','Last Night','zr5jvykwet3gowp',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('mqxg1du6osdhbcg0i4130xqeh7gqvv5kt9lvj5w129k1zlyh5g', 'npudd2hhqvhndiee96hyem3fm8m7ddprcs6orgmu5os08asf62', '0');
-- Dua Lipa
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('bb20y685uoai7bq', 'Dua Lipa', '27@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:27@artist.com', 'bb20y685uoai7bq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('bb20y685uoai7bq', 'My name is Dua Lipa', 'Dua Lipa');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('e693brim02senr26lvfe0ba6u0smpiij027ehsmfkjhfawu15r','bb20y685uoai7bq',NULL, 'Dua Lipa Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('j80p6yupb2rvzuyp6nqd7hyy75zqgs7dwq349chfm5p66yyfh1','Dance The Night (From Barbie The Album)','bb20y685uoai7bq',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('e693brim02senr26lvfe0ba6u0smpiij027ehsmfkjhfawu15r', 'j80p6yupb2rvzuyp6nqd7hyy75zqgs7dwq349chfm5p66yyfh1', '0');
-- Troye Sivan
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('sqbu87vjlgck7pl', 'Troye Sivan', '28@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:28@artist.com', 'sqbu87vjlgck7pl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('sqbu87vjlgck7pl', 'My name is Troye Sivan', 'Troye Sivan');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('mfnuhj1y4llunciyq1624civ924o0bdxiq9j32l0vlhn41wg9t','sqbu87vjlgck7pl',NULL, 'Troye Sivan Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('c27a6ec446xe22nl7ha907x15sf9hx25eb83q26z19vfee38pu','Rush','sqbu87vjlgck7pl',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('mfnuhj1y4llunciyq1624civ924o0bdxiq9j32l0vlhn41wg9t', 'c27a6ec446xe22nl7ha907x15sf9hx25eb83q26z19vfee38pu', '0');
-- Karol G
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('z45zft95p65wzx0', 'Karol G', '29@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:29@artist.com', 'z45zft95p65wzx0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('z45zft95p65wzx0', 'My name is Karol G', 'Karol G');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('zpmce00sj1wmk40anh3icspsswb2oz40ohiqnxoc8ui1wdb3y4','z45zft95p65wzx0',NULL, 'Karol G Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('ekgvos637t1b02coegkjmhqho3rryzmsxyjd88xbmuj2pqjh84','TQG','z45zft95p65wzx0',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('zpmce00sj1wmk40anh3icspsswb2oz40ohiqnxoc8ui1wdb3y4', 'ekgvos637t1b02coegkjmhqho3rryzmsxyjd88xbmuj2pqjh84', '0');
-- Big One
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('ox6fstkr1hi7rs2', 'Big One', '30@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:30@artist.com', 'ox6fstkr1hi7rs2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ox6fstkr1hi7rs2', 'My name is Big One', 'Big One');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('xgl5cd3u68ujeax8iruk5b21fm9fwm1kcts19293i62f2xttpw','ox6fstkr1hi7rs2',NULL, 'Big One Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('ek04doya7k0edzj5h7srqxge5be8tcywihm7a3gfnrswv8yymg','Los del Espacio','ox6fstkr1hi7rs2',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('xgl5cd3u68ujeax8iruk5b21fm9fwm1kcts19293i62f2xttpw', 'ek04doya7k0edzj5h7srqxge5be8tcywihm7a3gfnrswv8yymg', '0');
-- Yahritza Y Su Esencia
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('5jr5ytrlsmzn9bt', 'Yahritza Y Su Esencia', '31@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:31@artist.com', '5jr5ytrlsmzn9bt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('5jr5ytrlsmzn9bt', 'My name is Yahritza Y Su Esencia', 'Yahritza Y Su Esencia');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('af7fb6bb0c45tlo2o45y03sqrd7kt831tpydsg5f6j62mv1k3w','5jr5ytrlsmzn9bt',NULL, 'Yahritza Y Su Esencia Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('p86lelv7znzftpzwh03jaw1qd9y6f4wjqpa0ba386bbz278vgs','Fr��gil (feat. Grupo Front','5jr5ytrlsmzn9bt',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('af7fb6bb0c45tlo2o45y03sqrd7kt831tpydsg5f6j62mv1k3w', 'p86lelv7znzftpzwh03jaw1qd9y6f4wjqpa0ba386bbz278vgs', '0');
-- Junior H
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('v2jbww5iv7w824y', 'Junior H', '32@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:32@artist.com', 'v2jbww5iv7w824y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('v2jbww5iv7w824y', 'My name is Junior H', 'Junior H');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('x36iwzmcrtoh9g2n1trivlphzgt4lapibyme8wnxjc5hl4cpik','v2jbww5iv7w824y',NULL, 'Junior H Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('vol3a1kcs5dl7md3iumjoyjnqblvurl135nbuu2cx2ngg5qzq3','El Azul','v2jbww5iv7w824y',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('x36iwzmcrtoh9g2n1trivlphzgt4lapibyme8wnxjc5hl4cpik', 'vol3a1kcs5dl7md3iumjoyjnqblvurl135nbuu2cx2ngg5qzq3', '0');
-- Post Malone
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('zesyiyt0jb6559l', 'Post Malone', '33@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:33@artist.com', 'zesyiyt0jb6559l', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('zesyiyt0jb6559l', 'My name is Post Malone', 'Post Malone');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('5szka9cdx818egsmyr9ss0033oznvx1ag5e6rng9euzvm3khz1','zesyiyt0jb6559l',NULL, 'Post Malone Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('eqe8dc1tnqm09h5wofhydqiqrlnnt2mcke70no3d8bsjzie8tk','Sunflower - Spider-Man: Into the Spider-Verse','zesyiyt0jb6559l',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('5szka9cdx818egsmyr9ss0033oznvx1ag5e6rng9euzvm3khz1', 'eqe8dc1tnqm09h5wofhydqiqrlnnt2mcke70no3d8bsjzie8tk', '0');
-- Bebe Rexha
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('phc2vhs7dgtbw88', 'Bebe Rexha', '34@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:34@artist.com', 'phc2vhs7dgtbw88', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('phc2vhs7dgtbw88', 'My name is Bebe Rexha', 'Bebe Rexha');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ul7blo63zec78ibhh28ghs38bi83avyq136e7djwuzmcs165lu','phc2vhs7dgtbw88',NULL, 'Bebe Rexha Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('09x79mwb015ccwhp6d1dhuv97f1ylc6wtgggo87rv57xfazbdb','Im Good (Blue)','phc2vhs7dgtbw88',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ul7blo63zec78ibhh28ghs38bi83avyq136e7djwuzmcs165lu', '09x79mwb015ccwhp6d1dhuv97f1ylc6wtgggo87rv57xfazbdb', '0');
-- Tyler
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('495m3s69kfqacqp', 'Tyler', '35@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:35@artist.com', '495m3s69kfqacqp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('495m3s69kfqacqp', 'My name is Tyler', 'Tyler');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('phduoefox80wthm9zux3icn37enqn1e4ey5el3ehi8lr73kav3','495m3s69kfqacqp',NULL, 'Tyler Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('pn1zpz8k4uler1793dy0jqwad8bdaoly3tcjf5s8482pij1mui','See You Again','495m3s69kfqacqp',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('phduoefox80wthm9zux3icn37enqn1e4ey5el3ehi8lr73kav3', 'pn1zpz8k4uler1793dy0jqwad8bdaoly3tcjf5s8482pij1mui', '0');
-- Nicki Minaj
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('mi42fy5gqylrhq6', 'Nicki Minaj', '36@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:36@artist.com', 'mi42fy5gqylrhq6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('mi42fy5gqylrhq6', 'My name is Nicki Minaj', 'Nicki Minaj');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('rhvpiixn14o7gozp6jq0rg4ngq4hg4xu975877hkjnpsu66v9q','mi42fy5gqylrhq6',NULL, 'Nicki Minaj Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('rfuc0yrykdyt86tiqokfdb3v7uc2xtwi8x3inox89kx4e7x2b0','Barbie World (with Aqua) [From Barbie The Album]','mi42fy5gqylrhq6',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('rhvpiixn14o7gozp6jq0rg4ngq4hg4xu975877hkjnpsu66v9q', 'rfuc0yrykdyt86tiqokfdb3v7uc2xtwi8x3inox89kx4e7x2b0', '0');
-- OneRepublic
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('a2xygdzdwvpo4t1', 'OneRepublic', '37@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:37@artist.com', 'a2xygdzdwvpo4t1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('a2xygdzdwvpo4t1', 'My name is OneRepublic', 'OneRepublic');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('tytvkq4tlrhtc7xrrw1isccu1ekzyd4t6mjatfkc52dw7zyrs8','a2xygdzdwvpo4t1',NULL, 'OneRepublic Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('5io2pntbi67zcy1cox1ely4s7l18b00v2bot2hu5ph99vqkpdh','I Aint Worried','a2xygdzdwvpo4t1',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('tytvkq4tlrhtc7xrrw1isccu1ekzyd4t6mjatfkc52dw7zyrs8', '5io2pntbi67zcy1cox1ely4s7l18b00v2bot2hu5ph99vqkpdh', '0');
-- Ariana Grande
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('rhhln02r06qg5og', 'Ariana Grande', '38@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:38@artist.com', 'rhhln02r06qg5og', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('rhhln02r06qg5og', 'My name is Ariana Grande', 'Ariana Grande');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('4ae763f6qwn1rk07xpbcloz0u6rcuj3hmik2lmd4kwaab3sytm','rhhln02r06qg5og',NULL, 'Ariana Grande Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `created_at`) VALUES ('tnn82qupk2tdnj6f78gn8x8m9ib66s48wrwi8rsudc402pmnsm','Die For You - Remix','rhhln02r06qg5og',100,'POP','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('4ae763f6qwn1rk07xpbcloz0u6rcuj3hmik2lmd4kwaab3sytm', 'tnn82qupk2tdnj6f78gn8x8m9ib66s48wrwi8rsudc402pmnsm', '0');
