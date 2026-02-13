# Exchange Analysis Project
**CEE 251L — Uncertainty, Design, and Optimization | Duke University**

Design and optimize an automatic stock trading strategy using 200 days of closing prices for 19 stocks. Starting with **$1,000**, your goal is to maximize the total value of cash + investments by day 200.

---

## Files

| File | Description |
|------|-------------|
| `exchange_analysis.py` | Core simulation — given a set of parameters, returns the portfolio value after 200 trading days. |
| `exchange_opt.py` | **Start here.** Sets your initial guess and runs the optimizer. |
| `running_average.py` | Standalone script for Task 2 — plots the effect of φ on smoothed price, velocity, and volatility. |
| `stock_prices1.csv` | 200 days × 19 stocks of closing price data. |
| `m_files/` | Original MATLAB source files for reference. |

---

## Setup

```bash
pip install numpy matplotlib
pip install -e /path/to/multivarious   # install from the course repo
```

---

## Workflow

1. **Task 2** — run `running_average.py` for stock #5. Edit `s = 4` and the `phi` values at the top.
2. **Task 4** — run `exchange_opt.py`. Edit your initial guess, bounds, and choice of optimizer (`nms`, `ors`, or `sqp`).
3. **Task 3 (optional)** — modify the 5 marked sections in `exchange_analysis.py` to improve the algorithm.

---

## What to Edit

**`exchange_opt.py`** — your initial guess `p_init`, bounds, optimizer options, and optimizer choice.

**`exchange_analysis.py`** has 5 clearly marked `# EDIT HERE` sections:

| # | Section | What you can change |
|---|---------|-------------------|
| 1 | Quality equation Q | Add/remove terms (e.g. q4, q5) |
| 2 | Sell decision | When and whether to sell |
| 3 | Cash distribution | How to split cash among stocks to buy |
| 4 | Threshold update | How B and S evolve each day |
| 5 | Threshold gap | Minimum separation between B and S |