-- 1-7. 변환함수
-- TO_CHAR(날짜나 숫자, 변환될 문자열의 형식지정자): 매개변수로 받은 날짜나 숫자 데이터를 지정된 형식으로 변환한 문자열을 리턴
-- 숫자를 문자열로 변환
SELECT TO_CHAR(10000000, '999,999,999') -- 9자리까지 숫자를 표기하고 3자리마다 쉼표 표시
     , TO_CHAR(1000000, '099,999,999') -- 9자리까지 숫자를 표기하고 3자리마다 쉼표 표시, 0을 붙여서 표기
  FROM DUAL
;

-- 날짜를 문자열로 변환
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS')
     , TO_CHAR(SYSDATE, 'YYYY/MM/DD DAY')
     , TO_CHAR(SYSDATE, '"오늘은 " YYYY"년 " MM"월" DD"일입니다."')
     , TO_CHAR(SYSDATE, 'DY"요일입니다."')
  FROM DUAL
;

SELECT TO_DATE('2024/05/24 15:18:00', 'YYYY/MM/DD HH24:MI:SS')
  FROM DUAL
;

-- TO_DATE(문자열 데이터, 문자열 데이터의 날짜 형식): 매개변수로 지정된 날짜형시으로 되어있는 문자열을 DATE 타입으로 변환 후 리턴
SELECT TO_DATE('20240524154900', 'YYYY/MM/DDHH24:MI:SS')
     , TO_DATE('20240524 15', 'YYMMDD HH24')
     , TO_DATE('24', 'YY')
     , TO_DATE('24', 'RR')
     , TO_DATE('99', 'YY')
     , TO_DATE('99', 'RR')
     , TO_DATE('2024/05', 'YYYY/MM')
  FROM DUAL
;

-- TO_NUMBER(문자열 데이터, 문자열 데이터의 숫자 형식): 매개변수로 지정된 숫자 형식으로 된 문자열을 NUMBER 타입으로 변환 후 리턴
SELECT TO_NUMBER('-123.456', '999.999')
     , TO_NUMBER('123', '999.99')
     , TO_NUMBER('1234')
  FROM DUAL
;

-- ROUND(실수, 소수점), TRUNC(실수, 소수점)
-- ROUND(실수), TRUNC(실수): 정수까지(소수점 첫 째자리에서) 반올림, 정수까지(소수점 첫 째자리에서) 버림
SELECT ROUND(1.45, 0)
     , ROUND(1.45)
  FROM DUAL
;

-- 1-8. NVL: NULL 처리 함수
-- 과목의 과목번호, 과목이름, 교수번호, 교수이름을 조회하는데 담당교수가 배정되지 않은 과목과 과목을 배정받지 못한 교수의 정보도 함께 조회
-- 담당교수가 NULL인 데이터는 교수 배정되지 않음이라고 조회하고
-- 과목이 NULL인 교수의 과목정보는 과목 배정받지 못함이라고 조회
SELECT NVL(C.CNO, '과목 배정받지 못함')         AS "과목번호"
     , NVL(C.CNAME, '과목 배정받지 못함')       AS "과목명"
     , NVL(P.PNO, '교수 배정되지 않음')         AS "교수번호"
     , NVL(P.PNAME, '교수 배정되지 않음')       AS "교수명"
  FROM COURSE C
  FULL JOIN PROFESSOR P
         ON C.PNO = P.PNO 
;

-- 1-9. DECODE(컬럼명이나 조회해온 데이터, 조건 값, 
--             컬럼의 데이터나 조회해온 데이터가 조건 값1과 일치할 때 실행될 내용,
--             컬럼의 데이터나 조회해온 데이터가 조건 값1과 일치하지 않을 때 실행될 내용)
-- DECODE는 조건문을 처리하는 구문으로 조건에는 값만 넣어서 사용할 수 있다.
SELECT ENO
     , ENAME
     , DNO
     , DECODE(DNO, '10', '인사팀', '다른 부서') AS "부서명"
  FROM EMP
 ORDER BY DNO
;

-- DECODE(컬럼명이나 조회해온 데이터, 조건 값, 
--        컬럼의 데이터나 조회해온 데이터가 조건 값1과 일치할 때 실행될 내용,
--        조건 값2,
--        컬럼의 데이터나 조회해온 데이터가 조건 값2과 일치할 때 실행될 내용,
--        조건 값3,
--        컬럼의 데이터나 조회해온 데이터가 조건 값3과 일치할 때 실행될 내용,
--        ...
--        조건 값N,
--        컬럼의 데이터나 조회해온 데이터가 조건 값N과 일치할 때 실행될 내용,
--        컬럼의 데이터나 조회해온 데이터가 조건 값N과 일치하지 않을 때 실행될 내용(위의 조건과 모두 일치하지 않는 경우))
SELECT ENO
     , ENAME
     , DNO
     , DECODE(DNO, 
                '10', '인사팀',
                '01', '경영팀',
                '02', '개발팀',
                '그 외 부서') AS "부서명"
  FROM EMP
 ORDER BY DNO
;

SELECT ENO
     , ENAME
     , DNO
     , CASE DNO WHEN '10' THEN '인사팀'
                WHEN '01' THEN '경영팀'
                WHEN '02' THEN '개발팀'
                ELSE '그 외 부서' END AS "부서명"
  FROM EMP
 ORDER BY DNO
;

-- 사원의 사원번호, 사원이름, 업무, 급여, 인상급여 조회
-- 업무가 개발이면 50%인상, 업무가 경영이면 30%인상, 이원이면 20%인상, 그 외 업무면 10%이상 된 인상급여 조회
SELECT ENO
     , ENAME
     , JOB
     , DECODE(JOB, 
                '개발', SAL * 1.5,
                '경영', SAL * 1.3,
                '이원', SAL * 1.2,
                SAL * 1.1) AS "인상급여"    
     , SAL
     , COMM
  FROM EMP
;

-- 1-10. CASE~WHEN~THEN~ELSE END
-- CASE (컬럼명)
--    WHEN 조건1
--    THEN 조건1이 TRUE일 때 처리할 내용
--    WHEN 조건2
--    THEN 조건2이 TRUE일 때 처리할 내용
--    ...
--    WHEN 조건N
--    THEN 조건N이 TRUE일 때 처리할 내용
--    ELSE
--    위 조건이 모둔 FALSE인 데이터에 대한 처리내용
--    END AS 별칭
-- CASE 절에 컬럼이나 데이터를 지정한 경우(SWITCH CASE 문 처럼 사용)
SELECT ENO
     , ENAME
     , COMM
     , CASE NVL(COMM, -1)
         WHEN 0
         THEN '보너스 없음'
         WHEN -1
         THEN '해당없음'
       ELSE '보너스: ' || COMM
       END AS COMM_TXT
  FROM EMP
;

-- CASE 절에 컬럼이나 데이터를 지정하지 않은 경우 (WHEN 절에 비교문을 사용하여 조건을 지정할 수 있다.)
SELECT ENO
     , ENAME
     , COMM
     , CASE WHEN COMM = 0       THEN '보너스 없음'
            WHEN COMM IS NULL   THEN '해당없음'
            ELSE '보너스: ' || COMM
            END AS COMM_TXT
  FROM EMP
;

-- 사원의 사원번호, 사원이름, 업무, 급여, 인상급여 조회
-- 업무가 개발이면 50%인상, 업무가 경영이면 30%인상, 이원이면 20%인상, 그 외 업무면 10%이상 된 인상급여 조회
SELECT ENO
     , ENAME
     , JOB
     , SAL
     , CASE JOB WHEN '개발' THEN SAL * 1.5
                WHEN '경영' THEN SAL * 1.3
                WHEN '이원' THEN SAL * 1.2
                ELSE SAL * 1.1
                END AS RISE_SAL
  FROM EMP
;