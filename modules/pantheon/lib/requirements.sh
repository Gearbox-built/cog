#!/bin/bash
#
# Pantheon Requirements
# Author: Troy McGinnis
# Company: Gearbox
# Updated: November 19, 2017
#

pantheon::requirements() {
  local requirements; requirements=(terminus)

  for i in "${requirements[@]}"; do
    cog::check_requirement "${i}"
  done
}