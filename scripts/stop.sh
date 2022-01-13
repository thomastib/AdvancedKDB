#Move to the home folder and run the environment setup script
cd ${ALARIC_MD_HOME}
. ./config/env.sh

echo "Shutting down tickerplant on port ${TP_PORT}"
lsof -i :$TP_PORT | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
echo "Shutting down chained-tickerplant on port ${CTP_PORT}"
lsof -i :$CTP_PORT | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
echo "Shutting down conflated-chained-tickerplant on port ${CFTP_PORT}"
lsof -i :$CFTP_PORT | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
echo "Shutting down rdb on port ${RDB_PORT}"
lsof -i :$RDB_PORT | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
echo "Shutting down hdb on port ${HDB_PORT}"
lsof -i :$HDB_PORT | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
echo "Shutting down gateway on port(s) ${GW_PORT}"
lsof -i :$GW_PORT | grep LISTEN | awk '{print $2}' | xargs kill -9
echo "Shutting down orderbook NSDQ on port(s) ${OB_NSDQ_PORT}"
lsof -i :$OB_NSDQ_PORT | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
echo "Shutting down orderbook NYSE EDGE on port(s) ${OB_NYSE_EDGE_PORT}"
lsof -i :$OB_NYSE_EDGE_PORT | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
echo "Shutting down orderbook ARCA AMEX on port(s) ${OB_ARCA_AMEX_PORT}"
lsof -i :$OB_ARCA_AMEX_PORT | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
echo "Shutting down orderbook BATS BATSY on port(s) ${OB_BATS_BATSY_PORT}"
lsof -i :$OB_BATS_BATSY_PORT | grep LISTEN | awk '{print $2; exit}' | xargs kill -9

