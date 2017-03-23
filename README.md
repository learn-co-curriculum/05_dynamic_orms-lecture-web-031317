## CRUD Review

### Create
  + `instance#save`
  + `INSERT INTO table_name (column_names) VALUES (values_for_columns)`
### Read
  + `Class.all`
  + `SELECT * FROM table_name`
### Update
  ```ruby
  instance = Class.all.first
  instance.message #=> 'great coffee'
  instance.message =  #=> 'great coffee #'
  instance.save
  ```
  + `UPDATE table_name SET (column_names) WHERE id = ?`
### Delete
