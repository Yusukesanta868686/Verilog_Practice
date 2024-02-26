import math
from decimal import Decimal, getcontext

def to_fixed_point_binary(number, precision):
    getcontext().prec = precision  # 固定小数点数の精度を設定
    fixed_number = Decimal(number)
    integer_part = int(fixed_number)
    fractional_part = (fixed_number - integer_part) * (2 ** precision)
    binary_integer = bin(integer_part)[2:]
    binary_fractional = bin(int(fractional_part))[2:].zfill(precision)
    return f"{binary_integer}.{binary_fractional}"

def bin_to_ten(x):
    a = 0
    for i in range(16):
        a += int(x[2 + i]) * 2 ** (-i - 1)
        
    print(a)
    
for i in range (1, 4):
    a = math.cos(i * math.pi / 8)
    b = math.sin(i * math.pi / 8)
    c = to_fixed_point_binary(a, 16)
    d = to_fixed_point_binary(b, 16)
    print(c, d)
    bin_to_ten(c)
    bin_to_ten(d)