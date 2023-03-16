; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_list_sort.s                                     :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: jmaia <jmaia@student.42.fr>                +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2023/03/14 18:53:42 by jmaia             #+#    #+#              ;
;    Updated: 2023/03/16 13:54:33 by jmaia            ###   ###                ;
;                                                                              ;
; **************************************************************************** ;

struc list
        .data   resq    1
        .next   resq    1
endstruc

section .text
        global ft_list_sort

; void ft_list_sort(t_list **begin_list, int (*cmp)())
; void ft_list_sort(rdi **begin_list, rsi (*cmp)())
ft_list_sort:
	push	rbp						; Save rbp
	mov 	rbp, rsp				; Move rsp to rbp
	sub 	rsp, 32 				; 4 variables (begin_list, cmp, first_node, second_node)

	mov 	[rbp - 8], rdi			; Save begin_list to stack
	mov 	[rbp - 16], rsi			; Save cmp to stack

	mov 	rax, [rdi]				; Set current first node..
	mov 	[rbp - 24], rax			; ..

	cmp		rax, 0					; If first node is NULL
	je		end						; Then go to the end

	begin_first_loop:
		mov rdi, [rbp - 24]			; Copy current first node to rdi
		cmp rdi, 0					; If current first node is NULL
		je end						; Then, go to the end

		mov	rax, [rdi + list.next]	; Set current second node..
		mov	[rbp - 32], rax			; ..
		begin_second_loop:
			mov		rdi, [rbp - 24]		    ; Move current first node to rdi
			mov		rsi, [rbp - 32]		    ; Move current second node to rsi
			cmp		rsi, 0				    ; If second node is NULL
			je		end_second_loop		    ; Exit the loop

            mov     rdi, [rdi + list.data]  ; Move first node data to rdi
            mov     rsi, [rsi + list.data]  ; Move second node data to rsi
			call	[rbp - 16]			    ; Call cmp on first node and second node
			cmp		eax, 0				    ; If return value is > 0
			jg		l_switch_node		    ; Then, switch node
			jmp		l_next				    ; Else, go to next
			l_switch_node:
                mov     rdi, [rbp - 24]     ; Move current first node to rdi
                mov     rsi, [rbp - 32]     ; Move current second node to rsi
				call	switch_nodes		; Then, switch nodes
			l_next:
			mov		rsi, [rbp - 32]			; Copy second node to rsi
			mov		rsi, [rsi + list.next]	; Treat next second node
			mov		[rbp - 32], rsi
			jmp		begin_second_loop		; Do the loop
		end_second_loop:
		mov	rdi, [rbp - 24]				; Copy first node to rdi
		mov	rdi, [rdi + list.next]		; Treat next first node
		mov	[rbp - 24], rdi
		jmp	begin_first_loop			; Do the loop
			
end:
	add rsp, 32
	pop rbp
	ret	

; void	switch_nodes(rdi, rsi)
switch_nodes:
	mov rax, [rdi + list.data]	; Save first node data to rax
	mov rcx, [rsi + list.data]	; Save second node data to rcx
	mov [rdi + list.data], rcx	; Set first node data to second node data
	mov [rsi + list.data], rax	; Set second node data to first node data
	ret
