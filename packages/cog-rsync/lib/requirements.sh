#!/bin/bash
#
# rsync Requirements Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: March 10, 2018
#

rsync::requirements() {
  local requirements
  requirements=(rsync)

  for i in "${requirements[@]}"; do
    cog::check_requirement "${i}"
  done
}
