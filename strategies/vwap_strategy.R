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
#' 
#' 

library(quantmode)
library(dplyr)


vwap_pullback <- function(data,
                           price_col = "prccd",
                           mid_n = 50,
                           slow_n = 200,
                           rsi_n = 14,
                           rsi_bull_thr = 53,
                           rsi_overbought_thr = 75,
                           vol_col_4h = "vol",
                           vol_col_1d = "vol",
                           vroc_n = 14,
                           vwap
                           ) {

  price <- data[[price_col]]

  data <- data %>%
    mutate(
    
    #------ Structure screener-----Layer 1-------#

      # RSI filter for trend direction
      rsi = RSI(price, n = rsi_n),

      rsi_bulltrend_filter  = rsi_bull_thr < rsi & rsi > rsi_overbought_thr,

      # MAs filter for trend structure

      MA_mid  = EMA(price, n = mid_n),    
      MA_slow = SMA(price, n = slow_n),
      p_retrace = price < MA_mid, 
      bull_trend = p_retrace & MA_slow & MA_mid,

    #-------- Execution Strategy------Layer 2------#

    

      
    

     


    

    
