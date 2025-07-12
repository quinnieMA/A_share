* Set global path for data directory
global data_path "C:/Users/FM/OneDrive/A/DATA/三大表/data"

* ============================================= *
* Processing Financial Statement Data (FS_Combas)
* ============================================= *

* Load balance sheet data from CSMAR
use "$data_path/FS_Combas.dta", clear
drop if Typrep=="B"
* Create standardized stock code variable
gen stock_code = Stkcd  // Standardize variable name for merging
label variable stock_code "Stock code identifier"

* Extract year from accounting period (Accper)
gen year_str = substr(Accper, 1, 4)  // Extract first 4 characters (YYYY)
destring year_str, gen(year)         // Convert to numeric
drop year_str                        // Remove temporary string variable
label variable year "Fiscal year"

* Extract month from accounting period (Accper)
gen month_str = substr(Accper, 6, 2)  // Extract first 4 characters (YYYY)
destring month_str, gen(month)         // Convert to numeric
drop month_str                        // Remove temporary string variable


* View results to verify
tab year
describe stock_code year

* ============================================= *
* Financial Variable Standardization (Abbreviated)
* ============================================= *

* 1. Rename variables to international standards
rename A001101000 cash
rename A0d1101101 cli_deposits
rename A0d1102000 stlm_provisions
rename A0d1102101 cli_stlm_funds
rename A0b1103000 cash_cb
rename A0b1104000 depo_oth_banks
rename A0b1105000 prc_metals
rename A0f1106000 loans_net
rename A001107000 trad_sec
rename A0f1108000 deriv_assets
rename A001109000 st_inv_net
rename A001110000 notes_rcv_net
rename A001111000 ar_net
rename A001127000 rcv_financing
rename A001112000 prepay_net
rename A0i1113000 prem_rcv_net
rename A0i1114000 reins_rcv_net
rename A0i1115000 subrog_rcv_net
rename A0i1116000 reins_res_net
rename A0i1116101 reins_unearn_res_net
rename A0i1116201 reins_claim_res_net
rename A0i1116301 reins_life_res_net
rename A0i1116401 reins_hlth_res_net
rename A001119000 int_rcv_net
rename A001120000 div_rcv_net
rename A001121000 oth_rcv_net
rename A0f1122000 reverse_repo_net
rename A001123000 inv_net
rename A001123101 data_res_inv
rename A001128000 contract_assets
rename A001129000 assets_hfs
rename A001124000 curr_part_nca
rename A0d1126000 margin_deposits
rename A001125000 oth_ca
rename A001100000 tot_ca
rename A0i1224000 pol_loans_net
rename A0i1225000 time_deposits
rename A0b1201000 loans_adv_net
rename A001226000 debt_inv
rename A0F1132000 amort_cost_assets
rename A001202000 afs_sec_net
rename A001227000 oth_debt_inv
rename A0F1232000 fvtoci_debt
rename A001203000 htm_net
rename A001204000 lt_rcv_net
rename A001205000 lt_eq_inv_net
rename A001228000 oth_eq_inv
rename A0F1233000 fvtoci_eq
rename A0F1133000 fvtoci_assets
rename A001229000 oth_nc_fin_assets
rename A001206000 lt_debt_inv_net
rename A001207000 lt_inv_net
rename A0i1209000 cap_margin_dep
rename A0i1210000 sep_acct_assets
rename A001211000 inv_prop_net
rename A001212000 ppe_net
rename A001213000 cip_net
rename A001214000 constr_materials
rename A001215000 fa_disp
rename A001216000 bio_assets_net
rename A001217000 oil_gas_net
rename A001230000 rou_assets
rename A001218000 intang_net
rename A0d1218101 exch_seat_fees
rename A001218201 data_res_intang
rename A001219000 dev_costs
rename A001219101 data_res_dev
rename A001220000 goodwill_net
rename A001221000 lt_prepaid_exp
rename A001222000 def_tax_assets
rename A0F1224000 agency_assets
rename A001223000 oth_nca
rename A001200000 tot_nca
rename A0f1300000 oth_assets
rename A001000000 tot_assets
rename A002101000 st_borrow
rename A0d2101101 pledg_borrow
rename A0D2130000 st_fin_pay
rename A0b2102000 cb_borrow
rename A0b2103000 depo_ib
rename A0b2103101 ib_deposits
rename A0b2103201 cust_deposits
rename A0f2104000 funds_borrowed
rename A002105000 trad_liab
rename A0f2106000 deriv_liab
rename A002107000 notes_pay
rename A002108000 ap
rename A002109000 adv_cust
rename A002128000 contract_liab
rename A0f2110000 repo_liab
rename A0i2111000 comm_pay
rename A002112000 emp_ben_pay
rename A002113000 tax_pay
rename A002114000 int_pay
rename A002115000 div_pay
rename A0i2116000 claims_pay
rename A0i2117000 pol_div_pay
rename A0i2118000 pol_holder_dep
rename A0i2119000 ins_cont_res
rename A0i2119101 unearn_prem_res
rename A0i2119201 out_claim_res
rename A0i2119301 life_ins_res
rename A0i2119401 hlth_ins_res
rename A002120000 oth_pay
rename A0i2121000 reins_pay
rename A0d2122000 cli_sec_stlm
rename A0d2123000 und_sec_pay
rename A0i2124000 adv_prem
rename A002129000 liab_hfs
rename A002125000 curr_part_ncl
rename A002126000 oth_cl
rename A002127000 def_inc_curr
rename A002100000 tot_cl
rename A002201000 lt_borrow
rename A0d2202000 sep_acct_liab
rename A002203000 bonds_pay
rename A002211000 lease_liab
rename A002204000 lt_pay
rename A002212000 lt_emp_ben
rename A002205000 spec_pay
rename A002206000 tot_lt_liab
rename A002207000 est_liab
rename A0F2210000 agency_liab
rename A002208000 def_tax_liab
rename A002209000 oth_ncl
rename A002210000 def_inc_nc
rename A002200000 tot_ncl
rename A0f2300000 oth_liab
rename A002000000 tot_liab
rename A003101000 shr_cap
rename A003112000 oth_eq_inst
rename A003112101 pref_shr
rename A003112201 perm_bonds
rename A003112301 oth_equity
rename A003102000 cap_surplus
rename A003102101 treas_stock
rename A003103000 surp_res
rename A0f3104000 gen_risk_res
rename A003105000 ret_earn
rename A003106000 fx_trans
rename A003107000 unconf_inv_loss
rename A0F3108000 trad_risk_res
rename A0F3109000 spec_res
rename A003111000 oth_ci
rename A003100000 tot_parent_eq
rename A003200000 min_int
rename A003000000 tot_eq
rename A004000000 tot_liab_eq

* 2. Apply standard financial transformations
* Size variables (log transform)
gen ln_ta = ln(tot_assets)
*gen ln_rev = ln(revenue) if !missing(revenue)

* Ratios (standardize common financial ratios)
gen curr_ratio = tot_ca / tot_cl
*gen roa = ni / tot_assets  // Requires net income variable
gen debt_eq = tot_liab / tot_eq


* 4. Save the standardized dataset
* Save processed data
save "$data_path/std_BS.dta", replace

* ============================================= *
* INCOME STATEMENT VARIABLE STANDARDIZATION
* ============================================= *

* Load balance sheet data from CSMAR
use "$data_path/FS_Comins.dta", clear
drop if Typrep=="B"

* Create standardized stock code variable
gen stock_code = Stkcd  // Standardize variable name for merging
label variable stock_code "Stock code identifier"

* Extract year from accounting period (Accper)
gen year_str = substr(Accper, 1, 4)  // Extract first 4 characters (YYYY)
destring year_str, gen(year)         // Convert to numeric
drop year_str                        // Remove temporary string variable
label variable year "Fiscal year"

* Extract month from accounting period (Accper)
gen month_str = substr(Accper, 6, 2)  // Extract first 4 characters (YYYY)
destring month_str, gen(month)         // Convert to numeric
drop month_str                        // Remove temporary string variable


* View results to verify
tab year
describe stock_code year

* 1. Core Revenue Items
rename B001100000 total_rev
rename B001101000 revenue
rename Bbd1102000 net_int_inc
rename Bbd1102101 int_inc
rename Bbd1102203 int_exp
rename B0i1103000 earned_prem
rename B0i1103101 prem_inc
rename B0i1103111 reins_prem_inc
rename B0i1103203 ceded_prem
rename B0i1103303 uep_reserve
rename B0d1104000 net_fee_comm
rename B0d1104101 broker_fee_net
rename B0d1104201 underwrite_fee_net
rename B0d1104301 asset_mgmt_fee_net
rename B0d1104401 fee_comm_inc
rename B0d1104501 fee_comm_exp
rename B0f1105000 other_op_inc

* 2. Cost Items  
rename B001200000 total_cost
rename B001201000 cogs
rename B0i1202000 surr_policy
rename B0i1203000 net_claims
rename B0i1203101 claims_paid
rename B0i1203203 reins_claims
rename B0i1204000 net_ins_res
rename B0i1204101 ins_res
rename B0i1204203 reins_res
rename B0i1205000 policy_div
rename B0i1206000 reins_exp
rename B001207000 tax_surcharge
rename B0f1208000 admin_exp
rename B0i1208103 reins_admin
rename B0I1214000 ins_comm_exp
rename B001209000 sell_exp
rename B001210000 mgmt_exp
rename B001216000 rd_exp
rename B001211000 fin_exp
rename B001211101 int_exp_fin
rename B001211203 int_inc_fin
rename B0f1213000 other_op_cost

* 3. Profit Measures
rename B001305000 govt_subsidy
rename B001302000 invest_inc
rename B001302101 equity_invest_inc
rename B001302201 amort_sec_gain
rename B001303000 fx_gain
rename B001306000 hedge_gain
rename B001301000 fv_gain
rename B001212000 asset_impair
rename B001307000 credit_impair
rename B001308000 asset_disp_gain
rename B001300000 op_profit
rename B001400000 non_op_inc
rename B001400101 noncurrent_asset_gain
rename B001500000 non_op_exp
rename B001500101 noncurrent_asset_loss_net
rename B001500201 noncurrent_asset_loss
rename B001000000 ebit
rename B002100000 tax_exp
rename B002000000 net_inc
rename B002000401 cont_op_net
rename B002000501 discont_op_net
rename B002000101 parent_net
rename B002000301 pref_div
rename B002000201 minority_net

* 4. EPS and Comprehensive Income
rename B003000000 eps_basic
rename B004000000 eps_diluted
rename B005000000 oci
rename B005000101 parent_oci
rename B005000102 minority_oci
rename B006000000 comp_inc
rename B006000101 parent_comp_inc
rename B006000103 pref_comp_inc
rename B006000102 minority_comp_inc

* ============================================= *
* TRANSFORMATIONS
* ============================================= *

* Size Adjustments
*gen ln_assets = ln(total_assets)  // From balance sheet
gen ln_rev = ln(revenue) if revenue > 0
*gen ln_emp = ln(employees) if !missing(employees) // If available

* Profitability Ratios
*gen roa = net_inc / total_assets
*gen roe = parent_net / total_equity
gen gross_margin = (revenue - cogs) / revenue
gen op_margin = op_profit / revenue

* Financial Structure
*gen leverage = total_liab / total_assets
*gen current_ratio = total_ca / total_cl

* Research Intensity
gen rd_intensity = rd_exp / revenue if revenue > 0

* Insurance Specific (if needed)
gen loss_ratio = net_claims / prem_inc if prem_inc > 0
gen comb_ratio = (net_claims + ins_comm_exp) / prem_inc if prem_inc > 0
save "$data_path/std_income.dta", replace



* ============================================= *
* CASH FLOW STATEMENT VARIABLE STANDARDIZATION
* ============================================= *

use "$data_path/FS_Comscfd.dta", clear
drop if Typrep=="B"
* Create standardized stock code variable
gen stock_code = Stkcd  // Standardize variable name for merging
label variable stock_code "Stock code identifier"

* Extract year from accounting period (Accper)
gen year_str = substr(Accper, 1, 4)  // Extract first 4 characters (YYYY)
destring year_str, gen(year)         // Convert to numeric
drop year_str                        // Remove temporary string variable
label variable year "Fiscal year"

* Extract month from accounting period (Accper)
gen month_str = substr(Accper, 6, 2)  // Extract first 4 characters (YYYY)
destring month_str, gen(month)         // Convert to numeric
drop month_str                        // Remove temporary string variable


* View results to verify
tab year
describe stock_code year

* 1. Company Identifiers and Metadata

* 2. Operating Activities
* Inflows
rename C001001000 cash_from_sales
rename C0b1002000 net_deposit_increase
rename C0F1023000 net_cb_deposit_decrease
rename C0b1003000 net_cb_borrow_increase
rename C0b1004000 net_interbank_increase
rename C0i1005000 cash_from_premiums
rename C0i1006000 net_reinsurance_cash
rename C0i1007000 net_policy_deposit_increase
rename C0d1008000 net_trading_asset_increase
rename C0f1009000 cash_from_interest_fee
rename C0d1010000 net_borrowing_increase
rename C0d1011000 net_repo_increase
rename C0F1024000 net_lending_decrease
rename C0F1025000 net_reverse_repo_decrease
rename C001012000 tax_refund
rename C001013000 other_op_cash_in
rename C001100000 total_op_cash_in

* Outflows 
rename C001014000 cash_for_suppliers
rename C0b1015000 net_loan_increase
rename C0F1026000 net_cb_borrow_decrease
rename C0b1016000 net_cb_deposit_increase
rename C0i1017000 cash_for_claims
rename C0f1018000 cash_for_interest_fee
rename C0F1027000 net_reinsurance_payout
rename C0F1028000 net_policy_deposit_decrease
rename C0F1029000 net_lending_increase
rename C0F1030000 net_reverse_repo_increase
rename C0F1031000 net_borrowing_decrease
rename C0F1032000 net_repo_decrease
rename C0i1019000 cash_for_policy_div
rename C001020000 cash_for_employees
rename C001021000 cash_for_taxes
rename C001022000 other_op_cash_out
rename C001200000 total_op_cash_out
rename C001000000 net_op_cashflow

* 3. Investing Activities
* Inflows
rename C002001000 cash_from_invest_sales
rename C002002000 cash_from_dividends
rename C002003000 cash_from_asset_sales
rename C002004000 cash_from_subsidiary_sales
rename C002005000 other_invest_cash_in
rename C002100000 total_invest_cash_in

* Outflows
rename C002006000 cash_for_capex
rename C002007000 cash_for_investments
rename C0i2008000 net_pledge_loan_increase
rename C002009000 cash_for_subsidiaries
rename C002010000 other_invest_cash_out
rename C002200000 total_invest_cash_out
rename C002000000 net_invest_cashflow

* 4. Financing Activities 
* Inflows
rename C003008000 cash_from_financing
rename C003001000 cash_from_equity
rename C003001101 cash_from_minority
rename C003003000 cash_from_bonds
rename C003002000 cash_from_borrowing
rename C003004000 other_finance_cash_in
rename C003100000 total_finance_cash_in

* Outflows
rename C003005000 cash_for_debt_repay
rename C003006000 cash_for_dividends
rename C003006101 cash_to_minority
rename C003007000 other_finance_cash_out
rename C003200000 total_finance_cash_out
rename C003000000 net_finance_cashflow

* 5. Supplemental Items
rename C004000000 fx_impact_cash
rename C007000000 other_cash_effects
rename C005000000 net_cash_change
rename C005001000 begin_cash_balance
rename C006000000 end_cash_balance

* ============================================= *
* TRANSFORMATIONS
* ============================================= *


* 2. Natural log transformations
foreach var in end_cash_balance net_op_cashflow cash_for_capex {
    gen ln_`var' = ln(abs(`var') + 1) * sign(`var')
}

* ============================================= *
* SAVE
* ============================================= *

save "$data_path/std_CF.dta", replace


* ==============================================
* Financial Variables Standardization
* Dataset: Shareholders' Equity Statement Items
* Last Updated: 2024-03-20
* ==============================================

* ----------------------------------------------
* Step 1: Load the raw dataset
* ----------------------------------------------
use "$data_path/FN_FN046.dta", clear
drop if Typrep=="B"
* Create standardized stock code variable
gen stock_code = Stkcd  // Standardize variable name for merging
label variable stock_code "Stock code identifier"

* Extract year from accounting period (Accper)
gen year_str = substr(Accper, 1, 4)  // Extract first 4 characters (YYYY)
destring year_str, gen(year)         // Convert to numeric
drop year_str                        // Remove temporary string variable
label variable year "Fiscal year"

* Extract month from accounting period (Accper)
gen month_str = substr(Accper, 6, 2)  // Extract first 4 characters (YYYY)
destring month_str, gen(month)         // Convert to numeric
drop month_str                        // Remove temporary string variable


* View results to verify
tab year
describe stock_code year

* ----------------------------------------------
* Step 2: Rename core identification variables
* ----------------------------------------------
rename Stkcd code          // Security code (stock ticker)
rename ShortName name      // Short name of security
rename Accper date        // Reporting date (YYYY-MM-DD)
rename Typrep rtype       // Report type code: 
                         // A=Consolidated current, B=Parent current
                         // C=Consolidated prior, D=Parent prior
rename DataSources source // Announcement source (0=regular report)
rename SubjectCode scode  // Account code (1-15 categories)
rename SubjectName sname  // Account name corresponding to scode

* ----------------------------------------------
* Step 3: Rename financial variables (Fn046 series)
* Organized by conceptual categories
* ----------------------------------------------

* ---- Balance carry-forward items ----
rename Fn04601 pre_bal    // Prior period ending balance
rename Fn04605 open_bal   // Current period opening balance
rename Fn04643 end_bal    // Ending balance

* ---- Adjustments and changes ----
rename Fn04602 acct_chg   // Accounting policy changes
rename Fn04603 error_adj  // Prior period error corrections
rename Fn04604 pre_oth    // Other prior period adjustments
rename Fn04606 delta      // Changes during current period

* ---- Income statement items ----
rename Fn04607 ni         // Net income (profit/loss)
rename Fn04620 tci        // Total comprehensive income

* ---- Other comprehensive income ----
rename Fn04608 oci        // Other comprehensive income
rename Fn04609 afs_fv     // AFS assets fair value change
rename Fn04610 afs_oe     // AFS assets - to equity
rename Fn04611 afs_is     // AFS assets - to income statement
rename Fn04612 hedge_fv   // Cash flow hedge FV change
rename Fn04613 hedge_oe   // Hedge - to equity
rename Fn04614 hedge_is   // Hedge - to income statement
rename Fn04615 hedge_ic   // Hedge - initial recognition
rename Fn04616 equity_inv // Equity method investments
rename Fn04617 fx         // Foreign exchange differences
rename Fn04618 tax_oe     // Tax effects (equity items)
rename Fn04619 oth_gl     // Other gains/losses (equity)

* ---- Capital transactions ----
rename Fn04621 cap_chg    // Capital contributions/withdrawals
rename Fn04622 cap_in     // Owner contributions
rename Fn04623 pref_in    // Preferred stock contributions
rename Fn04624 sbc        // Share-based compensation
rename Fn04625 cap_out    // Capital reductions
rename Fn04626 cap_oth    // Other capital transactions

* ---- Profit distribution ----
rename Fn04627 div        // Profit distribution total
rename Fn04628 div_re     // Retained earnings appropriations
rename Fn04629 div_gr     // General risk reserve
rename Fn04630 div_tr     // Trading risk reserve
rename Fn04631 div_sh     // Shareholder dividends
rename Fn04632 div_oth    // Other distributions

* ---- Equity transfers ----
rename Fn04633 trans      // Equity transfers total
rename Fn04634 trans_cs   // Capital surplus to capital
rename Fn04635 trans_rs   // Retained earnings to capital
rename Fn04636 trans_rl   // Retained earnings cover loss
rename Fn04637 trans_gl   // General reserve cover loss
rename Fn04638 trans_oth  // Other equity transfers

* ---- Special reserves ----
rename Fn04639 reserve    // Special reserve balance
rename Fn04640 reserve_in // Current period provision
rename Fn04641 reserve_out // Current period usage
rename Fn04642 reserve_oth // Other reserve changes

* ----------------------------------------------
* Step 4: Format key variables
* ----------------------------------------------
*format date %tdCCYY-NN-DD  // Standard date format
*label variable code "Security code"
*label variable date "Reporting date (YYYY-MM-DD)"

* ----------------------------------------------
* Step 5: Create logarithmic transformations
* (Example for key continuous variables)
* ----------------------------------------------
gen l_ni = ln(ni) if ni > 0  // Log net income
gen l_end_bal = ln(end_bal) if end_bal > 0  // Log ending balance

* ----------------------------------------------
* Step 6: Save the standardized dataset
* ----------------------------------------------
save "$data_path/std_equity.dta", replace

* ==============================================
* END OF STANDARDIZATION SCRIPT
* ==============================================

