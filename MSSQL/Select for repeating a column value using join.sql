/*T-Sql Select for repeating a column value using join
I have two tables which I want to join but want a column of a 2nd table to repeat for every record of first table.


Table A looks like:

Date        Hour
7/1/2014    0
7/1/2014    1
7/1/2014    2
.
.
.
7/1/2014    23

Table B looks like:

Date        Hour   SomeText      Count
7/1/2014    10     TextA         20
7/1/2014    11     TextA         15
7/1/2014    10     TextB         35
7/1/2014    20     TextB         40

I want my result to repeat all rows from Table A with each Unique Text from "SomeText" Column of Table B and counts showing only in their relvant date and hour.

So result would be like:


Date       Hout    SomeText    Count
7/1/2014   0       TextA       0
7/1/2014   1       TextA       0
.
.
7/1/2014   10      TextA       20
7/1/2014   11      TextA       15
.
.
7/1/2014   23      TextA       0
7/1/2014   0       TextB       0
7/1/2014   1       TextB       0
.
.
7/1/2014   10      TextB       35
7/1/2014   11      TextB       0
.
.
7/1/2014   20      TextB       40
7/1/2014   21      TextB       0
.
.
7/1/2014   23      TextB       0
*/

select a.date, a.hour, t.text, coalesce(b.count, 0) as count
from tableA a cross join
     (select distinct text from tableB b) t left outer join
     tableB b
     on b.date = a.date and b.hour = a.hour and b.text = t.text
order by a.date, a.hour, t.text;

/*What it sounds like you want is to have an entry for every date and hour in Table A, and for every SomeText that exists in TableB, filling in the missing entries with a count of 0.

Assuming this is correct, you can do this like so:*/

SELECT TableA.Date, TableA.Hour, Texts.SomeText, COALESCE(TableB.Counts, 0)
FROM TableA
CROSS JOIN (SELECT DISTINCT SomeText FROM TableB) Texts
LEFT JOIN TableB ON TableA.Date = TableB.Date AND TableA.Hour = TableB.Hour AND Texts.SomeText = TableB.SomeText
ORDER BY TableA.Date, TableA.Hour, Texts.SomeText