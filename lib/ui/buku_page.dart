import 'package:aplikasimanajemenbuku/bloc/buku_bloc.dart';
import 'package:aplikasimanajemenbuku/bloc/logout_bloc.dart';
import 'package:aplikasimanajemenbuku/model/buku.dart';
import 'package:aplikasimanajemenbuku/ui/buku_detail.dart';
import 'package:aplikasimanajemenbuku/ui/buku_form.dart';
import 'package:aplikasimanajemenbuku/ui/login_page.dart';
import 'package:aplikasimanajemenbuku/widget/success_dialog.dart';
import 'package:flutter/material.dart';

class BukuPage extends StatefulWidget {
  const BukuPage({Key? key}) : super(key: key);

  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  @override
  Widget build(BuildContext context) {
    print("BukuPage built");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BukuForm())
                );
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            children: [
              ListTile(
                title: const Text('Logout', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.logout, color: Colors.white),
                onTap: () async {
                  await LogoutBloc.logout().then((value) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false,
                    );
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) =>
                      const SuccessDialog(
                        description: "Logout berhasil",
                      ),
                    );
                  });
                },
              )
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Buku>>(
          future: BukuBloc.getBuku(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Error fetching data'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            print("Data loaded: ${snapshot.data}");
            return ListBuku(list: snapshot.data);
          },
        ),
      ),
    );
  }
}

class ListBuku extends StatelessWidget {
  final List<Buku>? list;
  const ListBuku({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list?.length ?? 0,
      itemBuilder: (context, i) {
        return ItemBuku(buku: list![i]);
      },
    );
  }
}

class ItemBuku extends StatelessWidget {
  final Buku buku;
  const ItemBuku({Key? key, required this.buku}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BukuDetail(buku: buku),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          title: Text("Ketersediaan: ${buku.availability}"),
          subtitle: Text(
            "Nama Peminjam: ${buku.borrower_name ?? 'Belum Dipinjam'}\n"
                "Jumlah Hari Pinjam: ${buku.due_days ?? 'Tidak Ada'}",
          ),
        ),
      ),
    );
  }
}
