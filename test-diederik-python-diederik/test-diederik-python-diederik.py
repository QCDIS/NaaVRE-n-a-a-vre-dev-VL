
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_a', action='store', type=int, required='True', dest='param_a')

args = arg_parser.parse_args()
print(args)

id = args.id


param_a = args.param_a


b = 5 * param_a * 12

import json
filename = "/tmp/b_" + id + ".json"
file_b = open(filename, "w")
file_b.write(json.dumps(b))
file_b.close()
