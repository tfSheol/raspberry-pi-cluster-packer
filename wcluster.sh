#!/usr/bin/env bash

source ./lib/lib.sh

COMPOSE_PROFILES=aws,tool

compose="docker compose"

if [[ $(command -v docker-compose) != "" ]]; then
  echo -e "-> ${RED}docker-compose v1 detected, please use 'docker compose' commande insted of 'docker-compose'${NC}"
  compose="docker-compose"
  echo -e "$ sudo apt-get install docker-compose-plugin"
fi

if [[ $# == 0 ]]; then
  services=$(${compose} ps --services)
  echo ""
  echo -e "-> ${L_BLUE}Cluster helper for Raspberry PI${NC}"
  echo ""
  echo "$0 <service_name> <options>"
  echo ""
  for service in ${services//$'\n'/' '}; do
    echo -e "${ORANGE}$0 $service <options>${NC}"
  done
  echo ""
  exit 1
fi

${compose} run --rm $@

exit 0