function [ cost , constraint ] = exchange_analysis(param, constants )
% cost = exchange_analysis(param)
% analyze a policy for buying and selling stocks
%
% INPUT VARIABLES
% p(1)  = q(1)    .... quality veloc coeff
% p(2)  = q(2)    .... quality accel coeff
% p(3)  = q(3)    .... quality volatility coeff
% p(4)  = fc      .... fraction of cash to invest (must be between 0 and 1)
% p(5)  = phi     .... forgetting factor
% p(6)  = B       .... buy  threshold
% p(7)  = S       .... sell threshold
%
% OUTPUT VARIABLES
% cost            .... the negative of the value of cash and investments 
%                      after 200 days of trading.

q   = param(1:3);		% stock quality parameters
fc  = max(0,min(1,param(4)));	% fraction of cash to invest
phi = max(0,min(1,param(5)));	% forgetting factor 
B   = param(6);			% buy  threshold on day 1
S   = param(7); 		% sell threshold on day 1

FigNo        = constants{1};
stock_prices = constants{2};

[days,stocks] = size(stock_prices); % number of trading days, number of stocks

% initialize matrices

smooth_price = stock_prices;
smooth_veloc = zeros(days,stocks);	
smooth_accel = zeros(days,stocks);	
variance     = zeros(days,stocks);	

quality      = zeros(days,stocks);	% the quality of all stocks
B_record     = zeros(days,1);		% record of buy-threshold
S_record     = zeros(days,1); 		% record of sell-threshold

shares_owned = zeros(days,stocks);	% the number of shares in each stock
value        = zeros(days,1);		% the value of the investments
cash         = zeros(days,1);		% the cash in hand

cash(1:3) = 1000.00;			% in your pocket on "day 1"

fraction_of_cash_to_invest = fc;	% amount of your cash to invest

buy_threshold  = B;
sell_threshold = S;

transaction_cost = 2.00;		% transaction cost ... $2.00

B_record(1:3) = B;
S_record(1:3) = S;

for  day = 2:days-1			% loop over the trading days

  smooth_price(day+1,:) = (1-phi)*smooth_price(day,:) + phi*stock_prices(day+1,:);
  smooth_veloc(day+1,:) = ( smooth_price(day+1,:)-smooth_price(day-1,:) ) ./ ...
                          ( smooth_price(day+1,:)+smooth_price(day-1,:) );

  smooth_accel(day+1,:) = ( smooth_veloc(day+1,:)-smooth_veloc(day-1,:) ) / 2;

  variance(day+1,:) = (1-phi)*variance(day,:) + phi*smooth_veloc(day+1,:).^2;

  stocks_owned = find( shares_owned(day,:) > 0 );	% stocks owned today

  value(day) = sum ( stock_prices( day, stocks_owned ) .* ...
                     shares_owned( day, stocks_owned ) );

% *** You may change the following definition of "quality"

  quality(day,:)  = q(1)*smooth_veloc(day,:) + ...
                    q(2)*smooth_accel(day,:) + ...
                    q(3)*sqrt(variance(day,:)); 
%                   q(4)*sqrt(variance(day,:)).*smooth_veloc(day+1,:) + ...
%                   q(5)*sqrt(variance(day,:)).*smooth_accel(day+1,:); 

% ----- trading decisions ... sell the bad, buy the good  

% Find stocks that are potentially sellableand potentially buyable 
  stocks_to_sell = find( quality(day,:) < S );
  stocks_to_buy  = find( quality(day,:) > B );

% Don't sell what you don't own.   (no shorting)
  so = zeros(1,stocks); sts = zeros(1,stocks);  
  so(stocks_owned) = 1; sts(stocks_to_sell) = 1;
  stocks_to_sell = find(so & sts);

% Don't sell if you are not going to buy.  (You may ignore this rule.)
  if length(stocks_to_buy) == 0		% If there are no stocks to buy
    stocks_to_sell = [];			% then don't sell any. 
  end
     
  if length(stocks_to_sell) > 0		% there are stocks to sell
    cash(day) = cash(day) + sum ( stock_prices(day,stocks_to_sell) .* ...
                                  shares_owned(day,stocks_to_sell) );
    cash(day) = cash(day) - transaction_cost * length( stocks_to_sell );
    shares_owned( day, stocks_to_sell ) = 0;	% stocks are sold
  end

  shares_to_buy = zeros(1,stocks);
  if length(stocks_to_buy) > 0 && cash(day) > 0  % there are stocks to buy

    cash(day) = cash(day) - transaction_cost * length( stocks_to_buy );

    if cash(day) < 0 && value(day) < 0
	fprintf('you lose.\n');
    end

   % amount of cash available to invest ...
    cash_to_invest = cash(day) * fraction_of_cash_to_invest;

   % *** You may change how cash is distributed among stocks to buy
   % distribute all cash equally among all stocks to buy
    shares_to_buy(stocks_to_buy) = ( cash_to_invest / length(stocks_to_buy) ) ...
                                   ./ stock_prices(day,stocks_to_buy);

    cash(day) = cash(day) - cash_to_invest;

  end

  shares_owned( day+1,:) = shares_owned(day,:) + shares_to_buy;

  % cash is in some very safe investment ... 4% growth per year
  cash(day+1) = cash(day) * (1 + 0.04/365);

% *** You may change the threshold update on the following four lines ...

  % set B to the max quality of all owned stocks
  bb = max( quality( day, find( shares_owned(day+1,:)>0 )));
  if sum(shares_owned(day+1,:))==0, bb = B; end
  
  % set S to the min quality of all owned stocks
  ss = min( quality( day, find( shares_owned(day+1,:)>0 )));
  if sum(shares_owned(day+1,:))==0, ss = S; end

  if length(bb) > 0, B = bb; end
  if length(ss) > 0, S = ss; end

% *** You may change the following line, as long as S < B
  S = min(B-0.10*abs(B),S); % sell threshold must be less than the buy threshold

  B_record(day) =  B;
  S_record(day) =  S;

end

stocks_owned = find( shares_owned(days,:) > 0 );
value(days)  = sum ( stock_prices( days, stocks_owned ) .* ...
                     shares_owned( days, stocks_owned ) );

% minimize the negative of the value (the same as maximizing value)
cost = -value(days) - cash(days);   
constraint = -1;

if FigNo > 0   % -------------------------------------------------- plotting

 stp = [ 1 12 19 ];	% Stocks To Plot ... 1 to 19
 param = param(:);

 day0 = 1;

 time = [1:days];

% {
 figure(FigNo+1)
% clf
  subplot(511)
   plot(time+day0, stock_prices(time,stp), '-b', ...
        time+day0, smooth_price(time,stp), '-r');
    ylabel('price')
    legend(num2str(stp))
    axis('tight')
  subplot(512)
   plot(time+day0, smooth_veloc(:,stp), '-r');
    ylabel('% change')
    axis('tight')
  subplot(513)
   plot(time+day0, smooth_accel(:,stp), '-r');
    ylabel('change of %% change')
    axis('tight')
  subplot(514)
   plot(time+day0, variance(:,stp), '-r');
    ylabel('variance')
    axis('tight')
  subplot(515)
   plot(time+day0, B_record,'--k', time+day0,S_record,'--k', time+day0,quality(:,stp) )
    ylabel('quality')
    axis('tight')
  %if pdfPlots, print('exchange_analysis_1.pdf','-dpdfcrop'); 
% }

%{
smooth_price_5 = smooth_price;
smooth_veloc_5= smooth_veloc;
smooth_accel_5 = smooth_accel;
variance_5 = variance;
save   data_5.mat   time day0 smooth_price_5 smooth_veloc_5 smooth_accel_5 variance_5
%}
 
 figure(FigNo+2)
  clf
  subplot(211)
   plot( time+day0,shares_owned.*stock_prices,'-');
   hold on
   plot( time+day0,value,'-b','LineWidth',6)
   plot( time+day0,cash, '-g','LineWidth',6)
   legend('investments','cash')
   legend('location','NorthWest')
%  ttl = ['p=[ ' num2str(param') ' ]'];
%  title(ttl, 'FontSize', 10)
    axis('tight')
    ylabel('value')
   title(num2str(param'), 'FontSize', 10)
  subplot(212)
   plot(time+day0,shares_owned,'-')
    axis('tight')
    ylabel('shares owned')
    maxSharesOwned = max(max(shares_owned))
    [d,s] = find( shares_owned(2:days,:) > 2.0*round(shares_owned(1:days-1,:)) );
    for k=1:length(d)
	text(d(k),shares_owned(d(k)+1,s(k)),num2str(s(k)))
    end
  %if pdfPlots, print('exchange_analysis_2.pdf','-dpdfcrop'); 

 figure(FigNo+3)
   clf
   plot( time+day0,B_record, time+day0,S_record )
    axis('tight')
    ylabel('threshold values')
    legend('buy threshold','sell threshold')
  %if pdfPlots, print('exchange_analysis_3.pdf','-dpdfcrop'); 

end		% ------------------------------------------------- plotting

 
% exchange_analysis ------------------- 4 Apr 2011, 23 Mar 2015, 07 Apr 2025
