-- Playlists
INSERT INTO `playlist` (`id`, `name`, `created_at`, `creator_id`) VALUES ('82pci3k2tmbpqof3in8s6jlrxkig5fr9gwoym1vymnsjyfwl84', 'Playlist 0', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('yczlfzigq17nqkggq8t1p8qprnywvbvkr3b7s7j8emzqz9mgak', '82pci3k2tmbpqof3in8s6jlrxkig5fr9gwoym1vymnsjyfwl84', 0);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('mj0hghsc02j6rke05w3ujgcv8s9021hhc0467d6kr57rn8s6zc', '82pci3k2tmbpqof3in8s6jlrxkig5fr9gwoym1vymnsjyfwl84', 1);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('as7r05tjksb5tcr4ea1dnbrrshp3zc1h963p03ztus3igd8f4n', '82pci3k2tmbpqof3in8s6jlrxkig5fr9gwoym1vymnsjyfwl84', 4);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('4lnmhdtt1vrod3dmxvw7dgrt187xq7c1y27p5gn32ss7ig534q', '82pci3k2tmbpqof3in8s6jlrxkig5fr9gwoym1vymnsjyfwl84', 3);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('1n8pc3acpymhldp8g08jsa53zl047c4hjlbz7x0ul4j6s0kb68', '82pci3k2tmbpqof3in8s6jlrxkig5fr9gwoym1vymnsjyfwl84', 2);
INSERT INTO `playlist` (`id`, `name`, `created_at`, `creator_id`) VALUES ('q2v2j2m6ew9z1f8etvtfmccurwhlsx2riagb9p7mll40iu3znn', 'Playlist 1', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('qzfkhh6cfskytc7dq74b3zsnz4roctxymohzos7d6g8z1k45kf', 'q2v2j2m6ew9z1f8etvtfmccurwhlsx2riagb9p7mll40iu3znn', 1);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('hpcor8rgwh2xpnno5hl606lgs282f4tvprytjyyli5xjcwee1k', 'q2v2j2m6ew9z1f8etvtfmccurwhlsx2riagb9p7mll40iu3znn', 0);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('tcwenzxr94hv4yi163nifeo5wx8fc4ybk6e8cktm1is5wqb7eb', 'q2v2j2m6ew9z1f8etvtfmccurwhlsx2riagb9p7mll40iu3znn', 3);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('xdi59yzw5yburm99ijmbs2681m85mv0reykrnzk4u3mkjb7mn2', 'q2v2j2m6ew9z1f8etvtfmccurwhlsx2riagb9p7mll40iu3znn', 4);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('0dr10n51o1jyd9jjx3d1m22yfcde1f2l7lvsfeo76809pmplp9', 'q2v2j2m6ew9z1f8etvtfmccurwhlsx2riagb9p7mll40iu3znn', 2);
-- User Likes
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'avi7wvpdmeyfh9q12je9kv9fh3smcc7zf77a723d5mfpybgb76');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'xdc3utnkitmsql303qof5btaqo4pjzgkp0f5t4j811yonvvnhs');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'l9t8rkpmn5rktdiuxr9zv3dc9w00xraibub5ayhv32pqlcmmtl');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', '5dutmndbyn8q0dmucstrz53ptq1jkhx5sv5r7lw1qz7urup13d');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'ji7wswvngmoub9uc70u00209gvb8vurila50j6biucvpcvbpzk');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'mj0hghsc02j6rke05w3ujgcv8s9021hhc0467d6kr57rn8s6zc');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'veppoue0upmouf9b23nw1vfkoy1r77uqosudce8sd9zs6mvf9a');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'n8mgd7d4880pzz6bafsyv50kf2288umr5nwjlkiqxf7hefo0i9');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'rc5wwapdmxp02k71cletxsbzvlxj335fcm8zxbh7itowvou3hs');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'bs0zaziv8xzv65l0yk88109ar9bir6821zohk8cm4r6g0h15kt');
-- User Song Recommendations
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('63u49qzn7ut3z5ddo3khqmx2aodal7tjemfbqq64ktmldq5t54', 'icqlt67n2fd7p34', '89y4706qyjxl9cduvz95dmha8c2udpp1i8e2fnyda3byibnjjf', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('1r4totp2lfxh081l4tpshzxamw6et6fce5cdvre028hwsufv0s', 'icqlt67n2fd7p34', 'yczlfzigq17nqkggq8t1p8qprnywvbvkr3b7s7j8emzqz9mgak', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('4072aki20lcgwaqvujp1fus6tfma60wgcrcj4mmcv9rhxx1xc0', 'icqlt67n2fd7p34', '580mwigf1v5ly6d8w4oodh03aub8bcd7aekpt4goxwofqx3jm9', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('u5rm42ljbimglyactrwvkw79s4uccv3aypod4t33apkeaqfqnw', 'icqlt67n2fd7p34', 'xdc3utnkitmsql303qof5btaqo4pjzgkp0f5t4j811yonvvnhs', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('fqichldnoykseykrso7h68linykk1ebrxnx6krgn0xfg17cper', 'icqlt67n2fd7p34', 'hpcor8rgwh2xpnno5hl606lgs282f4tvprytjyyli5xjcwee1k', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('4fwuo6sojwwxewivxfko828upa46b0woori2mknui46dfc3j9f', 'icqlt67n2fd7p34', 'yf13oco1nga8if03ohp4rsyp2n3tiuuxuecz6xsjtlmrzyg0mk', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('96sclyqu1oh87wu2c61cj9eattrkwryir39u6926c99su5idyf', 'icqlt67n2fd7p34', 'rkargqjsn50t5v8ipjhiijet58hmrdzlshcf9h77h0t9p6k7fh', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('e83t1lf0espkf1kq80eoc6zpdw1xf3hf3nvrbjl2gzfaxaxqxz', 'icqlt67n2fd7p34', 'dsv040jgvfq3lzpn74ixbhpkc0ozpp53lu7tmprnlpxnwol9t8', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('vdavgg13la1ijtlax7yfcoi30ergn2ydow33hgbx0pfuobv4tr', 'icqlt67n2fd7p34', '93z5nw8osgaihltnt77mdd4f78r8qcahmqa1yl38omxd2iq9tw', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('0bmvpfupgcu1o2iulz63vnr3b0zpb7i7ie19c1wl3ey719ucpv', 'icqlt67n2fd7p34', 'rx9zsfhz3pv0g1h3ivxfh29vshel1m69buxrkvjd772anhg897', '2023-11-17 17:00:08.000');
