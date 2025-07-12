* Set global path for data directory
global data_path "C:/Users/FM/OneDrive/A/DATA/三大表/data"

* ============================================= *
* MERGE FINANCIAL STATEMENTS
* ============================================= *

* Load standardized cash flow statement data
use "$data_path/std_CF.dta", clear

* Sort data for merging (using standardized variable names)
sort stock_code year month

* 1. First merge: Cash Flow + Income Statement
merge 1:1 stock_code year month using "$data_path/std_income.dta"
* Keep only successfully matched observations
keep if _merge == 3
drop _merge

* 2. Second merge: Add Balance Sheet data
sort stock_code year month
merge 1:1 stock_code year month using "$data_path/std_BS.dta"
/*
Merge results:
- Not matched: 17,627 obs
  • Master only: 3 obs (_merge==1)
  • Using only (BS data): 17,624 obs (_merge==2)
- Matched: 339,107 obs (_merge==3)
*/

* Keep only complete cases
keep if _merge == 3
drop _merge

drop if year<=2016

* Save merged dataset
save "$data_path/BS_income_CF.dta", replace

* ============================================= *
* TRANSFORMATIONS
* ============================================= *
* 2. Apply standard financial transformations
* Size variables (log transform)
gen ln_ta = ln(tot_assets)
gen ln_rev = ln(revenue) if !missing(revenue)

* Ratios (standardize common financial ratios)
gen curr_ratio = tot_ca / tot_cl
gen roa = net_inc / tot_assets  // Requires net income variable
gen debt_eq = tot_liab / tot_eq


* Size Adjustments
gen ln_assets = ln(tot_assets)  // From balance sheet
*gen ln_rev = ln(revenue) if revenue > 0
*gen ln_emp = ln(employees) if !missing(employees) // If available

* Profitability Ratios
*gen roa = net_inc /tot_assets
gen roe = parent_net / (tot_assets-tot_liab)
gen gross_margin = (revenue - cogs) / revenue
gen op_margin = op_profit / revenue

* Financial Structure
gen leverage = tot_liab /tot_assets
*gen current_ratio = total_ca / total_cl

* Research Intensity
gen rd_intensity = rd_exp / revenue if revenue > 0

* Insurance Specific (if needed)
gen loss_ratio = net_claims / prem_inc if prem_inc > 0
gen comb_ratio = (net_claims + ins_comm_exp) / prem_inc if prem_inc > 0

* 1. Create standardized ratios (all winsorized at 1%)
gen cash_ratio = end_cash_balance / tot_assets if !missing(tot_assets)
gen ocf_sales = net_op_cashflow / revenue if revenue > 0
gen capex_ratio = cash_for_capex / tot_assets if !missing(tot_assets)

save "$data_path/BS_income_CF.dta", replace


* ==============================================
* Variable Cleaning Script: Drop Low-Obs Variables
* Criteria: Variables with <1,000 non-missing observations
* Last Updated: 2024-03-20
* ==============================================

* ----------------------------------------------
* Step 1: Define the variable list
* ----------------------------------------------
local var_list ///
IfCorrect DeclareDate cash_from_sales net_deposit_increase ///
net_cb_deposit_decrease net_cb_borrow_increase net_interbank_increase ///
cash_from_premiums net_reinsurance_cash net_policy_deposit_increase ///
net_trading_asset_increase cash_from_interest_fee net_borrowing_increase ///
net_repo_increase net_lending_decrease net_reverse_repo_decrease tax_refund ///
other_op_cash_in total_op_cash_in cash_for_suppliers net_loan_increase ///
net_cb_borrow_decrease net_cb_deposit_increase cash_for_claims ///
cash_for_interest_fee net_reinsurance_payout net_policy_deposit_decrease ///
net_lending_increase net_reverse_repo_increase net_borrowing_decrease ///
net_repo_decrease cash_for_policy_div cash_for_employees cash_for_taxes ///
other_op_cash_out total_op_cash_out net_op_cashflow cash_from_invest_sales ///
cash_from_dividends cash_from_asset_sales cash_from_subsidiary_sales ///
other_invest_cash_in total_invest_cash_in cash_for_capex cash_for_investments ///
net_pledge_loan_increase cash_for_subsidiaries other_invest_cash_out ///
total_invest_cash_out net_invest_cashflow cash_from_financing cash_from_equity ///
cash_from_minority cash_from_bonds cash_from_borrowing other_finance_cash_in ///
total_finance_cash_in cash_for_debt_repay cash_for_dividends cash_to_minority ///
other_finance_cash_out total_finance_cash_out net_finance_cashflow fx_impact_cash ///
other_cash_effects net_cash_change begin_cash_balance end_cash_balance stock_code ///
year month ln_end_cash_balance ln_net_op_cashflow ln_cash_for_capex total_rev ///
revenue net_int_inc int_inc int_exp earned_prem prem_inc reins_prem_inc ///
ceded_prem uep_reserve net_fee_comm broker_fee_net underwrite_fee_net ///
asset_mgmt_fee_net fee_comm_inc fee_comm_exp other_op_inc total_cost cogs ///
surr_policy net_claims claims_paid reins_claims net_ins_res ins_res reins_res ///
policy_div reins_exp tax_surcharge admin_exp reins_admin ins_comm_exp sell_exp ///
mgmt_exp rd_exp fin_exp int_exp_fin int_inc_fin govt_subsidy invest_inc ///
equity_invest_inc amort_sec_gain fx_gain hedge_gain fv_gain asset_impair ///
credit_impair asset_disp_gain other_op_cost B001304000 op_profit non_op_inc ///
noncurrent_asset_gain non_op_exp noncurrent_asset_loss_net noncurrent_asset_loss ///
ebit tax_exp B002200000 B002300000 net_inc cont_op_net discont_op_net parent_net ///
pref_div minority_net eps_basic eps_diluted oci parent_oci minority_oci comp_inc ///
parent_comp_inc pref_comp_inc minority_comp_inc cash cli_deposits stlm_provisions ///
cli_stlm_funds cash_cb depo_oth_banks prc_metals loans_net trad_sec deriv_assets ///
st_inv_net notes_rcv_net ar_net rcv_financing prepay_net prem_rcv_net ///
reins_rcv_net subrog_rcv_net reins_res_net reins_unearn_res_net reins_claim_res_net ///
reins_life_res_net reins_hlth_res_net int_rcv_net div_rcv_net oth_rcv_net ///
reverse_repo_net inv_net data_res_inv contract_assets assets_hfs curr_part_nca ///
margin_deposits oth_ca tot_ca pol_loans_net time_deposits loans_adv_net ///
debt_inv amort_cost_assets afs_sec_net oth_debt_inv fvtoci_debt htm_net ///
lt_rcv_net lt_eq_inv_net oth_eq_inv fvtoci_eq fvtoci_assets oth_nc_fin_assets ///
lt_debt_inv_net lt_inv_net cap_margin_dep sep_acct_assets inv_prop_net ppe_net ///
cip_net constr_materials fa_disp bio_assets_net oil_gas_net rou_assets ///
intang_net exch_seat_fees data_res_intang dev_costs data_res_dev goodwill_net ///
lt_prepaid_exp def_tax_assets agency_assets oth_nca tot_nca oth_assets tot_assets ///
st_borrow pledg_borrow st_fin_pay cb_borrow depo_ib ib_deposits cust_deposits ///
funds_borrowed trad_liab deriv_liab notes_pay ap adv_cust contract_liab repo_liab ///
comm_pay emp_ben_pay tax_pay int_pay div_pay claims_pay pol_div_pay ///
pol_holder_dep ins_cont_res unearn_prem_res out_claim_res life_ins_res ///
hlth_ins_res oth_pay reins_pay cli_sec_stlm und_sec_pay adv_prem liab_hfs ///
curr_part_ncl oth_cl def_inc_curr tot_cl lt_borrow sep_acct_liab bonds_pay ///
lease_liab lt_pay lt_emp_ben spec_pay tot_lt_liab est_liab agency_liab ///
def_tax_liab oth_ncl def_inc_nc tot_ncl oth_liab tot_liab shr_cap oth_eq_inst ///
pref_shr perm_bonds oth_equity cap_surplus treas_stock surp_res gen_risk_res ///
ret_earn fx_trans unconf_inv_loss trad_risk_res spec_res oth_ci tot_parent_eq ///
min_int tot_eq tot_liab_eq ln_ta ln_rev curr_ratio roa debt_eq ln_assets roe ///
gross_margin op_margin leverage rd_intensity loss_ratio comb_ratio cash_ratio ///
ocf_sales capex_ratio

* ----------------------------------------------
* Step 2: Initialize empty list for variables to drop
* ----------------------------------------------
local vars_to_drop ""

* ----------------------------------------------
* Step 3: Check each variable's observation count
* ----------------------------------------------
foreach var of local var_list {
    qui count if !missing(`var')
    local obs_count = r(N)
    
    if `obs_count' < 1000 {
        di "Variable `var' has only " `obs_count' " obs (will be dropped)"
        local vars_to_drop `vars_to_drop' `var'
    }
    else {
        di "Variable `var' has " `obs_count' " obs (will be kept)"
    }
}

* ----------------------------------------------
* Step 4: Drop low-observation variables if any exist
* ----------------------------------------------
if "`vars_to_drop'" != "" {
    di "Dropping the following variables with <1,000 obs:"
    foreach var of local vars_to_drop {
        di "  - `var'"
    }
    drop `vars_to_drop'
}
else {
    di "No variables with <1,000 obs found"
}

* ----------------------------------------------
* Step 5: Save summary of remaining variables
* ----------------------------------------------
describe

save "$data_path/BS_income_CF.dta", replace


sort stock_code year
merge m:1 stock_code year using "$data_path/industry.dta", keepusing(IndustryCode)
keep if _merge == 3
drop _merge
save "$data_path/BS_income_CF.dta", replace
