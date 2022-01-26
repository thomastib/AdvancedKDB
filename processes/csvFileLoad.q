//q csvFileLoad.q trade trade.csv

\l libs/log.q

// get command line parameters
tableName:`$.z.x[0];
csvFile:`$.z.x[1];

// Open port to tickerplant or default to self if tp is down
tpHandle: @[hopen; "J"$getenv[`TP_PORT]; {0}];

if[tableName=`trade;
        [trade:("PSFJ"; enlist csv) 0: hsym csvFile;
        @[tpHandle; (`.u.upd; `trade; flip get each trade); {0}]];
    tableName=`quote;
        [quote:("PSFFJJ"; enlist csv) 0: hsym csvFile;
        @[tpHandle; (`.u.upd; `trade; flip get each quote); {0}]];
    .log.error["tickerplant not configured for that table"]];