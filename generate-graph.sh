#!/usr/bin/env bash

terraform graph -draw-cycles -type=plan \
    | dot -Tsvg -Ecolor=red -Earrowhead=diamond -Kdot \
        >"graph-${PWD##*/}.svg"

terraform graph -draw-cycles -type=plan \
    | dot -Tpng -Ecolor=red -Earrowhead=diamond -Kdot \
        >"graph-${PWD##*/}.png"

terraform graph -draw-cycles -type=plan \
    | terraform-graph-beautifier \
        --exclude="module.root.provider" \
        --output-type=cyto-html \
        >"graph-${PWD##*/}.html"
