#!/bin/bash

#Colours
green_bold_colour="\e[0;32m\033[1m"
end_colour="\033[0m\e[0m"
red_bold_colour="\e[0;31m\033[1m"
blue_bold_colour="\e[0;34m\033[1m"
white_bold_colour="\e[0;37m\033[1m"
blue_colour="\e[0;34m"

# Variables
SERVER_IP=""
USERNAME=""
PASSWORD=""
FUNCTION=""

# Función de ayuda
function help_panel() {
    echo -e "\n${green_bold_colour}[*]${end_colour}${white_bold_colour} Uso: $0 -s <IP_DEL_SERVIDOR> -u <USUARIO> -p <CONTRASEÑA> -f <FUNCION>${end_colour}"
    echo -e "\n${green_bold_colour}-h, --help                  ${end_colour}${white_bold_colour}Mostrar esta ayuda${end_colour}"
    echo -e "${green_bold_colour}-s, --server                ${end_colour}${white_bold_colour}IP del servidor${end_colour}"
    echo -e "${green_bold_colour}-u, --user                  ${end_colour}${white_bold_colour}Usuario${end_colour}"
    echo -e "${green_bold_colour}-p, --password              ${end_colour}${white_bold_colour}Contraseña${end_colour}"
    echo -e "${green_bold_colour}-f, --function              ${end_colour}${white_bold_colour}Función a ejecutar${end_colour}"

    echo -e "\n    ${green_bold_colour}users                   ${end_colour}${white_bold_colour}Enumerar usuarios${end_colour}"
    echo -e "    ${green_bold_colour}querydispinfo           ${end_colour}${white_bold_colour}Enumerar información sobre usuarios del despliegue${end_colour}"
    echo -e "    ${green_bold_colour}users_info              ${end_colour}${white_bold_colour}Enumerar información de los usuarios${end_colour}"
    echo -e "    ${green_bold_colour}groups                  ${end_colour}${white_bold_colour}Enumerar grupos${end_colour}"
    echo -e "    ${green_bold_colour}groups_and_users        ${end_colour}${white_bold_colour}Enumerar grupos y sus respectivos usuarios${end_colour}"
    echo -e "    ${green_bold_colour}printers                ${end_colour}${white_bold_colour}Enumerar impresoras${end_colour}"
    echo -e "    ${green_bold_colour}shares                  ${end_colour}${white_bold_colour}Enumerar recursos compartidos por smb${end_colour}"
    echo -e "    ${green_bold_colour}password_policy         ${end_colour}${white_bold_colour}Enumerar política de contraseñas${end_colour}"
    echo -e "    ${green_bold_colour}server_info             ${end_colour}${white_bold_colour}Enumerar información del servidor${end_colour}"
    echo -e "    ${green_bold_colour}full_report             ${end_colour}${white_bold_colour}Informe completo${end_colour}"
}

# Procesar argumentos
while [[ "$#" -gt 0 ]]; do
    case $1 in
	-h|--help) help_panel; exit 0 ;;
        -s|--server) SERVER_IP="$2"; shift ;;
        -u|--user) USERNAME="$2"; shift ;;
        -p|--password) PASSWORD="$2"; shift ;;
        -f|--function) FUNCTION="$2"; shift ;;
        *) echo -e "${red_bold_colour}Opción desconocida: $1${end_colour}"; help_panel; exit 1 ;;
    esac
    shift
done

# Verificar si se proporcionaron todos los argumentos necesarios
if [[ -z "$SERVER_IP" || -z "$FUNCTION" ]]; then
    echo -e "${red_bold_colour}Error: faltan argumentos${end_colour}"
    help_panel
    exit 1
fi

# Funciones
function get_max_length() {
    local array=("$@")
    local max_length=$(printf "%s\n" "${array[@]}" | awk '{ print length }' | sort -nr | head -n1)

    echo "$max_length"
}

function check_empty_array() {
    local array=("${!1}")

    for element in "${array[@]}"; do
        if [[ -n "$element" ]]; then
            return 1
        fi
    done

    return 0
}

function print_content() {
    local firstArray=("${!1}")
    local firstTitle="$2"
    local lengthFirstTitle=$(echo -n "$firstTitle" | wc -m)
    local maxLengthFirstArray=$(get_max_length "${firstArray[@]}")
    local adjustedLengthFirstArray=0

    check_empty_array firstArray[@]
    if [[ $? -eq 0 ]]; then
        unset firstTitle
    else

        if [[ $lengthFirstTitle -gt $maxLengthFirstArray ]]; then
            maxLengthFirstArray=$lengthFirstTitle
        else
            adjustedLengthFirstArray=$((maxLengthFirstArray + 5))
        fi
    fi

    local secondArray=("${!3}")
    local secondTitle="$4"
    local lengthSecondTitle=$(echo -n "$secondTitle" | wc -m)
    local maxLengthSecondArray=$(get_max_length "${secondArray[@]}")
    local adjustedLengthSecondArray=0

    check_empty_array secondArray[@]
    if [[ $? -eq 0 ]]; then
        unset secondTitle
    else
        if [[ $lengthSecondTitle -gt $maxLengthSecondArray ]]; then
            maxLengthSecondArray=$lengthSecondTitle
        else
            adjustedLengthSecondArray=$((maxLengthSecondArray + 5))
        fi
    fi

    local thirdArray=("${!5}")
    local thirdTitle="$6"
    local lengthThirdTitle=$(echo -n "$thirdTitle" | wc -m)
    local maxLengthThirdArray=$(get_max_length "${thirdArray[@]}")
    local adjustedLengthThirdArray=0

    check_empty_array thirdArray[@]
    if [[ $? -eq 0 ]]; then
        unset thirdTitle
    else
        if [[ $lengthThirdTitle -gt $maxLengthThirdArray ]]; then
            maxLengthThirdArray=$lengthThirdTitle
        else
            adjustedLengthThirdArray=$((maxLengthThirdArray + 5))
        fi
    fi

    printf "${blue_bold_colour}%-${adjustedLengthFirstArray}s %-${adjustedLengthSecondArray}s %-${adjustedLengthThirdArray}s${end_colour}\n" \
    "$firstTitle" "$secondTitle" "$thirdTitle"

    printf "${blue_bold_colour}%-${adjustedLengthFirstArray}s %-${adjustedLengthSecondArray}s %-${adjustedLengthThirdArray}s${end_colour}\n" \
    "$(printf '%*s' "${maxLengthFirstArray}" '' | tr ' ' '-')" \
    "$(printf '%*s' "${maxLengthSecondArray}" '' | tr ' ' '-')" \
    "$(printf '%*s' "${maxLengthThirdArray}" '' | tr ' ' '-')" \

    for ((i = 0; i < ${#firstArray[@]}; i++)); do
        printf "${green_bold_colour}%-${adjustedLengthFirstArray}s %-${adjustedLengthSecondArray}s %-${adjustedLengthThirdArray}s${end_colour}\n" \
            "${firstArray[i]}" "${secondArray[i]}" "${thirdArray[i]}"
    done
}

function enum_users() {
    echo -e "\n${blue_colour}Enumerando usuarios en el servidor $SERVER_IP...${end_colour}"
    local users=()

    while IFS= read -r line; do
        if [[ $line =~ user:\[([^\]]+)\] ]]; then
            users+=("${BASH_REMATCH[1]}")
        fi
    done < <(rpcclient -U "$USERNAME%$PASSWORD" -c "enumdomusers" $SERVER_IP)

    print_content users[@] "USUARIO"
}

function querydispinfo() {
    echo -e "\n${blue_colour}Enumerando información sobre los usuarios en el despliegue en el servidor $SERVER_IP...${end_colour}"
    local accounts=()
    local names=()
    local descriptions=()

    while IFS= read -r line; do
        line=$(echo "$line" | awk -F 'Account: |Name: |Desc: ' '{print $2 "\t" $3 "\t" $4}')

        if [[ -n $line ]]; then
            IFS=$'\t' read -r account name description <<< "$line"

            accounts+=("$account")
            names+=("$name")
            descriptions+=("$description")
        fi
    done < <(rpcclient -U "$USERNAME%$PASSWORD" -c "querydispinfo" $SERVER_IP)

    print_content accounts[@] "CUENTA" names[@] "NOMBRE" descriptions[@] "DESCRIPCIÓN"
}

function enum_users_info() {
    local rids=()
    local users=()

    while IFS= read -r line; do
        if [[ $line =~ user:\[([^\]]+)\]\ rid:\[([^\]]+)\] ]]; then
            users+=("${BASH_REMATCH[1]}")
            rids+=("${BASH_REMATCH[2]}")
        fi
    done < <(rpcclient -U "$USERNAME%$PASSWORD" -c "enumdomusers" $SERVER_IP)

    for ((index=0; index<${#rids[@]}; index++)); do
        echo -e "\n${blue_colour}Obteniendo información del usuario ${users[$index]} en el servidor $SERVER_IP...${end_colour}"
        local command=$(rpcclient -U "$USERNAME%$PASSWORD" -c "queryuser ${rids[$index]}" $SERVER_IP | sed 's/^[\t]*//')
        echo -e "${green_bold_colour}${command}${end_colour}"
    done
}

function enum_groups() {
    echo -e "\n${blue_colour}Enumerando grupos en el servidor $SERVER_IP...${end_colour}"
    local groups=()
    local rids=()
    local descriptions=()

    while IFS= read -r line; do
        if [[ $line =~ group:\[([^\]]+)\]\ rid:\[([^\]]+)\] ]]; then
            groups+=("${BASH_REMATCH[1]}")
            rids+=("${BASH_REMATCH[2]}")
        fi
    done < <(rpcclient -U "$USERNAME%$PASSWORD" -c "enumdomgroups" $SERVER_IP)

    for rid in "${rids[@]}"; do
        while IFS= read -r line; do
            line=$(echo "$line" | grep "Description" | awk '{print $2}' FS=":" | tr -d '\t')

            if [[ -n $line ]]; then
                descriptions+=("$line")
            fi
        done < <(rpcclient -U "$USERNAME%$PASSWORD" -c "querygroup $rid" $SERVER_IP)
    done

    print_content groups[@] "GRUPO" descriptions[@] "DESCRIPCIÓN"
}

function enum_groups_and_users() {
    echo -e "\n${blue_colour}Enumerando grupos y sus usuarios en el servidor $SERVER_IP...${end_colour}"
    local users=()
    local users_rid=()
    local groups=()
    local groups_rid=()

    while IFS= read -r line; do
        if [[ $line =~ group:\[([^\]]+)\]\ rid:\[([^\]]+)\] ]]; then
            groups+=("${BASH_REMATCH[1]}")
            groups_rid+=("${BASH_REMATCH[2]}")
        fi
    done < <(rpcclient -U "$USERNAME%$PASSWORD" -c "enumdomgroups" "$SERVER_IP")

    for ((x=0; x<${#groups_rid[@]}; x++)); do
        while IFS= read -r line; do
            if [[ $line =~ rid:\[([^\]]+)\] ]]; then
                users_rid+=("${BASH_REMATCH[1]}")
            fi
        done < <(rpcclient -U "$USERNAME%$PASSWORD" -c "querygroupmem ${groups_rid[$x]}" "$SERVER_IP")

        for ((y=0; y<${#users_rid[@]}; y++)); do
            while IFS= read -r line; do
                line=$(echo "$line" | grep "User Name" | awk '{print $2}' FS=":" | tr -d '\t')

                if [[ -n $line ]]; then
                    users+=("$line")
                fi
            done < <(rpcclient -U "$USERNAME%$PASSWORD" -c "queryuser ${users_rid[$y]}" $SERVER_IP)
        done

        if [ ${#users[@]} -ne 0 ]; then
            echo -e "\n${blue_colour}Enumerando usuarios del grupo ${groups[$x]} en el servidor $SERVER_IP...${end_colour}"
            print_content users[@] "${groups[$x]}"
            users=()
            users_rid=()
        fi
    done
}

function enum_printers() {
    echo -e "\n${blue_colour}Enumerando miembros de impresoras en el servidor $SERVER_IP...${end_colour}"
    local names=()
    local descriptions=()
    local comments=()

    while IFS= read -r line; do
        if [[ $line =~ name:\[\s*([^\]]+?)\s*\] ]]; then
            names+=("${BASH_REMATCH[1]}")

        elif [[ $line =~ description:\[\s*([^\]]+?)\s*\] ]]; then
            descriptions+=("${BASH_REMATCH[1]}")

        elif [[ $line =~ comment:\[\s*([^\]]+?)\s*\] ]]; then
            comments+=("${BASH_REMATCH[1]}")
        fi
    done < <(rpcclient -U "$USERNAME%$PASSWORD" -c "enumprinters" $SERVER_IP)

    print_content names[@] "NOMBRE" descriptions[@] "DESCRIPCIÓN" comments[@] "COMENTARIOS"
}

function enum_shares() {
    echo -e "\n${blue_colour}Enumerando recursos compartidos en el servidor $SERVER_IP...${end_colour}"
    local netnames=()
    local remarks=()
    local paths=()

    while IFS= read -r line; do
         line=$(echo "$line" | tr -d '\t' | sed 's/\(netname\|remark\|path\|password\): /\1:/g' | sed 's/^[[:space:]]\+//' | sed 's/[[:space:]]\+$//')

        if [[ $line =~ netname:\s*(.*) ]]; then
            netnames+=("${BASH_REMATCH[1]}")

        elif [[ $line =~ remark:\s*(.*) ]]; then
            remarks+=("${BASH_REMATCH[1]}")

        elif [[ $line =~ path:\s*(.*) ]]; then
            paths+=("${BASH_REMATCH[1]}")
        fi

    done < <(rpcclient -U "$USERNAME%$PASSWORD" -c "netshareenumall" $SERVER_IP)

    print_content netnames[@] "NOMBRE" paths[@] "RUTA" remarks[@] "DESCRIPCIÓN"
}

function enum_password_policy() {
    echo -e "\n${blue_colour}Enumerando políticas de contraseña en el servidor $SERVER_IP...${end_colour}"
    local command=$(rpcclient -U "$USERNAME%$PASSWORD" -c "getdompwinfo" $SERVER_IP)
    echo -e "${green_bold_colour}${command}${end_colour}"
}

function enum_server_info() {
    echo -e "\n${blue_colour}Enumerando configuración del servidor $SERVER_IP...${end_colour}"
    local command=$(rpcclient -U "$USERNAME%$PASSWORD" -c "srvinfo" $SERVER_IP | sed 's/^[\t]*//')
    echo -e "${green_bold_colour}${command}${end_colour}"
}

function full_report() {
    echo -e "\n${blue_colour}Generando informe completo para el servidor $SERVER_IP...${end_colour}"
    enum_users
    querydispinfo
    enum_users_info
    enum_groups
    enum_groups_and_users
    enum_printers
    enum_shares
    enum_password_policy
    enum_server_info
}

# Ejecutar la función especificada
case $FUNCTION in
    users) enum_users ;;
    querydispinfo) querydispinfo ;;
    users_info) enum_users_info ;;
    groups) enum_groups ;;
    groups_and_users) enum_groups_and_users ;;
    printers) enum_printers ;;
    shares) enum_shares ;;
    password_policy) enum_password_policy ;;
    server_info) enum_server_info ;;
    full_report) full_report ;;
    *) echo -e "${red_bold_colour}Función desconocida: $FUNCTION${end_colour}"; help_panel; exit 1 ;;
esac
