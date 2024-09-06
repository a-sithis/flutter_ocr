import 'package:flutter/material.dart'; 
import 'package:image_picker/image_picker.dart'; // Resim seçimi ve kamera kullanımını sağlamak için kullanılan paket.
import 'package:google_ml_kit/google_ml_kit.dart'; // Google ML Kit kullanarak OCR (Optik Karakter Tanıma) işlemi için gerekli paket.

void main() {
  runApp(OcrSayfasi()); 
}

class OcrSayfasi extends StatefulWidget { 
  @override
  _OcrSayfasiState createState() => _OcrSayfasiState(); 
}

class _OcrSayfasiState extends State<OcrSayfasi> {
  String _taninanYazi = ''; // OCR işlemi sonucunda tanınan yazıyı tutan değişken.
  final ImagePicker _resimSecici = ImagePicker(); // ImagePicker nesnesi, kamera veya galeriden resim seçmek için kullanılır.

  Future<void> _resimSec() async { // Kullanıcı kameradan resim çektiğinde çağrılan fonksiyon.
    try {
      final secilenDosya = await _resimSecici.pickImage(source: ImageSource.camera); // Kameradan resim seçimini sağlar.

      if (secilenDosya != null) { // Eğer bir resim seçildiyse:
        final resimYolu = secilenDosya.path; // Seçilen dosyanın yolunu alır.
        final yazi = await _resmiTani(resimYolu); // OCR ile resmi işleyip metin tanır.
        setState(() { // Tanınan yazıyı günceller.
          _taninanYazi = yazi; // OCR ile tanınan yazıyı _taninanYazi değişkenine atar.
        });
      }
    } catch (e) { // Hata oluşursa, bir hata mesajı gösterir.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')), // Hata mesajını kullanıcıya bildirir.
      );
    }
  }

  Future<String> _resmiTani(String resimYolu) async { // OCR işlemini gerçekleştiren fonksiyon.
    try {
      final girdiResmi = InputImage.fromFilePath(resimYolu); // Resim yolundan bir InputImage oluşturur.
      final metinTaniyici = GoogleMlKit.vision.textRecognizer(); // Google ML Kit metin tanıma (OCR) nesnesi oluşturulur.
      final taninanMetin = await metinTaniyici.processImage(girdiResmi); // Resmi OCR işlemiyle işleyip metni tanır.
      return taninanMetin.text; // Tanınan metni geri döner.
    } catch (e) { // Eğer bir hata olursa:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Metin çıkarılırken bir hata oluştu: $e')), // Hata mesajını kullanıcıya bildirir.
      );
      return ''; // Hata durumunda boş bir string döner.
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
                onPressed: _resimSec, // Butona basıldığında _resimSec fonksiyonunu çalıştırır.
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
                  child: Text(_taninanYazi), // Tanınan yazıyı gösterir.
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
