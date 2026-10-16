import '../models/product.dart';

const List<Product> products = [
  Product(
    id: '1984',
    title: '1984',
    author: 'Д. Оруэлл',
    description:
        'Антиутопия о тоталитарном государстве, где Большой Брат следит за каждым. '
        'Издание по методике В. Ратке: роман, комментарии, словарь и грамматика '
        'для изучения английского языка.',
    imageUrl: 'https://covers.openlibrary.org/b/isbn/9780451524935-L.jpg',
    price: 3042,
    oldPrice: 3136,
    category: 'Книги на английском',
    details: 'мягкая обложка, 2023, Lingua',
  ),
  Product(
    id: 'little_prince',
    title: 'Little Prince. A1',
    author: 'А. де Сент-Экзюпери',
    description:
        'Философская сказка о Маленьком принце, путешествующем по планетам. '
        'Адаптированное издание уровня A1 из серии English Graded Readers.',
    imageUrl: 'https://covers.openlibrary.org/b/isbn/9780156012195-L.jpg',
    price: 2289,
    oldPrice: 2360,
    category: 'Книги на английском',
    details: 'мягкая обложка, 2023, АСТ',
  ),
  Product(
    id: 'gatsby',
    title: 'The Great Gatsby',
    author: 'Ф. С. Фицджеральд',
    description:
        'Роман об эпохе джаза, богатстве и несбывшихся мечтах загадочного '
        'миллионера Джея Гэтсби. Оригинальный текст на английском языке.',
    imageUrl: 'https://covers.openlibrary.org/b/isbn/9780743273565-L.jpg',
    price: 2016,
    oldPrice: 2520,
    category: 'Художественная литература',
    details: 'мягкая обложка, 2022, Scribner',
  ),
  Product(
    id: 'mockingbird',
    title: 'To Kill a Mockingbird',
    author: 'Х. Ли',
    description:
        'История взросления в маленьком городке на юге США и о справедливости, '
        'увиденной глазами ребёнка. Лауреат Пулитцеровской премии.',
    imageUrl: 'https://covers.openlibrary.org/b/isbn/9780061120084-L.jpg',
    price: 3577,
    oldPrice: 3690,
    category: 'Художественная литература',
    details: 'мягкая обложка, 2006, Harper',
  ),
];
