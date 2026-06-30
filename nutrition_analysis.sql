-- ================================================
-- NUTRITION & HEALTH RISK ANALYSIS
-- Analyst: Aditi Bajpai
-- Dataset: 168 food items across 16 categories
-- Tool: MySQL
-- Date: March 2026
-- ================================================

-- ================================================
-- QUERY 0a: DATA QUALITY AUDIT
-- Business Question: Are there data integrity issues?
-- Finding: 4.8% problematic rows (8/168) identified
-- ================================================
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Food IS NULL THEN 1 ELSE 0 END) AS null_foods,
    SUM(CASE WHEN Calories <= 0 THEN 1 ELSE 0 END) AS zero_calories,
    SUM(CASE WHEN Protein < 0 THEN 1 ELSE 0 END) AS negative_protein,
    SUM(CASE WHEN Fat < 0 THEN 1 ELSE 0 END) AS negative_fat,
    SUM(CASE WHEN Sat_Fat > Fat THEN 1 ELSE 0 END) AS sat_fat_exceeds_fat,
    SUM(CASE WHEN Calories > 900 THEN 1 ELSE 0 END) AS extreme_calories
FROM nutrition;

-- ================================================
-- QUERY 0b: DATA CLEANING
-- Fix: Negative protein value on French fries
-- ================================================
UPDATE nutrition
SET Protein = 0
WHERE Food = 'French-fried'
AND Protein < 0;

-- ================================================
-- QUERY 1: CATEGORY CALORIE OVERVIEW
-- Business Question: Which categories are most calorie-dense?
-- Finding: Seeds & Nuts highest at 340 avg cal (43% above 
--          dataset average of 237 cal)
-- ================================================
SELECT
    Category,
    COUNT(*) AS total_foods,
    ROUND(AVG(Calories), 2) AS avg_calories,
    ROUND(AVG(Protein), 2) AS avg_protein,
    ROUND(AVG(Fat), 2) AS avg_fat
FROM nutrition
GROUP BY Category
ORDER BY avg_calories DESC;

-- ================================================
-- QUERY 2: PROTEIN EFFICIENCY ANALYSIS
-- Business Question: Which foods give most protein per calorie?
-- Finding: Fish & Seafood dominates top 10 — Oysters, 
--          Shrimp, Cod deliver 15-20g protein per 100 cal
-- ================================================
SELECT
    Food,
    Category,
    Calories,
    Protein,
    ROUND((Protein / Calories) * 100, 2) AS protein_efficiency
FROM nutrition
WHERE Calories > 0 
AND Protein > 0
AND Food NOT IN ('Butter')
ORDER BY protein_efficiency DESC
LIMIT 10;

-- ================================================
-- QUERY 3a: HIDDEN SATURATED FAT RISKS
-- Business Question: Which moderate-calorie foods hide fat risks?
-- Thresholds validated using descriptive stats: 
--          avg fat=15.85g, avg cal=237
-- Finding: 15 foods (8.9%) are hidden fat bombs
-- ================================================
SELECT
    Food,
    Category,
    Calories,
    Fat,
    Sat_Fat,
    ROUND((Sat_Fat / Fat) * 100, 2) AS sat_fat_percentage
FROM nutrition
WHERE Fat > 15
AND Calories < 300
AND Sat_Fat > 0
AND Category NOT IN ('Fats, Oils, Shortenings')
ORDER BY sat_fat_percentage DESC
LIMIT 10;

-- ================================================
-- QUERY 3b: HIDDEN SUGAR BOMBS
-- Business Question: Which foods are secretly high in sugar?
-- Formula: Net Sugar = Carbs - Fiber (digestible sugar only)
-- Finding: Candied Vegetables (78.5g) and Prunes (80g) are 
--          deceptive sugar bombs despite healthy perception.
--          Cola drinks confirmed nutritionally empty.
-- ================================================
SELECT
    Food,
    Category,
    Calories,
    Carbs,
    Fiber,
    ROUND(Carbs - Fiber, 2) AS net_sugar,
    ROUND(((Carbs - Fiber) / Calories) * 100, 2) AS sugar_cal_percentage
FROM nutrition
WHERE Calories > 0
AND Carbs > 0
AND Category NOT IN ('Fats, Oils, Shortenings')
AND Food NOT IN ('Butter', 'Oysters')
ORDER BY sugar_cal_percentage DESC
LIMIT 10;

-- ================================================
-- QUERY 4: FULL NUTRITIONAL CATEGORY SCORECARD
-- Business Question: How do categories compare across 
--                    all nutrients?
-- Finding: Fish beats Meat by 74% on protein (33.53g vs 
--          19.27g). Drinks provide zero nutritional value.
-- ================================================
SELECT
    Category,
    ROUND(AVG(Calories), 2) AS avg_calories,
    ROUND(AVG(Protein), 2) AS avg_protein,
    ROUND(AVG(Carbs), 2) AS avg_carbs,
    ROUND(AVG(Fiber), 2) AS avg_fiber,
    ROUND(AVG(Fat), 2) AS avg_fat
FROM nutrition
WHERE Calories > 0
GROUP BY Category
ORDER BY avg_protein DESC;

-- ================================================
-- QUERY 5: CUSTOM HEALTH SCORING MODEL
-- Business Question: Which foods are overall healthiest?
-- Formula: (Protein x2) + (Fiber x3) - (Sat_Fat x1.5) 
--          - (Calories x0.01)
-- Weights: Protein builds muscle, Fiber most underconsumed,
--          Sat_Fat penalized for cardiovascular risk
-- Finding: Fish occupies 5 of top 10 healthiest foods.
--          Turkey best meat, Soybeans best plant protein.
-- ================================================
SELECT
    Food,
    Category,
    Calories,
    Protein,
    Fiber,
    Sat_Fat,
    ROUND(
        (Protein * 2) +
        (Fiber * 3) -
        (Sat_Fat * 1.5) -
        (Calories * 0.01)
    , 2) AS health_score
FROM nutrition
WHERE Calories > 0
AND Food NOT IN ('Butter', 'Oysters')
ORDER BY health_score DESC
LIMIT 10;
