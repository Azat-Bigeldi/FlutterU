import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/journal/journal_cubit.dart';
import '../blocs/location/location_cubit.dart';
import '../blocs/location/location_state.dart';
import '../models/journal_entry.dart';
import '../services/location_service.dart';
import '../services/media_service.dart';
import '../theme.dart';
import '../widgets/hardware_feedback.dart';
import '../widgets/location_panel.dart';

class PhotoJournalScreen extends StatelessWidget {
  const PhotoJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationCubit(context.read<LocationService>()),
      child: const _JournalView(),
    );
  }
}

class _JournalView extends StatefulWidget {
  const _JournalView();

  @override
  State<_JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<_JournalView> {
  final TextEditingController _captionController = TextEditingController();
  late final MediaService _media = context.read<MediaService>();

  // Черновик записи: фото выбрано, но ещё не сохранено.
  String? _photoName;
  DateTime? _takenAt;
  bool _isPicking = false;

  @override
  void dispose() {
    // Несохранённый снимок не должен занимать место.
    final draft = _photoName;
    if (draft != null) _media.delete(draft);
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    if (_isPicking) return;
    setState(() => _isPicking = true);
    final name = await pickPhoto(context, _media, source);
    if (!mounted) {
      if (name != null) _media.delete(name);
      return;
    }
    final previous = _photoName;
    setState(() {
      _isPicking = false;
      if (name != null) {
        _photoName = name;
        _takenAt = DateTime.now();
      }
    });
    if (name == null) return;

    if (previous != null) _media.delete(previous);
    // Координаты определяются автоматически после выбора фото.
    final location = context.read<LocationCubit>();
    location.reset();
    location.fetch();
  }

  Future<void> _save() async {
    final name = _photoName;
    final takenAt = _takenAt;
    final location = context.read<LocationCubit>().state;

    if (name == null || takenAt == null) {
      _showMessage('Сначала сделайте или выберите фото');
      return;
    }
    if (location is! LocationSuccess) {
      _showMessage('Сначала получите координаты GPS');
      return;
    }

    final caption = _captionController.text.trim();
    final entry = JournalEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      photoName: name,
      caption: caption.isEmpty ? 'Без подписи' : caption,
      takenAt: takenAt,
      location: location.fix,
    );
    final journal = context.read<JournalCubit>();
    final locationCubit = context.read<LocationCubit>();

    // Черновик очищается сразу, чтобы двойное нажатие не создало копию.
    setState(() {
      _photoName = null;
      _takenAt = null;
    });
    _captionController.clear();
    FocusScope.of(context).unfocus();
    locationCubit.reset();

    await journal.add(entry);
    if (mounted) _showMessage('Запись сохранена');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<JournalCubit>().state;
    final photo = _photoName;

    return BlocListener<LocationCubit, LocationState>(
      listener: (context, state) {
        if (state is LocationFailure) {
          showLocationProblem(
            context,
            context.read<LocationService>(),
            state.problem,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('📸 Narxoz Photo Journal')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 240,
                color: Theme.of(context).colorScheme.surface,
                child: photo == null
                    ? const Center(
                        child: Icon(
                          Icons.photo_camera_outlined,
                          size: 72,
                          color: FlipColors.grey,
                        ),
                      )
                    : Image.file(_media.fileFor(photo), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) => Column(
                children: [
                  LocationPanel(
                    fix: state is LocationSuccess ? state.fix : null,
                    isLoading: state is LocationLoading,
                    timestamp: _takenAt,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _isPicking
                              ? null
                              : () => _pick(ImageSource.camera),
                          icon: const Icon(Icons.photo_camera),
                          label: const Text('Take Photo'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: _isPicking
                              ? null
                              : () => _pick(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Pick Gallery'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: state is LocationLoading
                          ? null
                          : context.read<LocationCubit>().fetch,
                      icon: const Icon(Icons.my_location),
                      label: const Text('Fetch Current GPS Location'),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            TextField(
              controller: _captionController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Caption',
                hintText: 'Campus Quad at Narxoz',
                prefixIcon: Icon(Icons.edit_note),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('SAVE ENTRY TO DIARY'),
            ),
            const SizedBox(height: 24),
            Text(
              'Diary Entries (${entries.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (entries.isEmpty)
              const Text(
                'Записей пока нет',
                style: TextStyle(color: FlipColors.grey),
              ),
            for (final entry in entries)
              _EntryCard(entry: entry, media: _media),
          ],
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final JournalEntry entry;
  final MediaService media;

  const _EntryCard({required this.entry, required this.media});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            media.fileFor(entry.photoName),
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            cacheWidth: 200,
            errorBuilder: (_, _, _) => const SizedBox(
              width: 56,
              height: 56,
              child: Icon(Icons.broken_image_outlined),
            ),
          ),
        ),
        title: Text(entry.caption),
        subtitle: Text(
          '${entry.location.shortText}\n${formatDateTime(entry.takenAt)}',
        ),
        isThreeLine: true,
      ),
    );
  }
}
