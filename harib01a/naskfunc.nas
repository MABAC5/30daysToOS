; naskfunc
; TAB=4
[FORMAT "WCOFF"]
[BITS 32]

[FILE "naskfunc.nas"]
	GLOBAL _io_hlt
	
[SECTION .text]

_io_hlt:		;实际上在C语言中的函数声明为void io_hlt(void);
	HLT
	RET