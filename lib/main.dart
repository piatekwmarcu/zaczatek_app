import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zaczatek_app/screens/admin_zamowienia_page.dart';
import 'models/produkt_do_zamowienia.dart';
import 'models/uzytkownik.dart';
import 'models/ogloszenie.dart';
import 'screens/login_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/stany_page.dart';
import 'screens/magazyn/dodaj_produkt_page.dart';
import 'screens/dostawa/dostawa_historia.dart';
import 'screens/stany/zamowienia_do_zlozenia_page.dart';
import 'screens/stany/stany_admin_page.dart';
import 'package:zaczatek_app/models/grafik_model.dart';
import 'models/godziny_model.dart';
import 'screens/godziny/godziny_pracownik_page.dart';
import 'screens/godziny/godziny_admin_page.dart';
import 'screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'utils/init_users.dart';
import 'screens/godziny/statystyki_pracownikow_page.dart';
import 'package:intl/date_symbol_data_local.dart';


final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initializeDateFormatting('pl_PL', null);
  Hive.registerAdapter(ProduktDoZamowieniaAdapter());
  Hive.registerAdapter(UzytkownikAdapter());
  Hive.registerAdapter(OgloszenieAdapter());
  Hive.registerAdapter(GrafikTygodniowyAdapter());
  Hive.registerAdapter(GrafikPracownikAdapter());
  Hive.registerAdapter(GodzinyPracyAdapter());

  await Hive.openBox<ProduktDoZamowienia>('produktyZamowienia');
  await Hive.openBox<Uzytkownik>('uzytkownicy');
  await Hive.openBox<Ogloszenie>('ogloszenia');
  await Hive.openBox<GrafikTygodniowy>('grafiki');
  await Hive.openBox<GodzinyPracy>('godziny');



  await Supabase.initialize(
    url: 'https://pobzncjegqkchstynmma.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvYnpuY2plZ3FrY2hzdHlubW1hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI1ODY5ODEsImV4cCI6MjA2ODE2Mjk4MX0.IlriojS6WtPxvVhZoNerLJNDwDglcQX9Nv_V1Ngfm3I',
  );
  await dodajDomyslnychUzytkownikowDoSupabase();
  runApp(const ZaczatekApp());
}

class ZaczatekApp extends StatelessWidget {
  const ZaczatekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/statystyki': (context) => const StatystykiPracownikowPage(),
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/admin': (context) => const AdminZamowieniaPage(),
        '/stany': (context) => const StanyPage(),
        '/dodaj_produkt': (context) => DodajProduktPage(rola: 'admin'),
        '/dostawa_historia': (_) => const DostawaHistoriaPage(),
        '/stany_admin': (_) => const StanyAdminPage(),
        '/zamowienia_admin': (_) => const ZamowieniaDoZlozeniaPage(),
        '/godziny_pracownik': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return GodzinyPracownikPage(login: args['login']);
        },
        '/godziny_admin': (context) => const GodzinyAdminPage(),

      },
    );
  }
}
