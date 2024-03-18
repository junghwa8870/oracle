
/*
프로시저명 divisor_proc
숫자 하나를 전달받아 해당 값의 약수의 개수를 출력하는 프로시저를 선언합니다.
*/

--방법 1
CREATE OR REPLACE PROCEDURE divisor_proc (
    p_num IN NUMBER,
    p_count OUT NUMBER
)
IS
    v_divisor_count NUMBER := 0; -- 약수의 개수를 저장하는 변수
BEGIN
    -- 약수의 개수를 계산
    FOR i IN 1..p_num LOOP
        IF MOD(p_num, i) = 0 THEN
            v_divisor_count := v_divisor_count + 1;
        END IF;
    END LOOP;
    
    -- 결과를 OUT 매개변수에 할당
    p_count := v_divisor_count;
    
    -- 결과 출력
    dbms_output.put_line(p_num || '의 약수의 개수는 ' || p_count || '개 입니다.');
    
END divisor_proc;


--방법2
CREATE OR REPLACE PROCEDURE divisor_proc
    (p_num IN NUMBER)
IS 
    v_count NUMBER := 0;
BEGIN
    FOR i IN 1..p_num
    LOOP
        IF MOD(p_num, i) = 0 THEN
            v_count := v_count + 1;
        END IF;
    END LOOP;
    
     dbms_output.put_line('약수의 개수: ' || v_count || '개');
END;

-----방법 1의 실행
DECLARE
    v_num NUMBER := 24; -- 약수의 개수를 확인할 숫자
    v_count NUMBER; -- 약수의 개수를 저장할 변수
BEGIN
    divisor_proc(v_num, v_count); -- 프로시저 호출
END;

-----방법2의 실행
EXEC divisor_proc(72);


-------------------------------------------------------------------------------
/*
부서번호, 부서명, 작업 flag(I: insert, U:update, D:delete)을 매개변수로 받아 
depts 테이블에 
각각 INSERT, UPDATE, DELETE 하는 depts_proc 란 이름의 프로시저를 만들어보자.
그리고 정상종료라면 commit, 예외라면 롤백 처리하도록 처리하세요.
*/

--방법1
CREATE OR REPLACE PROCEDURE depts_proc
    (
    p_department_id IN departments.department_id%TYPE,
    p_department_name IN departments.department_name%TYPE,
    p_action_flag IN VARCHAR2
    )
IS
BEGIN
    -- INSERT 작업
    IF p_action_flag = 'I' THEN
    INSERT INTO departments (department_id, department_name)
    VALUES (p_department_id, p_department_name);
    
    -- UPDATE 작업
    ELSIF p_action_flag = 'U' THEN
    UPDATE departments
    SET department_name = p_department_name
    WHERE department_id = p_department_id;
    
    -- DELETE 작업
    ELSIF p_action_flag = 'D' THEN
    DELETE FROM departments
    WHERE department_id = p_department_id;

    END IF;
    
    -- 정상 종료 시 커밋
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        -- 예외 발생시 콜백
        ROLLBACK;
        RAISE;
END depts_proc;

--방법2
CREATE OR REPLACE PROCEDURE depts_proc
    (
        p_dept_id IN depts.department_id%TYPE,
        p_dept_name IN depts.department_name%TYPE,
        p_flag IN VARCHAR2
    )
IS
    v_cnt NUMBER := 0;
BEGIN
    
    SELECT COUNT(*)
    INTO v_count
    FROM depts
    WHERE department_id = p_dept_id;
    
    IF p_flag = 'I' THEN
        INSERT INTO depts
        (department_id, department_name)
        VALUES(p_dept_id, p_dept_name);
    ELSIF p_flag = 'U' THEN
        IF v_cnt = 0 THEN
            dbms_output.put_line('삭제하고자 하는 부서가 존재하지 않습니다.');
            RETURN;
        END IF;
        
        UPDATE depts
        SET department_name = p_dept_name
        WHERE department_id = p_dept_id;
    ELSIF p_flag = 'D' THEN
        IF v_cnt = 0 THEN
            dbms_output.put_line('삭제하고자 하는 부서가 존재하지 않습니다.');
            RETURN;
        END IF;
        DELETE FROM depts
        WHERE department_id = p_dept_id;
    ELSE
        dbms_output.put_line('해당 flag에 대한 동작이 준비되지 않았습니다.');
    END IF;
    
    COMMIT;
    
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('예외가 발생했습니다.');
            dbms_output.put_line('ERROR msg: ' || SQLERRM);
            ROLLBACK;
        
END;
-----방법1 실행
BEGIN
    depts_proc(101, 'Marketing', 'I');
END;

BEGIN
    depts_proc(101, 'Marketing', 'U');
END;

BEGIN
    depts_proc(101, NULL, 'I');
END;

-----방법2 실행
EXEC dept_proc(400, '개발부', 'I');
EXEC dept_proc(400, '영업부', 'U');
EXEC dept_proc(400, '영업부', 'D');
SELECT * FROM depts;

EXEC dept_proc(80, '영업부', 'I');

ALTER TABLE depts ADD CONSTRAINT depts_deptno_pk PRIMARY KEY(department_id);

SELECT * FROM depts;
--------------------------------------------------------------------------------

/*
employee_id를 입력받아 employees에 존재하면,
근속년수를 out하는 프로시저를 작성하세요. (익명블록에서 프로시저를 실행)
없다면 exception처리하세요
*/
-- 방법1
CREATE OR REPLACE PROCEDURE get_years_proc
    (
    p_employee_id IN employees.employee_id%TYPE,
    p_years_out OUT NUMBER
    )
IS
    v_hire_date employees.hire_date%TYPE;
BEGIN
    -- 직원의 근무 시작일을 조회
    SELECT hire_date INTO v_hire_date
    FROM employees
    WHERE employee_id = p_employee_id;

    -- 현재 날짜와의 차이를 계산하여 근속 년수를 계산
    p_years_out := ROUND(MONTHS_BETWEEN(SYSDATE, v_hire_date) / 12);

    -- 정상적으로 근무 시작일이 조회되었으므로 커밋
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    -- 해당 직원이 존재하지 않는 경우 예외 처리
        ROLLBACK;
        dbms_output.put_line('해당 직원이 존재하지 않습니다.');
    WHEN OTHERS THEN
    -- 기타 예외 발생 시 롤백 및 예외 다시 발생
    ROLLBACK;
    RAISE;
END;

--방법2
CREATE OR REPLACE PROCEDURE emp_hire_proc
    (
        p_emp_id IN employees.employee_id%TYPE,
        p_year OUT NUMBER
    )
IS
    v_hire_date employees.hire_date%TYPE;
BEGIN
    SELECT
        hire_date
    INTO
        v_hire_date
    FROM employees
    WHERE employee_id = p_emp_id;
    
    p_year := TRUNC((sysdate - v_hiredate) / 365);
    
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line(p_emp_id || '은(는) 없는 데이터 입니다.');
        p_year := 0;
    
END;


-----방법1 실행
DECLARE
    v_years NUMBER; -- 근속 년수를 받을 변수
    p_employee_id employees.employee_id%TYPE := 100; --직원 ID를 지정
BEGIN
    get_years_proc(p_employee_id => 100, p_years_out => v_years); -- 프로시저 호출
     -- 결과 출력
    dbms_output.put_line('사원번호 '||p_employee_id ||'의 '||'근속 년수: ' || v_years);
END;


-----방법2 실행
DECLARE
    v_year NUMBER;
BEGIN
    emp_hire_proc(100, v_year);
    IF v_year > 0 THEN
    dbms_output.put_line('근속년수: ' || v_year || '년');
    END IF;
END;











