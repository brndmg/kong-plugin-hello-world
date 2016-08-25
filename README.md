# Hello-World
## An Example Kong Plugin

[![][kong-logo]][kong-url]

## Summary

This example plugin leverages the helpers and kong source for running integration tests without having to be in the kong source tree. You can also use this as a starter for your own Kong plugins.

It assumes that you have a clone of the kong source code since we change to that directory for execution of the tests in the plugin project.  

We also assume that you can already successfully execute the integration tests on the kong source code (`make test-integration`).  Note that this requires both postgres and cassandra to be installed and accessible from your kong instance.  

NOTE: In order to run the `test-plugins` make target you also need redis installed.

If everything is working as it should, you can continue.  

Credit for most of the code in the plugin goes to  [Cédric Tran-Xuan](http://streamdata.io/blog/developing-an-helloworld-kong-plugin/). The [article](http://streamdata.io/blog/developing-an-helloworld-kong-plugin/) is for an older version of Kong, but it is a great starting place.


## Development

## Setup

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

## Useful Links

- [Kong: Plugin Development Guide](https://getkong.org/docs/latest/plugin-development/)
- [Kong: Development](https://github.com/Mashape/kong/blob/master/README.md#development)
- [Luarocks: Kong search](https://luarocks.org/search?q=kong)
- [Luarocks: Best Practices for Makefiles](https://github.com/keplerproject/luarocks/wiki/Recommended-practices-for-Makefiles)
- [Luarocks: Creating a rock](https://github.com/keplerproject/luarocks/wiki/Creating-a-rock)


## Notes

I started with the kong-vagrant project for my development environment.  I installed postgres, and redis, added some items to the path... I might make a PR against that repo...

[kong-url]: https://getkong.org/
[kong-logo]: http://i.imgur.com/4jyQQAZ.png
