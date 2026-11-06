import '../models/product.dart';

String _cover(String isbn) => 'https://covers.openlibrary.org/b/isbn/$isbn-L.jpg';

/// Начальный каталог (seed). Через seedProducts() берём КОПИЮ,
/// чтобы "Reset Catalog" всегда возвращал исходные данные.
final List<Product> _seed = [
  Product(
    id: '1984',
    title: '1984',
    author: 'Д. Оруэлл',
    description:
        'Антиутопия о тоталитарном государстве, где Большой Брат следит за каждым. '
        'Издание по методике В. Ратке: роман, комментарии, словарь и грамматика '
        'для изучения английского языка.',
    imageUrl: _cover('9780451524935'),
    price: 3042,
    oldPrice: 3136,
    category: 'Книги на английском',
    details: 'мягкая обложка, 2023, Lingua',
    rating: 4.9,
  ),
  Product(
    id: 'little_prince',
    title: 'Little Prince. A1',
    author: 'А. де Сент-Экзюпери',
    description:
        'Философская сказка о Маленьком принце, путешествующем по планетам. '
        'Адаптированное издание уровня A1 из серии English Graded Readers.',
    imageUrl: _cover('9780156012195'),
    price: 2289,
    oldPrice: 2360,
    category: 'Книги на английском',
    details: 'мягкая обложка, 2023, АСТ',
    rating: 4.8,
  ),
  Product(
    id: 'gatsby',
    title: 'The Great Gatsby',
    author: 'Ф. С. Фицджеральд',
    description:
        'Роман об эпохе джаза, богатстве и несбывшихся мечтах загадочного '
        'миллионера Джея Гэтсби. Оригинальный текст на английском языке.',
    imageUrl: _cover('9780743273565'),
    price: 2016,
    oldPrice: 2520,
    category: 'Художественная литература',
    details: 'мягкая обложка, 2022, Scribner',
    rating: 4.6,
  ),
  Product(
    id: 'mockingbird',
    title: 'To Kill a Mockingbird',
    author: 'Х. Ли',
    description:
        'История взросления в маленьком городке на юге США и о справедливости, '
        'увиденной глазами ребёнка. Лауреат Пулитцеровской премии.',
    imageUrl: _cover('9780061120084'),
    price: 3577,
    oldPrice: 3690,
    category: 'Художественная литература',
    details: 'мягкая обложка, 2006, Harper',
    rating: 4.8,
  ),
  Product(
    id: 'pride',
    title: 'Pride and Prejudice',
    author: 'Дж. Остин',
    description:
        'Классический роман о гордости, предубеждениях и любви Элизабет Беннет '
        'и мистера Дарси. Оригинальный текст.',
    imageUrl: _cover('9780141439518'),
    price: 2490,
    oldPrice: 2890,
    category: 'Классика',
    details: 'мягкая обложка, 2003, Penguin',
    rating: 4.7,
  ),
  Product(
    id: 'catcher',
    title: 'The Catcher in the Rye',
    author: 'Дж. Д. Сэлинджер',
    description:
        'Два дня из жизни подростка Холдена Колфилда в Нью-Йорке — '
        'главный роман о взрослении XX века.',
    imageUrl: _cover('9780316769488'),
    price: 2750,
    oldPrice: 3100,
    category: 'Художественная литература',
    details: 'мягкая обложка, 2001, Little, Brown',
    rating: 4.3,
  ),
  Product(
    id: 'jane_eyre',
    title: 'Jane Eyre',
    author: 'Ш. Бронте',
    description:
        'История сироты-гувернантки, её независимости и любви к мистеру Рочестеру.',
    imageUrl: _cover('9780141441146'),
    price: 2190,
    oldPrice: 2450,
    category: 'Классика',
    details: 'мягкая обложка, 2006, Penguin',
    rating: 4.5,
  ),
  Product(
    id: 'old_man_sea',
    title: 'The Old Man and the Sea',
    author: 'Э. Хемингуэй',
    description:
        'Повесть о старом кубинском рыбаке и его поединке с огромной рыбой. '
        'Нобелевская премия по литературе.',
    imageUrl: _cover('9780684801223'),
    price: 1890,
    oldPrice: 2100,
    category: 'Художественная литература',
    details: 'мягкая обложка, 1995, Scribner',
    rating: 4.4,
  ),
  Product(
    id: 'lord_flies',
    title: 'Lord of the Flies',
    author: 'У. Голдинг',
    description:
        'Группа мальчиков на необитаемом острове пытается выжить — '
        'и постепенно теряет человеческий облик.',
    imageUrl: _cover('9780399501487'),
    price: 2350,
    oldPrice: 2600,
    category: 'Книги на английском',
    details: 'мягкая обложка, 2003, Perigee',
    rating: 4.2,
  ),
  Product(
    id: 'mice_men',
    title: 'Of Mice and Men',
    author: 'Дж. Стейнбек',
    description:
        'Повесть о дружбе двух сезонных рабочих и их мечте о собственной ферме.',
    imageUrl: _cover('9780140177398'),
    price: 1990,
    oldPrice: 2290,
    category: 'Книги на английском',
    details: 'мягкая обложка, 1993, Penguin',
    rating: 4.5,
  ),
];

/// LW9: по заданию в каталоге 6 товаров.
/// Берём первые 6 книг из списка LW8 (поменяй число, если нужно больше).
const int catalogSize = 6;

List<Product> seedProducts() => List<Product>.of(_seed.take(catalogSize));

/// Пул "новинок", которые приходят при pull-to-refresh.
const List<Map<String, Object>> _newArrivals = [
  {'t': 'The Hobbit', 'a': 'Дж. Р. Р. Толкин', 'isbn': '9780547928227', 'p': 3290, 'r': 4.9},
  {'t': 'Animal Farm', 'a': 'Д. Оруэлл', 'isbn': '9780451526342', 'p': 1790, 'r': 4.6},
  {'t': 'The Alchemist', 'a': 'П. Коэльо', 'isbn': '9780062315007', 'p': 2590, 'r': 4.4},
  {'t': 'Fahrenheit 451', 'a': 'Р. Брэдбери', 'isbn': '9781451673319', 'p': 2390, 'r': 4.5},
  {'t': 'Brave New World', 'a': 'О. Хаксли', 'isbn': '9780060850524', 'p': 2690, 'r': 4.3},
];

int _newCounter = 0;

/// Имитация сетевого запроса: ждём 1.5 с и возвращаем новый товар.
Future<Product> fetchNewProduct() async {
  await Future.delayed(const Duration(milliseconds: 1500));

  final data = _newArrivals[_newCounter % _newArrivals.length];
  _newCounter++;
  final price = data['p'] as int;

  return Product(
    id: 'new_$_newCounter', // уникальный id → уникальный ValueKey
    title: data['t'] as String,
    author: data['a'] as String,
    description: 'Новинка! Только что поступила в каталог Flip.',
    imageUrl: _cover(data['isbn'] as String),
    price: price,
    oldPrice: (price * 1.15).round(),
    category: 'Новинки',
    details: 'мягкая обложка, 2026',
    rating: data['r'] as double,
  );
}
