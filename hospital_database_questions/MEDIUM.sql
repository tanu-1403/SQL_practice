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

--Display every patient's first_name.Order the list by the length of each name and then by alphabetically.
select first_name
from patients
ORDER BY LEN(first_name), first_name ASC;

--Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
select SUM(gender is "M") AS male_count,SUM(gender IS "F") AS female_count
from patients;

--Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.
select first_name,last_name,allergies
from patients
WHERE allergies='Penicillin' OR allergies='Morphine'
order by allergies ,first_name ,last_name ;

--Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
SELECT  patient_id, diagnosis
FROM admissions
GROUP BY patient_id,diagnosis
HAVING COUNT(*)>1;

--Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor"
SELECT first_name,last_name,'Patient' AS role FROM patients
    UNION ALL
SELECT first_name,last_name,'Doctor' AS role FROM doctors;

--Show all allergies ordered by popularity. Remove NULL values from query.
SELECT allergies,COUNT(*) AS total_diagnosis
FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
order by total_diagnosis DESC ;

--Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
SELECT first_name,last_name,birth_date
FROM patients
WHERE YEAR(birth_date)  BETWEEN 1970 AND 1979
order by birth_date ASC ;

--We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order EX: SMITH,jane
SELECT CONCAT(UPPER(last_name), ',' ,lower(first_name) ) AS new_name_format
From patients
ORDER BY first_name desc;

--Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
SELECT province_id, SUM(height) AS sum_height
From patients
GROUP BY province_id
HAVING SUM(height)>=7000;

--Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
SELECT MAX(weight) - MIN(weight) AS weight_delta
From patients
GROUP BY last_name
HAVING last_name='Maroni';

--Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
SELECT DAY(admission_date) AS day_number, COUNT(*) AS number_of_admissions
From admissions
GROUP BY day_number
order by number_of_admissions DESC;

--Show all columns for patient_id 542's most recent admission_date.
SELECT *
From admissions
WHERE patient_id IS 542
group by patient_id
HAVING MAX(admission_date);

--Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
--1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
--2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.
SELECT patient_id,attending_doctor_id,diagnosis
From admissions
WHERE (patient_id%2!=0 AND attending_doctor_id IN (1,5,19)) OR (attending_doctor_id like '%2%' AND LEN(patient_id)=3) ;

--Show first_name, last_name, and the total number of admissions attended for each doctor. Every admission has been attended by a doctor.
SELECT first_name,last_name,COUNT(*) AS admission_total
From doctors
JOIN admissions
on doctors.doctor_id=admissions.attending_doctor_id
GROUP BY attending_doctor_id;

--For each doctor, display their id, full name, and the first and last admission date they attended.
SELECT doctor_id,CONCAT(first_name,' ',last_name),MIN(admission_date) AS first_admission, MAX(admission_date) AS last_admission_date
From doctors
JOIN admissions
on doctors.doctor_id=admissions.attending_doctor_id
GROUP BY doctor_id;

--Display the total amount of patients for each province. Order by descending.
SELECT province_name,COUNT(patient_id) AS patient_count
From patients
JOIN province_names
on patients.province_id=province_names.province_id
GROUP BY province_name
ORDER BY patient_count DESC;

--For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
SELECT CONCAT(patients.first_name,' ',patients.last_name) AS patient_name,diagnosis,CONCAT(doctors.first_name,' ',doctors.last_name) AS doctor_name
From patients
JOIN admissions
on patients.patient_id=admissions.patient_id
JOIN doctors
on doctors.doctor_id=admissions.attending_doctor_id;

--display the first name, last name and number of duplicate patients based on their first name and last name.
--Ex: A patient with an identical name can be considered a duplicate.
SELECT first_name,last_name,COUNT(*) as num_of_duplicates
From patients
GROUP BY first_name,last_name
HAVING COUNT(*)>1;

--Display patient's full name, height in the units feet rounded to 1 decimal,weight in the unit pounds rounded to 0 decimals,
--birth_date,gender non abbreviated.
--Convert CM to feet by dividing by 30.48. Convert KG to pounds by multiplying by 2.205.
SELECT CONCAT(patients.first_name,' ',patients.last_name) AS patient_name,
              ROUND(height/30.48,1) as height,
              ROUND(weight*2.205,0) as weight,
              birth_date,
              CASE 
                    WHEN gender='M' THEN 'MALE'
					WHEN gender='F' THEN 'FEMALE' 
              END AS gender_type
From patients;

--Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.)
SELECT patients.patient_id,first_name,last_name
From patients
LEFT JOIN admissions
ON patients.patient_id=admissions.patient_id
WHERE admissions.patient_id IS NULL;

--Display a single row with max_visits, min_visits, average_visits where the maximum, minimum and average number of admissions per day is calculated. Average is rounded to 2 decimal places.
SELECT MAX(number_of_visits) AS max_visits,
              MIN(number_of_visits) AS min_visits,
              ROUND(avg(number_of_visits),2) AS average_visits
From (
  SELECT admission_date,COUNT(*) AS number_of_visits 
  FROM admissions
  GROUP BY admission_date);

--Display every patient that has at least one admission and show their most recent admission along with the patient and doctor's full name.
SELECT CONCAT(patients.first_name,' ',patients.last_name) AS patient_name,
              MAX(admission_date),
              CONCAT(doctors.first_name,' ',doctors.last_name) AS doctor_name
From patients
			JOIN admissions ON patients.patient_id=admissions.patient_id
            JOIN doctors ON doctors.doctor_id=admissions.attending_doctor_id
WHERE admissions.patient_id IS NOT NULL
GROUP BY admissions.patient_id;            
