--1) 각 과목의 과목명과 담당 교수의 교수명을 검색하라
SELECT C.CNAME
	 , P.PNAME
  FROM COURSE C
  JOIN PROFESSOR P
    ON C.PNO = P.PNO 

--2) 화학과 학생의 기말고사 성적을 모두 검색하라
SELECT ST.SNAME
	 , ST.MAJOR
	 , SC."RESULT" 
  FROM STUDENT ST
  FULL JOIN SCORE SC
  		 ON ST.SNO = SC.SNO
 WHERE ST.MAJOR = '화학'
  

--3) 유기화학과목 수강생의 기말고사 시험점수를 검색하라
SELECT ST.SNAME
	 , CR.CNAME
	 , SC."RESULT" 
  FROM STUDENT ST
  INNER JOIN SCORE SC
  		  ON ST.SNO = SC.SNO
  INNER JOIN COURSE CR
  		  ON SC.CNO = CR.CNO 
 WHERE CR.CNAME = '유기화학'

--4) 화학과 학생이 수강하는 과목을 담당하는 교수의 명단을 검색하라
SELECT DISTINCT  P."SECTION"
	 , P.PNAME 
  FROM STUDENT ST
  JOIN PROFESSOR P
  	ON ST.MAJOR = P."SECTION"
 WHERE ST.MAJOR = '화학'

--5) 모든 교수의 명단과 담당 과목을 검색한다
SELECT P.PNAME
	 , C.CNAME
  FROM PROFESSOR P
  JOIN COURSE C
    ON P.PNO = C.PNO 

--6) 모든 교수의 명단과 담당 과목을 검색한다(단 모든 과목도 같이 검색한다)
SELECT P.PNAME
	 , C.CNAME 
  FROM PROFESSOR P
  FULL JOIN COURSE C
    	 ON P.PNO = C.PNO
