# Nutrition & Health Risk Analysis — Key Findings
### Analyst: Aditi Bajpai | Tool: MySQL | Dataset: 168 foods, 16 categories

---

## Data Quality Audit
- 8 out of 168 rows (4.8%) had data integrity issues
- Issues found: negative protein values, saturated fat 
  exceeding total fat (scientifically impossible), 
  zero-calorie entries and extreme outliers
- 1 row cleaned (French fries negative protein → set to 0)
- 2 rows excluded from fat/protein analysis (Butter, Oysters)

---

## Insight 1 — Category Calorie Overview
Seeds & Nuts are the most calorie-dense category at 340 avg 
calories — 43% higher than the dataset average of 237 calories. 
However their high protein (10g avg) makes them nutrient-dense 
rather than empty-calorie foods. Breads & Cereals is the largest 
category (27 foods, 16.1% of dataset).

---

## Insight 2 — Protein Efficiency
Fish & Seafood delivers the highest protein efficiency — Oysters, 
Shrimp and Cod provide 15-20g protein per 100 calories. Fish & 
Seafood represents only 10.1% of the dataset but dominates the 
top 10 high-protein foods entirely.

---

## Insight 3a — Hidden Saturated Fat Bombs
15 foods (8.9% of dataset) qualify as hidden saturated fat risks 
— moderate calories (<300) but high fat (>15g). Most deceptive:
- Coconut sweetened: 95% saturated fat ratio
- Cheddar cheese: 89% saturated fat ratio  
- Eggs scrambled/fried: 87% saturated fat ratio
These foods are commonly perceived as healthy or moderate 
but carry significant cardiovascular risk.

---

## Insight 3b — Hidden Sugar Bombs
Net sugar analysis (Carbs minus Fiber) reveals shocking findings:
- Candied Vegetables: 78.5g net sugar — a food labeled as 
  vegetable ranks as 2nd highest sugar bomb in entire dataset
- Prunes: 80g net sugar — commonly recommended as a health 
  food but extremely high in digestible sugar
- Cola drin