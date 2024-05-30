-- 1. PL/SQL(Procedual Language Extension to SQL): 오라클에서 제공하는 절차적 언어를 만들기 위한 기능
--                                                 쿼리문에 변수를 선언하고 조건문이나 반복문을 사용할 수 있다.
-- PL/SQL에서는 결과를 출력하기 위해서 DBMS_OUTPUT.PUT_LINE 함수를 이용한다.
-- 출력을 하기 위한 옵션을 ON을 설정
--SET SERVEROUTPUT ON; (sqldeveloper에서 사용)

-- 1-1. 기본적인 PL/SQL
DECLARE
    -- 변수읜 선언은 변수명 데이터타입
    -- 선언부에서 변수의 값을 할당해도 되고 안해도 된다.
    -- 선언부에서 변수의 값을 할당하지 않으면 실행부에서 변수의 값을 할당해도 된다.
    NUM NUMBER;
BEGIN
    NUM := 10;
    DBMS_OUTPUT.PUT_LINE(NUM);
END;

-- 1-2. 예외처리가 포함된 PL/SQL
DECLARE
    NUM1 NUMBER := 10;
    NUM2 NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE(NUM1 / NUM2);
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다.');
        DBMS_OUTPUT.PUT_LINE(NUM1 / 1);
END;

-- 1-3. 참조형 변수 선언(테이블의 컬럼 타입 참조)
DECLARE
    -- STUDENT 테이블의 SNO 컬럼 타입과 동일한 타입으로 지정된다.
    STUDENT_NO STUDENT.SNO%TYPE;
    -- STUDENT 테이블의 SNAME 컬럼의 타입과 동일한 타입으로 지정된다.
    STUDENT_NAME STUDENT.SNAME%TYPE;
BEGIN
    STUDENT_NO := '11111111';
    STUDENT_NAME := '조장호';

    DBMS_OUTPUT.PUT_LINE(STUDENT_NO);
    DBMS_OUTPUT.PUT_LINE(STUDENT_NAME);
END;

-- 1-4. 테이블의 행을 참조한 행 참조변수 선언
DECLARE
    -- STUDENT 테이블에 존재하는 컬럼을 모두 가지고 있는 변수 선언
    -- STUDENT_ROW 변수에는 SNO, SNAME, SEX, SYEAR, MAJOR, AVR 포함되어 있다.
    STUDENT_ROW STUDENT%ROWTYPE;
BEGIN
    -- 각각의 컬럼의 데이터 타입은 참조한 테이블의 컬럼의 데이터 타입과 동일하다.
    STUDENT_ROW.SNO := '22222222';
    STUDENT_ROW.SNAME := '홍길동';
    STUDENT_ROW.SEX := '남';
    STUDENT_ROW.SYEAR := 1;
    STUDENT_ROW.MAJOR := '컴공';
    STUDENT_ROW.AVR := 3.56;
    DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SNO);
    DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SNAME);
    DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SEX);
    DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SYEAR);
    DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.MAJOR);
    DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.AVR);
END;

-- 1-5. SELECT 구문을 이용한 변수의 값 할당
-- SELECT 구문을 이용해서 변수 값을 할당할 때는 BEGIN부 안에서 할당한다.
DECLARE
    STUDENT_NO STUDENT.SNO%TYPE;
BEGIN
    -- SELECT INTO 구문
    -- SELECT 조회할 값 INTO 저장할 변수
    -- FROM
    SELECT SNO INTO STUDENT_NO
      FROM STUDENT
     WHERE SNAME = '홍길동';
    DBMS_OUTPUT.PUT_LINE(STUDENT_NO);
END;

-- EMP 테이블의 컬럼을 모두 참조하는 변수를 선언하고
-- ENO이 0001인이 사원의 데이터를 모두 출력하세요.
DECLARE
    EMP_ROW EMP%ROWTYPE;
BEGIN
    SELECT * INTO EMP_ROW
      FROM EMP
     WHERE ENO = '0001';
--    SELECT ENO, ENAME, JOB, MGR, HDATE, SAL, COMM, DNO INTO EMP_ROW
--      FROM EMP
--     WHERE ENO = '0001';
    DBMS_OUTPUT.PUT_LINE(EMP_ROW.ENO);
    DBMS_OUTPUT.PUT_LINE(EMP_ROW.ENAME);
    DBMS_OUTPUT.PUT_LINE(EMP_ROW.JOB);
    DBMS_OUTPUT.PUT_LINE(EMP_ROW.MGR);
    DBMS_OUTPUT.PUT_LINE(EMP_ROW.HDATE);
    DBMS_OUTPUT.PUT_LINE(EMP_ROW.SAL);
    DBMS_OUTPUT.PUT_LINE(EMP_ROW.COMM);
    DBMS_OUTPUT.PUT_LINE(EMP_ROW.DNO);
END;

-- 2. 조건문(IF/CASE)
-- 2-1. IF
/*
 * 
 * IF 조건1 THEN 실행문1
 * ELSIF 조건2 THEN 실행문2
 * ELSIF 조건3 THEN 실행문3
 * ...
 * ELSIF 조건N THEN 실행문N
 * ELSE 실행문
 * END IF;
 * 
 */
DECLARE
    NUM1 NUMBER := 12345;
    NUM2 NUMBER := 113;
BEGIN
    IF MOD(NUM1, NUM2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE(NUM2 || '는 ' || NUM1 || '의 약수입니다.');
    ELSE 
        DBMS_OUTPUT.PUT_LINE(NUM2 || '는 ' || NUM1 || '의 약수가 아닙니다.');
    END IF;
END;

DECLARE
    DEPT_ROW DEPT%ROWTYPE;
BEGIN
    SELECT * INTO DEPT_ROW
      FROM DEPT
     WHERE DNO = '30';
    IF DEPT_ROW.LOC = '서울' THEN
        DBMS_OUTPUT.PUT_LINE(DEPT_ROW.DNAME || '부서의 지역은 서울입니다.');
    ELSIF DEPT_ROW.LOC = '대전' THEN
        DBMS_OUTPUT.PUT_LINE(DEPT_ROW.DNAME || '부서의 지역은 대전입니다.');
    ELSIF DEPT_ROW.LOC = '부산' THEN
        DBMS_OUTPUT.PUT_LINE(DEPT_ROW.DNAME || '부서의 지역은 부산입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE(DEPT_ROW.DNAME || '부서의 지역은 서울, 대전, 부산 외의 지역입니다.');
    END IF;
END;

-- PROFESSOR 테이블의 모든 컬럼을 참조하는 변수를 선언하고
-- 교수가 정교수인지 부교수인지 출력하는 PL/SQL을 작성하세요.
-- 정교수, 부교수가 아닌 교수는 시간강사입니다.를 출력하세요.
-- PNO가 1032인 교수의 데이터 참조
DECLARE
    PROFESSOR_ROW PROFESSOR%ROWTYPE;
BEGIN
    SELECT * INTO PROFESSOR_ROW
      FROM PROFESSOR
     WHERE PNO = '1032';
     IF PROFESSOR_ROW.ORDERS = '정교수' THEN
        DBMS_OUTPUT.PUT_LINE(PROFESSOR_ROW.PNAME || '은 정교수입니다.');
     ELSIF PROFESSOR_ROW.ORDERS = '부교수' THEN
        DBMS_OUTPUT.PUT_LINE(PROFESSOR_ROW.PNAME || '은 부교수입니다.');
     ELSE 
        DBMS_OUTPUT.PUT_LINE(PROFESSOR_ROW.PNAME || '은 시간강사입니다.');
     END IF;
END;

-- 2-2. CASE 구문
DECLARE
    PROFESSOR_ROW PROFESSOR%ROWTYPE;
BEGIN
    SELECT * INTO PROFESSOR_ROW
      FROM PROFESSOR
     WHERE PNO = '1032';
    -- CASE1: CASE 뒤에 변수를 지정해서 값으로만 조건 비교
    CASE PROFESSOR_ROW.ORDERS
        WHEN '정교수' THEN
        DBMS_OUTPUT.PUT_LINE(PROFESSOR_ROW.PNAME || '은 정교수입니다.');
        WHEN '부교수' THEN
        DBMS_OUTPUT.PUT_LINE(PROFESSOR_ROW.PNAME || '은 부교수입니다.');
        ELSE
        DBMS_OUTPUT.PUT_LINE(PROFESSOR_ROW.PNAME || '은 시간강사입니다.');
    END CASE;
    -- CASE2: CASE 뒤에 변수를 지정하지 않고 WHEN절에서 조건식으로 비교
    CASE WHEN PROFESSOR_ROW.ORDERS = '정교수' THEN
         DBMS_OUTPUT.PUT_LINE(PROFESSOR_ROW.PNAME || '은 정교수입니다.');
         WHEN PROFESSOR_ROW.ORDERS = '부교수' THEN
         DBMS_OUTPUT.PUT_LINE(PROFESSOR_ROW.PNAME || '은 부교수입니다.');
         ELSE
         DBMS_OUTPUT.PUT_LINE(PROFESSOR_ROW.PNAME || '은 시간강사입니다.');
    END CASE;
END;

-- 3. 반복문(기본 LOOP, WHILE LOOP, FOR LOOP)
-- 3-1. 기본 LOOP
DECLARE
    NUM1 NUMBER := 0;
BEGIN
    LOOP
        NUM1 := NUM1 + 1;
        -- 특정 조건일 때 이번 실행을 건너뜀
        CONTINUE WHEN MOD(NUM1, 2) != 0;
        DBMS_OUTPUT.PUT_LINE(NUM1);
        -- 특정 조건일 때 LOOP 종료
        EXIT WHEN NUM1 >= 10;
    END LOOP;
END;

-- 3-2. WHILE LOOP
-- 특정 조건이 충족되는 동안 계속 반복 실행
DECLARE
    NUM NUMBER := 1;
BEGIN
    WHILE NUM <= 10 LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
        NUM := NUM + 1;
    END LOOP;
END;

-- 3-3. FOR LOOP
-- 시작값과 종료값을 지정해서 시작 값부터 종료 값까지 계속 반복
DECLARE
    NUM NUMBER;
BEGIN
    FOR NUM IN REVERSE 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
    END LOOP;
END;

-- 기본 LOOP 문을 이용해서 학생의 이름, 학생번호, 학생이름 10개 출력
DECLARE
    STUDENT_ROW STUDENT%ROWTYPE;
    CNT NUMBER := 0;
BEGIN
    LOOP
        -- 조회하는 데이터의 행의 개수가 0개면 NO_DATA_FOUND 예외가 발생한다.
        SELECT * INTO STUDENT_ROW
          FROM STUDENT
         WHERE SNO = TO_CHAR(TO_NUMBER('915301') + CNT);
        CNT := CNT + 1;
        EXIT WHEN CNT > 10;
        DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SNO);
        DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SNAME);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('해당 데이터를 찾지 못했습니다.');
END;

-- LOOP
DECLARE
    STUDENT_ROW STUDENT%ROWTYPE;
    CNT NUMBER := 0;
    ROWCNT NUMBER := 0;
BEGIN
    LOOP
        -- 조회하는 데이터의 행의 개수가 0개면 NO_DATA_FOUND 예외가 발생한다.
        SELECT * INTO STUDENT_ROW
          FROM STUDENT
         WHERE SNO = TO_CHAR(TO_NUMBER('915301') + CNT);
        SELECT COUNT(*) INTO ROWCNT
          FROM STUDENT
         WHERE SNO = TO_CHAR(TO_NUMBER('915301') + CNT);
        CNT := CNT + 1;
        EXIT WHEN CNT > 10;
        IF ROWCNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('데이터가 존재하지 않습니다.');
        ELSE 
            DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SNO);
            DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SNAME);
        END IF;
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('해당 데이터를 찾지 못했습니다.');
END;

---- WHILE LOOP
DECLARE
    STUDENT_ROW STUDENT%ROWTYPE;
    CNT NUMBER := 0;
BEGIN
    WHILE CNT <= 10 LOOP
        -- 조회하는 데이터의 행의 개수가 0개면 NO_DATA_FOUND 예외가 발생한다.
        SELECT * INTO STUDENT_ROW
          FROM STUDENT
         WHERE SNO = TO_CHAR(TO_NUMBER('915301') + CNT);
     
        CNT := CNT + 1;
    
        DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SNO);
        DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SNAME);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('해당 데이터를 찾을 수 없습니다.');
END;

---- FOR LOOP
DECLARE
    STUDENT_ROW STUDENT%ROWTYPE;
    CNT NUMBER;
BEGIN
    FOR CNT IN 0..10 LOOP
        -- 조회하는 데이터의 행의 개수가 0개면 NO_DATA_FOUND 예외가 발생한다.
        SELECT * INTO STUDENT_ROW
          FROM STUDENT
         WHERE SNO = TO_CHAR(TO_NUMBER('915301') + CNT);
     
        DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SNO);
        DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SNAME);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('해당 데이터를 찾지 못했습니다.');
END;

-- 4. 레코드: 다양한 타입의 변수들을 모아놓은 자료형.
DECLARE
    -- 레코드의 선언
    TYPE STUDENT_REC IS RECORD(
        -- 기본 데이터 타입과 참조형 데이터 타입들을 모두 사용할 수 있다.
        SNO         VARCHAR2(8) NOT NULL := '11111111',
        SNAME       STUDENT.SNAME%TYPE,
        SEX         STUDENT.SEX%TYPE,
        SYEAR       NUMBER(1) NOT NULL DEFAULT 1,
        MAJOR       STUDENT.MAJOR%TYPE,
        AVR         STUDENT.AVR%TYPE,
        JOIN_DATE   DATE DEFAULT SYSDATE,
        SCORE_ROW SCORE%ROWTYPE
    );

    -- 위에 선언한 레코드 자료형으로 변수를 하나 선언해야 실행부에서 레코드를 사용할 수 있다.
    -- 레코드 자료형의 변수 선언
    STUDENTREC STUDENT_REC;
BEGIN
    STUDENTREC.SNO := '22222222';
    STUDENTREC.SNAME := '이순신';
    
--    STUDENTREC.SCORE.SNO := '915301';
--    STUDENTREC.SCORE.CNO := '1211';
--    STUDENTREC.SCORE.RESULT := '100';
    SELECT * INTO STUDENTREC.SCORE_ROW
      FROM SCORE
     WHERE SNO = '915301'
       AND CNO = '1211';
   
   DBMS_OUTPUT.PUT_LINE(STUDENTREC.SNO);
   DBMS_OUTPUT.PUT_LINE(STUDENTREC.SNAME);
   DBMS_OUTPUT.PUT_LINE(STUDENTREC.SCORE_ROW.CNO);
   DBMS_OUTPUT.PUT_LINE(STUDENTREC.SCORE_ROW.RESULT);
END;

-- 4-1. 레코드를 통한 데이터 저장
CREATE TABLE STUDENT_RECORD
AS SELECT * FROM STUDENT;

DECLARE
    TYPE STUDENT_REC IS RECORD(
        SNO         STUDENT.SNO%TYPE,
        SNAME       STUDENT.SNAME%TYPE,
        SEX         STUDENT.SEX%TYPE,
        SYEAR       STUDENT.SYEAR%TYPE,
        MAJOR       STUDENT.MAJOR%TYPE,
        AVR         STUDENT.AVR%TYPE
    );
    
    STUDENTREC STUDENT_REC;
BEGIN
    STUDENTREC.SNO := '33333333';
    STUDENTREC.SNAME := '이순신';
    STUDENTREC.SEX := '남';
    STUDENTREC.SYEAR := 1;
    STUDENTREC.MAJOR := '컴공';
    STUDENTREC.AVR := 4.0;

    -- 데이터 저장
    INSERT INTO STUDENT_RECORD
    VALUES STUDENTREC;
END;

SELECT *
  FROM STUDENT_RECORD
 WHERE SNO = '33333333'