# LW9 — Flip: State Management with Provider (корзина)

Продолжение LW8 (приложение Flip). Положи папку `lab9/` рядом с `lab8/` в `lib/`.

1. В `pubspec.yaml` → `dependencies:` добавь `provider: ^6.1.2`
2. `flutter pub get`
3. `flutter run -t lib/lab9/main9.dart`

## Что изменилось относительно LW8

| Файл | Изменение |
|---|---|
| `providers/cart_provider.dart` | **новый** — `CartProvider extends ChangeNotifier`: `add / remove / toggle / clear`, `count`, `totalPrice`, `totalSaving` |
| `main9.dart` | `MaterialApp` обёрнут в `ChangeNotifierProvider` |
| `screens/cart_screen.dart` | **новый** — Screen 2: список, удаление по одному, итог, «Очистить всё» (с подтверждением), пустое состояние |
| `widgets/cart_badge.dart` | **новый** — иконка корзины в AppBar с живым счётчиком |
| `widgets/cart_button.dart` | **новый** — переключатель «В корзину / В корзине» |
| `screens/feed_screen.dart` | + `CartBadge` в AppBar, `childAspectRatio` 0.72 → 0.62 (место под кнопку) |
| `widgets/product_card.dart` | + `CartButton` внизу карточки (сетка) |
| `widgets/product_list_tile.dart` | + компактный `CartButton` (список) |
| `screens/detail_screen.dart` | + `CartBadge` в AppBar и большая кнопка «В корзину» |
| `data/products.dart` | каталог = 6 книг (`catalogSize`) |

Всё из LW8 (List/Grid, pull-to-refresh, swipe-to-delete + UNDO, избранное, профиль, Hero) осталось.

## Как показать синхронизацию (пункт 5)

1. В каталоге нажми «В корзину» у 3 книг → бейдж в AppBar = 3, кнопки стали «В корзине».
2. Открой корзину → удали одну книгу крестиком → «Итого» пересчиталось.
3. Назад → бейдж = 2, у удалённой книги кнопка снова «В корзину».
4. Открой книгу (DetailScreen) → нажми «В корзину» там → бейдж обновился и на детали, и в каталоге.
5. Корзина → «Очистить всё» → назад → бейдж исчез, все кнопки сброшены.

Никаких колбэков и передачи данных через конструкторы — все экраны слушают один объект `CartProvider`.

## Шпаргалка к защите

**Зачем Provider, если в LW8 избранное уже работало через ChangeNotifier?**
В LW8 `FavoritesStore` создаётся в `RootScreen` и передаётся вниз через конструкторы (`FeedScreen → ProductCard`, `FeedScreen → DetailScreen`). Это prop drilling: каждый промежуточный виджет обязан принять и передать объект, даже если сам им не пользуется. Provider кладёт объект в дерево один раз, и любой виджет ниже достаёт его через `context`.

**Почему провайдер выше MaterialApp, а не внутри home?**
`Navigator` живёт внутри `MaterialApp`. Экран, открытый через `Navigator.push`, — это отдельный route, и он не является потомком `RootScreen`. Если поставить провайдер ниже `MaterialApp`, `CartScreen` его не увидит → `ProviderNotFoundException`.

**watch / read / select — в чём разница?**
- `context.watch<T>()` — подписка: виджет перестраивается при каждом `notifyListeners()` (экран корзины).
- `context.read<T>()` — без подписки, только вызвать метод. Используется в `onPressed`. В `build` для отображения данных его не используют — UI не обновится.
- `context.select<T, R>(...)` — подписка на часть состояния: перестройка только если изменилось `R`. `CartButton` слушает только «есть ли ЭТА книга в корзине», `CartBadge` — только `count`. Нажатие на одну карточку не перерисовывает остальные пять.

**Что делает notifyListeners()?**
Сообщает всем подписчикам (виджетам с `watch/select`), что состояние изменилось, и они перестраиваются в следующем кадре. Без него данные в `CartProvider` изменятся, но экран останется старым.

**Почему в корзине Map, а не List?**
Ключ — `id`, поэтому одна книга не попадёт в корзину дважды, а `contains` работает за O(1). Порядок добавления Dart-овский `Map` сохраняет.

**Кто вызывает dispose у CartProvider?**
`ChangeNotifierProvider(create: ...)` сам создаёт объект и сам вызывает `dispose()`, когда провайдер удаляется из дерева. (В LW8 `RootScreen` делал это вручную.)

**Почему в корзине нет Hero?**
Под `CartScreen` в стеке остаётся каталог с теми же `tag: 'img_<id>'`. Hero с одинаковыми тегами на двух маршрутах при переходе начнут анимироваться друг в друга, а это не нужно.

**Что будет, если удалить свайпом книгу из каталога, а она лежит в корзине?**
Она остаётся в корзине: это разные состояния (каталог — локальный `setState` в `FeedScreen`, корзина — глобальный Provider). UNDO вернёт книгу в каталог, и кнопка покажет «В корзине», потому что статус берётся из провайдера.
