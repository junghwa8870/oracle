/*
���� 1.
-EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� �����͸� ��� �ϼ��� 
(AVG(�÷�) ���)
-EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� ���� ����ϼ���
-EMPLOYEES ���̺��� job_id�� IT_PROG�� ������� ��ձ޿����� ���� ������� 
�����͸� ����ϼ���
*/
SELECT * 
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);


SELECT COUNT(*) AS �����޿������
FROM employees
WHERE salary > (SELECT AVG(salary) from employees);


SELECT *
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees 
                WHERE job_id = 'IT_PROG');

/*
���� 2.
-DEPARTMENTS���̺��� manager_id�� 100�� �μ��� �����ִ� �������
��� ������ ����ϼ���.
*/
SELECT e.*
FROM departments d
JOIN employees e
ON d.manager_id = e.manager_id
WHERE d.manager_id = 100;

SELECT * FROM employees
WHERE department_id = (SELECT department_id FROM departments
                        WHERE manager_id = 100);
/*
���� 3.
-EMPLOYEES���̺��� ��Pat���� manager_id���� ���� manager_id�� ���� ��� ����� �����͸� 
����ϼ���
-EMPLOYEES���̺��� ��James��(2��)���� manager_id�� ���� ��� ����� �����͸� ����ϼ���.
*/
SELECT *
FROM employees
WHERE manager_id > (
    SELECT manager_id
    FROM employees
    WHERE first_name = 'Pat'
    );
    
SELECT *
FROM employees
WHERE manager_id IN (
    SELECT manager_id
    FROM employees
    WHERE first_name = 'James'
    );
/*
���� 4.
-EMPLOYEES���̺� ���� first_name�������� �������� �����ϰ�, 41~50��° �������� 
�� ��ȣ, �̸��� ����ϼ���
*/
SELECT *
FROM
    (
    SELECT
        ROWNUM AS rn, tbl.*
    FROM 
        (
        SELECT first_name
        FROM employees
        ORDER BY first_name DESC
        ) tbl
    )
WHERE rn > 40 AND rn <=50;
/*
���� 5.
-EMPLOYEES���̺��� hire_date�������� �������� �����ϰ�, 31~40��° �������� 
�� ��ȣ, ���id, �̸�, ��ȭ��ȣ, �Ի����� ����ϼ���.
*/
SELECT *
FROM
    (SELECT ROWNUM AS rn, tbl.*
    FROM
        (
        SELECT employee_id, first_name, phone_number, hire_date
        FROM employees 
        ORDER BY hire_date ASC
        ) tbl
    )
WHERE rn > 30 AND rn <=40;
/*
���� 6.
employees���̺� departments���̺��� left �����ϼ���
����) �������̵�, �̸�(��, �̸�), �μ����̵�, �μ��� �� ����մϴ�.
����) �������̵� ���� �������� ����
*/
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS �̸�,
    d.department_id
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
ORDER BY e.employee_id ASC;

/*
���� 7.
���� 6�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
*/
SELECT *
FROM
(
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS �̸�,
    e.department_id,
    (SELECT department_name
    FROM departments d
    WHERE d.department_id = e.department_id) AS dept_name
FROM employees e
)
ORDER BY e.employee_id;
    
/*
���� 8.
departments���̺� locations���̺��� left �����ϼ���
����) �μ����̵�, �μ��̸�, �Ŵ������̵�, �����̼Ǿ��̵�, ��Ʈ��_��巹��, ����Ʈ �ڵ�, ��Ƽ �� ����մϴ�
����) �μ����̵� ���� �������� ����
*/
SELECT * FROM departments;
SELECT * FROM locations;

SELECT d.department_id, d.department_name, d.manager_id, d.location_id,
        l.street_address, l.postal_code, l.city
FROM departments d
LEFT JOIN locations l
ON d.location_id = l.location_id
ORDER BY department_id ASC;

/*
���� 9.
���� 8�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
*/

SELECT d.department_id, d.department_name, d.manager_id, d.location_id,              
    (SELECT l.street_address 
    FROM locations l
    WHERE d.location_id = l.location_id
    ) AS street_address,
    (SELECT l.postal_code 
    FROM locations l
    WHERE d.location_id = l.location_id
    ) AS postal_code ,
    (SELECT l.city 
    FROM locations l
    WHERE d.location_id = l.location_id
    ) AS city 
FROM departments d
ORDER BY department_id ASC;
/*
���� 10.
locations���̺� countries ���̺��� left �����ϼ���
����) �����̼Ǿ��̵�, �ּ�, ��Ƽ, country_id, country_name �� ����մϴ�
����) country_name���� �������� ����
*/
SELECT * FROM countries;
SELECT * FROM locations;

SELECT l.location_id, l.street_address, l.city, 
        l.country_id, c.country_name
FROM locations l
LEFT JOIN countries c
ON l.country_id = c.country_id
ORDER BY country_name ASC;

/*
���� 11.
���� 10�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
*/

SELECT l.location_id, l.street_address, l.city, l.country_id, 
        (SELECT c.country_name
        FROM countries c
        WHERE c.country_id = l.country_id) AS country_name
FROM locations l
ORDER BY country_name ASC;

/*
���� 12. 
employees���̺�, departments���̺��� left���� hire_date�� �������� �������� 
11-20��° �����͸� ����մϴ�.
����) rownum�� �����Ͽ� ��ȣ, �������̵�, �̸�, ��ȭ��ȣ, �Ի���, 
�μ����̵�, �μ��̸� �� ����մϴ�.
����) hire_date�� �������� �������� ���� �Ǿ�� �մϴ�. rownum�� Ʋ������ �ȵ˴ϴ�.
*/
SELECT * FROM
    (
    SELECT ROWNUM AS rn, tbl.*
    FROM
        (
        SELECT e.employee_id, e.first_name, e.phone_number, e.hire_date,
                d.department_id, d.department_name
        FROM employees e
        LEFT JOIN departments d
        ON e.department_id = d.department_id
        ORDER BY hire_date ASC
        ) tbl
    )
WHERE rn > 10 AND rn <= 20;

/*
���� 13. 
--EMPLOYEES �� DEPARTMENTS ���̺��� JOB_ID�� SA_MAN ����� ������ LAST_NAME, JOB_ID, 
DEPARTMENT_ID,DEPARTMENT_NAME�� ����ϼ���.
*/
SELECT e.last_name, e.job_id, e.department_id,
    (SELECT d.department_name
    FROM departments d
    WHERE e.department_id = d.department_id) tbl
FROM employees e
WHERE job_id = 'SA_MAN';

SELECT
    tbl.*, d.department_name
FROM
    (
    SELECT
        last_name, job_id, department_id
    FROM employees
    WHERE job_id = 'SA_MAN'
    ) tbl
JOIN departments d
ON tbl.department_id = d.department_id;

/*
���� 14
-- DEPARTMENTS ���̺��� �� �μ��� ID, NAME, MANAGER_ID�� �μ��� ���� �ο����� ����ϼ���.
-- �ο��� ���� �������� �����ϼ���.
-- ����� ���� �μ��� ������� �ʽ��ϴ�.
*/
-- GROUP BY�� ����ϴ� ����: ���� �Լ��� �Բ� ���: COUNT, SUM, AVG, MAX, MIN ���� ���� �Լ��� �Բ� ���
-- �׷� ������ �����͸� ������ �� �ֽ��ϴ�
-- ���ú��� �Ǹŷ��� �ջ��ϰų�, �μ����� ���� ���� ����ϴ� ���� �۾��� �̿� �ش��մϴ�.

SELECT
    d.department_id, d.department_name, d.manager_id,
    a.total
FROM departments d
JOIN
    (
    SELECT
        department_id, COUNT(*) AS total
    FROM employees
    GROUP BY department_id
    ) a
ON d.department_id = a.department_id
ORDER BY a.total DESC;

SELECT
    d.department_id, d.department_name, d.manager_id,
    (
    SELECT COUNT(*)
    FROM employees e
    WHERE e.department_id = d.department_id
    ) AS total
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
)
ORDER BY total DESC;
/*
���� 15
--�μ��� ���� ���� ���ο�, �ּ�, �����ȣ, �μ��� ��� ������ ���ؼ� ����ϼ���.
--�μ��� ����� ������ 0���� ����ϼ���.
*/
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM locations;


SELECT
    d.*,
    loc.street_address, loc.postal_code,
    NVL(tbl.result, 0) AS �μ�����ձ޿�
FROM departments d
JOIN locations loc
ON d.location_id = loc.location_id
LEFT JOIN (
    SELECT
        department_id,
        TRUNC(AVG(salary),0) AS result
    FROM employees
    GROUP BY department_id
) tbl
ON d.department_id = tbl.department_id
ORDER BY tbl.result;

SELECT 
    d.*,
    loc.street_address, loc.postal_code,
    NVL(
     (
        SELECT
            TRUNC(AVG(salary), 0)
        FROM employees e
        WHERE e.department_id = d.department_id
     ), 
    0) AS �μ�����ձ޿�
FROM departments d
JOIN locations loc
ON d.location_id = loc.location_id
ORDER BY �μ�����ձ޿� DESC;

/*
���� 16
-���� 15 ����� ���� DEPARTMENT_ID�������� �������� �����ؼ� 
ROWNUM�� �ٿ� 1-10 ������ ������ ����ϼ���.
*/

SELECT *
FROM
    (
    SELECT ROWNUM AS rn, tbl2.*
    FROM
        (
        SELECT
            d.*,
            loc.street_address, loc.postal_code,
            NVL(tbl.result, 0) AS �μ�����ձ޿�
        FROM departments d
        JOIN locations loc
        ON d.location_id = loc.location_id
        LEFT JOIN (
            SELECT
                department_id,
                TRUNC(AVG(salary),0) AS result
            FROM employees
            GROUP BY department_id
        ) tbl
        ON d.department_id = tbl.department_id
        ORDER BY d.department_id DESC
        ) tbl2
    )
WHERE rn >= 1 AND rn <= 10;