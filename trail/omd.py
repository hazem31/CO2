from tkinter import *
from bitstring import Bits
from tkinter.tix import *
import os
def turn():
    def change(str, much):
        # print(amount)
        #    if int(str) >= 0:
        amount = "{0:#b}".format((int(str)))
        temp = amount[2:]
        temp2 = ""
        for i in range(len(temp), much, 1):
            temp2 += "0"

    # return temp2 + temp
    #    else:
    ##        temp = amount[2:]
    #        temp2 = ""
    #        for i in range(len(temp),much,1):
    #            temp2 += "1"
    #
    #        return temp2 + temp

    R_Instuctions = ['add', 'sub', 'slt', 'and', 'or', 'sll', 'jr']
    R_Funct = {'add': '100000', 'sub': '100010', 'and': '100100', 'slt': '101010', 'or': '100101', 'sll': '000000',
               'jr': '001000'}
    I_Instuctions = ['lw', 'sw', 'addi', 'ori', 'beq']
    I_Op = {'lw': '100011', 'sw': '101011', 'beq': '000100', 'bne': '000101', 'addi': '001000', 'ori': '001101'}
    J_Op = {'j': '000010', 'jal': '000011'}
    Registers = {'$zero': '00000', '$at': '00001', '$v0': '00010', '$v1': '00011', '$a0': '00100', '$a1': '00101',
                 '$a2': '00110', '$a3': '00111',
                 '$t0': '01000', '$t1': '01001', '$t2': '01010', '$t3': '01011', '$t4': '01100', '$t5': '01101',
                 '$t6': '01110', '$t7': '01111',
                 '$s0': '10000', '$s1': '10001', '$s2': '10010', '$s3': '10011', '$s4': '10100', '$s5': '10101',
                 '$s6': '10110', '$s7': '10111',
                 '$t8': '11000', '$t9': '11001', '$k0': '11010', '$k1': '11011', '$gp': '11100', '$sp': '11101',
                 '$fp': '11110', '$ra': '11111'}

    top = []
    bottom = []
    with open("test.txt") as f:
        str = f.read()

    str = str.split('\n')

    for ins in str:
        if ":" in ins:
            # bottom.append(ins.split(':')[0].strip())
            check = ins.split(':')[1].split(' ')[1].strip()
            if (check in R_Instuctions[:6]) or (check == "addi") or (check == "ori") or (check == "beq"):
                bottom.append(ins.split(':')[0].strip())
                bottom.append(ins.split(':')[1].split(' ')[1])
                temp = ins.split(':')[1].strip()
                bottom.append(temp[temp.find(' '):temp.find(',')].strip())
                bottom.append(temp.split(',')[1].strip())
                bottom.append(temp.split(',')[2].strip())
                # print(bottom)
                top.append(bottom)
                bottom = []
            elif check == "sw" or check == 'lw':
                bottom.append(ins.split(':')[0].strip())
                bottom.append(ins.split(':')[1].split(' ')[1].strip())
                temp = ins.split(':')[1].strip()
                bottom.append(temp[temp.find(' '):temp.find(',')].strip())
                bottom.append(temp[temp.find(',') + 1:temp.find('(')].strip())
                bottom.append(temp[temp.find('(') + 1:temp.find(')')].strip())
                top.append(bottom)
                bottom = []
            elif check == "jr":
                bottom.append(ins.split(':')[0].strip())
                bottom.append(ins.split(':')[1].split(' ')[1].strip())
                temp = ins.split(':')[1].strip()
                bottom.append(temp[temp.find(' '):].strip())
                # print(bottom)
                top.append(bottom)
                bottom = []
            elif check == "j" or check == "jal":
                bottom.append(ins.split(':')[0].strip())
                bottom.append(ins.split(':')[1].split(' ')[1].strip())
                temp = ins.split(':')[1].strip()
                bottom.append(temp[temp.find(' '):].strip())
                top.append(bottom)
                # print(bottom)
                bottom = []
        else:
            check = ins.strip().split(' ')[0]
            # print(check)
            if (check in R_Instuctions[:6]) or (check == "addi") or (check == "ori") or (check == "beq"):
                bottom.append(check)
                temp = ins.strip()[ins.find('$'):ins.find(',')]
                bottom.append(temp)
                bottom.append(ins.strip().split(',')[1].strip())
                bottom.append(ins.strip().split(',')[2].strip())
                # print(bottom)
                top.append(bottom)
                bottom = []
            elif check == "sw" or check == 'lw':
                bottom.append(check)
                temp = ins.strip()[ins.find('$'):ins.find(',')]
                bottom.append(temp)
                temp = ins.strip().split(',')[1].strip()
                bottom.append(temp[:temp.find('(')].strip())
                bottom.append(temp[temp.find('(') + 1:temp.find(')')])
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
                # print(bottom)
                top.append(bottom)
                bottom = []
                # bottom.append(ins.split(' ')[0].strip())
                # print(ins.split(' ')[1].strip())

    for lis in top:
        print(lis)

    f = open("asm.txt", 'w+')

    # or (ins[0] in I_Instuctions) or (ins[0] == "j") or (ins[0] == "jal")
    ints = ""
    func = ""
    opcode = ""
    rs = ""
    rt = ""
    shamt = ""
    imed = ""

    for index, ins in enumerate(top):
        if (ins[0] in R_Instuctions) or (ins[0] in I_Instuctions) or (ins[0] == "j") or (ins[0] == "jal"):
            if (ins[0] in R_Instuctions) and (ins[0] != "sll") and ins[0] != "jr":
                opcode = "000000"
                shamt = "00000"
                func = R_Funct[ins[0]]
                rd = Registers[ins[1]]
                rs = Registers[ins[2]]
                rt = Registers[ins[3]]
                ints = opcode + rs + rt + rd + shamt + func
                f.write(hex(int(ints, 2))[2:] + "\n")
            elif ins[0] == "sll":
                opcode = "000000"
                func = R_Funct[ins[0]]
                rs = "00000"
                rd = Registers[ins[1]]
                rt = Registers[ins[2]]
                # amount = "{0:#b}".format((int(ins[3])))
                # shamt = amount[2:].zfill(2)

                # shamt = change(ins[3],5)
                b = Bits(int=int(ins[3]), length=5)
                shamt = b.bin
                ints = opcode + rs + rt + rd + shamt + func
                # print(ints)
                f.write(hex(int(ints, 2))[2:] + "\n")
            elif ins[0] == "jr":
                opcode = "000000"
                func = R_Funct[ins[0]]
                rs = Registers[ins[1]]
                rt = "00000"
                rd = "00000"
                shamt = "00000"
                ints = opcode + rs + rt + rd + shamt + func
                # print(ints)
                # m = "4"
                # print(change(m,5))
                f.write(hex(int(ints, 2))[2:] + "\n")
            elif ins[0] == "lw" or ins[0] == "sw":
                opcode = I_Op[ins[0]]
                rt = Registers[ins[1]]
                rs = Registers[ins[3]]
                b = Bits(int=int(ins[2]), length=16)
                imed = b.bin
                ints = opcode + rs + rt + imed
                # print(ints)
                f.write(hex(int(ints, 2))[2:] + "\n")
                # check for ori later
            elif ins[0] == "addi" or ins[0] == "ori":
                opcode = I_Op[ins[0]]
                rt = Registers[ins[1]]
                rs = Registers[ins[2]]
                b = Bits(int=int(ins[3]), length=16)
                imed = b.bin
                ints = opcode + rs + rt + imed
                # print(ints)
                f.write(hex(int(ints, 2))[2:] + "\n")
            elif ins[0] == "beq":
                opcode = I_Op[ins[0]]
                rt = Registers[ins[1]]
                rs = Registers[ins[2]]
                tem = 0
                for i, val in enumerate(top):
                    if ins[3] == val[0]:
                        tem = i - (index + 1)
                        break
                b = Bits(int=int(tem), length=16)
                imed = b.bin
                ints = opcode + rs + rt + imed
                # print(b.int)
                # print(ints)
                f.write(hex(int(ints, 2))[2:] + "\n")
            elif ins[0] == "j" or ins[0] == "jal":
                opcode = J_Op[ins[0]]
                tem = 0
                for i, val in enumerate(top):
                    if ins[1] == val[0]:
                        tem = i - (index + 1)
                        break
                b = Bits(int=int(tem), length=16)
                imed = b.bin
                ints = opcode + imed
                # print(b.int)
                # print(ints)
                f.write(hex(int(ints, 2))[2:] + "\n")
        else:
            if (ins[1] in R_Instuctions) and (ins[1] != "sll") and ins[1] != "jr":
                opcode = "000000"
                shamt = "00000"
                func = R_Funct[ins[1]]
                rd = Registers[ins[2]]
                rs = Registers[ins[3]]
                rt = Registers[ins[4]]
                ints = opcode + rs + rt + rd + shamt + func
                f.write(hex(int(ints, 2))[2:] + "\n")
            elif ins[1] == "sll":
                opcode = "000000"
                func = R_Funct[ins[1]]
                rs = "00000"
                rd = Registers[ins[2]]
                rt = Registers[ins[3]]
                # amount = "{0:#b}".format((int(ins[3])))
                # shamt = amount[2:].zfill(2)

                # shamt = change(ins[3],5)
                b = Bits(int=int(ins[4]), length=5)
                shamt = b.bin
                ints = opcode + rs + rt + rd + shamt + func
                # print(ints)
                f.write(hex(int(ints, 2))[2:] + "\n")
            elif ins[1] == "jr":
                opcode = "000000"
                func = R_Funct[ins[1]]
                rs = Registers[ins[2]]
                rt = "00000"
                rd = "00000"
                shamt = "00000"
                ints = opcode + rs + rt + rd + shamt + func
                # print(ints)
                # m = "4"
                # print(change(m,5))
                f.write(hex(int(ints, 2))[2:] + "\n")
            elif ins[1] == "lw" or ins[1] == "sw":
                opcode = I_Op[ins[1]]
                rt = Registers[ins[2]]
                rs = Registers[ins[4]]
                b = Bits(int=int(ins[3]), length=16)
                imed = b.bin
                ints = opcode + rs + rt + imed
                # print(ints)
                f.write(hex(int(ints, 2))[2:] + "\n")
                # check for ori later
            elif ins[1] == "addi" or ins[1] == "ori":
                opcode = I_Op[ins[1]]
                rt = Registers[ins[2]]
                rs = Registers[ins[3]]
                b = Bits(int=int(ins[4]), length=16)
                imed = b.bin
                ints = opcode + rs + rt + imed
                # print(ints)
                f.write(hex(int(ints, 2))[2:] + "\n")
            elif ins[1] == "beq":
                opcode = I_Op[ins[1]]
                rt = Registers[ins[2]]
                rs = Registers[ins[3]]
                tem = 0
                for i, val in enumerate(top):
                    if ins[4] == val[0]:
                        tem = i - (index + 1)
                        break
                b = Bits(int=int(tem), length=16)
                imed = b.bin
                ints = opcode + rs + rt + imed
                # print(b.int)
                # print(ints)
                f.write(hex(int(ints, 2))[2:] + "\n")
            elif ins[1] == "j" or ins[1] == "jal":
                opcode = J_Op[ins[1]]
                tem = 0
                for i, val in enumerate(top):
                    if ins[2] == val[0]:
                        tem = i - (index + 1)
                        break
                b = Bits(int=int(tem), length=16)
                imed = b.bin
                ints = opcode + rs + rt + imed
                # print(b.int)
                # print(ints)
                f.write(hex(int(ints, 2))[2:] + "\n")
    # f.write("This is line")

    f.close()


root = Tk()

def asm():
    print("hello")
    str = ""
    with open("test.txt") as f:
        str = f.read()
    master = Tk()
    swin = ScrolledWindow(master, width=500, height=500)
    swin.grid(row=0)
    win = swin.window

    num = str.split('\n')
    for i,val in enumerate(num):
        word = Label(win, text="{}-asm == {}".format(i,val))
        word.grid(row=i+1, sticky=W)


# frame = Frame(root,width=300,height=250,bg="red")
# frame.pack()
# button = Button(root,text="change",command=hi)
# button.pack()

def domothing():
    print("hello")
    str = ""
    with open("asm.txt") as f:
        str = f.read()

    num = str.split('\n')
    master1 = Tk()
    swin = ScrolledWindow(master1, width=500, height=500)
    swin.grid(row=0)
    win = swin.window

    for i, val in enumerate(num):
        word = Label(win, text="{}-0b == {}".format(i,val))
        word.grid(row=i + 1, sticky=W)

def dm():
    print("hello")
    str = ""
    with open("DataMemory.txt") as f:
        str = f.read()

    num = str.split('\n')
    master2 = Tk()
    swin = ScrolledWindow(master2, width=500, height=500)
    swin.grid(row=0)
    win = swin.window
    # frame1 = Frame(master2, width=300, )
    # frame1.grid(row=1)

    for i in range(50):
        word = Label(win, text="location {} = {}".format(i,num[i]))
        word.grid(row=i + 3, sticky=W)

def rf():
    print("hello")
    str = ""
    with open("Regesters.txt") as f:
        str = f.read()

    num = str.split('\n')
    master3 = Tk()
    swin = ScrolledWindow(master3, width=500, height=500)
    swin.grid(row=0)
    win = swin.window
    # frame1 = Frame(master2, width=300, )
    # frame1.grid(row=1)

    for i in range(len(num)):
        word = Label(win, text="{}th regester = {}".format(i, num[i]))
        word.grid(row=i + 3, sticky=W)


def donothing():
    print("nothing")
    myCmd = 'ls'
    os.system(myCmd)



def simulink():
    myCmd = 'ls'
    os.system(myCmd)

    myCmd = 'vsim -c'
    os.system(myCmd)

    myCmd = 'vsim -c work.MIPS_CPU -do run'
    os.system(myCmd)


menu = Menu(root)
root.config(menu=menu)

submenu = Menu(menu)
menu.add_cascade(label="Tasks",menu=submenu)
submenu.add_command(label="change asm to hex",command=turn)
submenu.add_command(label="open asm file",command=asm)
submenu.add_separator()
submenu.add_command(label="view hex file",command=domothing)
submenu.add_command(label="open DataMemory",command=dm)
submenu.add_command(label="open Registers",command=rf)
submenu.add_command(label="simulate",command=simulink)


edit = Menu(menu)
menu.add_cascade(label="edit",menu=edit)
edit.add_command(label="new",command=donothing)
edit.add_command(label="open",command=donothing)

frame = Frame(root,width=300,height=50)
frame.grid(row=0)

word1 = Label(root,text="assembly:")
word1.grid(row=1)

def retrieve_input():
    inputValue=textBox.get("1.0","end-1c")
    print(inputValue)
    with open("test.txt","w+") as f:
        f.write(inputValue)



textBox=Text(root, height=20, width=100)
textBox.grid(row=2)


buttonCommit=Button(root, height=2, width=15, text="save",
                    command=lambda: retrieve_input())
buttonCommit.grid(row=3)
root.mainloop()
