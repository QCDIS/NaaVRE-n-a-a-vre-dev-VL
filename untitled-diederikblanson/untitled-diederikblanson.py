import numpy as np

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--b', action='store', type=int, required='True', dest='b')

arg_parser.add_argument('--foo', action='store', type=int, required='True', dest='foo')


args = arg_parser.parse_args()
print(args)

id = args.id

b = args.b
foo = args.foo



np.array 

a = b + 1 + foo()

import json
filename = "/tmp/a_" + id + ".json"
file_a = open(filename, "w")
file_a.write(json.dumps(a))
file_a.close()
