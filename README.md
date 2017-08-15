## Summary
Dockerized version of esniper, a lightweight eBay sniping tool

## Usage
    docker-esniper -u <username> -p <password> -i <item-number,max bid> [-i <item number,max bid>] [-q <quantity to buy>] [-s <time to place bid>]

## Options
    -h  Show usage information.
    -u  Username.
    -p  Password.
    -i  Number of item to bid on with max bid separated by comma. Can be given multiple times. 
    -q  Quantity of items to buy [default: 1].
    -s  Defines when to place bid in seconds before end of auction [default: 10].
