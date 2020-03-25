#!/bin/bash

DELIMIT="|"

internet_indicator()
{
    ETHERNET_INTERFACE="enp1s0"
    WIFI_INTERFACE="wlp2s0"

    ## Ping google if successful continue echo `No internet` and exit
    if [ "$(ping -c 1 8.8.8.8 | grep '100% packet loss' )" != "" ]
    then
        echo -n "No Internet "
        exit 0
    fi

    if [ -e "/sys/class/net/${ETHERNET_INTERFACE}/operstate" ] && [ "`cat /sys/class/net/${ETHERNET_INTERFACE}/operstate`" = "up" ]
    then
        echo -n "Ethernet : "
        exit 0
    fi

    if [ -e "/sys/class/net/${WIFI_INTERFACE}/operstate" ] && [ "`cat /sys/class/net/${WIFI_INTERFACE}/operstate`" = "up" ]
    then
        echo -n "Wifi : "
        exit 0
    fi
}

brightness_indicator()
{
    echo -e " $(/usr/share/i3blocks/./brightness)"
}

volume_indicator()
{
    ## Volume indicator ##
    #
    # The first parameter sets the step (and units to display)
    # The second parameter overrides the mixer selection
    # See the script for details.
    echo -n "♪ $(/usr/share/i3blocks/volume 1 pulse)"
}

battery_indicator()
{
    ACPI=$(acpi)
    # echo -n $ACPI | awk -F " " '{print $5}' | awk -F "," '{print $1}' ## ECHO BATTERY TIME ##
    echo -n $ACPI | awk -F " " '{print $4}' | awk -F "," '{print $1}' ## ECHO BATTERY PERCENTAGE ##
    echo -n $ACPI | awk -F " " '{print $3}' | awk -F "," '{print $1}' ## ECHO BATTERY STATE, i.e, 'Charging' or 'Discharging' ##
}

date_indicator()
{
    DATE=$(date '+%d/%m %A %l:%M %p')
    echo -n $DATE
}

status()
{
    echo -n "$DELIMIT"

    echo -n " $(brightness_indicator) "

    echo -n "$DELIMIT"

    echo -n " $(volume_indicator) "

    echo -n "$DELIMIT"

    echo -n " $(internet_indicator) "

    echo -n "$DELIMIT"

    echo -n " $(battery_indicator) "

    echo -n "$DELIMIT"

    echo -n " $(date_indicator) "

    echo -n "$DELIMIT"
}

while true; do
    xsetroot -name "$(status | tr '\n' ' ')"
	sleep 1m
done
