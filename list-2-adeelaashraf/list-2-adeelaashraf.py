
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--list_num', action='store', type=str, required='True', dest='list_num')


args = arg_parser.parse_args()
print(args)

id = args.id

import json
list_num = json.loads(args.list_num.replace('\'','').replace('[','["').replace(']','"]'))



def num_operation(num):
    num += 2
    return num

list_num_2 = [num_operation(i) for i in list_num]

