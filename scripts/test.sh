echo ""

tpProc=$(ps -ef | grep -v "grep" | grep tick.q | wc -l)

rdbProc=$(ps -ef | grep -v "grep" | grep rdb.q | wc -l)

aggRdbProc=$(ps -ef | grep -v "grep" | grep aggRdb.q | wc -l)

cepProc=$(ps -ef | grep -v "grep" | grep cep.q | wc -l)

feedProc=$(ps -ef | grep -v "grep" | grep feed.q | wc -l)

if [ $tpProc -eq 1 ]; then
    echo "Tickerplant is RUNNING"
else
    echo "Tickerplant is DOWN"
fi

if [ $rdbProc -eq 1 ]; then
    echo "RDB is RUNNING"
else
    echo "RDB is DOWN"
fi

if [[ $aggRdbProc -eq 1 ]]; then
    echo "Aggregation RDB is RUNNING"
else
    echo "Aggregation RDB is DOWN"
fi

if [ $cepProc -eq 1 ]; then
    echo "CEP is RUNNING"
else
    echo "CEP is DOWN"
fi

if [ $feedProc -eq 1 ]; then
    echo "Feedhandler is RUNNING"
else
    echo "Feedhandler is DOWN"
fi

echo ""