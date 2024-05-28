--1) WITH 절을 이용하여 정교수만 모여있는 가상테이블 하나와 일반과목(과목명에 일반이 포함되는)들이 모여있는 가상테이블 하나를 생성하여 
--   일반과목들을 강의하는 교수의 정보 조회하세요.(과목번호, 과목명, 교수번호, 교수이름)
WITH JEONG_PROFESSOR AS (
    SELECT PNO
         , PNAME
      FROM PROFESSOR
     WHERE ORDERS = '정교수'
),
NORMAL_COURSE AS (
    SELECT CNO
         , CNAME
         , PNO
      FROM COURSE
     WHERE CNAME LIKE '%일반%'
)
SELECT NC.CNO
     , NC.CNAME
     , JP.PNO
     , JP.PNAME
  FROM NORMAL_COURSE NC
  JOIN JEONG_PROFESSOR JP
    ON NC.PNO = JP.PNO
;
--2) WITH 절을 이용하여 급여가 3000이상인 사원정보를 갖는 가상테이블 하나와 보너스가 500이상인 사원정보를 갖는 가상테이블 하나를 생성하여
--   두 테이블에 모두 속해있는 사원의 정보를 모두 조회하세요.
WITH SAL3000 AS (
    SELECT ENO
         , ENAME
         , SAL
      FROM EMP
     WHERE SAL >= 3000
),
COMM500 AS (
    SELECT ENO
         , ENAME
         , COMM
      FROM EMP
     WHERE COMM >= 500
)
SELECT S.ENO
     , S.ENAME
     , S.SAL
     , C.COMM
  FROM SAL3000 S
  JOIN COMM500 C
    ON S.ENO = C.ENO

--3) WITH 절을 이용하여 평점이 3.3이상인 학생의 목록을 갖는 가상테이블 하나와 학생별 기말고사 평균점수를 갖는 가상테이블 하나를 생성하여
--   평점이 3.3이상인 학생의 기말고사 평균 점수를 조회하세요.
WITH AVR33 AS (
    SELECT SNO
         , SNAME
         , AVR
      FROM STUDENT
     WHERE AVR >= 3.3
),
STUDENT_AVR AS (
    SELECT SNO
         , AVG(RESULT)  AS AVG_RESULT
      FROM SCORE
     GROUP BY SNO
)
SELECT A.SNO
     , A.SNAME
     , A.AVR
     , SA.AVG_RESULT
  FROM AVR33 A
  JOIN STUDENT_AVR SA
    ON A.SNO = SA.SNO
;
--4) WITH 절을 이용하여 부임일자가 25년이상된 교수정보를 갖는 가상테이블 하나와 과목번호, 과목명, 학생번호, 학생이름, 교수번호, 기말고사성적을
--   갖는 가상테이블 하나를 생성하여 기말고사 성적이 90이상인 과목번호, 과목명, 학생번호, 학생이름, 교수번호, 교수이름, 기말고사성적을 조회하세요.
WITH OVER25 AS (
    SELECT PNO
         , PNAME
         , SECTION
      FROM PROFESSOR
     WHERE MONTHS_BETWEEN(SYSDATE, HIREDATE) >= 12 * 25
),
COSTPR AS (
    SELECT CR.CNO
         , CR.CNAME
         , ST.SNO
         , ST.SNAME
         , P.PNO
         , SC.RESULT
      FROM COURSE CR
      JOIN PROFESSOR P
        ON P.PNO = CR.PNO
      JOIN SCORE SC
        ON SC.CNO = CR.CNO
      JOIN STUDENT ST
        ON ST.SNO = SC.SNO
)
SELECT *
  FROM OVER25 O
  JOIN COSTPR C
    ON O.PNO = C.PNO
 WHERE C.RESULT >= 90
;
