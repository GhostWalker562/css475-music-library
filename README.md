# CSS475 - Team MPH

This repository is for the Music Library Project for CSS475.

## Pre-requisites

- MacOS + Bun: Required to run the scripts in the `scripts` directory.

## Install pnpm and bun 

Follow the steps provided [here](https://pnpm.io/installation) to install pnpm and to install bun [here](https://bun.sh/).

## Setting Environment Variables

Create a `.env` file in the root directory of the project. Add the following variables to the file:

```bash
POSTGRES_URL='postgres://'
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
