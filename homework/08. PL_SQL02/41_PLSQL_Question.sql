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

    CRRECARR CR_REC_ARR;

    NUM NUMBER := 1;
BEGIN
    OPEN CR_RC_CUR;

    LOOP
        FETCH CR_RC_CUR INTO CR_REC;
        CRRECARR(NUM) := CR_REC;
        NUM := NUM + 1;
        
        EXIT WHEN CR_RC_CUR%NOTFOUND;
    END LOOP;
    
     DBMS_OUTPUT.PUT_LINE(CRRECARR.LAST);
END;


--2) 학생번호, 학생이름과 학생별 평균 기말고사 성적을 갖는 테이블 T_STAVGSC를 만들고
--   커서를 이용하여 학생번호, 학생이름, 학생별 평균 기말고사 성적을 조회하고 
--   조회된 데이터를 생성한 테이블인 T_STAVGSC에 저장하세요.