// This process replays a log file with a filter
// Inputs are the log file path and the sym to filter on
// q logReplay.q ${TP_LOG_LOCATION} IBM.N

//load other libs
\l libs/log.q

// get command line parameters
tpLog:hsym `$.z.x[0];
filterSym:`$.z.x[1];

newLogFile: .[`$string[tpLog],"_",string filterSym; (); :; ()];
newLogHandle: hopen hsym newLogFile;

upd:{[table;data]
    if[(table=`trade) and (any filterSym in/: flip data);
        newLogHandle enlist (`upd;table;flip (flip data) where filterSym in/: flip data)];
    };

-11!tpLog;