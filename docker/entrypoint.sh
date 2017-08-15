#!/bin/bash

usage() {
	cat <<EOF
  Usage:
    docker-esniper -u <username> -p <password> -i <item-number,max bid> [-i <item number,max bid>] [-q <quantity to buy>] [-s <time to place bid>]
  Options:
    -h  Show this screen.
    -u  Username.
    -p  Password.
    -i  Number of item to bid on with max bid separated by comma. Can be given multiple times. 
    -q  Quantity of items to buy [default: 1].
    -s  Defines when to place bid in seconds before end of auction [default: 10].
EOF
}

while getopts ":hu:p:i:s:q:" OPT; do
	case $OPT in
		h)  usage; exit 0;;
		u)  USERNAME=$OPTARG;;
		p)  PASSWORD=$OPTARG;;
    i)  ITEMS+=("${OPTARG}");;
		q)  QUANTITY=$OPTARG;;
		s)  TIME=$OPTARG;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
	  :) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
  esac
done

if [ -z "${USERNAME}" ] || [ -z "${PASSWORD}" ]; then
  usage; exit 1
fi

cat <<EOF > ~/.esniper
username = ${USERNAME}
password = ${PASSWORD}
EOF

[ -z "${QUANTITY}" ] || (echo "quantity = ${QUANTITY}" >> ~/.esniper)
[ -z "${TIME}" ] || (echo "time = ${TIME}" >> ~/.esniper)

[ ! -f ~/auctions.dat ] || rm ~/auctions.dat 
echo > ~/auctions.dat
for ITEM in "${ITEMS[@]}"; do
  NUMBER=$(echo $ITEM | cut -f1 -d,)
  MAXBID=$(echo $ITEM | cut -f2 -d,)
  echo "${NUMBER} ${MAXBID}" >> ~/auctions.dat
done

/usr/local/bin/esniper ~/auctions.dat