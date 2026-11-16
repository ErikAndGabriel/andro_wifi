#!/data/data/com.termux/files/usr/bin/bash

export C_RESET="\e[0m"
export C_RED="\e[1;31m"
export C_GREEN="\e[1;32m"
export C_YELLOW="\e[1;33m"
export C_BLUE="\e[1;34m"
export C_CYAN="\e[1;36m"
export C_WHITE="\e[1;37m"
export C_GRAY="\e[1;30m"

show_banner() {
    clear
    echo -e "${C_CYAN}"
    cat << "EOF"
 ***  *   * ****  ****   ***       *   * *** ***** *** 
*   * **  * *   * *   * *   *      *   *  *  *      *  
***** * * * *   * ****  *   * **** * * *  *  ****   *  
*   * *  ** *   * *  *  *   *      ** **  *  *      *  
*   * *   * ****  *   *  ***       *   * *** *     *** 
EOF
    echo -e "${C_RESET}"
    echo -e "${C_YELLOW}   Wi-Fi Andro — Wifi API${C_RESET}"
    echo -e "${C_GRAY}   v 0${C_RESET}"
    echo ""
}
