#!/bin/sh

if ! type valgrind >/dev/null; then
  echo "Please install valgrind before running memory leak tests"
  exit 1
fi

curl -o ./test/leak/libvips.supp https://raw.githubusercontent.com/jcupitt/libvips/master/libvips.supp

G_SLICE=always-malloc G_DEBUG=gc-friendly valgrind \
  --suppressions=test/leak/libvips.supp \
  --suppressions=test/leak/sharp.supp \
  --gen-suppressions=yes \
  --leak-check=full \
  --show-leak-kinds=definite,indirect,possible \
  --num-callers=20 \
  --trace-children=yes \
  npm test
