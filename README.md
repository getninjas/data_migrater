# Data Migrater

Data Migration is like Migrate, but it will changes the data of your tables,
not your schema. This gems creates a file where you can write code to make
change along you schema changes.

## Install

Extracts the necessary files including a migrate that create a table used
to keep you data migration version.

```bash
rails g data_migrater:install
```

Then execute the migrations to create the table.

```bash
rake db:migrate
```

## Usage

Now we can create a data migration with `name` we want.

```bash
rails g data_migrater:create name
```

Check your `db/data_migrate` folder, the data migration will be there.
Next time your application run, all pending data migration will be execute.

## Custom Logger

You can send your log to a file including the module `DataMigrater::Logger`.

```
class MyDataMigration
  include DataMigrater::Logger

  def execute
    logger.info "going to log/my_data_migration.log"
  end
end
```

By default, the class name is used and the file goes to `log` folder. You can change it:

```
class MyDataMigration
  include DataMigrater::Logger

  data_logger path: "db/data_migrate/log/global.log"

  def execute
    logger.info "going to db/data_migrate/log/global.log"
  end
end
```

#### Options

`path`: Where the log will be written.

## Test

Before send pull request, check if specs is passing.

```bash
rspec spec
```

## Code Style

And check if the code style is good.

```bash
rubocop --debug --display-cop-names
```
