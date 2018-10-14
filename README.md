# Gistcatch

Catch gists from your Github followers and followings...

## Requirements

- Ruby 2.5.1
- A [GitHub application](https://github.com/settings/applications/new) for authentication

## Installation

### Manual

Step 1: Clone the repository by:

```shell
git clone git@github.com:enderahmetyurt/gistcatch.git && cd gistcatch
```

Step 2: Install dependencies with `bundle install`

Step 3: Create and migrate database `rails db:create db:migrate`

### docker-compose

Firstly, you should be sure docker installed on your OS.

Copy `.env_example` to `.env` and edit content. After that you can run by the following command:

```shell
docker-compose up --build
```

You should run migration commands after that by:

```shell
docker-compose run web rails db:migrate
```
