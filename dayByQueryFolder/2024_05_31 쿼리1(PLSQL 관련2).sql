-- 4-2. 레코드를 통한 데이터 수정
DECLARE
    TYPE STUDENT_RECORD IS RECORD(
        SNO         STUDENT.SNO%TYPE,
        SNAME       STUDENT.SNAME%TYPE,
        SEX         STUDENT.SEX%TYPE,
        SYEAR       STUDENT.SYEAR%TYPE,
        MAJOR       STUDENT.MAJOR%TYPE,
        AVR         STUDENT.AVR%TYPE
    );
    
    STUDENTREC STUDENT_RECORD;
BEGIN
    STUDENTREC.SNO      := '33333333';
    STUDENTREC.SNAME    := '이순신';
    STUDENTREC.SEX      := '남';
    STUDENTREC.SYEAR    := 4;
    STUDENTREC.MAJOR    := '소프트웨어';
    STUDENTREC.AVR      := 3.56;

    -- 데이터 수정
    UPDATE STUDENT_RECORD 
       SET 
--           MAJOR = STUDENTREC.MAJOR
--         , AVR  = STUDENTREC.AVR
           ROW = STUDENTREC
     WHERE SNO = STUDENTREC.SNO;
    COMMIT;
END;

DELETE FROM STUDENT_RECORD
 WHERE SNO = '33333333';
COMMIT;

SELECT *
  FROM STUDENT_RECORD
 WHERE SNO = '33333333'
;

-- 4-3. 레코드안에 레코드 선언
DECLARE
    TYPE SCO_REC IS RECORD(
        SNO     SCORE.SNO%TYPE,
        CNO     SCORE.CNO%TYPE,
        RESULT  SCORE.RESULT%TYPE
    );
    
    TYPE STU_REC IS RECORD(
        STU_ROW     STUDENT%ROWTYPE,
        -- 레코드안에 레코드 변수 선언
        SCOREC SCO_REC
    );
    
    STUREC STU_REC;
BEGIN
    SELECT ST.SNO
         , ST.SNAME
         , ST.SEX
         , ST.SYEAR
         , ST.MAJOR
         , ST.AVR
         , SC.CNO
         , SC.RESULT 
      INTO STUREC.STU_ROW.SNO
         , STUREC.STU_ROW.SNAME
         , STUREC.STU_ROW.SEX
         , STUREC.STU_ROW.SYEAR
         , STUREC.STU_ROW.MAJOR
         , STUREC.STU_ROW.AVR
         , STUREC.SCOREC.CNO
         , STUREC.SCOREC.RESULT
      FROM STUDENT ST
      JOIN SCORE SC
        ON ST.SNO = SC.SNO
     WHERE ST.SNO = '915301'
       AND SC.CNO = '1211';
   
   DBMS_OUTPUT.PUT_LINE(STUREC.STU_ROW.SNO);
   DBMS_OUTPUT.PUT_LINE(STUREC.STU_ROW.SNAME);
   DBMS_OUTPUT.PUT_LINE(STUREC.SCOREC.CNO);
   DBMS_OUTPUT.PUT_LINE(STUREC.SCOREC.RESULT);
END;

-- 5. 연관 배열: 동일한 데이터 타입의 데이터들을 모아놓은 객체
DECLARE
    -- 연관 배열 자료형 선언
    TYPE NUM_ARR IS TABLE OF NUMBER
    INDEX BY PLS_INTEGER;

    -- 연관 배열 변수 선언
    NUMARR NUM_ARR;
    
    -- 연관 배열에 저장할 변수 선언
    NUM NUMBER := 0;
BEGIN
    LOOP
        NUM := NUM + 1;
        NUMARR(NUM) := NUM;
        EXIT WHEN NUM > 5;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(NUMARR(1));
    DBMS_OUTPUT.PUT_LINE(NUMARR(2));
    DBMS_OUTPUT.PUT_LINE(NUMARR(3));
    DBMS_OUTPUT.PUT_LINE(NUMARR(4));
    DBMS_OUTPUT.PUT_LINE(NUMARR(5));
END;

-- 5-1. 레코드 연관 배열
DECLARE
    TYPE STU_REC IS RECORD(
        SNO     STUDENT.SNO%TYPE,
        SNAME    STUDENT.SNAME%TYPE,
        SEX     STUDENT.SEX%TYPE,
        SYEAR   STUDENT.SYEAR%TYPE,
        MAJOR   STUDENT.MAJOR%TYPE,
        AVR     STUDENT.AVR%TYPE
    );
    
    -- 위에서 선언한 레코드 타입의 연관 배열 선언
    TYPE STU_REC_ARR IS TABLE OF STU_REC
    INDEX BY PLS_INTEGER;
    
    -- 연관 배열 변수 선언
    STURECARR STU_REC_ARR;
    
    IDX NUMBER := 1;
BEGIN
    LOOP
        SELECT DECODE(MOD(IDX, 2), 0, '남', '여') INTO STURECARR(IDX).SEX
          FROM DUAL;
      
        STURECARR(IDX).SNO      := TO_CHAR(10000 + IDX);
        STURECARR(IDX).SNAME    := '학생' || (10000 + IDX);
        STURECARR(IDX).SYEAR    := MOD(IDX, 4) + 1;
        STURECARR(IDX).MAJOR    := '컴공';
        STURECARR(IDX).AVR      := MOD(IDX, 4) + 0.24;
    
        -- 데이터 저장
        INSERT INTO STUDENT_RECORD
        VALUES STURECARR(IDX);
        COMMIT;
    
        IDX := IDX + 1;
        EXIT WHEN IDX  >= 10;
    END LOOP;
    
END;


SELECT *
  FROM STUDENT_RECORD
 WHERE SNO LIKE '1000%';

-- 7-2. 연관 배열을 ROWTYPE으로 생성해서
-- STUDENT_RECORD 테이블에 SNO 20001 ~ 20009까지 학생을 저장하세요.
-- SNO, SNAME, SEX, SYEAR, MAJOR, AVR은 위의 내용 참고
DECLARE
    -- STU_REC_ARR2(1)  => SNO, SNAME, SEX, SYEAR, MAJOR, AV
    -- STU_REC_ARR2(2)  => SNO, SNAME, SEX, SYEAR, MAJOR, AV
    -- STU_REC_ARR2(3)  => SNO, SNAME, SEX, SYEAR, MAJOR, AV
    -- LIST<STUDENT_RECORD%ROWTYPE> LIST = NEW ARRAYLIST<STUDENT_RECORD%ROWTYPE>();
    TYPE STU_REC_ARR2 IS TABLE OF STUDENT_RECORD%ROWTYPE
    INDEX BY PLS_INTEGER;

    STURECARR2 STU_REC_ARR2;

    IDX NUMBER := 1;
BEGIN
    LOOP
        SELECT DECODE(MOD(IDX, 2), 0, '남', '여') INTO STURECARR2(IDX).SEX
              FROM DUAL;
          
        STURECARR2(IDX).SNO      := TO_CHAR(20000 + IDX);
        STURECARR2(IDX).SNAME    := '학생' || (20000 + IDX);
        STURECARR2(IDX).SYEAR    := MOD(IDX, 2) + 1;
        STURECARR2(IDX).MAJOR    := '소프트웨어';
        STURECARR2(IDX).AVR      := MOD(IDX, 4) + 0.33;
    
        INSERT INTO STUDENT_RECORD
        VALUES STURECARR2(IDX);
        COMMIT;
    
        IDX := IDX + 1;
        EXIT WHEN IDX  >= 10;
    END LOOP;
END;

SELECT *
  FROM STUDENT_RECORD
 WHERE SNO LIKE '2000%';

-- 5-3. 연관 배열의 함수
DECLARE
    TYPE STU_ROW_ARR IS TABLE OF STUDENT_RECORD%ROWTYPE
    INDEX BY PLS_INTEGER;
    
    STUROWARR STU_ROW_ARR;
BEGIN
    STUROWARR(1).SNO    := '30001';
    STUROWARR(1).SNAME  := '학생30001';
    STUROWARR(1).SEX    := '남';
    STUROWARR(1).SYEAR  := 1;
    STUROWARR(1).MAJOR  := '정보통신';
    STUROWARR(1).AVR    := 1.67;

    STUROWARR(2).SNO    := '30002';
    STUROWARR(2).SNAME  := '학생30002';
    STUROWARR(2).SEX    := '여';
    STUROWARR(2).SYEAR  := 2;
    STUROWARR(2).MAJOR  := '정보통신';
    STUROWARR(2).AVR    := 3.67;

    STUROWARR(3).SNO    := '30003';
    STUROWARR(3).SNAME  := '학생30003';
    STUROWARR(3).SEX    := '남';
    STUROWARR(3).SYEAR  := 3;
    STUROWARR(3).MAJOR  := '정보통신';
    STUROWARR(3).AVR    := 2.67;

    STUROWARR(10).SNO    := '30010';
    STUROWARR(10).SNAME  := '학생30010';
    STUROWARR(10).SEX    := '남';
    STUROWARR(10).SYEAR  := 1;
    STUROWARR(10).MAJOR  := '정보통신';
    STUROWARR(10).AVR    := 0.67;

    -- COUNT: 연관 배열에 저장되어있는 데이터의 개수
    DBMS_OUTPUT.PUT_LINE(STUROWARR.COUNT);
    -- FIRST: 연관 배열에 첫 번째 데이터의 인덱스 리턴
    DBMS_OUTPUT.PUT_LINE(STUROWARR.FIRST);
    -- LAST: 연관 배열에 마지막 데이터의 인덱스 리턴
    DBMS_OUTPUT.PUT_LINE(STUROWARR.LAST);
    -- PRIOR(인덱스): 지정한 인덱스 이전의 인덱스 리턴
    DBMS_OUTPUT.PUT_LINE(STUROWARR.PRIOR(10));
    -- NEXT(인덱스): 지정한 인덱스 다음의 인덱스 리턴
    DBMS_OUTPUT.PUT_LINE(STUROWARR.NEXT(1));

    -- EXISTS(인덱스): 지정한 인덱스에 데이터가 존재하는 지 TRUE, FALSE로 리턴
    -- TRUE, FALSE로 리턴되기 때문에 출력할 수 없다. (오라클에 BOOLEAN 타입 없기 때문에)
    -- EXISTS 함수는 조건문에서 사용한다.
    IF STUROWARR.EXISTS(3) THEN
        DBMS_OUTPUT.PUT_LINE('INDEX 3의 값: ' || STUROWARR(3).SNO);
    ELSE
        DBMS_OUTPUT.PUT_LINE('INDEX 3에 값이 없습니다.');
    END IF;
END;

-- 6. 커서(CURSOR): CURSOR는 쿼리(SELECT)의 결과를 저장해두는 메모리 공간
--                 PL/SQL에서는 CURSOR를 이용해서 데이터를 조작할 수 있다.
-- 6-1. 한 행만 조회하는 CURSOR
DECLARE
    -- 커서의 선언
    CURSOR STU_CUR IS
        SELECT SNO
             , SNAME
             , SEX
             , SYEAR
             , MAJOR
             , AVR
          FROM STUDENT
         WHERE SNO = '915301';
         
     -- 커서의 조회 쿼리 결과의 값들을 담아줄 변수 선언
     -- 변수의 형태는 일반 변수, 레코드, 참조타입 변수여도 상관없다.
     -- 커서가 여러 컬럼을 조회할 때는 레코드나 ROWTYPE으로만 값을 받아서 사용할 수 있다.
     TYPE STU_REC IS RECORD(
        SNO     VARCHAR2(8),
        SNAME   STUDENT.SNAME%TYPE,
        SEX     STUDENT.SEX%TYPE,
        SYEAR   STUDENT.SYEAR%TYPE,
        MAJOR   STUDENT.MAJOR%TYPE,
        AVR     STUDENT.AVR%TYPE
     );
     
    STUREC STU_REC;
BEGIN
    -- 커서 오픈
    OPEN STU_CUR;

    -- FETCH 커서에 저장되어 있는 데이터들을 변수로 옮겨주는 작업
    FETCH STU_CUR INTO STUREC;
    
    DBMS_OUTPUT.PUT_LINE(STUREC.SNO);
    DBMS_OUTPUT.PUT_LINE(STUREC.SNAME);
    DBMS_OUTPUT.PUT_LINE(STUREC.SYEAR);
    DBMS_OUTPUT.PUT_LINE(STUREC.MAJOR);

    -- 커서 닫기
    CLOSE STU_CUR;
END;

-- 6-2. 여러 개 행을 저장하고 있는 커서
DECLARE
    CURSOR STU_CUR IS
        SELECT SNO
             , SNAME
             , SEX
             , SYEAR
             , MAJOR
             , AVR
          FROM STUDENT;
          
    STUDENT_ROW STUDENT%ROWTYPE;
BEGIN
    OPEN STU_CUR;

    LOOP
        -- FETCH: 한 행에 대한 데이터만 꺼내온다.
        FETCH STU_CUR INTO STUDENT_ROW;
    
        DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SNO);
        DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SNAME);
        DBMS_OUTPUT.PUT_LINE('--------------------');
    
        -- 커서명%NOTFOUND: 더 이상 꺼내올 데이터가 없으면 TRUE, 데이터가 있으면 FALSE
        EXIT WHEN STU_CUR%NOTFOUND;
    END LOOP;
    
    CLOSE STU_CUR;
END;

-- FOR LOOP에서는 CURSOR의 OPEN, FETCH, CLOSE가 자동으로 이뤄진다.
DECLARE
    CURSOR STU_CUR IS
        SELECT SNO
             , SNAME
             , SEX
             , SYEAR
             , MAJOR
             , AVR
          FROM STUDENT;
-- FOR LOOP에서는 선언하지 않은 변수를 사용할 수 있다.          
--    STUDENT_ROW STUDENT%ROWTYPE;
BEGIN
    FOR STUDENT_ROW IN STU_CUR LOOP
        DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SNO);
        DBMS_OUTPUT.PUT_LINE(STUDENT_ROW.SNAME);
        DBMS_OUTPUT.PUT_LINE('--------------------');
    END LOOP;
END;

-- 6-3. 커서 파라미터: 커서를 선언할 때 파라미터도 함께 선언해서 고정적인 쿼리의 결과가 아닌
--                유동적인 쿼리의 결과를 커서에 저장하는 기능
--                커서를 오픈할 때 파라미터로 지정한 데이터 타입의 값을 함께 넘겨준다.
DECLARE
    -- 파라미터가 있는 커서의 선언
    -- 파라미터들의 조회 쿼리의 조건절(WHERE 절)에서 사용해서 유동적인 쿼리를 실행할 수 있게 해준다.
    CURSOR STU_CUR(PARAM_SYEAR NUMBER, PARAM_AVR NUMBER) IS
        SELECT SNO
             , SNAME
             , SYEAR
             , MAJOR
             , AVR
          FROM STUDENT
         WHERE SYEAR = PARAM_SYEAR
           AND AVR >= PARAM_AVR;
    
    TYPE STU_REC IS RECORD(
        SNO         STUDENT.SNO%TYPE,
        SNAME       STUDENT.SNAME%TYPE,
        SYEAR       STUDENT.SYEAR%TYPE,
        MAJOR       STUDENT.MAJOR%TYPE,
        AVR         STUDENT.AVR%TYPE
    );
    
    STUREC STU_REC;
BEGIN
    -- 커서를 오픈할 때 지정된 파라미터 데이터타입의 값들을 전달한다.
    OPEN STU_CUR(1, 2.7);

    LOOP
        FETCH STU_CUR INTO STUREC;
    
        DBMS_OUTPUT.PUT_LINE('1학년 학생 중 평점이 2.7이상인 학생목록');
        DBMS_OUTPUT.PUT_LINE(STUREC.SNO);
        DBMS_OUTPUT.PUT_LINE(STUREC.SNAME);
        DBMS_OUTPUT.PUT_LINE(STUREC.SYEAR);
        DBMS_OUTPUT.PUT_LINE(STUREC.MAJOR);
        DBMS_OUTPUT.PUT_LINE(STUREC.AVR);
        DBMS_OUTPUT.PUT_LINE('--------------');
    
        EXIT WHEN STU_CUR%NOTFOUND;
    END LOOP;

    CLOSE STU_CUR;
    
    -- CLOSE된 커서는 OPEN으로 다시 열어서 사용할 수 있다.
    OPEN STU_CUR(3, 1.5);

    LOOP
        FETCH STU_CUR INTO STUREC;
    
        DBMS_OUTPUT.PUT_LINE('3학년 학생 중 평점이 1.5이상인 학생목록');
        DBMS_OUTPUT.PUT_LINE(STUREC.SNO);
        DBMS_OUTPUT.PUT_LINE(STUREC.SNAME);
        DBMS_OUTPUT.PUT_LINE(STUREC.SYEAR);
        DBMS_OUTPUT.PUT_LINE(STUREC.MAJOR);
        DBMS_OUTPUT.PUT_LINE(STUREC.AVR);
        DBMS_OUTPUT.PUT_LINE('--------------');
    
        EXIT WHEN STU_CUR%NOTFOUND;
    END LOOP;
    
    CLOSE STU_CUR;
END;

-- 부서번호와 급여를 파라티머로 받는 커서를 선언하고
-- 파라미터로 전달된 부서번호와 부서번호가 같고 파라미터로 전달된 급여이상되는 급여를 받는 사원 목록을 조회
-- EMP 테이블의 모든 컬럼을 조회
-- 커서의 데이터를 받는 변수는 EMP ROWTYPE 변수
DECLARE
    CURSOR EMP_CUR(PARAM_DNO VARCHAR2, PARAM_SAL NUMBER) IS
        SELECT *
          FROM EMP
         WHERE DNO = PARAM_DNO
           AND SAL >= PARAM_SAL;
       
    EMP_ROW EMP%ROWTYPE;
BEGIN
    OPEN EMP_CUR('01', 3000);
    
    LOOP
        FETCH EMP_CUR INTO EMP_ROW;
        
        EXIT WHEN EMP_CUR%NOTFOUND;
    
        DBMS_OUTPUT.PUT_LINE('01번 부서의 연봉이 3000이상인 사원 목록');
        DBMS_OUTPUT.PUT_LINE(EMP_ROW.ENO);
        DBMS_OUTPUT.PUT_LINE(EMP_ROW.ENAME);
        DBMS_OUTPUT.PUT_LINE(EMP_ROW.SAL);
        DBMS_OUTPUT.PUT_LINE(EMP_ROW.DNO);
        DBMS_OUTPUT.PUT_LINE('--------------------------');
    END LOOP;
    
    CLOSE EMP_CUR;
END;

-- 6-4. 묵시적 커서: 쿼리를 실행하면 쿼리의 실행 결과를 오라클 내부에서 저장하고 있는데
--               오라클 내부에 저장된 쿼리의 결과를 확인할 수 있는 커서.
--               따로 커서를 선언하지 않고 사용할 수 있는 커서.
--               SQL%NOTFOUND, SQL%FOUND, SQL%ROWCOUNT, SQL%ISOPEN 속성만 사용할 수 있다.
--               묵시적 커서는 DML에서도 사용이 가능하다.
BEGIN
    UPDATE STUDENT_RECORD
       SET SYEAR = 5
     WHERE SYEAR = 4;
 
    -- 묵시적 커서를 이용해서 위 쿼리에 영향받은 행의 개수를 가져올 수 있다.
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
    
    COMMIT;
END;

-- 7. 예외처리: EXCEPTION 부에서 PL/SQL이 동작하다가 발생할 수 있는 예외에 대한 처리를 작성한다.
DECLARE
    VAL_SNO NUMBER;
BEGIN
--    SELECT SNAME INTO VAL_SNO
--      FROM STUDENT
--     WHERE SNO = '915301';
    SELECT SYEAR INTO VAL_SNO
      FROM STUDENT;
 
    DBMS_OUTPUT.PUT_LINE('예외 발생 시 COMMIT 실행안됨');
    COMMIT;
EXCEPTION
    WHEN VALUE_ERROR THEN 
        DBMS_OUTPUT.PUT_LINE('수치가 부적합합니다.');
        -- EXCEPTION 부에서는 대부분 PL/SQL에서 에러가 발생했을 때
        -- 데이터의 저장, 수정, 삭제되는 것을 막기위해
        -- ROLLBACK;을 사용한다.
        ROLLBACK;
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('쿼리의 결과가 한 행이 아닙니다.');
        ROLLBACK;
END;

-- 7-1. 예외처리부에서 사용할 수 있는 속성
-- SQLCODE: 에러코드를 리턴해주는 속성
-- SQLERRM: 에러 메시지를 리턴해주는 속성
DECLARE
    VAR_SYEAR     VARCHAR2(10);
BEGIN
    VAR_SYEAR := 'A';

    UPDATE STUDENT_RECORD
       SET SYEAR = 'A'
     WHERE SNO = '33333333';
    
    COMMIT;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('쿼리의 결과가 한 행이 아닙니다.');
        ROLLBACK;
    -- 지정된 예외 이름 말고 다른 예외들을 처리할 때는 OTHERS를 사용한다.
    -- 자바에서 마지막 CATCH에 최상위 클래스인 EXCEPTION을 사용하는 것과 동일하다.
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('에러 발생');
        DBMS_OUTPUT.PUT_LINE(SQLCODE);
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('롤백 완료');
END;
