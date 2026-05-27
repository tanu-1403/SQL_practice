--Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group.
--Order the list by the weight group decending.
--For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

SELECT COUNT(patient_id) AS patient_in_group, FLOOR(weight/10)*10 AS weight_group
FROM patients
GROUP BY FLOOR(weight/10)
ORDER BY weight desc;

--Show patient_id, weight, height, isObese from the patients table.Display isObese as a boolean 0 or 1.
--Obese is defined as weight(kg)/(height(m)2) >= 30.weight is in units kg. height is in units cm.

SELECT patient_id,weight,height,
        CASE 
            WHEN weight/POWER(height/100.0,2)>=30 THEN 1 
            ELSE 0 
        END AS isObese
FROM patients;

--Show patient_id, first_name, last_name, and attending doctor's specialty.
--Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'

SELECT patients.patient_id,
		patients.first_name AS patient_first_name,
        patients.last_name AS patient_last_name,
        doctors.specialty AS attending_doctor_specialty
FROM patients
		JOIN admissions ON patients.patient_id=admissions.patient_id
        JOIN doctors on admissions.attending_doctor_id=doctors.doctor_id
WHERE admissions.diagnosis='Epilepsy' AND doctors.first_name='Lisa';

--All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
/*
The password must be the following, in order:
1. patient_id
2. the numerical length of patient's last_name
3. year of patient's birth_date
*/

SELECT DISTINCT admissions.patient_id,
	CONCAT(patients.patient_id,len(patients.last_name),YEAR(patients.birth_date)) AS temp_password
FROM patients
	JOIN admissions ON patients.patient_id=admissions.patient_id;

/*
Each admission costs $50 for patients without insurance, and $10 for patients with insurance. 
All patients with an even patient_id have insurance.
Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance.
Add up the admission_total cost for each has_insurance group.
*/

SELECT 
	CASE 
        WHEN patient_id%2=0 THEN 'Yes'
        ELSE 'No'
    END AS has_insurance,
    SUM(CASE
        WHEN patient_id%2=0 THEN 10
        ELSE 50
    END) AS cost_after_insurance
FROM admissions 
GROUP BY has_insurance;

--Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name

SELECT province_name
From patients
RIGHT JOIN province_names
WHERE  patients.province_id=province_names.province_id 
GROUP BY province_name
HAVING COUNT(CASE WHEN gender ="M" THEN 1 END)>COUNT(CASE WHEN gender="F" THEN 1 END) ;

/*
We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
- First_name contains an 'r' after the first two letters.
- Identifies their gender as 'F'
- Born in February, May, or December
- Their weight would be between 60kg and 80kg
- Their patient_id is an odd number
- They are from the city 'Kingston'
*/

SELECT * 
FROM patients 
WHERE first_name LIKE '__r%' 
	AND gender='F' 
    AND MONTH(birth_date) IN (2,5,12) 
    AND weight between 60 AND 80 
    AND patient_id%2!=0 
    AND city='Kingston';

--Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.

SELECT CONCAT(ROUND(COUNT(*) *100.0/(SELECT COUNT(*) FROM patients),2), '%')as percent_of_male_patients
FROM patients
WHERE gender='M';

--For each day display the total amount of admissions on that day. Display the amount changed from the previous date.

SELECT admission_date,
	COUNT(*) AS admission_day,
    COUNT(*)-LAG(COUNT(*)) OVER(
    ORDER BY admission_date
    ) AS admission_count_change
FROM admissions
GROUP BY admission_date;

--Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.

SELECT province_name
From province_names
ORDER BY (CASE WHEN province_name IS 'Ontario' THEN 0 ELSE 1 END), province_name;

--We need a breakdown for the total amount of admissions each doctor has started each year. 
--Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.

SELECT DISTINCT doctors.doctor_id,
		CONCAT(doctors.first_name,' ',doctors.last_name) AS doctor_name,
        doctors.specialty,
        YEAR(admissions.admission_date) AS selected_year,
        COUNT(*) AS total_admissions
From doctors
		LEFT join admissions on doctors.doctor_id=admissions.attending_doctor_id
GROUP BY doctors.doctor_id,
		doctor_name,
        doctors.specialty,
        YEAR(admissions.admission_date)
ORDER BY doctor_id;