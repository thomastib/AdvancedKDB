// Standard out function
.log.out:{[message] -1 " " sv (string .z.p; "User:"; raze string .z.h; "INFO:"; message; "Mem:";.Q.s1 .Q.w[]);};

// Standard error function
.log.err:{[message] -2 " " sv (string .z.p; "User:"; raze string .z.h; "ERROR:"; message; "Mem:";.Q.s1 .Q.w[]);};

// Use .log.out function to log when ports are opened
.z.po:{.log.out["Port Opened: ", string .z.w]};

// Use .log.out function to log when ports are closed
.z.pc:{.log.out["Port Closed: ", string .z.w]};