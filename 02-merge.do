// 导入并处理情感分析数据
import delimited "C:\Users\FM\OneDrive\NLP1\DATA\sentiment_results\Chinese_Loughran_McDonald_Financial_Sentiment_results.csv", clear 

// 从document_id提取股票代码和年份
gen stock_code = substr(document_id, 1, strpos(document_id, "_") - 1)
gen year = substr(document_id, strpos(document_id, "_") + 1, 4)
destring year, replace

// 标准化股票代码格式
foreach suffix in SH SZ BJ {
    replace stock_code = subinstr(stock_code, "`suffix'", "", .)
}

// 检查处理结果
tab year
list stock_code in 1/10, clean


. sort stock_code year

. merge 1:1 stock_code year using C:\Users\FM\OneDrive\A\esg_score_finance.dta



* 变量预处理
// 对连续财务变量取对数
foreach var in 营业利润 专利权_账面价值 政府补助 研发投入 营业收入 {
    gen ln_`var' = ln(1 + `var')  // 加1避免零值
    label variable ln_`var' "ln(`var')"
}

// 标准化比率变量
foreach var in 研发人员数量占比 销售毛利率 净资产收益率 总资产报酬率 资产负债率 研发投入总额占营业收入比例 {
    replace `var' = `var'/100  // 转换为小数形式
    label variable `var' "`var'(ratio)"
}

// 情感变量标准化
gen neg_percent = negative / word * 100  // 负面词占比(%)
gen pos_percent = positive / word * 100  // 正面词占比(%)
label variable neg_percent "Negative words(%)"
label variable pos_percent "Positive words(%)"

// 专业变量命名(遵循JFE/RFS命名惯例)
rename 研发人员数量占比 rd_emp_ratio
rename 销售毛利率 gross_margin
rename 净资产收益率 roe
rename 总资产报酬率 roa
rename 资产负债率 leverage
rename 政府补助 gov_subsidy
rename 营业收入 revenue
rename 研发投入 rd_expense

* 描述性统计
estpost summarize score  rd_emp_ratio gross_margin ///
    ln_营业利润 ln_专利权_账面价值 roe roa leverage ln_政府补助 ///
    ln_研发投入 ln_营业收入

gen stockcode=stock_code

destring stockcode,replace

xtset stockcode year

foreach var in 产业布局 产业链 人工智能 代码 优秀 住所 保全 做强 储能 充分发挥 公示 公路 医疗 医疗器械 协同效应 启迪 响应 土地储备 圣泰 地区 处 天然气 奥飞 实华 工商行政管理局 布局 广东省 强 强化 形势 德尔 感染 成 打造 扶持 振兴 换发 推动 数据 新型 旅游 易 景区 智慧 机遇 治理 泽融 热力 环境 理工 琶 生态 生物 电机 电源 盈峰 碳 社会 空间 类型 精 精工 终端 经龙 统一 维护 联盟 聚焦 芬腾 莱茵 规划设计 记录 资源 远致 途径 部署 防控 阿拉尔 面料 领取 高鸿 龙大 {
    rename `var' var_`var'
}
foreach var in 研发人员数量 rd_emp_ratio gross_margin 营业利润 专利权_账面价值 roe roa leverage gov_subsidy 政府补助_营业外收入 资产总计  研发投入总额占营业收入比例 rd_expense revenue ln_营业利润 ln_专利权_账面价值 ln_政府补助 ln_研发投入 ln_营业收入{
    rename `var' fi_`var' 
}
* 回归分析示例
xtreg score  非正式否定情绪 非正式肯定情绪 正式否定情绪 正式肯定情绪 var_*  fi_*, ///
    robust cluster(stock_code)
	
xtset stockcode year

// 批量生成所有fi_变量的滞后项
foreach var of varlist fi_* {
    gen L1_`var' = L.`var'  // 创建滞后一期变量
    label variable L1_`var' "L1.`var'"  // 添加标签
    drop `var'  // 删除原始变量（可选）
}

// 带滞后项的回归模型
xtreg ESG_SCORE_WIND score neg_percent pos_percent var_* L1_fi_*, ///
    fe robust cluster(stock_code)
    
*outreg2 using "ESG_results.xls", replace ctitle(Model 1) ///
    *addtext(Year FE, YES, Firm Cluster, YES) ///
    *label dec(4) keep(neg_percent pos_percent rd_emp_ratio gross_margin)*
