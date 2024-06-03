--1) 과목번호, 과목이름, 과목별 평균 기말고사 성적을 갖는 레코드의 배열을 만들고
--   기본 LOOP문을 이용해서 모든 과목의 과목번호, 과목이름, 과목별 평균 기말고사 성적을 출력하세요.
--1) 과목번호, 과목이름, 과목별 평균 기말고사 성적을 갖는 레코드의 배열을 만들고
--   기본 LOOP문을 이용해서 모든 과목의 과목번호, 과목이름, 과목별 평균 기말고사 성적을 출력하세요.
DECLARE
    CURSOR CR_RC_CUR IS
        SELECT CR.CNO
             , CR.CNAME
             , ROUND(AVG(SC.RESULT), 2)
          FROM COURSE CR
          JOIN SCORE SC
            ON CR.CNO = SC.CNO
         GROUP BY CR.CNO
                , CR.CNAME;

    TYPE CR_REC IS RECORD(
        CNO         COURSE.CNO%TYPE,
        CNAME       COURSE.CNAME%TYPE,
        COURSE_AVG  NUMBER
    );

    TYPE CR_REC_ARR IS TABLE OF CR_REC
    INDEX BY PLS_INTEGER;
    
    CRREC CR_REC;                                       -- 1.

    CRRECARR CR_REC_ARR;
    IDX NUMBER := 1;
BEGIN
    OPEN CR_RC_CUR;

    LOOP
--        FETCH CR_RC_CUR INTO CRRECARR(IDX);           -- 2. 커서에 있는 값을 배열에 바로 담을 수 있다.
        FETCH CR_RC_CUR INTO CRREC;                     -- record 타입의 변수를 담으려면 1.처럼 값을 담을 수 있는 변수를 만들어야 한다.
        CRRECARR(IDX) := CRREC;                         -- 
        EXIT WHEN CR_RC_CUR%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(CRRECARR(IDX).CNO);
        DBMS_OUTPUT.PUT_LINE(CRRECARR(IDX).CNAME);
        DBMS_OUTPUT.PUT_LINE(CRRECARR(IDX).COURSE_AVG);
        
        IDX := IDX + 1;
    END LOOP;
END;
/

--2) 학생번호, 학생이름과 학생별 평균 기말고사 성적을 갖는 테이블 T_STAVGSC를 만들고
--   커서를 이용하여 학생번호, 학생이름, 학생별 평균 기말고사 성적을 조회하고 
--   조회된 데이터를 생성한 테이블인 T_STAVGSC에 저장하세요.
CREATE TABLE T_STAVGSC(
    SNO             VARCHAR2(8),
    SNAME           VARCHAR2(20),
    AVG_RESULT      NUMBER  
);

DECLARE
    CURSOR ST_AVG_CUR IS
        SELECT ST.SNO
             , ST.SNAME
             , ROUND(AVG(SC.RESULT), 2)
          FROM STUDENT ST
          JOIN SCORE SC
            ON ST.SNO = SC.SNO;
    T_STAVGSC_ROW T_STAVGSC%ROWTYPE;
BEGIN
    OPEN ST_AVG_CUR;
    
    LOOP
        FETCH ST_AVG_CUR INTO T_STAVGSC_ROW;
        
        EXIT WHEN ST_AVG_CUR%NOTFOUND;
        
        INSERT INTO T_STAVGSC VALUES T_STAVGSC_ROW;
    END LOOP;
    
    CLOSE ST_AVG_CUR;
END;

SELECT *
  FROM T_STAVGSC