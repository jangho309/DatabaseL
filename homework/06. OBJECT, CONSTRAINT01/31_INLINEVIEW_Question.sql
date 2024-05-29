--1) 4.5 환산 평점이 가장 높은 3인의 학생을 검색하세요.
SELECT ROWNUM
     , T.*
  FROM (SELECT --DENSE_RANK() OVER(ORDER BY AVR DESC)
               ST.SNO
             , ST.SNAME
             , ST.SEX
             , ST.SYEAR
             , ST.MAJOR
             , AVR * 1.125  AS CONVERT_AVR
          FROM STUDENT ST
         ORDER BY CONVERT_AVR DESC) T
 WHERE ROWNUM <= 3
;
--2) 기말고사 과목별 평균이 높은 3과목을 검색하세요.
SELECT ROWNUM
     , CO.CNAME
  FROM (SELECT CR.CNAME
             , AVG(SC.RESULT) AS AVG_RESULT
          FROM SCORE SC
          JOIN COURSE CR
            ON SC.CNO = CR.CNO
         GROUP BY CR.CNAME
         ORDER BY AVG_RESULT DESC) CO
 WHERE ROWNUM <= 3
;
--3) 학과별, 학년별, 기말고사 평균이 순위 3까지를 검색하세요.(학과, 학년, 평균점수 검색)
SELECT ROWNUM
     , SCT.*
  FROM (SELECT ST.MAJOR
             , ST.SYEAR
             , AVG(SC.RESULT)   AS AVG_RESULT
          FROM STUDENT ST
          JOIN SCORE SC
            ON ST.SNO = SC.SNO
         GROUP BY ST.MAJOR
                , ST.SYEAR
         ORDER BY AVG_RESULT DESC) SCT
 WHERE ROWNUM <= 3
;
--4) 기말고사 성적이 높은 과목을 담당하는 교수 3인을 검색하세요.(교수이름, 과목명, 평균점수 검색)
SELECT ROWNUM
     , RP.PNAME
     , RP.CNAME
     , RP.AVG_RESULT
  FROM (SELECT PR.PNAME
             , CR.CNAME
             , AVG(SC.RESULT)   AS AVG_RESULT
          FROM COURSE CR
          JOIN SCORE SC
            ON CR.CNO = SC.CNO
          JOIN PROFESSOR PR
            ON PR.PNO = CR.PNO
         GROUP BY PR.PNAME
                , CR.CNAME
         ORDER BY AVG_RESULT DESC) RP
 WHERE ROWNUM <= 3
;
--5) 교수별로 현재 수강중인 학생의 수를 검색하세요.
SELECT PS.PNAME
     , PS.STUDENT_CNT
  FROM (SELECT PR.PNAME
             , COUNT(ST.SNO)    AS STUDENT_CNT
          FROM PROFESSOR PR
          JOIN STUDENT ST
            ON PR.SECTION = ST.MAJOR
         GROUP BY PR.PNAME) PS
;