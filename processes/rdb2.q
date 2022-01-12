\l libs/log.q

/q tick/r.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]
/2008.09.09 .k ->.q
if[not "w"=first string .z.o;system "sleep 1"];

defaultargs:(!) . flip (
    (`serviceType      ; `rdb               );
    (`tphostport       ; `$"localhost:7001" );
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
    

///
//saves table to disk and applies attributes as necessary
//@param table symbol representing a table to save down
.u.savetab:{[date;table]
//    .log.info"Enumerating ",(string table)," against sym file";
//    tab: .Q.en[hsym args[`hdbroot]] 0!value table; //enumerates in-memory table against on-disk sym file
//    dir: ` sv .Q.par[hsym args[`hdbroot];date;table],`; //creates symbol like `:/home/kx/data/segs/seg5/trade/
//    .log.info"Saving data to ",string dir;
//   dir upsert tab; //append data to on-disk segment using upsert 
    .log.info"Flushing data from ",string table;
    table set 0#value table; //flushes out cached data
    if[`sym in cols table;
        .log.info"Applying grouped attribute on sym column to in-memory table: ",string table;
        keyCols:keys table; //table needs to be unkeyed to apply attributes
        @[0!table;`sym;`g#]; //reapplies g# attribute if it is needed
        keyCols xkey table;
    ];
 };


///
//tells the specified hostport to reload from it's current directory, signalling a change of data on-disk
//@param hostport symbol of the form `:localhost:7003 or `::7003 or `:unix://7003
.u.refresh:{[hostport]
    .log.info"Refreshing database: ", string hostport;
    handle:@[hopen;hostport;{[x;hp].log.error "Could not establish connection to: ", string[hp]}[hostport]];
    @[handle;(`reload;`);{[x;hp] .log.error "Could not refresh: ",string[hp]}[hostport]];
    hclose handle;
 };

/ end of day: save, clear, hdb reload
.u.end:{[date]
    .u.savetab[date] each tables[`.];
 //   .u.sorttab[date] each tables[`.];
 //   .u.refresh each hsym args[`hdbhostport];
    };

/ init schema and sync up from log file
.u.rep:{
    .log.info "Setting up table definitions of tickerplant tables";
    .log.info .Q.s each x;
    (.[;();:;].) x; //initialize schema based on tp returned schema (tablename ; schema)
    .log.info "Replaying log file ", -3! y;
    -11!y[0 1]
    };

.u.rep .(hopen `$":",string args[`tphostport])"(.u.sub[`aggToB;`];`.u `i`L)";