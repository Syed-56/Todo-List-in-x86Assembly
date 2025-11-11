INCLUDE Irvine32.inc

.data
	heading BYTE "                         |=====================    TODO LIST    =====================|", 0
	devs BYTE "  ------------------------ Made By: Syed Sultan Ahmed , Hassaan Nasir, Asad Khan ---------------------------", 0
	lines BYTE "===========================================================================================================", 0

	msgOpt1 BYTE " 1) Add Task", 0
	msgOpt2 BYTE " 2) View Tasks", 0
	msgOpt3 BYTE " 3) Complete Task", 0
	msgOpt4 BYTE " 4) Update Task", 0
	msgOpt5 BYTE " 5) Remove Task", 0
	msgExit BYTE " 6) EXIT", 0

.code

titlePage PROC
	call crlf
	MOV EDX, OFFSET heading
	call writeString
	call crlf
	call crlf
	MOV EDX, OFFSET devs
	call writeString
	call crlf
	call crlf
	call crlf
	RET
titlePage ENDP

mainScreen PROC
	call crlf
	MOV EDX, OFFSET lines
	call writeString
	call crlf
	
	MOV EDX, OFFSET msgOpt1
	call writeString
	call crlf
	MOV EDX, OFFSET msgOpt2
	call writeString
	call crlf
	MOV EDX, OFFSET msgOpt3
	call writeString
	call crlf
	MOV EDX, OFFSET msgOpt4
	call writeString
	call crlf
	MOV EDX, OFFSET msgOpt5
	call writeString
	call crlf
	MOV EDX, OFFSET msgExit
	call writeString
	call crlf

	MOV EDX, OFFSET lines
	call writeString
	call crlf
	call crlf

	RET
mainScreen ENDP

main PROC

	call titlePage
	call mainScreen

	exit
main ENDP

END main