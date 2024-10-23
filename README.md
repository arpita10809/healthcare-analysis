# healthcare-analysis
Project Overview:
The Healthcare Financial Analysis project focuses on evaluating critical financial metrics and patient data using SQL. The analysis targets key areas like financial risk, patient encounters, and payer contributions in a healthcare setting. By querying the data:
Financial Risk by Encounter Outcome: The project assesses uncovered costs for different medical encounters, helping to identify the most financially risky scenarios for patients and healthcare providers.
High-Cost Patient Encounters: It highlights patients with frequent high-cost medical treatments in 2023, focusing on cases where total claim costs exceeded $10,000.
Payer Contributions for Procedures: The project examines the number of claims and the financial contributions from different payers for various medical procedures, providing insights into how different procedures are financed by insurers.

Technologies Used:
SQL: For querying and analyzing healthcare encounter data.
Healthcare Database: Used for storing patient, encounter, and payer information.
CSV File: For data preparation and export.
SQL Server: Database management system (depending on the platform you used).
Data Analysis Techniques: Including grouping, filtering, and aggregation to derive insights from large datasets.

This analysis aids in understanding patient financial burdens, optimizing risk management, and ensuring better resource allocation within healthcare organizations.

            -------------These are the sql queries used in the analysis-----------
            
---Financial Risk Evaluation---: Assessed the uncovered costs per encounter based on reason codes, identifying the most financially risky scenarios.
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

-----------High-Cost Patient Encounters----------: Identified patients with frequent high-cost medical encounters in 2023, focusing on encounters exceeding $10,000.
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

-----------Payer Contribution Analysis-------: Evaluated the number of claims and financial contributions by various payers across different procedure types.
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

The insights generated help in understanding patient financial burdens, frequent high-cost healthcare scenarios, and the role of insurance coverage.
