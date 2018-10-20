<p align="center">
  <a href="http://www.gistcatch.com">
    <img height="150" width="150" src="https://github.com/enderahmetyurt/gistcatch/blob/master/public/logo.png?raw=true">
  </a>
</p>

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

Step 3: Configure your database

```
cp config/database.yml.example config/database.yml
vim config/database.yml # or leave it to use sqlite3 for development
```

Step 4: Create your own [GitHub App](https://github.com/settings/applications/new) and create `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` environment variables.

Step 5: Create and migrate database `rails db:create db:migrate`

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
