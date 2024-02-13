from memory.unsafe import Pointer

struct ComplexNum:
    var re: Float64
    var im: Float64

    fn __init__(inout self, re: Float64, im: Float64) -> None:
        self.re = re
        self.im = im
    
    fn __add__(inout self, other: ComplexNum) -> ComplexNum:
        return ComplexNum(self.re + other.re, self.im + other.im)
    
    fn __sub__(inout self, other: ComplexNum) -> ComplexNum:
        return ComplexNum(self.re - other.re, self.im - other.im)
    
    fn __mul__(inout self, other: ComplexNum) -> ComplexNum:
        return ComplexNum(self.re * other.re - self.im * other.im, self.re * other.im + self.im * other.re)
    
    fn __getitem__(borrowed self, i: Int) raises -> Float64 :
        if i == 0:
            return self.re
        elif i == 1:
            return self.im
        else:
            raise("Index out of range")
    
    fn __setitem__(inout self, i: Int, value: ComplexNum) raises -> None:
        if i == 0:
            self.re = value.re
        elif i == 1:
            self.im = value.im
        else:
            raise("Index out of range")
    
    fn print(inout self) -> None:
        print(self.re, "+", self.im, "i")

struct ComplexArray:
    var ArrPointer: Pointer[Float64]
    var len: Int
    var capacity: Int
    var length: Float64

    fn __init__(inout self, capacity: Int, default_value: ComplexNum) raises -> None:
        self.len = capacity * 2 if capacity > 0 else 1
        self.capacity = self.len * 4
        self.ArrPointer = Pointer[Float64].alloc(self.capacity)
        self.length = self.len / 2
    
        for i in range(self.len):
            self[i] = default_value
    
    fn __getitem__(borrowed self, i: Int) raises -> ComplexNum:
        if i > self.len:
            raise("Index out of range")
        return ComplexNum(self.ArrPointer.load(i), self.ArrPointer.load(i + 1))
    
    fn __setitem__(inout self, loc: Int, item: ComplexNum) raises -> None :
        if loc > self.capacity:
            raise("Index out of range")
        if loc > self.len:
            let old_len = self.len
            self.len = loc + 2
            for i in range(old_len, self.len):
                self.ArrPointer.store(i, item.re)
                self.ArrPointer.store(i+1, item.im)
            return
        self.ArrPointer.store(loc, item.re)
        self.ArrPointer.store(loc + 1, item.im)
    
    fn print(inout self) raises -> None:
        for i in range(self.len):
            print(self[i].re, "+", self[i].im, "i")

fn main() raises:
    var myComp = ComplexNum(1.0, 2.0)

    let zero = ComplexNum(0.0, 0.0)
    var myArr = ComplexArray(5, zero)

    myArr[0] = myComp
    myArr.print()