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