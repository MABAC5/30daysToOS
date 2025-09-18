; haribote-os
; TAB=4

		ORG	0xc200	;指定汇编语言地址运算的基地址(是系统文件在内存中的起始地址，保持一致)

fin:
		HLT
		jmp fin