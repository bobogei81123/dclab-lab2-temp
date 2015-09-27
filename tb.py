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
    #  n = N.to_bytes(256//8, byteorder='big')
    #  d = D.to_bytes(256//8, byteorder='big')
    #  c0 = C0.to_bytes(256//8, byteorder='big')
    def f(x):
        return (x).to_bytes(256//8, byteorder='big')
    def g(x):
        return int.from_bytes(x, byteorder='big')
    N = 19
    D = 2
    C0 = 3
    n, d = map(lambda x: f(x), (N, D))
    ser.write(n)
    ser.write(d)

    while True:
        c0 = f(C0)
        ser.write(c0)
        a = ser.read(32)
        A = g(a)
        x = A*(2**256) % N
        y = (fast_pow(C0, D, N))
        print(x, y)
        if (x != y): input()
        #  time.sleep(0.1)
        C0 += 1

def main():
    loop = asyncio.get_event_loop()
    loop.run_until_complete(task_input())
    #  task_input()




if __name__ == '__main__':
    main()
