module DBX::Driver
  autoload(:Abstract, 'dbx/driver/abstract')
  autoload(:MySQL, 'dbx/driver/mysql')
  autoload(:Postgres, 'dbx/driver/postgres')
end
