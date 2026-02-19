[bits 16]
[org 0x7c00]

; FAT32 Boot Sector Structure
jmp short start
nop

; BPB for FAT32
OEMName             db "NEWREPO "
BytesPerSector      dw 512
SectorsPerCluster   db 8
ReservedSectors     dw 2048 
NumberOfFATs        db 2
RootEntries         dw 0
TotalSectors16      dw 0
Media               db 0xF8
SectorsPerFAT16     dw 0
SectorsPerTrack     dw 63
HeadsPerDrive       dw 255
HiddenSectors       dd 0
TotalSectors32      dd 0 

; FAT32 Extended fields
SectorsPerFAT32     dd 0
ExtFlags            dw 0
FSVersion           dw 0
RootCluster         dd 2
FSInfo              dw 1
BackupBootSector    dw 6
Reserved            times 12 db 0
DriveNumber         db 0x80
Reserved1           db 0
BootSignature       db 0x29
VolumeID            dd 0x12345678
VolumeLabel         db "NEWREPO    "
FileSystemType      db "FAT32   "

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti

    mov [boot_drive], dl

    ; Enable A20 Line (Fast A20) - Essential for 1MB+ access
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Load Kernel using LBA Extensions (Sector 1, load 256 sectors = 128KB)
    mov ah, 0x42
    mov dl, [boot_drive]
    mov si, dap
    int 0x13
    jc disk_error

    ; Switch to Protected Mode
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    
    ; Setup segment registers for PM
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Magic and params for Kernel
    mov eax, 0x1337B001
    mov ebx, 0

    ; Relocate kernel from 0x8000 to 1MB
    mov esi, 0x8000
    mov edi, 0x100000
    mov ecx, 32768 ; 128KB in dwords
    rep movsd

    ; Jump to kernel (1MB)
    jmp 0x08:0x100000

halt:
    hlt
    jmp halt

disk_error:
    mov si, msg_error
    call print_string_16
    jmp halt

print_string_16:
    mov ah, 0x0e
.loop:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

; Disk Address Packet
align 4
dap:
    db 0x10    ; Size
    db 0       ; Reserved
    dw 256     ; Sectors to read (128KB)
    dw 0x8000  ; Offset
    dw 0x0000  ; Segment
    dq 1       ; Start LBA (Sector 1)

boot_drive db 0x80
msg_error   db "MBR Error!", 0

gdt_start:
    dd 0x0, 0x0
gdt_code:
    dw 0xffff, 0x0
    db 0x0, 10011010b, 11001111b, 0x0
gdt_data:
    dw 0xffff, 0x0
    db 0x0, 10010010b, 11001111b, 0x0
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

times 510-($-$$) db 0
dw 0xaa55
