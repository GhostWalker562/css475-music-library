DROP TABLE IF EXISTS `password_reset`;

DROP TABLE IF EXISTS `user_key`;

DROP TABLE IF EXISTS `user_session`;

DROP TABLE IF EXISTS `auth_user`;

CREATE TABLE `auth_user` (
    `id` varchar(15) NOT NULL,
    `username` varchar(55) NOT NULL,
    `email` varchar(255) NOT NULL UNIQUE,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `profile_image_url` varchar(255),
    CONSTRAINT `auth_user_id` PRIMARY KEY(`id`)
);

CREATE TABLE `user_key` (
    `id` varchar(255) NOT NULL,
    `user_id` varchar(15) NOT NULL,
    `hashed_password` varchar(255),
    CONSTRAINT `user_key_id` PRIMARY KEY(`id`),
    KEY `user_key_idx` (`user_id`) -- references `auth_user` (`id`)
);

CREATE TABLE `user_session` (
    `id` varchar(128) NOT NULL,
    `user_id` varchar(15) NOT NULL,
    `active_expires` bigint NOT NULL,
    `idle_expires` bigint NOT NULL,
    CONSTRAINT `user_session_id` PRIMARY KEY(`id`),
    KEY `user_session_idx` (`user_id`) -- references `auth_user` (`id`)
);

CREATE TABLE `password_reset` (
    `id` varchar(128) NOT NULL,
    `expires` bigint NOT NULL,
    `user_id` varchar(15) NOT NULL,
    CONSTRAINT `password_reset_id` PRIMARY KEY(`id`),
    KEY `user_password_reset_idx` (`user_id`) -- references `auth_user` (`id`)
);