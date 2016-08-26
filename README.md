# Hello-World
## An Example Kong Plugin

[![][kong-logo]][kong-url]

## Summary

This example plugin leverages the helpers and kong source for running integration tests without having to be in the kong source tree. You can also use this as a starter for your own Kong plugins.

It assumes that you have a clone of the kong source code since we change to that directory for execution of the tests in the plugin project.  

We also assume that you can already successfully execute the integration tests on the kong source code (`make test-integration`).  

> Running the Kong integration test suite requires both Postgres and Cassandra to be installed and configured to be accessible from your Kong instance according to kong/specs/kong_tests.conf in the Kong source tree. See the [test suite section](https://github.com/Mashape/kong#tests) of the Kong [README](https://github.com/Mashape/kong/blob/master/README.md)

If everything is working as it should, you can get started.  

Credit for most of the code in the plugin goes to  [Cédric Tran-Xuan](http://streamdata.io/blog/developing-an-helloworld-kong-plugin/). The [article](http://streamdata.io/blog/developing-an-helloworld-kong-plugin/) is for an older version of Kong, but it is a good starting point.

## Development

### Setup

Setting up your development environment.

1. Go to [this link](https://github.com/Mashape/kong/blob/master/README.md#development) to setup your Kong development environment.

2. Set the `KONG_PATH` environment variable or update the variable in the [Makefile](./Makefile) to point it to your Kong source dir. (default: /kong)

### Run the plugin test suite

Before you start development on your custom plugin, make sure you can run the full test suite with your current Kong source.

```
$ make test-all
```

You should see something like this.

```
vagrant@precise64:/kong-plugins/kong-plugin-hello-world$ make test-all
[==========] Running tests from scanned files.
[----------] Global test environment setup.
[----------] Running tests from /kong-plugins/kong-plugin-hello-world/spec/01-unit/01-test_spec.lua
[ RUN      ] ...ns/kong-plugin-hello-world/spec/01-unit/01-test_spec.lua @ 37: hello-world plugin when say_hello is true adds the correct header value of Hello World!!!
[       OK ] ...ns/kong-plugin-hello-world/spec/01-unit/01-test_spec.lua @ 37: hello-world plugin when say_hello is true adds the correct header value of Hello World!!! (0.43 ms)
[ RUN      ] ...ns/kong-plugin-hello-world/spec/01-unit/01-test_spec.lua @ 42: hello-world plugin when say_hello is true calls ngx.log
[       OK ] ...ns/kong-plugin-hello-world/spec/01-unit/01-test_spec.lua @ 42: hello-world plugin when say_hello is true calls ngx.log (0.30 ms)
[ RUN      ] ...ns/kong-plugin-hello-world/spec/01-unit/01-test_spec.lua @ 55: hello-world plugin when say_hello is false adds the correct header value of Bye World!!!
[       OK ] ...ns/kong-plugin-hello-world/spec/01-unit/01-test_spec.lua @ 55: hello-world plugin when say_hello is false adds the correct header value of Bye World!!! (0.31 ms)
[ RUN      ] ...ns/kong-plugin-hello-world/spec/01-unit/01-test_spec.lua @ 60: hello-world plugin when say_hello is false calls ngx.log
[       OK ] ...ns/kong-plugin-hello-world/spec/01-unit/01-test_spec.lua @ 60: hello-world plugin when say_hello is false calls ngx.log (0.23 ms)
[----------] 4 tests from /kong-plugins/kong-plugin-hello-world/spec/01-unit/01-test_spec.lua (5.85 ms total)

[----------] Running tests from /kong-plugins/kong-plugin-hello-world/spec/02-integration/01-it-works_spec.lua
[ RUN      ] ...gin-hello-world/spec/02-integration/01-it-works_spec.lua @ 44: Plugin: hello-world (access) Settings registered the plugin globally
[       OK ] ...gin-hello-world/spec/02-integration/01-it-works_spec.lua @ 44: Plugin: hello-world (access) Settings registered the plugin globally (64.67 ms)
[ RUN      ] ...gin-hello-world/spec/02-integration/01-it-works_spec.lua @ 55: Plugin: hello-world (access) Settings registered the plugin for the api
[       OK ] ...gin-hello-world/spec/02-integration/01-it-works_spec.lua @ 55: Plugin: hello-world (access) Settings registered the plugin for the api (5.67 ms)
[ RUN      ] ...gin-hello-world/spec/02-integration/01-it-works_spec.lua @ 67: Plugin: hello-world (access) Response added the header
[       OK ] ...gin-hello-world/spec/02-integration/01-it-works_spec.lua @ 67: Plugin: hello-world (access) Response added the header (675.52 ms)
[----------] 3 tests from /kong-plugins/kong-plugin-hello-world/spec/02-integration/01-it-works_spec.lua (2058.15 ms total)

[----------] Global test environment teardown.
[==========] 7 tests from 2 test files ran. (2065.65 ms total)
[  PASSED  ] 7 tests.
```

## Using Kong with your plugin

### 1. Build your plugin

```bash
$ make install-dev
```

This command installs your plugin locally to a `./lua_modules` directory. The PATH to modules installed in this folder will then be something like:

```bash
/some/path/to/kong-plugin-hello-world/lua_modules/share/lua/5.1/?.lua
```

> Under the hood make is just executing `luarocks` to install the rock locally. It needs to be installed in order to expand it to the directory structure that corresponds to the module names (i.e. kong.plugins.hello-world.handler => kong/plugins/hello-world/)
Go [here](https://github.com/keplerproject/luarocks/wiki/Documentation) for more luarocks information.

Armed with this information we can use it to tell Kong that we want to load a custom_plugin and where to look for it.

### 2. Tell Kong to start with your plugin


- <strong>Option 1</strong>

  Start Kong with your plugin(s) defined in the `KONG_CUSTOM_PLUGINS` [environment variable]((https://getkong.org/docs/0.9.x/configuration/#environment-variables).

  ```bash
  $ KONG_CUSTOM_PLUGINS='hello-world' \
    KONG_LUA_PACKAGE_PATH=/path/to/your/plugin/?.lua \
    bin/kong start -vv
  ```

  > NOTE: If you apply your plugin to any apis or consumers then your plugin must be included in any subsequent startup or Kong with fail to start.

- <strong>Option 2</strong>

  Update the `custom_plugins` and `lua_package_path` items in the Kong [configuration file](https://getkong.org/docs/latest/configuration/).

  ```
  custom_plugins = hello-world

  ...

  lua_package_path = /path/to/your/plugin/?.lua
  ```

> You can use any combination of the two methods above. Please refer to the configuration [documentation](kong-docs-config).


Checkout the Kong [5-minute Quickstart](https://getkong.org/docs/latest/getting-started/quickstart/) for details on how you can start using your plugin with APIs.


## Useful Links

- [Kong: Plugin Development Guide](https://getkong.org/docs/latest/plugin-development/)
- [Kong: Development](https://github.com/Mashape/kong/blob/master/README.md#development)
- [Kong: Test Suite](https://github.com/Mashape/kong#tests)
- [Kong: Configuration](kong-docs-config)
- [Luarocks: Kong search](https://luarocks.org/search?q=kong)
- [Luarocks: Best Practices for Makefiles](https://github.com/keplerproject/luarocks/wiki/Recommended-practices-for-Makefiles)
- [Luarocks: Creating a rock](https://github.com/keplerproject/luarocks/wiki/Creating-a-rock)


## Notes

I started with the kong-vagrant project for my development environment.  I installed postgres 9.4, and redis, added some items to the path... I might make a PR against that repo soon.

[kong-url]: https://getkong.org/
[kong-logo]: http://i.imgur.com/4jyQQAZ.png
[kong-docs-config]: https://getkong.org/docs/latest/configuration/
