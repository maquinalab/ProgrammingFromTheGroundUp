 .section .data

 .section .text
 .globl _start
 .globl factorial			#Caso queira compartilhar essa função com outros programas, é importante
					#declarar como global
_start:
 push $0x5				#Iniciamos colocando o primeiro argumento na pilha
 call factorial				#Chamamos a função, que guarda o endereço da próxima instrução na pilha.
 addl $0x4, %esp			#Limpa os argumentos que entraram na pilha
 movl %eax, %ebx			#Coloca o resultado do fatorial que está em %eax em %ebx para liberar
					#%eax para o system call
 movl $0x1, %eax			#Configura o %eax para o system call exit
 int $0x80				#Interrompe e faz system call

 .type factorial,@function
factorial:
 push %ebp				#Guarda o endereço da base da pilha anterior no topo da pilha atual
 movl %esp, %ebp			#Coloca a nova base da pilha no topo atual
 movl 8(%ebp), %eax			#Carrega o argumento em %eax
 cmpl $0x1, %eax			#Compara %eax com 1
 je end_factorial			#Se o argumento for 1, a função de fatorial encerra
 decl %eax				#Decrementa o argumento
 push %eax				#Coloca (argumento - 1) no topo da pilha para ser argumento da proxima
					#Chamada da função. Guarda o endereço da próxima instrução na pilha
 call factorial				#Chama a função para (argumento - 1)
 movl 8(%ebp), %ebx			#Coloca o fatorial de (argumento - 1) em %ebx
 imull %ebx, %eax			#Multiplica (argumento) * (argumento - 1)! e guarda em %eax

end_factorial:
 movl %ebp, %esp			#Define o novo topo da pilha com o valor da base de pilha atual
 pop %ebp				#Define a nova base da pilha com o valor do topo da pilha atual
 ret					#Da um pop para sair da função e voltar para o endereço seguinte
