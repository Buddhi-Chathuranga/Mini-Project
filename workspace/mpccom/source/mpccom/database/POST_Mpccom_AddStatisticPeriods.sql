--------------------------------------------------------------------------------------------------------
--
--  File        : POST_Mpccom_AddStatisticPeriods.sql
--
--  Module      : MPCCOM
--
--  Purpose     : Creates statistic periods for 120 periods ahead from the date of installation.
--                Run only in Fresh installations.
--
--  Date     Sign    History
--  ------   ------  -----------------------------------------------------------------------------------
--  170510   SeJalk  Bug 135661, Created.
--------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_Mpccom_AddStatisticPeriods.sql','Timestamp_1');
PROMPT Inserts of statistic_period default data...
DECLARE
   newrec_       STATISTIC_PERIOD_TAB%ROWTYPE;
   begin_year_   VARCHAR2(4) ;
   begin_date_   DATE;
   end_date_     DATE;
   description_  VARCHAR2(35);
   period_no_              NUMBER;

BEGIN
	begin_year_ := to_char(SYSDATE, 'YYYY');
	begin_date_ := to_date(begin_year_||'01'||'01','YYYYMMDD');
	period_no_ := 1;

	FOR month_ IN 1 .. 120  LOOP
		description_ := TRIM(TO_CHAR(begin_date_, 'MONTH'))||' '||TO_CHAR(begin_date_, 'YYYY');
		end_date_    := LAST_DAY(begin_date_);

		newrec_.begin_date := begin_date_;
		newrec_.description := description_;
		newrec_.end_date := end_date_;
		newrec_.stat_period_no := period_no_;
		newrec_.stat_year_no := TO_NUMBER(TO_CHAR(begin_date_, 'YYYY'));
		newrec_.period_closed := NULL;
		newrec_.rowversion := SYSDATE;
		Statistic_Period_API.Insert_Or_Update__(newrec_);
		-- Set the begin date to next month.
		begin_date_ := TRUNC(ADD_MONTHS(begin_date_, 1), 'MM');
		-- Check whether a new year is begun
		IF TRUNC(newrec_.begin_date, 'YYYY') != TRUNC(begin_date_, 'YYYY') THEN
		   period_no_ := 1;
		ELSE
		   period_no_ := period_no_ + 1;
		END IF;
	END LOOP;
END;
/
COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_Mpccom_AddStatisticPeriods.sql','Done');
PROMPT Finished with POST_Mpccom_AddStatisticPeriods.sql
