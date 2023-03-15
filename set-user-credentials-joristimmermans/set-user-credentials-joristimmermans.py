from sentinelhub import SHConfig

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_AWS_access_key', action='store', type=str, required='True', dest='param_AWS_access_key')
arg_parser.add_argument('--param_AWS_secret_key', action='store', type=str, required='True', dest='param_AWS_secret_key')

args = arg_parser.parse_args()
print(args)

id = args.id


param_AWS_access_key = args.param_AWS_access_key
param_AWS_secret_key = args.param_AWS_secret_key


config = SHConfig()
config.aws_access_key_id = param_AWS_access_key
config.aws_secret_access_key = param_AWS_secret_key
config.save()

