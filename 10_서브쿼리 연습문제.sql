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