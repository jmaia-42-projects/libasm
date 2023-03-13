section .text
	global ft_atoi_base
	extern ft_strlen

; int ft_atoi_base(char *str, char *base)
; eax ft_atoi_base(rdi str, rsi base)
ft_atoi_base:
	; Setup stack frame
	push rbp
	mov rbp, rsp

	; Save arguments
	push rdi
	push rsi

	; Check if length of base is greater than 1
	mov rdi, rsi
	call ft_strlen
	cmp rax, 1
	mov r9, rax	; Save length of base to r9
	jle err

	; Check if base contains the same character twice
	mov rdi, [rbp - 16]			; Retrieve base from the stack
	call has_duplicate
	cmp rax, 1
	je err

	; Check if base contains +, -, or white spaces
	mov rdi, [rbp - 16]			; Retrieve base from the stack
	call are_base_chars_valids
	cmp rax, 1
	jne err

	; EAX will be the return value
	; RDI will be the string
	; RSI will be the base
	; R8B will be the sign (0 is positive, != 0 is negative)
	; R9 will be the length of the base
	mov rdi, [rbp - 8]
	mov rsi, [rbp - 16]
	xor r8b, r8b				; Default sign will be positive

begin_loop_spaces:
	push rdi				; Save rdi value
	mov dil, [rdi]			; Copy current character to dil (rdi)
	cmp dil, 0				; If it is the null character
	pop rdi					; Restore rdi value
	je err					; Set return value to 0 and go to the end
	push rdi				; Save rdi value
	mov dil, [rdi]			; Copy current character to dil (rdi)
	call is_space
	pop rdi					; Restore rdi value
	cmp rax, 0				; If it is not a space
	je begin_loop_sign		; Then, loop for signs
	inc rdi					; Else, go to next character
	jmp begin_loop_spaces	; And treat next character

begin_loop_sign:
	mov dl, [rdi]							; Copy current character to dl (rdx)
	cmp dl, 0								; If it is the null character
	je err									; Set return value to 0 and go to the end
	cmp dl, '+'								; If it is a '+'
	je treat_next_loop_sign					; Then, treat next character
	cmp dl, '-'								; Else, if it is a '-'
	je inverse_negate_flag_and_treat_next	; Then, negate number
	jmp treat_numbers						; Else, treat numbers

treat_next_loop_sign:
	inc rdi					; Go to next character
	jmp begin_loop_sign		; Treat next character

inverse_negate_flag_and_treat_next:
	not r8b						; Inverse sign of number
	jmp treat_next_loop_sign	; Treat next character

treat_numbers:
	xor eax, eax	; Set return value to 0

begin_loop_numbers:
	push rax					; Save return value
	push rdi					; Save string
	mov dil, [rdi]				; Copy current char to dil (rdi)
	call convert_char_to_number ; Convert current char to number
	mov r11d, eax				; Save converted number to esi (rsi)
	cmp rax, -1					; If char was not in the base
	pop rdi						; [Restore string]
	pop rax						; [Restore return value]
	je end_set_return_value		; Then, return converted value from now
	imul eax, r9d				; Multiply number by base length
	add eax, r11d				; Add converted char to number
	inc rdi						; Treat next character..
	jmp begin_loop_numbers		; ..

	
; eax convert_char_to_number(dil c, rsi base) [dil <=> rdi]
; Using of rdx for the counter
; Using of r10b for the current base char
convert_char_to_number:
	xor eax, eax	; Set default value to 0
	xor rdx, rdx	; Set counter value to 0
begin_loop_convert_char:
	mov r10b, [rsi + rdx]		; Copy current base character to di
	cmp r10b, 0					; If end of the base is reached
	je convert_char_end_err		; Return an error
	cmp dil, r10b				; If the characters match
	je convert_char_end			; Then, end
	inc rdx						; Else, test next base character
	inc eax						; And increment value of base character
	jmp begin_loop_convert_char	; Do the loop

convert_char_end_err:
	xor rax, rax				; Set return value to -1..
	not rax						; ..
	ret							; Return the error

convert_char_end:
	ret

err:
	xor eax, eax	; Set return value to 0
	jmp end			; Go to the end

end_set_return_value:
	cmp r8b, 0					; If it is positive
	je end						; Then go to the end	
	jmp negate_number_and_end	; Else, negate number and end

negate_number_and_end:
	not eax		; 2's complement..
	inc eax		; ..
	jmp end		; Go to the end

end:
	mov rbp, [rbp]
	add rsp, 24
	ret

; rax are_base_chars_valids(rdi str)
are_base_chars_valids:
	xor rax, rax				; Default return value is invalid base
begin_loop_base_valid:
	mov sil, [rdi]				; Copy current character to sil (rsi)
	cmp sil, 0
	je base_valid
	cmp sil, '+'				; If current character is +
	je end_is_base_valid
	cmp sil, '-'				; If current character is -
	je end_is_base_valid
	
	push rax					; Save return value
	push rdi					; Save string position
	mov dil, sil				; Copy current character to dil
	call is_space				; Is current character a space ?..
	cmp rax, 1					; ..
	pop rdi						; Restore string position
	pop rax						; Restore return value
	je end_is_base_valid		; If current character is a space, end
	jmp continue_base_valid		; Else, continue

continue_base_valid:
	inc rdi
	jmp begin_loop_base_valid

base_valid:
	mov rax, 1
	je end_is_base_valid

end_is_base_valid:
	ret

; rax has_duplicate(rdi str)
has_duplicate:
	xor rax, rax						; Default return is no duplicate
	xor rdx, rdx						; Empty current character counter
	mov rcx, 1							; Start checking between first and second character
has_duplicate_treat_char:
	mov sil, [rdi + rdx]				; Copy current character to sil (rsi)
	cmp sil, 0							; If end of the string is reached
	je has_duplicate_end				; Then go to the end
has_duplicate_check_char:
	mov r8b, [rdi + rcx]				; Copy current checker character to r8b (r8)
	cmp r8b, 0							; If current checker character is NUL
	je has_duplicate_treat_next_char	; Then, treat next char
	cmp sil, r8b						; If duplicates are found
	je has_duplicate_duplicate_found	; Then, return duplicate
	inc rcx
	jmp has_duplicate_check_char

has_duplicate_treat_next_char:
	inc rdx								; Treat next character
	mov rcx, rdx						; Checker character is the one after the current
	inc rcx
	jmp has_duplicate_treat_char

has_duplicate_duplicate_found:
	mov rax, 1
	jmp has_duplicate_end

has_duplicate_end:
	ret

; rax is_space(dil c)
is_space:
	xor rax, rax			; By default, character is not a space
	cmp dil, ' '			; If character is ' '
	je ret_is_space_true	; Then, it is a space
	cmp dil, `\t`			; Else, if character is not between \t and \r..
	jl end_is_space			; .. then, it is not a space..
	cmp dil, `\r`			; .. ..
	jg end_is_space			; .. ..
	jmp ret_is_space_true	; Else, it is a space

ret_is_space_true:
	inc rax					; Set return value to 1
	jmp end_is_space		; Return

end_is_space:
	ret
