
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




my_var = 1

import json
filename = "/tmp/my_var_" + id + ".json"
file_my_var = open(filename, "w")
file_my_var.write(json.dumps(my_var))
file_my_var.close()
