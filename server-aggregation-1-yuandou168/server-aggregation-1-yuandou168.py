import flwr as fl

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--aggregator_address', action='store', type=int, required='True', dest='aggregator_address')

arg_parser.add_argument('--num_rounds', action='store', type=int, required='True', dest='num_rounds')


args = arg_parser.parse_args()
print(args)

id = args.id

aggregator_address = args.aggregator_address
num_rounds = args.num_rounds




aggregator_address = aggregator_address
num_rounds = num_rounds

def get_on_fit_config_fn():
    """Return a function which returns training configurations."""

    def fit_config(rnd: int):
        """Return a configuration with static batch size and (local) epochs."""
        config = {
            "learning_rate": str(0.001),
            "batch_size": str(32),
        }
        return config

    return fit_config

strategy = fl.server.strategy.FedAvg(
    fraction_fit=1,
    fraction_eval=1,
    min_fit_clients=2,
    min_available_clients=2,
    on_fit_config_fn=get_on_fit_config_fn(),
)
fl.server.start_server(server_address=aggregator_address, config={"num_rounds": num_rounds}, strategy=strategy, grpc_max_message_length=895_870_912)

