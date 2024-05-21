--1) 각 학생의 평점을 검색하라(별칭을 사용)
SELECT SNAME 	AS "이름"
	 , AVR		AS "평점"
  FROM STUDENT
;
--2) 각 과목의 학점를 검색하라(별칭을 사용)
SELECT CNAME	AS	"과목명"
	 , ST_NUM	AS	"학점"
  FROM COURSE
;
--3) 각 교수의 지위를 검색하라(별칭을 사용)
SELECT PNAME 	AS	"교수명"
	 , ORDERS 	AS	"지위"
  FROM PROFESSOR
;
--4) 급여를 10%인상했을 때 연간 지급되는 급여를 검색하라(별칭을 사용)
SELECT ENO
	 , ENAME
	 , JOB 
	 , MGR 
	 , HDATE 
	 , SAL
	 , (SAL * 1.1 + NVL(COMM, 0)) AS "연간 급여"
	 , DNO
  FROM EMP 
;
--5) 현재 학생의 평균 평점은 4.0만점이다. 이를 4.5만점으로 환산해서 검색하라(별칭을 사용)
SELECT SNO		AS	"학번"
	 , SNAME 	AS 	"이름"
	 , SEX 		AS	"성별"
	 , SYEAR 	AS	"학년"
	 , MAJOR 	AS	"전공"
	 , AVR					AS	"4.0AVR"
	 , (AVR * (4.0 / 4.5))	AS	"4.5AVR"
  FROM STUDENT
;


