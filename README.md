# Flapjack Cookbook

This cookbook installs and configure Flapjack, a monitoring notification routing system.
Flapjack gateways and contacts (with notification rules) can be managed.

## Platforms

* Ubuntu >= 12.04
* Centos >= 6.4

## Attributes

`node["flapjack"]["install_method"]` - Flapjack installation method, `"gem"` or `"package"` (no rpm).

Note: Package install method does not use the package scripts.

`node["flapjack"]["version"]` - Flapjack version (eg. gem: `"0.8.5"` or package: `"0.8.5+20140209152603-1.ubuntu.12.04"`).

`node["flapjack"]["apt_repo_uri"]` - Flapjack APT repository URI.

`node["flapjack"]["rest_client"]["version"]` - Ruby Rest-Client library version (for the API library).

`node["flapjack"]["install_ruby"]` - Install Ruby when using the `gem` installation method.

`node["flapjack"]["install_redis"]` - Install Redis.

`node["flapjack"]["user"]` - User to run Flapjack as, the default is `"flapjack"`.

`node["flapjack"]["group"]` - Flapjack user group.

`node["flapjack"]["services"]` - Flapjack services to run, currently only `["flapjack"]` is supported.

`node["flapjack"]["gateways"]["data_bag"]["name"]` - Flapjack gateways data bag name.

`node["flapjack"]["contacts"]["data_bag"]["name"]` - Flapjack contacts data bag name.

`node["flapjack"]["contacts"]["data_bag"]["namespace"]` - Flapjack contacts data bag item config namespace.

`node["flapjack"]["environment"]` - The Flapjack environment, the default is `"production"`.

`node["flapjack"]["config"][*]` - Flapjack configuration options, please refer to https://github.com/flpjck/flapjack/wiki/USING#wiki-configuring-components
for more information.

## Recipes

### default

Installs and configures Flapjack, using the following recipes.

### _config

Manages Flapjack configuration, `/etc/flapjack/flapjack_config.yaml`, by default, this recipe pulls gateways
from the `flapjack_gateways` data bag, which can be changed by `node["flapjack"]["gateways"]["data_bag"]["name"]`.

### _contacts

Manages Flapjack contacts (create & delete), and their notification rules. By default, this recipe
uses the `flapjack_contacts` data bag, however, you may use `node["flapjack"]["contacts"]["data_bag"]["name"]`
and `node["flapjack"]["contacts"]["data_bag"]["namespace"]` to use a different data bag and namespace.
The recipe uses the `flapjack_contact` resource (LWRP).

### _gem

Installs the Flapjack Ruby gem, optionally installing Ruby, using the `ruby_installer` cookbook.

### _package

Installs (extracts) the Flapjack package, currently only supported on ubuntu.

### _redis

Builds and installs Redis, using the `redisio` cookbook.

### _rest_client

Installs the `rest-client` Ruby gem.

### _services

Manages the runit supervised services specified in `node["flapjack"]["services"]`.

### _user

Manages the Flapjack user.
