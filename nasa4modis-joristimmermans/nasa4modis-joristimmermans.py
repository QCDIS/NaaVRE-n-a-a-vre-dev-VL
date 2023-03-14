
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_NASA_user', action='store', type=str, required='True', dest='param_NASA_user')

args = arg_parser.parse_args()
print(args)

id = args.id


param_NASA_user = args.param_NASA_user




