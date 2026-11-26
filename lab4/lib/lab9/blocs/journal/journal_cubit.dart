import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/journal_storage.dart';
import '../../models/journal_entry.dart';

/// Состояние — список записей, новые сверху.
class JournalCubit extends Cubit<List<JournalEntry>> {
  final JournalStorage storage;
  late final Future<void> _loaded = _load();

  JournalCubit({JournalStorage? storage})
    : storage = storage ?? JournalStorage(),
      super(const []) {
    _loaded;
  }

  Future<void> _load() async {
    final entries = await storage.read();
    if (!isClosed) emit(List.unmodifiable(entries));
  }

  Future<void> add(JournalEntry entry) async {
    // Дожидаемся загрузки, чтобы не затереть сохранённые записи.
    await _loaded;
    emit(List.unmodifiable([entry, ...state]));
    await storage.write(state);
  }
}
