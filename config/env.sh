#Standard Settings for All Processes
export ADV_KDB_HOME=${HOME}/Documents/FD_home/AdvancedKDB
export QHOME=${HOME}/q
export Q_OS=m64
export PROCESS_LOGS=${ADV_KDB_HOME}/logs
export CSV_DIR=${ADV_KDB_HOME}/csv

#Tickerplant Settings
export TP_PORT=7001
export TP_LOG_LOCATION=${ADV_KDB_HOME}/logs/tplog
export Q_SCHEMA=schema
export TP_TIMER=0

#Realtime Database Settings
export RDB_PORT=7002

#Aggregation Realtime Database Settings
export AGG_PORT=7003

#CEP Settings
export CEP_PORT=7005

# Feedhandler Settings
export FEED_PORT=7006

# Websocket Settings
export WEB_PORT=7013