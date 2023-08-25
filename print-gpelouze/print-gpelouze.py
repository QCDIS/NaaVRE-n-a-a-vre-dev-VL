
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--my_var', action='store', type=int, required='True', dest='my_var')


args = arg_parser.parse_args()
print(args)

id = args.id

my_var = args.my_var



print(my_var)

