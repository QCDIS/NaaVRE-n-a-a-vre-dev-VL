
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--output_param', action='store', type=str, required='True', dest='output_param')


args = arg_parser.parse_args()
print(args)

id = args.id

import json
output_param = json.loads(args.output_param.replace('\'','').replace('[','["').replace(']','"]'))



print(output_param)

