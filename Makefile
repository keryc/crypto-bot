FREQTRADE_RUN := docker-compose run --rm freqtrade

CONFIG := --config user_data/config.json
CONFIG_TEST := $(CONFIG) --config user_data/config.test.json

TIME_DATA = --timerange $(or $(TIMERANGE),20210101-20210201) --timeframe $(or $(TIMEFRAME),5m)
TEST_ARGS := --strategy $(or $(STRATEGY),SampleStrategy) $(TIME_DATA)

STRATEGIES := $(shell ls user_data/strategies | grep py | sed "s/.py//g" | tr "\n" " ")

list-exchanges:
	$(FREQTRADE_RUN) list-exchanges

list-strats:
	$(FREQTRADE_RUN) list-strategies

list-pairs:
	$(FREQTRADE_RUN) list-pairs --exchange $(or $(EXCHANGE),binance) --quote $(or $(QUOTE),USDT)

list-timeframes:
	$(FREQTRADE_RUN) list-timeframes --exchange $(or $(EXCHANGE),binance)

list-data:
	$(FREQTRADE_RUN) list-data --exchange $(or $(EXCHANGE),binance)

test-pairlist:
	$(FREQTRADE_RUN) test-pairlist --quote $(or $(QUOTE),USDT)

download-data:
	$(FREQTRADE_RUN) download-data  $(CONFIG_TEST) $(TIME_DATA)

test:
	$(FREQTRADE_RUN) backtesting $(CONFIG_TEST) $(TEST_ARGS)

plot-dataframe:
	$(FREQTRADE_RUN) plot-dataframe $(CONFIG_TEST) $(TEST_ARGS)

plot-profit:
	$(FREQTRADE_RUN) plot-profit $(CONFIG_TEST) $(TEST_ARGS)

test-all:
	$(FREQTRADE_RUN) backtesting $(CONFIG_TEST) --strategy-list $(STRATEGIES) $(TIME_DATA)
