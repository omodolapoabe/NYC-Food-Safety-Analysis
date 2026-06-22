-- Q1. WHICH VIOLATIONS ARE MOST COMMON AND WHERE DO THEY OCCUR MOST FREQUENTLY?
SELECT violation_code, boro, critical_flag, count(*) AS violation_count
FROM dohmh_nyc_inspection
GROUP BY violation_code, boro, critical_flag
ORDER BY violation_count DESC
LIMIT 10;

-- Q2. WHICH CUISINES AND NEIGHBORHOOD HAVE THE LOWEST FOOD SAFETY PERFORMANCE?
SELECT cuisine_description, nta, ROUND(AVG(score), 2) AS average_risk_score, COUNT(*) AS critical_violation
FROM dohmh_nyc_inspection
WHERE score IS NOT NULL AND critical_flag = 'Critical'
GROUP BY cuisine_description, nta
ORDER BY average_risk_score DESC, critical_violation DESC;

-- Q3. HOW DO RESTAURANT GRADES AND VIOLATIONS VARY ACROSS BOROUGHS OVERTIME? 
SELECT boro, EXTRACT(YEAR FROM inspection_date) AS inspection_year, ROUND(AVG(score), 2) AS avg_yearly_score,
		ROUND(COUNT(CASE WHEN grade = 'A' THEN 1 END) * 100 / COUNT(*), 2) AS percent_A_grades, COUNT(violation_code) AS violation_count
FROM dohmh_nyc_inspection
WHERE grade IN ('A','B','C') AND violation_code IS NOT NULL
GROUP BY boro, inspection_year
ORDER BY inspection_year, avg_yearly_score;

-- Q4. WHERE SHOULD THE CITY FOCUS INSPECTIONS, POLICIES, OR EDUCATION TO IMPROVE FOOD SAFETY?
SELECT boro, cuisine_description, COUNT(*) AS violation_count
FROM dohmh_nyc_inspection
WHERE critical_flag = 'Critical'
GROUP BY boro, cuisine_description
ORDER BY violation_count DESC
LIMIT 10;