
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--a', action='store', type=int, required='True', dest='a')

arg_parser.add_argument('--param_1', action='store', type=int, required='True', dest='param_1')
arg_parser.add_argument('--param_2', action='store', type=int, required='True', dest='param_2')
arg_parser.add_argument('--param_3', action='store', type=int, required='True', dest='param_3')
arg_parser.add_argument('--param_4', action='store', type=int, required='True', dest='param_4')
arg_parser.add_argument('--param_5', action='store', type=int, required='True', dest='param_5')
arg_parser.add_argument('--param_6', action='store', type=int, required='True', dest='param_6')
arg_parser.add_argument('--param_7', action='store', type=int, required='True', dest='param_7')

args = arg_parser.parse_args()
print(args)

id = args.id

a = args.a

param_1 = args.param_1
param_2 = args.param_2
param_3 = args.param_3
param_4 = args.param_4
param_5 = args.param_5
param_6 = args.param_6
param_7 = args.param_7



b = a + 2

a = 1 + (param_1,param_2,param_3,param_4,param_5,param_6,param_7)

c = b + []

import json
filename = "/tmp/c_" + id + ".json"
file_c = open(filename, "w")
file_c.write(json.dumps(c))
file_c.close()
filename = "/tmp/b_" + id + ".json"
file_b = open(filename, "w")
file_b.write(json.dumps(b))
file_b.close()
