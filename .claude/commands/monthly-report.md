# Monthly Progress Report Generator

Generate a monthly progress report from Clockify time tracking data and git commit history.

This command automates the creation of monthly progress reports required for grant compliance. It analyzes time tracking data, git commits, and generates a structured Excel report that can be imported into Google Sheets.

## Directory Structure

The command expects the following structure:

```
s:\funding\receipts\monthly-reports\
├── template.xlsx                    # Progress report template
├── repos.txt                        # List of git repository paths (one per line)
└── [month-name]_2025/                    # e.g., "december", "january"
    ├── Clockify*.csv                # Clockify time tracking export(s)
    └── progress_report_[Month]_2025.xlsx  # Generated output
```

## Workflow

1. **Detect month** from folder name (e.g., `december` → "December")
2. **Find all Clockify CSV files** in the month folder
3. **Read git repositories** from `repos.txt`
4. **Fetch git logs** from all repos for the specified month on `develop` branch
5. **Parse time tracking data** and aggregate into goals
6. **Analyze git commits** to extract implemented features
7. **Infer goals, definitions of done, and measures** automatically
8. **Ask user** for missing information:
   - Hypotheses (if applicable)
   - Goal status confirmation
   - Clarification on ambiguous tasks
9. **Generate Excel report** with preserved formatting
10. **Save** to month folder as `progress_report_[Month]_2025.xlsx`

## Usage

```bash
# Navigate to a month folder
cd s:\funding\receipts\monthly-reports\december

# Run the command
/monthly-report
```

Or from anywhere:

```bash
/monthly-report december
```

## What You Need to Provide

Before running:
1. Export Clockify detailed time report as CSV to the month folder
2. Ensure `repos.txt` contains correct repository paths
3. Ensure repositories are accessible and on `develop` branch

## Output

- Single-sheet Excel file: `progress_report_[Month]_2025.xlsx`
- Ready to import into Google Sheets
- All formatting preserved from template

## Example repos.txt Format

```
ssh://muller@chan:2222/gtm/soundcount_tf_ml.git
/path/to/another/local/repo
```

---

# Progress Report Field Definitions

Understanding each field in the progress report template is crucial for generating accurate and compliant reports.

## Goals
**Purpose:** Challenging goals to be achieved within the current month.

**Requirements:**
- Must be formulated in a way that can be evaluated as **fulfilled or not fulfilled**
- Must have **measurable criteria**
- Should be specific and actionable

**Examples:**
- ✅ Good: "Set up ML Training Infrastructure with GPU support and Docker environment"
- ✅ Good: "Develop soundcount.at landing page and publish online"
- ❌ Bad: "Work on ML stuff" (not measurable)
- ❌ Bad: "Improve code quality" (not specific enough)

**How to infer from Clockify:**
- Group similar time tracking entries together
- Look for concrete deliverables or outcomes
- Use action verbs: "Set up", "Develop", "Build", "Establish", "Create"
- Ensure each goal represents a distinct area of work

## Definition of Done
**Purpose:** What should be the outcome or result of your goal? What are acceptance criteria for achieving this goal?

**Requirements:**
- Clearly state the **expected outcome**
- List **specific acceptance criteria**
- Should be verifiable and concrete

**Examples:**
- ✅ Good: "ML/CAD PC components selected, purchased, assembled, and configured with Docker environment for GPU training"
- ✅ Good: "Landing page for soundcount.at published and accessible online"
- ❌ Bad: "PC is working" (too vague)
- ❌ Bad: "Website exists" (no specific criteria)

**How to infer from Clockify + Git:**
- Look at what was actually accomplished during the month
- Extract concrete outcomes from git commit messages
- List tangible deliverables mentioned in time tracking
- Focus on WHAT was achieved, not HOW

## Hypotheses (Optional)
**Purpose:** What hypotheses (assumptions) are you currently testing? Could they be confirmed or disproved? Did the refutation of a hypothesis lead to new assumptions?

**Requirements:**
- State the assumption being tested
- Include whether it was **validated** or **not validated**
- If disproved, mention any new hypotheses that emerged
- This field is **optional** - only include if hypotheses exist

**Examples:**
- ✅ "Hardware investment in high-performance PC will reduce rendering time by 50% compared to laptop"
- ✅ "Users prefer simple one-button recording over complex multi-track interfaces"
- ✅ "Regular behind-the-scenes content will generate more engagement than polished marketing posts"

**How to infer:**
- Usually **cannot be inferred** from time tracking alone
- Ask user if any hypotheses were being tested
- If user is unsure, leave empty
- **Default: Leave empty and ask user**

## Validated Yes/No
**Purpose:** Indicates whether the hypothesis was confirmed or disproved.

**Options:**
- `yes` - Hypothesis was confirmed
- `no` or `not validated` - Hypothesis was disproved
- `validated` - Alternative way to say "yes"
- Empty if no hypothesis exists

**How to determine:**
- Only fill if a hypothesis exists
- Ask user for validation status
- If hypothesis is ongoing, ask if partial validation is possible

## Measures & Activities
**Purpose:** What specific measures and activities were implemented? Detailed documentation of work done.

**Requirements:**
- **Describe in detail** what was done
- Include **specific numbers** where applicable (hours, iterations, counts)
- Mention **insights and learnings** gained
- Document **problems encountered** and how they were solved
- Note any **changes to project direction** resulting from the work
- Include **dates** for context

**Structure:**
```
- Activity description with hours and date
- Key insights gained
- Problems encountered and solutions
- Project changes resulting from learnings
```

**Examples:**
```
- Purchased and assembled CAD workstation (WD Black SSD, components from MediaMarkt)
- Installed Fusion 360 and completed training tutorials
- Created first enclosure model (8 iterations)
- Rendering time reduced by 65% (hypothesis exceeded)
- Encountered learning curve with parametric modeling - resolved through online courses
```

**How to generate:**
- Combine Clockify task descriptions with hours and dates
- Add git commit messages and features implemented
- Include specific numbers (hours, dates, counts, percentages)
- Format as bullet points for readability
- Use format: `- Action (hours - date)` or `- Action with details`

## Status
**Purpose:** Brief summary of whether the goal was achieved in full, in part, or not at all.

**Requirements:**
- State achievement level clearly
- Include **reasons** if not fully achieved or not achieved
- If not achieved, mention **carry-forward** to next month

**Achievement Levels:**
1. **Fully achieved** - All acceptance criteria met, work complete
2. **Partially achieved** - Some progress made, more work needed
3. **Not achieved** - Ongoing work, will continue next month

**Format:**
```
[Level]. [Brief explanation]. [If not achieved: carry forward note]
```

**Examples:**
- ✅ "Fully achieved. All acceptance criteria met. Prototype successfully tested across all target platforms."
- ✅ "Partially achieved. Accounts established and content published, but follower target not met. Will continue outreach activities next month and shift content strategy toward educational material."
- ✅ "Not achieved. Budget planning ongoing. Meeting held to discuss initial framework, but finalization pending. Will continue in January with detailed budget breakdown and approval."

**How to determine:**
- **Always ask user** for confirmation
- Present inferred goals and ask: "Was this fully achieved, partially achieved, or not achieved?"
- If partially/not achieved, ask for reason
- Suggest carry-forward language for ongoing goals

---

# Implementation Instructions for Claude

When this command is invoked:

1. **Determine month folder**:
   - If argument provided (e.g., `december`), use that
   - Otherwise, check current directory name
   - Convert to capitalized month name (e.g., `december` → `December`)

2. **Validate structure**:
   - Check if in `monthly-reports/[month]` or navigate there
   - Verify `template.xlsx` exists in parent `monthly-reports/` folder
   - Verify `repos.txt` exists in parent folder
   - Find all `Clockify*.csv` files in month folder

3. **Calculate date range**:
   - Map month name to dates (e.g., `December` → `2025-12-01` to `2025-12-31`)
   - Use current year (2025)

4. **Process git repositories**:
   - Read `repos.txt` line by line
   - For each repo path:
     - Check if it's a remote SSH URL or local path
     - If remote: Skip (cannot fetch automatically)
     - If local:
       - Navigate to repo
       - **ALWAYS pull latest changes first:** `git fetch --all && git pull`
       - Run: `git log --since="YYYY-MM-01" --until="YYYY-MM-31" --stat --no-merges --date=short --format="%h - %s (%ad)" --all`
       - The `--all` flag ensures commits from ALL branches (including those merged later) are included
       - Capture output including commit messages and file statistics
       - Parse files added/modified and specific features implemented
   - Aggregate all git logs from all repos

5. **Parse Clockify CSV**:
   - Read all Clockify CSV files
   - Parse columns: Description, Duration (decimal), Start Date
   - Group tasks by similarity into goals
   - Calculate total hours per goal
   - Extract task descriptions for measures

6. **Analyze git commits**:
   - Parse commit messages
   - Extract feature implementations
   - Map to time tracking goals where possible
   - Build detailed "Measures & Activities" text

7. **Infer progress report data**:
   - Create goal titles from task aggregations
   - Generate "Definition of Done" from outcomes
   - Build "Measures & Activities" from:
     - Clockify task descriptions with hours and dates
     - Git commit messages and features
   - Leave Hypotheses empty (ask user if needed)
   - Mark Status as unknown (ask user)

8. **Ask user for confirmation**:
   - Present inferred goals with hours
   - Ask for status of each goal (Fully achieved / Partially achieved / Not achieved)
   - Ask about hypotheses if any exist
   - Ask what to do with unparseable tasks (like "Admin stuff")

9. **Generate Excel file**:
   - Create a Python script `generate_[month]_report.py` in the `monthly-reports/` folder
   - **CRITICAL: Always activate venv before running:**
     ```bash
     s:/funding/receipts/venv/Scripts/activate && python generate_[month]_report.py
     ```
   - The script should load `template.xlsx`
   - Find sheet matching month name (capitalize first letter)
   - Fill rows starting from row 6:
     - Column A: Goal number (1, 2, 3...)
     - Column B: Goal description
     - Column C: Definition of Done
     - Column D: Hypotheses
     - Column E: Validated yes/no
     - Column F: Measures and activities
     - Column G: Status
     - Column H: Team member 1 hours (total hours for goal)
     - Columns I-K: Team member 2-4 hours (set to 0)
   - Remove all sheets except the current month
   - Save as `progress_report_[Month]_2025.xlsx` in month folder

10. **Report completion**:
    - Show summary of goals generated
    - Show total hours tracked
    - Confirm output file location

## Error Handling

- If no Clockify CSV found: Ask user to provide path
- If repos.txt not found: Skip git analysis, use only Clockify data
- If git repo inaccessible: Warn and continue with other repos
- If month not recognized: Ask user for clarification
- If template not found: Error and exit

## Important Notes

- **ALWAYS pull latest git changes first** before fetching logs: `git fetch --all && git pull`
- **Use `--all` flag** in git log to include commits from all branches (including merged ones)
- Parse dates in format: DD/MM/YYYY (Clockify format)
- Handle multi-line task descriptions in Clockify
- Split time entries that mention multiple goals
- Preserve all template formatting when generating output
- Use openpyxl library for Excel manipulation
- **CRITICAL: Activate venv before running Python scripts:**
  ```bash
  s:/funding/receipts/venv/Scripts/activate && python generate_[month]_report.py
  ```

---

# Workflow Notes

Key learnings and patterns from testing the monthly report generation process.

## Git Analysis - Code Changes

**IMPORTANT: Always pull latest changes first:**
```bash
# Navigate to repo and pull latest
cd /path/to/repo
git fetch --all && git pull

# Then get commits from ALL branches (including merged branches)
git log --since="2025-12-01" --until="2025-12-31" --stat --no-merges --date=short --format="%h - %s (%ad)" --all
```

**Why `--all` flag matters:**
- Commits made on feature branches and later merged would be missed without it
- Ensures complete history of all work done in the month
- Captures commits regardless of which branch they were originally on

**Why code changes matter:**
- Commit messages may be vague ("changes", "update", "fix")
- Actual code diffs reveal what features were implemented
- File changes show scope of work (e.g., "Added 5 new files, modified 12")
- Helps generate detailed "Measures & Activities"

**Parse git output for:**
- Commit messages (what was intended)
- Files changed (scope of changes)
- Lines added/removed (magnitude of work)
- Specific code features (e.g., new functions, classes, endpoints)

**Example:**
```
Commit: "Add video annotation tools and refactor project structure"

Files changed:
+ video_annotation/scripts/auto_label_via.py (new)
+ video_annotation/notebooks/statistics.ipynb (new)
~ Makefile (modified)

Code analysis reveals:
- New YOLOv8-based auto-labeling tool
- ByteTrack integration
- VIA JSON export functionality
- Statistics notebook with plotting functions
```

## Aggregate Time Tracking into Goals

**Aggregation algorithm from December test:**

```python
# Example: Raw Clockify entries
entries = [
    ("Build and set up of the machine learning PC", 8),
    ("Create Docker Image and shell script for GPU training", 1),
    ("Find components to use for ML pc", 2),
    ("Melaudis ML model training", 4)
]

# Aggregated goal
goal = {
    'title': 'Set up ML Training Infrastructure',
    'hours': 15,  # Sum of all related entries
    'definition_done': 'ML/CAD PC components selected, purchased, '
                      'assembled, and configured with Docker environment',
    'measures': [
        'Found and selected components for ML/CAD PC (2h - Dec 8)',
        'Built and set up machine learning PC (8h - Dec 17)',
        'Created Docker image for GPU training (1h - Dec 19)',
        'Tested ML model training with Melaudis paper (4h - Dec 1, 6)'
    ]
}
```

**Rules for aggregation:**
- Group tasks with similar keywords (e.g., "ML", "machine learning", "training")
- Group tasks related to same deliverable (e.g., "PC setup", "Docker")
- Keep distinct goals separate (e.g., "Website" vs "ML training")
- **Split multi-goal entries** (see next section)

## Split Multi-Goal Time Entries

**Example from December test:**
```
Original Clockify entry:
"create claude code instructions to organize receipts, work on python UI" (3h)

Analysis: Two distinct goals mentioned
1. Receipt management automation
2. Python UI development

Action: Split hours equally
- Goal 4: Receipt management (1.5h)
- Goal 3: Recording UI (1.5h)
```

**Detection patterns:**
- Conjunctions: "and", "also", ","
- Multiple distinct actions in one description
- Different technical areas (e.g., "frontend and backend", "docs and code")

**When unsure:**
- Ask user how to split
- Default to equal split if user doesn't specify

## Enrich with Git Commit Data (Example)

**Example from December:**

**Clockify entry:**
```
"Coding changes to automated labelling system" (4.5h - Dec 25)
```

**Git commits (Dec 25):**
```
commit: "Add video annotation tools and refactor project structure"
Files:
+ video_annotation/scripts/auto_label_via.py
+ crossing_tracker.py
Changes:
- Add automatic video labeling with YOLOv8 and ByteTrack
- Generate VIA JSON for manual review
- Export JSONL with crossing metadata (timing, confidence, distance)
- H.264 video compression for annotated output
```

**Combined Measures & Activities:**
```
- Implemented coding changes to automated labeling system (4.5h - Dec 25)
- Added automatic video labeling with YOLOv8 and ByteTrack
- Created VIA JSON export system with crossing metadata
- Implemented JSONL export with timing, confidence, and distance tracking
- Added H.264 video compression for annotated output
- Generated statistics notebook with modular plotting functions
```

**Matching algorithm:**
1. Match by date first (Clockify date → Git commit date)
2. Match by keywords (e.g., "labeling" in both)
3. Extract specific features from code changes
4. Add git details to Clockify task description

## Generate Excel with Preserved Formatting

**Critical: Use template directly, don't create new workbook**

```python
# WRONG - loses formatting:
new_wb = Workbook()
new_ws = new_wb.active
# ... copy data and styles manually ...

# CORRECT - preserves formatting:
wb = load_workbook('template.xlsx')
ws = wb['December']
# ... fill data in existing sheet ...
# Remove other sheets
for sheet_name in wb.sheetnames:
    if sheet_name != 'December':
        del wb[sheet_name]
wb.save('progress_report_December_2025.xlsx')
```

**Why this matters:**
- Template has specific colors, fonts, borders
- Merged cells need special handling
- Column widths and row heights must be preserved
- Manual copying always loses some formatting

## Running the Python Script

**CRITICAL: Always use the venv when running the Excel generation script:**

```bash
# Activate venv and run the script
s:/funding/receipts/venv/Scripts/activate && python generate_december_report.py
```

This ensures openpyxl and other dependencies are available.
