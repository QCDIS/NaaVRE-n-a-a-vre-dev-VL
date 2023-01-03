from webdav3.client import Client
from laserfarm.remote_utils import get_wdclient
from laserfarm import Retiler
import os
from laserfarm.remote_utils import list_remote
import pathlib
import laspy
import numpy as np

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id






                    
                    

if 'JUPYTERHUB_USER' in os.environ:
    param_username = os.environ['JUPYTERHUB_USER']
    
conf_remote_path_root = '/webdav/LAZ'
conf_remote_path_split = pathlib.Path(conf_remote_path_root + '/split_'+param_username)
conf_remote_path_retiled = pathlib.Path(conf_remote_path_root + '/retiled_'+param_username)
conf_remote_path_norm = pathlib.Path(conf_remote_path_root + '/norm_'+param_username)
conf_remote_path_targets = pathlib.Path(conf_remote_path_root + '/targets_'+param_username)
conf_local_tmp = pathlib.Path('/tmp')
conf_remote_path_ahn = conf_remote_path_root



conf_feature_name = 'perc_95_normalized_height'
conf_validate_precision = '0.001'
conf_tile_mesh_size = '10.'
conf_filter_type= 'select_equal'
conf_attribute = 'raw_classification'
conf_min_x = '-113107.81'
conf_max_x = '398892.19'
conf_min_y = '214783.87'
conf_max_y = '726783.87'
conf_n_tiles_side = '512'
conf_apply_filter_value = '1'
conf_laz_compression_factor = '7'
conf_max_filesize = '262144000'  # desired max file size (in bytes)

conf_wd_opts = { 'webdav_hostname': param_hostname, 'webdav_login': param_login, 'webdav_password': param_password}
print(conf_remote_path_ahn)
laz_files = [f for f in list_remote(get_wdclient(conf_wd_opts), pathlib.Path(conf_remote_path_ahn).as_posix())
             if f.lower().endswith('.laz')]
print(laz_files)


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
split_laz_files
remote_path_retiled = str(conf_remote_path_retiled)

grid_retile = {
    'min_x': float(conf_min_x),
    'max_x': float(conf_max_x),
    'min_y': float(conf_min_y),
    'max_y': float(conf_max_y),
    'n_tiles_side': int(conf_n_tiles_side)
}

retiling_input = {
    'setup_local_fs': {'tmp_folder': conf_local_tmp.as_posix()},
    'pullremote': conf_remote_path_split.as_posix(),
    'set_grid': grid_retile,
    'split_and_redistribute': {},
    'validate': {},
    'pushremote': conf_remote_path_retiled.as_posix(),
    'cleanlocalfs': {}
}

for file in split_laz_files:
    retiler = Retiler(file.replace('"',''),label=file).config(retiling_input).setup_webdav_client(conf_wd_opts)
    retiler_output = retiler.run()
print(retiler_output)

