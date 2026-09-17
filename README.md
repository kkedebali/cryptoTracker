# 🪙 CryptoTrack - Kripto Takip Uygulaması

Modern Flutter standartları ve **Clean Architecture** prensipleriyle geliştirilmiş, anlık kripto para takip, arama, favorileme ve döviz dönüşüm uygulaması.

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