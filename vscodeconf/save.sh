#!/bin/bash

# Hardcoded locations

vscode_settings_config_location="$HOME/.vscode-server/data/Machine/settings.json"
saved_vscode_settings_config_location="./settings.json"


save__current_to_saved() {
	echo "saved current config at $vscode_settings_config_location"
	echo "to $saved_vscode_settings_config_location"
}

replace__current_with_saved() {
	echo "replacing current config at $vscode_settings_config_location"
	echo "with $saved_vscode_settings_config_location"
}


diff \
	--side-by-side \
	--suppress-common-lines \
	--color=always \
	$vscode_settings_config_location \
	$saved_vscode_settings_config_location \
	| less -r


echo "left: Current Vscode Config"
echo "right: Saved Vscode Config" 
printf "type:\n\t'left' for saving current to saved\n\t'right' for overriding current with saved\n"
read input_val

if [ $input_val == "left" ]; then
	save__current_to_saved
elif [ $input_val == "right" ]; then
	replace__current_with_saved
else
	echo "invalid input $input_val...exiting"
fi
