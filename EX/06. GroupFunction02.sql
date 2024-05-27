-- 1. 그룹화 관련 함수
-- 1-1. ROLLUP
-- 처음에는 GROUP BY에 지정된 모든 컬럼으로 그룹화된 결과를 보여주고
-- 다음부터는 마지막에 지정된 컬럼을 하나씩 뺀 그룹화된 결과를 보여주다가
-- 마지막에는 그룹화되지 않은 전체 데이터에 대한 결과를 보여준다.
-- ROLLUP을 사용하지 않았을 때
SELECT DNO
	 , JOB
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP
	GROUP BY DNO, JOB;
	
-- ROLLUP 사용 시
SELECT DNO
	 , JOB
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP
	GROUP BY ROLLUP(DNO, JOB);
	
SELECT DNO
	 , JOB
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP
	GROUP BY DNO, JOB;
	
SELECT DNO
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP
	GROUP BY DNO;
	
SELECT MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP;
	
-- ROLLUP 함수를 이용해서 전공별 학년별 평점의 평균, 평점의 총합, 최고 평점 조회
-- 전공별 평점의 평균, 평점의 총합, 최고 평점 조회
-- 전체 학생에 대한 평점의 평균, 평점의 총합, 최고 평점 조회
SELECT MAJOR
	 , SYEAR
	 , AVG(AVR)
	 , SUM(AVR)
	 , MAX(AVR)
	 , COUNT(*)
	FROM STUDENT
	GROUP BY ROLLUP(MAJOR, SYEAR);
	
-- 1-2. CUBE
-- ROLLUP 함수와 지정방식은 동일하지만 동작 방식이 다르다.
-- ROLLUP 함수가 GROUP BY에 지정된 컬럼을 뒤에서부터 하나씩 빼면서 그룹화를 진행한다면
-- CUBE 함수는 GROUP BY에 지정된 컬럼의 모든 조합에 대한 그룹화를 진행한다.
-- ROLLUP 사용 시
SELECT MAJOR
	 , SYEAR
	 , SEX
	 , AVG(AVR)
	 , SUM(AVR)
	 , MAX(AVR)
	 , COUNT(*)
	FROM STUDENT
	GROUP BY ROLLUP(MAJOR, SYEAR, SEX);

-- CUBE 사용 시
SELECT MAJOR
	 , SYEAR
	 , SEX
	 , AVG(AVR)
	 , SUM(AVR)
	 , MAX(AVR)
	 , COUNT(*)
	FROM STUDENT
	GROUP BY CUBE(MAJOR, SYEAR, SEX);

-- 1-3. GROUPING SETS: GROUP BY에 지정된 컬럼들의 각각 그룹화된 결과를 보여준다.
SELECT DNO
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP
	GROUP BY DNO
UNION
SELECT JOB
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP
	GROUP BY JOB;

SELECT DNO
	 , JOB
	 , MAX(SAL)
	 , SUM(SAL)
	 , AVG(SAL)
	 , COUNT(*)
	FROM EMP
	GROUP BY GROUPING SETS(DNO, JOB);

