//tick utilities

\d .u

//initialization of .u.w, a dictionary specifying what tables each subscriber is subscribed to
// This table also holds what symbols each subscriber receives
init:{w::t!(count t::tables`.)#()}

//function to delete subscribers from subscriber table
del:{w[x]_:w[x;;0]?y};

//function run on disconnection from subscriber
.z.pc:{del[;x]each t};

//function to select the symbols that each subscriber requests
sel:{$[`~y;
   x;
   select from x where sym in y]}

// function that publishes data to each subscriber
pub:{[t;x]
    {[t;x;w] 
        if[count x:sel[x]w 1;
            ((neg w 0) (`upd;t;x))]
        }[t;x]each w t}

//funtion that adds client to .u.w and returns the table name and the table data to the client when subscribed
add:{
    $[(count w x)>i:w[x;;0]?.z.w;
        .[`.u.w;(x;i;1);union;y];
        w[x],:enlist(.z.w;y)];
    (x;$[99=type v:value x;sel[v]y;@[0#v;`sym;`g#]])}

//funcion that is run when a process subscribes. 
subEx:{[table;syms;exclude]
    if[table~`;                 //if no tables are passed, subscribe to all tables
        :sub[;syms]each t except exclude];
    if[not table in t;          //throw error if table does not exist
        'table];
    del[table].z.w;             //removes client from .u.w if already there
    add[table;syms]}               //adds client with symbols

sub:subEx[;;`];

//tell subscribers to run their EOD function 
end:{(neg union/[w[;;0]])@\:(`.u.end;x)}
