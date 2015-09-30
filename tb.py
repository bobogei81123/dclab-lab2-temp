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
    def f(x):
        return (x).to_bytes(256//8, byteorder='big')
    def g(x):
        return int.from_bytes(x, byteorder='big')

    n, d = map(lambda x: f(x), (N, D))
    ser.write(n)
    ser.write(d)

    cnt = 0
    t = -time.time()
    with open("testdata") as fl:
        while True:
            cnt += 1
            l = fl.readline()
            if not l: break;
            text = fl.readline().strip()
            print("Text = {}".format(text))
            fl.readline()
            m0t = fl.readline().split()[-1]
            c0t = fl.readline().split()[-1]
            fl.readline()
            M0 = int(m0t, base=16)
            C0 = int(c0t, base=16)
            c0 = f(C0)
            ser.write(c0)
            a = ser.read(32)
            A = g(a)
            print("Result = {}".format(a.decode()[::-1]))

            if (A == M0):
                print("PASSED !")
            else:
                print("FAILED ! M0 = {}, C0 = {}, C0' = {}".format(M0, C0, A))

            x = A
            y = M0
            print(x, y)

            cnt += 1
            print("----------------")

    t += time.time()
    print("Avg Time / request = {:.6f}".format(t / cnt))

def main():
    loop = asyncio.get_event_loop()
    loop.run_until_complete(task_input())
    #  task_input()




if __name__ == '__main__':
    main()
