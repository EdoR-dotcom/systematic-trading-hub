#' MA Crossover Strategy with Regime Filter
#'
#' @description
#' Implements a systematic trend-following strategy based on a hierarchical
#' moving average structure. A medium- vs long-term moving average relationship
#' is used to identify the prevailing market regime (bullish or bearish),
#' while short- vs medium-term moving average crossovers are used to generate
#' entry and exit signals.
#'
#' The strategy enforces directional consistency by allowing long positions
#' only during bullish regimes and short positions only during bearish regimes,
#' thereby reducing whipsaws and avoiding counter-trend trades.
#'
#' @param data A data.frame or tibble containing price data.
#' @param price_col Character scalar. Name of the column in `data` containing the close prices.
#' @param fast_n Integer. Lookback window for the short-term moving average.
#' @param mid_n Integer. Lookback window for the medium-term moving average.
#' @param slow_n Integer. Lookback window for the long-term moving average.
#'
#'
#' @return The input data with an additional column `position` representing
#'         the strategy exposure over time (+1 long, -1 short, 0 flat).


library(dplyr)
library(quantmod)

triple_ma_strategy <- function(data,
                               price_col = "Close",
                               fast_n  = 7,
                               mid_n   = 21,
                               slow_n  = 200) {

  # Estraggo il vettore dei prezzi
  price <- data[[price_col]]

  # Calcolo le medie mobili
  data <- data %>%
    mutate(
      MA_fast = SMA(price, n = fast_n),   # 7  # nolint
      MA_mid  = SMA(price, n = mid_n),    # 21
      MA_slow = SMA(price, n = slow_n),    # 200
    
      # Regimi di fondo
      regime_bull  = MA_mid > MA_slow, # nolint
      regime_bear  = MA_mid < MA_slow,

      # Cross tra fast e mid (timing)
      cross_up   = MA_fast > MA_mid  & lag(MA_fast <= MA_mid,  default = FALSE),
      cross_down = MA_fast < MA_mid  & lag(MA_fast >= MA_mid,  default = FALSE)
    )

  n <- nrow(data)
  position <- numeric(n)
  position[1] <- 0

  for (i in 2:n) {
    prev_pos <- position[i - 1]
    pos_now  <- prev_pos

  #  ------------------ Bullish Regime -------------------
    if (prev_pos == 0 &&
        isTRUE(data$regime_bull[i]) &&
        isTRUE(data$cross_up[i])) {
      pos_now <- 1
    }

    # Exit long: cross_down (fast sotto mid)
    if (prev_pos == 1 &&
        isTRUE(data$cross_down[i])) {
      pos_now <- 0
    }

  #  ------------------ Bearish Regime -------------------
    if (prev_pos == 0 &&
        isTRUE(data$regime_bear[i]) &&
        isTRUE(data$cross_down[i])) {
      pos_now <- -1
    }

    # Exit Short
    if (prev_pos == -1 &&
        isTRUE(data$cross_up[i])) {
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