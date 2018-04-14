from bears.python.PycodestyleBear import PycodestyleBear
from coalib.testing.LocalBearTestHelper import verify_local_bear


good_file = '''
def hello():
    print("hello world")
'''


bad_file = '''
import something



def hello():
    print("hello world")
'''

file_with_very_long_line = ('def ' + 'h' * 1000 + '():\n' +
                            '    print("hello")')

PycodestyleBearTest = verify_local_bear(
    PycodestyleBear,
    valid_files=(good_file,),
    invalid_files=(bad_file,))

PycodestyleBearConfigIgnoreTest = verify_local_bear(
    PycodestyleBear,
    valid_files=(good_file, bad_file),
    invalid_files=[],
    settings={'pycodestyle_ignore': 'E303'})

PycodestyleBearConfigSelectTest = verify_local_bear(
    PycodestyleBear,
    valid_files=(good_file, bad_file),
    invalid_files=[],
    settings={'pycodestyle_select': 'E300'})

long_line = 'a = "{0}"'.format('a' * 100)

PycodestyleBearLineLengthTest = verify_local_bear(
    PycodestyleBear,
    valid_files=(),
    invalid_files=(long_line,)
)

PycodestyleBearLineLengthSettingTest = verify_local_bear(
    PycodestyleBear,
    valid_files=(long_line,),
    invalid_files=(),
    settings={'max_line_length': 200}
)

PycodestyleBearInfiniteLineLengthTest = verify_local_bear(
    PycodestyleBear,
    valid_files=(file_with_very_long_line,),
    invalid_files=(),
    settings={'max_line_length': 0})
