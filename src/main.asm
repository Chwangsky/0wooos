org 0x7C00  ; 코드의 시작 주소를 0x7C00으로 지정한다.
bits 16     ; 16비트임을 명시한다.

%define ENDL 0x0D, 0x0A     ; ENDL을 줄 바꿈 문자(캐리지 리턴과 라인피드)로 정의한다.

start:
    jmp main            ; 프로그램의 시작점을 정의한다.

; prints a string to the screen
; Params:
;   - ds:sI points to string
;
puts:
    ; save registers we will modify
    push si
    push ax

.loop:
    lodsb   ; loads next character in al
    or al, al   ; verify if next character is null?
    jz .done

    move ah, 0x0e
    int  0x10

.done:
    pop ax
    pop si
    ret
  
main:

    ; setup data segments;
    mov ax, 0       ; can't write to ds/es directly
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax;
    mov sp, 0x7C00

    ; print message
    mov si, msg_hello
    call puts

    hlt

.halt:
    jmp .halt

msg_hello: 'Hello world!', ENDL, 0

times 510-($-$$) db 0        ; 510바이트가 될 때까지 0으로 채운다. 이는 부트 섹터가 512바이트여야 하기 때문이다.
dw 0AA55h                    ; 부트섹터의 끝에 부트 시그니처(0xAA55)를 추가하여 BIOS가 부팅 가능한 섹터로 인식하게 한다.