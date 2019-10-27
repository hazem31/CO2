R_Instuctions=['add','sub','slt','and','or','sll','jr']
R_Funct={'add':'100000','sub':'100010','and':'100100','slt':'101010','or':'100101','sll':'000000','jr':'001000'}
I_Instuctions=['lw','sw','addi','ori','beq']
I_Op={'lw':'100011','sw':'101011','beq':'000100','bne':'000101','addi':'001000','ori':'001101'}
J_Op={'j':'000010','jal':'000011'}
Registers = {'$zero':'00000','$at':'00001','$v0':'00010','$v1':'00011','$a0':'00100','$a1':'00101','$a2':'00110','$a3':'00111',
             '$t0':'01000','$t1':'01001','$t2':'01010','$t3':'01011','$t4':'01100','$t5':'01101','$t6':'01110','$t7':'01111',
             '$s0':'10000','$s1':'10001','$s2':'10010','$s3':'10011','$s4':'10100','$s5':'10101','$s6':'10110','$s7':'10111',
             '$t8':'11000','$t9':'11001','$k0':'11010','$k1':'11011','$gp':'11100','$sp':'11101','$fp':'11110','$ra':'11111'}

top = []
bottom = []
with open("test.txt") as f:
    str = f.read()

str = str.split('\n')

for ins in str:
    if ":" in ins:
        #bottom.append(ins.split(':')[0].strip())
        check = ins.split(':')[1].split(' ')[1].strip()
        if (check in R_Instuctions[:6]) or (check == "addi") or (check == "ori") or (check == "beq"):
            bottom.append(ins.split(':')[0].strip())
            bottom.append(ins.split(':')[1].split(' ')[1])
            temp = ins.split(':')[1].strip()
            bottom.append(temp[temp.find(' '):temp.find(',')].strip())
            bottom.append(temp.split(',')[1].strip())
            bottom.append(temp.split(',')[2].strip())
            #print(bottom)
            top.append(bottom)
            bottom = []
        elif check == "sw" or check == 'lw':
            bottom.append(ins.split(':')[0].strip())
            bottom.append(ins.split(':')[1].split(' ')[1].strip())
            temp = ins.split(':')[1].strip()
            bottom.append(temp[temp.find(' '):temp.find(',')].strip())
            bottom.append(temp[temp.find(',')+1:temp.find('(')].strip())
            bottom.append(temp[temp.find('(')+1:temp.find(')')].strip())
            top.append(bottom)
            bottom = []
        elif check == "jr":
            bottom.append(ins.split(':')[0].strip())
            bottom.append(ins.split(':')[1].split(' ')[1].strip())
            temp = ins.split(':')[1].strip()
            bottom.append(temp[temp.find(' '):].strip())
            #print(bottom)
            top.append(bottom)
            bottom = []
        elif check == "j" or check == "jal":
            bottom.append(ins.split(':')[0].strip())
            bottom.append(ins.split(':')[1].split(' ')[1].strip())
            temp = ins.split(':')[1].strip()
            bottom.append(temp[temp.find(' '):].strip())
            top.append(bottom)
            #print(bottom)
            bottom = []
    else:
        check = ins.strip().split(' ')[0]
        #print(check)
        if (check in R_Instuctions[:6]) or (check == "addi") or (check == "ori") or (check == "beq"):
            bottom.append(check)
            temp = ins.strip()[ins.find('$'):ins.find(',')]
            bottom.append(temp)
            bottom.append(ins.strip().split(',')[1].strip())
            bottom.append(ins.strip().split(',')[2].strip())
            #print(bottom)
            top.append(bottom)
            bottom = []
        elif check == "sw" or check == 'lw':
            bottom.append(check)
            temp = ins.strip()[ins.find('$'):ins.find(',')]
            bottom.append(temp)
            temp  = ins.strip().split(',')[1].strip()
            bottom.append(temp[:temp.find('(')].strip())
            bottom.append(temp[temp.find('(')+1:temp.find(')')])
            top.append(bottom)
            bottom = []
        elif check == "jr":
            bottom.append(check)
            temp = ins.strip()[ins.find('$'):]
            bottom.append(temp)
            top.append(bottom)
            bottom = []
        elif check == "j" or check == "jal":
            bottom.append(check)
            temp = ins.strip()[ins.find(' '):].strip()
            bottom.append(temp)
            #print(bottom)
            top.append(bottom)
            bottom = []
        #bottom.append(ins.split(' ')[0].strip())
        #print(ins.split(' ')[1].strip())

for lis in top:
    print(lis)
