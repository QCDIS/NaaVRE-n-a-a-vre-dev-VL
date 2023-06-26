
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_a', action='store', type=int, required='True', dest='param_a')
arg_parser.add_argument('--param_b', action='store', type=int, required='True', dest='param_b')

args = arg_parser.parse_args()
print(args)

id = args.id


param_a = args.param_a
param_b = args.param_b


c = param_a * param_b

import json
filename = "/tmp/c_" + id + ".json"
file_c = open(filename, "w")
file_c.write(json.dumps(c))
file_c.close()
