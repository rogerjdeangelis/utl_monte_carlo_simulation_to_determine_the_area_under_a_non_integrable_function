Monte carlo simulation to determine the area under a non integrable function

Probably does not solve the op problem but might help.
R has several monte carlo packages.

The standard normal cannot be integrated, lets see if we can use  simulation
to determine the area under the normal from 1.74 to 3.5

see
https://goo.gl/iDRLFK
https://communities.sas.com/t5/Base-SAS-Programming/monte-carlo-simulation-with-summation/m-p/437962

see
https://www.countbayesie.com/blog/2015/3/3/6-amazing-trick-with-monte-carlo-simulations


INPUT  (Normal Probability Functio)
=====

WORK.HAVE total obs=141

 Obs      X         Y

   1    -3.50    0.00087
   2    -3.45    0.00104
   3    -3.40    0.00123
   4    -3.35    0.00146
   5    -3.30    0.00172
   6    -3.25    0.00203

  38    3.35    0.001459
  39    3.40    0.001232
  40    3.45    0.001038
  41    3.50    0.000873

   Y |
     |                                              1.64
 0.4 +                               ****             |
     |                             **   ***           |
     |                            *       **          |
     |                           *         **         |
     |                          *           *         |
     |                         **            *        |
 0.3 +                         *              *       |
     |                        *               **      |
     |                       *                 *      |
     |                      **                  *     |
     |                      *                    *    |
     |                     *                     *    |
 0.2 +                    **                      *   |
     |                    *                        *  |
     |                   *                         ** |
     |                  *                           * | Tail of Normal
     |                 **                            *| estimated using 10,000
     |                **                              * simulations
 0.1 +               **                               |*
     |              **                                |**
     |             **                                 |****
     |           **                                   |*****
     |         ***                                    |********
     |     ****                                       |************
 0.0 +*****                                           |***************
     +---------+---------+---------+---------+---------+---------+---------+--
   -3.5      -2.5      -1.5      -0.5       0.5       1.5       2.5       3.5
                                   X


PROCESS (WPS/Proc R working code)

    runs <- 100000;  * number of runs;
    sims <- rnorm(runs,mean=0,sd=1); * gen 100,000 random normal;
    mc.integral <- sum(sims >= 1.64 & sims <= 6)/runs; * sum part of the total after 1.64;

OUTPUT
======

The WPS System

[1] 0.05016




   Y |
     |                                              1.64
 0.4 +                               ****             |
     |                             **   ***           |
     |                            *       **          |
     |                           *         **         |
     |                          *           *         |
     |                         **            *        |
 0.3 +                         *              *       |
     |                        *               **      |
     |                       *                 *      |
     |                      **                  *     |
     |                      *                    *    |
     |                     *                     *    |
 0.2 +                    **                      *   |
     |                    *                        *  |
     |                   *                         ** |
     |                  *                           * | Tail of Normal
     |                 **                            *| estimated using 10,000
     |                **                              * simulations
 0.1 +               **                               |*
     |              **                                |**
     |             **                                 |****   0.05 in tail
     |           **                                   |*****
     |         ***                                    |********
     |     ****                                       |** 0.05 ****
 0.0 +*****                                           |***************
     +---------+---------+---------+---------+---------+---------+---------+--
   -3.5      -2.5      -1.5      -0.5       0.5       1.5       2.5       3.5
                                   X

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

options ls=80 ps=44;
data have;
 do x=-3.5  to  3.5 by .05;
   y=pdf('NORMAL',x,0,1);
   output;
 end;
run;quit;

proc plot data=have;
plot y*x='*'/href=1.64;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

%utl_submit_wps64('
libname sd1 "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.1";
libname wrk "%sysfunc(pathname(work))";
libname hlp "C:\Program_Files\SASHome\SASFoundation\9.4\core\sashelp";
proc r;
submit;
source("C:/Program Files/R/R-3.3.1/etc/Rprofile.site", echo=T);
runs <- 100000;
sims <- rnorm(runs,mean=0,sd=1);
mc.integral <- sum(sims >= 1.64 & sims <= 6)/runs;
mc.integral;
endsubmit;
run;quit;
');

