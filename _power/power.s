#Lembrar de montar o arquivo sempre com a opção (as --32 -g -o programa.o programa.s) --32 para montar usando
#organização de 32 bits, visto que o sistema é de 64 bits. -g para o arquivo poder ser debugado
#Para linkar devemos dar o comando (ld -m elf_i386 -g -o programa programa.o)

.section .data

 .section .text
 .globl _start
_start:
 push $0x5				#Coloca 5 no topo da pilha. O endereço da base da pilha está gravado
					#em %ebp. O endereço do topo da pilha está gravado em %esp.
					#Nesse momento o endereço da base da pilha e o do topo da pilha
					#coincidem, pois só existe um elemento na pilha.
					#O conjunto de elementos entre o topo da pilha e a base da pilha
 					#são chamados de Quadro de Pilha (Stack Frame)
 push $0x3				#Coloca 3 no topo da pilha. A pilha cresce de trás para frente em 
					#relação aos endereços. Então %esp é decrementado em 4 bytes (valor
					#da palavra) para indicar o novo endereço que marca o topo da pilha
					#e esse endereço é carregado com o valor 3.
					#Até aqui a pilha se parece com:
					#0x00000003 0x00000005
 call power				#Aqui a função "power" é chamada. Na hora que uma função é chamada,
					#o endereço que vem depois dela é guardado para que volte para ele
					#depois que a função ser finalizada.
					#Então a pilha vai ficar
					#0xffcb2394  0x00000003 0x00000005
					#Onde 0xffcb2394 é o endereço da próxima instrução depois da função.
 addl $0x8, %esp			#Volta o topo da pilha para o endereço de antes da declaração de
					#argumentos.
 push %eax				#Coloca o resultado da primeira chamada no topo da pilha.
 push $0x2				#Coloca o segundo argumento no topo da pilha.
 push $0x1				#Coloca o primeiro argumento no topo da pilha
 call power				#Chama a função para obter a potência do número. (primeiro argumento
					#elevado ao segundo argumento)
 addl $0x8, %esp			#Após retornar da função atualizamos o topo da pilha para descartar
					#os argumentos
 pop %ebx				#Colocamos o resultado da primeira chamada de função em %ebx.	
 addl %eax, %ebx			#Como o resultado da última chamada de função já está em %eax, somamos
					#%eax com %ebx e guardamos em %ebx (status code).
 movl $0x1, %eax			#Colocamos 1 em %eax para fazermos a system call de saída do programa.
 int $0x80				#Interrompe o programa e chama a system call configurada.

 .type power,@function			#Aqui se define que power é uma função.
power:					#Começamos a definir a função "power"
 push %ebp				#Colocamos o valor do endereço da base da pilha do quadro de pilha anterior
					#no topo da pilha.
 movl %esp, %ebp			#O endereço de topo da pilha atual vai ser também o endereço de base
					#de pilha. (A partir daqui definimos o novo Quadro de Pilha)
 subl $0x4, %esp			#Decrementamos o topo de pilha para reservar o espaço para variáveis
					#locais.
 movl 8(%ebp), %ebx			#Pega o valor do segundo elemento da pilha (de 4 em 4) depois do que 
					#está no endereço gravado em %epb, ou seja, o primeiro argumento "3",
					#e guarda em %ebx
 movl 12(%ebp), %ecx			#Pega o valor do terceiro elemento depois da base da pilha, ou seja,
					#5, e guarda em %ecx
 movl %ebx, -4(%ebp)			#Guarda o primeiro argumento no espaço reservado para variáveis locais
power_loop_start:			#Aqui se inicia o loop de multiplicações sucessivas.
 cmpl $0x1, %ecx			#Verifica se o segundo argumento (expoente) é igual a 1.
 je end_power				#Se for igual a 1, a função vai ser finalizada.
 movl -4(%ebp), %eax			#Guarda a variável local em %eax.
 imull %ebx, %eax			#Multiplica a base pela variável local (3 x 3 na primeira iteração) e
					#guarda o resultado em %eax.
 movl %eax, -4(%ebp)			#Guarda o valor em %eax no espaço reservado para a variável local.
 decl %ecx				#Decrementa %ecx.
 jmp power_loop_start			#Reinicia o loop.
end_power:				#Finalização da função
 movl -4(%ebp), %eax			#Guardamos a variável local (resultado) em %eax.
 movl %ebp, %esp			#O novo topo da pilha é o que era antes da chamada da função
 pop %ebp				#A nova base da pilha volta a ser o valor antes da chamada da função
 ret					#Aqui se faz um "pop" atualizando o contador de programa para o endereço
					#de antes da chamada da função.
