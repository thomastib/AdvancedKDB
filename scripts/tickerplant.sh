cd $ADV_KDB_HOME
. ./config/env.sh

CMD="taskset -c q processes/tick.q ${Q_SCHEMA} ${TP_LOG_LOCATION} ${TP_LOG_TIME} ${TP_LOG_MEM}
    -p ${TP_PORT}
    -w ${Q_MAX_MEM}
    -t ${TP_TIMER}
    </dev/null >> ${LOG_FILE} 2>&1 &"

echo $CMD

eval $CMD

ln -Ffs ${LOG_FILE} ${Q_LOG_LOCATION}/tickerplant.log 
