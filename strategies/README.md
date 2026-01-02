# Strategies Laboratory

This section represents the research hub where trading strategies are designed and developed. Before detailing the specific mechanics of strategy construction, the organizational framework used to classify strategies is introduced.

Subsequently, the [process](#strategy-design) used to build robust trading strategies is presented. The framework provides a structured foundation for defining the core strategy architecture, while supporting the incremental integration of supplementary triggers, filters, and constraints aimed at improving robustness and regime adaptability.


## Foundational Framework

Strategies are classified according to two characteristics, in hierarchical order.
First, they are categorized based on the type of **market structure**they are designed to exploit.
Second, they are differentiated by the **execution logic** through which alpha is extracted.


### Macro-level Classification

Strategies are classified into three macro-level families.

#### *Trend-Following Strategies*

Trend-following strategies are designed to exploit markets characterized by well-defined directional trends, either bullish or bearish. Their objective is to generate alpha during phases of sustained momentum, where price exhibits strong directional persistence over a given time horizon.

The dominant behavioral logic underlying these strategies is **momentum and continuation**, often associated with volatility expansion and decompression dynamics used to identify phases of acceleration and consolidation within an existing trend. Consequently, trend-following strategies tend to perform best in markets that naturally exhibit prolonged directional moves and **regime persistence**.

Performance is therefore inherently market-dependent. Certain asset classes—such as commodities and other macro-sensitive instruments (e.g. gold) have historically displayed stronger trend persistence compared to assets that are structurally constrained or predominantly mean-reverting. Effective strategy design and parameterization must explicitly account for these differences in order to achieve robust and repeatable performance.

#### *Range-Structure Strategies*

Range-structure strategies are designed to operate in markets characterized by prolonged lateral price behavior, where directional trends are absent or weak. In such environments, price dynamics are dominated by consolidation rather than persistent directional movement, making trend-following approaches less effective.

These strategies are based on the assumption that price tends to oscillate within a bounded structure, often defined by structural support and resistance levels. Volatility is typically contained, and price exhibits limited directional drift. The primary objective is to exploit repetitive oscillatory behavior within the range, while explicitly filtering out phases of sustained directional movement.

Within this family, **range-oscillation** strategies focus on capturing price movements between the upper and lower bounds of the range, with exits typically defined at opposing structural levels rather than directional continuation. **Mean-reversion** strategies are also included within this category, but are distinguished by a different execution objective. These strategies exploit the tendency of price to revert toward a reference value or equilibrium after temporary deviations. The mean itself constitutes the primary profit target, rather than the range boundaries. This behavioral logic is particularly effective during strong consolidation phases, where price fluctuations remain bounded and volatility is compressed.

#### *Reversal Strategies*

Reversal strategies are designed to identify market conditions that precede the emergence of a new directional regime. These strategies focus on detecting structural transitions in market behavior, rather than temporary price fluctuations within an existing regime.

The primary objective is to capture phases of **volatility compression** and subsequent decompression, which often signal the formation of **accumulation or distribution processes**. These conditions frequently precede the initiation of a new trend, characterized by increasing directional persistence and expanding volatility.

By targeting regime transitions rather than equilibrium reversion, reversal strategies aim to exploit the early stages of trend formation. The emphasis is therefore on identifying shifts in market structure and positioning for the onset of sustained directional movement, rather than reacting to established trends.


### Execution Classification

Execution logic is organized into two primary entry archetypes, reflecting how directional exposure is initiated within a given market structure.

#### *Breakout entries*

A breakout entry is defined as a confirmed structural shift in which price exits a prior balance or consolidation regime and begins to exhibit directional behavior. These entries aim to capture the initial phase of momentum expansion following regime transition.

#### *Pull Back entries*

Pullback entries are employed after directional behavior has already been established. Two distinct pullback configurations are considered:
- **Breakout pullbacks**, which occur after a structural break and subsequent retest of the broken level.
- **Trend pullbacks**, defined as short-term counter-moves occurring within an established directional regime.

Not all corrective price movements qualify as valid pullbacks. Only retracements that preserve the underlying market structure and directional bias are considered actionable.
The execution framework is explicitly limited to breakout pullbacks and trend pullbacks. Deeper corrective structures that suggest a potential primary trend transition are excluded, as they require a separate analytical framework focused on higher-order regime shifts.


## Strategy Design

Strategy design starts from a common bare-bones framework, intended to ensure a minimum level of structural robustness. Building on this foundation, strategies are progressively refined in order to enhance performance with respect to the specific market behavior they are designed to exploit.

The bare-bones framework rests on three structural entry conditions and at least one exit condition. Entry conditions must be satisfied sequentially in order to enable trade execution. The signal triggers are classified as follows.

Execution is governed by a hierarchical sequence of conditions:

1. **Market Structure Alignmment Trigger**  
Determines whether the current market regime is compatible with the strategy. This represents the first trigger and serves as the regime identification layer. Its role is to define the appropriate trading window by validating the target market structure and filtering out unfavorable or noisy conditions.

2. **Primary Execution Trigger**  
Identifies the presence of a valid structural or volatility-based setup within the confirmed market structure. This trigger activates the trade idea. Typical examples include moving average crossovers, MACD-based signals, or equivalent structural confirmation mechanisms.

3. **Secondary Execution Trigger**  
Confirms execution quality and timing through one or more complementary validation conditions. This trigger is designed to filter false setups and enhance robustness.

Trade execution is permitted **only when all three conditions are satisfied** in sequence.

**Exit conditions** are defined separately and require **at least one** dedicated **trigger**. Their purpose is to preserve the profits generated by the strategy and to optimize trade management through structured exit methodologies, which may include trailing stops, partial position exits (scale-out), and dynamic position adjustments.
