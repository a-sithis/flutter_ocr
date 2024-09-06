import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

void main() {
  runApp(OcrSayfasi());
}

class OcrSayfasi extends StatefulWidget {
  @override
  _OcrSayfasiState createState() => _OcrSayfasiState();
}

class _OcrSayfasiState extends State<OcrSayfasi> {
  String _taninanYazi = '';
  final ImagePicker _resimSecici = ImagePicker(); // ImagePicker nesnesi

  Future<void> _resimSec() async {
    try {
      final secilenDosya = await _resimSecici.pickImage(source: ImageSource.camera); // Kameradan resim seçimi

      if (secilenDosya != null) {
        final resimYolu = secilenDosya.path;
        final yazi = await _resmiTani(resimYolu);
        setState(() {
          _taninanYazi = yazi;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }

  Future<String> _resmiTani(String resimYolu) async {
    try {
      final girdiResmi = InputImage.fromFilePath(resimYolu);
      final metinTaniyici = GoogleMlKit.vision.textRecognizer();
      final taninanMetin = await metinTaniyici.processImage(girdiResmi);
      return taninanMetin.text;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Metin çıkarılırken bir hata oluştu: $e')),
      );
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Google ML Kit ile OCR'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                onPressed: _resimSec,
                child: Text('Fotoğraf Çek'),
              ),
              SizedBox(height: 20),
              Text(
                'Tanınan Yazı:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_taninanYazi),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
