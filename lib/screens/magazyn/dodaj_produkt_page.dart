import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zaczatek_app/models/produkt_do_zamowienia.dart';

class DodajProduktPage extends StatefulWidget {
  final String rola;

  const DodajProduktPage({super.key, required this.rola});

  @override
  State<DodajProduktPage> createState() => _DodajProduktPageState();
}

class _DodajProduktPageState extends State<DodajProduktPage> {
  final _formKey = GlobalKey<FormState>();
  String nazwa = '';
  String kategoria = '';
  String dostawca = '';

  void dodajProdukt() async {
    if (_formKey.currentState!.validate()) {
      final box = Hive.box<ProduktDoZamowienia>('produktyZamowienia');

      final teraz = DateTime.now();
      final czas = '${teraz.hour.toString().padLeft(2, '0')}:${teraz.minute.toString().padLeft(2, '0')}';

      final nowy = ProduktDoZamowienia(
        nazwa: nazwa,
        ilosc: 0,
        kategoria: kategoria,
        dostawca: dostawca,
        lokal: '---',
        pracownik: '---',
        komentarz: '',
        dataZlozenia: teraz,
        czasZlozenia: czas,
      );

      await box.add(nowy);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produkt dodany ✅')),
      );

      setState(() {
        nazwa = '';
        kategoria = '';
        dostawca = '';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (widget.rola != 'admin') {
      return const Scaffold(
        body: Center(child: Text('Brak dostępu')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj produkt')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nazwa produktu'),
                onChanged: (val) => nazwa = val,
                validator: (val) => val == null || val.isEmpty ? 'Wpisz nazwę' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Kategoria'),
                onChanged: (val) => kategoria = val,
                validator: (val) => val == null || val.isEmpty ? 'Wpisz kategorię' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Dostawca'),
                onChanged: (val) => dostawca = val,
                validator: (val) => val == null || val.isEmpty ? 'Wpisz dostawcę' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: dodajProdukt,
                child: const Text('Dodaj'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
