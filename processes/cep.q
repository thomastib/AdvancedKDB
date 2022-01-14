\l libs/log.q

defaultargs:(!) . flip (
    (`serviceType      ; `cep               );
    (`tphostport       ; `$"localhost:",getenv[`TP_PORT])
    );

args:.Q.def[defaultargs] .Q.opt[.z.x];


.u.tphost:hopen `$":",string args[`tphostport];

// Dummy tickerplant update function to call if tickerplant is down
.u.upd: {[x;y]};

upd:{[table;data]
    if[table in tables[];
        if[not (type data) in 98 99h;
            f:key flip value table;
            data:$[0>type first data;
                enlist f!data;
                flip f!data
                ];
            ];
        insert[table;data];
        tradeAgg: select totalVol:sum[price*size], maxPrice: max price, minPrice: min price by sym from trade;
        quoteAgg: select maxBid: max bid, minAsk: min ask, spread:max[bid]-min[ask] by sym from quote;
        aggToB:`time`sym xcols update time:.z.N from 0!tradeAgg lj quoteAgg;
        @[.u.tphost;(`.u.upd; `aggToB; flip get each aggToB); {h::0}]
        ];
    };

.u.savetab:{[date;table]
//    .log.info"Enumerating ",(string table)," against sym file";
//    tab: .Q.en[hsym args[`hdbroot]] 0!value table; //enumerates in-memory table against on-disk sym file
//    dir: ` sv .Q.par[hsym args[`hdbroot];date;table],`; //creates symbol like `:/home/kx/data/segs/seg5/trade/
//    .log.info"Saving data to ",string dir;
//   dir upsert tab; //append data to on-disk segment using upsert 
    .log.out"Flushing data from ",string table;
    table set 0#value table; //flushes out cached data
    if[`sym in cols table;
        .log.out"Applying grouped attribute on sym column to in-memory table: ",string table;
        keyCols:keys table; //table needs to be unkeyed to apply attributes
        @[0!table;`sym;`g#]; //reapplies g# attribute if it is needed
        keyCols xkey table;
    ];
 };


/ end of day: save, clear, hdb reload
.u.end:{[date]
    .u.savetab[date] each tables[`.];
    //   .u.sorttab[date] each tables[`.];
    //   .u.refresh each hsym args[`hdbhostport];
    };

.u.rep:{
    .log.out["Setting up table definitions of tickerplant tables"];
    (.[;();:;].) each x; //initialize schema based on tp returned schema (tablename ; schema)
    .log.out "Replaying log file ", -3! y;
    -11!y[0 1]
    };

.u.rep .(hopen `$":",string args[`tphostport])"(.u.subEx[`;`;`aggToB];`.u `i`L)";