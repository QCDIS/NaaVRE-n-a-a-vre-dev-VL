
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--a_list', action='store', type=str, required='True', dest='a_list')


args = arg_parser.parse_args()
print(args)

id = args.id

import json
a_list = json.loads(args.a_list.replace('\'','').replace('[','["').replace(']','"]'))




b_list = []
for elem in a_list:
    b_list.append(elem+'42')

import json
filename = "/tmp/b_list_" + id + ".json"
file_b_list = open(filename, "w")
file_b_list.write(json.dumps(b_list))
file_b_list.close()
