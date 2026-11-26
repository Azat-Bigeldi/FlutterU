import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/settings/settings_cubit.dart';
import '../blocs/settings/settings_state.dart';
import '../models/note_item.dart';
import '../theme.dart';
import '../widgets/profile_avatar.dart';
import 'delivery_screen.dart';
import 'photo_journal_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String displayName;
  final bool isDarkMode;
  final List<NoteItem> notes;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<String> onDisplayNameSaved;
  final ValueChanged<List<NoteItem>> onNotesChanged;

  const ProfileScreen({
    super.key,
    required this.displayName,
    required this.isDarkMode,
    required this.notes,
    required this.onThemeChanged,
    required this.onDisplayNameSaved,
    required this.onNotesChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  final TextEditingController _noteController = TextEditingController();
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.displayName);
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.displayName != widget.displayName &&
        _nameController.text != widget.displayName) {
      _nameController.text = widget.displayName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveName() {
    final name = _nameController.text.trim();
    final savedName = name.isEmpty ? 'Guest User' : name;
    widget.onDisplayNameSaved(savedName);
    _nameController.text = savedName;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Имя сохранено')));
  }

  void _open(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _addNote() {
    final title = _noteController.text.trim();
    if (title.isEmpty) return;

    final now = DateTime.now();
    final dateText =
        '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}';
    final note = NoteItem(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      dateText: dateText,
      isCompleted: false,
    );

    widget.onNotesChanged([note, ...widget.notes]);
    _noteController.clear();
    FocusScope.of(context).unfocus();
  }

  void _toggleNote(NoteItem note, bool isCompleted) {
    final updatedNotes = widget.notes
        .map(
          (item) => item.id == note.id
              ? item.copyWith(isCompleted: isCompleted)
              : item,
        )
        .toList();
    widget.onNotesChanged(updatedNotes);
  }

  void _deleteNote(NoteItem note) {
    final updatedNotes = widget.notes
        .where((item) => item.id != note.id)
        .toList();
    widget.onNotesChanged(updatedNotes);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: Text(
              'My profile',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 16),
          _Section(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                leading: const ProfileAvatar(),
                title: Text(
                  widget.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'Profile management',
                  style: TextStyle(color: FlipColors.blue),
                ),
                trailing: const Icon(Icons.qr_code_2),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _nameController,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _saveName(),
                      decoration: const InputDecoration(
                        labelText: 'Your name',
                        hintText: 'Enter your name',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed: _saveName,
                        icon: const Icon(Icons.save_outlined, size: 18),
                        label: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _Section(
            children: [
              const _ProfileTile(
                icon: Icons.description_outlined,
                color: FlipColors.blue,
                title: 'My orders',
              ),
              const _ProfileTile(
                icon: Icons.inventory_2_outlined,
                color: Color(0xFF29A3D6),
                title: 'Packages',
              ),
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settings) => _ProfileTile(
                  icon: Icons.location_on_outlined,
                  color: const Color(0xFF8E44EC),
                  title: 'Курьерская доставка',
                  subtitle:
                      settings.deliveryPoint?.shortText ??
                      'Выберите точку по GPS',
                  onTap: () => _open(const DeliveryScreen()),
                ),
              ),
              _ProfileTile(
                icon: Icons.photo_camera_outlined,
                color: const Color(0xFFE5733A),
                title: 'Фотодневник',
                subtitle: 'Фото с координатами',
                onTap: () => _open(const PhotoJournalScreen()),
              ),
            ],
          ),
          _Section(
            children: const [
              _ProfileTile(
                icon: Icons.percent,
                color: FlipColors.yellow,
                title: 'Loyalty discount (3%)',
              ),
              _ProfileTile(
                icon: Icons.account_balance_wallet_outlined,
                color: Color(0xFF34C759),
                title: 'Personal account',
              ),
            ],
          ),
          _Section(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('Уведомления'),
                value: _notifications,
                onChanged: (value) => setState(() => _notifications = value),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode_outlined),
                title: const Text('Тёмная тема'),
                subtitle: const Text('Сохраняется на устройстве'),
                value: widget.isDarkMode,
                onChanged: widget.onThemeChanged,
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Язык'),
                trailing: Text(
                  'Русский',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          _buildNotesSection(context),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Flip · Offline storage',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return _Section(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Row(
            children: [
              const Icon(Icons.sticky_note_2_outlined, color: FlipColors.blue),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'My Notes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '${widget.notes.length}',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _noteController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addNote(),
                  decoration: const InputDecoration(
                    hintText: 'Write a new note...',
                    prefixIcon: Icon(Icons.edit_note),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _addNote,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
        if (widget.notes.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Text(
              'No notes yet. Add your first note above.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          )
        else
          ...widget.notes.map(
            (note) => Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 8, 6),
              child: Row(
                children: [
                  Checkbox(
                    value: note.isCompleted,
                    onChanged: (value) => _toggleNote(note, value ?? false),
                    activeColor: FlipColors.blue,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: TextStyle(
                            fontSize: 15,
                            decoration: note.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: note.isCompleted
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          note.dateText,
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Delete note',
                    onPressed: () => _deleteNote(note),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: FlipColors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final List<Widget> children;

  const _Section({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
