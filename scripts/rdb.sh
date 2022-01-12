cd $ALARIC_MD_HOME
. ./config/env.sh

LOG_FILE=${Q_LOG_LOCATION}/rdb_$(date +'%Y.%m.%dT%H:%M:%S').log

CMD="taskset -c ${RDB_CPU} ${QHOME}/${Q_OS}/q src/processes/rdb.q 
    -tphostport ${TP_HOST}:${TP_PORT}
    -hdbhostport ${HDB_HOST}:${HDB_PORT}
    -hdbroot ${HDB_ROOT}
    -p ${RDB_PORT}
    -w ${Q_MAX_MEM}
    </dev/null >> ${LOG_FILE} 2>&1 &"

echo $CMD

eval $CMD

ln -Ffs ${LOG_FILE} ${Q_LOG_LOCATION}/rdb.log 
