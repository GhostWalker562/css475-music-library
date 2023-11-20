-- Playlists
INSERT INTO `playlist` (`id`, `name`, `created_at`, `creator_id`) VALUES ('9i6lb4p6axctt0262gl5nuxwuaixwacefqjq7zmeasx3pq75x6', 'Playlist 0', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('5xlltmj3xkadrfem48akfjif3hdbme6n2z68036uz9qgg8d1w4', '9i6lb4p6axctt0262gl5nuxwuaixwacefqjq7zmeasx3pq75x6', 0);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('hti8td9amk4y2ahpgdsonbbupfchkupm69zvruxc2h92ff3mhm', '9i6lb4p6axctt0262gl5nuxwuaixwacefqjq7zmeasx3pq75x6', 1);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('43nux21ge1789t34g4t5776xb6ccr39rh67nacwebnbnrx6arg', '9i6lb4p6axctt0262gl5nuxwuaixwacefqjq7zmeasx3pq75x6', 3);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('6no5ruwwo9h6qyvmhvvwdhzc592epqg2fjb2x3erzoyog9m9cv', '9i6lb4p6axctt0262gl5nuxwuaixwacefqjq7zmeasx3pq75x6', 4);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('xua409iaosla0gsom6mbmd0cilgnlmhwox8h2uwbnaqfrgzxgp', '9i6lb4p6axctt0262gl5nuxwuaixwacefqjq7zmeasx3pq75x6', 2);
INSERT INTO `playlist` (`id`, `name`, `created_at`, `creator_id`) VALUES ('wwz5xpmxgrzqibdavayjrapcdfx4cuzq2hhcghyyscadpwnt91', 'Playlist 1', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('j80p6yupb2rvzuyp6nqd7hyy75zqgs7dwq349chfm5p66yyfh1', 'wwz5xpmxgrzqibdavayjrapcdfx4cuzq2hhcghyyscadpwnt91', 0);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('oaxqphkwz8vw1g40d6qopdz9cz9a10fr4qt2ksrrrvr9kvls89', 'wwz5xpmxgrzqibdavayjrapcdfx4cuzq2hhcghyyscadpwnt91', 1);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('4gy6ezd7r4xyih7w6soveo2v7zkgs4rye45wruvgbymuvtgz1b', 'wwz5xpmxgrzqibdavayjrapcdfx4cuzq2hhcghyyscadpwnt91', 4);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('6no5ruwwo9h6qyvmhvvwdhzc592epqg2fjb2x3erzoyog9m9cv', 'wwz5xpmxgrzqibdavayjrapcdfx4cuzq2hhcghyyscadpwnt91', 3);
INSERT INTO `playlist_songs` (`song_id`, `playlist_id`, `order`) VALUES ('uuyo2ydok0mw4kldawl1azua0lrnrptnyl8y7pr9d5xkc3civ8', 'wwz5xpmxgrzqibdavayjrapcdfx4cuzq2hhcghyyscadpwnt91', 2);
-- User Likes
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', '4gy6ezd7r4xyih7w6soveo2v7zkgs4rye45wruvgbymuvtgz1b');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', '9plisskxarqf51nof14mak4tl2a1u942vj6mkd1ojqchkakoa7');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', '65dlz7cnjv3islplf8l113e2r4nmk8pxrq5i3pw28x8c8uyt7j');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'teg7rsfsdyix51mfams67i5tmixy7rzu86m7itue05z3cqe7ce');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'xua409iaosla0gsom6mbmd0cilgnlmhwox8h2uwbnaqfrgzxgp');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', '6no5ruwwo9h6qyvmhvvwdhzc592epqg2fjb2x3erzoyog9m9cv');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'cj1mqvrr28eozbm8x1j93qz3275lh0rd1qcvees28v7enpuel1');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'vc2sad1ynuefglfhwp3g7uec92352uflupbjc0ibs8p29oge7j');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'hti8td9amk4y2ahpgdsonbbupfchkupm69zvruxc2h92ff3mhm');
INSERT INTO `user_likes` (`user_id`, `song_id`) VALUES ('icqlt67n2fd7p34', 'o7lhk2qcqxypek5fwi4n1ru1lre4gbwqznk5f9fwmbc624ixe5');
-- User Song Recommendations
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('eb26sxmwqgpmaxn7toagdn0aam34oj2plud9iyr83lpx4savni', 'icqlt67n2fd7p34', '09x79mwb015ccwhp6d1dhuv97f1ylc6wtgggo87rv57xfazbdb', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('pawinsipf844s74tqgmscbjakn0s4516wtow597ej5o0hag6mm', 'icqlt67n2fd7p34', 'uuyo2ydok0mw4kldawl1azua0lrnrptnyl8y7pr9d5xkc3civ8', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('bra5qwbi35oomnfzcvu35xyfgggj1sjaxyycfz8wlg4igghtkm', 'icqlt67n2fd7p34', 'urbk7n6vsv08fpyy7dp3sxgstik7bd8hi2vd60281jbaz541p7', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('5mwkgtzgezlrgpx1iaysh8s3txpxo6367j5iwpmspc85u0yka8', 'icqlt67n2fd7p34', 'oaxqphkwz8vw1g40d6qopdz9cz9a10fr4qt2ksrrrvr9kvls89', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('3s3okeztupce4y9hf9qrytylvgef0ti0isjyl38zmqninehffh', 'icqlt67n2fd7p34', '5xlltmj3xkadrfem48akfjif3hdbme6n2z68036uz9qgg8d1w4', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('96s3pg380fezyogvtoygmktji89t8y00z3uf2dl1m209a51q0c', 'icqlt67n2fd7p34', 'cj1mqvrr28eozbm8x1j93qz3275lh0rd1qcvees28v7enpuel1', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('bowqfpvv300edasqjvwy727d82jcjmbyaakd2arz0e4fjwvku7', 'icqlt67n2fd7p34', 'kjaww1sa5a6x26xhyv9w42lpt2hntfu4s3kdax4qz4d9eqaodv', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('n0rqw1eupxp4dx3yabkmc04xovuxhqmra5jllgcgo3e6vq5ebi', 'icqlt67n2fd7p34', 'pn1zpz8k4uler1793dy0jqwad8bdaoly3tcjf5s8482pij1mui', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('e1x0cjhosp25ogsctzflzvs79o0d2spgs6791hzthrvzjajlx3', 'icqlt67n2fd7p34', 'dfcljmbuywiz4tpdl9v9iidasl9qof8lhedhkseszb90n2dhzh', '2023-11-17 17:00:08.000');
INSERT INTO `user_song_recommendations` (`id`, `user_id`, `song_id`, `created_at`) VALUES ('4ids8ldkpoi5d47mw1wzbv96pe92q3x1e27c12fvnhu4qev91y', 'icqlt67n2fd7p34', '65dlz7cnjv3islplf8l113e2r4nmk8pxrq5i3pw28x8c8uyt7j', '2023-11-17 17:00:08.000');
