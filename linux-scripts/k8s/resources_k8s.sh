#!/bin/bash

# This script can help you to export all the resources in namespace you choose before
# Enjoy

CYAN='\033[0;36m'
NC='\033[0m'

ns="default"

function pick_namespace(){
    echo "Available namespaces:"
    ns_list=($(kubectl get ns --no-headers -o custom-columns=":metadata.name"))
    for i in "${!ns_list[@]}"; do
        echo "  [$i] ${ns_list[$i]}"
    done

    echo -n "Enter namespace number (default: 0): "
    read ns_choice

    if [[ "$ns_choice" =~ ^[0-9]+$ ]] && [ "$ns_choice" -ge 0 ] && [ "$ns_choice" -lt "${#ns_list[@]}" ]; then
        ns="${ns_list[$ns_choice]}"
    else
        echo "Invalid input, using default (${ns_list[0]})."
        ns="${ns_list[0]}"
    fi

    echo "Selected namespace: $ns"
}

function get_api_resources(){
    echo -e "${CYAN}Available API Versions:${NC}"
    kubectl api-versions
}

function get_resources_ns(){
    kubectl api-resources --verbs=list --namespaced -o name | while read res; do
        count=$(kubectl get "$res" -n ${ns} --no-headers 2>/dev/null | wc -l)
        if [ "$count" -gt 0 ]; then
            echo -e "${CYAN}=== $res ===${NC}"
            kubectl get "$res" -n ${ns}
            echo
        fi
    done
}

function export_resources_yaml(){
    out_dir="${ns}_export"
    mkdir -p "$out_dir"
    echo "Exporting resources to folder: $out_dir"

    kubectl api-resources --verbs=list --namespaced -o name | while read res; do
        items=$(kubectl get "$res" -n ${ns} --no-headers -o name 2>/dev/null)
        if [ -n "$items" ]; then
            for item in $items; do
                safe_item=$(echo "$item" | tr '/' '_')
                echo -e "${CYAN}Exporting $item to $out_dir/${safe_item}.yaml${NC}"
                kubectl get "$item" -n ${ns} -o yaml > "$out_dir/${safe_item}.yaml"
            done
        fi
    done
    echo "Export completed."
}

function show_menu(){
    echo "What do you want to do?"
    echo "  1) Show api-versions"
    echo "  2) Show resources (select namespace)"
    echo "  3) Export resources to YAML (select namespace)"
    echo "  4) Exit"
    echo -n "Enter menu number: "
    read choice

    case $choice in
        1)
            get_api_resources
            ;;
        2)
            pick_namespace
            get_resources_ns
            ;;
        3)
            pick_namespace
            export_resources_yaml
            ;;
        4)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice!"
            ;;
    esac
}

while true; do
    show_menu
    echo
done
