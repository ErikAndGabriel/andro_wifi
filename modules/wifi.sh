#!/data/data/com.termux/files/usr/bin/bash

wifi_info() {
    show_banner
    echo -e "${C_BLUE}[+] Conexão Wi-Fi Atual${C_RESET}\n"

    feedback "Obtendo informações da conexão"

    local json
    json=$(termux-wifi-connectioninfo 2>/dev/null)

    if [ -z "$json" ] || [ "$json" = "null" ]; then
        log_it "[X] Sem dados. Ative Wi-Fi e localização." "$C_RED"
        feedback "Falha ao obter dados"
        return 1
    fi

    if command -v jq &>/dev/null; then
        local ssid bssid ip freq rssi link
        ssid=$(echo "$json" | jq -r '.ssid // "N/A"')
        bssid=$(echo "$json" | jq -r '.bssid // "N/A"')
        ip=$(echo "$json" | jq -r '.ip // "N/A"')
        freq=$(echo "$json" | jq -r '.frequency_mhz // .frequency // "N/A"')
        rssi=$(echo "$json" | jq -r '.rssi // "N/A"')
        link=$(echo "$json" | jq -r '.link_speed_mbps // "N/A"')
        mac=$(echo "$json" | jq -r '.mac_address // "N/A"')
        network_id=$(echo "$json" | jq -r '.network_id // "N/A"')
        hidden=$(echo "$json" | jq -r '.ssid_hidden // "N/A"')
        supplicant=$(echo "$json" | jq -r '.supplicant_state // "N/A"')
        
        log_it "  SSID       : $ssid"          "$C_WHITE"
        log_it "  BSSID      : $bssid"         "$C_WHITE"
        log_it "  IP Local   : $ip"            "$C_WHITE"
        log_it "  Frequência : ${freq} MHz"    "$C_WHITE"
        log_it "  RSSI       : ${rssi} dBm"    "$C_WHITE"
        log_it "  Link Speed : ${link} Mbps"   "$C_WHITE"
        log_it "  MAC Address     : $mac" "$C_WHITE"
        log_it "  Network ID      : $network_id" "$C_WHITE"
        log_it "  SSID Hidden     : $hidden" "$C_WHITE"
        log_it "  Supplicant State: $supplicant" "$C_WHITE"
  
        feedback "Conectado a $ssid"
    else
        log_it "  $json" "$C_WHITE"
    fi

    [ -n "$LOG_FILE" ] && log_it "[i] Log: $LOG_FILE" "$C_GRAY"
}

wifi_scan() {
    show_banner
    echo -e "${C_BLUE}[+] Escaneando Redes Wi-Fi${C_RESET}\n"

    feedback "Iniciando escaneamento"

    local json
    json=$(timeout "$SCAN_TIMEOUT" termux-wifi-scaninfo 2>/dev/null)

    if [ -z "$json" ] || [ "$json" = "[]" ]; then
        log_it "[X] Nenhuma rede. Verifique permissões." "$C_RED"
        feedback "Nenhuma rede encontrada"
        return 1
    fi

    local count
    count=$(echo "$json" | jq 'length' 2>/dev/null || echo "?")

    feedback "Encontradas $count redes"

    if command -v jq &>/dev/null; then
        printf "${C_GRAY}%-32s %-18s %-8s %-6s${C_RESET}\n" "SSID" "BSSID" "FREQ(MHz)" "RSSI"
        printf "${C_GRAY}%s${C_RESET}\n" "$(printf '%.0s-' {1..70})"

        local limit="$MAX_REDES"
        [ "$limit" = "0" ] && limit=999

        echo "$json" | jq -r '.[] | "\(.ssid // "(oculto)")\t\(.bssid)\t\(.frequency // .frequency_mhz // 0)\t\(.rssi // 0)"' | \
        head -n "$limit" | \
        while IFS=$'\t' read -r s b f r; do
            log_it "$(printf "%-32s %-18s %-8s %-6s" "$s" "$b" "$f" "$r")" "$C_WHITE"
        done
    else
        [ -n "$LOG_FILE" ] && echo "$json" >> "$LOG_FILE"
        log_it "[i] jq ausente, JSON bruto salvo no log." "$C_YELLOW"
    fi

    [ -n "$LOG_FILE" ] && log_it "[i] Log: $LOG_FILE" "$C_GRAY"
}
