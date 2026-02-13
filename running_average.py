# running_average.py  –  CEE 251L, Duke University  |  H.P. Gavin
# Reproduce Figure 1: effect of forgetting factor phi on running averages.
# Task 2: run this for stock #5 and describe the effect of phi on p_bar,
#         p_dot, and p_ddot in a few sentences.

import numpy as np
import matplotlib.pyplot as plt

stock_prices = np.genfromtxt('stock_prices1.csv', delimiter=',')
days = stock_prices.shape[0]

# EDIT — change stock number (1-indexed, so stock 5 = index 4)
s = 4

# EDIT — try different forgetting factors
phi = [0.7, 0.5, 0.3]

# ── DO NOT CHANGE BELOW ───────────────────────────────────────────────
nPhi = len(phi)
pbar   = np.full((nPhi, days), np.nan)
dpbar  = np.full((nPhi, days), np.nan)
ddpbar = np.full((nPhi, days), np.nan)
vbar   = np.full((nPhi, days), np.nan)

for k in range(nPhi):
    pbar[k, 0:3]   = stock_prices[0, s]
    dpbar[k, 0:3]  = 0.0
    ddpbar[k, 0:3] = 0.0
    vbar[k, 0:3]   = 0.0

    for d in range(2, days):
        pbar[k, d]   = (1 - phi[k]) * pbar[k, d-1] + phi[k] * stock_prices[d, s]
        denom        = pbar[k, d] + pbar[k, d-2]
        dpbar[k, d]  = (pbar[k, d] - pbar[k, d-2]) / denom if denom != 0 else 0
        ddpbar[k, d] = (dpbar[k, d] - dpbar[k, d-2]) / 2.0
        vbar[k, d]   = (1 - phi[k]) * vbar[k, d-1] + phi[k] * dpbar[k, d]**2

x = np.arange(1, days + 1)

fig, axes = plt.subplots(4, 1, figsize=(9, 10), sharex=True)
labels = [f'φ = {p}' for p in phi]

axes[0].plot(x, stock_prices[:, s], '.k', markersize=2, label='raw price')
for k in range(nPhi):
    axes[0].plot(x, pbar[k], label=labels[k])
axes[0].set_ylabel('smooth price')
axes[0].legend(fontsize=8)

for k in range(nPhi):
    axes[1].plot(x, dpbar[k], label=labels[k])
axes[1].set_ylabel('fractional change')
axes[1].legend(fontsize=8)

for k in range(nPhi):
    axes[2].plot(x, ddpbar[k], label=labels[k])
axes[2].set_ylabel('rate of fractional change')
axes[2].legend(fontsize=8)

for k in range(nPhi):
    axes[3].plot(x, np.sqrt(vbar[k]), label=labels[k])
axes[3].set_ylabel('volatility')
axes[3].set_xlabel('trading day')
axes[3].legend(fontsize=8)

plt.suptitle(f'Running averages for stock #{s+1}', fontsize=11)
plt.tight_layout()
plt.show()
