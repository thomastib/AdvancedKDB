# Command line options (all, tick, rdb, aggRdb, cep, feed)

#Move to the home folder and run the environment setup script
. ./config/env.sh
cd ${ADV_KDB_HOME}

TICK_START="nohup ${QHOME}/${Q_OS}/q processes/tick.q ${Q_SCHEMA} ${TP_LOG_LOCATION} -p ${TP_PORT} -t ${TP_TIMER} </dev/null >> ${PROCESS_LOGS}/tick.log 2>&1 &"

RDB_START="nohup ${QHOME}/${Q_OS}/q processes/rdb.q -p ${RDB_PORT} </dev/null >> ${PROCESS_LOGS}/rdb.log 2>&1 &"

AGG_RDB_START="nohup ${QHOME}/${Q_OS}/q processes/aggRdb.q -p ${AGG_PORT} </dev/null >> ${PROCESS_LOGS}/aggRdb.log 2>&1 &"

CEP_START="nohup ${QHOME}/${Q_OS}/q processes/rdb.q -p ${CEP_PORT} </dev/null >> ${PROCESS_LOGS}/cep.log 2>&1 &"

FEED_START="nohup ${QHOME}/${Q_OS}/q processes/feed.q -p ${FEED_PORT} </dev/null >> ${PROCESS_LOGS}/feed.log 2>&1 &"

# Command line options (all, tick, rdb, aggRdb, cep, feed)
if [[ "$@[*]" =~ "all" ]]; then  
    echo $TICK_START
    eval $TICK_START
    echo $RDB_START
    eval $RDB_START
    echo $AGG_RDB_START
    eval $AGG_RDB_START
    # echo $CEP_START
    # eval $CEP_START
    echo $FEED_START
    eval $FEED_START
else
    if [[ "$@[*]" =~ "tick" ]]; then
        echo $TICK_START
        eval $TICK_START
    fi
    if [[ "$@[*]" =~ "rdb" ]]; then
        echo $RDB_START
        eval $RDB_START
    fi
    if [[ "$@[*]" =~ "aggRdb" ]]; then
        echo $AGG_RDB_START
        eval $AGG_RDB_START
    fi
    if [[ "$@[*]" =~ "cep" ]]; then
        echo $CEP_START
        eval $CEP_START
    fi
    if [[ "$@[*]" =~ "feed" ]]; then
        echo $FEED_START
        eval $FEED_START
    fi
fi


# echo "Shutting down tickerplant on port ${TP_PORT}"
# TP_STOP="lsof -i :${TP_PORT} | grep LISTEN | awk '{print $2; exit}' | xargs kill -9"