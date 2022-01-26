// q saveToHDB.q logFile hdbDir
// q saveToHdb.q ${TP_LOG_LOCATION}/schema2022.01.22 data

\l libs/log.q

// get command line parameters
tpLog:hsym `$.z.x[0];
hdbDir:.z.x[1];

// Load the schema from the tickerplant tables
system"l ",getenv[`ADV_KDB_HOME],"/tick/",getenv[`Q_SCHEMA],".q";

// Define the upd function as in the RDB
upd:{[table;data]
    if[table in tables[];
        if[not (type data) in 98 99h;
            f:key flip value table;
            data:$[0>type first data;
                enlist f!data;
                flip f!data
                ];
            ];
        insert[table;data]
        ];
    };

saveTab:{[date;table]
    compressCols:(),cols[table] except `sym`time;
    compressSpecs: compressCols!((17;2;6);(17;2;6));
    .log.out["Saving table", string table];
    (hsym `$hdbDir,"/",string[date],"/",string[table],"/";compressSpecs) set .Q.en[hsym `$hdbDir] table;
    };

// Replay the log
-11!tpLog;

savetab[.z.D] each tables[`.];