If a patient answers yes to any of four questions they will be ineligible for the trial

Problem: Identify ineligible control and ondrug pateints.

Recent addition on end
Lean something new and see Pauls
out of the box solution on end.
Paul Dorfman <sashole@bellsouth.net>


We have 40 patients 20 in control group(p1-p20) and 20 on drug(p1-p20).

https://stackoverflow.com/questions/53546473/sas-keep-if-all-else


INPUT
=====

  WORK.TEST total obs=8                        |   RULES
                                               |
     TRT      QUES    P1    P2    P3 ...   P4  |
                                               |
   CONTROL     Q1     N     Y     N  ...   Y   |   Control patient #4 (P4)
   CONTROL     Q2     N     Y     N        Y   |   is ineligible because
   CONTROL     Q3     Y     N     Y        N   |   he/she answered Y to
   CONTROL     Q4     N     N     N        N   |   at least one question

   ONDRUG      Q1     N     Y     N        Y   |
   ONDRUG      Q2     N     N     N        N   |
   ONDRUG      Q3     N     Y     N        Y   |
   ONDRUG      Q4     N     N     N  ...   N   |


EXAMPLE OUTPUT
--------------

 WORK.WANT total obs=2

    TRT      QUES    P1    P2    P3 ...   P4

  CONTROL     Q4     Y     Y     Y  ...   Y
  ONDRUG      Q4     N     Y     N  ...   Y

 Looks like we are going to bring in more control group patients.


PROCESS
=======

data want;

  do until (last.trt);

     set test;
     by trt;

     array tmps[20] _temporary_ ;
     array ps      p1-p20 ;

     do idx=1 to 20;
        if ps[idx]='Y' then tmps[idx]=1;
     end;

     if last.trt then do;
        do idx=1 to 20;
           if tmps[idx] then ps[idx]='Y'; else ps[idx]='N';
        end;
        output;
        call missing(of tmps[*]);
     end;

  end;

run;quit;


OUTPUT
======
 see above

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

data test;
input Trt$ ques $ (p1-p20) ($2.) ;
datalines;
CONTROL Q1 N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y
CONTROL Q2 N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y
CONTROL Q3 Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N
CONTROL Q4 N N N N N N N N N N N N N N N N N N N N N N N N
ONDRUG Q1 N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y
ONDRUG Q2 N N N N N N N N N N N N N N N N N N N N N N N N
ONDRUG Q3 N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y
ONDRUG Q4 N N N N N N N N N N N N N N N N N N N N N N N N
;
run;



*____             _
|  _ \ __ _ _   _| |
| |_) / _` | | | | |
|  __/ (_| | |_| | |
|_|   \__,_|\__,_|_|

;


Recent addition
Lean something new and see Pauls
out of the box solution on end.
Paul Dorfman <sashole@bellsouth.net>

Roger,

It looks like a (rare) good opportunity to make use of
one of the bitwise functions (in this case, BOR):

data have ;
  input (T Q) ($) (p1-p20) (:$1.) ;
  cards ;
CONTROL Q1 N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y
CONTROL Q2 N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y
CONTROL Q3 Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N
CONTROL Q4 N N N N N N N N N N N N N N N N N N N N N N N N
ONDRUG  Q1 N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y
ONDRUG  Q2 N N N N N N N N N N N N N N N N N N N N N N N N
ONDRUG  Q3 N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y N Y
ONDRUG  Q4 N N N N N N N N N N N N N N N N N N N N N N N N
run ;

data want (drop = _:) ;
  do until (last.T) ;
    set have ;
    by T ;
    _s = input (translate (put (cats (of p:), $20.), "01", "NY"), binary20.) ;
    if first.T then _r = _s ;
    else _r = BOR (_r, _s) ;
  end ;
  call pokelong (translate (put (_r, binary20.), "NY", "01"), addrlong (p1)) ;
run ;

Notably, PEEKCLONG could be used instead of CATS on the way from the P's to _S.
But on the way back from _R to the P's, the APP is the only alternative
to an array coupled with DO or 20 separate assignment statements with CHAR.
Interestingly, in COBOL it can be done using the UNSTRING statement.
Just musing, it could be useful if SAS offered a call routine with a similar functional
ity, in this case looking sort of like:

call unstring (<from>, <length>, of <to>:) ;

where <length> would indicate the size of the pieces into which <from> is to be unstrung.

Best regards


Roger DeAngelis
8:10 AM (0 minutes ago)
to Paul, SAS-L@LISTSERV.UGA.EDU

Nice Paul

You took the path less taken and it make all the difference

Cobol brings back memories however GET WITH IT ;)
Old Dogs can learn new tricks.

R and Python have splitting functions
-------------------------------------

strsplit("hello","");

[1] "h" "e" "l" "l" "o"

Python
------
print list("hello");

or

print wrap("hello", 1);

PROCESS

R
%utl_submit_r64('
strsplit("hello","");
');

Python
%utl_submit_py64('
from textwrap3 import wrap;
print wrap("hello", 1);
print list("hello");
');






