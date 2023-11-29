# Seed

This folder contains the seed scripts for the database. We are using [Vercel Postgres](https://vercel.com/docs/storage/vercel-postgres) as our database provider. 

## How To Use

1. Run the `seed/populate.sql` script to create the tables and populate the database with the seed data.

## Scripts

In order to use our scripts, you will need to install the approriate dependencies found in the root `package.json` file and README as well as provide the approriate environment variables. If you need to run our files, you can contact us for access to the main codebase.

## Notes

All tables are seeded with some values with the exception of the `password_reset` and `user_session` tables. These tables are to be used during authentication and are not seeded with any values. They have been manually tested and that process is outlined in the Project Report.