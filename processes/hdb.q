\l src/libs/log.q
\l src/libs/monitor.q

if[not "w"=first string .z.o;system "sleep 1"];

defaultargs:(!) . flip (
    (`serviceType      ; `hdb                                       );
    (`hdbroot          ; `$getenv[`HDB_ROOT]	                    )
	);

//read command line parameters
args:.Q.def[defaultargs] .Q.opt[.z.x];

//loads in the hdb root
.log.info["Loading ",string args[`hdbroot]];
system"l ",string args[`hdbroot]

// reload function
reload:{
    .log.info["Reloading..."];
    system"l ."}