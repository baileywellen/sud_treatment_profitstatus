import delimited "/Users/josepheshun/Desktop/Osweiler Project/Government_finaldata.csv", clear
destring count_tx binge_drinking illicit_druguse needing_tx sud prev2years_bingedrinking prev2years_druguse prev2years_sud prev2years_needingtx tx_percapita, replace ignore("NA") force
tab year
tab state_name
save "/Users/josepheshun/Desktop/Osweiler Project/Government.dta", replace

**** Non_Profit
import delimited "/Users/josepheshun/Desktop/Osweiler Project/Nonprofit_finaldata.csv", clear
destring count_tx binge_drinking illicit_druguse needing_tx sud prev2years_bingedrinking prev2years_druguse prev2years_sud prev2years_needingtx tx_percapita, replace ignore("NA") force
save "/Users/josepheshun/Desktop/Osweiler Project/Non_Profit.dta", replace

**** Appending Data
use "/Users/josepheshun/Desktop/Osweiler Project/For Profit.dta", clear
append using "/Users/josepheshun/Desktop/Osweiler Project/Government.dta" "/Users/josepheshun/Desktop/Osweiler Project/Non_Profit.dta"
encode state_name, gen(state)



* Generating Share
collapse (sum) count_tx cocaine_yr marijuana_month aud_yr heroin_yr binge_drinking illicit_druguse needing_tx sud start_year prev2years_bingedrinking prev2years_druguse prev2years_aud prev2years_marijuana prev2years_cocaine prev2years_heroin, by(profit_type year state)


*** For Profit
keep if profit_type == "Forprofit"
drop profit_type count_tx total_tx_year
rename share Forprofit
save "/Users/josepheshun/Desktop/Osweiler Project/Forprofit.dta", replace

*** Government
keep if profit_type == "Government"
drop profit_type count_tx total_tx_year
rename share Government
save "/Users/josepheshun/Desktop/Osweiler Project/Gov.dta", replace

*** Non-Profit
keep if profit_type == "Nonprofit"
drop profit_type count_tx total_tx_year
rename share NonProfit
save "/Users/josepheshun/Desktop/Osweiler Project/Non.dta", replace

*** Merging
use "/Users/josepheshun/Desktop/Osweiler Project/Forprofit.dta"
append using "/Users/josepheshun/Desktop/Osweiler Project/Gov.dta" "/Users/josepheshun/Desktop/Osweiler Project/Non.dta"

sort year
format Forprofit Government NonProfit %9.0f

twoway (scatter Forprofit year, mlabel(Forprofit) mlabcolor(green) mlabposition(12)) ///
       (scatter Government year, mlabel(Government) mlabcolor(red) mlabposition(12)) ///
	   (scatter NonProfit year, mlabel(NonProfit) mlabcolor(blue) mlabposition(12)) ///
       (line Forprofit year, lcolor(green)) ///
       (line Government year, lcolor(red)) ///
	   (line NonProfit year, lcolor(blue)), ///
       legend(subtitle("Share of Profit Status by Year") order(1 "Forprofit" 2 "Government"  3 "NonProfit")) ///
       title("Share of Profit Status by Year") ///
       xtitle("Year") ytitle("Share of Profit Status (%)")

	   
	   
twoway (scatter Forprofit year, mlabcolor(green) mlabposition(12) ///
        legend(off)) ///
       (scatter Government year, mlabcolor(red) mlabposition(12) ///
        legend(off)) ///
       (scatter NonProfit year, mlabcolor(blue) mlabposition(12) ///
        legend(off)) ///
       (line Forprofit year, lcolor(green)) ///
       (line Government year, lcolor(red)) ///
       (line NonProfit year, lcolor(blue)), ///
       legend(order(1 "Forprofit" 2 "Government" 3 "NonProfit")) ///
       title("Share of Profit Status by Year") ///
       xtitle("Year") ytitle("Share of Profit Status (%)")


	   
	   
***** Figure 2 - Substance Use

*** For Profit
import delimited "/Users/josepheshun/Desktop/Osweiler Project/Forprofit_finaldata.csv", clear

* Generating Share

**** Government

import delimited "/Users/josepheshun/Desktop/Osweiler Project/Government_finaldata.csv", clear
destring count_tx binge_drinking illicit_druguse needing_tx sud prev2years_bingedrinking prev2years_druguse prev2years_sud prev2years_needingtx tx_percapita, replace ignore("NA") force
tab year
tab state_name
save "/Users/josepheshun/Desktop/Osweiler Project/Government.dta", replace

**** Non_Profit
import delimited "/Users/josepheshun/Desktop/Osweiler Project/Nonprofit_finaldata.csv", clear
destring count_tx binge_drinking illicit_druguse needing_tx sud prev2years_bingedrinking prev2years_druguse prev2years_sud prev2years_needingtx tx_percapita, replace ignore("NA") force
save "/Users/josepheshun/Desktop/Osweiler Project/Non_Profit.dta", replace

**** Appending Data
use "/Users/josepheshun/Desktop/Osweiler Project/For Profit.dta", clear
append using "/Users/josepheshun/Desktop/Osweiler Project/Government.dta" "/Users/josepheshun/Desktop/Osweiler Project/Non_Profit.dta"
encode state_name, gen(state)

*** Generating Share
collapse (mean) cocaine_yr marijuana_month aud_yr heroin_yr binge_drinking illicit_druguse needing_tx sud start_year prev2years_bingedrinking prev2years_druguse prev2years_aud prev2years_marijuana prev2years_cocaine prev2years_heroin, by(year)

keep year prev2years_cocaine prev2years_heroin prev2years_marijuana prev2years_aud
sum prev2years_cocaine prev2years_heroin prev2years_marijuana prev2years_aud
br

gen total_individual = prev2years_cocaine + prev2years_heroin + prev2years_marijuana + prev2years_aud


gen share_aud = (prev2years_aud / total_individual)*100
gen share_marijuana = (prev2years_marijuana / total_individual)*100
gen share_cocaine = (prev2years_cocaine / total_individual)*100
gen share_heroin = (prev2years_heroin / total_individual)*100


sort year
format share_aud share_marijuana share_cocaine share_heroin %9.0f

twoway (scatter share_aud year, mlabel(share_aud) mlabcolor(purple) mlabposition(12)) ///
       (scatter share_marijuana year, mlabel(share_marijuana) mlabcolor(green) mlabposition(12)) ///
       (scatter share_cocaine year, mlabel(share_cocaine) mlabcolor(red) mlabposition(12)) ///
       (scatter share_heroin year, mlabel(share_heroin) mlabcolor(blue) mlabposition(12)) ///
       (line share_aud year, lcolor(purple) lpattern(solid)) ///
       (line share_marijuana year, lcolor(green) lpattern(solid)) ///
       (line share_cocaine year, lcolor(red) lpattern(solid)) ///
       (line share_heroin year, lcolor(blue) lpattern(solid)), ///
       legend(subtitle("Share of Profit Status by Year") order(1 "AUD" 2 "Marijuana" 3 "Cocaine" 4 "Heroin")) ///
       title("Share of Profit Status by Year") ///
       xtitle("Year") ytitle("Share of Profit Status (%)")

	   
	   
sort year
format share_aud share_marijuana share_cocaine share_heroin %9.0f

twoway (scatter share_aud year, mlabel(share_aud) mlabcolor(purple) mlabposition(12)) ///
       (scatter share_marijuana year, mlabel(share_marijuana) mlabcolor(green) mlabposition(12)) ///
       (scatter share_cocaine year, mlabel(share_cocaine) mlabcolor(red) mlabposition(12)) ///
       (scatter share_heroin year, mlabel(share_heroin) mlabcolor(blue) mlabposition(12)) ///
       (line share_aud year, lcolor(purple) lpattern(solid)) ///
       (line share_marijuana year, lcolor(green) lpattern(solid)) ///
       (line share_cocaine year, lcolor(red) lpattern(solid)) ///
       (line share_heroin year, lcolor(blue) lpattern(solid)), ///
       legend(order(1 "AUD" 2 "AUD" 3 "Marijuana" 4 "Marijuana" 5 "Cocaine" 6 "Cocaine" 7 "Heroin" 8 "Heroin") ///
       subtitle("Share of Profit Status by Year")) ///
       title("Share of Profit Status by Year") ///
       xtitle("Year") ytitle("Share of Profit Status (%)") ///
       xlabel(2015 "2013-2014" 2016 "2014-2015" 2017 "2015-2016" 2018 "2016-2017" 2019 "2017-2018")

	   
	   
*** Not Share

sort year
format prev2years_aud prev2years_marijuana prev2years_cocaine prev2years_heroin %9.0f

twoway (scatter prev2years_aud year, mlabel(prev2years_aud) mlabcolor(purple) mlabposition(12)) ///
       (scatter prev2years_marijuana year, mlabel(prev2years_marijuana) mlabcolor(green) mlabposition(12)) ///
       (scatter prev2years_cocaine year, mlabel(prev2years_cocaine) mlabcolor(red) mlabposition(12)) ///
       (scatter prev2years_heroin year, mlabel(prev2years_heroin) mlabcolor(blue) mlabposition(12)) ///
       (line prev2years_aud year, lcolor(purple) lpattern(solid)) ///
       (line prev2years_marijuana year, lcolor(green) lpattern(solid)) ///
       (line prev2years_cocaine year, lcolor(red) lpattern(solid)) ///
       (line prev2years_heroin year, lcolor(blue) lpattern(solid)), ///
       legend(order(1 "AUD" 2 "AUD" 3 "Marijuana" 4 "Marijuana" 5 "Cocaine" 6 "Cocaine" 7 "Heroin" 8 "Heroin") ///
       subtitle("Share of Profit Status by Year")) ///
       title("Share of Profit Status by Year") ///
       xtitle("Year") ytitle("Share of Profit Status (%)") ///
       xlabel(2015 "2013-2014" 2016 "2014-2015" 2017 "2015-2016" 2018 "2016-2017" 2019 "2017-2018")
	   
	   
*** Combining the Graphs
cd "/Users/josepheshun/Desktop/Osweiler Project"

// Combine the saved graphs into one panel
graph combine Graph.gph Substance.gph, row(1) column(1)


cd "/Users/josepheshun/Desktop/Osweiler Project"

// Combine the saved graphs into one panel, vertically
graph combine Graph.gph Substance.gph, row(2) ///
    title("Combined Graphs") ///
    xsize(12) ysize(8)
	
	// Combine the saved graphs into one panel, vertically
graph combine Graph.gph Not_Share.gph, row(2) ///
    title("Combined Graphs") ///
    xsize(12) ysize(8)
