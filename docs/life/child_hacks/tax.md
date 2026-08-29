---
layout: default
parent: Life Hacks
title: Tax hacks
---
# Non-SNS
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
0. Questions & Answers (Q&A)
     - Q1: is US standard deduction overlapping with HK deduction and FEIE scheme? Will US standard deduction be cut short if HK already has basic allowance?
          - Ans: No, FEIE and deduction comes AFTER the HK tax calculations. Hong Kong's basic allowance never reduces your US standard deduction — they're independent systems
     - Q2: Which of the following schemes/ deductions/ exclusions must meet physical presence test ≥330 full days abroad in a 12-month period or bona fide residence, and file Form 2555? how to fill in Form 2555? What other forms do I need to fill in? Answer in bullet points
          - Ans: 
     - Q3: How does one break state residency before moving aboard, I don't want to be bothered by stick states like Cali who doesn't uphold FEIE
          - Ans:

     - Q4: What is an FBAR form? Why is it relevant for when I'm filing for FEIE and other exclusions/deductions> 
          - Ans:

     - Q5: The stacking rules confuses me a lot...can you break it down even further using the 1M HK yearly salary vs 2M salary as an example?
          - Ans:

     - Q6: What is the physical presence test for MFJ? Does FEIE, stacking adn Foreign housing exclusion 
          - Ans:

     - Q7: So does it mean that MFJ always prevails in the 1M wife and 2M wife scenario? Or it is not.
          - Ans:


1. Terminologies (Skills/Rules)
     - FEIE = Foreign Earned Income Exclusion 
          - Amount changes every year
          - In 2026, the max exclusion is 132,900 USD/year
          - For reference: 2025 it was 130,000 ; 2024 it's 126,500
          - Important:
               - FEIE covers only EARNED income = qualifying income
               - FEIE doesn't shelter unearned income (but can still be bypassed by foreign tax credit, since HK is regarded as high cost by IRS, "housing exclusion" can help)
                    - interest
                    - dividends
                    - rental income
                    - capital gains
                    - investment income
     - Standard deduction (std)
          - Can be used with FEIE, and doesn't count as "double benefit" 
               - Under IRC §911(d)(6) ("Denial of Double Benefits"), you cannot take a deduction, exclusion, or credit that is "properly allocable to or chargeable against" income you've already excluded with the FEIE. That's why you can't, for example, deduct foreign business expenses and exclude the income they generated — you'd be getting the benefit twice.
               - The critical point: the standard deduction survives this rule. It is a personal deduction, not one "allocable to" any specific slice of income, soit is not disallowed when you claim the FEIE. You keep the full $32,200 MFJ standard deduction.
          - Deductibles:
               - 32000 USD off per year if Married = [MFJ Standard deduction brackets - Publication 505](https://www.irs.gov/publications/p505)
               - 16100 USD off per year if single
               - 24150 USD off per year if head of household 
               
     - Stacking Rule
          - Implemented since 2006.
          - 

     - Foreign Tax Credit
          - 

     - Foreign Housing exclusion
          - HK is regarded as high-cost locality by IRS (another example: Geneva)
          - Base amount for deduction is 21264 USD/year

     - State tax
          - Watch out for FEIE conformity
               - Conforming states: NC, NY, most states
               - Non-conforming states: CA, AL, HW, MI, NJ, PE
          - FEIE conformity: State taxable income starts with federal AGI, hence FEIE reduced and deductible
               - Hence: post-FEIE income is absorbed by the state's deduction
               - Note: You still need to file, but foreign income is excluded

          - MFJ = Married Filing Jointly (almost always better)
2. Forms
     - Form 1040: every year for US nationals (citizens and residents)
     - Form 1116: (Foreign tax credit): Standard deduction (personal deductions) happens here
     - Form 2555: Foreign residence, FEIE
     - FBAR?
     - Form 114: FinCEN (to report any foreign account over 10,000 USD)

3. Facts
     - No US-HK tax treaties but... doesn't block exclusion  or foreign tax credit
     - HK tax (= progressive rates)
          - HK tax has cap
               - meaning there are two scenarios for people make over 5M a year 
               - Scenario 1: No progressive tax at all (first 5M is 15%, rest 16%)
               - Scenario 2: With progressive tax (2%, 6%, 10%, 14%, 17%) all th way disregarding 5M+ 
               - IRD (HK's IRS) charges based on lower of the two scenarios
          - Normal HK tax calculation (Scenario 2) 5 bands, each of 50k HKD
               - Marginal tax rates are of 2%, 6%, 10%, 14%, 17%


4. Ms. Wife Now 2026 (in HKD)
     -
     ```
     Income	1,105,000
     Less MPF	(18,000)
     Less basic allowance	(132,000)
     Net chargeable income	955,000
     Tax: 2%/6%/10%/14% on first 200,000	16,000
     Tax: 17% on remaining 755,000	128,350
     Progressive total	144,350
     Standard-rate check (15% × 1,087,000)	163,050 → higher, so progressive applies
     ```

     - Now:
          - Total yearly HK tax: 144,350 (= US 18,500) = roughly 13%
          - US Federal on Ms. Wife: FEIE excluded up to 132,900 USD/ year
          - US income total 141,667 USD/year
          - Remaining taxable is 8767 USD
          - You can apply standard deduction (-32000 USD/year for being married)
          - Federal tax is now 0.

5. Ms. Wife Future 2046 (in HKD)
     - Assuming MFJ + FEIE claims
     ```
                    USD income	FEIE	claims/deductibles          Remaining
          Wife	     $256,410	     $132,900	                         $123,510
          You	     $102,564	     $102,564(all)	                    $0
          Combined	$358,974	     $235,464
          Ergo, total Household taxable foreign income			$123,510
          
          Note: Foreign income the household has excluded from Form 2555s (FEIE) is 235,464 USD/year
     ```
     - Use MFJ standard deduction first (Form 1116)
     ```
          2026 MFJ standard deduction (std) of $32,200

          Taxable income = $123,510 − $32,200 
          = $91,310 (all attributable to her).
     ```

     - Stacking rule applies (ouch)

     ```


     ```