/ q tick.q sym . -p 7001 </dev/null >foo 2>&1 &
"KDB+ 4.0 2021.07.12"

defaultargs:(!) . flip (
	(`serviceType     ; `tp        );
	(`qschema         ; `$.z.x[0]  );
	(`tploglocation   ; `$.z.x[1]  )
    );

//read command line parameters 
args:.Q.def[defaultargs] .Q.opt[.z.x];

//load in u.q
\l tick/u.q

//load other libs
\l libs/log.q

// define schema with first command line parameter
//q tick.q SRC [DST] [-p 7001] [-o h]
system"l tick/",(src:first .z.x),".q"

//define default listening port if not specified on startup
if[not system"p";
    .log.info["Setting port to 7001"];
    system"p 7001"];

//move to .u namespace
\d .u

//Define load function. Input is current date.
//	Sets log output file for the day and initializes it
//	Counts items in log file, throws error if it is corrupted
//	Opens handle to log file
ld:{
    if[not type key L::`$(-10_string L),string x;
		.[L;();:;()]];
	i::j::-11!(-2;L);
	if[0<=type i;
		.log.error[(string L)," is a corrupt log. Truncate to length ",(string last i)," and restart"];
		exit 1];
	.log.info["Opening handle to ",string L];
    hopen L};

//Define tick function. Input args are source schema file and destination log folder 
//	Initializes tables, places group attribute on sym column 
//	Opens handle to log files
tick:{
	init[];
	@[;`sym;`g#]each t;
	schema::x;
	logpath::y;
	d::.z.D;
	if[l::count y;
		L::`$":",y,"/",x,10#".";
		l::ld d];
    };

//Define end-of-day function. Takes no arguments
//	Runs end functionality, increases daycount, closes handle to log file
endofday:{
	.log.info["Running end of day function."]
    end d;
	d+:1;
	if[l;hclose l;
		l::0(`.u.ld;d)]};
		
// Timer function that checks if eod has occurred, checks if intraday log roll is needed, and sends metrics
ts:{
	if[d<x;
		if[d<x-1;
			system"t 0";
			.log.error["More than one day?"]];
		endofday[]];
	};

//Batching mode, which publishes periodically rather than after every call to upd
//    upd:{[t;x]
//        if[not -16=type first first x; // not sure I need this if the incoming data is timestamped
//            if[d<"d"$a:.z.P;
//                .z.ts[]];
//            a:"n"$a;
//            x:$[0>type first x;a,x;(enlist(count first x)#a),x]];
//        t insert x;
//        if[l;
//            l enlist (`upd;t;x);j+:1];
//    }];
if[system"t";
	.z.ts:{
		if[(`second$.z.P)=`second$`minute$.z.P;
            .log.info["Number of messages:",string .u.i];
            .log.info[string .u.w];
            ];
        pub'[t;value each t];		    //publish data to subscribers	
		@[`.;t;@[;`sym;`g#]0#];		
		i::j;
		ts .z.d}; 				    //run ts to check for end-of-day
	upd:{[t;x] 				    //Define upd function, which inserts data into table
 		t insert x;					
		if[l;					    //send data to log file every update
			l enlist (`upd;t;x);
			j+:1];
		}];

//Non-batching mode
//    upd:{[t;x]
//        ts"d"$a:.z.P;
//        if[not -16=type first first x;
//            a:"n"$a;
//            x:$[0>type first x;a,x;(enlist(count first x)#a),x]];

if[not system"t";
    system"t 1000";
	.z.ts:{ts .z.D;
        if[(`second$.z.P)=`second$`minute$.z.P;
//            .log.info["Number of messages:",string .u.i];
//            .log.info[string .u.w];
            ];};                        //runs ts to check for end-of-day every second			    
	upd:{[t;x] 						    //Define upd function, 
		ts"d"$a:.z.p;					    //run ts again
		f:key flip value t;				
        pub[t;							    //publish data to subscribers
            $[0>type first x;
				enlist f!x;
                flip f!x]];
		if[l;							    //add data to log file	
			l enlist (`upd;t;x);
            i+:1];
		}];

//move back to root namespace and run .u.tick to initialize tickerplant
\d .
.u.tick . string  args[`qschema`tploglocation];

\
 globals used
 .u.w - dictionary of tables->(handle;syms)
 .u.i - msg count in log file
 .u.j - total msg count (log file plus those held in buffer)
 .u.t - table names
 .u.L - tp log filename, e.g. `:./sym2008.09.11
 .u.l - handle to tp log file
 .u.d - date
