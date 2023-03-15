section .text
	global ft_strdup
	extern ft_strlen
	extern ft_strcpy
	extern malloc

; char	*strdup(const char *s);
; rax	strdup(rdi s);
ft_strdup:
	push rdi				; Push string onto the stack
	call ft_strlen			; Call ft_strlen on given argument
	mov rdi, rax			; Copy len of s to rdi
	inc rdi					; Add one to len, to get size with NUL character
	call malloc WRT ..plt	; Malloc data
	cmp rax, 0				; If rax is NULL
	jne fill				; Then, jump to the end of the function

	add rsp, 8				; Else, remove last value from stack (String)
	mov rax, 0				; Set return value to NULL
	jmp end					; Go to the end
fill:
	mov rdi, rax
	pop rsi
	call ft_strcpy
end:
	ret
