# rules_go_cgo_rebuilds

Trying to reproduce rebuilds that we are seeing in a large monorepo;

The action query for a go library target shows up up to 5 entries in the monorepo.
There should only be one.

```
bazel build //... --config=remote

bazel aquery @@gazelle++go_deps+io_opentelemetry_go_otel//:otel --config=remote

```
