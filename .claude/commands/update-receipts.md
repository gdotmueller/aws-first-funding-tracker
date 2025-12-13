# Update Receipts Command

Your task is to process new receipt PDFs and update the tracking system.

## Steps to Follow:

1. **Scan for unprocessed PDFs**
   - Scan ALL subfolders ONLY within the root directory (where receipts_data.csv is located)
   - Ignore any files/folders at the root level (those are for originals/backups)
   - Find any PDF files (case-insensitive: .pdf, .PDF) in category subfolders that are NOT already in receipts_data.csv
   - Check by comparing filenames in CSV with actual files in folders
   - The category name comes from the subfolder name (e.g., if PDF is in `audio_equipment/`, category is `Audio-Equipment`)
   - Handle new category subfolders automatically - they don't need to be pre-defined
   - Exclude hidden folders (starting with `.`) and special files (README.md, .csv, .ipynb, etc.)

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
   - List the new receipts added
   - Calculate and display updated compliance metrics:
     - Total investment
     - Austrian vendor spending (ATU)
     - Non-Austrian vendor spending
     - Austrian vendor percentage
     - Compliance status (≥50% required)
     - If non-compliant, show how much more Austrian spending is needed

6. **Remind user**
   - Remind them to run the Jupyter notebook for full analysis and visualizations
   - Command: `jupyter notebook receipt_analysis.ipynb`

## Important Rules:
- NEVER modify or remove existing entries from the CSV
- NEVER rename files that are already properly named and in the CSV
- Always check for duplicates before adding to CSV
- Round all amounts to whole euros (no decimals)
- Verify UID numbers carefully - ATU = Austrian
