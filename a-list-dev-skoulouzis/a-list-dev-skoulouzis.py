
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_3', action='store', type=int, required='True', dest='param_3')
arg_parser.add_argument('--param_5', action='store', type=int, required='True', dest='param_5')
arg_parser.add_argument('--param_6', action='store', type=int, required='True', dest='param_6')
arg_parser.add_argument('--param_a', action='store', type=int, required='True', dest='param_a')
arg_parser.add_argument('--param_b', action='store', type=int, required='True', dest='param_b')
arg_parser.add_argument('--param_c', action='store', type=int, required='True', dest='param_c')
arg_parser.add_argument('--param_d', action='store', type=int, required='True', dest='param_d')
arg_parser.add_argument('--param_e', action='store', type=int, required='True', dest='param_e')
arg_parser.add_argument('--param_f', action='store', type=int, required='True', dest='param_f')

args = arg_parser.parse_args()
print(args)

id = args.id


param_3 = args.param_3
param_5 = args.param_5
param_6 = args.param_6
param_a = args.param_a
param_b = args.param_b
param_c = args.param_c
param_d = args.param_d
param_e = args.param_e
param_f = args.param_f



print(param_a)
laz_files = [param_a,param_b,param_c,param_d,param_e,param_f,param_3,param_5,param_6]
print(laz_files)

import json
filename = "/tmp/laz_files_" + id + ".json"
file_laz_files = open(filename, "w")
file_laz_files.write(json.dumps(laz_files))
file_laz_files.close()
