
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--input_param', action='store', type=str, required='True', dest='input_param')


args = arg_parser.parse_args()
print(args)

id = args.id

input_param = args.input_param



print(input_param)

