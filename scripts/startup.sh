#Move to the home folder and run the environment setup script
cd ${ALARIC_MD_HOME}
. ./config/env.sh

TP_START="taskset -c q processes/tick.q ${Q_SCHEMA} ${TP_LOG_LOCATION} -p ${TP_PORT} -t ${TP_TIMER}
    </dev/null >> ${LOG_FILE} 2>&1 &"

eval $CMD



. ./scripts/tickerplant.sh
. ./scripts/chainedtp.sh
. ./scripts/conflatetp.sh
. ./scripts/rdb.sh
. ./scripts/hdb.sh
. ./scripts/gateway.sh
. ./scripts/orderbook.sh


echo "Shutting down tickerplant on port ${TP_PORT}"
TP_STOP="lsof -i :${TP_PORT} | grep LISTEN | awk '{print $2; exit}' | xargs kill -9"