import 'package:aplikasimanajemenbuku/bloc/buku_bloc.dart';
import 'package:aplikasimanajemenbuku/model/buku.dart';
import 'package:aplikasimanajemenbuku/ui/buku_page.dart';
import 'package:aplikasimanajemenbuku/widget/success_dialog.dart';
import 'package:aplikasimanajemenbuku/widget/warning_dialog.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BukuForm extends StatefulWidget {
  Buku? buku;
  BukuForm({Key? key, this.buku}) : super(key: key);

  @override
  _BukuFormState createState() => _BukuFormState();
}

class _BukuFormState extends State<BukuForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH BUKU";
  String tombolSubmit = "SIMPAN";

  // Controllers for form fields
  final _availabilityController = TextEditingController();
  final _borrowerNameController = TextEditingController();
  final _dueDaysController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.buku != null) {
      setState(() {
        judul = "UBAH BUKU";
        tombolSubmit = "UBAH";
        _availabilityController.text = widget.buku!.availability!;
        _borrowerNameController.text = widget.buku!.borrower_name ?? '';
        _dueDaysController.text = widget.buku!.due_days?.toString() ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // AppBar with Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: AppBar(
                title: Text(judul),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _availabilityTextField(),
                        _borrowerNameTextField(),
                        _dueDaysTextField(),
                        _buttonSubmit(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Textbox for Book Availability
  Widget _availabilityTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Ketersediaan Buku",
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
      controller: _availabilityController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Ketersediaan Buku harus diisi";
        }
        return null;
      },
    );
  }

  // Textbox for Borrower's Name
  Widget _borrowerNameTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Nama Peminjam",
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
      controller: _borrowerNameController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Peminjam harus diisi";
        }
        return null;
      },
    );
  }

  // Textbox for Due Days
  Widget _dueDaysTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Jumlah Hari Pinjam",
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      controller: _dueDaysController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Jumlah Hari Pinjam harus diisi";
        }
        if (int.tryParse(value) == null) {
          return "Harus berupa angka";
        }
        return null;
      },
    );
  }

  // Submit Button with Gradient
  Widget _buttonSubmit() {
    return Container(
      width: double.infinity,
      height: 50.0,
      margin: const EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(tombolSubmit),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              if (widget.buku != null) {
                ubah();
              } else {
                simpan();
              }
            }
          }
        },
      ),
    );
  }

  // Function to Save New Book

  // Function to Update Book Data
  void ubah() {
    setState(() {
      _isLoading = true;
    });
    Buku updatedBuku = Buku(
      id: widget.buku!.id,
      availability: _availabilityController.text,
      borrower_name: _borrowerNameController.text,
      due_days: int.tryParse(_dueDaysController.text),
    );
    BukuBloc.updateBuku(buku: updatedBuku).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const BukuPage()));
      showDialog(
          context: context,
          builder: (BuildContext context) => const SuccessDialog(
            description: "Data berhasil diubah",
          ));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Permintaan ubah data gagal, silahkan coba lagi",
          ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}
