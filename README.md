# Data Migrater

[![Build Status](https://travis-ci.org/getninjas/data_migrater.svg)](https://travis-ci.org/getninjas/data_migrater)
[![Gem Version](https://badge.fury.io/rb/data_migrater.svg)](https://badge.fury.io/rb/data_migrater)

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

```ruby
class MyDataMigration
  include DataMigrater::Logger

  def execute
    logger.info "going to log/my_data_migration.log"
  end
end
```

By default, the class name is used and the file goes to `log` folder. You can change it:

```ruby
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

```ruby
class MyDataMigration
  include DataMigrater::CSV

  def execute
    csv.each do |line|
      Object.create! line
    end
  end
end
```

By default, the class name is used and the file is parsed from `db/data_migrate/support/csv` folder. You can change it:

```ruby
class MyDataMigration
  include DataMigrater::CSV

  data_csv path: '/tmp/objects.csv'

  def execute
    csv.each do |line|
      Object.create! line
    end
  end
end
```

You can process a batch of items using the `chunk_size`:

```ruby
class MyDataMigration
  include DataMigrater::CSV

  data_csv chunk_size: 2

  def execute
    # [
    #   { first_name: 'Washington', last_name: 'Botelho' },
    #   { first_name: 'Vanessa'   , last_name: 'Queiroz' }
    # ]
    csv.each { |line| Object.create line }
  end
end
```

You can rename the keys inside the iterated data using the option `key_mapping`:

```ruby
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

- `dir`: Directory where CSV is located, by default `db/data_migrate/support/csv`;
- `file`: File name, by default is the class name underscored: `my_data_migration.csv`;
- `path`: Composition of `dir` + `/` + `file` when you want give a fully qualified path.

---

##### CSV Options

- `chunk_size`: Batch parse size;
- `key_mapping`: Key name alias.

For more CSV options, check the project [Smarter CSV](https://github.com/tilo/smarter_csv):

## S3

You can download your CSV directly from [Amazon S3](https://aws.amazon.com/s3) using the module `DataMigrater::CSV` with some configs. You *must* set `provider` as `:s3` to activate S3 feature.

```ruby
class MyDataMigration
  include DataMigrater::CSV

  data_csv bucket: 'my-bucket', provider: :s3

  def execute
    csv.each { |line| Object.create line }
  end
end
```

### Credentials

By default, when you use the S3 feature, the envs `ACCESS_KEY_ID`, `REGION` (default `us-east-1`) and `SECRET_ACCESS_KEY` will be used.
If you do not want export it globally and need to pass it inside you class, just declare de `credentials` options:

```ruby
class MyDataMigration
  include DataMigrater::CSV

  data_csv provider: :s3, credentials: {
    access_key_id:     'foo',
    region:            'us-east-1',
    secret_access_key: 'bar'
  }

  def execute
    csv.each { |line| Object.create line }
  end
end
```

### CSV Delete

You can delete the S3 and local file from your migration after process the CSV.

```ruby
class MyDataMigration
  include DataMigrater::CSV

  data_csv provider: :s3

  def execute
    csv.each { |line| Object.create line }

    csv_delete
  end
end
```

#### S3 Options

- `bucket`: The bucket name. By default `data-migrater`.
- `credentials`: AWS credentials: `access_key_id`, `region` and `secret_access_key`;
- `provider`: `:s3` to indicate the S3 provider;

#### Skip Run

You can use `ENV` to prevent Data Migrater to run. By default, `RAILS_ENV` as `test` already prevents it.

```bash
DATA_MIGRATER=false rails s
```
