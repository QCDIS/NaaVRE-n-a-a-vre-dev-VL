
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--b_list', action='store', type=str, required='True', dest='b_list')


args = arg_parser.parse_args()
print(args)

id = args.id

import json
b_list = json.loads(args.b_list.replace('\'','').replace('[','["').replace(']','"]'))




res = ''
for elem in b_list:
    res+=elem
    
print(res)
    

