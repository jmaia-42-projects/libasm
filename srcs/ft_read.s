section .text
	global ft_read
	extern __errno_location

; ssize_t read(int fd, void *buf, size_t count);
; rax     ft_read(rdi fd, rsi buf, rdx count);
ft_read:
	mov rax, 0						; Set called syscall to read. rdi rsi and rdx are already set
	syscall							; Call read
	test rax, rax					; If rax is positive
	jns end							; Then, jump to the end of the function
	call ft_abs						; Get absolute value of return code
	push rax						; Save value of error code
	call __errno_location WRT ..plt	; Get pointer to errno
	pop rdi							; Get value of error code
	mov [rax], edi					; Set error code to errno
	mov rax, -1						; Set return value to -1
end:
	ret

; rax	ft_abs(rax nbr)
ft_abs:
	mov rsi, rax	; Copy nbr to another register
	sar rsi, 63		; If nbr is positive, rsi is 0, else, rsi is filled with 1
	xor rax, rsi	; If nbr > 0, nothing change. If nbr < 0, rax is 1's complement of nbr
	sub rax, rsi	; If nbr > 0, nothing change. If nbr < 0, substract -1, so add 1 to get 2's complement of x
	ret
	
	
