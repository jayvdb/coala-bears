import sys

def main():
    args = sys.argv[1:]

    bears = set()

    for test in args:
        bear = test.replace('tests/', 'bears/')
        bear = bear[:bear.find('Test')] + '.py'
        bears.add(bear)

    print('--cov=' + ' --cov='.join(bears))


if __name__ == '__main__':
    main()

