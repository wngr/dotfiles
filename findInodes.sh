#!/bin/bash
for i in *; do echo -e "$(find $i | wc -l)\t$i"; done | sort -n
