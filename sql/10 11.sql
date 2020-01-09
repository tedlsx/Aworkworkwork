
### 10
SELECT theatreNo, DATE_FORMAT(startDateTime, '%Y-%m-%d') as DateTime, count(*)
FROM Hospital_Operation
GROUP BY DateTime
ORDER BY theatreNo;

### 11
SELECT theatreNo, IFNULL(lastMay, 0) AS lastMay, IFNULL(thisMay, 0) AS thisMay, IFNULL(increase, 0)
FROM(
SELECT DISTINCT HO.theatreNo, lastMay, thisMay, (thisMay - lastMay) AS increase
FROM Hospital_Operation AS HO
LEFT JOIN
(
SELECT theatreNo, count(*) as lastMay
FROM Hospital_Operation
WHERE year(startDateTime) = year(curdate()) - 1 AND month(startDateTime) = 5
GROUP BY theatreNo) AS LASTYEAR
ON HO.theatreNo = LASTYEAR.theatreNo
LEFT JOIN
(
SELECT theatreNo, count(*) as thisMay
FROM Hospital_Operation
WHERE year(startDateTime) = year(curdate()) AND month(startDateTime) = 5
GROUP BY theatreNo) AS THISYEAR
ON LASTYEAR.theatreNo = THISYEAR.theatreNO) T
ORDER BY increase;