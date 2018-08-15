#!/bin/bash
#
# TODO: Finish this script so that it can install standard plugins.
#

function exec-wp() {
	source "$(pwd)/env"

	docker stack ps "wp-${CLIENT_NAME}" > /dev/null 2>&1
	if [ $? -eq 0 ];then
	    echo "stack running - executing command"
	else
	    echo "could not find stack wp-${CLIENT_NAME}! Make sure it's running."
	    exit
	fi

	CLI_IMAGE="wordpress:cli-php7.1"

	DATA=$(docker service inspect --pretty  "wp-${CLIENT_NAME}_wordpress")

	NETWORK=$(echo "$DATA" | sed -n 's/Networks:\s\(.*\)/\1/p' | tr -d '[:space:]')
	VOL_SRC=$(echo "$DATA" | sed -n 's/Source\s=\s\(.*\)/\1/p' | tr -d '[:space:]')
	VOL_TRG=$(echo "$DATA" | sed -n 's/Target\s=\s\(.*\)/\1/p' | tr -d '[:space:]')

	echo "container: wp-${CLIENT_NAME}_wordpress"
	echo "network: $NETWORK"
	echo "volume: $VOL_SRC:$VOL_TRG"

	docker run -it --rm \
	--user 33:33 \
	--volume "$VOL_SRC:$VOL_TRG" \
	--network "$NETWORK" \
	$CLI_IMAGE "$@"
}

title="Select installation type"
prompt="Pick an option:"
options=("Base Install" "Base + Storfront + Woocommerce" "Base + Woocommerce")

echo "$title"
PS3="$prompt "
select opt in "${options[@]}" "Quit"; do

    case "$REPLY" in

    1 ) echo "Installing: $opt";;
    2 ) echo "Installing: $opt";;
    3 ) echo "Installing: $opt";;

    $(( ${#options[@]}+1 )) ) echo "Goodbye!"; break;;
    *) echo "Invalid option. Try another one.";continue;;

    esac

done

# while opt=$(zenity --title="$title" --text="$prompt" --list \
#                    --column="Options" "${options[@]}"); do

#     case "$opt" in
#     "${options[0]}" ) zenity --info --text="You picked $opt, option 1";;
#     "${options[1]}" ) zenity --info --text="You picked $opt, option 2";;
#     "${options[2]}" ) zenity --info --text="You picked $opt, option 3";;
#     *) zenity --error --text="Invalid option. Try another one.";;
#     esac

# done