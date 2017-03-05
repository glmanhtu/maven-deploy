#!/usr/bin/env bash

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -jar)
    EXECUTABLE="$2"
    shift # past argument
    ;;
    -e|--environment)
    ENVIRONMENT="$2"
    shift # past argument
    ;;
    start)
    MODE="start"
    ;;
    stop)
    MODE="stop"
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

if [[ -z "$EXECUTABLE" ]]; then
    echo "Executable jar is required"
    exit 1
fi

if [[ -z "$ENVIRONMENT" ]]; then
    echo "Environment need to be set"
    exit 1
fi

if [[ -z "$MODE" ]]; then
    echo "Please provide action start or stop"
    exit 1
fi

if [ ! -f "$EXECUTABLE" ] && [ "$MODE" = "start" ]; then
    echo "Executable file not found!"
    exit 1
fi

FILENAME=`basename ${EXECUTABLE}`
ENV_LOWER=`echo "${ENVIRONMENT}" | tr '[:upper:]' '[:lower:]'`
pidFile="/var/run/$FILENAME.$ENV_LOWER.pid"

if type -p java; then
    _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
    _java="$JAVA_HOME/bin/java"
else
    echo "No java installed yet"
    exit 1
fi

function processExists {
    currentPidFile=$1
    local result="false"
    if [ -f ${currentPidFile} ]; then
        if ps -p `cat ${currentPidFile}` > /dev/null; then
            result="true"
        fi
    fi
    echo ${result}
}

if [ "$MODE" = "stop" ]; then
    pidRunning=`processExists ${pidFile}`
    if [ "$pidRunning" == "true" ]; then
        kill -9 `cat ${pidFile}`
        rm -rf ${pidFile}
    fi
    echo "Stopped"

elif [ "$MODE" = "start" ]; then
    pidRunning=`processExists ${pidFile}`
    if [ ${pidRunning} = "true" ]; then
        echo "Application can't start because it already running"
        exit 1;
    else
        nohup ${_java} -Dspring.profiles.active=${ENVIRONMENT} -jar ${EXECUTABLE} > /dev/null 2>&1 &
        echo $! > ${pidFile}
        echo "Started"
        exit 0;
    fi
fi