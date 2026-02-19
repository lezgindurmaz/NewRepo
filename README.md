# NewRepo Kernel v3.0

Bu kernel x86 32-bit mimarisinde çalisan, Multiboot ve MBR uyumlu, FAT32 dosya sistemi yapisina sahip bir çekirdektir.

## Yenilikler (v3.0)
- **Gelistirilmis Depolama Destegi:** LBA48 destegi ile çok büyük disklerin (TB seviyesi) boyutunu dogru hesaplar ve gösterir.
- **FAT32 Dosya Sistemi:** HDD'ye kurulumda diski FAT32 standartlarina uygun (BPB dahil) formatlar.
- **Kararli Boot (LBA):** HDD'den boot ederken eski CHS yöntemi yerine modern LBA Extensions (`int 0x13 ah=0x42`) kullanir. Bu sayede her türlü disk boyutunda loading hatasi giderilmistir.
- **Detayli Bilgi:** Disk boyutu GB ve MB cinsinden hassas olarak gösterilir.

## Ekran Çiktilari
- "Kernel Çalisiyor"
- "Durum: Isodan/Depolama alanindan boot edildi"
- "Depolama Bilgisi: ... GB (... sektor)"
- "Bellek Bilgisi: ... MB RAM"

## Teknik Detaylar
1. **MBR (`mbr.asm`):** Artik bir FAT32 Boot Sector (`jmp short start + NOP + BPB`) yapisindadir. LBA paketlerini kullanarak kernel'i diskten yükler.
2. **Kurulum:** Kernel, hedef diske MBR'yi yazar, ardindan kernel'i "Reserved Sectors" alanina yerlestirir. Bu sayede dosya sistemiyle çakisma önlenir ve sistem kararliligi artar.

## Derleme ve Kullanim
`README_V2` üzerindeki derleme komutlari geçerlidir. Yeni ISO'yu kullanarak sistemi baslatin ve HDD'ye kurulumu seçin.
