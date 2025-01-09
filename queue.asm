.model small
.stack 100h
.data
    QUEUE_SIZE   equ 10
    queue        dw QUEUE_SIZE dup(?)  ; Массив для хранения элементов очереди
    head         dw 0                  ; Индекс головы очереди
    tail         dw 0                  ; Индекс хвоста очереди
    count        dw 0                  ; Счетчик элементов в очереди
    buffer       db 7 dup('$')         ; Буфер для строки (6 символов + '$')
    ten          dw 10                 ; Константа для деления на 10
    empty_msg    db 'The queue is empty', 0Dh, 0Ah, '$'  ; Сообщение о пустой очереди
.code
main:
    ; Инициализация сегментов
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; Добавление элементов в очередь
    mov ax, 1
    call enqueue
    mov ax, 32
    call enqueue
    mov ax, 5678
    call enqueue
    mov ax, -1234
    call enqueue
    mov ax, 0
    call enqueue
    mov ax, 50
    call enqueue

    ; Извлечение элементов из очереди и вывод их на экран
    call dequeue
    call print_number

    call dequeue
    call print_number

    call dequeue
    call print_number
    
    call dequeue
    call print_number
    
    call dequeue
    call print_number
    
    call dequeue
    call print_number

    ; Попытка извлечения из пустой очереди
    call dequeue
    call dequeue

    ; Завершение программы
    mov ax, 4C00h
    int 21h

; Процедура добавления нового элемента в очередь
enqueue proc
    push ax
    push bx
    push si

    ; Проверка на переполнение очереди
    mov cx, count
    cmp cx, QUEUE_SIZE
    je queue_full

    mov bx, tail
    shl bx, 1               ; Умножаем индекс на 2 (размер слова)
    lea si, queue[bx]
    mov [si], ax

    inc tail
    cmp tail, QUEUE_SIZE
    jne skip_reset_tail
    mov tail, 0

skip_reset_tail:
    ; Увеличение счетчика элементов
    inc count

queue_full:
    pop si
    pop bx
    pop ax
    ret
enqueue endp

; Процедура выборки очередного элемента из очереди (со сдвигом очереди)
dequeue proc
    push bx
    push si

    ; Проверка на пустоту очереди
    mov cx, count
    cmp cx, 0
    je queue_empty

    mov bx, head
    shl bx, 1               ; Умножаем индекс на 2 (размер слова)
    lea si, queue[bx]
    mov ax, [si]

    inc head
    cmp head, QUEUE_SIZE
    jne skip_reset_head
    mov head, 0

skip_reset_head:
    ; Уменьшение счетчика элементов
    dec count

    pop si
    pop bx
    ret

queue_empty:
    ; Печать сообщения о пустой очереди
    lea dx, empty_msg
    mov ah, 09h
    int 21h

    pop si
    pop bx
    xor ax, ax  ; Возвращаем 0 в ax
    ret
dequeue endp

print_number proc
    ; Инициализация указателя на конец буфера
    lea di, buffer + 6       ; Указатель на конец буфера (исключая символ '$')

    ; Инициализация флага отрицательного числа
    mov bx, 0                ; Сброс флага отрицательного числа

    ; Проверка числа на 0
    cmp ax, 0
    jge convert_start        ; Если число >= 0, переход к преобразованию

    ; Обработка отрицательного числа
    neg ax                   ; Преобразование числа в положительное
    mov bx, 1                ; Установка флага отрицательного числа

convert_start:
    mov cx, 0                ; Сброс счетчика символов

convert_loop:
    xor dx, dx               ; Очистка DX перед делением
    div ten                  ; AX / 10, результат в AX, остаток в DX
    add dl, '0'              ; Преобразование остатка в ASCII-символ
    dec di                   ; Сдвиг указателя на одну позицию влево
    mov [di], dl             ; Запись символа в буфер
    inc cx                   ; Увеличение счетчика символов
    cmp ax, 0                ; Проверка, все ли цифры обработаны
    jne convert_loop         ; Если нет, продолжение цикла

    ; Обработка вывода строки
    lea dx, buffer + 6       ; Указатель на конец буфера
    sub dx, cx               ; Сдвиг указателя на начало числа

    ; Проверка на наличие знака '-'
    cmp bx, 1
    jne skip_minus
    dec dx                   ; Сдвиг указателя на одну позицию влево
    mov byte ptr [di-1], '-' ; Запись '-' в начало строки

skip_minus:
    ; Вывод строки на экран
    mov ah, 09h
    int 21h

    ; Печать символов новой строки и возврата каретки
    mov ah, 02h
    mov dl, 0Dh              ; Символ возврата каретки
    int 21h
    mov dl, 0Ah              ; Символ новой строки
    int 21h

    ret
print_number endp
end main
