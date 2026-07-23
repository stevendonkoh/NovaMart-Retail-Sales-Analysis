# 🛍️ NovaMart Retail Sales Analysis
## 📖 Project Overview

This project analyses retail sales data for NovaMart, a fictional retail company, using Google Sheets.

The objective was to clean raw sales data, perform exploratory data analysis (EDA), build an interactive dashboard, and generate business insights that can support better decision-making.

This project demonstrates a complete data analytics workflow from raw data to business recommendations.

## 🎯 Project Objectives

- Clean and prepare messy retail sales data
- Perform exploratory data analysis using Pivot Tables
- Build an interactive sales dashboard
- Identify sales trends and business opportunities
- Present actionable business insights and recommendations

  ## 🛠️ Tools Used

- Google Sheets
- Pivot Tables
- Charts
- Data Cleaning Techniques
- Dashboard Design
- GitHub
  
## 📂 Dataset

The dataset represents retail sales transactions from a fictional company, **NovaMart**. It was designed to simulate real-world retail operations and includes intentional data quality issues to demonstrate the data cleaning process.

### Dataset Summary

- **Rows:** 1,500
- **Columns:** 24
- **Time Period:** January – June 2025
- **Currency:** Ghana Cedi (GH₵)

### Key Fields

- Order ID
- Order Date
- Ship Date
- Customer Name
- Customer Age
- Gender
- City
- Region
- Store Branch
- Product Name
- Category
- Quantity
- Unit Price
- Revenue
- Profit
- Payment Method
- Customer Type
- Salesperson
- Returned
  ## 🧹 Data Cleaning

Before analysis, the dataset was cleaned to improve data quality.

### Data Quality Issues Identified

- Duplicate records
- Missing customer names
- Missing payment methods
- Invalid customer ages
- Inconsistent text formatting
- Ship dates occurring before order dates

### Cleaning Actions Performed

- Removed duplicate records
- Standardised text formatting (cities and payment methods)
- Replaced missing customer names with **"Unknown Customer"**
- Replaced missing payment methods with **"Unknown"**
- Cleared invalid age values greater than 100
- Flagged records where ship dates occurred before order dates
  
  ## 📊 Exploratory Data Analysis (EDA)

Pivot Tables were used to answer key business questions including:

- Which category generates the highest revenue?
- Which region performs best?
- Which products generate the most revenue?
- Which payment methods are most popular?
- Which salesperson generates the highest sales?
- What is the customer retention rate?
- What is the return rate?
