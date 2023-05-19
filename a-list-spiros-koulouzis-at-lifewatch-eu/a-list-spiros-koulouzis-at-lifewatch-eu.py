
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





a_list = ['a','b','c','d']

import json
filename = "/tmp/a_list_" + id + ".json"
file_a_list = open(filename, "w")
file_a_list.write(json.dumps(a_list))
file_a_list.close()
