--1) 학생중에 동명이인을 검색한다
SELECT *
  FROM STUDENT ST1
  INNER JOIN STUDENT ST2
  		  ON ST1.SNAME = ST2.SNAME
 WHERE ST1.SNO <> ST2.SNO
;

--2) 전체 교수 명단과 교수가 담당하는 과목의 이름을 학과 순으로 검색한다
SELECT P.PNAME
	 , C.CNAME
  FROM PROFESSOR P
  JOIN COURSE C
    ON P.PNO = C.PNO
 ORDER BY P."SECTION"
;  

--3) 이번 학기 등록된 모든 과목과 담당 교수의 학점 순으로 검색한다
SELECT *
  FROM COURSE C
  JOIN PROFESSOR P
  	ON C.PNO = P.PNO
 ORDER BY C.ST_NUM DESC