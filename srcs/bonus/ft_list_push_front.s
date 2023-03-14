; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_list_push_front.s                               :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2023/03/14 14:26:05 by jmaia             #+#    #+#              ;
;    Updated: 2023/03/14 18:12:44 by jmaia            ###   ###                ;
;                                                                              ;
; **************************************************************************** ;

struc list
        .data   resq    1
        .next   resq    1
endstruc

section .text
        global ft_list_push_front
        extern malloc

; void  ft_list_push_front(t_list **begin_list, void *data)
; void  ft_list_push_front(rdi begin_list, rsi data)
ft_list_push_front:
        push rdi                        ; Save begin_list pointer
        push rsi                        ; Save data pointer
        mov rdi, list_size              ; Set 1st argument of malloc to struct size
        call malloc                     ; Call malloc
        pop rsi                         ; Restore data pointer
        pop rdi                         ; Restore begin_list pointer
        cmp rax, 0                      ; If malloc returned null
        je end                          ; Then jump to the end
        mov [rax + list.data], rsi      ; Set data value of new node to given data
        mov rdx, [rdi]                  ; Move current head pointer to rdx
        mov [rax + list.next], rdx      ; Set next value of new node to current head
        mov [rdi], rax                  ; Set head to new node
        jmp end                         ; Go to the end
end:
        ret
