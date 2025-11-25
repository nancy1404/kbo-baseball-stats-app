# ⚾ KBO Baseball Stats App

Interactive R Shiny app and analysis of 2024 KBO (Korean Baseball Organization) hitter stats.  
This project explores player performance and how it relates to team success using both:

- A **static analysis report** (R Markdown)
- An **interactive Shiny app** for fans, analysts, and anyone curious about KBO hitters

This work started as Projects 2 & 3 in **SDS 313 (Fall 2024)** and has been cleaned up as a portfolio project.

---

## 🌐 Live App

**Shiny app link:**  
https://nancy1404.shinyapps.io/trial3/

(The public app reads from the same `KBOstats2024.csv` dataset included in this repo.)

---

## 🎯 Project Goals

- Visualize how KBO hitters performed in the 2024 season
- Explore key batting stats like **OPS, BA, OBP, HR**
- Ask “front-office style” questions:
  - Which players provide the most offensive value?
  - How do team averages relate to final league standings?
  - Are top teams simply the ones with the best hitters?

This project combines **sports analytics + interactive visualization**, and is very aligned with my interests at the intersection of **data, sports, and decision-making**.

---

## 🧾 Dataset

- **File:** `KBOstats2024.csv`
- **Scope:** 2024 KBO League hitter stats (regular season)
- **Unit of observation:** Player-season
- **Columns include (examples):**
  - `Player` — player name  
  - `Team` — team name  
  - `OPS` — On-base Plus Slugging  
  - `BA` — Batting Average  
  - `OBP` — On-base Percentage  
  - `SLG` — Slugging Percentage  
  - `HR` — Home Runs  
  - `BB` — Walks  
  - `AB` — At-bats  
  - `PA` — Plate appearances  

Data was manually scraped and cleaned from **mykbostats.com** (fan-oriented KBO stats site), then saved as a CSV for reproducible analysis.

---

## 📂 Repository Structure

```text
kbo-baseball-stats-app/
├── data/
│   └── KBOstats2024.csv        # Cleaned hitter stats for 2024 KBO season
├── analysis/
│   └── Project2_KBO_Stats.Rmd  # Full EDA + visualizations + write-up (Project 2)
│   └── Project2_KBO_Stats.html  # Knitted html File
├── shiny_app/
│   └── app.R                   # Shiny app source code (Project 3)
└── README.md                   # This file
````

> 🔒 **Note:** Any deployment scripts containing tokens/secrets (e.g., `demo1.R` with `rsconnect::setAccountInfo()`) are **not** included here for security reasons. You should keep those local or scrub secrets before committing.

---

## 📊 What’s in the Analysis (R Markdown)

The R Markdown report (`analysis/Project2_KBO_Stats.Rmd`) includes:

### Univariate analyses

- Distribution of **OPS, BA, HR, BB**
- Summary statistics + discussion of “best vs worst” players

### Bivariate analyses

- **OPS vs SLG**
- **BA vs OBP** (including a derived **On-base Effectiveness** = `OBP / BA`)
- **HR vs PA** (with **Power Ratio** = `HR / PA`)
- **SLG vs AB**

### Multivariate analysis

- Bubble plot of **OPS vs BA**, with **HR** categorized as **Low / Medium / High**

### Team-level analysis

- Merged hitter stats with **team standings**
- Explored how team average **OPS, BA, HR, OBP** relate to **final rank**

The report focuses on explaining patterns in a way that a baseball fan, student, or analyst can understand.

---

## 🖥 Shiny App Overview

The Shiny app (`shiny_app/app.R`) lets users:

- Select a **variable** (`OPS`, `BA`, `OBP`, `HR`, or `Player`)
- Filter players using **sliders** (e.g., restrict OPS between `0.7` and `1.0`)

### Visualize:

- **Univariate distributions** (histograms)
- **Summary stats** (mean, median, SD, min, max)

### Run bivariate plots:

- Choose **X** and **Y** (`OPS`, `BA`, `OBP`, `HR`)
- Toggle a regression **trend line**

### Look up a specific player:

- See their stats in a **table**
- Compare their **OPS / BA / OBP** via a **bar chart**

It’s designed to feel like a lightweight, fan-facing exploration tool with some analytical depth.

---

## 🛠 Tools & Packages

### Core tools

- **Language:** R  
- **App framework:** Shiny  
- **Visualization:** ggplot2  
- **Data manipulation:** dplyr, tidyr  
- **Styling & UX:** shinythemes, shinyjs, colourpicker, DT  

### Packages used (main)

```r
library(shiny)
library(ggplot2)
library(DT)
library(dplyr)
library(readr)
library(tidyr)
library(shinythemes)
library(shinyjs)
library(colourpicker)
```

## ▶️ How to Run the Shiny App Locally

1. **Clone the repository**

```bash
git clone https://github.com/nancy1404/kbo-baseball-stats-app.git
cd kbo-baseball-stats-app
```

2. **Open R or RStudio**

Set your working directory to the repo root or directly into `shiny_app/`.

3. **Install required packages (if needed)**

```r
install.packages(c(
  "shiny", "ggplot2", "DT", "dplyr", "readr",
  "tidyr", "shinythemes", "shinyjs", "colourpicker"
))
```

4. **Run the app**

From R / RStudio:

```r
setwd("shiny_app")
shiny::runApp("app.R")
```

Make sure `KBOstats2024.csv` is in a path that `app.R` expects (e.g., the repo root or a `data/` folder, depending on your final code).

---

## 📑 How to Reproduce the Analysis Report

1. Open `analysis/Project2_KBO_Stats.Rmd` in RStudio.  
2. Ensure `KBOstats2024.csv` is available (e.g., in `data/`).  
3. Install any required packages listed at the top of the Rmd.  
4. Click **Knit** to generate the HTML report.

The report walks through the entire EDA, visualizations, and narrative.

---

## 🚀 Possible Extensions

If I extend this project, I’d like to:

- Add pitching stats and compare hitting vs pitching strength by team  
- Include interactive team filters (e.g., focus on one team’s hitters)  
- Build a dedicated **“GM view”**:
  - Simulate how replacing a player changes team averages  
- Add more advanced sabermetrics and visualizations  

---

## 🙋‍♀️ About Me

I’m **Nancy (Nakyung) Kwak**, a Statistics & Data Science major at the **University of Texas at Austin** and a **Break Through Tech AI Fellow** at Cornell Tech.

I’m especially interested in:

- Sports & marketing analytics  
- ML applications in customer experience and content strategy  
- Using data to bridge technical insights and real business decisions  

**Find me here:**

- GitHub: [@nancy1404](https://github.com/nancy1404)  
- LinkedIn: [nakyungnancy](https://www.linkedin.com/in/nakyungnancy)
