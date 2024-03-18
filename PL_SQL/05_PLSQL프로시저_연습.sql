
/*
���ν����� divisor_proc
���� �ϳ��� ���޹޾� �ش� ���� ����� ������ ����ϴ� ���ν����� �����մϴ�.
*/

--��� 1
CREATE OR REPLACE PROCEDURE divisor_proc (
    p_num IN NUMBER,
    p_count OUT NUMBER
)
IS
    v_divisor_count NUMBER := 0; -- ����� ������ �����ϴ� ����
BEGIN
    -- ����� ������ ���
    FOR i IN 1..p_num LOOP
        IF MOD(p_num, i) = 0 THEN
            v_divisor_count := v_divisor_count + 1;
        END IF;
    END LOOP;
    
    -- ����� OUT �Ű������� �Ҵ�
    p_count := v_divisor_count;
    
    -- ��� ���
    dbms_output.put_line(p_num || '�� ����� ������ ' || p_count || '�� �Դϴ�.');
    
END divisor_proc;


--���2
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
    
     dbms_output.put_line('����� ����: ' || v_count || '��');
END;

-----��� 1�� ����
DECLARE
    v_num NUMBER := 24; -- ����� ������ Ȯ���� ����
    v_count NUMBER; -- ����� ������ ������ ����
BEGIN
    divisor_proc(v_num, v_count); -- ���ν��� ȣ��
END;

-----���2�� ����
EXEC divisor_proc(72);


-------------------------------------------------------------------------------
/*
�μ���ȣ, �μ���, �۾� flag(I: insert, U:update, D:delete)�� �Ű������� �޾� 
depts ���̺� 
���� INSERT, UPDATE, DELETE �ϴ� depts_proc �� �̸��� ���ν����� ������.
�׸��� ���������� commit, ���ܶ�� �ѹ� ó���ϵ��� ó���ϼ���.
*/

--���1
CREATE OR REPLACE PROCEDURE depts_proc
    (
    p_department_id IN departments.department_id%TYPE,
    p_department_name IN departments.department_name%TYPE,
    p_action_flag IN VARCHAR2
    )
IS
BEGIN
    -- INSERT �۾�
    IF p_action_flag = 'I' THEN
    INSERT INTO departments (department_id, department_name)
    VALUES (p_department_id, p_department_name);
    
    -- UPDATE �۾�
    ELSIF p_action_flag = 'U' THEN
    UPDATE departments
    SET department_name = p_department_name
    WHERE department_id = p_department_id;
    
    -- DELETE �۾�
    ELSIF p_action_flag = 'D' THEN
    DELETE FROM departments
    WHERE department_id = p_department_id;

    END IF;
    
    -- ���� ���� �� Ŀ��
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        -- ���� �߻��� �ݹ�
        ROLLBACK;
        RAISE;
END depts_proc;

--���2
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
            dbms_output.put_line('�����ϰ��� �ϴ� �μ��� �������� �ʽ��ϴ�.');
            RETURN;
        END IF;
        
        UPDATE depts
        SET department_name = p_dept_name
        WHERE department_id = p_dept_id;
    ELSIF p_flag = 'D' THEN
        IF v_cnt = 0 THEN
            dbms_output.put_line('�����ϰ��� �ϴ� �μ��� �������� �ʽ��ϴ�.');
            RETURN;
        END IF;
        DELETE FROM depts
        WHERE department_id = p_dept_id;
    ELSE
        dbms_output.put_line('�ش� flag�� ���� ������ �غ���� �ʾҽ��ϴ�.');
    END IF;
    
    COMMIT;
    
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('���ܰ� �߻��߽��ϴ�.');
            dbms_output.put_line('ERROR msg: ' || SQLERRM);
            ROLLBACK;
        
END;
-----���1 ����
BEGIN
    depts_proc(101, 'Marketing', 'I');
END;

BEGIN
    depts_proc(101, 'Marketing', 'U');
END;

BEGIN
    depts_proc(101, NULL, 'I');
END;

-----���2 ����
EXEC dept_proc(400, '���ߺ�', 'I');
EXEC dept_proc(400, '������', 'U');
EXEC dept_proc(400, '������', 'D');
SELECT * FROM depts;

EXEC dept_proc(80, '������', 'I');

ALTER TABLE depts ADD CONSTRAINT depts_deptno_pk PRIMARY KEY(department_id);

SELECT * FROM depts;
--------------------------------------------------------------------------------

/*
employee_id�� �Է¹޾� employees�� �����ϸ�,
�ټӳ���� out�ϴ� ���ν����� �ۼ��ϼ���. (�͸��Ͽ��� ���ν����� ����)
���ٸ� exceptionó���ϼ���
*/
-- ���1
CREATE OR REPLACE PROCEDURE get_years_proc
    (
    p_employee_id IN employees.employee_id%TYPE,
    p_years_out OUT NUMBER
    )
IS
    v_hire_date employees.hire_date%TYPE;
BEGIN
    -- ������ �ٹ� �������� ��ȸ
    SELECT hire_date INTO v_hire_date
    FROM employees
    WHERE employee_id = p_employee_id;

    -- ���� ��¥���� ���̸� ����Ͽ� �ټ� ����� ���
    p_years_out := ROUND(MONTHS_BETWEEN(SYSDATE, v_hire_date) / 12);

    -- ���������� �ٹ� �������� ��ȸ�Ǿ����Ƿ� Ŀ��
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    -- �ش� ������ �������� �ʴ� ��� ���� ó��
        ROLLBACK;
        dbms_output.put_line('�ش� ������ �������� �ʽ��ϴ�.');
    WHEN OTHERS THEN
    -- ��Ÿ ���� �߻� �� �ѹ� �� ���� �ٽ� �߻�
    ROLLBACK;
    RAISE;
END;

--���2
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
        dbms_output.put_line(p_emp_id || '��(��) ���� ������ �Դϴ�.');
        p_year := 0;
    
END;


-----���1 ����
DECLARE
    v_years NUMBER; -- �ټ� ����� ���� ����
    p_employee_id employees.employee_id%TYPE := 100; --���� ID�� ����
BEGIN
    get_years_proc(p_employee_id => 100, p_years_out => v_years); -- ���ν��� ȣ��
     -- ��� ���
    dbms_output.put_line('�����ȣ '||p_employee_id ||'�� '||'�ټ� ���: ' || v_years);
END;


-----���2 ����
DECLARE
    v_year NUMBER;
BEGIN
    emp_hire_proc(100, v_year);
    IF v_year > 0 THEN
    dbms_output.put_line('�ټӳ��: ' || v_year || '��');
    END IF;
END;











