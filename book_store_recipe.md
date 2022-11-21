{{TABLE NAME}} Model and Repository Classes Design Recipe

Copy this recipe template to design and implement Model and Repository classes for a database table.

1. Design and create the Table

2. Create Test SQL seeds

3. Define the class names

# EXAMPLE
# Table name: books

# Model class
# (in lib/book_store.rb)
class Books
end

# Repository class
# (in lib/books_store_repository.rb)
class BooksRepository
end

4. Implement the Model class

# Table name: books

# Model class
# (in lib/book_store.rb)

class Books
  attr_accessor :id, :title, :author_name
end

5. Define the Repository Class interface

# Table name: books

# Repository class
# (in lib/boos_store_repository.rb)

```ruby

class BooksRepository

  # Selecting all books
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, author_name FROM books;

    # Returns an array of book objects.
  end

  # Gets a single book by its ID
  # One argument: the id
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, author_name FROM books WHERE id = #{id};

    # Returns a single book object.
  end

  # Adds a book to the books table
  # One argument: books, an instance of the Books class
  def create(title, author_name)
    # Executes the SQL query:
    # INSERT INTO books (title, author_name) VALUES (#{title}, #{author_name});

    # Returns array with book added
  end

  # Deletes a book from the books table by id
  # One argument: the id
  def delete(id)
    # Executes the SQL query:
    # DELETE FROM books WHERE id = #{id};

    #Returns array with book deleted
  end

end

```

6. Write Test Examples

```ruby

# 1
# Get all books

repo = BooksRepository.new

shelf = repo.all

shelf.length # =>  5

shelf[0].id # =>  1
shelf[0].title # =>  'Nineteen Eighty-Four'
shelf[0].author_name # =>  'George Orwell'

shelf[-1].id # =>  5
shelf[-1].title # =>  'The Age OF Innocence'
shelf[-1].author_name # =>  'Edith Wharton'

# 2
# Get a single book by id

repo = BooksRepository.new

book = repo.find(3)

book.id # =>  3
book.name # =>  'Emma'
book.author_name # =>  'Jane Austen'

# 3
# Insert a book into the table

repo = BooksRepository.new

repo.create('title1', 'author1')

shelf = repo.all
shelf.length # => 6
shelf[-1].id # => 6
shelf[-1].title # => 'title1'
shelf[-1].author_name # => 'author1'

# 4
# Removing a single book by id

repo = BooksRepository.new

repo.delete(3)

shelf = repo.all
shelf.length # => 4
shelf[3].id # => 4
shelf[3].title # => 'Dracula'
shelf[3].author_name # => 'Bram Stoker'

# 5 
# return empty list if no books

repo = BooksRepository.new

repo.delete(1)
repo.delete(2)
repo.delete(3)
repo.delete(4)
repo.delete(5)

shelf = repo.all

shelf.length # => 0

# 6 
# search by id that doesnt exist  

repo = BooksRepository.new

book = repo.find(6) # => error

# 8 
# delete by id that doesnt exist

repo = BooksRepository.new

repo.delete(6) # => error

# 9 
# search by a string with no matches

repo = BooksRepository.new

result = repo.search("qwerty")
result.length # => 0

# 10
# searching for a string that exists one returns one result

repo = BooksRepository.new

result = repo.search("George")
result.length # => 1

# 11
# testing all functionality

repo = BooksRepository.new

repo.delete(2)
repo.create("Animal Farm", "George Orwell")
shelf = repo.all
result = repo.search("George")
book = repo.find(3)
shelf.length # => 5
result.length # => 2
book.title # => "Emma"

```

7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_shelf_table
  seed_sql = File.read('spec/seeds_shelf.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'shelf' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do 
    reset_shelf_table
  end

  # (your tests will go here).
end
8. Test-drive and implement the Repository class behaviour

After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour.

