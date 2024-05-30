-- 1대 1 관계
-- 부모테이블에 존재하는 데이터가 자식테이블에도 하나만 존재할 수 있는 구조
CREATE TABLE MEMBER(
    ID          NUMBER(9),
    USERNAME    VARCHAR2(100),
    PASSWORD    VARCHAR2(100),
    CONSTRAINT PK_USER_ID   PRIMARY KEY(ID)
)
;

CREATE TABLE MEMBER_DETAIL(
    ID          NUMBER(9),
    NICKNAME    VARCHAR2(100),
    TELNUM      VARCHAR2(100),
    EMAIL       VARCHAR2(100),
    CONSTRAINT PK_MEMBER_DETAIL_ID PRIMARY KEY(ID),
    CONSTRAINT FK_MEMBER_DETAIL_ID FOREIGN KEY(ID)
        REFERENCES MEMBER(ID)
)
;

INSERT INTO MEMBER
VALUES (1, 'bit', '!dkdlxl1234');
COMMIT;

INSERT INTO MEMBER_DETAIL
VALUES (1, 'bitcamp', '01011111111', 'bit@bit.com');
COMMIT;

INSERT INTO MEMBER_DETAIL
VALUES (1, 'bit1111', '01022222222', 'bit@bit.com');

SELECT M.ID
     , M.USERNAME
     , M.PASSWORD
     , MD.NICKNAME
     , MD.TELNUM
     , MD.EMAIL
  FROM MEMBER M
  JOIN MEMBER_DETAIL MD
    ON M.ID = MD.ID
 WHERE M.ID = 1
;

-- 1대 N관계, N대 1관계: 부모테이블에 존재하는 데이터가 자식테이블에 여러개 존재하는 구조
DROP TABLE BOARD;

CREATE TABLE BOARD(
    BOARD_ID        NUMBER(10),
    BOARD_TITLE     VARCHAR2(1000),
    BOARD_CONTENT   VARCHAR2(2000),
    CONSTRAINT PK_BOARD_BOARD_ID PRIMARY KEY(BOARD_ID)
)
;

CREATE TABLE BOARD_FILE_FK(
    BOARD_ID    NUMBER(10),
    FILE_ID     NUMBER(10),
    FILE_NAME   VARCHAR2(1000),
    CONSTRAINT PK_BOARD_FILE_FK_FILE_ID PRIMARY KEY(FILE_ID),
    CONSTRAINT FK_BOARD_FILE_FK_BOARD_ID FOREIGN KEY(BOARD_ID)
        REFERENCES BOARD(BOARD_ID)
)
;

INSERT INTO BOARD
VALUES (1, 'AAAA', 'AAAA');
COMMIT;

INSERT INTO BOARD_FILE_FK
VALUES (1, 1, '게시글1 - 첨부파일1');
INSERT INTO BOARD_FILE_FK
VALUES (1, 2, '게시글1 - 첨부파일2');
INSERT INTO BOARD_FILE_FK
VALUES (1, 3, '게시글1 - 첨부파일3');
COMMIT;

SELECT B.BOARD_ID
     , B.BOARD_TITLE
     , B.BOARD_CONTENT
     , BF.FILE_ID
     , BF.FILE_NAME
  FROM BOARD B
  JOIN BOARD_FILE_FK BF
    ON B.BOARD_ID = BF.BOARD_ID
;

-- N대 N관계(다대다 관계): 두 개의 테이블의 데이터가 여러개의 존재하는 N대 N관계가 매핑된구조
-- 중간에 매핑된 테이블이 필요하다
CREATE TABLE LECTURE(
    LECTURE_ID      NUMBER(9),
    LECTURE_NAME    VARCHAR2(30),
    CONSTRAINT PK_LECTURE_LECTURE_ID PRIMARY KEY(LECTURE_ID)
)
;

CREATE TABLE STUD(
    STUDENT_ID      NUMBER(9),
    STUDENT_NAME    VARCHAR2(30),
    CONSTRAINT PK_STUD_STUDENT_ID PRIMARY KEY(STUDENT_ID)
)
;

-- LECTURE테이블과 STUD테이블이 N대 N관계로 매핑된 테이블
CREATE TABLE LECTURE_STUDENT(
    LECTURE_ID      NUMBER(9),
    STUDENT_ID      NUMBER(9),
    CONSTRAINT PK_LECTURE_STUDENT_IDS PRIMARY KEY(LECTURE_ID, STUDENT_ID),
    CONSTRAINT FK_LECTURE_STUDENT_L_ID FOREIGN KEY(LECTURE_ID)
        REFERENCES LECTURE(LECTURE_ID),
    CONSTRAINT FK_LECTURE_STUDENT_S_ID FOREIGN KEY(STUDENT_ID)
        REFERENCES STUD(STUDENT_ID)
)
;

INSERT INTO LECTURE
VALUES(1, '자바');
INSERT INTO LECTURE
VALUES(2, '오라클');
COMMIT;

INSERT INTO STUD
VALUES(1, '조장호');
INSERT INTO STUD
VALUES(2, '홍길동');
INSERT INTO STUD
VALUES(3, '장길산');
COMMIT;

INSERT INTO LECTURE_STUDENT
VALUES (1, 1);
INSERT INTO LECTURE_STUDENT
VALUES (1, 2);
INSERT INTO LECTURE_STUDENT
VALUES (1, 3);

INSERT INTO LECTURE_STUDENT
VALUES (2, 1);
COMMIT;

SELECT LS.LECTURE_ID
     , L.LECTURE_NAME
     , LS.STUDENT_ID
     , S.STUDENT_NAME
  FROM LECTURE_STUDENT LS
  JOIN LECTURE L
    ON LS.LECTURE_ID = L.LECTURE_ID
  JOIN STUD S
    ON LS.STUDENT_ID = S.STUDENT_ID
;

-- 1-3. UNIQUE KEY(UK): 중복값을 허용하지 않는 제약조건
--                      PK가 중복값 불가, INDEX, NOT NULL 제약조건을 가지고 있는 반면
--                      UK는 중복값 저장 불가만 가지고 있는 제약 조건이다. 그래서 NULL값이 저장된다.
CREATE TABLE EMP_UK(
    ENO     NUMBER(4)       CONSTRAINT PK_EMP_UK_ENO PRIMARY KEY,
    ENAME   VARCHAR2(20)    CONSTRAINT UK_EMP_UK_ENAME UNIQUE
)
;

-- UK는 중복된 값만 저장을 방지하는 제약조건
INSERT INTO EMP_UK
VALUES (1, '조장호');
COMMIT;
INSERT INTO EMP_UK
VALUES (2, '조장호');

INSERT INTO EMP_UK
VALUES (2, '조장호B');
COMMIT;

-- UK로 지정된 컬럼에는 NULL값이 저장되고 NULL값은 중복도 허용된다.
INSERT INTO EMP_UK
VALUES (3, NULL);
INSERT INTO EMP_UK
VALUES (4, NULL);
COMMIT;

SELECT *
  FROM EMP_UK
;

-- 컬럼을 모두 지정하고 UK 지정
CREATE TABLE DEPT_UK(
    DNO     NUMBER(4),
    DNAME   VARCHAR2(20),
    CONSTRAINT PK_DEPT_UK_DNO PRIMARY KEY(DNO),
    CONSTRAINT UK_DEPT_UK_DNAME  UNIQUE(DNAME)
)
;

-- 기존 테이블에 UK 추가
ALTER TABLE PROFESSOR
    ADD CONSTRAINT UK_PROFESSOR_PNO UNIQUE(PNO)
;

-- UK 삭제
-- 제약조건 명으로만 삭제 가능하다.
ALTER TABLE DEPT_UK
    DROP CONSTRAINT UK_DEPT_UK_DNAME
;

-- 1-4. CHECK: 컬럼에 저장되는 데이터에 조건을 달아주는 제약조건
--             CHECK가 지정되어 있는 컬럼의 데이터는 CHECK에 지정된 조건에 부합하는 데이터만 저장될 수 있다.
CREATE TABLE EMP_CHK (
    ENO     NUMBER(4)       PRIMARY KEY,
    ENAME   VARCHAR2(20)    UNIQUE,
    SAL     NUMBER(5, 0)    CHECK(SAL >= 3000),
    COMM   NUMBER(5, 0),
    CONSTRAINT CHK_EMP_CHK_COMM CHECK(COMM BETWEEN 100 AND 1000)
)
;

-- CHECK 조건에 맞는 데이터 저장
INSERT INTO EMP_CHK
VALUES (1, '홍길동', 3000, 300);
INSERT INTO EMP_CHK
VALUES (2, '조장호', 3100, 150);
COMMIT;

-- CHECK 조건에 맞지 않는 데이터의 저장
INSERT INTO EMP_CHK
VALUES (3, '장길산', 2800, 150);
INSERT INTO EMP_CHK
VALUES (4, '임꺽정', 4500, 90);


-- 1-5. NOT NULL:컬럼 데이터로 NULL에 저장되지 않게 막아주는 제약조건
CREATE TABLE EMP_NOT_NULL (
    ENO         NUMBER(4) PRIMARY KEY,
    ENAME       VARCHAR(20) UNIQUE NOT NULL,
    JOB         VARCHAR2(10) NOT NULL CHECK(JOB = '개발'),
    DNO         NUMBER(4) FOREIGN KEY REFERENCES DEPT_PK1(DNO) NOT NULL
)
;

-- NOT NULL 제약조건이 지정된 컬럼의 데이터로 NULL 저장하면 에러가 발생한다.
INSERT INTO EMP_NOT_NULL
VALUES (1, '조장호', NULL);
INSERT INTO EMP_NOT_NULL
VALUES (2, NULL, '개발');

-- 기존 테이블에 NOT NULL 제약조건 추가
ALTER TABLE PROFESSOR
    MODIFY PNO VARCHAR(8) NOT NULL
;

-- 1-6. DEFAULT: 특정 컬럼의 데이터가 NULL로 오거나 들어오지 않았을 때를 대비해서 기본값을 지정해놓는 제약조건
-- DBMS마다 DEFAULT와 NOT NULL의 순서 차이가 있지만
-- 기본적으로 DEFAULT 제약조건이 먼저 설정돼야 하는 DBMS가 대부분이다.
CREATE TABLE EMP_DEFAULT(
    ENO         NUMBER(4)       PRIMARY KEY,
    ENAME       VARCHAR2(20)    UNIQUE NOT NULL,
    JOB         VARCHAR2(10)    DEFAULT '개발' NOT NULL,
    HDATE       DATE            DEFAULT SYSDATE NOT NULL,
    DNO         NUMBER(4)       DEFAULT 0 NOT NULL
)
;

-- DEFAULT 값이 지정된 컬럼을 제외한 나머지 컬럼들에 데이터 저장
INSERT INTO EMP_DEFAULT(ENO, ENAME)
VALUES (1, '조장호');
COMMIT;

SELECT *
  FROM EMP_DEFAULT
;

-- 1-7. 제약조건이 모두 추가된 CREATE TABLE 구문
-- FNO(PK, NUMBER(10)), FNAME(VARCHAR2(50), NOT NULL, UNIQUE),
-- LOC(VARCHAR2(10), DEFAULT '서울', NOT NULL) 컬럼을 갖는 FACTORY1 테이블을 생성하세요.
DROP TABLE FACTORY1;

CREATE TABLE FACTORY1(
    FNO         NUMBER(10)      CONSTRAINT PK_FACTORY1_FNO PRIMARY KEY,
    FNAME       VARCHAR2(50)    CONSTRAINT UK_FACTORY1_FNAME UNIQUE NOT NULL,
    LOC         VARCHAR2(10)    DEFAULT '서울' NOT NULL
)
;
-- GNO(NUMBER(5), PK), GNAME(VARCHAR2(50), NOT NULL), PRI(NUMBER(5), DEFALUT 10000)
-- FNO(NUMBER(10), FK(FACTORY1의 FNO), NOT NULL) 컬럼을 갖는 GOODS1 테이블을 생성하세요.
DROP TABLE GOODS1;
CREATE TABLE GOODS1(
    GNO         NUMBER(5)       CONSTRAINT PK_GOODS1_GNO PRIMARY KEY,
    GNAME       VARCHAR2(50)    NOT NULL,
    PRI         NUMBER(5)       DEFAULT 10000,
    FNO         NUMBER(10)      CONSTRAINT FK_GOODS1_FNO REFERENCES FACTORY1(FNO) NOT NULL
)
;
-- PNO(NUMBER(6), PK), GNO(NUMBER(5), FK(GOODS1의 GNO), NOT NULL),
-- PRICE(NUMBER(5), DEFAULT 7000), PDATE(DATE, DEFAULT SYSDATE, NOT NULL)
-- 컬럼을 갖는 PROD1 테이블을 생성하세요.
DROP TABLE PROD1;
CREATE TABLE PROD1(
    PNO         NUMBER(6)       CONSTRAINT PK_PROD1_PNO PRIMARY KEY,
    GNO         NUMBER(5)       CONSTRAINT FK_PROD1_GNO REFERENCES GOODS1(GNO) NOT NULL,
    PRICE       NUMBER(5)       DEFAULT 7000,
    PDATE       DATE            DEFAULT SYSDATE NOT NULL
)

