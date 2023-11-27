# CSS475 - Team MPH

This repository is for the Music Library Project for CSS475.

## Pre-requisites

- MacOS + Bun: Required to run the scripts in the `scripts` directory.

## Install pnpm and bun 

Follow the steps provided [here](https://pnpm.io/installation) to install pnpm and to install bun [here](https://bun.sh/).

## Setting Environment Variables

Create a `.env` file in the root directory of the project. Add the following variables to the file:

```bash
DATABASE_URL='mysql://'
```

## Local Environment (Foreign Key Constraints)

To run the project with foreign key constraints enabled, you need to spin up a local MySQL server using Docker compose. You can do this by running the following command:

```bash
pnpm run docker:up
```

Make sure that you have Docker installed on your machine. You can check this by running `docker -v` in your terminal. Once the MySQL server is running, make sure to add the uri to the `.env` file. Here is an example of what the uri should look like:

```bash
LOCAL_DATABASE_URL='mysql://root:123456@localhost:3306/music-library'
```

Once you've added the uri to the `.env` file, you will need to manually see the database. You can connect to your database via a MySQL client such as [TablePlus](https://tableplus.com/). Once you've connected to the database, you can use the `populate_fk.sql` in the `scripts/seed` directory to populate the database with the tables, data, and foreign key constraints.

Once the MySQL server is running and seeded, you can run the following command to start the project:

```bash
pnpm run local:dev
```

## Developing

Once you've created a project and installed dependencies with `pnpm install`, start a development server:

```bash
pnpm run dev

# or start the server and open the app in a new browser tab
pnpm run dev -- --open
```

## Building

To create a production version of your app:

```bash
npm run build
```

You can preview the production build with `npm run preview`.

> To deploy your app, you may need to install an [adapter](https://kit.svelte.dev/docs/adapters) for your target environment.

## Deployment

Live deployment: https://skypix.vercel.app
