FREQTRADE_RUN := docker-compose run --rm freqtrade

STRATEGIES = $(shell ls user_data/strategies | grep py | sed "s/.py//g" | tr "\n" " ")

CONFIG := --config user_data/config.json
CONFIG_TEST := $(CONFIG) --config user_data/config.test.json

EXCHANGE := binance
DAYS := 30
TIMEFRAME := 5m
STRATEGY=SampleStrategy
QUOTE=USDT

TEST_ARGS := --timeframe=$(TIMEFRAME) --timeframe-detail=$(TIMEFRAME_DETAIL) --export trades

list-exchanges:
	$(FREQTRADE_RUN) list-exchanges

list-timeframes:
	$(FREQTRADE_RUN) list-timeframes --exchange $(EXCHANGE)

list-pairs:
	$(FREQTRADE_RUN) list-pairs --quot $(QUOTE) --print-json

list-data:
	$(FREQTRADE_RUN) list-data --exchange $(EXCHANGE)

list-strats:
	@echo $(STRATEGIES)

test-pairlist:
	$(FREQTRADE_RUN) test-pairlist --quote $(QUOTE)

download-data:
	$(FREQTRADE_RUN) download-data  $(CONFIG_TEST) --days=$(DAYS) --timeframe=$(TIMEFRAME)

test:
	$(FREQTRADE_RUN) backtesting $(CONFIG_TEST) --strategy $(STRATEGY) $(TEST_ARGS)

plot-dataframe:
	$(FREQTRADE_RUN) plot-dataframe $(CONFIG_TEST) --strategy $(STRATEGY) --timeframe=$(TIMEFRAME)

plot-profit:
	$(FREQTRADE_RUN) plot-profit $(CONFIG_TEST) --strategy $(STRATEGY) --timeframe=$(TIMEFRAME)

test-all:
	$(FREQTRADE_RUN) backtesting $(CONFIG_TEST) --strategy-list $(STRATEGIES) $(TEST_ARGS)



hyperopt:
	$(FREQTRADE_RUN) hyperopt $(CONFIG_TEST) \
		--hyperopt-loss $(LOSS) \
		--spaces $(SPACES) \
		--strategy $(STRATEGY) \
		-e $(EPOCHS) \
		--timerange=$(TIMERANGE) \
		--timeframe=$(TIMEFRAME) --random-state 42 -j -1
