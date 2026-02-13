# exchange_opt.py  –  CEE 251L, Duke University  |  H.P. Gavin

import numpy as np
from multivarious.opt.nms import nms
from multivarious.opt.ors import ors
from multivarious.opt.sqp import sqp
from exchange_analysis import exchange_analysis

stock_prices = np.genfromtxt('stock_prices1.csv', delimiter=',')  # DO NOT CHANGE
constants    = [0, stock_prices]                                   # DO NOT CHANGE

# EDIT — initial guess. If you added q4, q5 to your Q equation, append them here.
#              q1     q2    q3    fc    phi    B      S
p_init = np.array([ -8.7, 10.7,  1.0,  0.9,  0.7,  0.6, -0.4 ])

# EDIT — bounds. fc and phi must stay in (0,1).
p_lb = p_init - 1.5*np.abs(p_init);  p_lb[3], p_lb[4] = 0.01, 0.01
p_ub = p_init + 1.5*np.abs(p_init);  p_ub[3], p_ub[4] = 0.99, 0.99;  p_ub[5] = 4.0

f_init, _ = exchange_analysis(p_init, [10, stock_prices])         # DO NOT CHANGE
print(f"Initial value: ${-f_init:.2f}")                           # DO NOT CHANGE
if input("OK to continue? [y]/n : ").strip().lower() == 'n': raise SystemExit

# EDIT — optimizer options: [display, tol_v, tol_f, tol_g, max_evals, penalty, q_exp, m_max, err_F, find_feas]
opts = [1, 0.1, 0.1, 0.1, 5000, 1, 2, 5, 0.01, 0]

# EDIT — pick ONE optimizer, comment out the other two
p_opt, f_opt, _, _ = nms(exchange_analysis, p_init, p_lb, p_ub, opts, constants)
# p_opt, f_opt, _, _ = ors(exchange_analysis, p_init, p_lb, p_ub, opts, constants)
# p_opt, f_opt, _, _ = sqp(exchange_analysis, p_init, p_lb, p_ub, opts, constants)

f_opt, _ = exchange_analysis(p_opt, [20, stock_prices])           # DO NOT CHANGE
print(f"Optimized value: ${-f_opt:.2f}  |  params: {np.round(p_opt,4)}")

# OPTIONAL — test on days 201-400 once stock_prices2.csv is released
# f_test, _ = exchange_analysis(p_opt, [30, np.genfromtxt('stock_prices2.csv', delimiter=',')])
