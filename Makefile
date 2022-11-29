FREQTRADE_RUN := docker-compose run --rm freqtrade

CONFIG := --config user_data/config.json
CONFIG_PRIVATE := --config user_data/config.private.json
CONFIG_BACKTESTING := --config user_data/config.backtesting.json

TIME_DATA = --timerange $(or $(TIMERANGE),20220101-20220201) --timeframe $(or $(TIMEFRAME),5m)
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

test-pairlist:*
	$(FREQTRADE_RUN) test-pairlist $(CONFIG_BACKTESTING) --exchange $(or $(EXCHANGE),binance) --quote $(or $(QUOTE),USDT)

download-data:
	$(FREQTRADE_RUN) download-data $(CONFIG_BACKTESTING) --exchange $(or $(EXCHANGE),binance) $(TIME_DATA)

backtesting:
	$(FREQTRADE_RUN) backtesting $(CONFIG) $(CONFIG_PRIVATE) $(CONFIG_BACKTESTING) $(TEST_ARGS)

# Image Required: develop_plot or stable_plot
plot-dataframe:
	$(FREQTRADE_RUN) plot-dataframe $(CONFIG) $(CONFIG_PRIVATE) $(CONFIG_BACKTESTING) $(TEST_ARGS)
plot-profit:
	$(FREQTRADE_RUN) plot-profit $(CONFIG) $(CONFIG_PRIVATE) $(CONFIG_BACKTESTING) $(TEST_ARGS)

backtesting-all:
	$(FREQTRADE_RUN) backtesting $(CONFIG) $(CONFIG_PRIVATE) $(CONFIG_BACKTESTING) --strategy-list $(STRATEGIES) $(TIME_DATA)
