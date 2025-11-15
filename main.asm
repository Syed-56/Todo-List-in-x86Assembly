INCLUDE Irvine32.inc

MAX_TASKS 10

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
	msgOptionInput BYTE " Enter Option: ", 0
	invalidMsg BYTE " Invalid Option", 0
	msgTaskLimit BYTE "Task Limit Reached"

	msgInputTask BYTE " Enter Task: ", 0
	msgInputTaskDate BYTE " Enter Completion Date: ", 0
	msgInvalidTaskDate BYTE " Task Date is invalid", 0
	msgTaskAdded BYTE " Task Added Successfully", 0
	msgTaskCompleteNum BYTE " Enter Task Number to Complete: ", 0
	msgTaskCompleted BYTE " Task Completed Successfully", 0
	msgTaskUpdateNum BYTE " Enter Task Number to Update: ", 0
	msgTaskUpdateWhat BYTE " Enter 1 to Update Task's message and 2 to update Task's Due Date", 0
	msgTaskUpdateComplete BYTE " Task Updated Successfully", 0
	msgRemoveTaskNum BYTE " Enter Task Number to Remove: ", 0
	msgRemoveComplete BYTE " Task Removed Successfully", 0

	taskCount DWORD 0


.code

addTask PROTO
viewTask PROTO
completeTask PROTO
updateTask PROTO
removeTask PROTO

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

inputOption PROC
	call mainScreen
	MOV EDX, OFFSET msgOptionInput
	call writeString
	call readDec
	RET
inputOption ENDP

validateOption PROC opt:DWORD

	MOV EAX, opt
	CMP EAX, 1
	JE addTaskOption
	CMP EAX, 2
	JE viewTaskOption
	CMP EAX, 3
	JE completeTaskOption
	CMP EAX, 4
	JE updateTaskOption
	CMP EAX, 5
	JE removeTaskOption

	JMP invalidOption

	addTaskOption:
		INVOKE addTask
		JMP done
	viewTaskOption:
		INVOKE viewTask
		JMP done
	completeTaskOption:
		INVOKE completeTask
		JMP done
	updateTaskOption:
		INVOKE updateTask
		JMP done
	removeTaskOption:
		INVOKE removeTask
		JMP done

	invalidOption:
		MOV EDX, OFFSET invalidMsg
		call writeString
		call Crlf
		JMP done

	done:
	RET
validateOption ENDP

main PROC
	call titlePage
	mainLoop:
		call inputOption
		CMP EAX, 6
		JE finish
		INVOKE validateOption, EAX
		JMP mainLoop

	finish:
	exit
main ENDP

addTask PROC

	RET
addTask ENDP

viewTask PROC

	RET
viewTask ENDP

completeTask PROC

	RET
completeTask ENDP

updateTask PROC

	RET
updateTask ENDP

removeTask PROC

	RET
removeTask ENDP

END main