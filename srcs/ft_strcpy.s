section .text
	global ft_strcpy

; rdi: dest
; rsi: src
ft_strcpy:
	xor rcx, rcx		; Empty rcx register
	mov rax, rdi		; Set return value to dest pointer
begin:
	mov dl, [rsi + rcx]	; Loading current character to register dl (rdx)
	mov [rdi + rcx], dl	; Copy current character to next position of dest
	cmp dl, 0			; If we reached the end of src
	je end				; Then, go to the end
	inc rcx				; Else, go to next character
	jmp begin			; and treat the next character
end:
	ret
