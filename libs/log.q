/////////////
// PRIVATE //
/////////////

.log.priv.levels:`error`warning`notice`info`debug
.log.priv.handle:-1
.log.priv.level:.log.priv.levels?`info
.log.priv.showMemory:1b // Set to 0b to disable logging of memory consumption
.log.priv.rotate:1b // Set to 0b to disable daily log rotations
.log.priv.date:.z.d
.log.priv.processName:""
.log.priv.path:""

///
// Check if logs should be rotated
.log.priv.check:{[]
  if[2<abs .log.priv.handle;
    if[.log.priv.rotate&.log.priv.date<.z.d;
      .log.init[.log.priv.path;.log.priv.processName]]];
  }

///
// Recursively stringify any given data
// @param list any List of values to stringify
.log.priv.stringify:{[list]
  res:$[10=type list;list;
    97<type list;"\n",.Q.s list;
    0<=type list;"¬"sv .z.s@'list;
    string list];

  ssr[;"¬";" "]ssr[;"\n";"\n "]ssr[res;"\n¬";"\n"]}

///
// Builds standard logging message
// @param level long Log level
// @param str any Message to log
.log.priv.buildMsg:{[level;str]
  res:(.z.p;$[.log.priv.showMemory;"[",("/"sv string`int$system["w"]%1024*1024),"]";""]);
  res,:(upper .log.priv.levels level;str);
  .log.priv.stringify res}

///
// Log the given message to stdout with the specified level
// @param level long Log level
// @param str any Message to log
.log.priv.write:{[level;str]
  .log.priv.check[];
  if[level<=.log.priv.level;
    .log.priv.handle .log.priv.buildMsg[level;str]];
  }

////////////
// PUBLIC //
////////////

///
// Set logging level as specified
// @param level symbol Log level to set
.log.setLogLevel:{[level]
  .log.priv.level:.log.priv.levels?level;
  }

///
// Configure logging
// @param path string Absolute path to log directory
// @param processName string Process name
.log.init:{[path;processName]
  if[2<absh:abs .log.priv.handle;
    @[hclose;absh;0]];
  .log.priv.path:path;
  .log.priv.processName:processName;
  .log.priv.date:.z.d;
  file:`$":",path,"/",processName,"_",ssr[string .z.d;".";"_"],".log";
  .log.priv.handle:neg@[hopen;file;1i];
  }

//////////
// INIT //
//////////

{[level]
  (` sv`.log,level)set .log.priv.write[.log.priv.levels?level;];
  }'[.log.priv.levels];