import 'package:flutter/material.dart';
import 'package:contact_dio/services/api_services.dart';

class Transaksi {
  // Assume you have a model class for Transaksi
  final int nomorFaktur;
  final String kodeBarang;
  final String namaBarang;
  final int satuan;
  final int hargaSatuan;
  final int subtotal;

  Transaksi({
    required this.nomorFaktur,
    required this.kodeBarang,
    required this.namaBarang,
    required this.satuan,
    required this.hargaSatuan,
    required this.subtotal,
  });
}

class InvoicePage extends StatefulWidget {
  final int id;

  InvoicePage({required this.id});

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final ApiServices _dataService = ApiServices();
  List<Transaksi> transactions = []; // List to store fetched transactions

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is created (you might want to trigger this based on user actions)
    fetchData();
  }

  Future<void> fetchData() async {
    final contacts = await _dataService.getSingleTransaksi(widget.id);
    // For demonstration purposes, using dummy data
    List<Transaksi> fetchedData = [
      Transaksi(
        nomorFaktur: contacts!.nomorFaktur,
        kodeBarang: contacts.kodeBarang,
        namaBarang: contacts.namaBarang,
        satuan: contacts.satuan,
        hargaSatuan: contacts.hargaSatuan,
        subtotal: contacts.subtotal,
      ),
    ];

    setState(() {
      transactions = fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Display other static UI components

            // Display dynamic data in a ListView.builder
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  Transaksi transaction = transactions[index];
                  return ListTile(
                    title: Text('Item ${index + 1}'),
                    subtitle: Text(transaction.namaBarang),
                    trailing:
                        Text('\IDR${transaction.subtotal.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),

            // Calculate and display total
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: \IDR${transactions.fold(0.0, (total, transaksi) => total + transaksi.subtotal).toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
