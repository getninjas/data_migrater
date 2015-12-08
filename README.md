# DataMigrater

## Install

Extracts the necessary files:

```bash
rails g data_migrater:install
```

Then run migrate:

```bash
rake db:migrate
```

## Usage

```bash
rails g data_migrater:data_migration name
```

Check your `db/data_migrate` folder.
