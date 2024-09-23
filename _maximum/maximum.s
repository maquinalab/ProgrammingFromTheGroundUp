 .section .data

data_items:
 .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0	

 .section .text

 .globl _start
_start:
 movl $0, %edi						#Carrega o registrador %edi com o primeiro índice (0)
 movl data_items(,%edi,4), %eax				#Carrega em %eax o valor do endereço (data_items + %edi*4)
							#movl indica que vai carregar com os 4 primeiros bytes
 movl %eax, %ebx					#Carrega no registrador de maior número, o valor do
							#primeiro número. (Sendo o único, é o maior por enquanto)

start_loop:
 cmpl $0, %eax						#Compara de o valor de %eax é igual a 0
 je loop_exit						#Se for igual, vai para o fim do programa
 incl %edi						#Incrementa o registrador com o índice atual
 movl data_items(,%edi,4), %eax				#Carrega %eax com o item de índice %edi
 cmpl %ebx, %eax					#Compara o valor em %eax com %ebx
 jle start_loop						#Se %eax for menor ou igual %ebx, vai para o começo do loop
 movl %eax, %ebx					#Caso contrário carrega o valor de %eax em %ebx
 jmp start_loop						#Volta para o início do loop (incondicional)

loop_exit:
 movl $1, %eax						#Condição para syscall de exit
 int $0x80						#Interrupção e syscall
