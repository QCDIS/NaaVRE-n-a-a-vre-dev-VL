
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--a', action='store', type=int, required='True', dest='a')

arg_parser.add_argument('--b', action='store', type=int, required='True', dest='b')


args = arg_parser.parse_args()
print(args)

id = args.id

a = args.a
b = args.b



c = a+b

