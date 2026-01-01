# Strategies Laboratory

This section represent the research hub where trading strategies are designed. Before going through in details of how strategies are built we are going to define the organization of strategies. Latern on the metodology for building a roboust strategy a from that having the possibility to add other triggers or filters to better improve. 

## Classification of strategies

Strategies are classified according to two characteristics, in hierarchical order.
First, they are categorized based on the type of market structure they are designed to exploit.
Second, they are differentiated by the execution logic through which alpha is extracted.

### Macro-level Classification

Strategies are classified into three macro-level families.

#### Trend-Following Strategies

Trend-following strategies are designed to exploit markets characterized by well-defined directional trends, either bullish or bearish. Their objective is to generate alpha during phases of sustained momentum, where price exhibits strong directional persistence over a given time horizon.

The dominant behavioral logic underlying these strategies is momentum and continuation, often associated with volatility expansion and decompression dynamics used to identify phases of acceleration and consolidation within an existing trend. Consequently, trend-following strategies tend to perform best in markets that naturally exhibit prolonged directional moves and regime persistence.

Performance is therefore inherently market-dependent. Certain asset classes—such as commodities and other macro-sensitive instruments (e.g. gold) have historically displayed stronger trend persistence compared to assets that are structurally constrained or predominantly mean-reverting. Effective strategy design and parameterization must explicitly account for these differences in order to achieve robust and repeatable performance.

#### Range-Structure Strategies




#### Reversal Strategies


Strategies are classified into three macro-level families based on the underlying market behavior they aim to exploit.
- Trend-following 
- Breakout strategies
- Mean reversion strategies

Each strategy includes:
- a clear trading logic
- parameter definitions
- backtesting methodology
- performance metrics and evaluation


### Execution Classification

The strategy operates with two execution types.


#### Breakout entries

A breakout is defined as a confirmed structural shift in which price exits a prior balance regime and establishes directional behavior.


#### Pull Back entries

We distinguish between breakout pullbacks, which occur after a structural break followed by a retest, and trend pullbacks, defined as short-term counter-moves within an established directional regime. Not all trend corrections qualify as pullbacks.

Our strategies operate exclusively on Type 1 (breakout pullbacks) and Type 2 (trend pullbacks). Type 3 corrections represent potential primary trend shifts and therefore require a separate analytical framework, including Elliott Wave Theory.

## Strategy Design

