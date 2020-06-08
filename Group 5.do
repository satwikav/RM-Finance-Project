********************************************************************************
* Research Module Financial Economics WS2019/2020
* Group 5: Microfinance and Economic Development
* Sanxing Song & Satwika Vysetty
* Last modified 12.01.2020
********************************************************************************


* Setup
clear all

set more off

cd "C:\XXXXXXXXXXX"

* Create the new state level data file with updated excel dataset
*import excel "States_Stata13.xlsx", sheet("Sheet1") firstrow
*save "State_Stata13.dta", replace


********************************************************************************
* Correlation between economic development and microfinance sector
* State-wise simple linear regression
* Data source: SHG report(2009-2013);BMR MFI report(2009-2013);
*              Reserve Bank of India statistic publications
********************************************************************************

use "State_Stata13.dta", clear 

set more off

***************************************
* Simple regression of GDP on total GLP
***************************************
			 
generate Total_GLP = SHG_GLP + MFI_GLP

* Scatter plot
twoway (scatter GDP Total_GLP) (lfit GDP Total_GLP), ytitle(State-level GDP) ///
xtitle(State-level total GLP) title(Correlation between state-level GDP & total GLP (lakh INR) ) ///
note(Data source: SMFI report; BMR report; RBI publications (2009-2013)) legend(off) ///
scheme(s1mono) name(Graph101_GDP_GLP, replace)

* Regression
regress GDP Total_GLP, vce(cluster State_UT_ID)

***********************************************
* Simple regression of log GDP on log total GLP
***********************************************

* Generate ln values
generate Ln_GDP = ln(GDP)
generate Ln_Total_GLP = ln(Total_GLP)

* Scatter plot
twoway (scatter Ln_GDP Ln_Total_GLP) (lfit Ln_GDP Ln_Total_GLP), ytitle(State-level ln(GDP)) ///
xtitle(State-level ln(Total GLP)) title(Correlation between state-level ln(GDP) & ln(Total GLP)) ///
note(Data source: SMFI report; BMR report; RBI publications (2009-2013)) legend(off) ///
scheme(s1mono) name(Graph102_lnGDP_lnGLP, replace)
 
* Regression
regress Ln_GDP Ln_Total_GLP, vce(cluster State_UT_ID)


********************************************************************************
* Malegam (2011) regulation shock on MFIs in India
* Institutional level D-i-D regression to study the effect of regulation on MFIs
* Data source: Mr. Rehbein's MFI dataset 
********************************************************************************

use "MFIs_Stata13.dta", clear

set more off
  
* Keep useful variables
* Keeping year > 2008 means keeping year == 2009,2010,2011,2012,2013,2014
* Keeping Period == "ANN" means dropping year == 2013 & year == 2014
keep if Country == "India" 
keep if year > 2008 
keep if Period == "ANN" 

* Drop outliers
drop if MFIname == "GMSSS"  
drop if MFIname == "CSF"

* Drop MFIs exist only before or only after regulation shock
sort MFIID year
by MFIID: egen count = count(year)
order MFIID MFIname count
sort count MFIname year
drop if count == 1

drop if MFIname == "AMIL" 
drop if MFIname == "AMMACTS" 
drop if MFIname == "Belstar" 
drop if MFIname == "CReSA" 
drop if MFIname == "GMF" 
drop if MFIname == "IFMR Rural Channels" 
drop if MFIname == "India's Capital Trust Ltd" 
drop if MFIname == "Janodaya" 
drop if MFIname == "M-power" 
drop if MFIname == "NFPL" 
drop if MFIname == "Nano" 
drop if MFIname == "RASS" 
drop if MFIname == "RORES" 
drop if MFIname == "SEWA MACTS" 
drop if MFIname == "SVSDF" 
drop if MFIname == "Saadhana" 
drop if MFIname == "Share MACTS" 
drop if MFIname == "Swayamshree Micro Credit Services" 
drop if MFIname == "VFPL" 

/* Generate ln values
generate Ln_GrossLoanPortfolio = ln(GrossLoanPortfolio)
generate Ln_Loanperborrower = ln(Loanperborrower)
generate Ln_Numberofloansoutstanding = ln(Numberofloansoutstanding)
generate Ln_Loansperstaffmember = ln(Loansperstaffmember)
generate Ln_Loansperloanofficer = ln(Loansperloanofficer)
generate Ln_Numberofactiveborrowers = ln(Numberofactiveborrowers)
generate Ln_Borrowersperstaffmember = ln(Borrowersperstaffmember)
generate Ln_Borrowersperloanofficer = ln(Borrowersperloanofficer)
generate Ln_Offices = ln(Offices)
generate Ln_Personnel = ln(Personnel)
generate Ln_Loanofficers = ln(Loanofficers)
generate Ln_Costperborrower = ln(Costperborrower)
generate Ln_Costperloan = ln(Costperloan)
*/

/* Show the distribution of variable
histogram GrossLoanPortfolio, bin(20) title(Distribution of institutional GLP) name(Graph201_GLP, replace)
histogram Ln_GrossLoanPortfolio, bin(20) title(Distribution of institutional ln(GLP)) name(Graph202_Ln_GLP, replace)
histogram Loanperborrower, bin(20) title(Distribution of institutional Loanperborrower) name(Graph203_Loanperborrower, replace)
histogram Ln_Loanperborrower, bin(20) title(Distribution of institutional ln(Loanperborrower)) name(Graph204_Ln_Loanperborrower, replace)
histogram Numberofloansoutstanding, bin(20) title(Distribution of institutional Numberofloansoutstanding) name(Graph205_Noofloansoutstanding, replace)
histogram Ln_Numberofloansoutstanding, bin(20) title(Distribution of institutional ln(Numberofloansoutstanding)) name(Graph206_Ln_Noofloansoutstanding, replace)
histogram Loansperstaffmember, bin(20) title(Distribution of institutional Loansperstaffmember) name(Graph207_Loansperstaffmember, replace)
histogram Ln_Loansperstaffmember, bin(20) title(Distribution of institutional Ln_Loansperstaffmember) name(Graph208_Ln_Loansperstaffmember, replace)
histogram Loansperloanofficer, bin(20) title(Distribution of institutional Loansperloanofficer) name(Graph209_Loansperloanofficer, replace)
histogram Ln_Loansperloanofficer, bin(20) title(Distribution of institutional Ln_Loansperloanofficer) name(Graph210_Ln_Loansperloanofficer, replace)
histogram Numberofactiveborrowers, bin(20) title(Distribution of institutional Numberofactiveborrowers) name(Graph211_Noofactiveborrowers, replace)
histogram Ln_Numberofactiveborrowers, bin(20) title(Distribution of institutional ln(Numberofactiveborrowers)) name(Graph212_Ln_Noofactiveborrowers, replace)
histogram Borrowersperstaffmember, bin(20) title(Distribution of institutional Borrowersperstaffmember) name(Graph213_Borrowersperstaffmember, replace)
histogram Ln_Borrowersperstaffmember, bin(20) title(Distribution of institutional Ln_Borrowersperstaffmember) name(Graph214_Ln_Borrowersperstaffmember, replace)
histogram Borrowersperloanofficer, bin(20) title(Distribution of institutional Borrowersperloanofficer) name(Graph215_Borrowersperloanofficer, replace)
histogram Ln_Borrowersperloanofficer, bin(20) title(Distribution of institutional Ln_Borrowersperloanofficer) name(Graph216_Ln_Borrowersperloanofficer, replace)
histogram Offices, bin(20) title(Distribution of institutional Offices) name(Graph217_Offices, replace)
histogram Ln_Offices, bin(20) title(Distribution of institutional Ln_Offices) name(Graph218_Ln_Offices, replace)
histogram Personnel, bin(20) title(Distribution of institutional Personnel) name(Graph219_Personnel, replace)
histogram Ln_Personnel, bin(20) title(Distribution of institutional Ln_Personnel) name(Graph220_Ln_Personnel, replace)
histogram Loanofficers, bin(20) title(Distribution of institutional Loanofficers) name(Graph221_Loanofficers, replace)
histogram Ln_Loanofficers, bin(20) title(Distribution of institutional Ln_Loanofficers) name(Graph222_Ln_Loanofficers, replace)
histogram Costperborrower, bin(20) title(Distribution of institutional Costperborrower) name(Graph223_Costperborrower, replace)
histogram Ln_Costperborrower, bin(20) title(Distribution of institutional Ln_Costperborrower) name(Graph224_Ln_Costperborrower, replace)
histogram Costperloan, bin(20) title(Distribution of institutional Costperloan) name(Graph225_Costperloan, replace)
histogram Ln_Costperloan, bin(20) title(Distribution of institutional Ln_Costperloan) name(Graph226_Ln_Costperloan, replace)
*/

* Descriptive statistics
summarize GrossLoanPortfolio if GrossLoanPortfolio != 0 
summarize Numberofloansoutstanding
summarize Numberofactiveborrowers 
summarize Offices 
summarize Personnel
summarize Portfolioatriskgt30days if Portfolioatriskgt30days <= 1
summarize Portfolioatriskgt90days if Portfolioatriskgt90days <= 1
summarize Returnonassets
*summarize Loansperstaffmember
*summarize Borrowersperstaffmember
*summarize Loanofficers
*summarize Costperborrower
*summarize Costperloan
*summarize Personnelexpenseloanportfoli
*summarize OpExpense_portfolio

* Descriptive statistics for 2010 to get mean value before regulation
summarize GrossLoanPortfolio if year == 2010 & GrossLoanPortfolio != 0
summarize Numberofloansoutstanding if year == 2010
summarize Numberofactiveborrowers if year == 2010
summarize Offices if year == 2010
summarize Personnel if year == 2010
summarize Portfolioatriskgt30days if year == 2010 & Portfolioatriskgt30days <= 1
summarize Portfolioatriskgt90days if year == 2010 & Portfolioatriskgt90days <= 1
summarize Returnonassets if year == 2010

* Set global variables
global institution_final GrossLoanPortfolio Numberofloansoutstanding Numberofactiveborrowers ///
                         Offices Personnel Portfolioatriskgt30days Portfolioatriskgt90days Returnonassets
						 
global institution_final_PlaceboTest GrossLoanPortfolio Numberofloansoutstanding Numberofactiveborrowers ///
                         Offices Personnel Portfolioatriskgt30days Portfolioatriskgt90days Returnonassets
						 
/*global institution GrossLoanPortfolio Ln_GrossLoanPortfolio ///
                   Loanperborrower Ln_Loanperborrower ///
				   Numberofloansoutstanding Ln_Numberofloansoutstanding ///
				   Loansperstaffmember Ln_Loansperstaffmember ///
				   Loansperloanofficer Ln_Loansperloanofficer ///
                   Numberofactiveborrowers Ln_Numberofactiveborrowers ///
                   Borrowersperstaffmember Ln_Borrowersperstaffmember ///
				   Borrowersperloanofficer Ln_Borrowersperloanofficer ///
				   Offices Ln_Offices Personnel Ln_Personnel Loanofficers Ln_Loanofficers ///
				   StartUps Portfolioatriskgt30days Portfolioatriskgt90days Writeoffratio ///
	               Profitmargin Operationalselfsufficiency ///
				   Returnonassets Returnonequity Debttoequityratio ///
				   Costperborrower Ln_Costperborrower Costperloan Ln_Costperloan ///
				   Personnelexpenseloanportfoli OpExpense_portfolio ///
				   Percentoffemaleborrowers Percentoffemaleloanofficers ///
			       Percentoffemaleboardmembers Percentoffemalemanagers Percentoffemalestaff
		   
global institution_Ptest GrossLoanPortfolio Ln_GrossLoanPortfolio ///
                   Loanperborrower Ln_Loanperborrower ///
				   Numberofloansoutstanding Ln_Numberofloansoutstanding ///
				   Loansperstaffmember Ln_Loansperstaffmember ///
				   Loansperloanofficer Ln_Loansperloanofficer ///
                   Numberofactiveborrowers Ln_Numberofactiveborrowers ///
                   Borrowersperstaffmember Ln_Borrowersperstaffmember ///
				   Borrowersperloanofficer Ln_Borrowersperloanofficer ///
				   Offices Ln_Offices Personnel Ln_Personnel Loanofficers Ln_Loanofficers ///
				   Portfolioatriskgt30days Portfolioatriskgt90days Writeoffratio ///
	               Profitmargin Operationalselfsufficiency ///
			       Returnonassets Returnonequity Debttoequityratio ///
				   Costperborrower Ln_Costperborrower Costperloan Ln_Costperloan ///
				   Personnelexpenseloanportfoli OpExpense_portfolio ///
				   Percentoffemaleborrowers Percentoffemalestaff
				   
*global control Assets Profitmargin
*/	   
				   
      
***************************
* First-step identification
***************************
* "NBFI-MFI" is affected by the regulation shock, while "other MFI" is unaffected
* So "NBFI-MFI" is in the treatment group and "other MFI" is in the control group

* Generate dummy variables for affected/unaffected and before/after shock
generate Dir_affected = 0
replace Dir_affected = 1 if Currentlegalstatus == "NBFI"

generate Post = year > 2010

summarize Dir_affected

******************
* D-i-D regression
******************

* D-i-D Regression with consideration of fixed effects (2010-2012)
foreach x of global institution_final {

reghdfe `x' i.Post##i.Dir_affected if year != 2009, absorb(MFIID year) vce(cluster MFIID)

}


/* D-i-D Regression with consideration of fixed effects (2009-2012)
foreach x of global institution {

reghdfe `x' i.Post##i.Dir_affected, absorb(MFIID year) vce(cluster MFIID)

}

* D-i-D Regression with consideration of fixed effects (2009-2011)
foreach x of global institution {

reghdfe `x' i.Post##i.Dir_affected if year != 2012, absorb(MFIID year) vce(cluster MFIID)

}

* D-i-D Regression with consideration of fixed effects (2010-2012)
foreach x of global institution {

reghdfe `x' i.Post##i.Dir_affected if year != 2009, absorb(MFIID year) vce(cluster MFIID)

}

* D-i-D Regression with consideration of fixed effects (2010 and 2012)
foreach x of global institution {

reghdfe `x' i.Post##i.Dir_affected if year != 2009 & year != 2011, absorb(MFIID year) vce(cluster MFIID)

}

* D-i-D Regression with consideration of fixed effects (2010-2011)
foreach x of global institution {

reghdfe `x' i.Post##i.Dir_affected if year != 2009 & year != 2012, absorb(MFIID year) vce(cluster MFIID)

}

* D-i-D Regression with consideration of fixed effects and control variable(2010-2011)
foreach x of global institution {

reghdfe `x' i.Post##i.Dir_affected $control if year != 2009 & year != 2012, absorb(MFIID year) vce(cluster MFIID)

}
*/

**************
* Placebo test
**************
* Use pre-treatment period 2009-2010 as the fake period, 2009 as before shock, 2010 as after shock
generate Post_1 = year > 2009

foreach x of global institution_final_PlaceboTest {

reghdfe `x' i.Post_1##i.Dir_affected if year != 2011 & year != 2012, absorb(MFIID year) vce(cluster MFIID)

}


********************************************************************************
* Malegam (2011) regulation shock on MFIs(NBFCs) in India
* State level D-i-D regression to study the effect of shock on economic development
* Data source: SHG report(2009-2013);BMR MFI report(2009-2013)
********************************************************************************

use "State_Stata13.dta", clear 

set more off

* Generate total gross loan portfolio 
generate Total_GLP = SHG_GLP + MFI_GLP

* Generate  ln values
generate Ln_GDP = ln(GDP)
generate Ln_Total_GLP = ln(Total_GLP)
generate Ln_MFI_GLP = ln(MFI_GLP)
*generate Ln_NDP = ln(NDP)
*generate Ln_NDP_percapita = ln(NDP_percapita)
*generate Ln_MFI_Clients = ln(MFI_Clients)

/* Show the distribution of variable
histogram GDP, bin(10) title(Distribution of state-wise GDP) name(Graph301_State_GDP, replace)
histogram Ln_GDP, bin(10) title(Distribution of state-wise ln(GDP)) name(Graph302_State_Ln_GDP, replace)
histogram NDP, bin(10) title(Distribution of state-wise NDP) name(Graph303_State_NDP, replace)
histogram Ln_NDP, bin(10) title(Distribution of state-wise ln(NDP)) name(Graph304_State_Ln_NDP, replace)
histogram NDP_percapita, bin(10) title(Distribution of state-wise NDP_percapita) name(Graph305_State_NDP_percapita, replace)
histogram Ln_NDP_percapita, bin(10) title(Distribution of state-wise ln(NDP_percapita)) name(Graph306_State_Ln_NDP_percapita, replace)
histogram Total_GLP, bin(10) title(Distribution of state-wise Total_GLP) name(Graph307_State_Total_GLP, replace)
histogram Ln_Total_GLP, bin(10) title(Distribution of state-wise ln(Total_GLP)) name(Graph308_State_Ln_Total_GLP, replace)
histogram MFI_GLP, bin(10) title(Distribution of state-wise MFI_GLP) name(Graph309_State_MFI_GLP, replace)
histogram Ln_MFI_GLP, bin(10) title(Distribution of state-wise ln(MFI_GLP)) name(Graph310_State_Ln_MFI_GLP, replace)
histogram MFI_Clients, bin(10) title(Distribution of state-wise MFI_Clients) name(Graph311_State_MFI_Clients, replace)
histogram Ln_MFI_Clients, bin(10) title(Distribution of state-wise ln(MFI_Clients)) name(Graph312_State_Ln_MFI_Clients, replace)
*/

/* Generate GDP(t)/GDP(t-1) and GDP growth rate
sort Year State_UT_ID
generate count = _n
generate GDP_LastYear = GDP[_n-32]
generate GDP_GrowthFactor = GDP / GDP_LastYear
drop count GDP_LastYear
generate GDP_GrowthRate = GDP_GrowthFactor -1
drop GDP_GrowthFactor
*/

* Descriptive statistics
summarize MFI_GLP
summarize Total_GLP
summarize MFI_Clients
summarize GDP
summarize Drop_Out_Rate
summarize Unemploy_Rural_Overall
summarize Poverty_Rate

* Generate global variables

global state_final1 Ln_MFI_GLP Ln_Total_GLP MFI_Clients Ln_GDP Drop_Out_Rate 
                   
global state_final2 Unemploy_Rural_Overall Poverty_Rate
				   
global state_final_PlaceboTest Ln_MFI_GLP Ln_Total_GLP MFI_Clients Ln_GDP Drop_Out_Rate 

				   
/*global state2009 Total_GLP Ln_Total_GLP MFI_GLP Ln_MFI_GLP MFI_Clients Ln_MFI_Clients ///
             GDP Ln_GDP GDP_GrowthRate NDP Ln_NDP NDP_percapita Ln_NDP_percapita ///
			 Drop_Out_Rate Retention_Rate Poverty_Rate ///
	         Unemploy_Rural_Overall Unemploy_Rural_Male Unemploy_Rural_Female ///
	         Unemploy_Urban_Overall Unemploy_Urban_Male Unemploy_Urban_Female
			 
global state2010 Total_GLP Ln_Total_GLP MFI_GLP Ln_MFI_GLP MFI_Clients Ln_MFI_Clients ///
             GDP Ln_GDP GDP_GrowthRate NDP Ln_NDP NDP_percapita Ln_NDP_percapita ///
			 Drop_Out_Rate Retention_Rate 
	         
global state_Ptest Total_GLP Ln_Total_GLP MFI_GLP Ln_MFI_GLP MFI_Clients Ln_MFI_Clients ///
             GDP Ln_GDP NDP Ln_NDP NDP_percapita Ln_NDP_percapita ///
			 Drop_Out_Rate Retention_Rate
*/
             
****************************
* Second-step identification
****************************
* Only MFI model is affected, while SHG model is unaffected
* The share of MFI GLP in the microfinance sector before the regulation shock shows exposure to the shock
* State with higher share of MFI is more indirectly affected
* State with lower share of MFI is less indirectly affected

* Use the data at the end of financial year 2010-2011 to compute the MFI GLP share 
generate Total_GLP2010 = SHG_GLP2010 + MFI_GLP2010
generate MFIshare2010 = MFI_GLP2010 / Total_GLP2010

* Indicate the intensity of indirect effect of the regulation shock (2011) on each state
generate Indir_affected = MFIshare2010

summarize Indir_affected

* Indicate before and after regulation shock
generate Post = Year > 2010

* For binary D-i-D regression
* Indicate treatment group and control group based on thresholds of Indir_affected
* More indirectly affected State is in the treatment group, called Regulated 
* Less indirectly affected State is in the control group
* Generate dummy variables for regulated/unregulated and before/after shock
/*generate Regulated = .
replace Regulated = 1 if Indir_affected > 0.75
replace Regulated = 0 if Indir_affected < 0.25
*/

*********************
* D-i-D regression 
*********************

* Continuous D-i-D Regression with consideration of fixed effects (2010-2012)
foreach x of global state_final1 {

reghdfe `x' i.Post##c.Indir_affected if Year != 2009 & Year != 2013, absorb(State_UT_ID Year) vce(cluster State_UT_ID)

}

* Continuous D-i-D Regression with consideration of fixed effects (2009 & 2011)
foreach x of global state_final2 {

reghdfe `x' i.Post##c.Indir_affected if Year != 2010 & Year != 2012 & Year != 2013, absorb(State_UT_ID Year) vce(cluster State_UT_ID)

}


/* Continuous D-i-D Regression with consideration of fixed effects (2009-2013)
foreach x of global state2009 {

reghdfe `x' i.Post##c.Indir_affected, absorb(State_UT_ID Year) vce(cluster State_UT_ID)

}

* Continuous D-i-D Regression with consideration of fixed effects (2009-2012)
foreach x of global state2009 {

reghdfe `x' i.Post##c.Indir_affected if Year != 2013, absorb(State_UT_ID Year) vce(cluster State_UT_ID)

}

* Continuous D-i-D Regression with consideration of fixed effects (2009-2011)
foreach x of global state2009 {

reghdfe `x' i.Post##c.Indir_affected if Year != 2012 & Year != 2013, absorb(State_UT_ID Year) vce(cluster State_UT_ID)

}

* Continuous D-i-D Regression with consideration of fixed effects (2010-2013)
foreach x of global state2010 {

reghdfe `x' i.Post##c.Indir_affected if Year != 2009, absorb(State_UT_ID Year) vce(cluster State_UT_ID)

}

* Continuous D-i-D Regression with consideration of fixed effects (2010-2012)
foreach x of global state2010 {

reghdfe `x' i.Post##c.Indir_affected if Year != 2009 & Year != 2013, absorb(State_UT_ID Year) vce(cluster State_UT_ID)

}

* Continuous D-i-D Regression with consideration of fixed effects (2010 and 2012)
foreach x of global state2010 {

reghdfe `x' i.Post##c.Indir_affected if Year != 2009 & Year != 2011 & Year != 2013, absorb(State_UT_ID Year) vce(cluster State_UT_ID)

}

* Continuous D-i-D Regression with consideration of fixed effects (2010-2011)
foreach x of global state2010 {

reghdfe `x' i.Post##c.Indir_affected if Year != 2009 & Year != 2012 & Year != 2013, absorb(State_UT_ID Year) vce(cluster State_UT_ID)

}
*/


**************
* Placebo test
**************
*Use pre-treatment period 2009-2010 as the fake period, 2009 as before shock, 2010 as after shock
generate Post_1 = Year > 2009

* Continuous D-i-D Regression with consideration of fixed effects (2009-2010)
foreach x of global state_final_PlaceboTest {

reghdfe `x' i.Post_1##c.Indir_affected if Year != 2011 & Year != 2012 & Year != 2013, absorb(State_UT_ID Year) vce(cluster State_UT_ID)

}

