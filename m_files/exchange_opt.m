% exchange_opt.m
% optimize stock exchange system design

% parameters involved in the design

% p(1) = q(1)    ....  quality veloc coeff
% p(2) = q(2)    ....  quality accel coeff
% p(3) = q(3)    ....  quality accel coeff
% p(4) = fc      ....  fraction of cash to invest
% p(5) = phi     ....  forgetting factor
% p(6) = Tb      ....  buy   threshold on day 1
% p(7) = Ts      ....  sell  threshold on day 1

% train on days 1 to 200
stock_prices = csvread('stock_prices1.csv'); % load stock price data

% stock_prices = stock_prices(:,[1]);  % just stick with stock #1

%            q1    q2    q3   fc    phi    Tb   Ts 
% p_min = [ -20 ; -20 ;  -2.0 ; 0.01 ; 0.01 ; -1 ; -1 ];
% p_max = [  20 ;  20 ;   2.0 ; 0.99 ; 0.99 ;  1 ;  1 ];

% p_init = p_min + rand(7,1).*(p_max-p_min);	% a random initial guess

%             q1  q2   q3   fc   phi   Tb    Ts 
  p_init = [ -8.7 10.7 1.0  0.9  0.7   0.6  -0.4  ];

  p_min = p_init - 1.5*abs(p_init);
  p_max = p_init + 1.5*abs(p_init);

  p_min(4) =  0.01; p_max(4) = 0.99;
  p_min(5) =  0.01; p_max(5) = 0.99;
  p_max(6) =  4.00;

% evaluate the initial guess   -----------------------------------------
  FigNo =  10;  % plots on
  constants = { FigNo , stock_prices };

  f_init = exchange_analysis( p_init, constants )

  if (input('   OK to continue? [y]/n : ','s')=='n')  return; end

%         display  tolX  tolF  tolG  MaxEval  
  opts = [    1    0.1   0.1   0.1   5000    ];  

  FigNo = 0;  % plots off
  constants = { FigNo , stock_prices };

  [p_opt,f_opt,g_opt,cvg_hst] = ...
            NMAopt('exchange_analysis', p_init, p_min, p_max, opts, constants );

  FigNo =  20
  constants = { FigNo , stock_prices };
  f_opt = exchange_analysis( p_opt, constants )

  plot_cvg_hst ( cvg_hst, p_opt, 5 )

%{
% test on days 201 to 400
  stock_prices = csvread('stock_prices2.csv'); % load stock price data

  FigNo =  30
  constants = { FigNo , stock_prices };

  f_opt = exchange_analysis( p_opt , constants )
%}

