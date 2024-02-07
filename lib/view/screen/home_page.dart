import 'package:contact_dio/model/transaksi_model.dart';
import 'package:contact_dio/services/api_services.dart';
import 'package:contact_dio/services/auth_manager.dart';
import 'package:contact_dio/view/screen/invoice_page.dart';
import 'package:contact_dio/view/screen/login_page.dart';
import 'package:contact_dio/view/widget/contact_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _kodeBarangCtl = TextEditingController();
  final _namaBarangCtl = TextEditingController();
  final _satuanCtl = TextEditingController();
  final _hargaSatuanCtl = TextEditingController();
  final _subtotalCtl = TextEditingController();
  String _result = '-';
  final ApiServices _dataService = ApiServices();
  final List<Datum> _contactMdl = [];
  ResponsePost? ctRes;
  ResponseDelete? dlRes;
  bool isEdit = false;
  String idContact = '';

  late SharedPreferences logindata;
  String username = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    inital();
  }

  void inital() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username').toString();
      token = logindata.getString('token').toString();
    });
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _kodeBarangCtl.dispose();
    _namaBarangCtl.dispose();
    _satuanCtl.dispose();
    _hargaSatuanCtl.dispose();
    _subtotalCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mebel API'),
          actions: [
            IconButton(
              onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
              icon: const Icon(Icons.logout),
            ),
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: MySearchDelegate());
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 2.0),
                  color: Colors.tealAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.account_circle_rounded),
                            const SizedBox(width: 8.0),
                            Flexible(
                              child: Text(
                                'Login sebagai : $username',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.key),
                            const SizedBox(width: 8.0),
                            Flexible(
                              child: Text(
                                'Token : $token',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Two columns of form fields
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Column
                    Expanded(
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameCtl,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Nomor Faktur',
                              suffixIcon: IconButton(
                                onPressed: () => _nameCtl.clear(),
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          TextField(
                            controller: _kodeBarangCtl,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Kode Barang',
                              suffixIcon: IconButton(
                                onPressed: () => _kodeBarangCtl.clear(),
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          TextField(
                            controller: _namaBarangCtl,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Nama Barang',
                              suffixIcon: IconButton(
                                onPressed: () => _namaBarangCtl.clear(),
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        width: 16.0), // Add some spacing between columns
                    // Second Column
                    Expanded(
                      child: Column(
                        children: [
                          TextField(
                            controller: _satuanCtl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Satuan',
                              suffixIcon: IconButton(
                                onPressed: () => _satuanCtl.clear(),
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          TextField(
                            controller: _hargaSatuanCtl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Harga Satuan',
                              suffixIcon: IconButton(
                                onPressed: () => _hargaSatuanCtl.clear(),
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          TextField(
                            controller: _subtotalCtl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Subtotal',
                              suffixIcon: IconButton(
                                onPressed: () => _subtotalCtl.clear(),
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8.0,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_nameCtl.text.isEmpty ||
                                _kodeBarangCtl.text.isEmpty ||
                                _namaBarangCtl.text.isEmpty ||
                                _satuanCtl.text.isEmpty ||
                                _hargaSatuanCtl.text.isEmpty ||
                                _subtotalCtl.text.isEmpty) {
                              displaySnackbar('Semua field harus diisi');
                              return;
                            }
                            final postModel = Datum(
                              nomorFaktur: int.parse(_nameCtl.text),
                              kodeBarang: _kodeBarangCtl.text,
                              namaBarang: _namaBarangCtl.text,
                              satuan: int.parse(_satuanCtl.text),
                              hargaSatuan: int.parse(_hargaSatuanCtl.text),
                              subtotal: int.parse(_subtotalCtl.text),
                            );

                            ResponsePost? res;
                            if (isEdit) {
                              res = await _dataService.UpdateTransaksi(
                                  idContact, postModel);
                            } else {
                              res = await _dataService.postTransaksi(postModel);
                            }

                            setState(() {
                              ctRes = res;
                              isEdit = false;
                            });
                            _nameCtl.clear();
                            _kodeBarangCtl.clear();
                            _namaBarangCtl.clear();
                            _satuanCtl.clear();
                            _hargaSatuanCtl.clear();
                            _subtotalCtl.clear();
                            await refreshContactList();
                          },
                          child: Text(isEdit ? 'UPDATE' : 'POST'),
                        ),
                        if (isEdit)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              _nameCtl.clear();
                              _kodeBarangCtl.clear();
                              _namaBarangCtl.clear();
                              _satuanCtl.clear();
                              _hargaSatuanCtl.clear();
                              _subtotalCtl.clear();
                              setState(() {
                                isEdit = false;
                              });
                            },
                            child: const Text('Cancel Update'),
                          ),
                      ],
                    )
                  ],
                ),
                hasilCard(context),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await refreshContactList();
                          setState(() {});
                        },
                        child: const Text('Refresh Data'),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _result = '-';
                          _contactMdl.clear();
                          ctRes = null;
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'List Barang',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child:
                      _contactMdl.isEmpty ? Text(_result) : _buildListContact(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListContact() {
    return ListView.separated(
        itemBuilder: (context, index) {
          final ctList = _contactMdl[index];
          return Card(
            child: ListTile(
              // leading: Text(user.id),
              title: Text(ctList.nomorFaktur.toString()),
              subtitle: Text(ctList.namaBarang),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      final contacts = await _dataService
                          .getSingleTransaksi(ctList.nomorFaktur);
                      setState(() {
                        if (contacts != null) {
                          _nameCtl.text = contacts.nomorFaktur.toString();
                          _kodeBarangCtl.text = contacts.kodeBarang;
                          _namaBarangCtl.text = contacts.namaBarang;
                          _satuanCtl.text = contacts.satuan.toString();
                          _hargaSatuanCtl.text =
                              contacts.hargaSatuan.toString();
                          _subtotalCtl.text = contacts.subtotal.toString();
                          isEdit = true;
                          idContact = contacts.nomorFaktur.toString();
                        }
                      });
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(
                          ctList.nomorFaktur.toString(), ctList.namaBarang);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () async {
                      final contacts = await _dataService
                          .getSingleTransaksi(ctList.nomorFaktur);
                      setState(() {
                        if (contacts != null) {
                          // Navigate to the login page after processing the data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    InvoicePage(id: contacts.nomorFaktur)),
                          );
                        }
                      });
                    },
                    icon: const Icon(Icons.insert_drive_file_outlined),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10.0),
        itemCount: _contactMdl.length);
  }

  Widget hasilCard(BuildContext context) {
    return Column(children: [
      if (ctRes != null)
        ContactCard(
          ctRes: ctRes!,
          onDismissed: () {
            setState(() {
              ctRes = null;
            });
          },
        )
      else
        const Text(''),
    ]);
  }

  void _showDeleteConfirmationDialog(String id, String nama) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data $nama ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                ResponseDelete? res = await _dataService.deleteTransaksi(id);
                setState(() {
                  dlRes = res;
                });
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                await refreshContactList();
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                await AuthManager.logout();
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  dialogContext,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  Future<void> refreshContactList() async {
    final users = await _dataService.getAllTransaksi();
    setState(() {
      if (_contactMdl.isNotEmpty) _contactMdl.clear();
      if (users != null) _contactMdl.addAll(users);
    });
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}

class MySearchDelegate extends SearchDelegate {
  List<String> categories = [
    'Meja',
    'Kursi',
    'Stik Es Krim',
    'Lemari',
    'Papan'
  ];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    if (query.isNotEmpty) {
      for (var item in categories) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          matchQuery.add(item);
        }
      }
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(title: Text(result));
      },
      itemCount: matchQuery.length,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }
}
