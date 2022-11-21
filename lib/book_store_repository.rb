require_relative '../lib/book_store'

class BooksRepository
  
  def inflate(uninflated)
    inflated = Books.new
    inflated.id = uninflated['id']
    inflated.title = uninflated['title']
    inflated.author_name = uninflated['author_name']
    return inflated
  end
  
  def all
    sql = "SELECT id, title, author_name FROM books;"
    result_set = DatabaseConnection.exec_params(sql, [])

    array = []

    result_set.each do |book|
      array << inflate(book)
    end
    
    return array
  end

  def find(id)
    sql = "SELECT id, title, author_name FROM books WHERE id = #{id};"
    book = DatabaseConnection.exec_params(sql, [])
    return inflate(book[0])
  end

  def create(title, author_name)
    sql = "INSERT INTO books
      ( id, title, author_name )
      VALUES( '#{all[-1].id.to_i + 1}', '#{title}', '#{author_name}');"
      DatabaseConnection.exec_params(sql, [])
  end

  def delete(id)
    sql = "DELETE FROM books WHERE id = '#{id}';"
    DatabaseConnection.exec_params(sql, [])
  
  end

  def search_for(string)
    results = []
    all.each do |book|
      results << book if book.title.include?(string) || book.author_name.include?(string)
    end
    return results
  end

end

