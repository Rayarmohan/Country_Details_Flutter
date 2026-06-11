import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/theme_provider.dart';
import '../providers/sync_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeState = ref.watch(themeProvider);
    final syncState = ref.watch(syncProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            'Appearance',
            Icons.palette_rounded,
            [
              _buildThemeModeSelector(context, ref, themeState.mode),
              const SizedBox(height: 16),
              _buildAccentColorPicker(context, ref, themeState.accentColor),
              const SizedBox(height: 16),
              _buildFontScaleSelector(context, ref, themeState.fontScale),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            'Sync & Data',
            Icons.sync_rounded,
            [
              _buildSyncSection(context, ref, syncState),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            'About',
            Icons.info_outline_rounded,
            [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.flag_rounded,
                    color: colorScheme.primary,
                  ),
                ),
                title: const Text('Country Explorer'),
                subtitle: const Text('v1.0.0 — Powered by REST Countries'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, IconData icon, List<Widget> children) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildThemeModeSelector(
      BuildContext context, WidgetRef ref, ThemeMode currentMode) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme Mode',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: ThemeMode.values.map((mode) {
            final isSelected = mode == currentMode;
            final labels = {
              ThemeMode.light: 'Light',
              ThemeMode.dark: 'Dark',
              ThemeMode.system: 'System',
            };
            final icons = {
              ThemeMode.light: Icons.light_mode_rounded,
              ThemeMode.dark: Icons.dark_mode_rounded,
              ThemeMode.system: Icons.settings_brightness_rounded,
            };

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: mode == ThemeMode.light ? 0 : 4,
                  right: mode == ThemeMode.dark ? 0 : 4,
                ),
                child: ChoiceChip(
                  selected: isSelected,
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[mode]!,
                        size: 20,
                      ),
                      const SizedBox(height: 2),
                      Text(labels[mode]!, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  onSelected: (_) {
                    ref.read(themeProvider.notifier).setThemeMode(mode);
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAccentColorPicker(
      BuildContext context, WidgetRef ref, Color currentColor) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accent Color',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(AppConstants.accentColors.length, (index) {
            final color = AppConstants.accentColors[index];
              final isSelected = color.toARGB32 == currentColor.toARGB32;

            return GestureDetector(
              onTap: () {
                ref.read(themeProvider.notifier).setAccentColor(color);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(
                          color: theme.colorScheme.onSurface, width: 3)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: isSelected
                    ? Icon(Icons.check_rounded,
                        color: color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                        size: 20)
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFontScaleSelector(
      BuildContext context, WidgetRef ref, double currentScale) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Font Size',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(AppConstants.fontScales.length, (index) {
            final scale = AppConstants.fontScales[index];
            final name = AppConstants.fontScaleNames[index];
            final isSelected = scale == currentScale;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : 4,
                  right: index == AppConstants.fontScales.length - 1 ? 0 : 4,
                ),
                child: ChoiceChip(
                  selected: isSelected,
                  label: Text(name),
                  onSelected: (_) {
                    ref.read(themeProvider.notifier).setFontScale(scale);
                  },
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSyncSection(
      BuildContext context, WidgetRef ref, SyncState syncState) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (syncState.isSyncing)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              )
            else
              Icon(
                syncState.lastSyncTime != null
                    ? Icons.cloud_done_rounded
                    : Icons.cloud_off_rounded,
                size: 18,
                color: syncState.lastSyncTime != null
                    ? Colors.green
                    : colorScheme.onSurfaceVariant,
              ),
            const SizedBox(width: 8),
            Text(
              syncState.lastSyncTime != null
                  ? 'Last synced: ${DateFormat.yMd().add_jm().format(syncState.lastSyncTime!)}'
                  : 'No sync yet',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        if (syncState.error != null) ...[
          const SizedBox(height: 8),
          Text(
            'Error: ${syncState.error}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: syncState.isSyncing
                ? null
                : () => ref.read(syncProvider.notifier).syncNow(),
            icon: const Icon(Icons.sync_rounded, size: 18),
            label: const Text('Sync Now'),
          ),
        ),
      ],
    );
  }
}
