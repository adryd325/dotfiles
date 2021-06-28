#!/usr/bin/env bash

AR_NODE="node"
[ -e "$AR_DIR/.node/bin/node" ] && AR_NODE="$AR_DIR/.node/bin/node"
[ -e "$(command -v node)" ] && AR_NODE="node"
