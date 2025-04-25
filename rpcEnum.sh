#!/bin/bash

# Colors
green_bold_color="\e[0;32m\033[1m"
end_color="\033[0m\e[0m"
red_bold_color="\e[0;31m\033[1m"
blue_bold_color="\e[0;34m\033[1m"
white_bold_color="\e[0;37m\033[1m"
blue_color="\e[0;34m"

# Variables
SERVER_IP=""
USERNAME=""
PASSWORD=""
FUNCTION=""

# Help function
function help_panel() {
    echo -e "\n${green_bold_color}[*]${end_color}${white_bold_color} Usage: $0 -s <SERVER_IP> -u <USER> -p <PASSWORD> -f <FUNCTION>${end_color}"
    echo -e "\n${green_bold_color}-h, --help                  ${end_color}${white_bold_color}Show this help menu${end_color}"
    echo -e "${green_bold_color}-s, --server                ${end_color}${white_bold_color}Server IP address${end_color}"
    echo -e "${green_bold_color}-u, --user                  ${end_color}${white_bold_color}User${end_color}"
    echo -e "${green_bold_color}-p, --password              ${end_color}${white_bold_color}Password${end_color}"
    echo -e "${green_bold_color}-f, --function              ${end_color}${white_bold_color}Function to execute${end_color}"

    echo -e "\n    ${green_bold_color}users                   ${end_color}${white_bold_color}Enumerate users${end_color}"
    echo -e "    ${green_bold_color}querydispinfo           ${end_color}${white_bold_color}Enumerate deployment users' information${end_color}"
    echo -e "    ${green_bold_color}users_info              ${end_color}${white_bold_color}Enumerate users' information${end_color}"
    echo -e "    ${green_bold_color}groups                  ${end_color}${white_bold_color}Enumerate groups${end_color}"
    echo -e "    ${green_bold_color}groups_and_users        ${end_color}${white_bold_color}Enumerate groups and their members${end_color}"
    echo -e "    ${green_bold_color}printers                ${end_color}${white_bold_color}Enumerate printers${end_color}"
    echo -e "    ${green_bold_color}shares                  ${end_color}${white_bold_color}Enumerate SMB shares${end_color}"
    echo -e "    ${green_bold_color}password_policy         ${end_color}${white_bold_color}Enumerate password policy${end_color}"
    echo -e "    ${green_bold_color}server_info             ${end_color}${white_bold_color}Enumerate server information${end_color}"
    echo -e "    ${green_bold_color}full_report             ${end_color}${white_bold_color}Generate full report${end_color}"
}

# Process arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
	-h|--help) help_panel; exit 0 ;;
        -s|--server) SERVER_IP="$2"; shift ;;
        -u|--user) USERNAME="$2"; shift ;;
        -p|--password) PASSWORD="$2"; shift ;;
        -f|--function) FUNCTION="$2"; shift ;;
        *) echo -e "${red_bold_color}Unknown option: $1${end_color}"; help_panel; exit 1 ;;
    esac
    shift
done

# Verify required arguments
if [[ -z "$SERVER_IP" || -z "$FUNCTION" ]]; then
    echo -e "${red_bold_color}Error: Missing required arguments${end_color}"
    help_panel
    exit 1
fi

# Functions
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

    printf "${blue_bold_color}%-${adjustedLengthFirstArray}s %-${adjustedLengthSecondArray}s %-${adjustedLengthThirdArray}s${end_color}\n" \
    "$firstTitle" "$secondTitle" "$thirdTitle"

    printf "${blue_bold_color}%-${adjustedLengthFirstArray}s %-${adjustedLengthSecondArray}s %-${adjustedLengthThirdArray}s${end_color}\n" \
    "$(printf '%*s' "${maxLengthFirstArray}" '' | tr ' ' '-')" \
    "$(printf '%*s' "${maxLengthSecondArray}" '' | tr ' ' '-')" \
    "$(printf '%*s' "${maxLengthThirdArray}" '' | tr ' ' '-')" \

    for ((i = 0; i < ${#firstArray[@]}; i++)); do
        printf "${green_bold_color}%-${adjustedLengthFirstArray}s %-${adjustedLengthSecondArray}s %-${adjustedLengthThirdArray}s${end_color}\n" \
            "${firstArray[i]}" "${secondArray[i]}" "${thirdArray[i]}"
    done
}

function enum_users() {
    echo -e "\n${blue_color}Enumerating users on the server $SERVER_IP...${end_color}"
    local users=()

    while IFS= read -r line; do
        if [[ $line =~ user:\[([^\]]+)\] ]]; then
            users+=("${BASH_REMATCH[1]}")
        fi
    done < <(rpcclient -U "$USERNAME%$PASSWORD" -c "enumdomusers" $SERVER_IP)

    print_content users[@] "USER"
}

function querydispinfo() {
    echo -e "\n${blue_color}Enumerating user information in the deployment on the server $SERVER_IP...${end_color}"
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

    print_content accounts[@] "ACCOUNT" names[@] "NAME" descriptions[@] "DESCRIPTION"
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
        echo -e "\n${blue_color}Getting information for user ${users[$index]} on the server $SERVER_IP...${end_color}"
        local command=$(rpcclient -U "$USERNAME%$PASSWORD" -c "queryuser ${rids[$index]}" $SERVER_IP | sed 's/^[\t]*//')
        echo -e "${green_bold_color}${command}${end_color}"
    done
}

function enum_groups() {
    echo -e "\n${blue_color}Enumerating groups on the server $SERVER_IP...${end_color}"
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

    print_content groups[@] "GROUP" descriptions[@] "DESCRIPTION"
}

function enum_groups_and_users() {
    echo -e "\n${blue_color}Enumerate groups and their members on the server $SERVER_IP...${end_color}"
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
            echo -e "\n${blue_color}Enumerating users of the group ${groups[$x]} on the server $SERVER_IP...${end_color}"
            print_content users[@] "${groups[$x]}"
            users=()
            users_rid=()
        fi
    done
}

function enum_printers() {
    echo -e "\n${blue_color}Enumerating printer members on the server $SERVER_IP...${end_color}"
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

    print_content names[@] "NAME" descriptions[@] "DESCRIPTION" comments[@] "COMMENTS"
}

function enum_shares() {
    echo -e "\n${blue_color}Enumerating shared resources on the server $SERVER_IP...${end_color}"
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

    print_content netnames[@] "NAME" paths[@] "PATH" remarks[@] "DESCRIPTION"
}

function enum_password_policy() {
    echo -e "\n${blue_color}Enumerating password policies on the server $SERVER_IP...${end_color}"
    local command=$(rpcclient -U "$USERNAME%$PASSWORD" -c "getdompwinfo" $SERVER_IP)
    echo -e "${green_bold_color}${command}${end_color}"
}

function enum_server_info() {
    echo -e "\n${blue_color}Enumerating server configuration $SERVER_IP...${end_color}"
    local command=$(rpcclient -U "$USERNAME%$PASSWORD" -c "srvinfo" $SERVER_IP | sed 's/^[\t]*//')
    echo -e "${green_bold_color}${command}${end_color}"
}

function full_report() {
    echo -e "\n${blue_color}Generating full report for the server $SERVER_IP...${end_color}"
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

# Execute the specified function
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
    *) echo -e "${red_bold_color}Función desconocida: $FUNCTION${end_color}"; help_panel; exit 1 ;;
esac
