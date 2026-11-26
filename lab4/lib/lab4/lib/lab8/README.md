# LW8 — Flip: Dynamic Lists, Grids & Touch Gestures

Продолжение LW7 (приложение Flip). Запуск: положи папку `lab8/` рядом с `lab7/` в `lib/` и

```bash
flutter run -t lib/lab8/main8.dart
```

## Что изменилось относительно LW7

| Файл | Изменение |
|---|---|
| `models/product.dart` | + поле `rating` |
| `data/products.dart` | 10 книг в seed, `seedProducts()` (копия), `fetchNewProduct()` (Future.delayed 1500 мс) |
| `screens/feed_screen.dart` | StatefulWidget: AppBar-toggle, ListView.separated / GridView.builder, RefreshIndicator, Dismissible + UNDO, empty state |
| `screens/detail_screen.dart` | + строка «Рейтинг» |
| `widgets/product_card.dart` | подогнан под `childAspectRatio: 0.72` (без overflow) |
| `widgets/product_list_tile.dart` | новая строка списка |
| `widgets/delete_background.dart`, `empty_state.dart`, `rating_stars.dart`, `category_tag.dart` | новые |

Избранное, профиль, BottomNavigationBar, Hero-переход — как в LW7.

## Шпаргалка к защите

**Почему ListView.builder/separated, а не Column?**
Column (и обычный `ListView(children: [...])`) создаёт ВСЕ виджеты сразу. На 10 000 товаров — 10 000 виджетов в памяти и долгий первый кадр. Builder ленивый: строит только видимые элементы (+ небольшой cacheExtent) и переиспользует их при скролле.

**Что такое childAspectRatio: 0.72?**
Ширина / высота ячейки. 0.72 → высота ≈ 1.39 × ширины, т.е. высокие карточки. Overflow не будет, потому что верхняя часть карточки — `Expanded` (занимает остаток), а у текста `maxLines: 1` + `ellipsis`.

**Зачем ValueKey в Dismissible?**
Flutter сопоставляет виджеты и их State по ключу. Без уникального ключа после удаления элемента state «съедет» на соседний элемент, и будет ошибка «A dismissed Dismissible widget is still part of the tree». Ключ по `id`, а не по `index`, потому что индексы сдвигаются после удаления/вставки.

**Почему в onDismissed обязательно удалять из списка?**
Dismissible только анимирует уход. Если элемент остался в данных — он снова построится, а Dismissible уже «dismissed» → assertion.

**Как работает UNDO?**
Перед удалением запоминаем `product` и `index`. Колбэк SnackBarAction — замыкание с этими значениями: `_products.insert(index, product)`. `clamp` защищает от случая, когда список стал короче.

**Почему AlwaysScrollableScrollPhysics?**
RefreshIndicator срабатывает только от скролла. Если элементов мало и они помещаются на экран, список не скроллится — pull-to-refresh не работает. Эта физика разрешает оверскролл всегда.

**Зачем `if (!mounted) return;` после await?**
За 1.5 с пользователь может уйти с экрана. setState на размонтированном State → ошибка.

**Почему `seed()` возвращает новый список?**
Чтобы «Reset Catalog» давал свежую копию, а не ссылку на уже изменённый список.
