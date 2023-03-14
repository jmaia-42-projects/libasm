; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_list_size.s                                     :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2023/03/14 18:14:24 by jmaia             #+#    #+#              ;
;    Updated: 2023/03/14 18:52:33 by jmaia            ###   ###                ;
;                                                                              ;
; **************************************************************************** ;

struc list
        .data   resq    1
        .next   resq    1
endstruc

section .text
        global ft_list_size

; int ft_list_size(t_list *begin_list)
; eax ft_list_size(rdi begin_list)
ft_list_size:
        xor rax, rax                    ; Set counter to 0
begin_loop:
        cmp rdi, 0                      ; If we reached end of the list
        je end                          ; Then, go to the end
        inc eax                         ; Else, increment counter
        mov rdi, [rdi + list.next]      ; Change to next node
        jmp begin_loop                  ; Treat next node
end:
        ret
