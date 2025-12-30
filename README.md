# Grant Management System

## Overview
This repository manages two aspects of a **government grant**:
1. **Receipt Tracking** - Investment receipts with Austrian vendor compliance requirements
2. **Monthly Progress Reports** - Time tracking and goal achievement reporting

---

# 📋 Receipt Management

## Compliance Requirement
**At least 50% of total project spending must come from Austrian sources** (UID numbers starting with "ATU")

### Important: Personnel Costs Count!
AWS confirmed that **personnel costs for Austrian residents count towards the 50% Austrian rule**.

**Compliance Formula:**
```
Austrian % = (ATU Vendors + Personnel) / (Receipts + Personnel)
```

**Current Budget (90% funded):**
- Personnel: €12,960 (counts as Austrian)
- Investment: €14,850

**Threshold Calculation:**
- Total Project = €12,960 + €14,850 = €27,810
- 50% Threshold = €13,905 needed from Austrian sources
- Personnel already contributes €12,960, so only €945 ATU vendor spending required

**Risk:** If personnel costs are reduced (missed workshops, late reports), you'll need more ATU vendor spending to compensate.

## Folder Structure
```
receipts_source/                    # Receipt processing area
├── receipts_data.csv               # Master database of all receipts
├── budget_plan.json                # Personnel & investment budget data
├── receipt_analysis.ipynb          # Jupyter notebook for analysis
└── [analysis outputs]              # Generated reports and charts

receipts_original/                  # Original receipt PDFs
├── audio_equipment/                # Category: Audio equipment receipts
├── CAD-PC/                         # Category: CAD workstation receipts
├── ML-PC/                          # Category: ML workstation receipts
├── Subscriptions/                  # Category: Software subscriptions
└── [other_categories]/             # Create new category folders as needed
```

## File Naming Convention
All receipt PDFs are renamed to follow a standardized format:

```
Category_YYYY-MM-DD_Vendor_Description_Amount.pdf
```

**Examples:**
- `Audio-Equipment_2025-11-24_Amazon_NEEWER-Lavalier-Mics_15.pdf`
- `CAD-PC_2025-12-10_MediaMarkt_WD-Black-SSD-2TB_129.pdf`

## How to Add New Receipts

### Step 1: Organize PDF Files
Place new receipt PDFs into the appropriate category subfolder under `receipts/`

### Step 2: Process with Claude Code
```bash
/update-receipts
```

This will automatically:
- Extract data from PDFs
- Rename files
- Update the CSV database
- Check compliance status

### Step 3: Analyze Results
```bash
jupyter notebook receipt_analysis.ipynb
```

The notebook will:
- Load budget data from `budget_plan.json`
- Calculate compliance including personnel costs
- Generate visualizations and reports

---

# 📊 Monthly Progress Reports

## Overview
Generate monthly progress reports from Clockify time tracking data and git commit history.

## Folder Structure
```
monthly-reports/
├── template.xlsx                    # Progress report template
├── repos.txt                        # List of git repository paths
└── [month-name]/                    # e.g., "december", "january"
    ├── Clockify*.csv                # Clockify time tracking export(s)
    └── progress_report_[Month]_2025.xlsx  # Generated output
```

## How to Generate Monthly Reports

### Step 1: Prepare Data
1. Export Clockify detailed time report as CSV to the month folder (e.g., `monthly-reports/december_2025/`)
2. Ensure `repos.txt` contains correct git repository paths

### Step 2: Generate Report
Navigate to the month folder and run:
```bash
cd monthly-reports/december_2025
/monthly-report
```

Or from anywhere:
```bash
/monthly-report december_2025
```

### Step 3: Import to Google Sheets
1. Open the generated `progress_report_December_2025.xlsx`
2. In Google Sheets: File → Import
3. Upload the file
4. Copy the December tab to your main progress report

## What the Command Does

The `/monthly-report` command will:
1. Find all Clockify CSV files in the month folder
2. Fetch git logs from repositories listed in `repos.txt`
3. Aggregate time tracking into goals
4. Analyze git commits to extract implemented features
5. Infer goals, definitions of done, and measures
6. Ask you to confirm goal statuses and provide missing information
7. Generate an Excel file ready for Google Sheets import

## repos.txt Format

List git repository paths (one per line):
```
/path/to/local/repo1
/path/to/local/repo2
```

The command will:
- Pull latest `develop` branch
- Extract commits for the specified month
- Use commit messages to enhance progress report details

---

# 🛠️ Setup

## First Time Setup

### Install Dependencies
```bash
setup_venv.bat          # Windows
```

This creates a Python virtual environment and installs:
- pandas (data processing)
- matplotlib & seaborn (visualization)
- jupyter (analysis notebooks)
- openpyxl (Excel file handling)

### Configure Git Repositories
Create `monthly-reports/repos.txt` with your repository paths.

---

# 📚 Quick Reference

## Receipt Management

| Task | Command |
|------|---------|
| Process new receipts | `/update-receipts` |
| View analysis | `jupyter notebook receipt_analysis.ipynb` |
| Check compliance | Run notebook or check `receipts_data.csv` |

## Progress Reports

| Task | Command |
|------|---------|
| Generate monthly report | `/monthly-report [month]` |
| View template | Open `monthly-reports/template.xlsx` |
| Configure repos | Edit `monthly-reports/repos.txt` |

## General

| Task | Command |
|------|---------|
| First time setup | `setup_venv.bat` |
| Activate venv | `venv\Scripts\activate.bat` |

---

# 📝 Important Notes

## Receipt Management
- ⚠️ Never manually edit the CSV - use `/update-receipts`
- ✅ Always keep original PDFs
- 📊 Run Jupyter notebook regularly to track compliance
- 🇦🇹 Prioritize Austrian vendors (50% requirement)

## Progress Reports
- 📅 Export Clockify data at end of each month
- 🔄 Git repositories will be auto-pulled to `develop` branch
- ❓ Claude will ask for clarification on ambiguous goals
- 📋 Review generated reports before importing to Google Sheets

---

# 🔧 Technical Details

## Technologies Used
- **Python 3.8+** - Data processing
- **Pandas** - CSV and data manipulation
- **openpyxl** - Excel file handling
- **Matplotlib & Seaborn** - Visualization
- **Jupyter Lab** - Interactive analysis
- **Claude Code** - AI-assisted automation

## File Formats
- **CSV** - Receipt database, Clockify exports
- **PDF** - Receipt documents
- **XLSX** - Progress report template and outputs
- **Jupyter Notebook** - Analysis and reporting

---

**Last Updated:** 2025-12-30
