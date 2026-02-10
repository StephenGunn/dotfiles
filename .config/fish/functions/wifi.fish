function wifi -d "Simple WiFi manager"
    switch "$argv[1]"
        case list scan
            nmcli device wifi rescan 2>/dev/null
            nmcli device wifi list
        case connect
            if test (count $argv) -lt 2
                echo "Usage: wifi connect <SSID>"
                return 1
            end
            nmcli device wifi connect "$argv[2]"
        case alias rename
            if test (count $argv) -lt 3
                echo "Usage: wifi alias <current-name> <new-name>"
                return 1
            end
            nmcli connection modify "$argv[2]" connection.id "$argv[3]"
            echo "Renamed '$argv[2]' → '$argv[3]'"
        case saved
            nmcli connection show | grep wifi
        case off
            nmcli radio wifi off
            echo "WiFi off"
        case on
            nmcli radio wifi on
            echo "WiFi on"
        case forget
            if test (count $argv) -lt 2
                echo "Usage: wifi forget <name>"
                return 1
            end
            nmcli connection delete "$argv[2]"
        case status ''
            nmcli general status
            echo ""
            nmcli device show wlan0 2>/dev/null | grep -E 'DEVICE|TYPE|STATE|CONNECTION|IP4.ADDRESS'
        case help '*'
            echo "Usage: wifi <command>"
            echo ""
            echo "  list        Scan and list available networks"
            echo "  connect     wifi connect <SSID>"
            echo "  alias       wifi alias <current-name> <friendly-name>"
            echo "  saved       Show saved connections"
            echo "  forget      wifi forget <name>"
            echo "  on/off      Toggle WiFi radio"
            echo "  status      Show current connection (default)"
    end
end
