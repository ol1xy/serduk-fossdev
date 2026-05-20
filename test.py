from script import sum
from script import divide
from script import substruct
def test_sum():
    a = 1
    b = 2
    result = 3
    assert sum(a, b) == result

def test_divide():
    a = 4
    b = 2
    result = 0.5
    assert divide(a, b) == result

def test_divide_prohibited():
    try:
        divide("A", "B")
        assert False
    except ValueError as e:
        print('Test string-division fails')
#def test_divide_zero():
#need to end it

def test_subctruct():
    a = 5
    b = 3
    result = 2
    assert substruct(a, b) == result
    print("Test substruct passed")

if __name__ == '__main__':
    test_divide()
    test_sum()
    test_divide_prohibited()
