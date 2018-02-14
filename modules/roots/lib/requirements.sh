#!/bin/bash
#
# WP Requirements Module
# Author: Troy McGinnis
# Company: Gearbox
# Updated: February 13, 2018
#

roots::requirements() {
  local requirements; requirements=(wp composer)

  for i in "${requirements[@]}"; do
    cog::check_requirement "${i}"
  done
}