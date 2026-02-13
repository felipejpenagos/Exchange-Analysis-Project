%% Load data

global stock_prices
stock_prices = load('stock_prices1.dat'); % load stock price data

%% Calculate Values

N1 = 5;
N2 = 10;
N3 = 20;

weights1 = exp(-[1:N1].*5./N1);		% weight recent data more heaviliy
weights1 = weights1 / sum(weights1);	% weights must add to 1

weights2 = exp(-[1:N2].*5./N2);		% weight recent data more heaviliy
weights2 = weights2 / sum(weights2);	% weights must add to 1

weights3 = exp(-[1:N3].*5./N3);		% weight recent data more heaviliy
weights3 = weights3 / sum(weights3);	% weights must add to 1

days = 200;

for  day1 = N1+1:days-1			% loop over the trading days
     price1  = stock_prices(day1-1:-1:day1-N1,5);
     smooth_price1(day1) = weights1*price1;
     smooth_veloc1(day1) = ( smooth_price1(day1)-smooth_price1(day1-2) ) ./ ...
                           ( smooth_price1(day1)+smooth_price1(day1-2) );
     smooth_accel1(day1) = ( smooth_veloc1(day1)-smooth_veloc1(day1-2) ) / 2;
     volatility1(day1) = sqrt(var(price1)) ./ smooth_price1(day1);       
end

for  day2 = N2+1:days-1			% loop over the trading days
     price2  = stock_prices(day2-1:-1:day2-N2,5);
     smooth_price2(day2) = weights2*price2;
     smooth_veloc2(day2) = ( smooth_price2(day2)-smooth_price2(day2-2) ) ./ ...
                          ( smooth_price2(day2)+smooth_price2(day2-2) );
     smooth_accel2(day2) = ( smooth_veloc2(day2)-smooth_veloc2(day2-2) ) / 2;
     volatility2(day2) = sqrt(var(price2)) ./ smooth_price2(day2);       
end

for  day3 = N3+1:days-1			% loop over the trading days
     price3  = stock_prices(day3-1:-1:day3-N3,5);
     smooth_price3(day3) = weights3*price3;
     smooth_veloc3(day3) = ( smooth_price3(day3)-smooth_price3(day3-2) ) ./ ...
                           ( smooth_price3(day3)+smooth_price3(day3-2) );
     smooth_accel3(day3) = ( smooth_veloc3(day3)-smooth_veloc3(day3-2) ) / 2;
     volatility3(day3) = sqrt(var(price3)) ./ smooth_price3(day3);       
end

%% Plot Values

% day0 = 1;
% time = [1:days];

x = 1:199;

figure(1); clf
    subplot(4,1,1)
    plot(x, smooth_price1, x, smooth_price2, x, smooth_price3);
    
    subplot(4,1,2)
    plot(x, smooth_veloc1, x, smooth_veloc2, x, smooth_veloc3);
    
    subplot(4,1,3)
    plot(x, smooth_accel1, x, smooth_accel2, x, smooth_accel3);
    
    subplot(4,1,4)
    plot(x, volatility1, x, volatility2, x, volatility3);