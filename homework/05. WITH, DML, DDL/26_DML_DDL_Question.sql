--1) STUDENT 테이블을 참조하여 ST_TEMP 테이블을 만들고 모든 학생의 성적을 4.5만점 기준으로 수정하세요
CREATE TABLE ST_TEMP(SNO, SNAME, SEX, SYEAR, MAJOR, AVRFF)
    AS SELECT SNO
            , SNAME
            , SEX
            , SYEAR
            , MAJOR
            , AVR * 1.25
         FROM STUDENT
;
SELECT *
  FROM ST_TEMP
;
--2) PROFESSOR 테이블을 참조하여 PF_TEMP 테이블을 만들고 모든 교수의 부임일자를 100일 앞으로 수정하세요
CREATE TABLE PF_TEMP(PNO, PNAME, "SECTION", ORDERS, BEF_HIREDATE)
    AS (SELECT PNO
            , PNAME
            , "SECTION"
            , ORDERS
            , (HIREDATE - 100)  AS BEF_HIREDATE
         FROM PROFESSOR)
;
SELECT *
  FROM PF_TEMP
;
--3) ST_TEMP 테이블에서 화학과 2학년 학생의 정보를 삭제하세요
DELETE FROM ST_TEMP
 WHERE MAJOR = '화학'
   AND SYEAR = 2
;

SELECT *
  FROM ST_TEMP
;
--4) PF_TEMP 테이블에서 조교수의 정보를 삭제하세요
DELETE FROM PF_TEMP
 WHERE ORDERS = '조교수'
;

SELECT *
  FROM PF_TEMP
;
--5) EMP 테이블을 참조하여 EMP2 테이블을 만들고
--   DNO = 30인 사원의 보너스를 15프로 상승시킨 값으로 변경하시고 
--   DNO = 10인 사원의 보너스를 5프로 상승시킨 값으로 변경,
--   DNO = 20인 사원의 급여를 10프로 상승시킨 값으로 변경하세요.
CREATE TABLE EMP2 
    AS SELECT * FROM EMP
;

UPDATE EMP2
   SET COMM = COMM * 1.15
 WHERE DNO = '30'
;
UPDATE EMP2
   SET COMM = COMM * 1.05
 WHERE DNO = ' 10'
;
UPDATE EMP2
   SET SAL = SAL * 1.1
 WHERE DNO = '20'
;

COMMIT;

SELECT *
  FROM EMP2
;
--6) 화학과 2학년 학생중 기말고사 성적의 등급이 A, B인 정보를 갖는 테이블 SCORE_STGR을 생성하세요.(SNO, SNAME, MAJOR, SYEAR, CNO, CNAME, RESULT, GRADE)
CREATE TABLE SCORE_STGR(SNO, SNAME, MAJOR, SYEAR, CNO, CNAME, RESULT, GRADE)
    AS SELECT T.SNO
            , T.SNAME
            , T.MAJOR
            , T.SYEAR
            , C.CNO
            , C.CNAME
            , T.RESULT
            , SGR.GRADE
         FROM (SELECT S.SNO
                    , S.SNAME
                    , S.MAJOR
                    , S.SYEAR
                    , SC.RESULT
                    , SC.CNO
                 FROM STUDENT S
                 JOIN SCORE SC
                   ON S.SNO = SC.SNO
                WHERE S.MAJOR = '화학'
                  AND S.SYEAR = 2) T
         JOIN SCGRADE SGR
           ON T.RESULT BETWEEN SGR.LOSCORE AND SGR.HISCORE
         JOIN COURSE C
           ON C.CNO = T.CNO
        WHERE SGR.GRADE IN ('A', 'B')
        ORDER BY T.SNO
               , T.SNAME
    
   
;
SELECT *
  FROM SCORE_STGR
;
--7) 생물학과 학생중 평점이 2.7이상인 학생이 수강중인 과목의 정보를 갖는 테이블 ST_COURSEPF를 생성하세요. (SNO, SNAME, CNO, CNAME, PNO, PNAME, AVR)
CREATE TABLE ST_COURSEPF(SNO, SNAME, CNO, CNAME, PNO, PNAME, AVR)
    AS SELECT S.SNO
            , S.SNAME
            , C.CNO
            , C.CNAME
            , C.PNO
            , P.PNAME
            , S.AVR
         FROM STUDENT S
         JOIN SCORE SC
           ON S.SNO = SC.SNO
         JOIN COURSE C
           ON C.CNO = SC.CNO
         JOIN PROFESSOR P
           ON C.PNO = P.PNO
        WHERE S.MAJOR = '생물'
          AND S.AVR >= 2.7
;

SELECT *
  FROM ST_COURSEPF