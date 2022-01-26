# Advanced KDB

## Exercise 1
Before starting any processes, it is important to configure the environment by adapting AdvancedKDB/config/env.sh. Then set the environment by running the shell script as follows 
```sh
$ ./config/env.sh
```
Running the processes in Question 1 can be done by running them manually with q, or with the shell scripts.

### Processes
The following is a list of processes with the commands to start them manually

Tickerplant:    `q processes/tick.q ${Q_SCHEMA} ${TP_LOG_LOCATION} -p ${TP_PORT} -t ${TP_TIMER}`

RDB:            `q processes/rdb.q -p ${RDB_PORT}`

Aggregate RDB:  `q processes/aggRdb.q -p ${AGG_PORT}`

CEP:            `q processes/cep.q -p ${CEP_PORT}`

Q Feedhandler:  `q processes/feed.q -p ${FEED_PORT}`

### Automatic startup and shutdown
```sh
$ ./scripts/start.sh all
$ ./scripts/start.sh tick rdb feed
```
The input process can either be `all` or the individual processes `tick`, `rdb`, `cep`, `aggRdb` and `feed`. Note that no processes will start without the tickerplant.

To check if a process is running you can use the `test.sh` script:
```sh
$ ./scripts/test.sh
```
The `stop.sh` script works similarly to the `start.sh` script:
```sh
$ ./scripts/stop.sh <process>
```
### Tickerplant log replay
To read in a tickerplant log file and filter it so that it creates a new log file based on a filtered sym for the trade table, run the following:
``` sh
$ q logReplay.q ${TP_LOG_LOCATION} IBM.N
```

### CSV File Load
To load a csv file into the tickerplant, run the following process:
``` sh
$ q csvFileLoad.q trade trade.csv
```
### EOD Process
To create a daily partitioned HDB using a log file, run the following process:
``` sh
$ q saveToHdb.q ${TP_LOG_LOCATION}/schema2022.01.22 data
```
The first parameter is the tickerplant log file and the second is the HDB directory

### Answer to Exercise 1, Question 10

Sequence to update the schema:
1. Stop the RDB and tickerplant processes
2. Change the tp log file 
3. Restart the processes to make sure that the new schema change is picked update
4. The HDB needs to be reformatted in order to take into account the schema change. This can be done with a 
    dbmaint.q script that can add the necessary columns to the tables. The .Q.chk function can then be used to
    check the database integrity across partitions.

## Exercise 2
The solutions to each question in Exercise 2 are in txt files in the `exercise2` directory

## Exercise 3
For all of the feeds to work, the tickerplant must be running
### Python Feed
To run the Python feedhandler, run the following command
``` sh
$ pyq exercise3/python/pythonAPI.py trade.csv
```
Note that python3 and pyq must be installed beforehand

### Java Feed
To run the Java feedhandler, run the following command
``` sh
$ java exercise3/java/CsvApi
```

### Websocket
Start the websocket process
``` sh
$ q exercise3/html/q/websocket.q -p 7013
```
Connect from the browser by navigating to `${ADV_KDB_HOME}/exercise3/html/index.html`