; naskfunc
; TAB=4

[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[BITS 32]
[FILE "naskfunc.nas"]

		GLOBAL _io_hlt,_write_mem8
	
[SECTION .text]

_io_hlt:		;实际上在C语言中的函数声明为void io_hlt(void);
		HLT
		RET
	
_write_mem8:	;void write_mem8(int addr,int data);
		MOV	ECX,[ESP+4]
		MOV	AL,[ESP+8]
		MOV	[ECX],AL
		RET
;ESP是函数调用时的栈顶指针,始终指向栈顶,[ESP]储存函数返回地址,[ESP+4]储存第一个参数,[ESP+8]储存第二个参数

