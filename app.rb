require_relative 'lib/database_connection'
require_relative 'lib/book_store_repository'

DatabaseConnection.connect('book_store')

book_repo = BooksRepository.new

book_repo.all.each do |book|
  p book.id + " - " + book.title + " - " + book.author_name
end