--뷰 이름은 자유
--1) 학생의 평점 4.5 만점으로 환산된 정보를 검색할 수 있는 뷰를 생성하세요.
CREATE VIEW CONVERT_STUDENT_AVR AS (
    SELECT SNO
         , SNAME
         , SEX
         , SYEAR
         , MAJOR
         , AVR * 1.125  AS CONVERT_AVR
      FROM STUDENT
)
;
SELECT *
  FROM CONVERT_STUDENT_AVR
;
--2) 각 과목별 기말고사 평균 점수를 검색할 수 있는 뷰를 생성하세요.
CREATE VIEW COURSE_RESULT_AVG AS (
    SELECT CR.CNAME
         , AVG(SC.RESULT)   AS AVG_RESULT
      FROM COURSE CR
      JOIN SCORE SC
        ON CR.CNO = SC.CNO
     GROUP BY CR.CNAME
)
;
SELECT *
  FROM COURSE_RESULT_AVG
;
--3) 각 사원과 관리자(MGR)의 이름을 검색할 수 있는 뷰를 생성하세요.
CREATE VIEW EMP_FROM_MGR AS (
    SELECT E1.ENAME                     EMP_NAME
         , NVL(E2.ENAME, '관리자 없음')      MGR_NAME
      FROM EMP E1
      LEFT JOIN EMP E2
             ON E1.MGR = E2.ENO
)
;
SELECT *
  FROM EMP_FROM_MGR

--4) 각 과목별 기말고사 평가 등급(A~F)까지와 해당 학생 정보를 검색할 수 있는 뷰를 생성하세요.
CREATE VIEW COURSE_GRADE_ST_INFO AS (
    SELECT CR.CNAME
         , SC.RESULT
         , SGR.GRADE
         , ST.*
      FROM SCORE SC
      JOIN SCGRADE SGR
        ON SC.RESULT BETWEEN SGR.LOSCORE AND SGR.HISCORE
      JOIN COURSE CR
        ON SC.CNO = CR.CNO
      JOIN STUDENT ST
        ON SC.SNO = ST.SNO
)
;

SELECT *
  FROM COURSE_GRADE_ST_INFO
;
--5) 물리학과 교수의 과목을 수강하는 학생의 명단을 검색할 뷰를 생성하세요.
CREATE VIEW PHYSICS_PROFESSOR_STUDENT AS (
    SELECT DISTINCT ST.SNO
         , ST.SNAME
      FROM COURSE CR
      JOIN PROFESSOR PS
        ON CR.PNO = PS.PNO
      JOIN STUDENT ST
        ON PS.SECTION = ST.MAJOR
     WHERE PS.SECTION = '물리'
)
;

SELECT *
  FROM PHYSICS_PROFESSOR_STUDENT