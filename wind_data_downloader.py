# -*- coding: utf-8 -*-
"""
Created on Thu Jul  3 09:13:46 2025

@author: FM

Dupont analysis data downloader using Wind API
"""

import os
from WindPy import *
w.start()

from pathlib import Path
from global_options_A import DataPaths, WindAPIConfig, DownloadConfig

# Initialize Wind API
if not w.isconnected():
    w.start()

# Read stock codes from file
with open(DataPaths.STOCK_CODES_FILE, "r", encoding="utf-8") as f:
    stock_codes = f.read().strip()  # Read the entire string (already comma-separated)

# Validate stock codes
if not stock_codes:
    raise ValueError("Stock code file is empty or format is incorrect")

print("Stock codes read from file:")
print(stock_codes)

# Get fields from global configuration
operational_capability_fields = ",".join(WindAPIConfig.FIELD_GROUPS["operational_capability"])

# Year range to process (from global config)
start_year, end_year = WindAPIConfig.DEFAULT_YEAR_RANGE
for year in range(end_year, start_year - 1, -1):
    print(f"\nProcessing operational_capability data for year {year}...")
    
    # Build query parameters using global config
    query_params = f"rptDate={year}{WindAPIConfig.DEFAULT_REPORT_DATE}"
    
    # Execute WIND query
    data = w.wss(stock_codes, operational_capability_fields, query_params, usedf=True)
    
    # Process results
    if isinstance(data, tuple) and len(data) == 2:
        error_code, result_df = data
        if error_code == 0:
            # Add year column
            result_df['year'] = year
            
            # Build output path using global config
            output_file = DataPaths.DUPONT_DATA_DIR / \
                        f"{DownloadConfig.OUTPUT_FILE_PREFIXES['operational_capability']}_{year}.csv"
            
            try:
                # Save CSV using global encoding
                result_df.to_csv(output_file, 
                               encoding=WindAPIConfig.DEFAULT_ENCODING, 
                               index=True)
                print(f"operational_capability data saved to: {output_file}")
                
                # Show preview
                print(f"Data preview for {year}:")
                print(result_df.head())
                
            except Exception as e:
                print(f"Failed to save {year} data: {e}")
        else:
            print(f"Query failed for {year}. Error code: {error_code}")
    else:
        print(f"Unexpected data format received for {year}")

print("\nDupont data download completed!")