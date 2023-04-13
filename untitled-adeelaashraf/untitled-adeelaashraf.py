
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




list_num = [i for i in range(0, 1000)]

import json
filename = "/tmp/list_num_" + id + ".json"
file_list_num = open(filename, "w")
file_list_num.write(json.dumps(list_num))
file_list_num.close()
