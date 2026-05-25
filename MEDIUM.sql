--Show unique birth years from patients and order them by ascending.
SELECT DISTINCT YEAR(birth_date) AS birth_year
From patients
ORDER BY birth_year ASC;

--Show unique first names from the patients table which only occurs once in the list.
--For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.
SELECT DISTINCT(first_name)
From patients
GROUP BY first_name
HAVING COUNT(first_name)=1
ORDER BY first_name ASC;

--Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
SELECT patient_id,first_name
From patients
WHERE first_name LIKE 's____%s';

--Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
--Primary diagnosis is stored in the admissions table.
SELECT patients.patient_id,first_name,last_name
From patients
JOIN admissions 
ON admissions.patient_id=patients.patient_id
WHERE diagnosis='Dementia';
