import 'package:go_router/go_router.dart';
import '../../presentation/countries/country_list_screen.dart';
import '../../presentation/countries/country_detail_screen.dart';
import '../../presentation/settings/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const CountryListScreen(),
    ),
    GoRoute(
      path: '/country/:name',
      name: 'country',
      builder: (context, state) {
        final name = state.pathParameters['name']!;
        return CountryDetailScreen(countryName: name);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
