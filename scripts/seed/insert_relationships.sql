-- Playlists
INSERT INTO `playlist` (`id`, `name`, `created_at`, `creator_id`) VALUES ('hjh3hvnnu1nskt2oqfonvut9vs2pfh3wc63w1ol2eg9n22uois', 'Playlist 0', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('945yswdakixfen1imd4rfonevo5uvlead3828wryu3fgze9fb7', 'hjh3hvnnu1nskt2oqfonvut9vs2pfh3wc63w1ol2eg9n22uois', 0);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('do9jrypk3n3rka960iapu16tbv47wu92fddc5hisnk396egoa5', 'hjh3hvnnu1nskt2oqfonvut9vs2pfh3wc63w1ol2eg9n22uois', 3);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('4vggfg753is01tmzgexgzsjpf7db02qeediou7my1l72ldwu9f', 'hjh3hvnnu1nskt2oqfonvut9vs2pfh3wc63w1ol2eg9n22uois', 2);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('0k8oo4vpjwh6itnj6nmdpfmahp26tpi29ataqf10kstfj5ljz5', 'hjh3hvnnu1nskt2oqfonvut9vs2pfh3wc63w1ol2eg9n22uois', 1);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('5315edpsv5g46qgwmz95mrn4fu86ks6bjt45i7wcq6hecbqzyj', 'hjh3hvnnu1nskt2oqfonvut9vs2pfh3wc63w1ol2eg9n22uois', 4);
INSERT INTO `playlist` (`id`, `name`, `created_at`, `creator_id`) VALUES ('nlb0aef125s23aq4zbj96a3ql2gelphkhf93barswamo03tr7m', 'Playlist 1', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('m70mibs7yfdlxu0kas9rcidyeaqf03p783uukzm4zeun9mq9om', 'nlb0aef125s23aq4zbj96a3ql2gelphkhf93barswamo03tr7m', 0);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('nuudn8m8eqdx1zfsb4h5x1x8t5dn88a8lm17i0jh0ef9i5dubd', 'nlb0aef125s23aq4zbj96a3ql2gelphkhf93barswamo03tr7m', 3);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('klix2lv0dv31gnm0rg59kpkzyfknmuwplowkqdoss1cncke06h', 'nlb0aef125s23aq4zbj96a3ql2gelphkhf93barswamo03tr7m', 4);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('r9nq4plpw3yw4czjcb8vgxdlzoxflwqc68fqv9jgv9wyj85w5z', 'nlb0aef125s23aq4zbj96a3ql2gelphkhf93barswamo03tr7m', 1);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('ix5wfejy0j2rfblc443n6oi3rr5jytq173t86pezgbpcjiqdox', 'nlb0aef125s23aq4zbj96a3ql2gelphkhf93barswamo03tr7m', 2);
-- User Likes
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'mvv2i5f0qzeuk8krc1mgt2oz4imkr4w616ec53sr998hxw5ym0');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'kfmfelg0f94xznvt90efvunp2nrr4zmt6e1siocugzvy2pyxbo');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'z895jr3zh1capfzxdfsmpibe609und16sqe0osy4mqj3tggyi5');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'w9z3w60nhoekjaacmnrng8mmfjtjz07hjme1qhg9jrfpo4r1z1');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'r9nq4plpw3yw4czjcb8vgxdlzoxflwqc68fqv9jgv9wyj85w5z');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'uu8ibsafrhfgzfs2qu7e5k07tua0dg1vpdiwi3h4atbmvnqq1i');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'iqrsiqtubg20txklfy28um6lhcywtwb0l2dnb243ty0vfufux2');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'd22mr0glohujzc3h5kfm8mmunxkaavbwyhqry6dwhtmbj779lt');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'ctxm2j71h9aprs6rwzqnanc83zk9uoyopq76aib5g0gdv3u9qo');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'rurfx08ptiziknoidhugvg5g4dficmzb2es63h1hrtg5ygn7if');
-- User Song Recommendations
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('tz37k2ovs1cu5ga9tdgk3yniqbfgixinym4kpl9g6pdpx26884', 'icqlt67n2fd7p34', '9t1hf0tp3cxq6c6po9t9qyzdquy6biy7dp4ntpo22eclo434gc', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('bceoz4mgfrrxoviejodocuthnecc6j9wu64xw4a3ui0gaclyyb', 'icqlt67n2fd7p34', 'altmctgmw45i7lhml6xmck05iv2anmdj6nz7moor4ta3njiydf', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('fzyzjf2kpem3iz6mo13w4du2fe3y08ng9wrcwkr3cvkb0zgjb6', 'icqlt67n2fd7p34', 'zvkia55dkh4alyacicoyzj01ozf4arty60j4yexo7jr4tkdyt9', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('4616ix1owibfi1flndu10o22gtbemxlni3g8640gpgymmzrmeu', 'icqlt67n2fd7p34', 'igi17avvwx7kkhyr0x9cgp1aafqpzbk03hikwhpjuhigmobbxn', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('ok07ztd8p73w28vrrozk9scml3eihur7gdgfu7ghbr85974kcj', 'icqlt67n2fd7p34', '6kfyy1dx56pzl7k5lypxj2csa1kkl5lljgvutwsahimfoyuofo', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('e92yggaxp75im7cclflln58ib5wv666whc34c9dpsj5kyjx2kl', 'icqlt67n2fd7p34', 'yw6qlcyhbr5t8cnu3mora6rld4c8o9f25ejt2b34x4drvyihoe', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('jbhgcq3xyxuvztx35g7kvy5hyp19td7lb3wtxk04gbcw2p9rfu', 'icqlt67n2fd7p34', 'nhlnauh4zrpkwax0awhxu4qf007669570fmnikcg2ji201ntf5', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('2cxv3r69bvtq7qi2xqyau7gjlkm7m32v6ru9z1ijdvvtxdfai2', 'icqlt67n2fd7p34', '61rpz464xuvhp5qq7jmggypwrcoi8qb10vt5mq1lsqi1do0ome', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('9b8ut98jsbvu64p63dz1je0p2y1qvdjuavj1aqzjg8gqgjdtrr', 'icqlt67n2fd7p34', 'ikho511zuj2pkdxzx5u12a0t0i36pgzhm0fxlauozwhtphe478', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('mb1m626uhq7ld4y2x2kk4zre02u515398ded7zdrrs9wxgi9qh', 'icqlt67n2fd7p34', 'do9jrypk3n3rka960iapu16tbv47wu92fddc5hisnk396egoa5', '2023-11-17 17:00:08.000');
