from multiply_data_access import DataAccessComponent

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




data_access_component = DataAccessComponent()

import json
filename = "/tmp/data_access_component_" + id + ".json"
file_data_access_component = open(filename, "w")
file_data_access_component.write(json.dumps(data_access_component))
file_data_access_component.close()
