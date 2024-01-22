use [SEAN_Staging_TEST_2017]
GO

/*
 * Creates two functions:
 * fn_GetDaylightSavingsTimeStart: Returns the start date of DST per current (as of 2023) NIST rules.
 * fn_GetDaylightSavingsTimeEnd: Returns the end date of DST per current (as of 2023) NIST rules.
 */

CREATE function [dbo].[fn_GetDaylightSavingsTimeStart] (@Year varchar(4))
RETURNS smalldatetime
as
begin
   declare @DTSStartWeek smalldatetime, @DTSEndWeek smalldatetime
   set @DTSStartWeek = '03/01/' + convert(varchar,@Year)
   return case datepart(dw,@DTSStartWeek)
     when 1 then dateadd(hour,170,@DTSStartWeek)
     when 2 then dateadd(hour,314,@DTSStartWeek)
     when 3 then dateadd(hour,290,@DTSStartWeek)
     when 4 then dateadd(hour,266,@DTSStartWeek)
     when 5 then dateadd(hour,242,@DTSStartWeek)
     when 6 then dateadd(hour,218,@DTSStartWeek)
     when 7 then dateadd(hour,194,@DTSStartWeek)
   end
END

GO

CREATE function [dbo].[fn_GetDaylightSavingsTimeEnd] (@Year varchar(4))
RETURNS smalldatetime
as
begin
   declare @DTSEndWeek smalldatetime
   set @DTSEndWeek = '11/01/' + convert(varchar,@Year)
   return case datepart(dw,dateadd(week,1,@DTSEndWeek))
     when 1 then dateadd(hour,2,@DTSEndWeek)
     when 2 then dateadd(hour,146,@DTSEndWeek)
     when 3 then dateadd(hour,122,@DTSEndWeek)
     when 4 then dateadd(hour,98,@DTSEndWeek)
     when 5 then dateadd(hour,74,@DTSEndWeek)
     when 6 then dateadd(hour,50,@DTSEndWeek)
     when 7 then dateadd(hour,26,@DTSEndWeek)
   end
end

GO