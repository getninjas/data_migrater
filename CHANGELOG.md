## v1.1.0

### Fixes

- Does not raise error when file does not exist locally;
- Does not try to delete a non existent file locally.

### Updates

- `csv_delete` now deletes the local file too.

## v1.0.0

### Break

- Removes the `tmp_dir` options, now the file will be download at `path` place.

### Fixes

- Do not raise error when S3 file does not exist;

### News

- Uses `us-east-1` as default region for S3 module;
- Adds `csv_delete` method to be able to delete the S3 file.

### Updates

- Uses new syntax of SDK S3.

## v0.7.0

### News

- Bump aws-sdk dependency to v3
- Bump Ruby version compatibilities
- Rails 5.2 compatibility

## v0.6.0

### News

- Adds `ENV['DATA_MIGRATER']` to controller the Data Migrater run;
- Bump Ruby to 2.4.3.

## v0.5.0

### Fixes

- Fix CSV and Logger variable conflict; [tmartinelli]

### News

- Adds S3 CSV file support;

## v0.4.0

### News

- Add Rails 5 support;
- Bump Ruby until 2.4.1.

## v0.3.0

### News

- Added support for CSV;
- Added options `dir` to specify the directory on Logger;
- Added options `file` to specify the Logger file name.

## v0.2.0

### News

- Added support for custom logger.

## v0.1.1

### Fixes

- Fixed `require` name on `bin` script.

## v0.1.0

### News

- Rails 4 support.
