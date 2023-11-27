#!/bin/bash
bun db:setup
bun db:songs
bun db:execute seed/insert_songs.sql
bun db:relationships
bun db:execute seed/insert_relationships.sql
bun run ./scripts/create_populate_scripts.ts