section .text
	global ft_strlen

ft_strlen:
	xor rax, rax	; Empty return value
begin:
	mov sil, [rdi]	; Copy current character to sil (rsi)
	cmp sil, 0		; If end of string is reached
	je end			; Go to the end
	inc rax			; Else, increment return value
	inc rdi			; and go to next character
	jmp begin		; Treat next character
end:
	ret
