
\l libs/log.q

if[not "w"=first string .z.o;system "sleep 1"];

defaultargs:(!) . flip (
    (`serviceType      ; `websocket               );
    (`tphostport       ; `$"localhost:",getenv[`TP_PORT]);
    (`hdbhostport      ; `$"localhost:7003" )
 );

//read command line parameters
args:.Q.def[defaultargs] .Q.opt[.z.x];

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


/ init schema and sync up from log file
.u.rep:{
    .log.out["Setting up table definitions of tickerplant tables"];
    (.[;();:;].) each x; //initialize schema based on tp returned schema (tablename ; schema)
    .log.out "Replaying log file ", -3! y;
    -11!y[0 1]
    };

.u.rep .(hopen `$":",string args[`tphostport])"(.u.subEx[`;`;`aggToB];`.u `i`L)";

.log.out["Running Websocket init"];

/Create websocket message handler
/Converts kdb+ output to JSON format
.z.ws:{neg[.z.w] .j.j @[{select from trade where sym=x};`$x;{`$ "'",x}]};

/Init websocket connection table
activeWSConnections: ([] handle:(); connectTime:());

/Add and remove connection detail when a new websocket connection is established or dropped

.z.wo:{`activeWSConnections upsert (x;.z.t)};

.z.wc:{delete from `activeWSConnections where handle = x};
