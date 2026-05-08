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
    ret
applyStep ENDP

updateWeights PROC
    ret
updateWeights ENDP

trainEpoch PROC
    ret
trainEpoch ENDP

printResult PROC
    ret
printResult ENDP

END main