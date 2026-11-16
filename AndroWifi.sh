#!/data/data/com.termux/files/usr/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

CONFIG_FILE="./config/config.sh"
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE" || {
    echo "[!] Config não encontrada: $CONFIG_FILE"
    exit 1
}

source ./modules/banner.sh
source ./modules/utils.sh
source ./modules/wifi.sh

init_log
check_deps

usage() {
    show_banner
    echo -e "${C_WHITE}Uso:${C_RESET} ./ferramentas.sh [OPÇÃO]"
    echo ""
    echo -e "${C_WHITE}Opções:${C_RESET}"
    echo "  --wifi, --info    Informações da conexão atual"
    echo "  --scan            Escanear redes próximas"
    echo "  --config          Editar configuração"
    echo "  --help            Esta ajuda"
    echo ""
    echo -e "${C_GRAY}Config: ./config/config.sh${C_RESET}"
}

case "$1" in
    --wifi|--info)
        wifi_info
        ;;
    --scan)
        wifi_scan
        ;;
    --config)
        ${EDITOR:-nano} "$CONFIG_FILE"
        ;;
    --help|-h|"")
        usage
        ;;
    *)
        echo -e "${C_RED}Opção inválida: $1${C_RESET}"
        usage
        exit 1
        ;;
esac
