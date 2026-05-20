'''
test for the foo function from src/example.py
'''
import pytest
from src.example import foo


@pytest.mark.parametrize('x, y, expected', [
    (1, 2, 3),
    (0, 0, 0),
    (-1, -1, -2),
    (1, -1, 0),
    (1.5, 2.5, 4.0),
    (-1.5, -2.5, -4.0),
    (-1, 1, 0)
])
def test_foo(x: int, y: int, expected: int):
    assert foo(x, y) == expected
