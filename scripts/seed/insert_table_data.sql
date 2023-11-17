INSERT INTO
    `auth_user` (
        `id`,
        `username`,
        `email`,
        `created_at`
    )
VALUES
    (
        "icqlt67n2fd7p34",
        "Admin",
        "g@g.com",
        "2023-11-17 17:00:08.000"
    );

INSERT INTO
    `user_key` (`id`, `user_id`, `hashed_password`)
VALUES
    (
        "email:g@g.com",
        "icqlt67n2fd7p34",
        "s2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189"
    );