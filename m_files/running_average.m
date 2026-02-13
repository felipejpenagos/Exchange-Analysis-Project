%% Load data

global stock_prices
stock_prices = load('stock_prices1.dat'); % load stock price data

%% Calculate Values

phi = [ 0.7 , 0.5 , 0.3 ];

%{
weights1 = exp(-[1:N1].*5./N1);		% weight recent data more heaviliy
weights1 = weights1 / sum(weights1);	% weights must add to 1

weights2 = exp(-[1:N2].*5./N2);		% weight recent data more heaviliy
weights2 = weights2 / sum(weights2);	% weights must add to 1

weights3 = exp(-[1:N3].*5./N3);		% weight recent data more heaviliy
weights3 = weights3 / sum(weights3);	% weights must add to 1
%}

s = 8;
days = 200;

pbar   = NaN(3,days);
dpbar  = NaN(3,days);
ddpbar = NaN(3,days);
vbar   = NaN(3,days);

pbar(:,1:3) = stock_prices(1:3,s)*[ 1 1 1 ];
dpbar(:,1:3) = zeros(3);
ddpbar(:,1:3) = zeros(3);
vbar(:,1:3) = zeros(3); 

for k = 1:3 
  for  d = 3:days			% loop over the trading days
     pbar(k,d) = (1-phi(k)) * pbar(k,d-1) + phi(k) * stock_prices(d-1,s);
     dpbar(k,d) = ( pbar(k,d) - pbar(k,d-2) ) / ( pbar(k,d) + pbar(k,d-2) ); 
     ddpbar(k,d) = ( pbar(k,d) - pbar(k,d-2) ) / 2.0;
     vbar(k,d) = (1-phi(k)) * vbar(k,d-1) + phi(k) * dpbar(k,d)^2;
  end
end
%% Plot Values

% day0 = 1;
% time = [1:days];

x = [1 : days];

formatPlot(7,1,1);
figure(1)
    clf
    subplot(4,1,1)
    hold on
    plot(x, stock_prices(:,s), '.k') 
    plot(x, pbar ) 
    ylabel('smooth price')
    
    subplot(4,1,2)
    plot(x, dpbar)
    ylabel('fractional change')
    
    subplot(4,1,3)
    plot(x, ddpbar)
    ylabel('rate of fractional change')
    
    subplot(4,1,4)
    plot(x, sqrt(vbar))
    ylabel('volatility')

print('running_average.pdf', '-dpdfcrop') 

    
