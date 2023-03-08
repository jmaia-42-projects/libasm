section .text
	global ft_strcmp

; rdi: s1
; rsi: s2
ft_strcmp:
	xor rdx, rdx			; Set index to 0
	xor rcx, rcx			; Empty rcx
	xor r8, r8				; Empty r8
begin:
	mov cl, [rdi + rdx]		; Copy current s1 character to cl (rcx)	
	mov r8b, [rsi + rdx]	; Copy current s2 character to r8b (r8)	
	mov rax, rcx			; Copy current s1 character to rax
	sub rax, r8				; Substract current s2 character to al (rax)
	cmp rax, 0				; If the characters aren't equals
	jne end					; then go to the end
	cmp cl, 0				; Else, if the characters are both 0
	je end					; then go to the end
	inc rdx					; Else, go to next character
	jmp begin				; Treat next character
end:
	ret
