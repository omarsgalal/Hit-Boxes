.model medium                   ;
.stack 64                       ;               
                                ;               
.data                           ;               
                                ;               
bricklength equ 20              ;��� ������� ���� ��������               
brickWidth equ 10               ;               
playerlength equ  60            ;               
playerWidth equ 10              ;               
ballLength equ 8                ;               
ballWidth equ 8                 ;               
                                ;               
startRect dw 0,0                ;���� ����� ��������               
W dw 0                          ;����� ������ �������               
L dw 0                          ;����� ������ ��������               
rectColor db ?                  ;��� ��������               
                                ;               
startLine dw 0, 0               ;���� ����� ���� ������               
length dw 0                     ;��� ����               
lineColor db 0                  ;��� ����               
                                ;               
playerPositionOld dw 130, 180   ;������ ������� �����               
playerPosition dw 130, 180      ;���� ������ �������               
                                ;               
ballPositionOld dw 160, 170     ;������ ������� ������� ������               
ballPosition dw 160, 170        ;������ ������� �����               
                                ;               
BallDirection dw 1, -1          ;����� ���� �����               
                                ;               
crashes db 4 dup(0)             ;������ ����� �� ������ �������               
                                ;               
score db 60                     ;������ �����               
loseState db 0                  ;������ �������               
                                ;               
win db 'you win$'               ;����� �������               
lose db 'you lose$'             ;               
print db 'press any key to start or esc to exit$'  ;
             ;
endGame db 0 ;����� ������
     ;
.code 
     ;
     ;
reset proc ;������ ���� ��������� ��� ��� ����
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
    mov ah,0      ;������ ��� �������� ���
    mov al,13h    ;
    int 10h       ;
                  ;
    call stopGame ;������� ������� �������� �� ������
    cmp endGame, 1;������ �� ���� ������ �� ������ �� ��
    je finalisHere;
                  ;
    startHere:    ;
    call drawScene;���� ���� ������
                  ;
    mainLoop:     ;
    mov ah,1      ;��� ������� �� ������ ���� ��������
    int 16h       ;
    jz here       ;
    call movePlayer  ;������ ������ �� ��� ��� ��� �������
    call drawPlayer  ;���� ��� ���� �����
    here:            ;
    call moveBall    ;������ �����
    call drawBall    ;��� ������ ������ �����
    cmp score, 0     ;������ �� ��� ������ �� ��
    je gameOver      ;
    cmp loseState, 1 ;������ �� ��� �� ��
    je gameOver      ;
    jmp mainLoop     ;
                     ;
                     ;
    gameOver:        ;
                     ;
    mov ah,2         ;����� ������� ��� ���� �������
    mov dh, 19       ;
    mov dl, 2        ;
    int 10h          ;
                     ;
    cmp loseState, 1    ;������ �� �������
    je true             ;
    mov dx, offset win  ;��� �� ��� ����� �����
    jmp comehere        ;
    true:               ;
    mov dx, offset lose ;��� �� ��� ����� �������
    comehere:           ;
    mov ah, 9           ;
    int 21h             ;
                        ;
                        ;
    call stopGame       ;������ ��� ���� ����� ������
    cmp endGame, 0      ;�� ���� ������
    je startHere        ;
                        ;
    finalishere:        ;
    mov ah,4ch             ;����� ������
    int 21h                                        ;
main endp                                          ;
                                                   ;
                                                   ;
                         ;
drawLine proc            ;���� �� ����
    pusha                ;
    mov dx, startLine[2] ;��� ��� ���� ��� �� cx ,� �� dx
    mov cx, startLine[0] ;
    mov al, lineColor    ;��� ����� ��� �� al
    lineloop:                                      ;
    mov ah,0ch                 			   ;��� ������
    int 10h         ;
    inc cx          ;
    dec length      ;����� ����� 
    cmp length, 0   ;�� ��� ����� ����� ��� ����� ������
    jne lineloop    ;
    popa            ;
    ret             ;
drawLine endp       ;
                    ;
                    ;
drawRect proc       ; ��� ������ ���� �� ���� ��� ���� ���� �����
    pusha           ;
    mov cx, L       ;
    mov length, cx      ;��� ��� �������� ��� ��� ����
    mov bl, rectColor   ;
    mov lineColor, bl   ;��� ��� �������� ��� ��� ����
    mov cx, startRect   ;
    mov startLine, cx   ;��� ����� �������� ��� ����� ����
    mov si, startRect[2];
    mov di, si          ;
    add si, W           ;��� ��� �������� �� �� �� �� ����� ������ ��� ������ �����
    rectloop:           ;������ ���� ����� ���� �����
    mov cx, L           ;
    mov length, cx      ;��� ��� ����
    mov startLine[2], di;��� �������� ������ ��� ���� �� ��� ����
    call drawLine       ;���� ��� ��� ����
    inc di              ;����� �������� ������ 
    cmp di, si          ;������ �������� ������ ���� 
    jne rectloop        ;
    popa     ;
    ret      ;
drawRect endp;
             ;
             ;
drawWalls proc  ;��� ����� ������
    pusha       ;
                ; ��� ��� ��� �� �� ����� ������ �����
    mov startLine, 0   ;
    mov startLine[2], 0;
    mov lineColor, 5   ;
    mov length, 320    ;
    call drawLine      ;
                       ;
    mov startLine, 0   ;��� ��� ��� �� �� ����� ������ �����
    mov startLine[2], 199                          ;
    mov lineColor, 5                               ;
    mov length, 320;
    call drawLine  ;
                   ;
    mov al, 5      ;��� ����� ��� ������� ����� ��
    mov cx, 0      ;
    mov dx, 0      ;
                   ;
    wallsloop:     ;��� ������ ���� ���� ������ ������ �������
    mov ah, 0ch    ;������ ��� ������
    int 10h        ;
    add cx, 319    ;��� �������� ������ ���� ���� �� ����� ��������
    mov ah, 0ch    ;��� ������
    int 10h        ;
    sub cx, 319    ;����� �������� ������ ��� �����
    inc dx         ;����� ������
    cmp dx, 200    ;������ ������ ���� ���� �� ������ ������ ��� ��� ������
    jne wallsloop  ;
                   ;
    popa           ;
    ret            ;
drawWalls endp     ;
                   ;
drawBricks proc    ;��� ����� ��� ��� �������
    pusha          ;
    mov bx, 5      ;����� ��� ������ ������
                   ;
    bricksloop2:   ;��� ���� ���� ���� �����
    mov ax, 6      ;��� ��� ������ ������ ��� �����
    mov RectColor, 5  ;��� ��� �����
    bricksloop1:      ;������ �������� ���� 10 ����� �� ���� ������
    mov startRect, ax ;
    mov startRect[2], bx ;��� ��� �������� ����� ������ 
    mov L, bricklength   ;��� ��� ������ �� ��� ��������
    mov w, brickWidth;��� ��� ������ �� ��� ��������
    call drawRect    ;��� ������ ��� ���� �� ������ ��������
    add ax, 32       ;����� ������ ��� ��� �� ���� ������� ���� �����
    cmp ax, 320      ;�������� ������ ������ ��� ��� �������� �� �����
    jb bricksloop1   ;
    add bx, 15       ;���� ������ ��� ��� �� ���� ������� ���� �����
    cmp bx, 95       ;�������� ����� �� ������ ������ �� ������
    jb bricksloop2   ;
             
    popa     
    ret      
drawBricks endp ;
                ;
                ;
drawPlayer proc ;��� ���� ���� ������ �� ���� ��� ����� ������ ���� ����� ������
    pusha       ;
                ;
    mov rectColor, 0    ;�� ��� ����� ��� ������� ���� ������ ���� ���� ������ ������
    mov W, playerWidth  ;
    mov L, playerLength ;
    mov ax, playerPositionOld
    mov startRect, ax        
    mov startRect[2], 180    
    call drawRect            
                             
    mov rectColor, 5;�� ��� ����� ��� ������� ���� ������ ������ �������� �� ����� ������
    mov W, playerWidth      
    mov L, playerLength     
    mov ax, playerPosition  
    mov startRect, ax       
    mov startRect[2], 180   
    call drawRect           
                            
                            
    popa                    
    ret                     
drawPlayer endp             
                            
                            
drawScene proc                                     ;��� ��� ������ ����� �� ����� ������
    pusha          ;
    call drawWalls ;��� �������
                   ;
    call drawBricks;��� �����
                   ;
    call drawPlayer;��� ������
                   ;
    call drawBall  ;��� ����� �������� �� ���� ������� ������ ���
                   ;
    popa           ;
    ret            ;
drawScene endp;
              ;
              ;
              ;
drawBall proc ;����� ����� ���� �����
    pusha     ;
              ;
    mov rectColor, 0 ;��� ��� ��� ������ ���� ���� ����� �� ������ ������ 
    mov W, ballWidth ;
    mov L, ballLength;
    mov ax, ballPositionOld
    mov startRect, ax      
    mov ax, ballPositionOld[2]
    mov startRect[2], ax      
    call drawRect             
                              
                              
    mov rectColor, 4 ;��� ��� ��� ������ ���� ����� �� ������ ������
    mov W, ballWidth ;
    mov L, ballLength;
    mov ax, ballPosition   
    mov startRect, ax      
    mov ax, ballPosition[2]
    mov startRect[2], ax   
    call drawRect          
                           
    mov cx, 40000;��� ������ ������� �� ���� ����� �����
    slow:      
    loop slow  
               
    popa       
    ret        
drawBall endp  
               
               
               
movePlayer proc  ;����� ����� ������ ������ ����� ������ �� ��� ������ ��� ������
    pusha        ;
                 ;
    cmp ah, 4Dh  ;�������� ������� ����� ����� ������
    jne left     
                 
    cmp playerPosition, 320-6-playerlength;������ �� ��� ������ ��� ����� ������
    jae finishMoving  
    mov ax, playerPosition ;��� ���� ������ ���� ��� ��� ��� ������ ������ ���� �����
    mov playerPositionOld, ax;
    add playerPosition, 8    ;����� ������ ����� ����� ������ 8 ������
    jmp finishMoving         ;
                             ;
    left:                    ;
    cmp ah, 4Bh              ;�������� ������� ����� ����� ������
    jne finishMoving         ;
                             ;
    cmp playerPosition, 6    ;�������� ������ ������ �� �� ���� ����
    jbe finishMoving         ;
    mov ax, playerPosition    ;��� ���� ������ ��� ������ ������
    mov playerPositionOld, ax ;
    sub playerPosition, 8     ;������ ����� ������ 8 ������
                             
    finishMoving:            
                             
    mov ah, 0                 ;����� ����� �� ���� �������
    int 16h                 
                            
    popa                    
    ret                     
movePlayer endp             
                            
                    
moveBall proc        ;����� ����� ������ ����� ���������� �������� ������
    pusha            ;
                     ;
    mov ax, ballPosition   ;��� ��� ���� ����� ��� ������ ������ ���� ���� ��� �����
    mov ballPositionOld, ax;
    mov ax, ballPosition[2];
    mov ballPositionOld[2], ax
                              
                              
    mov ah, 0Dh;������� ������� �� ����� ������ ������ �� ����� ������ ����� ����� ������ ������� �� ��� �����
    mov bh, 0  ;
    mov cx, ballPosition   
    mov dx, ballPosition[2]
    dec cx                 
    dec dx                 
    int 10h                

    cmp al, 5            ;���� �� ��� ����� �� ��� ���� ����� ������ ��
    jne here1            ;
    mov crashes, 1       ;����� ������ �� ����� ��������� �� ��� �����
    here1:               ;

    add cx, ballLength+1 ;����� ��� ���� ������ �� ����� ������� ������
    int 10h              ;
    cmp al, 5            ;�������� ������ ��������
    jne here2            ;
    mov crashes[1], 1    ;����� ����� �� ������� ��� ��� ����� ������
    here2:               ;

    add dx, ballWidth+1  ;����� ��� ������ �� ����� ������� ������
    int 10h              ;
    cmp al, 5            ;�������� ���� ����� ��������
    jne here3            ;
    mov crashes[2], 1    ;��� ��� ������ ����� ����� �� ��� �����
    here3:               ;
    sub cx, ballLength+1 ;����� ����� �� ����� ������� ������
    int 10h              ;
    cmp al, 5            ;�������� ���� ����� ��������
    jne here4            ;
    mov crashes[3], 1    ;����� ����� �� ��� �����
    here4:               ;
                      
    mov al, crashes   ;
    add al, crashes[1];
    add al, crashes[2];
    add al, crashes[3];
    cmp al, 0         ;��� ��� ��� �� ���� ������� �� ���� �� ��� ��������� �� ����� �� ��� �����
    je finishBall     ;
                      ;
                      ;
    cmp ballPosition[2], 91;������ �������� ������ ����� ������ ����� ��� ����� ��� ����� �� �����
    ja continue            ;
    cmp ballPosition, 1    ;������ �������� ������ ���� ������ ����� ��� ����� ��� ����� �� �����
    je continue            ;
    cmp ballPosition, 320-ballLength;������ �������� ������ ����� ������ ����� ��� ����� ��� ����� �� �����
    je continue           ;
    cmp ballPosition[2], 1;������ �������� ������ ���� ������ ����� ��� ����� ��� ����� �� �����
    jbe continue          ;
                          ;
    dec score             ;��� �� �� ������� �� ��� ����� ����� �� ������ ��� ������ �� ���� ����
                          ;
    mov bx, ballPosition  ;���� ������ ��� ��� ��� ����� �� ������� ������ �� ���� ������ ��� 32 ����� ��� ��� ������
                          ;
    shr bx, 5             ;��� ���� ������ ��� 32
    mov al, 32            ;
    mul bl                ;���� ��� ������ �� 32 ������ ��� ����
    add ax, 26           ;���� 26 ������ ��� ��� ���� ������
    cmp ballPosition, ax ;����� ���� ����� ������ ���� ������ ������ �� �� ��� ������ �� �� �� ������ ������� ������
    jbe yes   ;
    inc bl    ;��� �� �� ������ ��� ���� �� ������� �� ������ �������� ���� ��� ������
    yes:      ;
    mov al, 32;
    mul bl    ;
    add ax, 6 ;������ ��� �������� ������ ������� ������ ������ ������� ���� ����
              ;
    mov cx, ax;��� �������� ������ �� ���� ���
              ;
    mov ax, ballPosition[2];������ ���� ���� ��� ��� ��� ����� ���� �������� ������ ��� ��� 15 ��� ��� ������� �� ���� ������
    dec ax    ;���� ���� ���� �� ������ ���� ��� ��� �����
    mov bl, 15;��� 15 �� �� �� ��
    div bl    ;��� ���� �� 15 ���� ���� ����� �� ���� ��
    mov bl, 15;
    mul bl    ;���� ��� ���� �� 15 ������ ��� ��� ���� ���
    add ax, 5 ;���� ������ ������ ��� ��� ������
    mov si, ax;���� �� ����� ����
    mov di, ballPosition[2];
    add si, 15             ;
    add di, ballWidth      ;��� ����� ������ ����� ���� ������ ������ �� �� ������ �������� �� ���� �����
    cmp di, si;
    jne omar  ;
    mov ax, si;��� ��� ���� ������ ���� �����
              ;
    omar:     ;
    mov dx, ax;��� �������� ������ �� �� �� ���
                           ;
    mov startRect, cx      ;���� ���� ���������� ����� ���� ������ ���� ���� ������ ��� ��� �����
    mov startRect[2], dx   ;
    mov RectColor, 0    
    mov W, BrickWidth   
    mov L, BrickLength  
                        
    call drawRect          ;��� ������ ������� �������
                      
                      
    continue:         
                      
    mov al, crashes        ;
    add al, crashes[1]     ;
    add al, crashes[2]     ;
    cmp al, 3              ;��� ��� ��� ���� ����� �� ��� ���� ����
    jne here5              ;
    mov ballDirection, -1  ;��� ��� ���� ��� ������� �� ������� ������� ��� �� ��� �����
    mov ballDirection[2], 1;
    jmp finishBall           
                             
    here5:                   
                             
    mov al, crashes[1]       
    add al, crashes[2]       
    add al, crashes[3]       
    cmp al, 3                                      ;��� ��� ��� ���� ����� �� ���� ���� ����
    jne here6                                      ;
    mov ballDirection, -1                          ;��� ��� ���� ��� ������� �� ������� ������� ��� �� ��� �����
    mov ballDirection[2], -1 
    jmp finishBall           
                             
    here6:                   
                             
    mov al, crashes[0]       
    add al, crashes[2]       
    add al, crashes[3]      
    cmp al, 3               ;��� ��� ��� ���� ����� �� ���� ���� ����
    jne here7               ;
    mov ballDirection, 1    ;��� ��� ���� ��� ������� �� ������� ������� ��� �� ��� �����
    mov ballDirection[2], -1;
    jmp finishBall          ;
                            ;
    here7:                  ;
                            ;
    mov al, crashes[0]      ;
    add al, crashes[1]      ;
    add al, crashes[3]      ;
    cmp al, 3               ;��� ��� ��� ���� ����� �� ���� ���� ����
    jne here8               ;
    mov ballDirection, 1    ;��� ��� ���� ��� ������� �� ������� ������� ��� �� ��� �����
    mov ballDirection[2], 1 ;
    jmp finishBall          ;
                            ;
    here8:                  ;
                            ;
    mov al, crashes[0]      ;
    add al, crashes[1]      ;
    cmp al, 2               ;��� ��� ��� ���� ����� �� ��� ���� ���� �� ������
    jne here9               ;
    mov ballDirection[2], 1 ;��� ��� �� ������ ���� ������ ������
    jmp finishBall          ;
                            ;
    here9:                  ;
                            ;
    mov al, crashes[1]      ;
    add al, crashes[2]      ;
    cmp al, 2               ;��� ��� ��� ���� ����� �� ���� ���� �� ������
    jne here10              ;
    mov ballDirection, -1   ;��� ��� �� ������ ���� ������ ��� ������
    jmp finishBall          ;
                            ;
    here10:                 ;
                            ;
    mov al, crashes[2]      ;
    add al, crashes[3]      ;
    cmp al, 2               ;��� ��� ��� ���� ����� ��  ���� ���� �� ������
    jne here11              ;
    mov ballDirection[2], -1;��� ��� �� ������ ���� ������ ��� ������
    jmp finishBall          ;
                            ;
    here11:                 ;
                            ;
    mov al, crashes         ;
    add al, crashes[3]      ;
    cmp al, 2               ;��� ��� ��� ���� ����� �� ���� ���� �� ������
    jne here12              ;
    mov ballDirection, 1    ;��� ��� �� ������ ���� ������ ��� ������
    jmp finishBall          ;
                            ;
    here12:                 ;
                            ;
                            ;
    cmp crashes, 1          ;��� ��� ��� ���� ����� �� ������ ������ ��� ���� ������� ��� ������ �������
    jne here13              ;
    mov ballDirection, 1    ;
    mov ballDirection[2], 1 ;
    jmp finishBall          ;
                            ;
    here13:                 ;
                            ;
    cmp crashes[1], 1       ;��� ��� ��� ���� ����� �� ������ ������ ��� ���� ������� ��� ������ �������
    jne here14              ;
    mov ballDirection, -1   ;
    mov ballDirection[2], 1 ;
    jmp finishBall          ;
                            ;
    here14:                 ;
                            ;
    cmp crashes[2], 1       ;��� ��� ��� ���� ����� �� ������ ������ ��� ���� ������� ��� ������ ������
    jne here15              ;
    mov ballDirection, -1   ;
    mov ballDirection[2], -1;
    jmp finishBall          ;
                            ;
    here15:                 ;
                            ;
    cmp crashes[3], 1       ;��� ��� ��� ���� ����� �� ������ ������ ��� ���� ������� ��� ������ �������
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
    mov crashes[3], 0        ;��� ������ �������� ���� ������� ��� ��� ��� ����� �� ����� ������� �����
                             ;
    mov ax, ballDirection    ;��� ���� ����� ��� ������ ������ ������ ������� ��� ������ ������
    add ballPosition, ax     ;
    mov ax, ballDirection[2] ;
    add ballPosition[2], ax  ;
                             ;
    mov ax, ballPosition[2]  ;������ ��� ��� ������ �� ���� ����� ���� ��  ���� ���� �����
    add ax, ballWidth        ;
    cmp ax, 199              ;
    jb herefinish            ;
    mov loseState, 1         ;��� ��� ����� ���� ������� ����� �����
                             ;
    herefinish: ;
    popa        ;
    ret         ;
moveBall endp   ;
                ;
                ;
stopGame proc   ;����� ����� ���� ������ ���� �������� ������ ���� ���� ������ �� �������
    pusha       ;
    call reset  ;�� ������� ���� ���� ��������� ��� ������ ������� ����� ���� ������ �� ����
                ;
    mov ah,2    ;���� ������ ������ ����
    mov dh, 20  ;
    mov dl, 2   ;
    int 10h     ;
                ;
    mov ah, 9                ;���� ������ ���� ���� ������ ��� ����� ������ �� �����
    mov dx, offset print     ;
    int 21h      ;
                 ;
    mov ah,0     ;����� ������� ������
    int 16h      ;
                 ;
    cmp ah, 01h  ;��� ��� ��� ���� ������
    jne other    ;
    mov endGame, 1           ;��� ��� ���� ������� ��� ��� ��� ��� �� ������
                             ;
    other:       ;
    mov ah, 06h  ;���� �� ������ ������ ������
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