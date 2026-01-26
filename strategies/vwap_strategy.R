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


vwap_pullback <- 