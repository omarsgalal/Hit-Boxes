.model medium                   ;
.stack 64                       ;               
                                ;               
.data                           ;               
                                ;               
bricklength equ 20              ;»⁄÷ «·ÀÊ«»  ·—”„ «·Ã—«›ﬂ”               
brickWidth equ 10               ;               
playerlength equ  60            ;               
playerWidth equ 10              ;               
ballLength equ 8                ;               
ballWidth equ 8                 ;               
                                ;               
startRect dw 0,0                ;‰ﬁÿ… »œ«Ì… «·„” ÿÌ·               
W dw 0                          ;«·ÿÊ· «·—«”Ì ··„” ÿ·               
L dw 0                          ;«·ÿÊ· «·«›ﬁÏ ··„” ÿ»·               
rectColor db ?                  ;·Ê‰ «·„” ÿÌ·               
                                ;               
startLine dw 0, 0               ;‰ﬁÿ… »œ«Ì… «·Œÿ «·«›ﬁÏ               
length dw 0                     ;ÿÊ· «·Œÿ               
lineColor db 0                  ;·Ê‰ «·Œÿ               
                                ;               
playerPositionOld dw 130, 180   ;«·‰ﬁÿ… «·ﬁœÌ„… ··«⁄»               
playerPosition dw 130, 180      ;‰ﬁÿ… «··«⁄» «·Õ«·Ì…               
                                ;               
ballPositionOld dw 160, 170     ;«·‰ﬁÿ… «·ﬁœÌ„… ··ﬂ—œÌœ «·›Ê“…               
ballPosition dw 160, 170        ;«·‰ﬁÿ… «·Õ«·Ì… ··ﬂ—…               
                                ;               
BallDirection dw 1, -1          ;« Ã«Â  Õ—ﬂ «·ﬂ—…               
                                ;               
crashes db 4 dup(0)             ;«’ÿœ«„ «·ﬂ—… „‰ «·«—»⁄ ﬂÊ—‰—«                
                                ;               
score db 60                     ;· ÕœÌœ «·›Ê“               
loseState db 0                  ;· ÕœÌœ «·Œ”«—…               
                                ;               
win db 'you win$'               ;—”«∆· «·ÿ»«⁄…               
lose db 'you lose$'             ;               
print db 'press any key to start or esc to exit$'  ;
             ;
endGame db 0 ;‰Â«Ì… «··⁄»…
     ;
.code 
     ;
     ;
reset proc ;·«⁄«œ… Ã„Ì⁄ «·„ €Ì—«  «·Ì ÕÌÀ ﬂ«‰ 
    pusha                          ;
    mov playerPositionOld, 130     ;
    mov playerPositionOld[2], 180  ;
    mov playerPosition, 130        ;
    mov playerposition[2], 180     ;
    mov ballPositionOld, 160       ;
    mov ballPositionOld[2], 170    ;
    mov ballPosition, 160          ;
    mov ballPosition[2], 170       ;
    mov BallDirection, 1           ;
    mov BallDirection[2], -1       ;
    mov crashes[0], 0
    mov crashes[1], 0
    mov crashes[2], 0
    mov crashes[3], 0
    mov score, 60    
    mov loseState, 0 
                     
    popa             
    ret              
reset endp           
                     
main proc far                      ;
    mov ax, @data ;
    mov ds, ax    ;
                  ;
    mov ah,0      ;«·œŒÊ· «·Ì «·Ã—«›ﬂ” „Êœ
    mov al,13h    ;
    int 10h       ;
                  ;
    call stopGame ;··ÿ»«⁄… Ê«‰ Ÿ«— «·«Œ Ì«— „‰ «··«⁄»
    cmp endGame, 1;«· «ﬂœ Â· Ì›÷· «·Œ—ÊÃ „‰ «··⁄»… «„ ·«
    je finalisHere;
                  ;
    startHere:    ;
    call drawScene;·—”„ ”«Õ… «··⁄»…
                  ;
    mainLoop:     ;
    mov ah,1      ;«Œ– «·„› «Õ „‰ «··«⁄» Ê⁄œ„ «·«‰ Ÿ«—
    int 16h       ;
    jz here       ;
    call movePlayer  ;· Õ—Ìﬂ «··«⁄» «‰ ÷€ÿ ⁄·Ì «Õœ «·”Â„Ì‰
    call drawPlayer  ;·—”„ «Œ— „Ê÷⁄ ··«⁄»
    here:            ;
    call moveBall    ;· Õ—Ìﬂ «·ﬂ—…
    call drawBall    ;—”„ «·„Ê÷⁄ «·ÃœÌœ ··ﬂ—…
    cmp score, 0     ;·· «ﬂœ Â· ›«“ «··«⁄» «„ ·«
    je gameOver      ;
    cmp loseState, 1 ;·· «ﬂœ Â· Œ”— «„ ·«
    je gameOver      ;
    jmp mainLoop     ;
                     ;
                     ;
    gameOver:        ;
                     ;
    mov ah,2         ; Õ—Ìﬂ «·ﬂ—”Ê— «·Ì „ﬂ«‰ «·ÿ»«⁄…
    mov dh, 19       ;
    mov dl, 2        ;
    int 10h          ;
                     ;
    cmp loseState, 1    ;«· «ﬂœ „‰ «·Œ”«—…
    je true             ;
    mov dx, offset win  ;Â‰« ﬁœ ›«“ ›‰ÿ»⁄ «·›Ê“
    jmp comehere        ;
    true:               ;
    mov dx, offset lose ;Â‰« ﬁœ Œ”— ›‰ÿ»⁄ «·Œ”«—…
    comehere:           ;
    mov ah, 9           ;
    int 21h             ;
                        ;
                        ;
    call stopGame       ;«·œŒÊ· «·Ì Õ«·…  ŒÌÌ— «··«⁄»
    cmp endGame, 0      ;Â· Ì—Ìœ «·Œ—ÊÃ
    je startHere        ;
                        ;
    finalishere:        ;
    mov ah,4ch             ;«‰Â«¡ «··⁄»…
    int 21h                                        ;
main endp                                          ;
                                                   ;
                                                   ;
                         ;
drawLine proc            ;·—”„ Œÿ «›ﬁÌ
    pusha                ;
    mov dx, startLine[2] ;‰ﬁ· —«” «·Œÿ «·Ì «· cx ,Ê «· dx
    mov cx, startLine[0] ;
    mov al, lineColor    ;‰ﬁ· «··Ê‰ «·Ì «· al
    lineloop:                                      ;
    mov ah,0ch                 			   ;—”„ «·»ﬂ”·
    int 10h         ;
    inc cx          ;
    dec length      ; ﬁ·Ì· «·ÿÊ· 
    cmp length, 0   ;«‰ Ê’· «·ÿÊ· ··’›— ›ÂÌ ‰Â«Ì… «·œÊ—…
    jne lineloop    ;
    popa            ;
    ret             ;
drawLine endp       ;
                    ;
                    ;
drawRect proc       ; —”„ „” ÿÌ· „·Ê‰ ⁄‰ ÿ—Ìﬁ —”„ »÷⁄… ŒÿÊÿ «›ﬁÌ…
    pusha           ;
    mov cx, L       ;
    mov length, cx      ;‰ﬁ· ÿÊ· «·„” ÿÌ· «·Ì ÿÊ· «·Œÿ
    mov bl, rectColor   ;
    mov lineColor, bl   ;‰ﬁ· ·Ê‰ «·„” ÿÌ· «·Ì ·Ê‰ «·Œÿ
    mov cx, startRect   ;
    mov startLine, cx   ;‰ﬁ· »œ«Ì… «·„” ÿÌ· «·Ì »œ«Ì… «·Œÿ
    mov si, startRect[2];
    mov di, si          ;
    add si, W           ;Ê÷⁄ ⁄—÷ «·„” ÿÌ· ›Ì «· «” «Ì —Ã” — ·„⁄—›… „ Ì ” ‰ ÂÌ «··Ê»
    rectloop:           ;«·œÊ—… «· Ì ” —”„ ŒÿÊÿ «›ﬁÌ…
    mov cx, L           ;
    mov length, cx      ;‰ﬁ· ÿÊ· «·Œÿ
    mov startLine[2], di;‰ﬁ· «·«Õœ«ÀÌ «·—«”Ì «·Ì «·Œÿ ﬂÌ Ì „ —”„Â
    call drawLine       ;‰œ«¡ —”„ Â–« «·Œÿ
    inc di              ;“Ì«œ… «·«Õœ«ÀÌ «·—«”Ì 
    cmp di, si          ;„ﬁ«—‰… «·«Õœ«ÀÌ «·—«”Ì »«Œ— 
    jne rectloop        ;
    popa     ;
    ret      ;
drawRect endp;
             ;
             ;
drawWalls proc  ;—”„ ÕÊ«∆ÿ «·„ﬂ«‰
    pusha       ;
                ; Â‰« Ì „ —”„ Œÿ ›Ì »œ«Ì… «·„ﬂ«‰ «›ﬁÌ«
    mov startLine, 0   ;
    mov startLine[2], 0;
    mov lineColor, 5   ;
    mov length, 320    ;
    call drawLine      ;
                       ;
    mov startLine, 0   ;Â‰« Ì „ —”„ Œÿ ›Ì ‰Â«Ì… «·„ﬂ«‰ «›ﬁÌ«
    mov startLine[2], 199                          ;
    mov lineColor, 5                               ;
    mov length, 320;
    call drawLine  ;
                   ;
    mov al, 5      ;‰ﬁ· «··Ê‰ «·Ì «·—Ã” — «·Œ«’ »Â
    mov cx, 0      ;
    mov dx, 0      ;
                   ;
    wallsloop:     ;Â–Â «·œÊ—… ·—”„ ŒÿÌ‰ —«”ÌÌ‰ ÌÕÌÿ«‰ »«·„ﬂ«‰
    mov ah, 0ch    ;«‰ —»  —”„ «·»ﬂ”·
    int 10h        ;
    add cx, 319    ;Ê÷⁄ «·«Õœ«ÀÌ «·«›ﬁÌ ·—”„ »ﬂ”· ›Ì «·ÃÂ… «·„‰«Ÿ—…
    mov ah, 0ch    ;—”„ «·»ﬂ”·
    int 10h        ;
    sub cx, 319    ;«⁄«œ… «·«Õœ«ÀÌ «·«›ﬁÌ «·Ì „ﬂ«‰Â
    inc dx         ;“Ì«œ… «·⁄œ«œ
    cmp dx, 200    ;„ﬁ«—‰… «·⁄œ«œ »«Œ— »ﬂ”· ›Ì «·‘«‘… · ÕœÌœ „ Ì Ì „ «·ÊﬁÊ›
    jne wallsloop  ;
                   ;
    popa           ;
    ret            ;
drawWalls endp     ;
                   ;
drawBricks proc    ;—”„ «·ÿÊ» «·Ì Ì „ «’ÿÌ«œÂ
    pusha          ;
    mov bx, 5      ;«÷«›… ÿÊ· «·Â«„‘ «·—«”Ì
                   ;
    bricksloop2:   ;«Ê· œÊ—… ·—”„ ’›Ê› «·ÿÊ»
    mov ax, 6      ;‰ﬁ· ÿÊ· «·Â«„‘ «·«›ﬁÌ »Ì‰ «·ÿÊ»
    mov RectColor, 5  ;Ê÷⁄ ·Ê‰ «·ÿÊ»
    bricksloop1:      ;«·œÊ—… «·œ«Œ·Ì… ·—”„ 10 ÿÊ»«  ›Ì «·’› «·Ê«Õœ
    mov startRect, ax ;
    mov startRect[2], bx ;Â‰« Ê÷⁄ «Õœ«ÀÌ«  »œ«Ì… «·ÿÊ»… 
    mov L, bricklength   ;Ê÷⁄ ÿÊ· «·ÿÊ»… ›Ì ÿÊ· «·„” ÿÌ·
    mov w, brickWidth;Ê÷⁄ ⁄—÷ «·ÿÊ»… ›Ì ⁄—÷ «·„” ÿÌ·
    call drawRect    ;—”„ «·ÿÊ»… ÊÂÌ ⁄»«— ⁄‰ „” ÿÌ· »«· «ﬂÌœ
    add ax, 32       ;«÷«›… «·›«—ﬁ »Ì‰ «Ê· ﬂ· ÿÊ»… Ê«·ÿÊ»… «· Ì  ·ÌÂ«
    cmp ax, 320      ;«·„ﬁ«—‰… »‰Â«Ì… «·‘«‘… Õ Ì Ì „ «·«‰ Â«¡ „‰ «·—”„
    jb bricksloop1   ;
    add bx, 15       ;÷«›… «·›«—ﬁ »Ì‰ «Ê· ﬂ· ÿÊ»… Ê«·ÿÊ»… «· Ì  ·ÌÂ«
    cmp bx, 95       ;«·„ﬁ«—‰… »„ﬂ«‰ ›Ì «·‘«‘… ··Œ—ÊÃ „‰ «·œÊ—…
    jb bricksloop2   ;
             
    popa     
    ret      
drawBricks endp ;
                ;
                ;
drawPlayer proc ;Â–Â ·—”„ ÿÊ»… «··«⁄» ⁄‰ ÿ—Ìﬁ „”Õ „ﬂ«‰Â «·ﬁœÌ„ Ê—”„ „ﬂ«‰Â «·ÃœÌœ
    pusha       ;
                ;
    mov rectColor, 0    ;›Ì Â–« «·Ã“¡ Ì „ «·«⁄œ«œ ·—”„ „” ÿÌ· «”Êœ „ﬂ«‰ «··«⁄» «·ﬁœÌ„
    mov W, playerWidth  ;
    mov L, playerLength ;
    mov ax, playerPositionOld
    mov startRect, ax        
    mov startRect[2], 180    
    call drawRect            
                             
    mov rectColor, 5;›Ì Â–« «·Ã“¡ Ì „ «·«⁄œ«œ ·—”„ «··«⁄» »«··Ê‰ «·»‰›”ÃÌ ›Ì „ﬂ«‰Â «·Õ«·Ì
    mov W, playerWidth      
    mov L, playerLength     
    mov ax, playerPosition  
    mov startRect, ax       
    mov startRect[2], 180   
    call drawRect           
                            
                            
    popa                    
    ret                     
drawPlayer endp             
                            
                            
drawScene proc                                     ;Â‰« —”„ «·„ﬂ«‰ «·⁄«„ ›Ì »œ«Ì… «··⁄»…
    pusha          ;
    call drawWalls ;—”„ «·ÕÊ«∆ÿ
                   ;
    call drawBricks;—”„ «·ÿÊ»
                   ;
    call drawPlayer;—”„ «··«⁄»
                   ;
    call drawBall  ;—”„ «·ﬂ—… «·„ Õ—ﬂ… ›Ì „ﬂ«‰ «·»œ«Ì… «·„Œ’’ ·Â«
                   ;
    popa           ;
    ret            ;
drawScene endp;
              ;
              ;
              ;
drawBall proc ;«·Ã“¡ «·Œ«’ »—”„ «·ﬂ—…
    pusha     ;
              ;
    mov rectColor, 0 ;Â‰« Ì „ —”„ „” ÿÌ· «”Êœ »ÕÃ„ «·ﬂ—… ›Ì „ﬂ«‰Â« «·ﬁœÌ„ 
    mov W, ballWidth ;
    mov L, ballLength;
    mov ax, ballPositionOld
    mov startRect, ax      
    mov ax, ballPositionOld[2]
    mov startRect[2], ax      
    call drawRect             
                              
                              
    mov rectColor, 4 ;Â‰« Ì „ —”„ „” ÿÌ· »·Ê‰ «·ﬂ—… ›Ì „ﬂ«‰Â« «·Õ«·Ì
    mov W, ballWidth ;
    mov L, ballLength;
    mov ax, ballPosition   
    mov startRect, ax      
    mov ax, ballPosition[2]
    mov startRect[2], ax   
    call drawRect          
                           
    mov cx, 40000;Â–Â «·œÊ—… ·· »ÿÌ¡ „‰ Õ—ﬂ… «·ﬂ—… ﬁ·Ì·«
    slow:      
    loop slow  
               
    popa       
    ret        
drawBall endp  
               
               
               
movePlayer proc  ;«·Ã“¡ «·Œ«’ » Õ—Ìﬂ «··«⁄» Ì„Ì‰« ÊÌ”«—« „‰ ÷€ÿ «··«⁄» ⁄·Ì «·«”Â„
    pusha        ;
                 ;
    cmp ah, 4Dh  ;«·„ﬁ«—‰… »«·«”ﬂÌ «·Œ«’ »«·“— «·«Ì„‰
    jne left     
                 
    cmp playerPosition, 320-6-playerlength;«· «ﬂœ „‰ ⁄œ„ «·Ê’Ê· «·Ì ‰Â«Ì… «·‘«‘…
    jae finishMoving  
    mov ax, playerPosition ;‰ﬁ· „ﬂ«‰ «··«⁄» «·–Ì ﬂ«‰ ›ÌÂ «·Ì «·„ﬂ«‰ «·ﬁœÌ„ ·Ì „ «·„”Õ
    mov playerPositionOld, ax;
    add playerPosition, 8    ; Õ—Ìﬂ «··«⁄» Ì„Ì‰« ﬁ·Ì·« »„ﬁœ«— 8 »ﬂ”·« 
    jmp finishMoving         ;
                             ;
    left:                    ;
    cmp ah, 4Bh              ;«·„ﬁ«—‰… »«·«”ﬂÌ «·Œ«’ »«·”— «·«Ì”—
    jne finishMoving         ;
                             ;
    cmp playerPosition, 6    ;«·„ﬁ«—‰… »‰Â«Ì… «·‘«‘… ﬂÌ ·« ÌŒ—Ã „‰Â«
    jbe finishMoving         ;
    mov ax, playerPosition    ;‰ﬁ· „ﬂ«‰ «··«⁄» «·Ì «·„ﬂ«‰ «·ﬁœÌ„
    mov playerPositionOld, ax ;
    sub playerPosition, 8     ; Õ—ÌﬂÂ Ì”«—« »„ﬁœ«— 8 »ﬂ”·« 
                             
    finishMoving:            
                             
    mov ah, 0                 ; ›—Ì€ «·»›— „‰ «·“— «·„«ŒÊ–
    int 16h                 
                            
    popa                    
    ret                     
movePlayer endp             
                            
                    
moveBall proc        ;«·Ã“¡ «·Œ«’ » Õ—Ìﬂ «·ﬂ—… Ê ’«œ„« Â« »«·ÕÊ«∆ÿ Ê«·ÿÊ»
    pusha            ;
                     ;
    mov ax, ballPosition   ;Â‰« ‰ﬁ· „ﬂ«‰ «·ﬂ—… «·Ì «·„ﬂ«‰ «·ﬁœÌ„ ·Ì „ „”ÕÂ ⁄‰œ «·—”„
    mov ballPositionOld, ax;
    mov ax, ballPosition[2];
    mov ballPositionOld[2], ax
                              
                              
    mov ah, 0Dh;«·« Ì«‰ »«·‰ﬁÿ… ›Ì «·—ﬂ‰ «·⁄·ÊÌ «·«Ì”— „‰ «·ﬂ—… ·„⁄—›… «··Ê‰ ›ÊﬁÂ« · ÕœÌœ «· ’«œ„ „‰ Â–Â «·ÃÂ…
    mov bh, 0  ;
    mov cx, ballPosition   
    mov dx, ballPosition[2]
    dec cx                 
    dec dx                 
    int 10h                

    cmp al, 5            ;·‰—Ì Â· Â–« «··Ê‰ ÂÊ ·Ê‰ «·‘∆ «·· Ì ” ’ÿœ„ »Â
    jne here1            ;
    mov crashes, 1       ;«÷«›… «’ÿœ«„ ›Ì ”·”·… «· ’«œ„«  „‰ Â–Â «·ÃÂ…
    here1:               ;

    add cx, ballLength+1 ;„⁄—›… ·Ê‰ «·‘∆ «·’«œ„ „‰ «·ÃÂ… «·⁄·ÊÌ… «·Ì„‰Ì
    int 10h              ;
    cmp al, 5            ;„ﬁ«—‰ Â« »«··Ê‰ «·»‰›”ÃÌ
    jne here2            ;
    mov crashes[1], 1    ;«÷«›…  ’«œ„ ›Ì «·«——«Ì «–« ﬂ«‰ «··Ê‰ »‰›”ÃÌ
    here2:               ;

    add dx, ballWidth+1  ;„⁄—›… ·Ê‰ «·‰ﬁÿ… „‰ «·ÃÂ… «·”›·Ì… «·Ì„‰Ì
    int 10h              ;
    cmp al, 5            ;„ﬁ«—‰ Â« »·Ê‰ «·ÿÊ» Ê«·ÕÊ«∆ÿ
    jne here3            ;
    mov crashes[2], 1    ;«–« ﬂ«‰ »‰›”ÃÌ ›‰÷Ì›  ’«œ„ „‰ Â–Â «·ÃÂ…
    here3:               ;
    sub cx, ballLength+1 ;„⁄—›… «··Ê‰ „‰ «·ÃÂ… «·”›·Ì… «·Ì”—Ì
    int 10h              ;
    cmp al, 5            ;„ﬁ«—‰ Â« »·Ê‰ «·ÿÊ» Ê«·ÕÊ«∆ÿ
    jne here4            ;
    mov crashes[3], 1    ;«–«›…  ’«œ„ „‰ Â–Â «·ÃÂ…
    here4:               ;
                      
    mov al, crashes   ;
    add al, crashes[1];
    add al, crashes[2];
    add al, crashes[3];
    cmp al, 0         ;Â‰« «–« ﬂ«‰ ·« ÌÊÃœ  ’«œ„«  ·« ‰œŒ· ›Ì Ã“¡ «· ’«œ„«  „⁄ «·ÿÊ» „‰ Â–« «·ﬂÊœ
    je finishBall     ;
                      ;
                      ;
    cmp ballPosition[2], 91;„ﬁ«—‰… «·«Õœ«ÀÌ «·—«”Ì »«⁄·Ì «Õœ«ÀÌ ··ÿÊ» Õ Ì ‰ Ã‰» Â–« «·Ã“¡ „‰ «·ﬂÊœ
    ja continue            ;
    cmp ballPosition, 1    ;„ﬁ«—‰… «·«Õœ«ÀÌ «·«›ﬁÌ »«ﬁ· «Õœ«ÀÌ ··ÿÊ» Õ Ì ‰ Ã‰» Â–« «·Ã“¡ „‰ «·ﬂÊœ
    je continue            ;
    cmp ballPosition, 320-ballLength;„ﬁ«—‰… «·«Õœ«ÀÌ «·«›ﬁÌ »«⁄·Ì «Õœ«ÀÌ ··ÿÊ» Õ Ì ‰ Ã‰» Â–« «·Ã“¡ „‰ «·ﬂÊœ
    je continue           ;
    cmp ballPosition[2], 1;„ﬁ«—‰… «·«Õœ«ÀÌ «·—«”Ì »«ﬁ· «Õœ«ÀÌ ··ÿÊ» Õ Ì ‰ Ã‰» Â–« «·Ã“¡ „‰ «·ﬂÊœ
    jbe continue          ;
                          ;
    dec score             ;Â‰« ﬁœ  „ «· ’«œ„ „⁄ «Õœ «·ÿÊ» ›‰ﬁ·· „‰ «·”ﬂÊ— ·«‰ «··«⁄» ﬁœ «Õ—“ Âœ›«
                          ;
    mov bx, ballPosition  ;‰ﬁÊ„ »„⁄—›… «Ì‰  ﬁ⁄ —«” «·ﬂ—… „‰ «·«⁄„œ… «·⁄‘—… ⁄‰ ÿ—Ìﬁ ﬁ”„ Â« ⁄·Ì 32 ›‰Õ’· ⁄·Ì —ﬁ„ «·⁄„Êœ
                          ;
    shr bx, 5             ;Â‰« ‰ﬁ”„ «·»ﬂ”· ⁄·Ì 32
    mov al, 32            ;
    mul bl                ;‰÷—» —ﬁ„ «·⁄„Êœ ›Ì 32 ··Õ’Ê· ⁄·Ì «Ê·Â
    add ax, 26           ;‰÷Ì› 26 ··Õ’Ê· ⁄·Ì «Œ— „ﬂ«‰ ··ÿÊ»…
    cmp ballPosition, ax ;‰ﬁ«—‰ „ﬂ«‰ «·ﬂ—… «·«’·Ì »«Œ— «·ÿÊ»… ·„⁄—›… Â· ÂÌ Â–Â «·ÿÊ»… «„ ÂÌ ›Ì «·›—«€ «·„Ã«Ê— ··ÿÊ»…
    jbe yes   ;
    inc bl    ;Â‰« ÂÌ ›Ì «·›—«€ „„« Ì⁄‰Ì «‰ «· ’«œ„ „‰ «·ÿÊ»… «·„Ã«Ê—… Ê·Ì” Â–… «·ÿÊ»…
    yes:      ;
    mov al, 32;
    mul bl    ;
    add ax, 6 ;«·Õ’Ê· ⁄·Ì «·«Õœ«ÀÌ «·«›ﬁÌ «·‰Â«∆Ì ··ÿÊ»… Ê«÷«›… «·Â««„‘ «·ÌÂ «Ì÷«
              ;
    mov cx, ax;Ê÷⁄ «·«Õœ«ÀÌ «·”Ì‰Ì ›Ì «·”Ì «ﬂ”
              ;
    mov ax, ballPosition[2];·„⁄—›… «·’› «·–Ì  ﬁ⁄ ›ÌÂ —«” «·ﬂ—… ‰ﬁ”„ «·«Õœ«ÀÌ «·’«œÌ ·Â« ⁄·Ì 15 ÊÂÊ ⁄œœ «·»ﬂ”·“ ›Ì «·’› «·Ê«Õœ
    dec ax    ;‰‰ﬁ’ Ê«Õœ ⁄‘«‰ ÂÌ «·‰ﬁÿ… «··Ì ›Êﬁ —«” «·ﬂ—…
    mov bl, 15;‰÷⁄ 15 ›Ì «· »Ì «·
    div bl    ;Â‰« ‰ﬁ”„ ⁄· 15 Ê—ﬁ„ «·’› ÌﬂÊÊ‰ ›Ì «·«« «·
    mov bl, 15;
    mul bl    ;‰÷—» —ﬁ„ «·’› ›Ì 15 ··Õ’Ê· ⁄·Ì «Ê· »ﬂ”· ›ÌÂ
    add ax, 5 ;‰÷Ì› «·Â«„‘ ··Õ’Ê· ⁄·Ì «Ê· «·ÿÊ»…
    mov si, ax;‰÷⁄Â ›Ì —Ã” — „ƒﬁ 
    mov di, ballPosition[2];
    add si, 15             ;
    add di, ballWidth      ;Â‰« ‰ﬁ«—‰ «Õœ«ÀÌ «·ﬂ—… »«Œ— «·ÿÊ»… ·„⁄—›… Â· ÂÌ «·ÿÊ»… «·„ÿ·Ê»… «„ «· Ì  ·ÌÂ«
    cmp di, si;
    jne omar  ;
    mov ax, si;Â‰« ‰⁄› «‰Â« «·ÿÊ»… «· Ì  ·ÌÂ«
              ;
    omar:     ;
    mov dx, ax;‰÷⁄ «·«Õœ«ÀÌ «·’«œÏ ›Ì «· œÌ «ﬂ”
                           ;
    mov startRect, cx      ;„⁄‰« «·«‰ «·«Õœ«ÀÌ«  ›‰ﬁÊ„ »—”„ „” ÿÌ· «”Êœ „ﬂ«‰ «·ÿÊ»… Õ Ì Ì „ „ÕÊÂ«
    mov startRect[2], dx   ;
    mov RectColor, 0    
    mov W, BrickWidth   
    mov L, BrickLength  
                        
    call drawRect          ;—”„ «·ÿÊ»… «·”Êœ«¡ ··«Œ›«¡
                      
                      
    continue:         
                      
    mov al, crashes        ;
    add al, crashes[1]     ;
    add al, crashes[2]     ;
    cmp al, 3              ;‰—Ì «–« ﬂ«‰ Â‰«ﬂ  ’«œ„ „‰ «Ê· À·«À ÃÂ« 
    jne here5              ;
    mov ballDirection, -1  ;«–« ﬂ«‰ ’ÕÌÕ ›÷⁄ «·« Ã«Â ›Ì «·« Ã«Â «·„⁄«ﬂ” ·Â„ „‰ Â–Â «·ÃÂ…
    mov ballDirection[2], 1;
    jmp finishBall           
                             
    here5:                   
                             
    mov al, crashes[1]       
    add al, crashes[2]       
    add al, crashes[3]       
    cmp al, 3                                      ;‰—Ì «–« ﬂ«‰ Â‰«ﬂ  ’«œ„ „‰ À«‰Ì À·«À ÃÂ« 
    jne here6                                      ;
    mov ballDirection, -1                          ;«–« ﬂ«‰ ’ÕÌÕ ›÷⁄ «·« Ã«Â ›Ì «·« Ã«Â «·„⁄«ﬂ” ·Â„ „‰ Â–Â «·ÃÂ…
    mov ballDirection[2], -1 
    jmp finishBall           
                             
    here6:                   
                             
    mov al, crashes[0]       
    add al, crashes[2]       
    add al, crashes[3]      
    cmp al, 3               ;‰—Ì «–« ﬂ«‰ Â‰«ﬂ  ’«œ„ „‰ À«·À À·«À ÃÂ« 
    jne here7               ;
    mov ballDirection, 1    ;«–« ﬂ«‰ ’ÕÌÕ ›÷⁄ «·« Ã«Â ›Ì «·« Ã«Â «·„⁄«ﬂ” ·Â„ „‰ Â–Â «·ÃÂ…
    mov ballDirection[2], -1;
    jmp finishBall          ;
                            ;
    here7:                  ;
                            ;
    mov al, crashes[0]      ;
    add al, crashes[1]      ;
    add al, crashes[3]      ;
    cmp al, 3               ;‰—Ì «–« ﬂ«‰ Â‰«ﬂ  ’«œ„ „‰ —«»⁄ À·«À ÃÂ« 
    jne here8               ;
    mov ballDirection, 1    ;«–« ﬂ«‰ ’ÕÌÕ ›÷⁄ «·« Ã«Â ›Ì «·« Ã«Â «·„⁄«ﬂ” ·Â„ „‰ Â–Â «·ÃÂ…
    mov ballDirection[2], 1 ;
    jmp finishBall          ;
                            ;
    here8:                  ;
                            ;
    mov al, crashes[0]      ;
    add al, crashes[1]      ;
    cmp al, 2               ;‰—Ì «–« ﬂ«‰ Â‰«ﬂ  ’«œ„ „‰ «Ê· À«‰Ì ÃÂ«  „‰ «·«⁄·Ì
    jne here9               ;
    mov ballDirection[2], 1 ;«–« ﬂ«‰ „‰ «·«⁄·Ì ‰⁄ﬂ” «·Õ—ﬂ… ··«”›·
    jmp finishBall          ;
                            ;
    here9:                  ;
                            ;
    mov al, crashes[1]      ;
    add al, crashes[2]      ;
    cmp al, 2               ;‰—Ì «–« ﬂ«‰ Â‰«ﬂ  ’«œ„ „‰ À«‰Ì ÃÂ«  „‰ «·Ì„Ì‰
    jne here10              ;
    mov ballDirection, -1   ;«–« ﬂ«‰ „‰ «·Ì„Ì‰ ‰⁄ﬂ” «·Õ—ﬂ… ‰ÕÊ «·Ì”«—
    jmp finishBall          ;
                            ;
    here10:                 ;
                            ;
    mov al, crashes[2]      ;
    add al, crashes[3]      ;
    cmp al, 2               ;‰—Ì «–« ﬂ«‰ Â‰«ﬂ  ’«œ„ „‰  À«‰Ì ÃÂ«  „‰ «·«”›·
    jne here11              ;
    mov ballDirection[2], -1;«–« ﬂ«‰ „‰ «·«”›· ‰⁄ﬂ” «·Õ—ﬂ… ‰ÕÊ «·«⁄·Ì
    jmp finishBall          ;
                            ;
    here11:                 ;
                            ;
    mov al, crashes         ;
    add al, crashes[3]      ;
    cmp al, 2               ;‰—Ì «–« ﬂ«‰ Â‰«ﬂ  ’«œ„ „‰ À«‰Ì ÃÂ«  „‰ «·Ì”«—
    jne here12              ;
    mov ballDirection, 1    ;«–« ﬂ«‰ „‰ «·Ì”«— ‰⁄ﬂ” «·Õ—ﬂ… ‰Õ… «·Ì„Ì‰
    jmp finishBall          ;
                            ;
    here12:                 ;
                            ;
                            ;
    cmp crashes, 1          ;Â‰« «–« ﬂ«‰ Â‰«ﬂ  ’«œ„ „‰ «·«⁄·Ì «·Ì”«— ›ﬁÿ ‰Ã⁄· «·« Ã«Â «·Ì «·Ì„Ì‰ Ê«·«”›·
    jne here13              ;
    mov ballDirection, 1    ;
    mov ballDirection[2], 1 ;
    jmp finishBall          ;
                            ;
    here13:                 ;
                            ;
    cmp crashes[1], 1       ;Â‰« «–« ﬂ«‰ Â‰«ﬂ  ’«œ„ „‰ «·«⁄·Ì «·Ì„Ì‰ ›ﬁÿ ‰Ã⁄· «·« Ã«Â «·Ì «·Ì”«— Ê«·«”›·
    jne here14              ;
    mov ballDirection, -1   ;
    mov ballDirection[2], 1 ;
    jmp finishBall          ;
                            ;
    here14:                 ;
                            ;
    cmp crashes[2], 1       ;Â‰« «–« ﬂ«‰ Â‰«ﬂ  ’«œ„ „‰ «·«”›· «·Ì„Ì‰ ›ﬁÿ ‰Ã⁄· «·« Ã«Â «·Ì «·«⁄·Ì «·Ì”«—
    jne here15              ;
    mov ballDirection, -1   ;
    mov ballDirection[2], -1;
    jmp finishBall          ;
                            ;
    here15:                 ;
                            ;
    cmp crashes[3], 1       ;Â‰« «–« ﬂ«‰ Â‰«ﬂ  ’«œ„ „‰ «·«”›· «·Ì”«— ›ﬁÿ ‰Ã⁄· «·« Ã«Â «·Ì «·Ì„Ì‰ Ê«·«⁄·Ì
    jne here16              ;
    mov ballDirection, 1    ;
    mov ballDirection[2], -1;
    jmp finishBall          ;
                            ;
    here16:                 ;
                            ;
                            ;
                            ;
    finishBall:             ;
    mov crashes, 0          ;
    mov crashes[1], 0       ;
    mov crashes[2], 0        ;
    mov crashes[3], 0        ;»⁄œ Õ”«»«  «· ’œ„«  ‰⁄Ìœ «· ’«œ„ «·Ì ’›— Õ Ì Ì ⁄„· ›Ì «·„—… «·ﬁ«œ„… ÊÂﬂ–«
                             ;
    mov ax, ballDirection    ;‰ﬁ· „Ê÷⁄ «·ﬂ—… «·Ì «·„Ê÷⁄ «·ÃœÌœ »«÷«›… «·« Ã«Â «·Ì «·„Ê÷⁄ «·ﬁœÌ„
    add ballPosition, ax     ;
    mov ax, ballDirection[2] ;
    add ballPosition[2], ax  ;
                             ;
    mov ax, ballPosition[2]  ;«· «ﬂœ «–« ﬂ«‰ «··«⁄» ﬁœ «”ﬁÿ «·ﬂ—… ÊŒ”— ⁄‰  ÿ—Ìﬁ „Ê÷⁄ «·ﬂ—…
    add ax, ballWidth        ;
    cmp ax, 199              ;
    jb herefinish            ;
    mov loseState, 1         ;«–« ﬂ«‰ ’ÕÌÕ« ›‰÷⁄ «·Œ”«—… »Ê«Õœ ﬂ„ƒ‘—
                             ;
    herefinish: ;
    popa        ;
    ret         ;
moveBall endp   ;
                ;
                ;
stopGame proc   ;«·Ã“¡ «·Œ«’ »»œ¡ «··⁄»… Ê»⁄œ «‰ Â«∆Â« ·„⁄—›… „«–« Ì—Ìœ «··«⁄» „‰ «Œ Ì«—Â
    pusha       ;
    call reset  ;›Ì «·»œ«Ì… ‰⁄Ìœ Ã„Ì⁄ «·„ €Ì—«  «·Ì «·Õ«·… «·«’·Ì…  Õ”»« ·»œ¡ «··⁄»… „‰ ÃœÌœ
                ;
    mov ah,2    ;‰Õ—ﬂ «·„ƒ‘— ·ÿ»«⁄… Ã„·…
    mov dh, 20  ;
    mov dl, 2   ;
    int 10h     ;
                ;
    mov ah, 9                ;‰ÿ»⁄ «·Ã„·… «· Ì  ŒÌ— «··«⁄» ·ﬂÌ ÌŒ «— «·Œ—ÊÃ «Ê «··⁄»
    mov dx, offset print     ;
    int 21h      ;
                 ;
    mov ah,0     ;‰‰ Ÿ— «Œ Ì«—Â Ê‰«Œ–Â
    int 16h      ;
                 ;
    cmp ah, 01h  ;‰—Ì «–« ﬂ«‰ Ì—Ìœ «·Œ—ÊÃ
    jne other    ;
    mov endGame, 1           ;‰÷⁄ «‰Â Ì—Ìœ «·«‰Â«¡ «–« ﬂ«‰ ÷€ÿ ⁄·Ì “— «·Œ—ÊÃ
                             ;
    other:       ;
    mov ah, 06h  ;‰„”Õ ﬂ· «·‘«‘… »«··Ê‰ «·«”Êœ
    mov cx, 0    ;
    mov dx, 184fh;
    mov bh, 0    ;
    xor al, al   ;
    int 10h      ;
    popa         ;
    ret          ;
stopGame endp                ;
                             ;
                             ;
end main                     ;