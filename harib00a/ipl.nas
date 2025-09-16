; hello-os
; TAB = press 2 TAB(one TAB is 8 space)

		ORG		0x7c00			; 程序装载到内存预留的起始地址处

; FAT12软盘专用的代码
		JMP 	entry
		DB		0x90		
		; 对比可以发现，这里其实发生了改变，但却不影响运行，是因为这些都只是磁盘信息，只要在合理范围内即可，CPU不会把他们当作命令执行
		DB		"HARIBOTE"		
		DW		512				
		DB		1				
		DW		1				
		DB		2				
		DW		224				
		DW		2880			
		DB		0xf0			
		DW		9				
		DW		18				
		DW		2				
		DD		0				
		DD		2880			
		DB		0,0,0x29		
		DD		0xffffffff		
		DB		"HARIBOTEOS "	
		DB		"FAT12   "		
		RESB	18

; 程序主体

entry:
		MOV		AX,0
		MOV		SS,AX
		MOV		SP,0X7c00
		MOV		DS,AX

		MOV		SI,msg

		; harib00a新增内容 : 读取下一个扇区 C0-H0-S2到内存地址0x0820及以后的512字节中
		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0		;柱面0
		MOV		DH,0		;磁头0
		MOV		CL,2			;扇区2
		MOV		AH,0x02		;AH=0x02 : 读盘
		MOV		AL,1		;1个扇区
		MOV		BX,0
		MOV		DL,0x00		;A驱动器
		INT		0x13		;调用磁盘bios
		JC		error

fin:
		HLT
		JMP		fin
		
error:
		MOV SI,msg
		
; 汇编语言中代码是顺序执行的，除非有跳转，所以即使没有显示调用putloop，也会运行putloop，有输出(在helloos5及之前)
putloop:
		MOV		AL,[SI]
		ADD		SI,1
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e
		MOV		BX,15
		INT		0x10
		JMP		putloop
msg:
		DB		0x0a,0x0a
		DB		"load error"
		DB		0x0a
		DB		0
		
		RESB	0x7dfe-$

		DB		0x55,0xaa

