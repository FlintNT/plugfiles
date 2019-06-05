#!/bin/bash
# Nicholas Farrow 2019

crypto_rate () {
    if [ "$1" == "BTC" ]; then ln=2; else ln=1; fi
    echo "$(curl -s rate.sx | grep $1 | sed -n ${ln}p | grep -Eo "[0-9]*\.[0-9]*" | head -1)"
}

nordvpn_status () {
    STATUS=$(nordvpn status)
    CONNSTAT=$(grep "Status:" <<< "$STATUS" | cut -d ' ' -f2)
    COUNTRY=$(grep "City:" <<< "$STATUS" | cut -d ' ' -f2)
    IP=$(grep "IP" <<< "$STATUS" | cut -d ':' -f2)
    echo "$CONNSTAT $COUNTRY$IP"
}


i3status | while :
do
    # Save output of i3status (generic time date space info) to $line
    read line
   
    # Get NordVPN status
    if command -v nordvpn &> /dev/null; then
        NORD=$(nordvpn_status)
    else
	NORD=""
    fi

    BTC=$(crypto_rate "BTC")
    ETH=$(crypto_rate "ETH")
    RATIO=$(bc <<< "scale=5;$ETH/$BTC")

    echo -e "$NORD | ${RED}BTC:$BTC  ETH:$ETH  ETH/BTC:$RATIO |  $line" || exit 1  
done
