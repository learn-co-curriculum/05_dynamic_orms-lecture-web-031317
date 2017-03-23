# Our Classes should correspond to tables in our database
# columns should correspond to attributes
# instances of classes should correspond to rows

class Tweet # tweets with columns message and username and id
  attr_accessor :message, :username, :id

  def self.all
    # This method needs to search the database for all of data about the tweets
    sql = <<~SQL
    SELECT *
    FROM tweets
    SQL

    # 1. Fire some SQL - this will return some data in the form of an array of hashes
    results = DB[:conn].execute(sql)
    # This will return an array that looks like this:
    # [{id: 5, username: 'coffeedad', message: 'Great # coffee'}, {id: 6, username: 'coffeedad', message: 'need coffee'}]
    # iterate over that array and create a new Tweet for each hash that I get back

    # 3. Return an array of all of those instantiated tweets
    results.map do |row|
      self.new(row) #=> {id: 9, username: 'coffeedad', message: 'Great coffee'}
    end
  end

  def initialize(options={})
    @message  = options['message']
    @username = options['username']
    @id = options['id']
  end

  def description
    "#{username} says #{message}"
  end

  def save
   # Whenever we call save on an instance
  # If it's a new instance
    # Inssert a new row in the DB
  # otherwise
    # update the existing row with my new values
  end
end

t = Tweet.new({'username'=> 'coffeedad', 'message' => 'Hello'})
t.save
