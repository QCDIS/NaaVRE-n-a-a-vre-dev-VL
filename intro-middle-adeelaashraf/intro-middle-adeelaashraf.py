
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--input_param', action='store', type=str, required='True', dest='input_param')


args = arg_parser.parse_args()
print(args)

id = args.id

import json
input_param = json.loads(args.input_param.replace('\'','').replace('[','["').replace(']','"]'))



print(input_param)
output_param = input_param

import json
filename = "/tmp/output_param_" + id + ".json"
file_output_param = open(filename, "w")
file_output_param.write(json.dumps(output_param))
file_output_param.close()
