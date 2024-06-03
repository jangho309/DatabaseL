--1) 전공과 전공별 기말고사 평균 점수를 갖는 테이블
--   T_MAJOR_AVG_RES를 생성하고 SCORE테이블과 STUDENT테이블을 참조해서
--   T_MAJOR_AVG_RES에 데이터를 저장하는 프로시저 P_MAJOR_AVG_RES를 생성하세요.
CREATE TABLE T_MAJOR_AVG_RES(
    MAJOR           VARCHAR2(20),
    AVG_RESULT      NUMBER(4,2)
);

CREATE OR REPLACE PROCEDURE P_MAJOR_AVG_RES
IS
    CURSOR MA_AVG_CUR IS
        SELECT ST.MAJOR
             , AVG(SC.RESULT)   AS  AVG_RESULT
          FROM STUDENT ST
          JOIN SCORE SC
            ON ST.SNO = SC.SNO
         GROUP BY ST.MAJOR;
            
    T_MAJOR_AVG_ROW T_MAJOR_AVG_RES%ROWTYPE;
BEGIN
    FOR MA_AVG_CUR_ROW IN MA_AVG_CUR LOOP
        INSERT INTO T_MAJOR_AVG_RES
        VALUES MA_AVG_CUR_ROW;
        COMMIT;
    END LOOP;
END;
/

EXEC P_MAJOR_AVG_RES;

SELECT *
  FROM T_MAJOR_AVG_RES
;

--2) 교수들은 부임일로부터 5년마다 안식년을 갖습니다.
--   교수들의 오늘날짜까지의 안식년 횟수를 리턴하는 함수 F_GET_VACATION_CNT를 구현하세요.
SELECT *
  FROM PROFESSOR
;

CREATE OR REPLACE FUNCTION F_GET_VACATION_CNT
(
    PARAM_HIREDATE      DATE
)
RETURN NUMBER
IS
    RETURN_FIVE_TIMES NUMBER;
BEGIN
    RETURN_FIVE_TIMES := TRUNC(MONTHS_BETWEEN(SYSDATE, PARAM_HIREDATE) / (12 * 5));
    
    RETURN RETURN_FIVE_TIMES;
END;
/

SELECT PNO
     , PNAME
     , HIREDATE
     , F_GET_VACATION_CNT(HIREDATE)    PP
  FROM PROFESSOR
;