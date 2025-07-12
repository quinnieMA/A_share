// 设置工作路径
cd "C:\Users\FM\OneDrive\A"

// 定义年份范围和变量列表
local years 2016 2017 2018 2019 2020 2021 2022 2023 2024
local numvars 研发人员数量 研发人员数量占比 销售毛利率 营业利润 专利权_账面价值 ///
               净资产收益率roe 总资产报酬率roa 资产负债率 政府补助 政府补助_营业外收入 ///
               资产总计 研发投入总额占营业收入比例 研发投入 营业收入

// 初始化临时文件
tempfile master
save `master', emptyok

// 循环处理每个年份的数据
foreach y of local years {
    // 导入CSV文件
    import delimited "photovoltaic_`y'.csv", encoding(utf8) clear
    
    // 统一数值格式处理
    foreach var of varlist `numvars' {
        capture confirm string variable `var'
        if _rc {
            tostring `var', replace force
        }
        replace `var' = subinstr(`var', ",", "", .)  // 移除千分位逗号
        replace `var' = "" if inlist(`var', "-", ".", "NA") // 处理多种缺失值标记
        destring `var', replace
        format `var' %16.2f
    }
    
    // 标准化证券代码
    rename 证券代码 stock_code
    replace stock_code = ustrregexra(stock_code, "\.[A-Z]+$", "")
    
    // 添加年份变量
    gen year = `y'
    label variable year "数据年份"
    
    // 保留处理后的数据
    if `y' == 2016 {
        save `master', replace
    }
    else {
        append using `master'
        save `master', replace
    }
    
    di "已完成 `y' 年数据处理"
}

// 最终数据整理
use `master', clear

// 检查证券代码唯一性
bysort stock_code year: gen dup = _N
assert dup == 1
drop dup

// 设置面板数据结构
xtset stock_code year

// 变量标签
label variable stock_code "证券代码(无后缀)"
label variable 证券简称 "公司名称"

// 保存最终合并文件
save "photovoltaic_panel_2016_2024.dta", replace
export excel using "photovoltaic_panel_2016_2024.xlsx", firstrow(variables) replace
