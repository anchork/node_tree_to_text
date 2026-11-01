#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 <version>"
	exit 1
fi

VERSION=$1

# cp LICENSE ./addons/scope_copy/
# cp README.md ./addons/scpe_copy/
sed -i '' "s/version=\".*\"/version=\"$VERSION\"/" ./addons/node_tree_to_text/plugin.cfg
zip -r node_tree_to_text-v$VERSION.zip ./addons/node_tree_to_text -x "*.uid" "*.DS_Store"
