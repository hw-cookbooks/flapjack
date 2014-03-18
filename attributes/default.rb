default["flapjack"]["install_method"] = "gem" # "package" (no rpm)
default["flapjack"]["version"] = "0.8.5"

default["flapjack"]["apt_repo_uri"] = "http://packages.flapjack.io/deb"

default["flapjack"]["rest_client"]["version"] = "1.6.7"

default["flapjack"]["install_ruby"] = true

default["flapjack"]["install_redis"] = true

default["flapjack"]["user"] = "flapjack"
default["flapjack"]["group"] = "flapjack"

default["flapjack"]["services"] = ["flapjack"]

default["flapjack"]["gateways"]["data_bag"]["name"] = "flapjack_gateways"

default["flapjack"]["contacts"]["data_bag"]["name"] = "flapjack_contacts"
default["flapjack"]["contacts"]["data_bag"]["namespace"] = nil

default["flapjack"]["contacts"]["manage_all_entity"] = false
