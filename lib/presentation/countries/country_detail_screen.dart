import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/country.dart';
import '../providers/country_providers.dart';

class CountryDetailScreen extends ConsumerWidget {
  final String countryName;

  const CountryDetailScreen({super.key, required this.countryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final countriesAsync = ref.watch(countryListProvider);

    return countriesAsync.when(
      data: (countries) {
        final country = countries.any((c) => c.name == countryName)
    ? countries.firstWhere((c) => c.name == countryName)
    : countries.first;
        return _DetailContent(
          country: country,
          theme: theme,
          colorScheme: colorScheme,
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Failed to load details')),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final Country country;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _DetailContent({
    required this.country,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildInfoSection('General', [
                    _infoRow(Icons.public_rounded, 'Region', country.region),
                    if (country.subregion != null)
                      _infoRow(
                          Icons.map_rounded, 'Subregion', country.subregion!),
                    if (country.continents.isNotEmpty)
                      _infoRow(Icons.layers_rounded, 'Continent',
                          country.continents.join(', ')),
                  ]),
                  const SizedBox(height: 12),
                  _buildInfoSection('Demographics', [
                    _infoRow(Icons.people_rounded, 'Population',
                        numberFormat.format(country.population)),
                    if (country.area != null)
                      _infoRow(Icons.straighten_rounded, 'Area (km²)',
                          numberFormat.format(country.area!.toInt())),
                  ]),
                  const SizedBox(height: 12),
                  if (country.currencies.isNotEmpty)
                    _buildInfoSection('Currency', [
                      ...country.currencies.entries.map(
                        (e) => _infoRow(
                            Icons.attach_money_rounded, e.key, e.value),
                      ),
                    ]),
                  if (country.languages.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _buildInfoSection('Languages', [
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: country.languages.map((lang) {
                            return Chip(
                              label: Text(lang, style: const TextStyle(fontSize: 13)),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            );
                          }).toList(),
                        ),
                      ]),
                    ),
                  if (country.timezones.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _buildInfoSection('Time Zones', [
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Text(
                            country.timezones.join(', '),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ]),
                    ),
                  const SizedBox(height: 12),
                  if (country.googleMapsUrl != null)
                    _buildMapButton(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      stretch: true,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_rounded),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'flag_${country.name}',
          child: CachedNetworkImage(
            imageUrl: country.flagUrl,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(
              color: colorScheme.surfaceContainerHighest,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (_, _, _) => Container(
              color: colorScheme.surfaceContainerHighest,
              child: Icon(Icons.flag_outlined,
                  size: 48, color: colorScheme.onSurfaceVariant),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          country.name,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        if (country.capital != null)
          Row(
            children: [
              Icon(Icons.location_on_rounded,
                  size: 18, color: colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                country.capital!,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        if (country.nativeNames.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            country.nativeNames.entries.first.value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    ).animate().slideY(begin: 0.2, duration: 400.ms).fadeIn();
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    ).animate().slideY(begin: 0.1, duration: 400.ms).fadeIn();
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening: ${country.googleMapsUrl}')),
          );
        },
        icon: const Icon(Icons.map_rounded),
        label: const Text('Open in Google Maps'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    ).animate().slideY(begin: 0.1, duration: 400.ms).fadeIn();
  }
}