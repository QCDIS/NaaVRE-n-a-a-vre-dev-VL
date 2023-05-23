
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--a', action='store', type=str, required='True', dest='a')


args = arg_parser.parse_args()
print(args)

id = args.id

a = args.a



test = [a for i in range(10)]

import json
filename = "/tmp/test_" + id + ".json"
file_test = open(filename, "w")
file_test.write(json.dumps(test))
file_test.close()
