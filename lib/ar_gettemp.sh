#!/usr/bin/env bash
function ar_gettemp {
  local tmpPrefix=""
  if [[ -n "${AR_MODULE}" ]]; then
      tmpPrefix=".${AR_MODULE}"
  fi
  if [[ -x "$(command -v mktemp)" ]]; then
      printf="$(mktemp -d -t "adryd-dotfiles${tmpPrefix}.XXXXXXXXXX")" 
  else
      for tempDir in "${TMPDIR}" /tmp; do
          if [[ -d "${tempDir}" ]]; then
              printf "${tempDir}"/adryd-dotfiles"${tmpPrefix}"."${RANDOM}"
              break
          fi
      done
  fi
}