# NewRepo Kernel

Bu kernel x86 32-bit mimarisinde çalisan, Multiboot uyumlu, mavi ekran üzerine beyaz yazi yazan basit bir isletim sistemi çekirdegidir.

## Özellikler
- VGA 80x25 Metin Modu (Mavi Arka Plan, Beyaz Yazi)
- RAM Test (0x1000000 adresine yazma ve okuma)
- Klavye Testi (Standart Ingilizce QWERTY)
- Multiboot Desteği

## Derleme Komutlari

Bu kernel'i derlemek için kullanilan komutlar:

### 1. Bagimliliklarin Kurulmasi
```bash
sudo apt-get update
sudo apt-get install -y nasm gcc-multilib grub-common grub-pc-bin xorriso mtools
```

### 2. Assembly Kodunun Derlenmesi (boot.asm)
```bash
nasm -felf32 boot.asm -o boot.o
```

### 3. C Kodunun Derlenmesi (kernel.c)
```bash
gcc -m32 -c kernel.c -o kernel.o -ffreestanding -O2 -Wall -Wextra -fno-stack-protector -fno-pie
```

### 4. Linkleme (myos.bin)
```bash
gcc -m32 -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc -no-pie -Wl,--build-id=none
```

### 5. ISO Olusturma
```bash
mkdir -p isodir/boot/grub
cp myos.bin isodir/boot/myos.bin
echo 'set timeout=0
set default=0

menuentry "NewRepo Kernel" {
	multiboot /boot/myos.bin
	boot
}' > isodir/boot/grub/grub.cfg

grub-mkrescue -o NewRepo.iso isodir
```
