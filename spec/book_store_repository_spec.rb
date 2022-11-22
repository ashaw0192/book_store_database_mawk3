require 'book_store'
require 'book_store_repository'



RSpec.describe BooksRepository do
  
  def reset_books_table
    seed_sql = File.read('spec/seeds_book_store.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'book_store_test' })
    connection.exec(seed_sql)
  end
  
  before(:each) do 
    reset_books_table
  end

  it "returns all 5 books" do
    repo = BooksRepository.new

    shelf = repo.all

    expect(shelf.length).to eq 5

    expect(shelf[0].id).to eq '1'
    expect(shelf[0].title).to eq 'Nineteen Eighty-Four'
    expect(shelf[0].author_name).to eq 'George Orwell'

    expect(shelf[-1].id).to eq '5'
    expect(shelf[-1].title).to eq 'The Age of Innocence'
    expect(shelf[-1].author_name).to eq 'Edith Wharton'
  end

  it "returns a single book by its id number" do
    repo = BooksRepository.new

    book = repo.find(3)

    expect(book.id).to eq '3'
    expect(book.title).to eq 'Emma'
    expect(book.author_name).to eq 'Jane Austen'
  end

  it "adds a book to the books table" do
    repo = BooksRepository.new

    repo.create('Title 1', 'Author 1')

    shelf = repo.all
    expect(shelf.length).to eq 6
    expect(shelf[-1].id).to eq '6'
    expect(shelf[-1].title).to eq 'Title 1'
    expect(shelf[-1].author_name).to eq 'Author 1'
  end

  it "doesn't include a book already exists and is added a second time" do
    repo = BooksRepository.new

    repo.create("Dracula", "Dracula")

    shelf = repo.all
    expect(shelf.length).to eq 5
    expect(shelf[-1].id).to eq '5'
  end

  it "removes a book by id" do
    repo = BooksRepository.new
    repo.delete(3)
    shelf = repo.all
  
    expect(shelf.length).to eq 4
    expect(shelf[2].id).to eq '4'
    expect(shelf[2].title).to eq 'Dracula'
    expect(shelf[2].author_name).to eq 'Bram Stoker'
  end

  it "returns an empty list if no books" do
    repo = BooksRepository.new

    repo.delete(1)
    repo.delete(2)
    repo.delete(3)
    repo.delete(4)
    repo.delete(5)

    shelf = repo.all

    expect(shelf.length).to eq 0

  end

  it "raises error when trying to find an index that doesn't exist" do
    repo = BooksRepository.new

    expect{ repo.find(6) }.to raise_error "Index 0 is out of range"
    expect{ repo.find(5) }.to_not raise_error "Index 0 is out of range"
  end

  xit "raises error when trying to delete an index that doesn't exist" do
    repo = BooksRepository.new

    expect{ repo.delete(6) }.to raise_error
  end

  it "result length 0 if no search results match title or author_name" do
    repo = BooksRepository.new

    result = repo.search_for("qwerty")
    
    expect(result.length).to eq 0
  end

  it "result length 1 if one search result matches title or author_name" do
    repo = BooksRepository.new

    result = repo.search_for("George")
    
    expect(result.length).to eq 1
  end

  it "just works" do
    repo = BooksRepository.new

    repo.delete(2)
    repo.create("Animal Farm", "George Orwell")
    shelf = repo.all
    result = repo.search_for("George")
    book = repo.find(3)
    expect(shelf.length).to eq 5
    expect(result.length).to eq 2
    expect(book.title).to eq "Emma"
  end

end