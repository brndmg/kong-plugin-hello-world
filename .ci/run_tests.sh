set -e

export BUSTED_ARGS="-o gtest -v --exclude-tags=ci"
export TEST_CMD="busted $BUSTED_ARGS"

current_user=$(whoami)

if [ "$TEST_SUITE" == "lint" ]; then
  make lint
elif [ "$TEST_SUITE" == "unit" ]; then
  make test
else
  if [ "$current_user" == "vagrant" ]; then
    sudo -H -i -u postgres createuser --createdb kong || true
    sudo -H -i -u postgres createdb -U kong kong_tests || true
  else
    createuser --createdb kong
    createdb -U kong kong_tests
  fi

  if [ "$TEST_SUITE" == "integration" ]; then
    make test-integration
  elif [ "$TEST_SUITE" == "plugins" ]; then
    make test-plugins
  fi
fi
