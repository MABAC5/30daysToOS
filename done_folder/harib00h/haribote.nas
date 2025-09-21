; haribote-os
; TAB=4

;有关BOOT_INFO
CYLS	EQU		0x0ff0		;设定启动区
LEDS	EQU		0X0ff1
VMODE	EQU		0x0ff2		;有关颜色数目的信息，颜色的位数
SCRNX	EQU		0x0ff4		;分辨率的X
SCRNY	EQU		0x0ff6		;分辨率的Y
VRAM	EQU		0x0ff8		;图像缓冲区的开始地址

		ORG		0xc200		;指定汇编语言地址运算的基地址(是系统文件在内存中的起始地址，保持一致)
		
		MOV		AL,0x13
		MOV 	AH,0x00
		INT 	0x10		;调用VGA图像模式,320x200x8位色彩模式
		MOV		BYTE [VMODE],8		;记录画面画面模式
		MOV		WORD [SCRNX],320
		MOV		WORD [SCRNY],200	;画面大小信息
		MOV		DWORD [VRAM],0x000a0000
		
;调用BIOS取得键盘上各种LED的指示灯状态
		MOV		AH,0x02
		INT		0x16		;keyboard BIOS
		MOV		[LEDS],AL
		
fin:
		HLT
		JMP 	fin