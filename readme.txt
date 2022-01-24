Answer to Exercise 1, Question 10
Sequence to update the schema:
1. Stop the RDB and tickerplant processes
2. Change the tp log file 
3. Restart the processes to make sure that the new schema change is picked update
4. The HDB needs to be reformatted in order to take into account the schema change. This can be done with a 
    dbmaint.q script that can add the necessary columns to the tables. The .Q.chk function can then be used to
    check the database integrity across partitions.