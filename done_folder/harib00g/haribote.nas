; haribote-os
; TAB=4

		ORG	0xc200	;指定汇编语言地址运算的基地址(是系统文件在内存中的起始地址，保持一致)

		MOV	AL,0x13
		MOV AH,0x00
		INT 0x10	;调用VGA图像模式,320*200*8位色彩模式
fin:
		HLT
		JMP fin