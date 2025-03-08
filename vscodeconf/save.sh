#!/bin/bash

# Hardcoded locations

vscode_settings_config_location="$HOME/.vscode-server/data/Machine/settings.json"
saved_vscode_settings_config_location="./settings.json"


diff \
	--side-by-side \
	--suppress-common-lines \
	--color=always \
	$vscode_settings_config_location \
	$saved_vscode_settings_config_location \
	| less -r


echo "left: Current Vscode Config"
echo "right: Saved Vscode Config" 
