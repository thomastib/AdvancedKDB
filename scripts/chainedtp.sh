cd $ALARIC_MD_HOME
. ./config/env.sh

LOG_FILE=${Q_LOG_LOCATION}/ctp_$(date +'%Y.%m.%dT%H:%M:%S').log

CMD="taskset -c ${CTP_CPU} ${QHOME}/${Q_OS}/q src/processes/ctp.q 
    -tphostport ${TP_HOST}:${TP_PORT}
    -p ${CTP_PORT}
    -w ${Q_MAX_MEM}
    -t ${CTP_TIMER}
    </dev/null >> ${LOG_FILE} 2>&1 &"

echo $CMD

eval $CMD

ln -Ffs ${LOG_FILE} ${Q_LOG_LOCATION}/ctp.log 
