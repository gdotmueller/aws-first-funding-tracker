# Update Receipts Command

Your task is to process new receipt PDFs and update the tracking system.

## Data Files

- **Receipts CSV:** `S:\funding\receipts\receipts_source\receipts_data.csv`
- **Budget Plan:** `S:\funding\receipts\receipts_source\budget_plan.json`
- **Analysis Notebook:** `S:\funding\receipts\receipts_source\receipt_analysis.ipynb`

The budget_plan.json contains personnel costs and investment budgets. The Jupyter notebook handles all compliance calculations including personnel costs towards the 50% Austrian vendor rule.

## Steps to Follow:

1. **Scan for unprocessed PDFs**
   - Scan ALL subfolders ONLY within the receipts directory
   - Find any PDF files (case-insensitive: .pdf, .PDF) in category subfolders that are NOT already in receipts_data.csv
   - Check by comparing filenames in CSV with actual files in folders
   - The category name comes from the subfolder name (e.g., if PDF is in `audio_equipment/`, category is `Audio-Equipment`)
   - Handle new category subfolders automatically - they don't need to be pre-defined
   - Exclude hidden folders (starting with `.`) and special files (README.md, .csv, .ipynb, .json, etc.)

2. **Read each new PDF**
   - Extract the following information:
     - Receipt/invoice number from vendor
     - Invoice/receipt date
     - Vendor name
     - UID/VAT number (USt-IDNr, UID, etc.)
     - ALL individual items with descriptions and prices
     - Receipt total (Gesamtbetrag)
   - For each item, ensure price is GROSS (including VAT):
     - If shown as "inkl. USt." or "Stückpreis (inkl. USt.)" → use that price
     - If shown as "ohne USt." or net price → calculate gross by applying VAT rate
   - Determine if vendor is Austrian (UID starts with "ATU")
   - Check if receipt total ≥50€ (fundable)

3. **Rename new PDFs**
   - Follow the naming convention: `Category_YYYY-MM-DD_Vendor_Description_TotalAmount.pdf`
   - Category comes from the folder name (convert underscores/spaces to proper format, e.g., `audio_equipment` → `Audio-Equipment`)
   - Description can be generic (e.g., "Multi-Order") if multiple items, or specific if single item
   - TotalAmount = receipt total rounded to whole euros (not individual item amounts)
   - Use hyphens for multi-word descriptions
   - Keep the renamed file in its original folder

4. **Update CSV**
   - Read existing receipts_data.csv
   - Create ONE ROW PER ITEM on the receipt
   - All items from same receipt share: Receipt_Number, Filename, Receipt_Total, Is_Fundable
   - Column order: Receipt_Number, Filename, Category, Date, Vendor, Item_Description, Item_Amount_Exact, UID_Number, Is_ATU, Receipt_Total, Is_Fundable
   - Check for duplicates by Receipt_Number before adding
   - Sort by date (oldest to newest)

5. **Report Summary**
   - Show how many new receipts were processed
   - List the new receipts added with their totals and ATU status
   - Show basic totals:
     - Total receipts in CSV
     - Total spending from receipts
     - ATU vendor spending
     - Non-ATU vendor spending

6. **Direct user to notebook for full analysis**
   - Tell the user: "Run the Jupyter notebook for full compliance analysis including personnel costs:"
   - Command: `jupyter notebook receipt_analysis.ipynb`
   - The notebook will:
     - Load budget_plan.json for personnel costs
     - Calculate Austrian compliance (receipts + personnel)
     - Generate visualizations and reports

## Important Rules:
- NEVER modify or remove existing entries from the CSV
- NEVER rename files that are already properly named and in the CSV
- Always check for duplicates before adding to CSV
- Round all amounts to whole euros (no decimals)
- Verify UID numbers carefully - ATU = Austrian
- Do NOT calculate compliance yourself - the notebook handles this with personnel costs

## Why the notebook handles compliance:

The 50% Austrian vendor rule includes personnel costs for Austrian residents (confirmed by AWS). The notebook:
1. Loads `budget_plan.json` for personnel costs (€12,960 at 90% funding)
2. Adds personnel to Austrian spending
3. Calculates: Austrian % = (ATU vendors + Personnel) / (Total receipts + Personnel)

This is handled in code for accuracy and consistency.
