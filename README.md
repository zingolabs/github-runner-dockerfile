# Github Actions Runner (Dockerized)

## How to use:

1. Get a PAT (Pesonal Access Token) from Github that has administration permissions on the repo you want the image to run actions for.
2. Store that token in `secret.txt` on the root directory.
3. Copy the `.env.example` into `.env` on the root directory and replace the value for the actual repo to target.
4. Run ```docker compose up -d``` to start the container.
5. Once the container is up and running, you should be able to find it in Github under the repo's runners listing.

The runner removes itself from github if stopped gracefully.

## Next features
- [ ] Have mounted volumes/databases to store run logs
