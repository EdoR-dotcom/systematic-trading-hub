#' Crossover Strategy SMA 7/21/200
#'
#' @description
#' Implements a multi–moving-average trading strategy using SMA(7), SMA(21)
#' and SMA(200). The SMA(21) vs SMA(200) relationship defines the market
#' regime (bullish or bearish), while SMA(7) vs SMA(21) determines the timing
#' of entries and exits. Depending on `long_only`, the strategy trades only long
#' in bullish regimes or only short in bearish regimes. The function returns
#' the vector of positions (+1 long, -1 short, 0 flat) for each date.
#' 
#' @param prices Numeric vector with closing prices
#'
#' @return A numeric vector

library(dplyr)
library(quantmod)

bb_strategy <- function(data,
                        price_col = "prccd", 
                        bb_n = 20,          # bollinger bands period
                        k = 1.8,            # deviazione standard
                        rsi_n = 14,         # RSI period
                        rsi_long_thr = 53,  # RSI threshold for long
                        rsi_short_thr = 47, # RSI threshold for short
                        bbw_quantile = 0.33 # compression signal
                        ) {

  price <- data[[price_col]]

  data <- data %>%
    mutate(
      # Bollinger Bands su Close
      bb = BBands(price, n = bb_n, sd = k),
      mavg  = bb[, "mavg"],
      upper = bb[, "up"],
      lower = bb[, "dn"],

      # Bollinger Band Width
      bb_width = (upper - lower) / mavg,

      # Threshold 
      bbw_thr = quantile(bb_width, probs = bbw_quantile, na.rm = TRUE),

      # Compression Trigger
      vol_compression = bb_width < bbw_thr,

      # RSI filter for trend direction
      rsi = RSI(price, n = rsi_n),

      rsi_long_filter  = rsi > rsi_long_thr,
      rsi_short_filter = rsi < rsi_short_thr,

      # Breakout trigger
      long_breakout = price > upper,
      short_breakout = price < lower,

      # All conditions to entry the position
      long_entry_cond  = vol_compression & rsi_long_filter  & long_breakout,
      short_entry_cond = vol_compression & rsi_short_filter & short_breakout

    )

  n <- nrow(data)
  position <- numeric(n)
  position[1] <- 0

    for (i in 2:n) { # nolint
      prev_pos <- position[i - 1]
      pos_now  <- prev_pos

      # ENTRY se flat # nolint
      if (prev_pos == 0) {
        if (isTRUE(data$long_entry_cond[i])) {
          pos_now <- 1
          } else if (isTRUE(data$short_entry_cond[i])) {
            pos_now <- -1
          }
    }

    # EXIT long RSI condition 
    if (prev_pos == 1 && data$rsi[i] < 50) {
    pos_now <- 0
    } # nolint

    # EXIT short RSI condition
    if (prev_pos == -1 && data$rsi[i] > 50) {
    pos_now <- 0
    }

    position[i] <- pos_now
  }

data$position <- position
return(data)
}

## Backtesting Strategy

backtest <- function(xts_prices, xts_signals) {

  returns <- xts_prices / lag(xts_prices) - 1
  strategyReturns <- lag(xts_signals) * returns

  returns <- na.fill(returns, 0)
  strategyReturns <- na.fill(strategyReturns, 0)

  names(returns) <- "Benchmark"
  names(strategyReturns) <- "Strategy"

  compareReturns <- cbind(returns, strategyReturns)
  return(compareReturns)
}

