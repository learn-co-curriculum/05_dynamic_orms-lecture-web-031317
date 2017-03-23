class LiveRecord

  def self.columns
    sql = <<-SQL
    PRAGMA table_info (#{self.table_name})
    SQL
    results = DB[:conn].execute(sql)
    results.map {|col_info| col_info["name"] }.compact
  end

  def column_names_for_update
    columns = self.class.columns.reject {|col| col == 'id'}
    columns.map do |column| #['message', 'username']
      "#{column} = '#{self.send(column)}'"
    end.join(', ')
  end

  def self.define_attributes
    self.columns.each do |attribute|
      attr_accessor attribute
    end
  end

  def self.table_name
    self.to_s.downcase + "s"
  end

  def self.all
    sql = <<-SQL
    SELECT *
    FROM #{self.table_name}
    SQL
    results = DB[:conn].execute(sql)
    results.map do |row|
      row = row.select {|k, v| self.columns.include?(k) }
      self.new(row)
    end
  end

  def initialize(options={})
    allowed_attributes = options.reject do |attribute, value|
      attribute == 'id'
    end
    allowed_attributes.each do |attribute, attribute_value| #attribute :message, 'great_coffee'
      self.send("#{attribute}=", attribute_value)
    end
    @id = options['id']
  end

  def save
    if self.persisted?
      update
    else
      create_row
    end
  end

  def update
    sql = <<-SQL
    UPDATE #{self.class.table_name} SET #{self.column_names_for_update}
    WHERE id = ?
    SQL
    puts sql
    DB[:conn].execute(sql, self.id)
    self
  end

  def persisted?
    !!self.id
  end

  private

  def create_row
    sql = <<-SQL
    INSERT INTO #{self.class.table_name} (#{column_names_for_insert})
    VALUES (#{values_for_insert})
    SQL
    DB[:conn].execute( sql)
    id_sql = <<-SQL
    SELECT * FROM #{self.class.table_name}
    ORDER BY id DESC
    LIMIT 1
    SQL
    id_results = DB[:conn].execute(id_sql)
    @id = id_results.first['id']
    self
  end

  def columns_for_insert
    self.class.columns.reject {|col| col == 'id'}
  end

  def column_names_for_insert
    columns_for_insert.join(', ')
  end

  def values_for_insert
    columns_for_insert.map {|col| "'#{self.send(col)}'" }.join(', ')
  end

end
