--1) 송강 교수가 강의하는 과목을 검색한다
SELECT CNAME
  FROM COURSE
 WHERE PNO = (SELECT PNO
 			    FROM PROFESSOR
 			   WHERE PNAME = '송강')


--2) 화학 관련 과목을 강의하는 교수의 명단을 검색한다
SELECT *
  FROM PROFESSOR
 WHERE "SECTION" = '화학'

--3) 학점이 2학점인 과목과 이를 강의하는 교수를 검색한다
SELECT C.CNAME
	 , P.PNAME 
  FROM COURSE C
  INNER JOIN PROFESSOR P
  		  ON C.PNO = P.PNO 
 WHERE C.ST_NUM = 2
 

--4) 화학과 교수가 강의하는 과목을 검색한다
SELECT C.CNAME
  FROM PROFESSOR P
  JOIN COURSE C
    ON P.PNO = C.PNO
 WHERE P."SECTION" = '화학'

--5) 화학과 1학년 학생의 기말고사 성적을 검색한다
SELECT ST.SNAME 
	 , SC.RESULT
  FROM SCORE SC
  INNER JOIN STUDENT ST
  		  ON ST.SNO = SC.SNO 
 WHERE ST.MAJOR = '화학'
   AND ST.SYEAR = 1

--6) 일반화학 과목의 기말고사 점수를 검색한다
SELECT CR.CNO
	 , SC."RESULT" 
  FROM COURSE CR
  JOIN SCORE SC
    ON CR.CNO = SC.CNO 
 WHERE CR.CNAME = '일반화학'

--7) 화학과 1학년 학생의 일반화학 기말고사 점수를 검색한다
SELECT ST.SNAME 
	 , SC."RESULT" 
  FROM SCORE SC
  INNER JOIN STUDENT ST
  		  ON SC.SNO = ST.SNO
 WHERE ST.MAJOR = '화학'
   AND ST.SYEAR = 1

--8) 화학과 1학년 학생이 수강하는 과목을 검색한다
SELECT DISTINCT CR.CNAME 
  FROM STUDENT ST
  JOIN SCORE SC
  	ON SC.SNO = ST.SNO 
  JOIN COURSE CR
  	ON CR.CNO = SC.CNO
 WHERE ST.MAJOR = '화학'
   AND ST.SYEAR = 1

--9) 유기화학 과목의 평가점수가 F인 학생의 명단을 검색한다
SELECT ST.SNAME
  FROM STUDENT ST
  JOIN SCORE SC
    ON ST.SNO = SC.SNO
  JOIN COURSE CR
    ON CR.CNO = SC.CNO
  JOIN SCGRADE GR
    ON SC."RESULT" BETWEEN GR.LOSCORE AND GR.HISCORE
 WHERE CR.CNAME = '유기화학'
   AND GR.GRADE = 'F'

