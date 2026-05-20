def sum(a, b):
    return a + b

def divide(a, b):
    if b == 0:
        raise ValueError("Denominator couldn't be a zero")
    if isinstance(a, str) or isinstance(b, str):
	    raise ValueError("Divisors couldn't be a string")

    if isinstance(a, list) or isinstance(b, list):
        raise ValueError("Could not divide lists")
    
    return a / b

def substruct(a, b):
    if isinstance(a, str) and isinstance(b, str):
        result = a.replace(b, "")
    else:
        result = a - b
    return result
