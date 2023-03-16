; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_list_remove_if.s                                :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2023/03/16 13:31:51 by jmaia             #+#    #+#              ;
;    Updated: 2023/03/16 15:41:18 by jmaia            ###   ###                ;
;                                                                              ;
; **************************************************************************** ;

struc list
        .data   resq    1
        .next   resq    1
endstruc

section .text
        global ft_list_remove_if
        extern free

; void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *))
; void ft_list_remove_if(rdi begin_list, rsi data_ref, rdx (*cmp)(), rcx (*free_fct)(void *))
ft_list_remove_if:
        push    rbp             ; Save rbp
        mov     rbp, rsp        ; Move rsp to rbp
        sub     rsp, 48         ; 6 variables (parameters + current node + previous_node)

        mov     [rbp - 8], rdi  ; Save begin_list to stack
        mov     [rbp - 16], rsi ; Save data_ref to stack
        mov     [rbp - 24], rdx ; Save cmp to stack
        mov     [rbp - 32], rcx ; Save free_fct to stack

        mov     rax, [rdi]      ; Set current node..
        mov     [rbp - 40], rax ; ..

        mov     QWORD [rbp - 48], 0   ; Set default previous_node to NULL

        begin_loop:
                mov     rdi, [rbp - 40]         ; Copy current node to rdi
                cmp     rdi, 0                  ; If current node is NULL
                je      end                     ; Then, go to the end

                mov     rax, [rdi + list.next]  ; Copy next node to rax
                push    rax                     ; Save it on the stack
                mov     rdi, [rdi + list.data]  ; Copy data to rdi
                mov     rsi, [rbp - 16]         ; Copy data ref to rsi
                call    [rbp - 24]              ; Call cmp on current node and data ref
                cmp     eax, 0                  ; If current node and data ref are equals
                je      if_equals               ; ...
                jmp     if_not_equals           ; ...
                if_equals:
                        mov     rdi, [rbp - 40]         ; Copy current node to rdi
                        mov     rsi, [rbp - 8]          ; Copy begin list to rsi
                        mov     rdx, [rbp - 48]         ; Copy previous_node to rdx
                        mov     rcx, [rbp - 32]         ; Copy free_fct to rcx
                        call    delete_node             ; Delete node
                        jmp     after_if_equals         ; Continue code
                if_not_equals:
                        mov     rdi, [rbp - 40]         ; Copy current node to rdi
                        mov     [rbp - 48], rdi         ; Set previous_node to old current node
                        jmp     after_if_equals         ; Continue code
                after_if_equals:
                pop     rdi                     ; Restore next node from stack
                mov     [rbp - 40], rdi         ; Set it as current node
                jmp     begin_loop

        end:
        add rsp, 48             ; Restore stack initial state
        pop rbp                 ; Restore old rbp
        ret

;void    delete_node(t_list *node, t_list **begin_list, t_list *previous_node, fct_ptr free_fct)
;void    delete_node(rdi node, rsi begin_list, rdx previous_node, rcx free_fct)
delete_node:
        mov     r8, [rdi + list.next]           ; Save next node to r8
        cmp     rdx, 0                          ; If previous_node does not exist
        je      no_previous_node                ; ...
        jmp     previous_node_exists            ; ...

        no_previous_node:
                mov     [rsi], r8               ; Set new begin_list to next node
        previous_node_exists:
                mov     [rdx + list.next], r8   ; Set next of precedent node to next node

        push    rdi                             ; Save current node on the stack
        mov     rdi, [rdi + list.data]          ; Put data of deleted node to rdi
        cmp     rcx, 0                          ; If free_fct is NULL
        je      after_free_data                 ; Jump after free_data
        call    rcx                             ; Free data of deleted node
        after_free_data:
        pop     rdi                             ; Restore deleted node
        call    free                            ; Free deleted node
        ret
