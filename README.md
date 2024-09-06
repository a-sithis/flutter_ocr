Çekilen fotoğrafın google-ml-kit kullanılarak ocr işlemini yapmasını sağlar.
Emülatörden kamera ayarlarını webcam olarak değiştirin.
Android izinlerini unutmayın; 
Uygulamanızın AndroidManifest.xml dosyasına şu izinleri eklemeniz gerekir:
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
..
Pubspec.yaml dosyanızda dependencies: başlığı altın da 
image_picker: ^1.1.2
google_ml_kit: ^0.18.0
bu iki paketin güncel sürümlerini eklemeniz gerekir.
