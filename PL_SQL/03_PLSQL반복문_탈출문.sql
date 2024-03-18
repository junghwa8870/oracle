
-- WHILE문

DECLARE
    v_total NUMBER := 0;
    v_count NUMBER := 1; -- begin
BEGIN
    WHILE v_count <= 10 -- end
    LOOP
        EXIT WHEN v_count - 5; -- break
    
        v_total := v_total + v_count;
        v_count := v_count + 1; -- step
    END LOOP;
    dbms_output.put_line(v_total);
END;

-- FOR문
DECLARE
    v_num NUMBER := 7;
BEGIN
    FOR i IN 1..9 -- .을 두개 작성해서 범위를 표현
    LOOP
        dbms_output.put_line(v_num || ' x ' || i || ' = ' || v_num*i);
    END LOOP;
END;

-----
DECLARE
    v_num NUMBER := 7;
BEGIN
    FOR i IN 1..9 -- .을 두개 작성해서 범위를 표현
    LOOP
        CONTINUE WHEN MOD(i, 2) = 0;
        dbms_output.put_line(v_num || ' x ' || i || ' = ' || v_num*i);
    END LOOP;
END;


----------------------------------------------------------------------------
-- 1. 모든 구구단을 출력하는 익명 블록을 만드세요. (2 ~ 9단)
-- 짝수단만 출력해 주세요. (2, 4, 6, 8)
-- 참고로 오라클 연산자 중에는 나머지를 알아내는 연산자가 없어요. (% 없음~)

--방법1
DECLARE
    v_num1 NUMBER;
    v_num2 NUMBER;
BEGIN
    FOR v_num1 IN 2..9 LOOP
    -- 짝수단의 경우에만 출력
    IF MOD(v_num1, 2) = 0 THEN
        FOR v_num2 IN 1..9 LOOP
            dbms_output.put_line(v_num1 || ' x ' || v_num2 || ' = ' || v_num1 * v_num2);
        END LOOP;
    END IF;
    END LOOP;
END;

--방법2
BEGIN
    FOR num IN 2..9
    LOOP
        IF MOD(num, 2) = 0 THEN
            dbms_output.put_line('구구단 ' || num || '단');
            
            FOR row IN 1..9
            LOOP
            dbms_output.put_line(num || ' x ' || row || ' = ' || num * row);    
            END LOOP;
            dbms_output.put_line('-------------------------------------------');
        END IF;
    END LOOP;
END;

--방법3
BEGIN
    FOR num IN 2..9
    LOOP
        CONTINUE WHEN MOD (num, 2) = 1;
            dbms_output.put_line('구구단 ' || num || '단');
            
            FOR row IN 1..9
            LOOP
            dbms_output.put_line(num || ' x ' || row || ' = ' || num * row);    
            END LOOP;
            dbms_output.put_line('-------------------------------------------');
        
    END LOOP;
END;

-- 2. INSERT를 300번 실행하는 익명 블록을 처리하세요.
-- board라는 이름의 테이블을 만드세요. (bno, writer, title 컬럼이 존재합니다.)
-- bno는 SEQUENCE로 올려 주시고, writer와 title에 번호를 붙여서 INSERT 진행해 주세요.
-- ex) 1, test1, title1 -> 2 test2 title2 -> 3 test3 title3 ....

CREATE TABLE board (
    bno NUMBER PRIMARY KEY,
    writer VARCHAR2(30),
    title VARCHAR2(30)
);

CREATE SEQUENCE b_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 10000
    NOCYCLE
    NOCACHE;

DECLARE
    v_num NUMBER := 1;
BEGIN
    WHILE v_num <= 300
    LOOP
        INSERT INTO board
        VALUES(b_seq.NEXTVAL, 'test'||v_num, 'title'||v_num);
        v_num := v_num + 1;
    END LOOP;
END;

SELECT * FROM board
ORDER BY bno DESC;

COMMIT;









