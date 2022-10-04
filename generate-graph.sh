#!/usr/bin/env bash

terraform graph -draw-cycles -type=plan \
    | dot -Tsvg -Ecolor=red -Earrowhead=diamond -Kdot >terraform-graph.svg

terraform graph -draw-cycles -type=plan \
    | dot -Tpng -Ecolor=red -Earrowhead=diamond -Kdot >terraform-graph.png

terraform graph -draw-cycles -type=plan \
    | terraform-graph-beautifier \
        --exclude="module.root.provider" \
        --output-type=cyto-html \
        >terraform-graph.html
