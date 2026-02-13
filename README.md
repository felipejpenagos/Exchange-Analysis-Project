# Exchange Analysis Project

**CEE 251L – Uncertainty, Design, and Optimization**  
Duke University | Prof. Henri P. Gavin

Python translation of the MATLAB stock trading analysis and optimization framework.

## Files

| File | Description |
|------|-------------|
| `exchange_analysis.py` | Core simulation — computes portfolio value given trading parameters |
| `exchange_opt.py` | Optimization script — finds best parameters using Nelder-Mead and Differential Evolution |
| `stock_prices1.csv` | 200 days × 19 stocks closing price data |

## Design Variables

| Parameter | Description |
|-----------|-------------|
| `q1` | Quality velocity coefficient |
| `q2` | Quality acceleration coefficient |
| `q3` | Quality volatility coefficient |
| `fc` | Fraction of cash to invest (0–1) |
| `phi` | Forgetting factor for running average (0–1) |
| `B1` | Initial buy threshold |
| `S1` | Initial sell threshold |

## Usage

```python
import numpy as np
from exchange_analysis import exchange_analysis

stock_prices = np.genfromtxt('stock_prices1.csv', delimiter=',')

# Example parameters from project PDF
param = [-10.0, 2.0, -2.0, 0.9, 0.5, 0.1, -0.1]

cost, _ = exchange_analysis(param, [0, stock_prices])
print(f"Portfolio value: ${-cost:.2f}")
```

Run optimization:
```bash
python exchange_opt.py
```

## Dependencies

```
numpy
scipy
matplotlib
```