use healthcare;

--Evaluating Financial Risk by Encounter Outcome--

SELECT 
    REASONCODE,
    SUM(TOTAL_CLAIM_COST - PAYER_COVERAGE) AS TotalUncoveredCost,
    COUNT(*) AS NumberOfEncounters,
    AVG(TOTAL_CLAIM_COST - PAYER_COVERAGE) AS AvgUncoveredCost
FROM 
    encountersss
GROUP BY 
    REASONCODE
ORDER BY 
    TotalUncoveredCost DESC;


--Identifying Patients with Frequent High-Cost Encounters--

SELECT 
    ID,
    COUNT(*) AS NumberOfHighCostEncounters,
    SUM(CAST(TOTAL_CLAIM_COST AS DECIMAL(10,2))) AS TotalEncounterCost
FROM 
    Encounters
WHERE 
    CAST(TOTAL_CLAIM_COST AS DECIMAL(10,2)) > 10000  
    AND YEAR(START) = 2023  
GROUP BY 
    ID
HAVING 
    COUNT(*) > 3
ORDER BY 
    TotalEncounterCost DESC;


SELECT 
    COUNT(*)
FROM 
    Encounters
WHERE 
    YEAR(START) = 2023
    AND CAST(TOTAL_CLAIM_COST AS DECIMAL(10,2)) > 10000;

    
--Assessing Payer Contributions for Different Procedure Types--

SELECT
    DESCRIPTION,
    PAYER,
    COUNT(*) AS total_claims,
    AVG(BASE_ENCOUNTER_COST) AS avg_BASE_ENCOUNTER_COST,
    AVG(TOTAL_CLAIM_COST) AS avg_TOTAL_CLAIM_COST,
    AVG(PAYER_COVERAGE) AS avg_PAYER_COVERAGE,
    AVG(TOTAL_CLAIM_COST - PAYER_COVERAGE) AS avg_gap_amount,
    CASE
        WHEN AVG(TOTAL_CLAIM_COST) > 0 THEN (AVG(PAYER_COVERAGE) / AVG(TOTAL_CLAIM_COST)) * 100
        ELSE 0
    END AS coverage_ratio
FROM
    encountersss
GROUP BY
    DESCRIPTION,
    PAYER
ORDER BY
    AVG(TOTAL_CLAIM_COST - PAYER_COVERAGE) DESC;


----Identifying Patients with Multiple Procedures Across Encounters---
 SELECT
    ID,
    ReasonCode,
    COUNT(DISTINCT DESCRIPTION) AS NumberOfDistinctProcedures,
    COUNT(id) AS NumberOfEncounters
FROM
    encountersss
GROUP BY
    Id,
    ReasonCode
HAVING
    COUNT(DISTINCT DESCRIPTION) > 1 
ORDER BY
    NumberOfDistinctProcedures DESC;

---Analyzing Patient Encounter Duration for Different Classes
SELECT
    EncounterClass,
    COUNT(*) AS NumberOfEncounters,
    AVG(DATEDIFF(MINUTE, START, STOP)) AS AvgDurationInMinutes,
    MIN(DATEDIFF(MINUTE, START, STOP)) AS MinDurationInMinutes,
    MAX(DATEDIFF(MINUTE, START, STOP)) AS MaxDurationInMinutes
FROM
    encountersss
WHERE
    START IS NOT NULL
    AND STOP IS NOT NULL  
GROUP BY
    EncounterClass
ORDER BY
    AvgDurationInMinutes DESC;


