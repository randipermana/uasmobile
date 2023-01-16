import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randi_mobile/item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    CollectionReference users = firebase.collection('users');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text('Flutter Mobile Apps FireBase'),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            children: [
              //// VIEW DATA HERE
              StreamBuilder<QuerySnapshot>(
                stream: users.snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data?.docs
                          .map(
                            (e) => ItemCard(
                              e['name'],
                              e['age'],

                              //Konfigurasi Tombol Untuk Delete
                              onDelete: () {
                                users.doc(e.id).delete();
                              },

                              onUpdate: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Edit Data'),
                                    actions: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          style: GoogleFonts.poppins(),
                                          decoration: const InputDecoration(
                                              hintText: "Masukkan Nama"),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          style: GoogleFonts.poppins(),
                                          decoration: const InputDecoration(
                                              hintText: "Masukkan Umur"),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('EDIT'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                          .toList() as List<Widget>,
                    );
                  } else {
                    return const Text('Data Belum Terisi');
                  }
                },
              ),

              const SizedBox(
                height: 150,
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(-5, 0),
                    blurRadius: 15,
                    spreadRadius: 3)
              ]),
              width: double.infinity,
              height: 130,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          style: GoogleFonts.poppins(),
                          controller: nameController,
                          decoration:
                              const InputDecoration(hintText: "Masukkan Nama"),
                        ),
                        TextField(
                          style: GoogleFonts.poppins(),
                          controller: ageController,
                          decoration:
                              const InputDecoration(hintText: "Masukkan Umur"),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  //Tombol Untuk Menambah Data
                  Container(
                    height: 130,
                    width: 130,
                    padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: Colors.blue[900],
                        ),
                        child: Text(
                          'Add Data',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          //// ADD DATA HERE
                          users.add({
                            'name': nameController.text,
                            'age': int.tryParse(ageController.text) ?? 0,
                          });
                          nameController.text = '';
                          ageController.text = '';
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
