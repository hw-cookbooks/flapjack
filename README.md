# Flapjack Cookbook

This cookbook installs and configure Flapjack, a monitoring notification routing system.
Flapjack gateways and contacts (with notification rules) can be managed.

## Platforms

* Ubuntu >= 12.04
* Centos >= 6.4

## Attributes

`node["flapjack"]["install_method"]`:

Flapjack installation method, `"gem"` or `"package"` (no rpm).

Note: Package install method does not use the package scripts.

`node["flapjack"]["version"]`:

Flapjack version (eg. gem: `"0.8.5"` or package: `"0.8.5+20140209152603-1.ubuntu.12.04"`).

`node["flapjack"]["apt_repo_uri"]`:

Flapjack APT repository URI.

`node["flapjack"]["rest_client"]["version"]`:

Ruby Rest-Client library version (for the API library).

`node["flapjack"]["install_ruby"]`:

Install Ruby when using the `gem` installation method.

`node["flapjack"]["install_redis"]`:

Install Redis.

`node["flapjack"]["user"]`:

User to run Flapjack as, default is `"flapjack"`

`node["flapjack"]["group"]`:

Flapjack user group.

`node["flapjack"]["services"]`:

Flapjack services to run, currently only `["flapjack"]` is supported.

`node["flapjack"]["gateways"]["data_bag"]["name"]`:

Flapjack gateways data bag name.

`node["flapjack"]["contacts"]["data_bag"]["name"]`:

Flapjack contacts data bag name.

`node["flapjack"]["contacts"]["data_bag"]["namespace"]`:

Flapjack contacts data bag item config namespace.
