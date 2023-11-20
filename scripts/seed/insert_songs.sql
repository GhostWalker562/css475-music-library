-- Latto
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('ncqp5qteslg1z1e', 'Latto', '0@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:0@artist.com', 'ncqp5qteslg1z1e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ncqp5qteslg1z1e', 'My name is Latto', 'Latto');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('wkzgxjt00dfubgmgcb9v89cntnbzqwcyyxknfchx92qavmajs6','ncqp5qteslg1z1e', NULL, 'Latto Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('svh86ii8llz6e2jeita5w04j4c2wczpfg1fk5ocrkeorzk3eev','Seven (feat. Latto) (Explicit Ver.)','ncqp5qteslg1z1e',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('wkzgxjt00dfubgmgcb9v89cntnbzqwcyyxknfchx92qavmajs6', 'svh86ii8llz6e2jeita5w04j4c2wczpfg1fk5ocrkeorzk3eev', '0');
-- Myke Towers
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('vc2y3ggpqo16jdo', 'Myke Towers', '1@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:1@artist.com', 'vc2y3ggpqo16jdo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('vc2y3ggpqo16jdo', 'My name is Myke Towers', 'Myke Towers');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ks7p1vqhybo74jjg8kr0e3m04j8umlhv030r9237yxqyqklcvp','vc2y3ggpqo16jdo', 'https://i.scdn.co/image/ab67616d0000b2730656d5ce813ca3cc4b677e05', 'Myke Towers Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('po1bopypefdsfr8d39lahm6iq3emu3p964ou6mtfl2k07cqoy3','LALA','vc2y3ggpqo16jdo',100,'POP','7ABLbnD53cQK00mhcaOUVG','https://p.scdn.co/mp3-preview/42772b16b4e575d1b15b0ec7f94e335539390d2d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ks7p1vqhybo74jjg8kr0e3m04j8umlhv030r9237yxqyqklcvp', 'po1bopypefdsfr8d39lahm6iq3emu3p964ou6mtfl2k07cqoy3', '0');
-- Olivia Rodrigo
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('9vudvm05ea5gpp4', 'Olivia Rodrigo', '2@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:2@artist.com', '9vudvm05ea5gpp4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('9vudvm05ea5gpp4', 'My name is Olivia Rodrigo', 'Olivia Rodrigo');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('nwuhyq8sde1dqfvpztwztfjh4n8oci86kpobeym0i1bstipuof','9vudvm05ea5gpp4', 'https://i.scdn.co/image/ab67616d0000b273e85259a1cae29a8d91f2093d', 'Olivia Rodrigo Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ff1wz3cxjak9koqhz8hng4ufvq79ch76d89ie48tiihefj4840','vampire','9vudvm05ea5gpp4',100,'POP','1kuGVB7EU95pJObxwvfwKS',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('nwuhyq8sde1dqfvpztwztfjh4n8oci86kpobeym0i1bstipuof', 'ff1wz3cxjak9koqhz8hng4ufvq79ch76d89ie48tiihefj4840', '0');
-- Taylor Swift
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('mssiyd4xsf5mk8a', 'Taylor Swift', '3@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:3@artist.com', 'mssiyd4xsf5mk8a', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('mssiyd4xsf5mk8a', 'My name is Taylor Swift', 'Taylor Swift');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('fsm90yr6fdfsusk3hlkcspwp8gpbeq7gujoclnc50dxkx4py4e','mssiyd4xsf5mk8a', 'https://i.scdn.co/image/ab67616d0000b273e787cffec20aa2a396a61647', 'Taylor Swift Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('tkniemxw4nbzovu9mokp2djiz6047z7v8mfm73qxoh1whybmib','Cruel Summer','mssiyd4xsf5mk8a',100,'POP','1BxfuPKGuaTgP7aM0Bbdwr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('fsm90yr6fdfsusk3hlkcspwp8gpbeq7gujoclnc50dxkx4py4e', 'tkniemxw4nbzovu9mokp2djiz6047z7v8mfm73qxoh1whybmib', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('1gm50no14c7b215ehon9vjr9rmqwt9kx6vjcckt6txd80cfxmk','I Can See You (Taylors Version) (From The ','mssiyd4xsf5mk8a',100,'POP','5kHMfzgLZP95O9NBy0ku4v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('fsm90yr6fdfsusk3hlkcspwp8gpbeq7gujoclnc50dxkx4py4e', '1gm50no14c7b215ehon9vjr9rmqwt9kx6vjcckt6txd80cfxmk', '1');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('q01h19bc4wsne2ype1tjff21x7slmbxwx6w41bxpzhm3nd9d2o','Anti-Hero','mssiyd4xsf5mk8a',100,'POP','0V3wPSX9ygBnCm8psDIegu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('fsm90yr6fdfsusk3hlkcspwp8gpbeq7gujoclnc50dxkx4py4e', 'q01h19bc4wsne2ype1tjff21x7slmbxwx6w41bxpzhm3nd9d2o', '2');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('t1nt46wrg7re1snn81xcrafi1hu6ha68u00mriurv6yat78fon','Blank Space','mssiyd4xsf5mk8a',100,'POP','1p80LdxRV74UKvL8gnD7ky',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('fsm90yr6fdfsusk3hlkcspwp8gpbeq7gujoclnc50dxkx4py4e', 't1nt46wrg7re1snn81xcrafi1hu6ha68u00mriurv6yat78fon', '3');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('bymu5i9s7edvhduyvvfg86wnaa7cw8jsdhruqzgkn2puufwlpa','Style','mssiyd4xsf5mk8a',100,'POP','1hjRhYpWyqDpPahmSlUTlc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('fsm90yr6fdfsusk3hlkcspwp8gpbeq7gujoclnc50dxkx4py4e', 'bymu5i9s7edvhduyvvfg86wnaa7cw8jsdhruqzgkn2puufwlpa', '4');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('9cy6p7hypcvjikwpu2gki4y4oo1pqgk3upv0z3hrn772wu98r4','cardigan','mssiyd4xsf5mk8a',100,'POP','4R2kfaDFhslZEMJqAFNpdd',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('fsm90yr6fdfsusk3hlkcspwp8gpbeq7gujoclnc50dxkx4py4e', '9cy6p7hypcvjikwpu2gki4y4oo1pqgk3upv0z3hrn772wu98r4', '5');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('yqq6guip64ygmtn90hcmqmezqvzd3ijcv3yu9smsrx3qbvu5wa','Karma','mssiyd4xsf5mk8a',100,'POP','7KokYm8cMIXCsGVmUvKtqf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('fsm90yr6fdfsusk3hlkcspwp8gpbeq7gujoclnc50dxkx4py4e', 'yqq6guip64ygmtn90hcmqmezqvzd3ijcv3yu9smsrx3qbvu5wa', '6');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('xqepklfm4l2f32xi7x3d0cjdl674rs3p7t45nq0r88qgud6fip','Enchanted (Taylors Version)','mssiyd4xsf5mk8a',100,'POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('fsm90yr6fdfsusk3hlkcspwp8gpbeq7gujoclnc50dxkx4py4e', 'xqepklfm4l2f32xi7x3d0cjdl674rs3p7t45nq0r88qgud6fip', '7');
-- Bad Bunny
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('4p13nrcio9oa30i', 'Bad Bunny', '4@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:4@artist.com', '4p13nrcio9oa30i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('4p13nrcio9oa30i', 'My name is Bad Bunny', 'Bad Bunny');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('zkdyykyfelhg81o95owaq8ay9wdgrxwx6kkpd96f83qosj5hwc','4p13nrcio9oa30i', 'https://i.scdn.co/image/ab67616d0000b273ab5c9cd818ad6ed3e9b79cd1', 'Bad Bunny Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('g4v9ii8f41ubfu2lp5pa4g38zksd888gl9yvnqgsgi57z45dui','WHERE SHE GOES','4p13nrcio9oa30i',100,'POP','7ro0hRteUMfnOioTFI5TG1','https://p.scdn.co/mp3-preview/b9b7e4c982b33ee23c4867f7a3025e3598c35760?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('zkdyykyfelhg81o95owaq8ay9wdgrxwx6kkpd96f83qosj5hwc', 'g4v9ii8f41ubfu2lp5pa4g38zksd888gl9yvnqgsgi57z45dui', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('r2nev9895xfrtm7ejdkkhy00mzn4n8p51uafrh2y3ft161abya','un x100to','4p13nrcio9oa30i',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('zkdyykyfelhg81o95owaq8ay9wdgrxwx6kkpd96f83qosj5hwc', 'r2nev9895xfrtm7ejdkkhy00mzn4n8p51uafrh2y3ft161abya', '1');
-- Dave
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('ouitcypyi4qj95e', 'Dave', '5@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:5@artist.com', 'ouitcypyi4qj95e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ouitcypyi4qj95e', 'My name is Dave', 'Dave');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('fxk6zy19h2fxe7j6rxgwkb6brcmbaja5g1swet4mnb8xuhz15v','ouitcypyi4qj95e', 'https://i.scdn.co/image/ab67616d0000b273e3a09a9ae3f1fa102c110e60', 'Dave Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ygzulg8f07a2lx43vxzp2nxlr3apndjorce9j0kuoiek37h2p7','Sprinter','ouitcypyi4qj95e',100,'POP','2FDTHlrBguDzQkp7PVj16Q',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('fxk6zy19h2fxe7j6rxgwkb6brcmbaja5g1swet4mnb8xuhz15v', 'ygzulg8f07a2lx43vxzp2nxlr3apndjorce9j0kuoiek37h2p7', '0');
-- Eslabon Armado
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('a1j7yq5nx752ppz', 'Eslabon Armado', '6@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:6@artist.com', 'a1j7yq5nx752ppz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('a1j7yq5nx752ppz', 'My name is Eslabon Armado', 'Eslabon Armado');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('87luk9js3p08q37okjhaqbadlq74o2ino9yv937gmkuape0po7','a1j7yq5nx752ppz', 'https://i.scdn.co/image/ab67616d0000b2732071a0c79802d9375a53bfef', 'Eslabon Armado Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('h9j5sg5w3wq6qj2c89rr52hc4c79ehszt01rmarzt7u3og0nbo','Ella Baila Sola','a1j7yq5nx752ppz',100,'POP','3dnP0JxCgygwQH9Gm7q7nb','https://p.scdn.co/mp3-preview/5d39f3e17f1e20e2711d033001e48b8d4249b992?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('87luk9js3p08q37okjhaqbadlq74o2ino9yv937gmkuape0po7', 'h9j5sg5w3wq6qj2c89rr52hc4c79ehszt01rmarzt7u3og0nbo', '0');
-- Quevedo
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('ipcws1hoiw0nzf9', 'Quevedo', '7@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:7@artist.com', 'ipcws1hoiw0nzf9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ipcws1hoiw0nzf9', 'My name is Quevedo', 'Quevedo');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('23uj4aiq8ouqkedz7sijehfumerclk0ash6ii4biqkoqxbxmae','ipcws1hoiw0nzf9', 'https://i.scdn.co/image/ab67616d0000b273a00a817b017c6f6bf8460be9', 'Quevedo Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('21c7teb0h8xasn9pyiwoind9nhc4ni1zskfshmwq6l6e0exdw4','Columbia','ipcws1hoiw0nzf9',100,'POP','6XbtvPmIpyCbjuT0e8cQtp','https://p.scdn.co/mp3-preview/e3d6df66fe67f618166a2cab858580ac8a96486a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('23uj4aiq8ouqkedz7sijehfumerclk0ash6ii4biqkoqxbxmae', '21c7teb0h8xasn9pyiwoind9nhc4ni1zskfshmwq6l6e0exdw4', '0');
-- Gunna
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('0gy5uj4hhhff8ly', 'Gunna', '8@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:8@artist.com', '0gy5uj4hhhff8ly', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('0gy5uj4hhhff8ly', 'My name is Gunna', 'Gunna');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('qpjhk8fqcu3wwxo44va6iiev22nuxlce3m0l3emqy60xsc5xj1','0gy5uj4hhhff8ly', 'https://i.scdn.co/image/ab67616d0000b273017d5e26552345c4b1575b6c', 'Gunna Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('qjtoyagogjydda1ztw0axux1br6e5nyxqmc2mhls0p4yr09345','fukumean','0gy5uj4hhhff8ly',100,'POP','4rXLjWdF2ZZpXCVTfWcshS','https://p.scdn.co/mp3-preview/f237ab921af697ba9b49e12fa167c2ce1a82d6b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('qpjhk8fqcu3wwxo44va6iiev22nuxlce3m0l3emqy60xsc5xj1', 'qjtoyagogjydda1ztw0axux1br6e5nyxqmc2mhls0p4yr09345', '0');
-- Peso Pluma
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('a7opqxke3bb6eiy', 'Peso Pluma', '9@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:9@artist.com', 'a7opqxke3bb6eiy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('a7opqxke3bb6eiy', 'My name is Peso Pluma', 'Peso Pluma');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('6wfgydxa3gqper64njfj8s6f3y4zi67ucbbs0r22ai1m3rlsll','a7opqxke3bb6eiy', NULL, 'Peso Pluma Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('yg9secntc9kw2jxulunrrsage4vhj10oj5i84lgb4p219x6cxr','La Bebe - Remix','a7opqxke3bb6eiy',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('6wfgydxa3gqper64njfj8s6f3y4zi67ucbbs0r22ai1m3rlsll', 'yg9secntc9kw2jxulunrrsage4vhj10oj5i84lgb4p219x6cxr', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('857fz1jc9dsxewz4bho3w6aayrovtajreywnngs6lgpo7x41zz','TULUM','a7opqxke3bb6eiy',100,'POP','7bPp2NmpmyhLJ7zWazAXMu','https://p.scdn.co/mp3-preview/164468e67b8da8053036c68533ffa473ab680c51?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('6wfgydxa3gqper64njfj8s6f3y4zi67ucbbs0r22ai1m3rlsll', '857fz1jc9dsxewz4bho3w6aayrovtajreywnngs6lgpo7x41zz', '1');
-- NewJeans
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('jvfkzj897v17x10', 'NewJeans', '10@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:10@artist.com', 'jvfkzj897v17x10', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('jvfkzj897v17x10', 'My name is NewJeans', 'NewJeans');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('hkb8qgjznwebusqns2q83i3w80dnnxnyqgzvz1yblz76v6wnr8','jvfkzj897v17x10', 'https://i.scdn.co/image/ab67616d0000b2733d98a0ae7c78a3a9babaf8af', 'NewJeans Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('jb94f2ay46522goqcy1nh088748r7z5w0sf0j03z3i1w6begcm','Super Shy','jvfkzj897v17x10',100,'POP','5sdQOyqq2IDhvmx2lHOpwd','https://p.scdn.co/mp3-preview/dab062e2cc708a2680ce84953a3581c5a679a230?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('hkb8qgjznwebusqns2q83i3w80dnnxnyqgzvz1yblz76v6wnr8', 'jb94f2ay46522goqcy1nh088748r7z5w0sf0j03z3i1w6begcm', '0');
-- Miley Cyrus
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('fjwzz8fi19rxm5x', 'Miley Cyrus', '11@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:11@artist.com', 'fjwzz8fi19rxm5x', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('fjwzz8fi19rxm5x', 'My name is Miley Cyrus', 'Miley Cyrus');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('69lbk997bfr4ebo2t5f2j64y4j4fo8boml9qrfcvij7n3bss8p','fjwzz8fi19rxm5x', 'https://i.scdn.co/image/ab67616d0000b273cd222052a2594be29a6616b5', 'Miley Cyrus Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('64imh4qdm2cssppqag3pa0m4jtpmb754skzbqen3cban43zp5d','Flowers','fjwzz8fi19rxm5x',100,'POP','7DSAEUvxU8FajXtRloy8M0','https://p.scdn.co/mp3-preview/5184d19d1b7fcc3e7c067e38af45a7cc80851440?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('69lbk997bfr4ebo2t5f2j64y4j4fo8boml9qrfcvij7n3bss8p', '64imh4qdm2cssppqag3pa0m4jtpmb754skzbqen3cban43zp5d', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('izda174x7rpkzvrg30vri3nx7xr3xby3edcupztp7h4vmw5w8b','Angels Like You','fjwzz8fi19rxm5x',100,'POP','1daDRI9ahBonbWD8YcxOIB','https://p.scdn.co/mp3-preview/4db8314199c0d49e95c786792ecd06eadae9f510?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('69lbk997bfr4ebo2t5f2j64y4j4fo8boml9qrfcvij7n3bss8p', 'izda174x7rpkzvrg30vri3nx7xr3xby3edcupztp7h4vmw5w8b', '1');
-- David Kushner
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('k8x050eglezf4ud', 'David Kushner', '12@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:12@artist.com', 'k8x050eglezf4ud', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('k8x050eglezf4ud', 'My name is David Kushner', 'David Kushner');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('itq7myc4oc8guqfijsww229msh8pd6e86ilj28eonjjyih4hrg','k8x050eglezf4ud', 'https://i.scdn.co/image/ab67616d0000b27395ca6a9b4083a86c149934ae', 'David Kushner Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('8j2avhiyfumh00men88yomb8u5zgibwad9chwzcerpdo043u2c','Daylight','k8x050eglezf4ud',100,'POP','1odExI7RdWc4BT515LTAwj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('itq7myc4oc8guqfijsww229msh8pd6e86ilj28eonjjyih4hrg', '8j2avhiyfumh00men88yomb8u5zgibwad9chwzcerpdo043u2c', '0');
-- Harry Styles
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('sh5o623tjeg7ok5', 'Harry Styles', '13@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:13@artist.com', 'sh5o623tjeg7ok5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('sh5o623tjeg7ok5', 'My name is Harry Styles', 'Harry Styles');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('eplymiv9f4p3khqe0e8z9x5d5wprs1ys7mhtx6zx4ebwhx2ul5','sh5o623tjeg7ok5', 'https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0', 'Harry Styles Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('y24ns6mtqy6ik4waulv2izftffiez21yzmfxftigaqj7gry5ke','As It Was','sh5o623tjeg7ok5',100,'POP','4Dvkj6JhhA12EX05fT7y2e','https://p.scdn.co/mp3-preview/c43dd07043b29e800c1a65b3a0102861fa3cf418?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('eplymiv9f4p3khqe0e8z9x5d5wprs1ys7mhtx6zx4ebwhx2ul5', 'y24ns6mtqy6ik4waulv2izftffiez21yzmfxftigaqj7gry5ke', '0');
-- SZA
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('s2tuw3bn2i4pl85', 'SZA', '14@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:14@artist.com', 's2tuw3bn2i4pl85', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('s2tuw3bn2i4pl85', 'My name is SZA', 'SZA');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('krvdunzcqzjip8b5ndc4r4pwgak9p8b047n4dp9zl1dzjoaid7','s2tuw3bn2i4pl85', 'https://i.scdn.co/image/ab67616d0000b2730c471c36970b9406233842a5', 'SZA Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('14c4ln54b2j7wbc731a6zuean0siwv9fwmuxixtrbhabgow37j','Kill Bill','s2tuw3bn2i4pl85',100,'POP','1Qrg8KqiBpW07V7PNxwwwL','https://p.scdn.co/mp3-preview/4bd2dc84016f3743add7eea8b988407b1b900672?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('krvdunzcqzjip8b5ndc4r4pwgak9p8b047n4dp9zl1dzjoaid7', '14c4ln54b2j7wbc731a6zuean0siwv9fwmuxixtrbhabgow37j', '0');
-- Fifty Fifty
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('vxclrec9tgfeevp', 'Fifty Fifty', '15@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:15@artist.com', 'vxclrec9tgfeevp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('vxclrec9tgfeevp', 'My name is Fifty Fifty', 'Fifty Fifty');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('3hir5vxutaahkc5h3nwdpwb33crrhy3qqyo0jno10i9oulwnty','vxclrec9tgfeevp', 'https://i.scdn.co/image/ab67616d0000b27337c0b3670236c067c8e8bbcb', 'Fifty Fifty Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('d22kq1zzrnasl80q0folwcsmf8zi68743fbxdha6sr3a1vqk5p','Cupid - Twin Ver.','vxclrec9tgfeevp',100,'POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('3hir5vxutaahkc5h3nwdpwb33crrhy3qqyo0jno10i9oulwnty', 'd22kq1zzrnasl80q0folwcsmf8zi68743fbxdha6sr3a1vqk5p', '0');
-- Billie Eilish
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('94gwe1iqcnmmmgv', 'Billie Eilish', '16@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:16@artist.com', '94gwe1iqcnmmmgv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('94gwe1iqcnmmmgv', 'My name is Billie Eilish', 'Billie Eilish');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('lslaernxni05ahdizn2blqm3x3bg139opazn3lk8islswtcb1n','94gwe1iqcnmmmgv', NULL, 'Billie Eilish Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('z9hx4xt5mm18kmfweeu303nl3o6edmpsawvjvj6i7jp1cnabep','What Was I Made For? [From The Motion Picture "Barbie"]','94gwe1iqcnmmmgv',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('lslaernxni05ahdizn2blqm3x3bg139opazn3lk8islswtcb1n', 'z9hx4xt5mm18kmfweeu303nl3o6edmpsawvjvj6i7jp1cnabep', '0');
-- Feid
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('ls7tv8syravyaww', 'Feid', '17@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:17@artist.com', 'ls7tv8syravyaww', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ls7tv8syravyaww', 'My name is Feid', 'Feid');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('v9o9fy2kw3302p47u8fkjg5hh0r1bhs6avwo5asnl9qksct5fz','ls7tv8syravyaww', 'https://i.scdn.co/image/ab67616d0000b27329ebee2b5fb008871fcd201a', 'Feid Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('pmmp1nndzon9f6ttx4stq6lmviuwf6as62f4f4gkmg8q9negjz','Classy 101','ls7tv8syravyaww',100,'POP','6XSqqQIy7Lm7SnwxS4NrGx',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('v9o9fy2kw3302p47u8fkjg5hh0r1bhs6avwo5asnl9qksct5fz', 'pmmp1nndzon9f6ttx4stq6lmviuwf6as62f4f4gkmg8q9negjz', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('1iknch560dl1xpc6qa94asa4d95cyn0lzcis1vjko6jemmwt2h','El Cielo','ls7tv8syravyaww',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('v9o9fy2kw3302p47u8fkjg5hh0r1bhs6avwo5asnl9qksct5fz', '1iknch560dl1xpc6qa94asa4d95cyn0lzcis1vjko6jemmwt2h', '1');
-- Jimin
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('2h146sufgsxlqvd', 'Jimin', '18@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:18@artist.com', '2h146sufgsxlqvd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('2h146sufgsxlqvd', 'My name is Jimin', 'Jimin');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('uhugqqmjshskkpijbh7538cwcyjl113w0uc7kt9e83yeyuys0q','2h146sufgsxlqvd', 'https://i.scdn.co/image/ab67616d0000b2732b46078245d0120690eb560d', 'Jimin Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('73mm5latlxelcyazsuuzp0igr23fw3smc5tat8449l9mjbcz60','Like Crazy','2h146sufgsxlqvd',100,'POP','3Ua0m0YmEjrMi9XErKcNiR','https://p.scdn.co/mp3-preview/2db5f36096963d97afc870c50990d62d27858a43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('uhugqqmjshskkpijbh7538cwcyjl113w0uc7kt9e83yeyuys0q', '73mm5latlxelcyazsuuzp0igr23fw3smc5tat8449l9mjbcz60', '0');
-- Gabito Ballesteros
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('v5b8s0g9ojsvuwh', 'Gabito Ballesteros', '19@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:19@artist.com', 'v5b8s0g9ojsvuwh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('v5b8s0g9ojsvuwh', 'My name is Gabito Ballesteros', 'Gabito Ballesteros');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('wa256eivh932zrrikiughmoyz4wimyc3ew5ccsrb46wqrtdya1','v5b8s0g9ojsvuwh', NULL, 'Gabito Ballesteros Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('viv01zlm3149v53ijrxzscbxbjgf257p76pa7yenbbk7j9qqqf','LADY GAGA','v5b8s0g9ojsvuwh',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('wa256eivh932zrrikiughmoyz4wimyc3ew5ccsrb46wqrtdya1', 'viv01zlm3149v53ijrxzscbxbjgf257p76pa7yenbbk7j9qqqf', '0');
-- Arctic Monkeys
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('zy02z98kbythmey', 'Arctic Monkeys', '20@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:20@artist.com', 'zy02z98kbythmey', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('zy02z98kbythmey', 'My name is Arctic Monkeys', 'Arctic Monkeys');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('8py6jibh4elwwks9kagbijd44g81g0sgzwshiu534atx7qenwk','zy02z98kbythmey', 'https://i.scdn.co/image/ab67616d0000b2734ae1c4c5c45aabe565499163', 'Arctic Monkeys Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('7ld88z9m1im5tvtmsaccnfgqqtuusbuy89txh8ka9nqixexgge','I Wanna Be Yours','zy02z98kbythmey',100,'POP','5XeFesFbtLpXzIVDNQP22n','https://p.scdn.co/mp3-preview/07de30bde8363d9ff78b72339245c151f67af451?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('8py6jibh4elwwks9kagbijd44g81g0sgzwshiu534atx7qenwk', '7ld88z9m1im5tvtmsaccnfgqqtuusbuy89txh8ka9nqixexgge', '0');
-- Bizarrap
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('wep917g4m6aabjt', 'Bizarrap', '21@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:21@artist.com', 'wep917g4m6aabjt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('wep917g4m6aabjt', 'My name is Bizarrap', 'Bizarrap');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('32f536fsc3xykrynb5wrqj7ntz2esijvsoi2lhu0z4u5oimwn3','wep917g4m6aabjt', 'https://i.scdn.co/image/ab67616d0000b27315583045b2fdb7d7bab10e81', 'Bizarrap Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('5bv9f8r21tv40umlglr86jo48mbwmwlw32m0o2tzmzpyynd3dj','Peso Pluma: Bzrp Music Sessions, Vol. 55','wep917g4m6aabjt',100,'POP','5AqiaZwhmC6dIbgWrD5SzV','https://p.scdn.co/mp3-preview/9d61998a29c2e8b52a7d46885352f5507eb219e2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('32f536fsc3xykrynb5wrqj7ntz2esijvsoi2lhu0z4u5oimwn3', '5bv9f8r21tv40umlglr86jo48mbwmwlw32m0o2tzmzpyynd3dj', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('lblv3scwcmvmtflbusevguiwxnbe0affktppriictv5fpxphrp','Quevedo: Bzrp Music Sessions, Vol. 52','wep917g4m6aabjt',100,'POP','2tTmW7RDtMQtBk7m2rYeSw','https://p.scdn.co/mp3-preview/e9c0ed735e611f6af45bc946bd4c31590df09ed6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('32f536fsc3xykrynb5wrqj7ntz2esijvsoi2lhu0z4u5oimwn3', 'lblv3scwcmvmtflbusevguiwxnbe0affktppriictv5fpxphrp', '1');
-- The Weeknd
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('5yytwa1reyim3hd', 'The Weeknd', '22@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:22@artist.com', '5yytwa1reyim3hd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('5yytwa1reyim3hd', 'My name is The Weeknd', 'The Weeknd');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('tmf3puvt8k2kdfunnn2ks15yqoim2d5k94mzc60b7qczx8tc6w','5yytwa1reyim3hd', NULL, 'The Weeknd Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('l1cme2fw3b4unh7onmzxf491yc25ikfswv5uk8rl4oygj0tltq','Popular (with Playboi Carti & Madonna) - The Idol Vol. 1 (Music from the HBO Original Series)','5yytwa1reyim3hd',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('tmf3puvt8k2kdfunnn2ks15yqoim2d5k94mzc60b7qczx8tc6w', 'l1cme2fw3b4unh7onmzxf491yc25ikfswv5uk8rl4oygj0tltq', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('tyqz8tkoc1ev5wy44xns8fm6vpdldudr79dn03u7h8vwp2m4m6','Creepin','5yytwa1reyim3hd',100,'POP','0GVaOXDGwtnH8gCURYyEaK','https://p.scdn.co/mp3-preview/a2b11e2f0cb8ef4a0316a686e73da9ec2b203e6e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('tmf3puvt8k2kdfunnn2ks15yqoim2d5k94mzc60b7qczx8tc6w', 'tyqz8tkoc1ev5wy44xns8fm6vpdldudr79dn03u7h8vwp2m4m6', '1');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('q7bp0l4dt9a9in7khswi2zcissk0fh0n2amynsldl2tu226jei','Die For You','5yytwa1reyim3hd',100,'POP','2LBqCSwhJGcFQeTHMVGwy3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('tmf3puvt8k2kdfunnn2ks15yqoim2d5k94mzc60b7qczx8tc6w', 'q7bp0l4dt9a9in7khswi2zcissk0fh0n2amynsldl2tu226jei', '2');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('okgoret25xocvtsub5hoahouk0x0l4nsle1waohxn9xrl5ni45','Starboy','5yytwa1reyim3hd',100,'POP','7MXVkk9YMctZqd1Srtv4MB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('tmf3puvt8k2kdfunnn2ks15yqoim2d5k94mzc60b7qczx8tc6w', 'okgoret25xocvtsub5hoahouk0x0l4nsle1waohxn9xrl5ni45', '3');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('e6v6kcds515byl5z33pcrvy040145gehqebompaolavd46vchl','Blinding Lights','5yytwa1reyim3hd',100,'POP','0VjIjW4GlUZAMYd2vXMi3b',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('tmf3puvt8k2kdfunnn2ks15yqoim2d5k94mzc60b7qczx8tc6w', 'e6v6kcds515byl5z33pcrvy040145gehqebompaolavd46vchl', '4');
-- Fuerza Regida
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('gfy7dv7a57ndmme', 'Fuerza Regida', '23@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:23@artist.com', 'gfy7dv7a57ndmme', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('gfy7dv7a57ndmme', 'My name is Fuerza Regida', 'Fuerza Regida');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('adtqsb834dwprpd5a42dny2i99o5cxerjfmk26s00u2s5mtf4v','gfy7dv7a57ndmme', 'https://i.scdn.co/image/ab67616d0000b273cfe3eb72c48b93971e53efd9', 'Fuerza Regida Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('vdus0cc6bwv4jcjoadsnlcp1luf4ma7n095getmikn01fzocda','SABOR FRESA','gfy7dv7a57ndmme',100,'POP','1UMm1Qs3u59Wvk53zBUE8r','https://p.scdn.co/mp3-preview/590ae0b69465339d97ef5db9f7e36fe0c452fbb4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('adtqsb834dwprpd5a42dny2i99o5cxerjfmk26s00u2s5mtf4v', 'vdus0cc6bwv4jcjoadsnlcp1luf4ma7n095getmikn01fzocda', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('4ous5n7dnb3rbjb4x78k0hjqegdz0p09nt9qvl270zx77dkwsd','TQM','gfy7dv7a57ndmme',100,'POP','368eeEO3Y2uZUQ6S5oIjcu','https://p.scdn.co/mp3-preview/63f6b66cfcc3d7bd396dcbe18d6e3dee05fdb956?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('adtqsb834dwprpd5a42dny2i99o5cxerjfmk26s00u2s5mtf4v', '4ous5n7dnb3rbjb4x78k0hjqegdz0p09nt9qvl270zx77dkwsd', '1');
-- Rma
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('xta68otsfbcsl7k', 'Rma', '24@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:24@artist.com', 'xta68otsfbcsl7k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('xta68otsfbcsl7k', 'My name is Rma', 'Rma');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('d0511ut9kb06a0itq6vxx8r260io4qzn1i0cwu7dqwfh1bqk6w','xta68otsfbcsl7k', NULL, 'Rma Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('xumi0yq5cg9151j99zsael91q2p4utq41u13ios91gqlhcd0ly','Calm Down (with Selena Gomez)','xta68otsfbcsl7k',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('d0511ut9kb06a0itq6vxx8r260io4qzn1i0cwu7dqwfh1bqk6w', 'xumi0yq5cg9151j99zsael91q2p4utq41u13ios91gqlhcd0ly', '0');
-- Tainy
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('64nywtnm3dv8thc', 'Tainy', '25@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:25@artist.com', '64nywtnm3dv8thc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('64nywtnm3dv8thc', 'My name is Tainy', 'Tainy');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('0iceisafr253cde9sk925pmgd43tfqu9vpq6hsp5sc44yi0dl6','64nywtnm3dv8thc', 'https://i.scdn.co/image/ab67616d0000b273de7b9af78fbdda96c5a0635b', 'Tainy Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('yyp5l0j11bi11h8gvdsgwmzcmlbcj82okfpuzicl4ych71grly','MOJABI GHOST','64nywtnm3dv8thc',100,'POP','4eMKD8MRroxCqugpsxCCNb','https://p.scdn.co/mp3-preview/a6d8180d52b759c3e3db9aa78e841ffc06e26c17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('0iceisafr253cde9sk925pmgd43tfqu9vpq6hsp5sc44yi0dl6', 'yyp5l0j11bi11h8gvdsgwmzcmlbcj82okfpuzicl4ych71grly', '0');
-- Morgan Wallen
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('1y1l4p1cea1muk7', 'Morgan Wallen', '26@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:26@artist.com', '1y1l4p1cea1muk7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('1y1l4p1cea1muk7', 'My name is Morgan Wallen', 'Morgan Wallen');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('9ffw9tupi42ka0oa1p0rm3lquqh1xgrpsdpgidsknafk5zkkci','1y1l4p1cea1muk7', 'https://i.scdn.co/image/ab67616d0000b273705079df9a25a28b452c1fc9', 'Morgan Wallen Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('5f04g4apqvtvfkomrtfydxxezxgfr9orezsiyj7kef1c0kfisc','Last Night','1y1l4p1cea1muk7',100,'POP','7K3BhSpAxZBznislvUMVtn',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('9ffw9tupi42ka0oa1p0rm3lquqh1xgrpsdpgidsknafk5zkkci', '5f04g4apqvtvfkomrtfydxxezxgfr9orezsiyj7kef1c0kfisc', '0');
-- Dua Lipa
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('2g42n5f6yhrepz6', 'Dua Lipa', '27@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:27@artist.com', '2g42n5f6yhrepz6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('2g42n5f6yhrepz6', 'My name is Dua Lipa', 'Dua Lipa');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('8amrnke91dn97mb8n1aoenltz6wt7sqqj4macmxznnma101zjz','2g42n5f6yhrepz6', 'https://i.scdn.co/image/ab67616d0000b2737dd3ba455ee3390cb55b0192', 'Dua Lipa Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ng2yyvupw4yptre4wn6d87j0ovspp9za95137fkzttdxv5ggqx','Dance The Night (From Barbie The Album)','2g42n5f6yhrepz6',100,'POP','1vYXt7VSjH9JIM5oRRo7vA','https://p.scdn.co/mp3-preview/acaea048f50a3b30ca24b348c84a6047373baabb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('8amrnke91dn97mb8n1aoenltz6wt7sqqj4macmxznnma101zjz', 'ng2yyvupw4yptre4wn6d87j0ovspp9za95137fkzttdxv5ggqx', '0');
-- Troye Sivan
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('j6zx0l5wqxp68ya', 'Troye Sivan', '28@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:28@artist.com', 'j6zx0l5wqxp68ya', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('j6zx0l5wqxp68ya', 'My name is Troye Sivan', 'Troye Sivan');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('x2787c6cdh6bt6f0lgxbxjxq1r1zu43rm176n5hhoqezzghj3k','j6zx0l5wqxp68ya', 'https://i.scdn.co/image/ab67616d0000b27367103283a4eb57578a428252', 'Troye Sivan Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ji7iyrvmx88z2r4wfabby71h4l6ynrvck3ltshjpvrauv1qbmu','Rush','j6zx0l5wqxp68ya',100,'POP','4ZnkygoWLzcGbQYCm3lkae',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('x2787c6cdh6bt6f0lgxbxjxq1r1zu43rm176n5hhoqezzghj3k', 'ji7iyrvmx88z2r4wfabby71h4l6ynrvck3ltshjpvrauv1qbmu', '0');
-- Karol G
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('a4a03i3wiok9qd0', 'Karol G', '29@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:29@artist.com', 'a4a03i3wiok9qd0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('a4a03i3wiok9qd0', 'My name is Karol G', 'Karol G');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('98meq0vs58hgnsvmqajk393ozc9vktcokzr546pdfg213y6qlc','a4a03i3wiok9qd0', 'https://i.scdn.co/image/ab67616d0000b27382de1ca074ae63cb18fce335', 'Karol G Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('vj5nh5w9ngpmut0mxns6b77u0onk5y8pkerpjleccrcun7366f','TQG','a4a03i3wiok9qd0',100,'POP','0DWdj2oZMBFSzRsi2Cvfzf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('98meq0vs58hgnsvmqajk393ozc9vktcokzr546pdfg213y6qlc', 'vj5nh5w9ngpmut0mxns6b77u0onk5y8pkerpjleccrcun7366f', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('p0yox2abot5h12t51hmpjgmu4ctc1crdcb4kdv16hd2hi1x7wi','AMARGURA','a4a03i3wiok9qd0',100,'POP','505v13epFXodT9fVAJ6h8k',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('98meq0vs58hgnsvmqajk393ozc9vktcokzr546pdfg213y6qlc', 'p0yox2abot5h12t51hmpjgmu4ctc1crdcb4kdv16hd2hi1x7wi', '1');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('d6fh3p8nwtbkqqms9ym4605gtst59mhv6s36x13k2jylya2k3f','S91','a4a03i3wiok9qd0',100,'POP','7EpOXgSRgnglRWr86pZfGU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('98meq0vs58hgnsvmqajk393ozc9vktcokzr546pdfg213y6qlc', 'd6fh3p8nwtbkqqms9ym4605gtst59mhv6s36x13k2jylya2k3f', '2');
-- Big One
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('z151r5o9z3h0amx', 'Big One', '30@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:30@artist.com', 'z151r5o9z3h0amx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('z151r5o9z3h0amx', 'My name is Big One', 'Big One');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('4g7t9zvmudce3d94c8zoc64jec7n5vlsuc1vkohtfvrzbx6fad','z151r5o9z3h0amx', NULL, 'Big One Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('nbsub5y8xpdrnbeztotb05g47vesq00jxqcys28rxh5193qi87','Los del Espacio','z151r5o9z3h0amx',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('4g7t9zvmudce3d94c8zoc64jec7n5vlsuc1vkohtfvrzbx6fad', 'nbsub5y8xpdrnbeztotb05g47vesq00jxqcys28rxh5193qi87', '0');
-- Yahritza Y Su Esencia
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('awvi97pvoeu8443', 'Yahritza Y Su Esencia', '31@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:31@artist.com', 'awvi97pvoeu8443', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('awvi97pvoeu8443', 'My name is Yahritza Y Su Esencia', 'Yahritza Y Su Esencia');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('y67f62ctoip3snbqz6ws3zr5hcpqzf3w3hefgudfc2y4a47ocy','awvi97pvoeu8443', NULL, 'Yahritza Y Su Esencia Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('o1bghjju0clftyqoqbkpet15qux4zskha4pclt9pzb3qm48bzc','Frgil (feat. Grupo Front','awvi97pvoeu8443',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('y67f62ctoip3snbqz6ws3zr5hcpqzf3w3hefgudfc2y4a47ocy', 'o1bghjju0clftyqoqbkpet15qux4zskha4pclt9pzb3qm48bzc', '0');
-- Junior H
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('ldp722t18m01s3v', 'Junior H', '32@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:32@artist.com', 'ldp722t18m01s3v', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('ldp722t18m01s3v', 'My name is Junior H', 'Junior H');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('2zzx36wid0w4aeqhbjyjjbpcnyichvj2k73tc3sz9jgrbef3k3','ldp722t18m01s3v', 'https://i.scdn.co/image/ab67616d0000b27333ed356efed99b158c4267c6', 'Junior H Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('rlikics41j6l188ifst0kkmbydhecgmakkgh3nbttzackoc14r','El Azul','ldp722t18m01s3v',100,'POP','1haJsMtoBhHfvuM7XWuT3W','https://p.scdn.co/mp3-preview/f9df136c3a2d3c0c5424e2c4b75a303f35c08af5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('2zzx36wid0w4aeqhbjyjjbpcnyichvj2k73tc3sz9jgrbef3k3', 'rlikics41j6l188ifst0kkmbydhecgmakkgh3nbttzackoc14r', '0');
-- Post Malone
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('zy77g1f11ma5aji', 'Post Malone', '33@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:33@artist.com', 'zy77g1f11ma5aji', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('zy77g1f11ma5aji', 'My name is Post Malone', 'Post Malone');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ujg8ja5rkxx3b2aq25tyf5mjlvuc7d9t07ryku8eq8mf2xepdv','zy77g1f11ma5aji', 'https://i.scdn.co/image/ab67616d0000b2739478c87599550dd73bfa7e02', 'Post Malone Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('o5u0ivyfwojqurqk17aye0mzi1orwkuyk0jjcrrb48rrpy9m65','Sunflower - Spider-Man: Into the Spider-Verse','zy77g1f11ma5aji',100,'POP','0RiRZpuVRbi7oqRdSMwhQY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ujg8ja5rkxx3b2aq25tyf5mjlvuc7d9t07ryku8eq8mf2xepdv', 'o5u0ivyfwojqurqk17aye0mzi1orwkuyk0jjcrrb48rrpy9m65', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('lxbij53i2ve5397i7c51uklakpx9f9026ftb2dkcp97pcl3ssp','Overdrive','zy77g1f11ma5aji',100,'POP','3t0ic4mkhvhamrKDkulB8v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ujg8ja5rkxx3b2aq25tyf5mjlvuc7d9t07ryku8eq8mf2xepdv', 'lxbij53i2ve5397i7c51uklakpx9f9026ftb2dkcp97pcl3ssp', '1');
-- Bebe Rexha
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('3su6yx33m5zcrbs', 'Bebe Rexha', '34@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:34@artist.com', '3su6yx33m5zcrbs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('3su6yx33m5zcrbs', 'My name is Bebe Rexha', 'Bebe Rexha');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ufak041csf0fgnrxs318mlrvolhoqw8rhj4nb00wwxp66ym2j8','3su6yx33m5zcrbs', NULL, 'Bebe Rexha Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ctl44rvkm4iixnwjvcxnpt3l3q0y5r471jsx5h7cfx9tssg7ne','Im Good (Blue)','3su6yx33m5zcrbs',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ufak041csf0fgnrxs318mlrvolhoqw8rhj4nb00wwxp66ym2j8', 'ctl44rvkm4iixnwjvcxnpt3l3q0y5r471jsx5h7cfx9tssg7ne', '0');
-- Tyler
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('h7ntazywcer2oyg', 'Tyler', '35@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:35@artist.com', 'h7ntazywcer2oyg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('h7ntazywcer2oyg', 'My name is Tyler', 'Tyler');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('y2ep9wrlw9ooubx73n56ys6pedksr48y43r3w3if3i1itw71tg','h7ntazywcer2oyg', 'https://i.scdn.co/image/ab67616d0000b2738940ac99f49e44f59e6f7fb3', 'Tyler Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('160d0siz53c7cmisuqq18092rcx6pgc828ddwuholz35qwea8y','See You Again','h7ntazywcer2oyg',100,'POP','7KA4W4McWYRpgf0fWsJZWB','https://p.scdn.co/mp3-preview/c703198293891e3b276800ea6b187cf7951d3d7d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('y2ep9wrlw9ooubx73n56ys6pedksr48y43r3w3if3i1itw71tg', '160d0siz53c7cmisuqq18092rcx6pgc828ddwuholz35qwea8y', '0');
-- Nicki Minaj
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('qhkzvl8mlw9takh', 'Nicki Minaj', '36@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:36@artist.com', 'qhkzvl8mlw9takh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('qhkzvl8mlw9takh', 'My name is Nicki Minaj', 'Nicki Minaj');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('fxu0qgg5vez4eo57wxws95s3edhno16ch2j66uxk1k235aj4eu','qhkzvl8mlw9takh', 'https://i.scdn.co/image/ab67616d0000b2737e8f938c02fac3b564931116', 'Nicki Minaj Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('teors20vqtssto0ku4sinp8xlqthtxnw2jvqo9dggbjt18f9jk','Barbie World (with Aqua) [From Barbie The Album]','qhkzvl8mlw9takh',100,'POP','741UUVE2kuITl0c6zuqqbO','https://p.scdn.co/mp3-preview/f654928ccaa4e6a9fb09a6eb3f208383eccc12a9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('fxu0qgg5vez4eo57wxws95s3edhno16ch2j66uxk1k235aj4eu', 'teors20vqtssto0ku4sinp8xlqthtxnw2jvqo9dggbjt18f9jk', '0');
-- OneRepublic
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('dyq70ltxew7qxh3', 'OneRepublic', '37@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:37@artist.com', 'dyq70ltxew7qxh3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('dyq70ltxew7qxh3', 'My name is OneRepublic', 'OneRepublic');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ixy604s29d6qex7gt5qz1tpib45ecep6cfhgisonm46ofba3mo','dyq70ltxew7qxh3', 'https://i.scdn.co/image/ab67616d0000b273ec96e006b8bdfc582610ec13', 'OneRepublic Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ylbp2krnzvb0e4d9alh2la3hr5xzu0pohgz98497ott14ohum9','I Aint Worried','dyq70ltxew7qxh3',100,'POP','4h9wh7iOZ0GGn8QVp4RAOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ixy604s29d6qex7gt5qz1tpib45ecep6cfhgisonm46ofba3mo', 'ylbp2krnzvb0e4d9alh2la3hr5xzu0pohgz98497ott14ohum9', '0');
-- Ariana Grande
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('r8b4qmi9hjof7hr', 'Ariana Grande', '38@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:38@artist.com', 'r8b4qmi9hjof7hr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('r8b4qmi9hjof7hr', 'My name is Ariana Grande', 'Ariana Grande');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('5t7o8ii2gy33lrj9hha797ynhx7zbvqf1xjs5gg2nw2064hr0t','r8b4qmi9hjof7hr', NULL, 'Ariana Grande Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('t2xnfy2vj9wmfzm6j0cniosvd9afabn36c39c9o6c7b070th1h','Die For You - Remix','r8b4qmi9hjof7hr',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('5t7o8ii2gy33lrj9hha797ynhx7zbvqf1xjs5gg2nw2064hr0t', 't2xnfy2vj9wmfzm6j0cniosvd9afabn36c39c9o6c7b070th1h', '0');
-- David Guetta
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('2l5oz22buetrspr', 'David Guetta', '39@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:39@artist.com', '2l5oz22buetrspr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('2l5oz22buetrspr', 'My name is David Guetta', 'David Guetta');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('eurz7dcpnd53i8wnkuxjbczp61v9q3ron67qom2zdmkigr079z','2l5oz22buetrspr', 'https://i.scdn.co/image/ab67616d0000b2730b4ef75c3728599aa4104f7a', 'David Guetta Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('ern7r9z471phxxcmpgkzxa605bu1s7t5yo9dnubo9j1hupac1s','Baby Dont Hurt Me','2l5oz22buetrspr',100,'POP','3BKD1PwArikchz2Zrlp1qi','https://p.scdn.co/mp3-preview/a8f2e176e17e0f6298b42ef8e96118318fdd2b89?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('eurz7dcpnd53i8wnkuxjbczp61v9q3ron67qom2zdmkigr079z', 'ern7r9z471phxxcmpgkzxa605bu1s7t5yo9dnubo9j1hupac1s', '0');
-- Peggy Gou
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('27tzwtbv5qeib0d', 'Peggy Gou', '40@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:40@artist.com', '27tzwtbv5qeib0d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('27tzwtbv5qeib0d', 'My name is Peggy Gou', 'Peggy Gou');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('4h7f31cvuhk5m1bmb9h516bfmnoimmkrw4l2i3192qb13jpd0y','27tzwtbv5qeib0d', 'https://i.scdn.co/image/ab67616d0000b27388d71aadd009fe1a83df88f2', 'Peggy Gou Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('wit466wk6pt0g5ht1y0r6jm6eamgiyu7fyr7k2pxzmnp8ujupq','(It Goes Like) Nanana - Edit','27tzwtbv5qeib0d',100,'POP','23RoR84KodL5HWvUTneQ1w','https://p.scdn.co/mp3-preview/e36e0bd4714844f1f9d992398b41a3e333f15cc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('4h7f31cvuhk5m1bmb9h516bfmnoimmkrw4l2i3192qb13jpd0y', 'wit466wk6pt0g5ht1y0r6jm6eamgiyu7fyr7k2pxzmnp8ujupq', '0');
-- Tom Odell
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('5pymwbn4t48zoh8', 'Tom Odell', '41@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:41@artist.com', '5pymwbn4t48zoh8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('5pymwbn4t48zoh8', 'My name is Tom Odell', 'Tom Odell');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('v0hcw6n1m3g00sg4qavjircbwbt0hcfkgfie28qjlxhkoz4p1r','5pymwbn4t48zoh8', 'https://i.scdn.co/image/ab67616d0000b2731917a0f3f4152622a040913f', 'Tom Odell Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('uf58f44ayq2kdqqcv9a1f8jaru8mql9fy03uz5ncgtf2fp4fqo','Another Love','5pymwbn4t48zoh8',100,'POP','3JvKfv6T31zO0ini8iNItO','https://p.scdn.co/mp3-preview/0369cb748bc968ffd34fb4ac60f5403f2aad032f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('v0hcw6n1m3g00sg4qavjircbwbt0hcfkgfie28qjlxhkoz4p1r', 'uf58f44ayq2kdqqcv9a1f8jaru8mql9fy03uz5ncgtf2fp4fqo', '0');
-- Kali Uchis
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('6pxb0d31txy5jtl', 'Kali Uchis', '42@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:42@artist.com', '6pxb0d31txy5jtl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('6pxb0d31txy5jtl', 'My name is Kali Uchis', 'Kali Uchis');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('r3keuxbchjojj8teugazhz3izuvsi0lvbqj8puyymbc0kpw3sz','6pxb0d31txy5jtl', 'https://i.scdn.co/image/ab67616d0000b27381fccd758776d16b87721b17', 'Kali Uchis Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('0eg5we1dedd6n2qtd7rczr0f87g7ftvy4250cyr40w86zyypv4','Moonlight','6pxb0d31txy5jtl',100,'POP','0JmnkIqdlnUzPaf8sqBRs3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('r3keuxbchjojj8teugazhz3izuvsi0lvbqj8puyymbc0kpw3sz', '0eg5we1dedd6n2qtd7rczr0f87g7ftvy4250cyr40w86zyypv4', '0');
-- Manuel Turizo
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('5nkq9f7oqt4wyuw', 'Manuel Turizo', '43@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:43@artist.com', '5nkq9f7oqt4wyuw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('5nkq9f7oqt4wyuw', 'My name is Manuel Turizo', 'Manuel Turizo');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('gz9gul1zmszqv7qvq15dsh1imi9pokgwrpl9pkpk01pa09qafp','5nkq9f7oqt4wyuw', 'https://i.scdn.co/image/ab67616d0000b273c9f744b0d62da795bc21d04a', 'Manuel Turizo Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('pm67ah12p65mdundn7gtczojbeltqoewf64qv5nu9pbjnvdpaj','La Bachata','5nkq9f7oqt4wyuw',100,'POP','5ww2BF9slyYgNOk37BlC4u','https://p.scdn.co/mp3-preview/0232b53fd7849e6696e1ab3099dd01dd00823f17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('gz9gul1zmszqv7qvq15dsh1imi9pokgwrpl9pkpk01pa09qafp', 'pm67ah12p65mdundn7gtczojbeltqoewf64qv5nu9pbjnvdpaj', '0');
-- dennis
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('y3cbrrmj6b9tc8u', 'dennis', '44@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:44@artist.com', 'y3cbrrmj6b9tc8u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('y3cbrrmj6b9tc8u', 'My name is dennis', 'dennis');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('2h2rcmfiethpnzaa7bk4zbdy0yhduvvy2erqqmjtchr4lkvv68','y3cbrrmj6b9tc8u', 'https://i.scdn.co/image/ab67616d0000b273ddfc406de0d7dbc2e339f016', 'dennis Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('fkfcvzn1gb6sbwx5jzbnkvzz2dyngzexxejffxh3b23zm0l3qf','T','y3cbrrmj6b9tc8u',100,'POP','35FW5OEe4p38LdjK1KqT2X','https://p.scdn.co/mp3-preview/eaa522f48564e43e33e00c011aef0489526d1072?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('2h2rcmfiethpnzaa7bk4zbdy0yhduvvy2erqqmjtchr4lkvv68', 'fkfcvzn1gb6sbwx5jzbnkvzz2dyngzexxejffxh3b23zm0l3qf', '0');
-- PinkPantheress
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('j8y4gxpwyawzyjf', 'PinkPantheress', '45@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:45@artist.com', 'j8y4gxpwyawzyjf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('j8y4gxpwyawzyjf', 'My name is PinkPantheress', 'PinkPantheress');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('05vf0q78irh66yzekz6qyruofa90gxc2w49qpg9329k3dx70kr','j8y4gxpwyawzyjf', 'https://i.scdn.co/image/ab67616d0000b2739567e1aa41657425d046733b', 'PinkPantheress Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('9u88swilwaggph6x9q29ui75kddpiw3rcwmei4oo7whut6lazm','Boys a liar Pt. 2','j8y4gxpwyawzyjf',100,'POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('05vf0q78irh66yzekz6qyruofa90gxc2w49qpg9329k3dx70kr', '9u88swilwaggph6x9q29ui75kddpiw3rcwmei4oo7whut6lazm', '0');
-- Charlie Puth
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('dki2i666upfx6dd', 'Charlie Puth', '46@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:46@artist.com', 'dki2i666upfx6dd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('dki2i666upfx6dd', 'My name is Charlie Puth', 'Charlie Puth');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('rb45eu484cj2321l3e2sv4t4cd972ab64nk0to8zc1noj4rxb3','dki2i666upfx6dd', 'https://i.scdn.co/image/ab67616d0000b27335d2e0ed94a934f2cc46fa49', 'Charlie Puth Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('lixnoj97e2ugl620jxfab0feq8cm6krujh42bu3qix1jkdcen8','Left and Right (Feat. Jung Kook of BTS)','dki2i666upfx6dd',100,'POP','5Odq8ohlgIbQKMZivbWkEo','https://p.scdn.co/mp3-preview/9e4342eefa4f33df4e9b199e60dbce0f59e46eff?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('rb45eu484cj2321l3e2sv4t4cd972ab64nk0to8zc1noj4rxb3', 'lixnoj97e2ugl620jxfab0feq8cm6krujh42bu3qix1jkdcen8', '0');
-- Rauw Alejandro
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('03djf881sti4q1s', 'Rauw Alejandro', '47@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:47@artist.com', '03djf881sti4q1s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('03djf881sti4q1s', 'My name is Rauw Alejandro', 'Rauw Alejandro');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('tvl0d1ick3rnn7jj39qdvu6tw0lplqfe49xnwtvwlt1wui01pv','03djf881sti4q1s', NULL, 'Rauw Alejandro Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('nmikhubotkb4v5zv0uupm5m67uq8zktaud2zb1rr36zqbobj8v','BESO','03djf881sti4q1s',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('tvl0d1ick3rnn7jj39qdvu6tw0lplqfe49xnwtvwlt1wui01pv', 'nmikhubotkb4v5zv0uupm5m67uq8zktaud2zb1rr36zqbobj8v', '0');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('84m655cm6hhucxgs3btby3gkczr745wzolg3dory7gie5fzehl','BABY HELLO','03djf881sti4q1s',100,'POP','2SOvWt6igzXViIjIiWNWEP','https://p.scdn.co/mp3-preview/8a9ca6c81e6e6ad48758f02017456405fd7a476d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('tvl0d1ick3rnn7jj39qdvu6tw0lplqfe49xnwtvwlt1wui01pv', '84m655cm6hhucxgs3btby3gkczr745wzolg3dory7gie5fzehl', '1');
-- Ozuna
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('9g15ww4xh2zxk10', 'Ozuna', '48@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:48@artist.com', '9g15ww4xh2zxk10', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('9g15ww4xh2zxk10', 'My name is Ozuna', 'Ozuna');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('yndim078afb9yodrhhtocxrn6wys9m15ahr0vwbkntltryn0jp','9g15ww4xh2zxk10', 'https://i.scdn.co/image/ab67616d0000b273125624f2e04f5a1ccb0dfb45', 'Ozuna Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('at23scr3q80nfc80g5cy6v5mpijqpxz9v401uo99a29kjjyl9n','Hey Mor','9g15ww4xh2zxk10',100,'POP','1zsPaEkglFvxjAhrM8yhpr','https://p.scdn.co/mp3-preview/cd2d2242b748408da15c2b66f47d54b3f0793ae0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('yndim078afb9yodrhhtocxrn6wys9m15ahr0vwbkntltryn0jp', 'at23scr3q80nfc80g5cy6v5mpijqpxz9v401uo99a29kjjyl9n', '0');
-- Chris Molitor
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('kyia49dr4l9p1u8', 'Chris Molitor', '49@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:49@artist.com', 'kyia49dr4l9p1u8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('kyia49dr4l9p1u8', 'My name is Chris Molitor', 'Chris Molitor');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('ta68d22gnlphheo5xgzu6cg226dnavjxfgvjob72tcr4fpdm78','kyia49dr4l9p1u8', 'https://i.scdn.co/image/ab67616d0000b273be011d16b9360a7dee109774', 'Chris Molitor Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('3396jhrssjb422sb4fv61th8tu9foccfg3c0t1o4rfdpglnxcz','Yellow','kyia49dr4l9p1u8',100,'POP','6tvs7zEP8d1SBgSqZQ84OT','https://p.scdn.co/mp3-preview/ea93f9b43fc638111ad661719037bfb88cd9c05d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('ta68d22gnlphheo5xgzu6cg226dnavjxfgvjob72tcr4fpdm78', '3396jhrssjb422sb4fv61th8tu9foccfg3c0t1o4rfdpglnxcz', '0');
-- Libianca
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('e21300mk3inh7o0', 'Libianca', '50@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:50@artist.com', 'e21300mk3inh7o0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('e21300mk3inh7o0', 'My name is Libianca', 'Libianca');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('31yuaic1mla1tlsgtcoi3yvvqbc3iw6j7h1x96gc9ly5uzzqoj','e21300mk3inh7o0', 'https://i.scdn.co/image/ab67616d0000b273fc342f95f117d48dbdde9735', 'Libianca Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('m26xso5mwqyvehqiugbdu2fplxtcuwquwuoijw5y9io65zmmxr','People','e21300mk3inh7o0',100,'POP','26b3oVLrRUaaybJulow9kz','https://p.scdn.co/mp3-preview/abcbc9adf10ae4901b40b80a30dc194d589c2d62?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('31yuaic1mla1tlsgtcoi3yvvqbc3iw6j7h1x96gc9ly5uzzqoj', 'm26xso5mwqyvehqiugbdu2fplxtcuwquwuoijw5y9io65zmmxr', '0');
-- Glass Animals
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('k9c5l9fkhoz2u9c', 'Glass Animals', '51@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:51@artist.com', 'k9c5l9fkhoz2u9c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('k9c5l9fkhoz2u9c', 'My name is Glass Animals', 'Glass Animals');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('mbibngpvuu4fnw8aroj28kk9hompgx1qkmnpkgueh1trwplfex','k9c5l9fkhoz2u9c', 'https://i.scdn.co/image/ab67616d0000b273712701c5e263efc8726b1464', 'Glass Animals Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('wkxrj8a4mmdjg46bj0zh2q3rz3m0gmz55tyoyvoys8ejxmr6h7','Heat Waves','k9c5l9fkhoz2u9c',100,'POP','3USxtqRwSYz57Ewm6wWRMp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('mbibngpvuu4fnw8aroj28kk9hompgx1qkmnpkgueh1trwplfex', 'wkxrj8a4mmdjg46bj0zh2q3rz3m0gmz55tyoyvoys8ejxmr6h7', '0');
-- JVKE
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('4j20wfkuaaw0xb6', 'JVKE', '52@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:52@artist.com', '4j20wfkuaaw0xb6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('4j20wfkuaaw0xb6', 'My name is JVKE', 'JVKE');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('3qlqhom99z13yt18gpjexvibadc7iw3eszazx4m08yjcn75puu','4j20wfkuaaw0xb6', 'https://i.scdn.co/image/ab67616d0000b273c2504e80ba2f258697ab2954', 'JVKE Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('f1wg80ooamtg40n7334b1birhj9oeievi2ju8g24gyem41wv3v','golden hour','4j20wfkuaaw0xb6',100,'POP','5odlY52u43F5BjByhxg7wg','https://p.scdn.co/mp3-preview/bcc17f30841d6fbf3cd7954c3e3cf669f11b6a21?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('3qlqhom99z13yt18gpjexvibadc7iw3eszazx4m08yjcn75puu', 'f1wg80ooamtg40n7334b1birhj9oeievi2ju8g24gyem41wv3v', '0');
-- The Neighbourhood
INSERT INTO `auth_user` (`id`, `username`, `email`, `created_at`) VALUES ('6gh0ooqcmreru4v', 'The Neighbourhood', '53@artist.com', '2023-11-17 17:00:08.000');
INSERT INTO `user_key` (`id`, `user_id`, `hashed_password`) VALUES ('email:53@artist.com', '6gh0ooqcmreru4v', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO `artist` (`id`, `bio`, `name`) VALUES ('6gh0ooqcmreru4v', 'My name is The Neighbourhood', 'The Neighbourhood');
INSERT INTO `album` (`id`, `artist_id`, `cover_image_url`, `name`, `created_at`) VALUES ('yt7ug4w8367drw968dj4gam7hlgzjx79a234vdgpmuyvqxcv1a','6gh0ooqcmreru4v', 'https://i.scdn.co/image/ab67616d0000b2738265a736a1eb838ad5a0b921', 'The Neighbourhood Album','2023-11-17 17:00:08.000');
INSERT INTO `song` (`id`, `name`, `artist_id`,`duration`, `genre`, `spotify_id`, `preview_url`, `created_at`) VALUES ('4udlzbdmz1v73v132lo2jdj4urbtd7fh04wnona02apmqrftml','Sweater Weather','6gh0ooqcmreru4v',100,'POP','2QjOHCTQ1Jl3zawyYOpxh6','https://p.scdn.co/mp3-preview/877602f424a9dea277b13301ffc516f9fd1fbe7e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO `album_songs`(`album_id`, `song_id`, `order`) VALUES ('yt7ug4w8367drw968dj4gam7hlgzjx79a234vdgpmuyvqxcv1a', '4udlzbdmz1v73v132lo2jdj4urbtd7fh04wnona02apmqrftml', '0');
