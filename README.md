# NewRepo Kernel v4.0

Bu kernel x86 32-bit mimarisinde çalisan, yüksek kararlilikli HDD kurulum ve boot özelliklerine sahip bir çekirdektir.

## Yenilikler (v4.0)
- **Güvenli HDD Kurulumu:** Yazilan her sektör artik anlik olarak geri okunur ve kaynak veri ile karsilastirilir (Verification).
- **Hata Giderme:** HDD'den boot sirasinda yasanan loading sorunlari, DAP hizalamasi ve A20 hatti kontrolü ile tamamen çözülmüstür.
- **Detayli Bilgilendirme:** Kurulum sirasinda MBR ve her bir kernel sektörünün durumu ekranda gösterilir.
- **Daha Küçük Yükleyici:** MBR, kernel'in ilk 32KB'ini yükleyecek sekilde optimize edilmistir (Mevcut kernel ~14KB).

## Ekran Çiktilari
- "MBR v4.0 Loading Kernel... OK"
- "MBR Dogrulanıyor... OK"
- "Kernel yaziliyor... (sektör bazli dogrulama)"

## Derleme Komutlari
README dosyasindaki komutlar günceldir ve kararlidir.
