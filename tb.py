from serial import Serial
import asyncio
import time

ser = Serial(port='/dev/ttyUSB0', baudrate=115200)
@asyncio.coroutine
def task_test():

    s = b'a'
    while True:
        ser.write(s)
        s = ser.read(1)
        print(s)
        yield from asyncio.sleep(1)

N =  0xCA3586E7EA485F3B0A222A4C79F7DD12E85388ECCDEE4035940D774C029CF831
E =  0x0000000000000000000000000000000000000000000000000000000000010001
D =  0xB6ACE0B14720169839B15FD13326CF1A1829BEAFC37BB937BEC8802FBCF46BD9
M0 = 0x6C6C6977206F6877202C64726F4C204F202C6E6F73206120656D20646C697542
C0 = 0x10FA8F41464D8A32BD3B885B7050E4DC8260F2C492507DA56D38D2CEA4CE05DE

def fast_pow(a, b, mod):
    if not b:
        return 1

    ret = fast_pow(a, b>>1, mod) % mod
    ret = (ret * ret) % mod
    if b & 1:
        ret = (ret * a) % mod
    return ret

@asyncio.coroutine
def task_input():
    n = N.to_bytes(256//8, byteorder='big')
    d = D.to_bytes(256//8, byteorder='big')
    c0 = C0.to_bytes(256//8, byteorder='big')
    ser.write(n)
    ser.write(n)

    cnt = 0;
    while True:
        ser.write(c0)
        a = ser.read(32)
        print(a)
        time.sleep(1)
        cnt += 1;
        if cnt == 2: c0 = (0).to_bytes(256//8, byteorder='big')

def main():
    loop = asyncio.get_event_loop()
    loop.run_until_complete(task_input())
    #  task_input()




if __name__ == '__main__':
    main()
