#!/bin/bash

# Запрос к конфиг-серверу для получения порта
CONFIG_SERVER_URL="http://localhost:8888"
APPLICATION_NAME="config-client"
PROFILE="dev"

# Запрос к конфиг-серверу для получения порта
CONFIG_URL="${CONFIG_SERVER_URL}/${APPLICATION_NAME}/${PROFILE}"
PORT=$(curl -s "${CONFIG_URL}" | jq -r '.propertySources[] | select(.name | endswith("-'"${PROFILE}"'.yml")).source["server.port"]')

if [ -z "$PORT" ] || [ "$PORT" == "null" ]; then
  echo "Error: Could not fetch port from config server"
  exit 1
fi

# Устанавливаем переменные окружения для Docker Compose
export CONFIG_CLIENT_PORT=$PORT
export PROFILE=$PROFILE

echo "CONFIG_CLIENT_PORT=$CONFIG_CLIENT_PORT"
echo "PROFILE=$PROFILE"

# Создание временного файла .env
cat <<EOF > .env
CONFIG_CLIENT_PORT=$CONFIG_CLIENT_PORT
PROFILE=$PROFILE
EOF

# Запуск контейнера с динамическим портом
docker compose --env-file .env up -d --build

# Удаление временного файла .env
rm .env
