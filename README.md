# CSS475 - Team MPH

This repository is for the Music Library Project for CSS475.

# Skypix 

Skypix is a music library that allows users to create playlists, add songs to their library, and share their music with friends. Users can also follow other users and view their music libraries.

## Technologies Used

## Frontend
- [SvelteKit](https://kit.svelte.dev/)
- [TailwindCSS](https://tailwindcss.com/)
- [PostgreSQL](https://www.postgresql.org/)
- [Drizzle](https://orm.drizzle.team/)
- [Lucia](https://lucia-auth.com/)
- [shadcn-svelte](https://www.shadcn-svelte.com/)

## Hosting
- [Cloudinary](https://cloudinary.com/)
- [Vercel](https://vercel.com/)

## Package Manager
- [Bun](https://bun.sh/)
- [pnpm](https://pnpm.io/)

## APIs
- [Spotify API](https://developer.spotify.com/documentation/web-api/)

## Misc
- [Sendgrid](https://sendgrid.com/)
- [PostHog](https://posthog.com/)

## Languages
- [TypeScript](https://www.typescriptlang.org/)
- [SQL](https://www.w3schools.com/sql/)
- [HTML](https://www.w3schools.com/html/)
- [CSS](https://www.w3schools.com/css/)
- [JavaScript](https://www.javascript.com/)

## Pre-requisites

- MacOS + Bun: Required to run the scripts in the `scripts` directory.

## Install pnpm and bun 

Follow the steps provided [here](https://pnpm.io/installation) to install pnpm and to install bun [here](https://bun.sh/).

## Setting Environment Variables

Create a `.env` file in the root directory of the project. Add the following variables to the file (or reference the `.env.example` file):

```bash
POSTGRES_URL=''
POSTGRES_PRISMA_URL=''
POSTGRES_URL_NON_POOLING=''
POSTGRES_USER=''
POSTGRES_HOST=''
POSTGRES_PASSWORD=''
POSTGRES_DATABASE=''

EMAIL_API_KEY=''
GITHUB_CLIENT_ID=''
GITHUB_CLIENT_SECRET=''
SPOTIFY_CLIENT_ID=''
SPOTIFY_CLIENT_SECRET=''
CLOUDINARY_CLOUD_NAME=''
PUBLIC_CLOUDINARY_APP_ID=''
PUBLIC_CLOUDINARY_UPLOAD_PRESET=''
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
pnpm run build
```

You can preview the production build with `pnpm run preview`.

> To deploy your app, you may need to install an [adapter](https://kit.svelte.dev/docs/adapters) for your target environment.

## Deployment

Landing Page Deployment: https://skpi.vercel.app/

Live deployment: https://skypix.vercel.app
