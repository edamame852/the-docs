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
          - Ans: **basically YES**
          - TLDR bro
          ```
               Short answer: yes for federal in both the HK$1M and HK$2M cases — but not for a universal reason, and there's one scenario where it can flip. Let me be precise, because "MFJ always prevails" is almost true here but not axiomatically.

               Why MFJ wins in both your scenarios specifically:

               The thing people fear about MFJ is the stacking rule — that pooling your $102,564 exclusion onto hers raises her stacking platform to $235,464 and pushes her leftover income into higher brackets. That's real. But MFJ simultaneously hands you a much wider bracket structure and a double-size standard deduction ($32,200 vs. $16,100). In both your scenarios, the bracket/deduction advantage outweighs the stacking penalty:

               HK$1M wife	HK$2M wife
               MFJ result	~$0 (income under ceiling)	~$0 after FTC + housing
               MFS result	~$0, but she loses your unused exclusion room and gets narrower brackets	Higher tentative tax risk; MFS brackets compress hard, and MFS bars several credits
               Winner	MFJ	MFJ
               The subtlety — MFS's hidden platform advantage: Under MFS, her stacking platform would be only her own $132,900, not $235,464. A lower platform means her leftover income stacks at slightly lower rates. So in pure stacking terms, MFS helps. But MFS brackets are exactly half-width, hit the 32/35% brackets far sooner, deny you the ability to "absorb" her income under your unused headroom, and disqualify various credits. In your numbers, those MFS penalties swamp the platform benefit — so MFJ still wins.

               Where MFJ could actually lose: MFS starts to pull ahead only in edgier situations — e.g., if one spouse has huge US-source or investment income that would get dragged into high joint brackets, if there's an income-driven student loan repayment plan keying off joint AGI, or if one spouse has liability/audit exposure you want to wall off. None of those apply to a two-salary HK expat couple, which is why MFJ dominates for you.

               Bottom line

               On the housing question: $21,264 is the floor you must pay yourself, $114,300 is the ceiling the IRS will count, and only the ~$93,036 gap between them is excludable — stacked on top of the FEIE. On filing status: MFJ prevails in both your HK$1M and HK$2M scenarios, because the wider brackets and doubled standard deduction beat the stacking penalty — but that's a result of your specific numbers, not an iron law, and it can flip if large US-source or investment income ever enters the picture.

               As always, educational rather than personalized advice — the housing proration (if either of you qualifies for fewer than 365 days) and the MFJ-vs-MFS election are both worth a cross-border CPA's confirmation before filing.

          ```

     - Q8: Can I ask if the stacking rule ONLY applies when FEIE fails to cover all?
          - Ans:

     - Q9: The table on "Now compute each piece against the 2026 MFJ brackets: First term and Second term are very well made". Can you make one on 2M salary with considerations before and after the TIPRA act is 2005/2006 ? I want to see the 10% bottom bracket reset logic.
          - Ans:

     - Q10: If we are homeowners in Hong Kong, do we still quality for housing exclusion or no. Does it need to be rental, being a HK home owner would still be pay rateable values (RVs) to the HK Inland revenue department.
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
          - Historical background
               - Implemented since 2006 via the 2005 TIPRA act
               - Before 2006, expats gets double benefits, FEIE + rest income all at 10%
               - Now: your leftover income must be taxed as if the excluded income were still stacked underneath it, filling up the low brackets — so the remainder is taxed at the high marginal rates it would have occupied. Math is in Section 5.

     - Foreign Tax Credit
          - Applies with local country's taxable income multiplying the percentage of non-FEIE (non-excluded) percentage
          - Check step 5 for details

     - Foreign Housing exclusion
          - HK is regarded as high-cost locality by IRS (another example: Geneva)
          - Housing exclusion is based off of... local monthly rental figure, your post FEIE calculation
          - Base amount for deduction is 21264 USD/year
          - This is also complicated as fk, it's not a single number, it's a range with max and min
          - Example (from 2M case)
               ```
                    Piece	               What it is	                                                       2026 HK figure	          How it's derived
                    Base (floor)	          Rent the IRS assumes everyone pays out of pocket — not excludable	$21,264	               16% × $132,900 (FEIE deductable)
                    Cap (ceiling)	          Max rent the IRS will count in Hong Kong	                         $114,300	               Special high-cost figure from Notice 2026-25[1]
                    Excludable slice	     The meat of the sandwich — what you actually remove	               up to $93,036	          $114,300 − $21,264
               ```

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
     - Form 2555: Foreign residence, FEIE, calculate your housing exclusion 
          - always calculate your housing exclusion first then FEIE applies to what's left
     - FBAR? :
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
     - First, assuming filing as MFJ, both as FEIE claims
     ```
                    USD income	     FEIE	claims/deductibles            Remaining
          Wife	     $256,410	          $132,900	                         $123,510
          You	     $102,564	          $102,564(all)	                    $0
          Combined	$358,974(=Gross)	$235,464
          
          
          Ergo, total Household taxable foreign income is $123,510
          
          Note: Foreign income the household has excluded from Form 2555s (FEIE) is 235,464 USD/year
     ```
     - Second, Use MFJ standard deduction (Form 1116)
     ```
          2026 MFJ standard deduction (std) of $32,200

          Taxable income = $123,510 − $32,200 
          = $91,310 (all attributable to her).
     ```

     - Recap...this is what we have now

     ```
     Gross income        FEIE (both)         std deduction         Taxable income (= "leftover" income)
     358,974   -         235,464        -    32,200              = 91,310

     ```

     - Stacking rule applies (ouch) at 10% bracket (= similar to HK tax progression)
          - Thirdly, we figure out the post TIPRA act calculation
          ```
               Note: Tax() is a function, will be placed against the 2026 MFJ brackets
               
               Real Tax = Tax(taxable income + excluded income) - Tax(excluded income)
               
               Real Tax = Tax(326,774) - Tax(235,464) 

          ```

          - Forth and Fifth:

               - First term = Tax(326,774) = The full stack

                    ```
                         Bracket	          Slice taxed	          Tax
                         10%	               first $24,800	          $2,480
                         12%	               $24,800 → $100,800	     $9,120
                         22%	               $100,800 → $211,150	     $24,277
                         24%	               $211,150 → $326,774	     $27,750
                         
                         Total		     $63,627

                    ```

               - Second term = Tax(235,464) = The excluded stack we "remove"

                    ```
                         Bracket	               Slice taxed	          Tax
                         10%	                    first $24,800	          $2,480
                         12%	                    $24,800 → $100,800	     $9,120
                         22%	                    $100,800 → $211,150	     $24,277
                         24%	                    $211,150 → $235,464	     $5,835
                         
                         Total		$41,712

                    ```

               - Sixth: 63627 - 41712 = 21915 USD (This is your new payable tax now)
                    - This is what happened the excluded $235,464 "used up" the entire 10%, 12%, and part of the 22% brackets. 
                    - So her leftover $91,310 doesn't get to enjoy any of those cheap rates — it sits in the 22% and 24% bands. 
                    - That's the punishment: same $91,310, but taxed at roughly double the rate a non-expat would pay on the same amount. 
                    - The exclusion still helps enormously, but it doesn't let you "reset" to the bottom of the bracket ladder.

               - Seventh: Find the non(not)-excluded percentage first then apply foreign Tax Credit (FTC)
                    - Since Ms.Wife paid 38013 USD HK salaries tax
                    - FTC allows her to "credit" her HK tax attributed to the non-excluded slice
                         - Math + Recap: 
                         ```
                                        USD income	     FEIE	claims/deductibles            Remaining Taxable
                              Wife	     $256,410	          $132,900	                         $123,510


                              Hence: 

                              Excluded percentage: 132900/256410 = 51.8%
                              (Non)Not-excluded percentage: 123510/256410 = 48.2%
                         ```

                         - We take this 48.2% and apply it to the already paid HK salaries tax 38,013 USD

                         ```
                              foreign tax credit  = HK Taxed money * non-excluded percentage 
                                                  = 38013 * 48.2%
                                                  = 18,310


                              You can now pay 18,310 less


                              Apply this credit to the new payable tax by subtracting it

                              21,915 - 18,310
                              = 3,600 USD                                              
                         ```

               - Eighth: Use housing exclusion to clean up the rest
                    - HK has high-cost housing exclusion scheme from IRS
                    - Cap at 114,300 on 21264 USD base.
                    - Removing the rest of the 3600 USD per year