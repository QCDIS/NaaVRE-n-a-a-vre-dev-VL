import os
import shutil

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_working_directory_name', action='store', type=str, required='True', dest='param_working_directory_name')

args = arg_parser.parse_args()
print(args)

id = args.id


param_working_directory_name = args.param_working_directory_name


def get_working_dir(dir_name: str) -> str:
    working_dir = f'/datastore/working_dirs/{dir_name}'
    working_dir = f'/home/jovyan/data/working_dirs/{dir_name}'
    if os.path.exists(working_dir):
        shutil.rmtree(working_dir)
    os.makedirs(working_dir)
    return working_dir

name = param_working_directory_name
working_dir = get_working_dir(name)

print(working_dir)

import json
filename = "/tmp/working_dir_" + id + ".json"
file_working_dir = open(filename, "w")
file_working_dir.write(json.dumps(working_dir))
file_working_dir.close()
