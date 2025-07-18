import 'package:flutter/material.dart';
import '../../services/magazyn_service.dart';
import '../../models/product.dart';
import '../../main.dart';

class MagazynListaPage extends StatefulWidget {
  final String kategoria;
  final String lokalizacja;
  final String login;
  final String rola;

  const MagazynListaPage({
    super.key,
    required this.kategoria,
    required this.lokalizacja,
    required this.rola,
    required this.login,
  });

  @override
  State<MagazynListaPage> createState() => _MagazynListaPageState();
}

class _MagazynListaPageState extends State<MagazynListaPage> with RouteAware {
  final _magazynService = MagazynService();

  bool sortNameAsc = true;
  bool sortIloscAsc = true;
  bool showOnlyCritical = false;

  @override
  void initState() {
    super.initState();
    _magazynService.pobierzProduktyZChmury(widget.lokalizacja);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _usunProdukt(Product produkt) async {
    final potwierdzenie = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usuń produkt'),
        content: Text('Czy na pewno chcesz usunąć "${produkt.nazwa}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Anuluj')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Usuń')),
        ],
      ),
    );

    if (potwierdzenie ?? false) {
      _magazynService.usunProdukt(produkt);
    }
  }

  void _edytujIlosc(Product produkt) async {
    final controller = TextEditingController(text: produkt.ilosc.toString());

    final nowaIlosc = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edytuj ilość – ${produkt.nazwa}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Nowa ilość'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Anuluj')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, int.tryParse(controller.text)),
            child: const Text('Zapisz'),
          ),
        ],
      ),
    );

    if (nowaIlosc != null) {
      _magazynService.aktualizujIlosc(produkt, nowaIlosc);
    }
  }

  void _dodajNowyProdukt() async {
    String nazwa = '';
    int ilosc = 0;

    final formKey = GlobalKey<FormState>();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dodaj nowy produkt'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nazwa produktu'),
                onChanged: (val) => nazwa = val,
                validator: (val) => val == null || val.isEmpty ? 'Wprowadź nazwę' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ilość'),
                keyboardType: TextInputType.number,
                onChanged: (val) => ilosc = int.tryParse(val) ?? 0,
                validator: (val) =>
                val == null || int.tryParse(val) == null ? 'Wprowadź liczbę' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Anuluj')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Dodaj'),
          ),
        ],
      ),
    );

    if (result == true) {
      final nowy = Product(
        nazwa: nazwa,
        ilosc: ilosc,
        kategoria: widget.kategoria,
        lokalizacja: widget.lokalizacja,
      );
      _magazynService.dodajProdukt(nowy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/zaczatek.jpg'),
            fit: BoxFit.cover,
            opacity: 0.6,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    '📦 ${widget.kategoria} – ${widget.lokalizacja}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF040F0F),
                    ),
                  ),
                  const Spacer(),
                  if (widget.rola == 'admin')
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _dodajNowyProdukt,
                      color: Colors.black,
                    ),
                ],
              ),


              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => setState(() => sortNameAsc = !sortNameAsc),
                    icon: const Icon(Icons.sort_by_alpha),
                    label: Text(sortNameAsc ? 'Nazwa A-Z' : 'Nazwa Z-A'),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => sortIloscAsc = !sortIloscAsc),
                    icon: const Icon(Icons.numbers),
                    label: Text(sortIloscAsc ? 'Ilość rosnąco' : 'Ilość malejąco'),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => showOnlyCritical = !showOnlyCritical),
                    icon: const Icon(Icons.warning),
                    label: Text(showOnlyCritical ? 'Krytyczne' : 'Wszystkie'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ValueListenableBuilder<List<Product>>(
                  valueListenable: _magazynService.produktyNotifier,
                  builder: (context, produkty, _) {
                    var widoczne = produkty
                        .where((p) =>
                    p.kategoria == widget.kategoria &&
                        p.lokalizacja == widget.lokalizacja)
                        .toList();

                    if (showOnlyCritical) {
                      widoczne = widoczne.where((p) => p.ilosc <= 10).toList();
                    }

                    widoczne.sort((a, b) => sortNameAsc
                        ? a.nazwa.toLowerCase().compareTo(b.nazwa.toLowerCase())
                        : b.nazwa.toLowerCase().compareTo(a.nazwa.toLowerCase()));
                    widoczne.sort((a, b) => sortIloscAsc
                        ? a.ilosc.compareTo(b.ilosc)
                        : b.ilosc.compareTo(a.ilosc));

                    if (widoczne.isEmpty) {
                      return const Center(
                        child: Text(
                          'Brak produktów',
                          style: TextStyle(fontSize: 18, color: Color(0xFF040F0F)),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '🔢 Suma produktów: ${widoczne.fold<int>(0, (sum, p) => sum + p.ilosc)}',
                            style: const TextStyle(fontSize: 16, color: Color(0xFF040F0F)),
                          ),
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await _magazynService.pobierzProduktyZChmury(widget.lokalizacja);
                            },
                            child: ListView.builder(
                              itemCount: widoczne.length,
                              itemBuilder: (context, index) {
                                final produkt = widoczne[index];
                                final krytyczny = produkt.ilosc <= 10;

                                return Card(
                                  elevation: 4,
                                  shadowColor: Colors.black54,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  color: const Color(0xFFD2D4C8),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: ListTile(
                                    title: Text(
                                      produkt.nazwa,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text('Ilość: ${produkt.ilosc}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (krytyczny)
                                          const Icon(Icons.warning, color: Colors.red),
                                        if (widget.rola == 'admin') ...[
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () => _edytujIlosc(produkt),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () => _usunProdukt(produkt),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
