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
Next time your application run, all pending data migration will be executed.

## Logger

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

- `dir`: Directory where log will be;
- `file`: File name;
- `path`: Composition of `dir/file` when you want give a fully qualified path. Default: `log/class_name.log`.

## CSV

You can parse CSV on the fly using the module `DataMigrater::CSV`.

```
class MyDataMigration
  include DataMigrater::CSV

  def execute
    # parsed from `db/data_migrate/support/csv/my_data_migration.csv`
    csv.each do |line|
      Object.create! line
    end
  end
end
```

By default, the class name is used and the file is parsed from `db/data_migrate/support/csv` folder. You can change it:

```
class MyDataMigration
  include DataMigrater::CSV

  data_csv path: "/tmp/objects.csv"

  def execute
    # parsed from `/tmp/objects.csv`
    csv.each do |line|
      Object.create! line
    end
  end
end
```

You can process a batch of items using the `chunk_size`:

```
class MyDataMigration
  include DataMigrater::CSV

  data_csv chunk_size: 2

  def execute
    csv.each do |line|
      # line:
      #
      # [
      #   { first_name: 'Washington', last_name: 'Botelho' },
      #   { first_name: 'Lucas'     , last_name: 'Souza' }
      # ]

      Object.create! line
    end
  end
end
```

You can rename the keys inside the iterated data using the option `key_mapping`:

```
class MyDataMigration
  include DataMigrater::CSV

  data_csv key_mapping: { first_name: :first }

  def execute
    csv.each do |line|
      Object.create! line # { first: 'Washington', last_name: 'Botelho' }
    end
  end
end
```

#### Options

- `dir`: Directory where CSV is located;
- `file`: File name;
- `path`: Composition of `dir/file` when you want give a fully qualified path. Default: `db/data_migrate/support/csv/class_name.csv`.

---

##### CSV Options:

- `chunk_size`: Batch parse size;
- `key_mapping`: Key name alias.

For more CSV options, check the project [Smarter CSV](https://github.com/tilo/smarter_csv):

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
