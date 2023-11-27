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
