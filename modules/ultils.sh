#!/data/data/com.termux/files/usr/bin/bash

LOG_FILE=""

init_log() {
    if [ "$SALVAR_LOG" = "true" ]; then
        mkdir -p "$LOG_DIR"
        LOG_FILE="${LOG_DIR}/wifi_$(date +%Y%m%d_%H%M%S).log"
    fi
}

log_it() {
    local msg=$1
    local color=${2:-$C_RESET}
    echo -e "${color}${msg}${C_RESET}"
    [ -n "$LOG_FILE" ] && echo "$(date '+%H:%M:%S') $msg" >> "$LOG_FILE"
}

falar() {
    local msg=$1
    if [ "$FEEDBACK_VOZ" = "true" ]; then
        termux-tts-speak -l "$VOZ_IDIOMA" -r "$VOZ_VELOCIDADE" "$msg" 2>/dev/null &
    fi
}

toast() {
    local msg=$1
    if [ "$FEEDBACK_TOAST" = "true" ]; then
        termux-toast "$msg" 2>/dev/null
    fi
}

feedback() {
    falar "$1"
    toast "$1"
}

check_deps() {
    local missing=()
    command -v termux-wifi-connectioninfo &>/dev/null || missing+=("termux-api")
    command -v termux-wifi-scaninfo &>/dev/null || missing+=("termux-api")
    command -v jq &>/dev/null || missing+=("jq")

    if [ "$FEEDBACK_VOZ" = "true" ] || [ "$FEEDBACK_TOAST" = "true" ]; then
        command -v termux-tts-speak &>/dev/null || missing+=("termux-api(tts)")
        command -v termux-toast &>/dev/null || missing+=("termux-api(toast)")
    fi

    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${C_YELLOW}[!] Dependências faltando: ${missing[*]}${C_RESET}"
        echo -e "${C_YELLOW}[!] Instale: pkg install termux-api jq${C_RESET}"
        echo -e "${C_YELLOW}[!] App Termux:API também é necessário.${C_RESET}"
    fi
}

pause() {
    echo ""
    read -rp "ENTER para continuar..."
}
