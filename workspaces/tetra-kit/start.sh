#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?

# TODO: compile phys layer
decoder &
recorder &
(
    cd tetra-kit-player || exit $?
    npm run start
)
