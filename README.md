# utl-clinical-if-a-patient-answers-yes-to-any-of-four-questions-they-will-be-ineligible
If a patient answers yes to any of four questions they will be ineligible for the trial.
    If a patient answers yes to any of four questions they will be ineligible for the trial

    Problem: Identify ineligible control and ondrug pateints.

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


