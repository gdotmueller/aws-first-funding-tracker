# Grant Receipt Management System

## Overview
This folder manages receipts for a **government grant** with a compliance requirement:
- **At least 50% of total investments must be sourced from Austrian vendors** (UID numbers starting with "ATU")

## Folder Structure
```
receipts/                        # Root folder
├── audio_equipment/             # Category: Audio equipment receipts
├── CAD-PC/                      # Category: CAD workstation receipts
├── [other_categories]/          # Create new category folders as needed
│
├── receipts_data.csv            # Master database of all receipts
├── receipt_analysis.ipynb       # Jupyter notebook for analysis
├── requirements.txt             # Python dependencies
├── setup_venv.bat               # Setup script (Windows)
├── run_notebook.bat             # Run Jupyter notebook (Windows)
├── README.md                    # This file
├── .clinerules                  # Claude Code project rules
├── venv/                        # Python virtual environment (created by setup)
└── .claude/
    └── commands/
        └── update-receipts.md   # Slash command for processing new receipts

Note: Keep original/unprocessed receipts outside these category folders
      (e.g., in a separate 'originals/' folder or at root level)
```

## File Naming Convention
All receipt PDFs are renamed to follow a standardized format for easy identification:

```
Category_YYYY-MM-DD_Vendor_Description_Amount.pdf
```

**Examples:**
- `Audio-Equipment_2025-11-24_Amazon_NEEWER-Lavalier-Mics_15.pdf`
- `CAD-PC_2025-12-10_MediaMarkt_WD-Black-SSD-2TB_129.pdf`
- `CAD-PC_2025-12-12_e-tec_BeQuiet-PSU-850W_126.pdf`

**Components:**
- **Category**: Investment type (from folder name)
- **Date**: Purchase date in ISO format (YYYY-MM-DD)
- **Vendor**: Short vendor name
- **Description**: Brief item description (use hyphens for spaces)
- **Amount**: Rounded to whole euros (no € symbol)

## CSV Database
The `receipts_data.csv` file contains all receipt information:

| Column | Description |
|--------|-------------|
| Filename | The renamed PDF filename |
| Category | Investment category |
| Date | Purchase date (YYYY-MM-DD) |
| Vendor | Vendor name |
| Description | Item description |
| Amount_EUR | Amount in whole euros |
| UID_Number | Vendor's UID/VAT number |
| Is_ATU | "Yes" for Austrian vendors, "No" for others |

## Austrian Vendor Compliance
**Requirement:** ≥50% of total spending must be from Austrian vendors

**How to identify Austrian vendors:**
- UID numbers starting with **ATU** (e.g., ATU49501105)
- Examples of non-Austrian:
  - LU = Luxembourg (Amazon EU)
  - CN = China
  - IT = Italy
  - GB = United Kingdom

**Known Austrian Vendors:**
- MediaMarkt Linz: ATU49501105
- e-tec electronic GmbH: ATU73063757

## How to Add New Receipts

### Step 1: Organize PDF Files
1. Place new receipt PDFs into the appropriate category subfolder:
   - `audio_equipment/` - for audio equipment
   - `CAD-PC/` - for CAD workstation components
   - Create new subfolders for new categories as needed (e.g., `software/`, `office_furniture/`)

2. **Important:** Only category subfolders are scanned. Keep original/backup receipts at the root level or in a separate folder outside the category subfolders.

### Step 2: Process with Claude Code
Open this folder in Claude Code and run:
```
/update-receipts
```

This command will:
1. Find all new (unprocessed) PDFs
2. Read and extract data from each receipt
3. Rename files according to the naming convention
4. Update the CSV database
5. Show compliance status

### Step 3: Analyze Results

#### First Time Setup
Before running the notebook for the first time, set up the Python virtual environment:

**Windows:**
```bash
setup_venv.bat
```

This will:
- Create a Python virtual environment
- Install all required packages (pandas, matplotlib, seaborn, jupyter)
- Only needs to be run once

#### Running the Analysis
After setup, run the Jupyter notebook:

**Windows:**
```bash
run_notebook.bat
```

**Manual (any OS):**
```bash
# Activate virtual environment
venv\Scripts\activate.bat    # Windows
source venv/bin/activate      # Linux/Mac

# Start Jupyter
jupyter notebook receipt_analysis.ipynb
```

The notebook provides:
- Total investment calculations
- Austrian vs Non-Austrian spending breakdown
- Compliance status (with visual indicators)
- Spending by category and vendor
- Timeline visualizations
- Exportable summary reports

## Compliance Monitoring

The system tracks your Austrian vendor compliance in real-time. After running `/update-receipts`, you'll see:

```
AUSTRIAN VENDOR COMPLIANCE REPORT
Total Investment: €679.00
Austrian (ATU): €255.00 (37.56%)
Non-Austrian: €424.00 (62.44%)

Status: NON-COMPLIANT ✗
Required: ≥50% from Austrian vendors
Shortfall: €84.50 additional Austrian spending needed
```

## Important Notes

⚠️ **Never manually edit the CSV** - use `/update-receipts` to maintain data integrity

✅ **Always keep original PDFs** - even after renaming, keep the original receipts

📊 **Run the Jupyter notebook** regularly to track compliance progress

🇦🇹 **Prioritize Austrian vendors** to meet the 50% requirement

## Quick Reference

| Task | Command |
|------|---------|
| **First time setup** | `setup_venv.bat` |
| Process new receipts | `/update-receipts` (in Claude Code) |
| View analysis | `run_notebook.bat` |
| Check current data | Open `receipts_data.csv` |
| Activate venv manually | `venv\Scripts\activate.bat` |

## Support

If you encounter issues:
1. Check that PDFs are readable and contain invoice data
2. Verify folder structure matches the expected format
3. Ensure `.clinerules` and `/update-receipts` command files are present
4. Review the CSV for duplicates or formatting issues

---

**Last Updated:** 2025-12-13
**Total Receipts:** 8
**Current Compliance:** 37.56% Austrian (need ≥50%)
