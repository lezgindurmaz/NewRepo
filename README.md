# NewRepo Kernel

> Yayımlanmış en yeni etiket: [v5.1.0](https://github.com/lezgindurmaz/NewRepo/releases/tag/v5.1.0). Aşağıdaki v5.0 başlıklı notlar önceki README kapsamını anlatır.

Bu depo, 32-bit x86 mimarisi için deneysel bir çekirdek ve önyükleme denemeleri içerir. C çekirdeği, assembly giriş kodu, linker betiği ve GRUB yapılandırması depodadır.

> **Uyarı:** Kaynaklarda MBR/disk sektörlerine yazma işlemleri bulunur. Gerçek veya önemli veriler içeren bir diskte çalıştırmayın; yalnızca emülatör ya da atılabilir bir disk imajında test edin.

## Yenilikler (v5.0)
- **Detaylı HDD tespiti:** HDD model adı (örn. QEMU HARDDISK) ve boyut bilgisi (GB/MB ve sektör bazında).
- **Düzeltilmiş RAM raporlama:** Multiboot üzerinden gelen bellek bilgisinin ISO ve HDD boot durumlarında işlenmesi.
- **Daha tutarlı metinler:** Ekran çıktılarının sadeleştirilmesi.
- **Boot iyileştirmeleri:** Bootloader mesajları, A20 hattı ve LBA yükleme mantığında düzenlemeler.
- **Doğrulama:** Kurulum sırasında MBR ve kernel verileri yazıldıktan sonra doğrulanır.

## Örnek ekran çıktıları
- `Kernel Calisiyor`
- `Durum: Isodan boot edildi`
- `Depolama Bilgisi: [Model Name] | 1.25 GB (2621440 sektor)`
- `Bellek Bilgisi: 512 MB RAM (524288 KB)`

## Derleme

Aşağıdaki yönergeler mevcut depo notlarından alınmıştır; donanım/disk yazma adımlarını emülatörde veya geçici bir disk imajında doğrulayın.

### Bağımlılıklar
```bash
sudo apt-get update
sudo apt-get install -y nasm gcc-multilib grub-common grub-pc-bin xorriso mtools
```

### Derleme adımları
```bash
# 1. MBR'yi derle
nasm -f bin mbr.asm -o mbr.bin

# 2. Kernel ikilisini hazırla
touch kernel.bin
nasm -f elf32 boot.asm -o boot.o
gcc -m32 -c kernel.c -o kernel.o -ffreestanding -O2 -Wall -Wextra -fno-stack-protector -fno-pie
gcc -m32 -T linker.ld -o myos_tmp.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc -no-pie -Wl,--build-id=none
objcopy -O binary myos_tmp.bin kernel.bin

# 3. Final kernel'i derle
nasm -f elf32 boot.asm -o boot.o
gcc -m32 -c kernel.c -o kernel.o -ffreestanding -O2 -Wall -Wextra -fno-stack-protector -fno-pie
gcc -m32 -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc -no-pie -Wl,--build-id=none
```

### ISO oluşturma
```bash
mkdir -p isodir/boot/grub
cp myos.bin isodir/boot/myos.bin
cat > isodir/boot/grub/grub.cfg <<'EOF'
set timeout=0
set default=0
menuentry "NewRepo Kernel" {
    multiboot /boot/myos.bin
    boot
}
EOF
grub-mkrescue -o NewRepo.iso isodir
```
