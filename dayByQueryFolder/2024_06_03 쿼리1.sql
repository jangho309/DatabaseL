CREATE TABLE ST_SC_GRADE(
    SNO     VARCHAR2(8),
    SNAME   VARCHAR2(20),
    CNO     VARCHAR2(8),
    CNAME   VARCHAR2(20),
    SCORE   NUMBER(3, 0),
    GRADE   VARCHAR2(1)
);

-- ST_SC_GRADE 테이블에 학생별 과목별 기말고사 성적 등급까지 저장하는 프로시저 P_ST_GRADE 생성
CREATE OR REPLACE PROCEDURE P_ST_GRADE
IS
    CURSOR ST_SC_GRADE_CUR IS
        SELECT T.SNO
             , T.SNAME
             , T.CNO
             , T.CNAME
             , T.RESULT
             , T.GRADE
          FROM (SELECT ST.SNO
                     , ST.SNAME
                     , CR.CNO
                     , CR.CNAME
                     , SC.RESULT
                     , SGR.GRADE
                  FROM STUDENT ST
                  JOIN SCORE SC
                    ON ST.SNO = SC.SNO
                  JOIN COURSE CR
                    ON CR.CNO = SC.CNO      
                  JOIN SCGRADE SGR
                    ON SC.RESULT BETWEEN SGR.LOSCORE AND SGR.HISCORE) T;
                    
    ST_SC_GRADE_REC ST_SC_GRADE%ROWTYPE;
BEGIN
    FOR  ST_SC_GRADE_ROW IN ST_SC_GRADE_CUR LOOP
        INSERT INTO ST_SC_GRADE
        VALUES ST_SC_GRADE_ROW;
        COMMIT;
    END LOOP;
    
--    OPEN ST_SC_GRADE_CUR;
--    
--    LOOP
--        FETCH ST_SC_GRADE_CUR INTO ST_SC_GRADE_REC;
--        
--        EXIT WHEN ST_SC_GRADE_CUR%NOTFOUND;
--        
--        INSERT INTO ST_SC_GRADE VALUES ST_SC_GRADE_REC;
--        COMMIT;
--    END LOOP;
--    
--    CLOSE ST_SC_GRADE_CUR;
END;

EXEC P_ST_GRADE;

DELETE FROM ST_SC_GRADE;

SELECT *
  FROM ST_SC_GRADE
 ORDER BY SNO, CNO
;


-- 1-2. 파라미터가 있는 프로시저
-- 프로시저명 다음에 ()묶어서 파라미터들을 정의할 수 있고
-- 프로시저를 호출할 때 지정한 파라미터 값들을 전달한다.
CREATE OR REPLACE PROCEDURE P_NEW_DEPT(
    DNO VARCHAR2,
    DNAME IN VARCHAR2,
    LOC VARCHAR2 DEFAULT '서울',
    DIRECTOR VARCHAR2 DEFAULT '0001'
)
IS
BEGIN
    INSERT INTO DEPT(DNO, DNAME, LOC, DIRECTOR)
    VALUES (DNO, DNAME, LOC, DIRECTOR);
    COMMIT;
END;
/

-- 파라미터가 있는 프로시저를 실행할 때 파라미터 값들을 전달한다.
-- 기본값이 있는 파라미터는 생략 가능
EXEC P_NEW_DEPT('80', '테스트');

SELECT *
  FROM DEPT
;

-- 1-3. Stored Function: 오라클 사용자 정의 함수. 프로시저와 동일한 역할을 하지만
--                       프로시저와 다르게 리턴 값이 존재해서 EXEC 명령어로 단독 실행도 되고
--                       일반 쿼리문에서 호출도 가능하다.
-- 급여별로 세금을 계산해주는 함수 F_GET_TAX
CREATE OR REPLACE FUNCTION F_GET_TAX
(
    SAL     NUMBER
)
-- 함수의 결과의 데이터타입 지정
RETURN NUMBER
IS
    TAX NUMBER;
BEGIN
    IF SAL >= 7000 THEN TAX := 0.5;
    ELSIF SAL >= 6000 THEN TAX := 0.4;
    ELSIF SAL >= 5000 THEN TAX := 0.3;
    ELSE TAX := 0.3;
    END IF;
    
    -- 위에서 지정한 함수 결과의 데이터 타입의 값을 RETURN 구문을 사용해서 RETURN
    RETURN ROUND(SAL * TAX);
END;
/

-- 생성한 함수 쿼리문에서 사용
SELECT F_GET_TAX(3000)
  FROM DUAL;
  
-- 기존 테이블의 데이터와 혼합해서 사용
SELECT E.ENO
     , E.ENAME
     , E.SAL
     , F_GET_TAX(E.SAL) AS TAX
  FROM EMP E
;

-- 평점을 파라미터로 받아서 4.5만점인 평점으로 환산하는 F_CONVERT_AVR을 만들어보세요.
CREATE OR REPLACE FUNCTION F_CONVERT_AVR
(
    AVR     NUMBER
)
RETURN NUMBER
IS
BEGIN
    RETURN ROUND(AVR * 1.125, 2);
END;
/

SELECT SNO
     , SNAME
     , AVR
     , F_CONVERT_AVR(AVR) AS C_AVR
  FROM STUDENT
;

-- FUNCTION WHERE 절에서 사용
SELECT SNO
     , SNAME
     , AVR
     , F_CONVERT_AVR(AVR) AS C_AVR
  FROM STUDENT
 WHERE F_CONVERT_AVR(AVR) >= 4.2
;

-- 날짜를 파라미터로 받아서 10년뒤 날짜를 리턴하는 F_PLUS_10YEARS를 만드세요.
CREATE OR REPLACE FUNCTION F_PLUS_10YEARS
(
    P_DATE DATE
)
RETURN DATE
IS
BEGIN
    RETURN ADD_MONTHS(P_DATE, 120);
END;
/

SELECT ENAME
     , HDATE
     , F_PLUS_10YEARS(HDATE)
  FROM EMP;
  
-- 두 날짜를 파라미터로 받아서 두 날자의 차이를 일자로 리턴하는 함수 F_DIFF_DATES를 만드세요.
CREATE OR REPLACE FUNCTION F_DIFF_DATES
(
    P1_DATE DATE,
    P2_DATE DATE
)
RETURN NUMBER
IS
    DAY_DIFF NUMBER;
BEGIN
    IF P1_DATE > P2_DATE THEN 
        DAY_DIFF := ROUND(P1_DATE - P2_DATE);
    ELSE
        DAY_DIFF := ROUND(P2_DATE - P1_DATE);
    END IF;
    
    RETURN DAY_DIFF;
END;
/

SELECT ENO
     , ENAME
     , HDATE
     , F_DIFF_DATES(SYSDATE, HDATE) "입사후 지난일자"
  FROM EMP
;

-- 1-4. TRIGGER: 특정 테이블의 데이터의 변경이 있을 때 지정한 PL/SQL 구문을 실행하는 SUB PROGRAM
-- BEFORE TRIGGER
-- 급여가 3000미만으로 입력되거나 수정됐을 때 에러를 표출하는 트리거
CREATE OR REPLACE TRIGGER TR_EMP_SAL
-- EMP 테이블의 SAL 컬럼의 값이 변경되거나 추가되기 전에 동작하는 트리거
BEFORE
INSERT OR UPDATE OF SAL ON EMP
-- 새로운 데이터를 받아오는 변수 선언
REFERENCING NEW AS NEW
-- 모든 행에 대해서
FOR EACH ROW
BEGIN
    IF : NEW.SAL < 3000 THEN 
         -- 데이터가 추가될 때
         IF INSERTING THEN
            RAISE_APPLICATION_ERROR(-20001, '최저 시급보다 낮은 급여는 추가할 수 없습니다.');
         -- 데이터가 변경될 때
         ELSIF UPDATING THEN
            RAISE_APPLICATION_ERROR(-20002, '최저 시급보다 낮은 급여로 데이터를 수정할 수 없습니다.');
         ELSE
            RAISE_APPLICATION_ERROR(-20003, '최저 시급보다 낮음');
         END IF;
    END IF;
END;
/

INSERT INTO EMP
VALUES ('8001', '홍길동', '테스트', NULL, SYSDATE, 3100, 100, '01');
COMMIT;

INSERT INTO EMP
VALUES ('8001', '조병조', '테스트', NULL, SYSDATE, 2800, 100, '01');
COMMIT;

SELECT * FROM EMP;

UPDATE EMP
   SET SAL = 2900
 WHERE ENO = '9998'
;

-- AFTER TRIGGER
-- SCORE 테이블의 데이터가 추가되거나 변경됐을 때 ST_SC_GRADE 테이블에 데이터를 추가하거나 변경하는 트리거
CREATE OR REPLACE TRIGGER TR_ST_SC_GRADE
AFTER
INSERT OR UPDATE ON SCORE
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
    ST_SC_GRADE_ROW ST_SC_GRADE%ROWTYPE;
BEGIN
    SELECT SNAME INTO ST_SC_GRADE_ROW.SNAME
      FROM STUDENT 
     WHERE SNO = :NEW.SNO;
     
    SELECT CNAME INTO ST_SC_GRADE_ROW.CNAME
      FROM COURSE 
     WHERE CNO = :NEW.CNO;
     
    SELECT GRADE INTO ST_SC_GRADE_ROW.GRADE
      FROM SCGRADE
     WHERE :NEW.RESULT BETWEEN LOSCORE AND HISCORE;
     
    MERGE INTO ST_SC_GRADE A
    USING DUAL
    ON (A.SNO = :NEW.SNO AND A.CNO = :NEW.CNO)
    WHEN MATCHED THEN
        UPDATE
           SET SCORE = :NEW.RESULT
             , GRADE = ST_SC_GRADE_ROW.GRADE
    WHEN NOT MATCHED THEN
        INSERT(SNO, SNAME, CNO, CNAME, SCORE, GRADE)
        VALUES(:NEW.SNO, ST_SC_GRADE_ROW.SNAME, :NEW.CNO,
          ST_SC_GRADE_ROW.CNAME, :NEW.RESULT, ST_SC_GRADE_ROW.GRADE);
END;
/
SELECT *
  FROM ST_SC_GRADE
 WHERE SNO = '915301'
   AND CNO = '1212'
;

SELECT *
  FROM SCORE
 ORDER BY RESULT DESC
;

UPDATE SCORE
   SET RESULT = 100
 WHERE SNO = '915301'
   AND CNO = '1212'
;

SELECT *
  FROM ST_SC_GRADE
 WHERE SNO = '999998'
   AND CNO = '1212'
;
   
INSERT INTO SCORE
VALUES('999998', '1212', 85);
