# 🏠 Airbnb End-to-End Data Engineering Pipeline
### AWS · Snowflake · dbt · Medallion Architecture

---

## 📌 Project Overview

An end-to-end data engineering pipeline built on a real-world Airbnb dataset. Raw data is ingested from **AWS S3** into **Snowflake**, transformed across **Bronze → Silver → Gold** layers using **dbt**, and modeled into a **Star Schema** ready for analytics.

The project covers the full lifecycle of a modern data pipeline: ingestion, incremental loading, dimensional modeling, SCD Type-2 history tracking and metadata-driven pipelines.

---

## 🏗️ Architecture

```
AWS S3 (Raw Data)
      │
      ▼
Snowflake (External Stage via IAM)
      │
      ▼
┌─────────────────────────────────────┐
│         Medallion Architecture      │
│                                     │
│  Bronze Layer  →  Raw ingestion     │
│  Silver Layer  →  Cleaned & upserted│
│  Gold Layer    →  Star Schema       │
└─────────────────────────────────────┘
      │
      ▼
Analytics-Ready Data (Fact & Dimension Tables)
```

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| **AWS S3** | Raw data storage |
| **AWS IAM** | Secure Snowflake-S3 integration |
| **Snowflake** | Cloud data warehouse |
| **dbt (data build tool)** | Data transformation & modeling |
| **Python** | Data upload scripting |
| **Git** | Version control |

---

## 📂 Project Structure

```
├── Source/                    # Raw Airbnb CSV source files
├── dbt_snowflake_aws/
│   ├── models/
│   │   ├── bronze/            # Raw ingestion models
│   │   ├── silver/            # Cleaned & deduplicated models
│   │   └── gold/              # Star schema (facts & dimensions)
│   ├── snapshots/             # SCD Type-2 historical tracking
│   ├── macros/                # Reusable Jinja macros
│   ├── seeds/                 # Static reference data
│   ├── tests/                 # dbt data quality tests
│   └── dbt_project.yml        # dbt project configuration
├── main.py                    # Python script for S3 data upload
├── pyproject.toml             # Python project config
└── .gitignore
```

---

## ⚙️ Key Features

### 🥉 Bronze Layer — Raw Ingestion
- Data loaded from S3 into Snowflake via an external stage with IAM authentication
- Raw tables preserved as-is for auditability

### 🥈 Silver Layer — Cleansing & Incremental Loads
- Incremental loading strategy to process only new/changed records
- Upsert logic to handle duplicate and updated rows
- Data type casting and null handling

### 🥇 Gold Layer — Star Schema
- Fact and dimension tables modeled for analytical queries
- Conformed dimensions for listings, hosts, reviews, and dates

### 📸 SCD Type-2 with dbt Snapshots
- Historical changes tracked on slowly changing dimensions
- Full audit trail of record changes over time using `dbt snapshot`

### ⚙️ Metadata-Driven Pipelines
- Pipeline behaviour controlled via configuration rather than hardcoded logic
- Makes the pipeline scalable and easier to maintain

---

## 🚀 Getting Started

### Prerequisites
- Snowflake account
- AWS account with S3 bucket
- Python 3.10+
- dbt Core with Snowflake adapter

### Installation

```bash
# Clone the repository
git clone https://github.com/Hamza-Abbas/Airbnb_aws_dbt-snowflake-pipeline.git
cd Airbnb_aws_dbt-snowflake-pipeline

# Install Python dependencies
pip install -r requirements.txt

# Install dbt packages
cd dbt_snowflake_aws
dbt deps
```

### Configure Snowflake Connection

Create a `profiles.yml` file in `~/.dbt/` (never commit this file):

```yaml
dbt_snowflake_aws:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your_account>
      user: <your_username>
      password: <your_password>
      role: <your_role>
      database: <your_database>
      warehouse: <your_warehouse>
      schema: <your_schema>
```

### Run the Pipeline

```bash
# Upload raw data to S3
python main.py

# Run all dbt models
dbt run

# Run data quality tests
dbt test

# Run snapshots (SCD Type-2)
dbt snapshot
```

---

## 📊 Data Model

The Gold layer follows a **Star Schema** design:

```
               ┌──────────────┐
               │  FACT_REVIEWS│
               └──────────────┘
                       │
       ┌───────────────┼───────────────┐
       ▼               ▼               ▼
┌─────────────┐ ┌─────────────┐ ┌───────────┐
│ DIM_LISTINGS│ │  DIM_HOSTS  │ │ DIM_DATES │
└─────────────┘ └─────────────┘ └───────────┘
```

---

## 📚 Concepts Learned and Demonstrated

- Medallion Architecture (Bronze / Silver / Gold)
- Incremental data loading strategies
- Upsert patterns in Snowflake with dbt
- Slowly Changing Dimensions (SCD Type-2)
- Star Schema dimensional modeling
- Metadata-driven pipeline design
- Jinja templating and dbt macros
- Data quality testing with dbt

---

## 🔐 Security Notes

- Snowflake credentials are stored in `~/.dbt/profiles.yml` and never committed to version control
- AWS IAM roles are used for secure S3-to-Snowflake integration (no hardcoded keys)
