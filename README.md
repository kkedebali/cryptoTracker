# 🪙 CryptoTrack - Kripto Takip Uygulaması

Modern Flutter standartları ve **Clean Architecture** prensipleriyle geliştirilmiş, anlık kripto para takip, arama, favorileme ve döviz dönüşüm uygulaması.

---

## ✨ Ekran görüntüleri
<img width="300" alt="Image" src="https://github.com/user-attachments/assets/4856dfc3-8184-4b6d-bb0e-cbe3c4fff83c"/>
<img width="300" alt="Image" src="https://github.com/user-attachments/assets/39c6f21c-810d-428b-a650-fb9b04c8d2ba"/>

---

## 🚀 Öne Çıkan Özellikler

- **Clean Architecture:** Sürdürülebilir, test edilebilir ve katmanlı mimari (`Data`, `Domain`, `Presentation`).
- **State Management:** BLoC (Event-Driven) pattern ile temiz ve performanslı durum yönetimi.
- **Canlı & Akıllı Veri:** 30 saniyede bir otomatik güncellenen coin verileri (CoinGecko API entegrasyonu).
- **Lokal Veritabanı:** `Hive` altyapısı ile çevrimdışı (offline) veri saklama ve favori yönetimi.
- **Gelişmiş Arama & Filtreleme:** Anlık arama filtresi ve farklı para birimi (`TRY`, `USD`, `EUR`) dönüşümleri.
- **Modern UI/UX:** `Shimmer` efekti destekli profesyonel **Skeleton Loading** tasarımı.

---

## 🛠️ Kullanılan Teknolojiler ve Paketler

Projede endüstri standardı olan şu modern araçlar ve kütüphaneler tercih edilmiştir:

* **Flutter & Dart**
* **flutter_bloc** (State Management)
* **Dio** (Ağ yönetimi ve hata yönetimi)
* **Hive** (NoSQL lokal veritabanı)
* **Shimmer** (Yüklenme animasyonları)

---

## 📂 Mimari Yapı (Clean Architecture)

```text
lib/
│
├── app/           # API Anahtarları, app verileri vs. (.gitignore)
├── core/          # Tema sabitleri, Network servisi vs.
├── data/          # Modeller, API servisleri ve Hive veritabanı işlemleri
├── domain/        # Entity'ler ve iş kuralları
└── presentation/  # BLoC, ekranlar ve UI bileşenleri (global widgets)