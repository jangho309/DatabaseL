--1) 과목번호, 과목이름, 교수번호, 교수이름을 담을 수 있는 변수들을 선언하고 
--   유기화학 과목의 과목번호, 과목이름, 교수번호, 교수이름을 출력하세요.
DECLARE
    COURSE_NO       COURSE.CNO%TYPE;
    COURSE_NAME     COURSE.CNAME%TYPE;
    PROFESSOR_NO    PROFESSOR.PNO%TYPE;
    PROFESSOR_PNAME PROFESSOR.PNAME%TYPE;
BEGIN
    SELECT CR.CNO   INTO    COURSE_NO
      FROM COURSE CR
      JOIN PROFESSOR PR
        ON CR.PNO = PR.PNO
     WHERE CR.CNAME = '유기화학';
 
    SELECT CR.CNAME   INTO    COURSE_NAME
      FROM COURSE CR
      JOIN PROFESSOR PR
        ON CR.PNO = PR.PNO
     WHERE CR.CNAME = '유기화학';
    
    SELECT PR.PNO   INTO    PROFESSOR_NO
      FROM COURSE CR
      JOIN PROFESSOR PR
        ON CR.PNO = PR.PNO
     WHERE CR.CNAME = '유기화학';
 
    SELECT PR.PNAME   INTO    PROFESSOR_PNAME
      FROM COURSE CR
      JOIN PROFESSOR PR
        ON CR.PNO = PR.PNO
     WHERE CR.CNAME = '유기화학';
 
    DBMS_OUTPUT.PUT_LINE('유기화학의 과목번호 : ' || COURSE_NO || ', 과목이름 : ' || COURSE_NAME
                         || ', 교수번호 : ' || PROFESSOR_NO || ', 교수이름 : ' || PROFESSOR_PNAME);
END;


--2) 위 데이터들을 레코드로 선언하고 출력하세요.
DECLARE
    TYPE COURSE_PROFESSOR_REC IS RECORD (
        CNO     COURSE.CNO%TYPE,
        CNAME   COURSE.CNAME%TYPE,
        PNO     PROFESSOR.PNO%TYPE,
        PNAME   PROFESSOR.PNAME%TYPE
    );
    CPR COURSE_PROFESSOR_REC;
BEGIN
    SELECT CR.CNO, CR.CNAME, PR.PNO, PR.PNAME INTO CPR
      FROM COURSE CR
      JOIN PROFESSOR PR
        ON CR.PNO = PR.PNO
     WHERE CR.CNAME = '유기화학';

    DBMS_OUTPUT.PUT_LINE('유기화학의 과목번호 : ' || CPR.CNO || ', 과목이름 : ' || CPR.CNAME
                         || ', 교수번호 : ' || CPR.PNO || ', 교수이름 : ' || CPR.PNAME);
END;
