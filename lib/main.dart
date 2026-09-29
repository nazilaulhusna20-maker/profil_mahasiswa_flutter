import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profil Mahasiswa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controller input
  final TextEditingController namaController =
      TextEditingController(text: 'Nazila Ul Husna');

  final TextEditingController npmController =
      TextEditingController(text: '2408007010016');

  final TextEditingController jurusanController =
      TextEditingController(text: 'Manajemen Informatika');

  // Image Picker
  final ImagePicker picker = ImagePicker();

  File? fotoProfil;

  // Data tersimpan
  String? namaTersimpan;
  String? npmTersimpan;
  String? jurusanTersimpan;
  File? fotoTersimpan;

  // Memilih foto dari galeri
  Future<void> pilihFoto() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        fotoProfil = File(image.path);
      });
    }
  }

  // Menyimpan data
  void simpanData() {
    if (namaController.text.isEmpty ||
        npmController.text.isEmpty ||
        jurusanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan lengkapi semua data terlebih dahulu',
          ),
        ),
      );
      return;
    }

    setState(() {
      namaTersimpan = namaController.text;
      npmTersimpan = npmController.text;
      jurusanTersimpan = jurusanController.text;
      fotoTersimpan = fotoProfil;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data berhasil disimpan'),
      ),
    );
  }

  // Kembali ke form untuk mengedit data
  void editProfil() {
    setState(() {
      namaTersimpan = null;
      npmTersimpan = null;
      jurusanTersimpan = null;
      fotoTersimpan = null;
    });
  }

  @override
  void dispose() {
    namaController.dispose();
    npmController.dispose();
    jurusanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Mahasiswa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: namaTersimpan == null
            ? _buildForm()
            : _buildProfilTersimpan(),
      ),
    );
  }

  // =========================
  // FORM DATA PROFIL
  // =========================
  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Data Profil',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Silakan lengkapi data profil Anda',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 25),

        // FOTO PROFIL
        Center(
          child: GestureDetector(
            onTap: pilihFoto,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage: fotoProfil != null
                      ? FileImage(fotoProfil!)
                      : null,
                  child: fotoProfil == null
                      ? Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.blue.shade700,
                        )
                      : null,
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        const Center(
          child: Text(
            'Klik foto untuk memilih foto profil',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ),

        const SizedBox(height: 25),

        // INPUT NAMA
        TextField(
          controller: namaController,
          decoration: InputDecoration(
            labelText: 'Nama',
            hintText: 'Masukkan nama',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // INPUT NPM
        TextField(
          controller: npmController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'NPM',
            hintText: 'Masukkan NPM',
            prefixIcon: const Icon(Icons.badge),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // INPUT JURUSAN
        TextField(
          controller: jurusanController,
          decoration: InputDecoration(
            labelText: 'Jurusan',
            hintText: 'Masukkan jurusan',
            prefixIcon: const Icon(Icons.school),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 25),

        // BUTTON SAVE
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: simpanData,
            icon: const Icon(Icons.save),
            label: const Text(
              'Save',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // PROFIL SETELAH DISIMPAN
  // =========================
  Widget _buildProfilTersimpan() {
    return Column(
      children: [
        const SizedBox(height: 20),

        const Text(
          'Profil Mahasiswa',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 30),

        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                // FOTO
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage: fotoTersimpan != null
                      ? FileImage(fotoTersimpan!)
                      : null,
                  child: fotoTersimpan == null
                      ? Icon(
                          Icons.person,
                          size: 75,
                          color: Colors.blue.shade700,
                        )
                      : null,
                ),

                const SizedBox(height: 25),

                // NAMA
                Text(
                  namaTersimpan!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                // NPM
                Row(
                  children: [
                    const Icon(
                      Icons.badge,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'NPM',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        npmTersimpan!,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // JURUSAN
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.school,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Jurusan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        jurusanTersimpan!,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 25),

        // TOMBOL EDIT
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: editProfil,
            icon: const Icon(Icons.edit),
            label: const Text(
              'Edit Profil',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}