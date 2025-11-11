%define SYS_WRITE 1
%define SYS_EXIT  60
%define STDOUT    1
SECTION .data
    N       dq 10
    space   db ' ', 0
    newline db 10
SECTION .bss
    num_buffer resb 20
SECTION .text
global _start
_start:
    mov r10, [N]
    mov r8, 1
    mov r9, 1
    mov rdi, r8
    call _print_number
    call _print_space
    cmp r10, 1
    je .done
    mov rdi, r9
    call _print_number
    call _print_space
    cmp r10, 2
    je .done
    mov rcx, 3
.loop:
    cmp rcx, r10
    jg .done
    mov rax, r8
    add rax, r9
    mov rdi, rax
    call _print_number
    call _print_space
    mov r8, r9
    mov r9, rax
    
    inc rcx
    jmp .loop
.done:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, newline
    mov rdx, 1
    syscall
    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall
_print_number:
    mov rax, rdi
    mov rbx, 10
    mov rcx, num_buffer + 19
    mov byte [rcx], 0
    dec rcx
    cmp rax, 0
    jne .convert_loop
    mov byte [rcx], '0'
    dec rcx
    jmp .print
.convert_loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rcx], dl
    dec rcx
    cmp rax, 0
    jnz .convert_loop
.print:
    inc rcx
    mov rsi, rcx
    mov rdx, num_buffer + 19
    sub rdx, rsi

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    syscall
    ret
_print_space:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, space
    mov rdx, 1
    syscall
    ret