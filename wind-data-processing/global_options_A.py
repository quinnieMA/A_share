# -*- coding: utf-8 -*-
"""
Created on Thu Jul  3 09:29:53 2025

@author: FM
"""

import os
from pathlib import Path
from typing import Dict, List, Optional, Set, Tuple

# ========================
# Hardware Resource Configuration
# ========================
class HardwareConfig:
    N_CORES: int = os.cpu_count() - 1 or 1  # Use all CPU cores minus one, keep at least 1
    MAX_MEMORY: str = "8G"  # Maximum memory allocation
    CHUNK_SIZE: int = 200  # Rows processed per batch (adjust based on memory)

# ========================
# Base Path Configuration
# ========================
BASE_DIR = Path("C:/Users/FM/OneDrive/A")
os.environ["WIND_API_CACHE"] = str(BASE_DIR / "wind_cache")  # Cache directory for Wind API

# ========================
# Data Directory Structure
# ========================
class DataPaths:
    # Core directories
    INPUT_DIR = BASE_DIR / "input"
    OUTPUT_DIR = BASE_DIR / "output"
    
    # Financial analysis categories (flat structure)
    FINANCIAL_ANALYSIS_DIR = BASE_DIR / "financial_analysis"
    PER_SHARE_METRICS_DIR = BASE_DIR / "per_share_metrics"
    PROFITABILITY_DIR = BASE_DIR / "profitability"
    EARNINGS_QUALITY_DIR = BASE_DIR / "earnings_quality"
    CASH_FLOW_DIR = BASE_DIR / "cash_flow"
    CAPITAL_STRUCTURE_DIR = BASE_DIR / "capital_structure"
    SOLVENCY_DIR = BASE_DIR / "solvency"
    OPERATIONAL_CAPABILITY_DIR = BASE_DIR / "operational_capability"
    
    # Existing directories (kept for compatibility)
    DUPONT_DATA_DIR = BASE_DIR / "dupont"
    MARKET_DATA_DIR = BASE_DIR / "market"
    
    # Resource files
    STOCK_CODES_FILE = INPUT_DIR / "code.txt"


# ========================
# Wind API Configuration
# ========================
class WindAPIConfig:
    """
    Wind API配置类 | Wind API Configuration Class
    包含从Wind金融终端获取数据的标准字段组 | Contains standard field groups for data retrieval from Wind Financial Terminal
    """
    
    # 标准字段组 | Standard field groups
    FIELD_GROUPS = {
        # 杜邦分析字段 | Dupont Analysis Fields
        "dupont": [
            "roe",                     # 净资产收益率 | Return on Equity (ROE)
            "dupont_assetstoequity",   # 权益乘数 | Equity Multiplier (Assets/Equity)
            "dupont_equitymultiplier",  # 权益乘数(杜邦) | Dupont Equity Multiplier
            "dupont_npmargin",         # 销售净利率(杜邦) | Dupont Net Profit Margin
            "dupont_assetsturnover",    # 资产周转率(杜邦) | Dupont Asset Turnover
            "dupont_taxburden",        # 税收负担率 | Tax Burden Ratio
            "dupont_intburden",        # 利息负担率 | Interest Burden Ratio
            "dupont_ebitmargin"        # 息税前利润率 | EBIT Margin
        ],
        
        # 盈利能力指标 | Profitability Metrics
        "profitability": [
            "roe_avg",                 # ROE(平均) | ROE (Average)
            "roe_basic",               # ROE(加权) | ROE (Basic)
            "roe_diluted",             # ROE(摊薄) | ROE (Diluted)
            "roe_deducted",            # ROE(扣除/平均) | ROE Deducted (Average)
            "roe_exbasic",             # ROE(扣除/加权) | ROE Excluding Extraordinary Items (Basic)
            "roe_exdiluted",           # ROE(扣除/摊薄) | ROE Excluding Extraordinary Items (Diluted)
            "roe_add",                 # ROE-增发条件 | ROE Additional Issuance Condition
            "roa2",                    # 总资产报酬率 | Return on Assets (ROA)
            "roa",                     # 总资产净利率 | Net Return on Assets
            "roic",                    # 投入资本回报率 | Return on Invested Capital (ROIC)
            "ROP",                     # 人力投入回报率 | Return on People (Human Capital ROI)
            "roe_yearly",              # 净资产收益率(年化) | Annualized ROE
            "roa2_yearly",             # 总资产报酬率(年化) | Annualized ROA
            "roa_yearly",              # 总资产净利率(年化) | Annualized Net ROA
            "netprofitmargin",         # 销售净利率 | Net Profit Margin
            "netprofitmargin_deducted", # 扣非后销售净利率 | Deducted Net Profit Margin
            "grossprofitmargin",       # 销售毛利率 | Gross Profit Margin
            "cogstosales",             # 销售成本率 | Cost of Goods Sold to Sales Ratio
            "nptocostexpense",         # 成本费用利润率 | Net Profit to Cost Expense Ratio
            "expensetosales",          # 销售期间费用率 | Operating Expense to Sales Ratio
            "optoebt",                 # 主营业务比率 | Operating Profit to Earnings Before Tax
            "profittogr",              # 净利润/营业总收入 | Net Profit to Gross Revenue
            "optogr",                  # 营业利润/营业总收入 | Operating Profit to Gross Revenue
            "ebittogr",                # 息税前利润/营业总收入 | EBIT to Gross Revenue
            "gctogr",                  # 营业总成本/营业总收入 | Total Operating Cost to Gross Revenue
            "operateexpensetogr",      # 销售费用/营业总收入 | Operating Expense to Gross Revenue
            "adminexpensetogr",        # 管理费用/营业总收入 | Administrative Expense to Gross Revenue
            "finaexpensetogr",         # 财务费用/营业总收入 | Financial Expense to Gross Revenue
            "impairtoOP",              # 资产减值损失/营业利润 | Impairment Loss to Operating Profit
            "ebitdatosales"            # EBITDA/营业总收入 | EBITDA to Sales
        ],
        
        # 收益质量指标 | Earnings Quality Metrics
        "earnings_quality": [
            "operateincometoebt",      # 经营活动/利润总额 | Operating Income to EBT
            "investincometoebt",       # 价值变动/利润总额 | Investment Income to EBT
            "nonoperateprofittoebt",   # 营业外收支净额/利润总额 | Non-operating Profit to EBT
            "taxtoebt",                # 所得税/利润总额 | Tax to EBT
            "deductedprofittoprofit",  # 扣除非经常损益后的净利润/净利润 | Deducted Profit to Total Profit
            "accrualratio",            # 应计比率 | Accrual Ratio
            "recquality",              # 应收账款质量 | Receivables Quality
            "invquality",              # 存货质量 | Inventory Quality
            "cfo_to_ni",               # 经营活动现金流/净利润 | Cash Flow from Operations to Net Income
            "revenuegrowth",           # 收入增长率 | Revenue Growth Rate
            "earningspersistence"      # 盈利持续性指标 | Earnings Persistence Indicator
        ],
        
        # 现金流指标 | Cash Flow Metrics
        "cash_flow": [
            "salescashintoor",         # 销售商品提供劳务收到的现金/营业收入 | Cash Received from Sales to Operating Revenue
            "ocftoor",                 # 经营活动现金流净额/营业收入 | Operating Cash Flow to Operating Revenue
            "ocftooperateincome",      # 经营活动现金流净额/营业利润 | Operating Cash Flow to Operating Income
            "fa_netprofitcashcover",   # 净利润现金含量 | Net Profit Cash Coverage
            "capitalizedtoda",         # 资本支出/折旧和摊销 | Capital Expenditure to Depreciation & Amortization
            "ocftocf",                 # 经营活动现金流净额/总现金流 | Operating Cash Flow to Total Cash Flow
            "icftocf",                 # 投资活动现金流净额/总现金流 | Investing Cash Flow to Total Cash Flow
            "fcftocf",                 # 筹资活动现金流净额/总现金流 | Financing Cash Flow to Total Cash Flow
            "ocftosales",              # 经营活动现金流净额/销售收入 | Operating Cash Flow to Sales
            "ocftoinveststockdividend",# 现金流回报收益率 | Cash Flow Return on Investment
            "ocftoop",                 # 现金营运指数 | Cash Operating Index
            "ocftoassets",             # 全部资产现金回收率 | Cash Recovery Rate on Total Assets
            "ocftodividend",           # 现金股利保障倍数 | Cash Dividend Coverage Ratio
            "freecashflow",            # 自由现金流 | Free Cash Flow
            "cashconversioncycle",     # 现金转换周期 | Cash Conversion Cycle
            "capexratio"               # 资本支出比率 | Capital Expenditure Ratio
        ],
        
        # 资本结构指标 | Capital Structure Metrics
        "capital_structure": [
           "debttoassets",              # 资产负债率 | Debt to Assets Ratio
           "deducteddebttoassets2",     # 获取数据及应用的资产负债率 | Adjusted Debt to Assets Ratio
           "deducteddebttoassets",      # 余额或款项后的负债/总资产 | Net Debt to Total Assets
           "longdebttolongcapital",     # 明资本负债率 | Long-term Debt to Long-term Capital
           "longcapitaltoinvestment",   # 明资产适合率 | Long-term Capital to Investment Ratio
           "assetstoequity",            # 权益乘数 | Assets to Equity Ratio
           "equity_to_asset",           # 权益比 | Equity to Assets Ratio
           "catoassets",                # 流动资产/总资产 | Current Assets to Total Assets
           "currentdebttoequity",       # 流动负债权益比率 | Current Debt to Equity Ratio
           "ncatoassets",               # 非流动资产/总资产 | Non-current Assets to Total Assets
           "longdebttoequity",          # 长期负债权益比率 | Long-term Debt to Equity Ratio
           "tangibleassetstoassets",    # 有形资产/总资产 | Tangible Assets to Total Assets
           "equitytototalcapital",      # 归属于母公司股东的权益/全部投入资本 | Equity to Total Capital
           "intdebttototalcap",         # 有息负债/全部投入资本 | Interest-bearing Debt to Total Capital
           "currentdebttodebt",         # 流动负债/负债合计 | Current Debt to Total Debt
           "longdebtodebt",             # 长期负债/负债合计 | Long-term Debt to Total Debt
           "ncatoequity",               # 固定资产化比率 | Fixed Assets to Equity Ratio
           "ibdebtratio"                # 有息负债率 | Interest-bearing Debt Ratio
       ],
       
       # 偿债能力指标 | Solvency Metrics
       "solvency": [
            # 流动性比率 | Liquidity Ratios
            "current",                  # 流动比率 | Current Ratio
            "quick",                    # 速动比率 | Quick Ratio
            "cashratio",                # 保守速动比率 | Cash Ratio
            "cashtocurrentdebt",        # 现金比率 | Cash to Current Debt
            "ocftoquickdebt",           # 现金到期债务比 | Operating Cash Flow to Quick Debt
            
            # 利息保障 | Interest Coverage
            "ocftointerest",            # 现金流量利息保障倍数 | Operating Cash Flow to Interest
            "ebittointerest",           # 已获利息倍数(EBIT/利息费用) | EBIT to Interest
            "ebitdatointerest",         # EBITDA/利息费用 | EBITDA to Interest
            
            # 债务结构 | Debt Structure
            "debttoequity",             # 产权比率 | Debt to Equity Ratio
            "fa_debttoeqy",             # 净资产负债率 | Net Debt to Equity
            "fa_netdebtratio",          # 净负债率 | Net Debt Ratio
            "equitytodebt",             # 归属母公司股东的权益/负债合计 | Equity to Debt
            "equitytointerestdebt",     # 归属母公司股东的权益/带息债务 | Equity to Interest-bearing Debt
            "longdebttodebt",           # 长期负债占比 | Long-term Debt Percentage
            
            # 有形资产保障 | Tangible Asset Coverage
            "tangibleassettodebt",      # 有形资产/负债合计 | Tangible Assets to Debt
            "tangassettointdebt",       # 有形资产/带息债务 | Tangible Assets to Interest-bearing Debt
            "tangibleassettonetdebt",   # 有形资产/净债务 | Tangible Assets to Net Debt
            "debttotangibleequity",     # 有形净值债务率 | Debt to Tangible Equity
            
            # 现金流保障 | Cash Flow Coverage
            "ocftodebt",                # 经营活动现金流净额/负债合计 | Operating Cash Flow to Debt
            "ocftointerestdebt",        # 经营活动现金流净额/带息债务 | Operating Cash Flow to Interest-bearing Debt
            "ocftoshortdebt",           # 经营活动现金流净额/流动负债 | Operating Cash Flow to Short-term Debt
            "ocftolongdebt",            # 经营活动现金流净额/非流动负债 | Operating Cash Flow to Long-term Debt
            "ocftonetdebt",             # 经营活动现金流净额/净债务 | Operating Cash Flow to Net Debt
            "ocficftocurrentdebt",      # 非筹资性现金净流量与流动负债的比率 | Non-financing Cash Flow to Current Debt
            "ocficftodebt",             # 非筹资性现金净流量与负债总额的比率 | Non-financing Cash Flow to Total Debt
            
            # EBITDA保障 | EBITDA Coverage
            "ebitdatodebt",             # 息税折旧摊销前利润/负债合计 | EBITDA to Debt
            "ebitdatointerestdebt",     # EBITDA/带息债务 | EBITDA to Interest-bearing Debt
            "tltoebitda",               # 全部债务/EBITDA | Total Liabilities to EBITDA
            
            # 特殊比率 | Specialized Ratios
            "longdebttoworkingcapital", # 长期债务与营运资金比率 | Long-term Debt to Working Capital
            "netdebttoev",              # 净债务/股权价值 | Net Debt to Enterprise Value
            "interestdebttoev",         # 带息债务/股权价值 | Interest-bearing Debt to Enterprise Value
            "cashtostdebt",             # 货币资金/短期债务 | Cash to Short-term Debt
            "fa_stdebtratio",           # 现金短债比 | Cash to Short-term Debt Ratio
            "fa_crofll"                 # 长期债务资本化比率 | Long-term Debt Capitalization Ratio
        ],        
        
       # 运营能力指标 | Operational Capability Metrics
       "operational_capability": [
            "turndays",                 # 营业周期(天) | Operating Cycle (Days)
            "invturndays",              # 存货周转天数 | Inventory Turnover Days
            "arturndays",               # 应收账款周转天数 | Accounts Receivable Turnover Days
            "apturndays",               # 应付账款周转天数 | Accounts Payable Turnover Days
            "netturndays",              # 净营业周期 | Net Operating Cycle
            "invturn",                  # 存货周转率 | Inventory Turnover
            "arturn",                   # 应收账款周转率 | Accounts Receivable Turnover
            "fa_amrturn",               # 流动资产周转率 | Current Assets Turnover
            "caturn",                   # 固定资产周转率 | Fixed Assets Turnover
            "operatecapitalturn",       # 营运资本周转率 | Working Capital Turnover
            "faturn",                   # 非流动资产周转率 | Non-current Assets Turnover
            "non_currentassetsturn",    # 非流动资产周转率(补充) | Non-current Assets Turnover (Supplementary)
            "assetsturn1",              # 总资产周转率 | Total Assets Turnover
            "turnover_ttm",             # 应付账款周转率(TTM) | Accounts Payable Turnover (TTM)
            "apturn",                   # 应付账款周转率 | Accounts Payable Turnover
            "fa_apppturn",              # 应收账款及应付票据周转率 | AR & AP Notes Turnover
            "fa_arturn_reserve",        # 现金周转率(备用) | Cash Turnover (Reserve)
            "fa_cashturnratio"          # 现金周转比率 | Cash Turnover Ratio
        ]
    }
    
    # Default parameters
    DEFAULT_YEAR_RANGE = (2015, 2025)
    DEFAULT_REPORT_DATE = "1231"  # Year-end reporting
    DEFAULT_ENCODING = "utf_8_sig"  # For CSV output

# ========================
# Download Job Configuration
# ========================
class DownloadConfig:
    OUTPUT_FILE_PREFIXES = {
        "dupont": "dupont",
        "profitability": "profitability",
        # Add more mappings as needed
    }
    
    DEFAULT_OUTPUT_FORMAT = "csv"  # csv or excel

# ========================
# Directory Initialization
# ========================
def init_directories():
    """Create all required directory structures"""
    # Core directories
    DataPaths.INPUT_DIR.mkdir(parents=True, exist_ok=True)
    DataPaths.OUTPUT_DIR.mkdir(exist_ok=True)
    
    # Financial analysis directories
    DataPaths.FINANCIAL_ANALYSIS_DIR.mkdir(exist_ok=True)
    DataPaths.PER_SHARE_METRICS_DIR.mkdir(exist_ok=True)
    DataPaths.PROFITABILITY_DIR.mkdir(exist_ok=True)
    DataPaths.EARNINGS_QUALITY_DIR.mkdir(exist_ok=True)
    DataPaths.CASH_FLOW_DIR.mkdir(exist_ok=True)
    DataPaths.CAPITAL_STRUCTURE_DIR.mkdir(exist_ok=True)
    DataPaths.SOLVENCY_DIR.mkdir(exist_ok=True)
    DataPaths.OPERATIONAL_CAPABILITY_DIR.mkdir(exist_ok=True)
    
    # Existing special directories
    DataPaths.DUPONT_DATA_DIR.mkdir(exist_ok=True)
    DataPaths.MARKET_DATA_DIR.mkdir(exist_ok=True)

# Initialize directories
init_directories()

# ========================
# Environment Verification
# ========================
if __name__ == "__main__":
    print("=== Configuration Verification ===")
    print(f"Base directory: {BASE_DIR}")
    print(f"Stock codes file: {DataPaths.STOCK_CODES_FILE} (exists: {DataPaths.STOCK_CODES_FILE.exists()})")
    print(f"Wind API cache: {os.environ['WIND_API_CACHE']}")
    print("\nAvailable directories:")
    for name, path in vars(DataPaths).items():
        if not name.startswith('_') and isinstance(path, Path):
            print(f"{name}: {path} (exists: {path.exists()})")
    print("\nAvailable field groups:")
    for group, fields in WindAPIConfig.FIELD_GROUPS.items():
        print(f"{group}: {len(fields)} fields")