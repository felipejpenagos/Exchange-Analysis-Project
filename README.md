# Exchange Analysis Project
**CEE 251L — Uncertainty, Design, and Optimization | Duke University**

Optimize an automatic stock trading strategy using 200 days of closing prices for 19 stocks.

---

## Files

| File | Description |
|------|-------------|
| `exchange_analysis.py` | Simulates the trading strategy. Returns portfolio value given a set of parameters. |
| `exchange_opt.py` | Runs the optimizer to find the best parameters. **This is your main working file.** |
| `stock_prices1.csv` | 200 days × 19 stocks closing price data. |

## Getting Started

```bash
pip install numpy matplotlib
pip install multivarious   # or install from the course repo
python exchange_opt.py
```

## What to Edit

**`exchange_analysis.py`** has 5 clearly marked `# EDIT HERE` sections:
1. Quality equation Q (add/remove terms)
2. Sell decision logic
3. How cash is distributed among purchased stocks
4. Threshold update rule
5. Minimum gap between buy/sell thresholds

**`exchange_opt.py`** — set your initial guess, bounds, optimizer options, and choose between `nms`, `ors`, or `sqp`.

## Goal

Maximize the total value of cash + investments after 200 trading days, starting with **$1,000**.
