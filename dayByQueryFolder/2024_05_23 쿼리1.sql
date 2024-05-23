-- 2. 집합연산자
-- 집합연산자는 서로 다른 두 쿼리의 결과물 합집합, 차집합, 교집합 해주는 연산자
-- 2-1. 합집합 연산자(UNION, UNION ALL)
-- 2000년 이후에 부임된 교수의 교수번호, 교수이름, 부임일자의 2000년 이후에 채용된 사원의 사원번호, 사원이름, 채용일자를 조회
-- 첫 번째 쿼리에서 컬럼의 개수, 데이터 타입이 결정되기 때문에 두 번째 쿼리는 첫 번째 쿼리의 컬럼의 개수, 데이터 타입을 따라야한다.
SELECT PNO
	 , PNAME
	 , HIREDATE
  FROM PROFESSOR
 WHERE HIREDATE >= TO_DATE('20000101 00:00:00', 'YYYYMMDD HH24:MI:SS')
UNION
SELECT ENO
	 , ENAME
	 , HDATE
  FROM EMP
 WHERE HDATE >= TO_DATE('2000', 'YYYY')
;

-- UNION은 중복을 제거해서 합집합 연산을 해준다.
-- 평점이 3.0이상인 학생의 학생번호, 학생이름, 학년, 평점과 학년이 3학년인 학생의 학생번호, 학생이름, 학년, 평점을 함께 조회
-- 중복제거
SELECT SNO
	 , SNAME
	 , SYEAR 
	 , AVR 
  FROM STUDENT
 WHERE AVR >= 3.0
UNION
SELECT SNO
	 , SNAME
	 , SYEAR 
	 , AVR
  FROM STUDENT
 WHERE SYEAR = 3
 ORDER BY SNO  
;
-- UNION은 중복을 제거해서 합집합 연산을 해준다.
-- 평점이 3.0이상인 학생의 학생번호, 학생이름, 학년, 평점과 학년이 3학년인 학생의 학생번호, 학생이름, 학년, 평점을 함께 조회
-- 중복제거 없음
SELECT SNO
	 , SNAME
	 , SYEAR 
	 , AVR 
  FROM STUDENT
 WHERE AVR >= 3.0
UNION ALL
SELECT SNO
	 , SNAME
	 , SYEAR 
	 , AVR
  FROM STUDENT
 WHERE SYEAR = 3
 ORDER BY SNO  

-- 2-2. 차집합 연산자(MINUS)
-- 첫 번째 쿼리에서 두 번째 쿼리의 공통된 데이터를 제외한 결과를 조회한다.
INSERT INTO EMP VALUES('9998', '제갈궁', '지원', NULL, SYSDATE, 3200, 320, NULL);
COMMIT;

-- 성이 제갈이면서 지원업무를 하지 않는 사원의 사원번호, 사원이름, 업무 조회
SELECT ENO
     , ENAME
     , JOB 
  FROM EMP 
 WHERE ENAME  LIKE '제갈%'
   AND JOB != '지원'
;

SELECT ENO 
     , ENAME 
     , JOB 
  FROM EMP
 WHERE ENAME LIKE '제갈%'
MINUS 
SELECT ENO
     , ENAME 
     , JOB 
  FROM EMP
 WHERE JOB = '지원'
;

-- 차집합 연산자를 사용해서 담당교수가 배정되지 않은 과목의 과목번호, 과목이름 조회
SELECT CNO
     , CNAME 
  FROM COURSE
 WHERE 1=1
MINUS
SELECT CNO
     , CNAME
  FROM COURSE
 WHERE PNO IS NOT NULL
;

-- 2-3. 교집합 연산자(INTERSECT)
-- 첫 번째 쿼리의 결과에서 두 번째 쿼리의 공통된 결과만 조회
-- 교집합 연산자를 사용해서 물리, 화학과 학생중 평점이 3.0이상인 학생의 학생번호, 학생이름, 전공, 평점 조회
SELECT SNO
     , SNAME
     , MAJOR
     , AVR
  FROM STUDENT
 WHERE MAJOR IN ('물리', '화학')
INTERSECT
SELECT SNO
     , SNAME
     , MAJOR
     , AVR
  FROM STUDENT
 WHERE AVR >= 3.0
;
