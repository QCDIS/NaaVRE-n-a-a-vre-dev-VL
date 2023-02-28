from my_data_generator import DataGenerator

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id






pram_batch_size = 8
pram_input_dim = [8,8,9]
pram_x_train = [1,2,3]

input_dim = pram_input_dim
batch_size = pram_batch_size
x_train = pram_x_train

data = DataGenerator(x_train
                    , input_dim[0]
                    , input_dim[1]
                    , input_dim[2]
                    , indexes_output=[True, True, False, False]
                    , batch_size=batch_size
                    # , path_to_img=run_folders["data_path"]
                    , data_augmentation=True
                    , vae_mode=True
                    , reconstruction=True
                    , softmax=False
                    , hide_and_seek=False
                    , equalization=False
                    )

import json
filename = "/tmp/data_" + id + ".json"
file_data = open(filename, "w")
file_data.write(json.dumps(data))
file_data.close()
