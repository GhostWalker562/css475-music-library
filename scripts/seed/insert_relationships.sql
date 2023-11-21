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
