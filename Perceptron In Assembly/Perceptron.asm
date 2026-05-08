INCLUDE Irvine32.inc

.data

    inputs  DWORD 1, 0, 0
            DWORD 1, 0, 1
            DWORD 1, 1, 0
            DWORD 1, 1, 1
            
    targets DWORD 0, 1, 1, 1       
    weights DWORD 0, 0, 0         

    num_features DWORD 3            
    num_samples  DWORD 4           

    msg_epoch BYTE "Epoch: ", 0
    msg_errors BYTE "  |  Errors: ", 0

.code
main PROC
    mov esi, 0

main_loop:
    inc esi
    
    mov edx, OFFSET msg_epoch
    call WriteString
    
    mov eax, esi
    call printResult
    
    mov edx, OFFSET msg_errors
    call WriteString
    
    call trainEpoch
    
    push eax
    call printResult
    call Crlf
    
    pop eax
    cmp eax, 0
    je finish
    
    jmp main_loop

finish:
    exit
main ENDP

dotProduct PROC
    push ebx
    push edx
    push esi
    push edi
    
    mov eax, 0          
    mov ebx, 0          

dot_loop_start:
    cmp ebx, ecx       
    jge dot_loop_end    

    mov edx, [esi + ebx*4] 
    
    imul edx, [edi + ebx*4] 
    
    add eax, edx        

    inc ebx             
    jmp dot_loop_start  

dot_loop_end:
    pop edi
    pop esi
    pop edx
    pop ebx
    
    ret                
dotProduct ENDP

applyStep PROC
    cmp eax, 0
    jg set_one
    
    mov eax, 0
    jmp end_step
    
set_one:
    mov eax, 1
    
end_step:
    ret
applyStep ENDP

updateWeights PROC
    push eax
    push edx
    push edi
    push esi
    
    mov edx, 0
    
update_loop:
    cmp edx, ecx
    jge end_update
    
    mov eax, [esi + edx*4]
    imul eax, ebx
    add [edi + edx*4], eax
    
    inc edx
    jmp update_loop
    
end_update:
    pop esi
    pop edi
    pop edx
    pop eax
    ret
updateWeights ENDP

trainEpoch PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov edx, 0
    mov ebx, 0
    
epoch_loop:
    cmp ebx, num_samples
    jge end_epoch
    
    mov eax, 12
    imul eax, ebx
    mov esi, OFFSET inputs
    add esi, eax
    
    mov edi, OFFSET weights
    mov ecx, num_features
    
    call dotProduct
    call applyStep
    
    push edx
    mov edx, targets[ebx*4]
    sub edx, eax
    
    cmp edx, 0
    je no_error
    
    push ebx
    mov ebx, edx
    call updateWeights
    pop ebx
    
    pop edx
    inc edx
    jmp next_sample
    
no_error:
    pop edx
    
next_sample:
    inc ebx
    jmp epoch_loop
    
end_epoch:
    mov eax, edx
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
trainEpoch ENDP

printResult PROC
    pushad
    
    cmp eax, 0
    jne process_num
    
    mov al, '0'
    call WriteChar
    jmp end_print
    
process_num:
    mov ecx, 0
    mov ebx, 10
    
div_loop:
    cmp eax, 0
    je print_digits
    
    mov edx, 0
    div ebx
    push edx
    inc ecx
    jmp div_loop
    
print_digits:
    cmp ecx, 0
    je end_print
    
    pop edx
    add dl, '0'
    mov al, dl
    call WriteChar
    dec ecx
    jmp print_digits
    
end_print:
    popad
    ret
printResult ENDP

END main