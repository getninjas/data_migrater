def delete(file_name)
  File.delete File.expand_path("../#{file_name}", __dir__)
end
