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
    # Standard field groups
    FIELD_GROUPS = {
        "dupont": [
            "roe",                     # 净资产收益率
            "dupont_assetstoequity",   # 权益乘数
            "dupont_equitymultiplier",  # 权益乘数(杜邦)
            "dupont_npmargin",         # 销售净利率(杜邦)
            "dupont_assetsturnover",    # 资产周转率(杜邦)
            "dupont_taxburden",        # 税收负担率
            "dupont_intburden",        # 利息负担率
            "dupont_ebitmargin"        # 息税前利润率
        ],
        "profitability": [
            "roe_avg",                 # ROE(平均)
            "roe_basic",               # ROE(加权)
            "roe_diluted",             # ROE(摊薄)
            "roe_deducted",            # ROE(扣除/平均)
            "roe_exbasic",             # ROE(扣除/加权)
            "roe_exdiluted",           # ROE(扣除/摊薄)
            "roe_add",                 # ROE-增发条件
            "roa2",                    # 总资产报酬率
            "roa",                     # 总资产净利率
            "roic",                    # 投入资本回报率
            "ROP",                     # 人力投入回报率
            "roe_yearly",              # 净资产收益率(年化)
            "roa2_yearly",             # 总资产报酬率(年化)
            "roa_yearly",              # 总资产净利率(年化)
            "netprofitmargin",         # 销售净利率
            "netprofitmargin_deducted", # 扣非后销售净利率
            "grossprofitmargin",       # 销售毛利率
            "cogstosales",             # 销售成本率
            "nptocostexpense",         # 成本费用利润率
            "expensetosales",          # 销售期间费用率
            "optoebt",                 # 主营业务比率
            "profittogr",              # 净利润/营业总收入
            "optogr",                  # 营业利润/营业总收入
            "ebittogr",                # 息税前利润/营业总收入
            "gctogr",                  # 营业总成本/营业总收入
            "operateexpensetogr",      # 销售费用/营业总收入
            "adminexpensetogr",        # 管理费用/营业总收入
            "finaexpensetogr",         # 财务费用/营业总收入
            "impairtoOP",              # 资产减值损失/营业利润
            "ebitdatosales"            # EBITDA/营业总收入
        ],
        "earnings_quality": [
            "operateincometoebt",      # 经营活动/利润总额
            "investincometoebt",       # 价值变动/利润总额
            "nonoperateprofittoebt",   # 营业外收支净额/利润总额
            "taxtoebt",                # 所得税/利润总额
            "deductedprofittoprofit",  # 扣除非经常损益后的净利润/净利润
            "accrualratio",            # 应计比率
            "recquality",              # 应收账款质量
            "invquality",              # 存货质量
            "cfo_to_ni",               # 经营活动现金流/净利润
            "revenuegrowth",           # 收入增长率
            "earningspersistence"      # 盈利持续性指标
        ],
        "cash_flow": [
            "salescashintoor",         # 销售商品提供劳务收到的现金/营业收入
            "ocftoor",                 # 经营活动现金流净额/营业收入
            "ocftooperateincome",      # 经营活动现金流净额/营业利润
            "fa_netprofitcashcover",   # 净利润现金含量
            "capitalizedtoda",         # 资本支出/折旧和摊销
            "ocftocf",                 # 经营活动现金流净额/总现金流
            "icftocf",                 # 投资活动现金流净额/总现金流
            "fcftocf",                 # 筹资活动现金流净额/总现金流
            "ocftosales",              # 经营活动现金流净额/销售收入
            "ocftoinveststockdividend",# 现金流回报收益率
            "ocftoop",                 # 现金营运指数
            "ocftoassets",             # 全部资产现金回收率
            "ocftodividend",           # 现金股利保障倍数
            "freecashflow",            # 自由现金流
            "cashconversioncycle",     # 现金转换周期
            "capexratio"               # 资本支出比率
        ],
        "capital_structure": [
           "debttoassets",              # 资产负债率
           "deducteddebttoassets2",     # 获取数据及应用的资产负债率
           "deducteddebttoassets",      # 余额或款项后的负债/总资产
           "longdebttolongcapital",     # 明资本负债率
           "longcapitaltoinvestment",   # 明资产适合率
           "assetstoequity",            # 权益乘数
           "equity_to_asset",           # 权益比
           "catoassets",                # 流动资产/总资产
           "currentdebttoequity",       # 流动负债权益比率
           "ncatoassets",               # 非流动资产/总资产
           "longdebttoequity",          # 长期负债权益比率
           "tangibleassetstoassets",    # 有形资产/总资产
           "equitytototalcapital",      # 归属于母公司股东的权益/全部投入资本
           "intdebttototalcap",         # 有息负债/全部投入资本
           "currentdebttodebt",         # 流动负债/负债合计
           "longdebtodebt",             # 长期负债/负债合计
           "ncatoequity",               # 固定资产化比率
           "ibdebtratio"                # 有息负债率
       ],
       "solvency": [
            # Liquidity Ratios
            "current",                  # 流动比率
            "quick",                    # 速动比率
            "cashratio",                # 保守速动比率
            "cashtocurrentdebt",        # 现金比率
            "ocftoquickdebt",           # 现金到期债务比
            
            # Interest Coverage
            "ocftointerest",            # 现金流量利息保障倍数
            "ebittointerest",           # 已获利息倍数(EBIT/利息费用)
            "ebitdatointerest",         # EBITDA/利息费用
            
            # Debt Structure
            "debttoequity",             # 产权比率
            "fa_debttoeqy",             # 净资产负债率
            "fa_netdebtratio",          # 净负债率
            "equitytodebt",             # 归属母公司股东的权益/负债合计
            "equitytointerestdebt",     # 归属母公司股东的权益/带息债务
            "longdebttodebt",           # 长期负债占比
            
            # Tangible Asset Coverage
            "tangibleassettodebt",      # 有形资产/负债合计
            "tangassettointdebt",       # 有形资产/带息债务
            "tangibleassettonetdebt",   # 有形资产/净债务
            "debttotangibleequity",     # 有形净值债务率
            
            # Cash Flow Coverage
            "ocftodebt",                # 经营活动现金流净额/负债合计
            "ocftointerestdebt",        # 经营活动现金流净额/带息债务
            "ocftoshortdebt",           # 经营活动现金流净额/流动负债
            "ocftolongdebt",            # 经营活动现金流净额/非流动负债
            "ocftonetdebt",             # 经营活动现金流净额/净债务
            "ocficftocurrentdebt",      # 非筹资性现金净流量与流动负债的比率
            "ocficftodebt",             # 非筹资性现金净流量与负债总额的比率
            
            # EBITDA Coverage
            "ebitdatodebt",             # 息税折旧摊销前利润/负债合计
            "ebitdatointerestdebt",     # EBITDA/带息债务
            "tltoebitda",               # 全部债务/EBITDA
            
            # Specialized Ratios
            "longdebttoworkingcapital", # 长期债务与营运资金比率
            "netdebttoev",              # 净债务/股权价值
            "interestdebttoev",         # 带息债务/股权价值
            "cashtostdebt",             # 货币资金/短期债务
            "fa_stdebtratio",           # 现金短债比
            "fa_crofll"                 # 长期债务资本化比率
        ],        
       "operational_capability": [
            "turndays",                 # 营业周期(天)
            "invturndays",              # 存货周转天数
            "arturndays",               # 应收账款周转天数
            "apturndays",               # 应付账款周转天数
            "netturndays",              # 净营业周期
            "invturn",                  # 存货周转率
            "arturn",                   # 应收账款周转率
            "fa_amrturn",               # 流动资产周转率
            "caturn",                   # 固定资产周转率
            "operatecapitalturn",       # 营运资本周转率
            "faturn",                   # 非流动资产周转率
            "non_currentassetsturn",    # 非流动资产周转率(补充)
            "assetsturn1",              # 总资产周转率
            "turnover_ttm",             # 应付账款周转率(TTM)
            "apturn",                   # 应付账款周转率
            "fa_apppturn",              # 应收账款及应付票据周转率
            "fa_arturn_reserve",        # 现金周转率(备用)
            "fa_cashturnratio"          # 现金周转比率
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