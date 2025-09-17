; 	haribote-ipl
; 	TAB = press 2 TAB(one TAB is 8 space)
;	16位寄存器: AX累加寄存器 CX计数寄存器 DX数据寄存器 BX基址寄存器 SP栈指针寄存器 BP基址指针寄存器 SI源变址寄存器 DI目的变址寄存器
;	8位寄存器:  AL累加寄存器低位 CL计数寄存器低位 DL数据寄存器低位 BL基址寄存器低位 AH累加寄存器高位 CH计数寄存器高位 DH数据寄存器高位 BH基址寄存器高位
;	16位段寄存器:ES附加段寄存器 CS代码段寄存器 SS栈段寄存器 DS数据段寄存器 FS段寄存器2 GS段寄存器3

		ORG		0x7c00		;程序装载到内存预留的起始地址处

; 	FAT12软盘专用的代码
		JMP 	entry
		DB		0x90		
; 	对比可以发现，这里其实发生了改变，但却不影响运行，是因为这些都只是磁盘信息，只要在合理范围内即可，CPU不会把他们当作命令执行
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

; 	程序主体
entry:
		MOV		AX,0		;初始化寄存器
		MOV		SS,AX		
		MOV		SP,0X7c00
		MOV		DS,AX

		MOV		AX,0x0820	;AX=0x02(读盘),0x03(写盘),0x04(校验),0x0c(寻道)...
		MOV		ES,AX		;ES:BX = 缓冲地址(INT 0x13调用中,实际地址为ES*16+BX)，即将磁盘内容读到第ES:BX-ES:BX+511(共512字节)内存地址中
		MOV		CH,0		;柱面0
		MOV		DH,0		;磁头0
		MOV		CL,2		;扇区2
		
;	haribooc新增内容:读取完柱面0的18个扇区
readloop:
		MOV		SI,0
		
retry:
		MOV		AH,0x02		;AH=0x02 : 读盘
		MOV		AL,1		;处理对象的扇区数,这里AL=17的话可以直接读入17个扇区的内容,但这样做的话似乎有些限制
		MOV		BX,0
		MOV		DL,0x00		;A驱动器
		INT		0x13		;调用磁盘bios
		JNC		next		;没出错跳转到next
		ADD		SI,1		;出错次数+1
		CMP		SI,5		;SI(出错次数)与5比较
		JAE		error		;JAE:jump if above or equal，即SI>=5跳转到error
		MOV		AH,0x00
		MOV		DL,0x00		;A驱动器
		INT		0x13		;重置驱动器
		JMP		retry
		
next:
		MOV 	AX,ES
		ADD 	AX,0x0020
		MOV 	ES,AX			;没有ADD ES,0x0020 指令，所以用AX完成
		ADD 	CL.1			;储存当前读取的扇区号
		CMP 	CL,18
		JBE 	readloop		;JBE(jump if below or equal) 当CL<=18时跳转
		
fin:
		HLT
		JMP		fin
		
error:
		MOV SI,msg
		
; 	汇编语言中代码是顺序执行的，除非有跳转，所以即使没有显示调用putloop，也会运行putloop，有输出(在helloos5及之前)

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

