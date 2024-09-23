.section .data      	#Indica uma seção para dados que serão usados.

.section .text      	#Indica o início da seção de texto. Onde o programa de fato está.
.globl _start           #Declaração de um símbolo. O que será substituido por alguma informação durante a montagem
			#Símbolos geralmente são usados para marcar a localização na memória de alguma coisa
			#Então se pode se referir a eles em vez de se referir ao endereço
_start:			#Define o valor do label. Label é um símbolo seguido de ":"
			#Um endereço é associado a essa parte do programa. Se esse endereço mudar, o símbolo
			#vai se referir ao novo endereço
movl $1, %eax		#Coloca o valor 1 no registrador %eax. Se fosse o valor sem o "$" indicaria que
			#o valor no endereço 1 seria colocado no registrador %eax. O valor 1 nesse registrador
			#é necessário para fazer o system call exit.
movl $0, %ebx 		#Coloca o valor 0 no registrador %ebx. Aqui se carrega esse registrador com o status code.
			#Esse valor será mostrado na tela no fim do programa com o comando echo $?, se tudo
			#ocorreu bem.
int $0x80  		#int é para acontecer um interrupt. 0x80 indica que é um interrupt de system call
