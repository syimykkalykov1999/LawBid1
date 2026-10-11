import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawbid/core/persistence/persistence_providers.dart';

/// Demo toggles «как сейчас / как предлагаем». A section thread adds one
/// [DemoFlag] to [kDemoFlags] and reads it with
/// `ref.watch(demoFlagProvider('id'))`. Off = the live behaviour; on = the
/// proposal. Only the web demo shows the panel; production never reads it
/// (the value is false unless kDemoMode build turned it on).
class DemoFlag {
  const DemoFlag(this.id, this.title, {this.hint = ''});

  final String id;
  final String title;
  final String hint;
}

const List<DemoFlag> kDemoFlags = [
  DemoFlag(
    'feed.caption3',
    'Подпись поста: 3 строки',
    hint: 'Лента: подпись под фото сворачивается до 3 строк вместо 2.',
  ),
];

class DemoFlagsNotifier extends Notifier<Set<String>> {
  static const _key = 'demo.flags';

  @override
  Set<String> build() {
    try {
      return (ref.read(sharedPreferencesProvider).getStringList(_key) ??
              const <String>[])
          .toSet();
    } catch (_) {
      return <String>{};
    }
  }

  void toggle(String id) {
    final next = {...state};
    if (!next.remove(id)) next.add(id);
    state = next;
    try {
      ref.read(sharedPreferencesProvider).setStringList(_key, next.toList());
    } catch (_) {}
  }
}

final demoFlagsProvider =
    NotifierProvider<DemoFlagsNotifier, Set<String>>(DemoFlagsNotifier.new);

final demoFlagProvider = Provider.family<bool, String>(
  (ref, id) => ref.watch(demoFlagsProvider.select((s) => s.contains(id))),
);

Future<void> showDemoFlagsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _DemoFlagsSheet(),
  );
}

class _DemoFlagsSheet extends ConsumerWidget {
  const _DemoFlagsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = ref.watch(demoFlagsProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Демо-настройки: выключено = как сейчас, включено = как предлагаем',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final f in kDemoFlags)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(f.title),
                subtitle: f.hint.isEmpty ? null : Text(f.hint),
                value: on.contains(f.id),
                onChanged: (_) =>
                    ref.read(demoFlagsProvider.notifier).toggle(f.id),
              ),
          ],
        ),
      ),
    );
  }
}
