#Move to the home folder and run the environment setup script
. ./config/env.sh
cd ${ADV_KDB_HOME}


if [[ "$@[*]" =~ "all" ]]; then 
    echo "Stopping tickerplant"
    lsof -i :${TP_PORT} | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
    echo "Stopping RDB"
    lsof -i :${RDB_PORT} | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
    echo "Stopping Aggregation RDB"
    lsof -i :${AGG_PORT} | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
    # echo "Stopping CEP"
    # lsof -i :${CEP_PORT} | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
    echo "Stopping mock feedhandler"
    lsof -i :${FEED_PORT} | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
else
    if [[ "$@[*]" =~ "tick" ]]; then
        echo "Stopping tickerplant"
        lsof -i :${TP_PORT} | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
    fi
    if [[ "$@[*]" =~ "rdb" ]]; then
        echo "Stopping RDB"
        lsof -i :${RDB_PORT} | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
    fi
    if [[ "$@[*]" =~ "aggRdb" ]]; then
        echo "Stopping Aggregation RDB"
        lsof -i :${AGG_PORT} | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
    fi
    if [[ "$@[*]" =~ "cep" ]]; then
        echo "Stopping CEP"
        lsof -i :${CEP_PORT} | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
    fi
    if [[ "$@[*]" =~ "feed" ]]; then
        echo "Stopping mock feedhandler"
        lsof -i :${FEED_PORT} | grep LISTEN | awk '{print $2; exit}' | xargs kill -9
    fi
fi