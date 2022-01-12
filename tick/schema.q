trade:([]time:`timespan$(); sym:`$(); price:`float$(); size:`long$())
quote:([]time:`timespan$(); sym:`$(); bid:`float$(); ask:`float$(); bidSize:`long$(); askSize:`long$())
aggToB:([]time:`timespan$(); sym:`$(); maxTrade:`float$(); minTrade:`float$(); totalVol:`long$(); maxBid:`float$(); minAsk:`float$())

\
//supplemental tables
 book:0!select last plsize by sym, plside, plprice:`long$10000 * plprice from level_delta;
 ohlcv:0!select time: max tradetime, open:first tradeprice, high:max tradeprice, low: min tradeprice, close:last tradeprice, volume: last totalvolume, bucket:`1sec by sym from trade;
\

