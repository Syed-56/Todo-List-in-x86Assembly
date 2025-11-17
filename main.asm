INCLUDE Irvine32.inc

MAX_TASKS  EQU 10

.data
heading BYTE "                         |=====================    TODO LIST    =====================|",0
devs    BYTE "  ------------------------ Made By: Syed Sultan Ahmed , Hassaan Nasir, Asad Khan ---------------------------",0
lines   BYTE "===========================================================================================================",0

msgOpt1 BYTE " 1) Add Task",0
msgOpt2 BYTE " 2) View Tasks",0
msgOpt3 BYTE " 3) Complete Task",0
msgOpt4 BYTE " 4) Update Task",0
msgOpt5 BYTE " 5) Remove Task",0
msgExit BYTE " 6) EXIT",0
msgOptionInput BYTE " Enter Option: ",0
invalidMsg BYTE " Invalid Option",0
msgTaskLimit BYTE "Task Limit Reached",0
msgNoTasks BYTE "No tasks have been added yet in your TODO LIST",0
msgDisplayingTasks BYTE "Displaying current scheduled tasks:",0

msgInputTask BYTE " Enter Task: ",0
msgInputTaskDate BYTE " Enter Completion Date (DD/MM/YYYY): ",0
msgInvalidTaskDate BYTE " Task Date is invalid",0
msgTaskAdded BYTE " Task Added Successfully",0

msgTaskCompleteNum BYTE " Enter Task Number to Complete: ",0
msgTaskCompleted BYTE " Task Completed Successfully",0

msgTaskUpdateNum BYTE " Enter Task Number to Update: ",0
msgTaskUpdateWhat BYTE " Enter 1 to Update Task's message and 2 to update Task's Due Date",0
msgTaskUpdateComplete BYTE " Task Updated Successfully",0

msgRemoveTaskNum BYTE " Enter Task Number to Remove: ",0
msgRemoveComplete BYTE " Task Removed Successfully",0

msgDot BYTE " ) ",0
msgSpace BYTE "    ",0
msgStatusSpace BYTE "    Status: ",0
msgNotCompleted BYTE "Not Completed",0
msgCompleted BYTE "Completed",0

taskCount DWORD 0

taskMessages BYTE MAX_TASKS*50 DUP(?)
taskDates    BYTE MAX_TASKS*12 DUP(?)
taskStatus   BYTE MAX_TASKS DUP(?)  

.code

addTask PROTO
viewTask PROTO
completeTask PROTO
updateTask PROTO
removeTask PROTO

titlePage PROC
    call crlf
    mov edx, OFFSET heading
    call WriteString
    call crlf
    call crlf
    mov edx, OFFSET devs
    call WriteString
    call crlf
    call crlf
    call crlf
    ret
titlePage ENDP

mainScreen PROC
    call crlf
    mov edx, OFFSET lines
    call WriteString
    call crlf

    mov edx, OFFSET msgOpt1
    call WriteString
    call crlf
    mov edx, OFFSET msgOpt2
    call WriteString
    call crlf
    mov edx, OFFSET msgOpt3
    call WriteString
    call crlf
    mov edx, OFFSET msgOpt4
    call WriteString
    call crlf
    mov edx, OFFSET msgOpt5
    call WriteString
    call crlf
    mov edx, OFFSET msgExit
    call WriteString
    call crlf

    mov edx, OFFSET lines
    call WriteString
    call crlf
    call crlf
    ret
mainScreen ENDP

inputOption PROC
    call mainScreen
    mov edx, OFFSET msgOptionInput
    call WriteString
    call ReadDec
    ret
inputOption ENDP

validateOption PROC opt:DWORD
    mov eax,opt
    cmp eax,1
    je addTaskOption
    cmp eax,2
    je viewTaskOption
    cmp eax,3
    je completeTaskOption
    cmp eax,4
    je updateTaskOption
    cmp eax,5
    je removeTaskOption
    jmp invalidOption

addTaskOption:
    invoke addTask
    jmp done
viewTaskOption:
    invoke viewTask
    jmp done
completeTaskOption:
    invoke completeTask
    jmp done
updateTaskOption:
    invoke updateTask
    jmp done
removeTaskOption:
    invoke removeTask
    jmp done

invalidOption:
    mov edx, OFFSET invalidMsg
    call WriteString
    call crlf

done:
    ret
validateOption ENDP

addTask PROC
    mov eax, taskCount
    cmp eax, MAX_TASKS
    jae taskLimitReached

    mov edx, OFFSET msgInputTask
    call WriteString

    mov eax, taskCount
    imul eax, 50
    lea edx, taskMessages[eax]
    mov ecx, 50
    call ReadString

dateinputloop:
    mov edx, OFFSET msgInputTaskDate
    call WriteString

    mov eax, taskCount
    imul eax, 12
    lea esi, taskDates[eax]      
    mov edx, esi
    mov ecx, 12
    call ReadString          

striploop:
    mov al,[esi]
    cmp al,0
    je stripdone
    cmp al,13
    je replacenull
    cmp al,10
    je replacenull
    inc esi
    jmp striploop
replacenull:
    mov byte ptr [esi],0
    inc esi
    jmp striploop
stripdone:
    mov eax, taskCount
    imul eax, 12
    lea esi, taskDates[eax]

    cmp byte ptr [esi+2], '/'
    jne invalidDate
    cmp byte ptr [esi+5], '/'
    jne invalidDate

    movzx eax, byte ptr [esi]
    sub eax,'0'
    movzx ebx, byte ptr [esi+1]
    sub ebx,'0'
    imul eax,10
    add eax, ebx
    cmp eax,1
    jl invalidDate
    cmp eax,30
    jg invalidDate

    movzx eax, byte ptr [esi+3]
    sub eax,'0'
    movzx ebx, byte ptr [esi+4]
    sub ebx,'0'
    imul eax,10
    add eax, ebx
    cmp eax,1
    jl invalidDate
    cmp eax,12
    jg invalidDate

    movzx eax, byte ptr [esi+6]
    sub eax,'0'
    movzx ebx, byte ptr [esi+7]
    sub ebx,'0'
    imul eax,10
    add eax, ebx
    imul eax,100
    mov ecx, eax
    movzx eax, byte ptr [esi+8]
    sub eax,'0'
    movzx ebx, byte ptr [esi+9]
    sub ebx,'0'
    imul eax,10
    add eax, ebx
    add ecx,eax
    cmp ecx,2025
    jl invalidDate

    mov eax, taskCount
    lea edx, taskStatus[eax]
    mov byte ptr [edx], 0

    inc taskCount
    mov edx, OFFSET msgTaskAdded
    call WriteString
    call crlf
    ret

invalidDate:
    mov edx, OFFSET msgInvalidTaskDate
    call WriteString
    call crlf
    jmp dateinputloop

taskLimitReached:
    mov edx, OFFSET msgTaskLimit
    call WriteString
    call crlf
    ret
addTask ENDP

viewTask PROC
    call crlf
    mov eax, taskCount
    cmp eax,0
    je noTasks

    mov edx, OFFSET msgDisplayingTasks
    call WriteString
    call crlf

    mov ecx,0                
viewloop:
    mov eax, ecx
    inc eax
    call WriteDec
    mov edx, OFFSET msgDot
    call WriteString

    mov eax, ecx
    imul eax,50
    lea edx, taskMessages[eax]
    call WriteString

    mov edx, OFFSET msgSpace
    call WriteString

    mov eax, ecx
    imul eax,12
    lea edx, taskDates[eax]
    call WriteString

    mov edx, OFFSET msgStatusSpace
    call WriteString

    mov eax, ecx
    mov bl, taskStatus[eax]
    cmp bl,0
    je notCompleted
    mov edx, OFFSET msgCompleted
    call WriteString
    jmp statusDone
notCompleted:
    mov edx, OFFSET msgNotCompleted
    call WriteString
statusDone:

    call crlf

    inc ecx
    mov eax, ecx
    cmp eax, taskCount
    jl viewloop
    ret

noTasks:
    mov edx, OFFSET msgNoTasks
    call WriteString
    call crlf
    ret
viewTask ENDP

completeTask PROC
    mov eax, taskCount
    cmp eax,0
    je noTasksComplete

    mov edx, OFFSET msgTaskCompleteNum
    call WriteString
    call ReadDec        

    dec eax                
    cmp eax,0
    jl invalidTaskNum
    mov ecx, taskCount
    cmp eax,ecx
    jge invalidTaskNum

    mov byte ptr taskStatus[eax],1  

    mov edx, OFFSET msgTaskCompleted
    call WriteString
    call crlf
    ret

noTasksComplete:
    mov edx, OFFSET msgNoTasks
    call WriteString
    call crlf
    ret

invalidTaskNum:
    mov edx, OFFSET invalidMsg
    call WriteString
    call crlf
    ret
completeTask ENDP


updateTask PROC
    ret
updateTask ENDP

removeTask PROC
    ret
removeTask ENDP

main PROC
    call titlePage
mainLoop:
    call inputOption
    cmp eax,6
    je finish
    invoke validateOption, eax
    jmp mainLoop
finish:
    exit
main ENDP

END main
