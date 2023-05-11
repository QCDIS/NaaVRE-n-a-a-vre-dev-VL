from webdav3.client import Client
import pathlib
import os
import numpy as np
import laspy

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--laz_files', action='store', type=str, required='True', dest='laz_files')

arg_parser.add_argument('--param_hostname', action='store', type=str, required='True', dest='param_hostname')
arg_parser.add_argument('--param_login', action='store', type=str, required='True', dest='param_login')
arg_parser.add_argument('--param_password', action='store', type=str, required='True', dest='param_password')
arg_parser.add_argument('--param_username', action='store', type=str, required='True', dest='param_username')

args = arg_parser.parse_args()
print(args)

id = args.id

import json
laz_files = json.loads(args.laz_files.replace('\'','').replace('[','["').replace(']','"]'))

param_hostname = args.param_hostname
param_login = args.param_login
param_password = args.param_password
param_username = args.param_username

conf_laz_compression_factor = '7'
conf_remote_path_split = pathlib.Path( '/webdav/LAZ' + '/split_'+param_username)
conf_remote_path_ahn =  '/webdav/LAZ'
conf_max_filesize = '262144000'  # desired max file size (in bytes)
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}

conf_laz_compression_factor = '7'
conf_remote_path_split = pathlib.Path( '/webdav/LAZ' + '/split_'+param_username)
conf_remote_path_ahn =  '/webdav/LAZ'
conf_max_filesize = '262144000'  # desired max file size (in bytes)
conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}


def save_chunk_to_laz_file(in_filename, 
                           out_filename, 
                           offset, 
                           n_points):
    """Read points from a LAS/LAZ file and write them to a new file."""
    
    points = np.array([])
    
    with laspy.open(in_filename) as in_file:
        with laspy.open(out_filename, 
                        mode="w", 
                        header=in_file.header) as out_file:
            in_file.seek(offset)
            points = in_file.read_points(n_points)
            out_file.write_points(points)
    return len(points)

def split_strategy(filename, max_filesize):
    """Set up splitting strategy for a LAS/LAZ file."""
    with laspy.open(filename) as f:
        bytes_per_point = (
            f.header.point_format.num_standard_bytes +
            f.header.point_format.num_extra_bytes
        )
        n_points = f.header.point_count
    n_points_target = int(
        max_filesize * int(conf_laz_compression_factor) / bytes_per_point
    )
    stem, ext = os.path.splitext(filename)
    return [
        (filename, f"{stem}-{n}{ext}", offset, n_points_target)
        for n, offset in enumerate(range(0, n_points, n_points_target))
    ]


client = Client(conf_wd_opts)
client.mkdir(conf_remote_path_split.as_posix())


remote_path_split = conf_remote_path_split


for file in laz_files:
    print('Splitting: '+file )
    client.download_sync(remote_path=os.path.join(conf_remote_path_ahn,file), local_path=file)
    inps = split_strategy(file, int(conf_max_filesize))
    for inp in inps:
        save_chunk_to_laz_file(*inp)
    client.upload_sync(remote_path=os.path.join(conf_remote_path_split,file), local_path=file)

    for f in os.listdir('.'):
        if not f.endswith('.LAZ'):
            continue
        os.remove(os.path.join('.', f))
    
split_laz_files = laz_files

import json
filename = "/tmp/split_laz_files_" + id + ".json"
file_split_laz_files = open(filename, "w")
file_split_laz_files.write(json.dumps(split_laz_files))
file_split_laz_files.close()
