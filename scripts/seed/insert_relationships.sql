-- Playlists
INSERT INTO `playlist` (`id`, `name`, `created_at`, `creator_id`) VALUES ('iy4tp6ist5ybe474x4hwzh2srkx6xyno424kdjmgw519xrbtle', 'Playlist 0', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('ng2yyvupw4yptre4wn6d87j0ovspp9za95137fkzttdxv5ggqx', 'iy4tp6ist5ybe474x4hwzh2srkx6xyno424kdjmgw519xrbtle', 0);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('857fz1jc9dsxewz4bho3w6aayrovtajreywnngs6lgpo7x41zz', 'iy4tp6ist5ybe474x4hwzh2srkx6xyno424kdjmgw519xrbtle', 3);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('q7bp0l4dt9a9in7khswi2zcissk0fh0n2amynsldl2tu226jei', 'iy4tp6ist5ybe474x4hwzh2srkx6xyno424kdjmgw519xrbtle', 4);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('9cy6p7hypcvjikwpu2gki4y4oo1pqgk3upv0z3hrn772wu98r4', 'iy4tp6ist5ybe474x4hwzh2srkx6xyno424kdjmgw519xrbtle', 1);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('z9hx4xt5mm18kmfweeu303nl3o6edmpsawvjvj6i7jp1cnabep', 'iy4tp6ist5ybe474x4hwzh2srkx6xyno424kdjmgw519xrbtle', 2);
INSERT INTO `playlist` (`id`, `name`, `created_at`, `creator_id`) VALUES ('lwo1a49jw1rq8a5bcsb8359sj1bpfcamws5s02ncmjsv55762c', 'Playlist 1', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('64imh4qdm2cssppqag3pa0m4jtpmb754skzbqen3cban43zp5d', 'lwo1a49jw1rq8a5bcsb8359sj1bpfcamws5s02ncmjsv55762c', 0);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('l1cme2fw3b4unh7onmzxf491yc25ikfswv5uk8rl4oygj0tltq', 'lwo1a49jw1rq8a5bcsb8359sj1bpfcamws5s02ncmjsv55762c', 1);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('g4v9ii8f41ubfu2lp5pa4g38zksd888gl9yvnqgsgi57z45dui', 'lwo1a49jw1rq8a5bcsb8359sj1bpfcamws5s02ncmjsv55762c', 2);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('ygzulg8f07a2lx43vxzp2nxlr3apndjorce9j0kuoiek37h2p7', 'lwo1a49jw1rq8a5bcsb8359sj1bpfcamws5s02ncmjsv55762c', 4);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('21c7teb0h8xasn9pyiwoind9nhc4ni1zskfshmwq6l6e0exdw4', 'lwo1a49jw1rq8a5bcsb8359sj1bpfcamws5s02ncmjsv55762c', 3);
-- User Likes
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'h9j5sg5w3wq6qj2c89rr52hc4c79ehszt01rmarzt7u3og0nbo');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'nmikhubotkb4v5zv0uupm5m67uq8zktaud2zb1rr36zqbobj8v');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', '5bv9f8r21tv40umlglr86jo48mbwmwlw32m0o2tzmzpyynd3dj');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'tkniemxw4nbzovu9mokp2djiz6047z7v8mfm73qxoh1whybmib');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'q01h19bc4wsne2ype1tjff21x7slmbxwx6w41bxpzhm3nd9d2o');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'l1cme2fw3b4unh7onmzxf491yc25ikfswv5uk8rl4oygj0tltq');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'bymu5i9s7edvhduyvvfg86wnaa7cw8jsdhruqzgkn2puufwlpa');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'yyp5l0j11bi11h8gvdsgwmzcmlbcj82okfpuzicl4ych71grly');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'ylbp2krnzvb0e4d9alh2la3hr5xzu0pohgz98497ott14ohum9');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', '9cy6p7hypcvjikwpu2gki4y4oo1pqgk3upv0z3hrn772wu98r4');
-- User Song Recommendations
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('i7vi8o8tptx0zndfmd6sjzw4d6ui6hr0nkx2yyp1xm2moizhaf', 'icqlt67n2fd7p34', '9cy6p7hypcvjikwpu2gki4y4oo1pqgk3upv0z3hrn772wu98r4', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('1y5ywrshfol3duiptv9pnurzjt5b9aqc7g2ea4o5fkxfc6pwa0', 'icqlt67n2fd7p34', '3396jhrssjb422sb4fv61th8tu9foccfg3c0t1o4rfdpglnxcz', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('y5v09kwm2ldbqi4g1m4ehcm59edze4kd1800mcqah8s1y124nd', 'icqlt67n2fd7p34', 'q01h19bc4wsne2ype1tjff21x7slmbxwx6w41bxpzhm3nd9d2o', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('j800s4vhfel8kivplawneiwaf45j97w8ok5nxjfyzomfl4skca', 'icqlt67n2fd7p34', 'vj5nh5w9ngpmut0mxns6b77u0onk5y8pkerpjleccrcun7366f', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('x6zk428nqj47p0tkcfybaarxdudbbpu1zo4zk6dl0318oicemf', 'icqlt67n2fd7p34', 'wkxrj8a4mmdjg46bj0zh2q3rz3m0gmz55tyoyvoys8ejxmr6h7', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('sfesnh6c516len79p9mb02gzwfrtjjf6bvw2xdmemybycujszm', 'icqlt67n2fd7p34', '1gm50no14c7b215ehon9vjr9rmqwt9kx6vjcckt6txd80cfxmk', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('7vro3n7jh1y7ijsx4lgnkxnx4ektcsglnlmpvvoudsgl7xcsqs', 'icqlt67n2fd7p34', 't1nt46wrg7re1snn81xcrafi1hu6ha68u00mriurv6yat78fon', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('ie3shdimpoagk9nmcur9wqbgayqlpuxsagzmbd79a6hjpyqcpj', 'icqlt67n2fd7p34', 'ji7iyrvmx88z2r4wfabby71h4l6ynrvck3ltshjpvrauv1qbmu', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('ss8gb3zxi6qzyb2qtew5olz14ra8m7gwd5x82uns2cy65ttl70', 'icqlt67n2fd7p34', 'd6fh3p8nwtbkqqms9ym4605gtst59mhv6s36x13k2jylya2k3f', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('5lz23lzxt8jq7i1ehnm63j7m3450ut7g0nxj1puqabarcrvgme', 'icqlt67n2fd7p34', '8j2avhiyfumh00men88yomb8u5zgibwad9chwzcerpdo043u2c', '2023-11-17 17:00:08.000');
