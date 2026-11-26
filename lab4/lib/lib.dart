class Book {
  String title;
  String author;
  double price;
  bool isBorrowed;

  Book({
    required this.title,
    required this.author,
    required this.price,
    this.isBorrowed = false,
  });
}

class Library {
  List<Book> books = [];
  void addBook(Book book) {
    books.add(book);
  }

  List<Book> getAvailableBooks() {
    return books.where((book) => book.isBorrowed == false).toList();
  }

  double getTotalValue() {
    return books.fold(0.0, (sum, book) => sum + book.price);
  }
}

void main() {
  var library = Library();
  library.addBook(
    Book(title: "Clean Code", author: "Robert Martin", price: 25.5),
  );
  library.addBook(
    Book(title: "1984", author: "George Orwell", price: 12.0, isBorrowed: true),
  );
  library.addBook(
    Book(title: "Atomic Habits", author: "James Clear", price: 15.0),
  );
  print("Available books:");
  for (var books in library.getAvailableBooks()) {
    print("${books.title} by ${books.author} (${books.price})");
  }
  print("\nTotal collection value: ${library.getTotalValue()}");
}
