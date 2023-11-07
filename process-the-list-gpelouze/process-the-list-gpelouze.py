
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--a', action='store', type=str, required='True', dest='a')

arg_parser.add_argument('--param_y', action='store', type=int, required='True', dest='param_y')

args = arg_parser.parse_args()
print(args)

id = args.id

import json
a = json.loads(args.a.replace('\'','').replace('[','["').replace(']','"]'))

param_y = args.param_y


for elem in a:
    res = elem + '_processed'
    print(res, param_y)

