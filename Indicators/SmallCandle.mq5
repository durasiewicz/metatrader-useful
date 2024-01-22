//+------------------------------------------------------------------+
//|                                                  SmallCandle.mq5 |
//|                               Copyright 2024, Artur Durasiewicz. |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, Artur Durasiewicz."
#property link      ""
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots   1
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_label1 "Small candle"
#property indicator_color1  White

//--- input parameters
input double   SmallCandleMaxBodyRangeRatio = 0.49;

double OpenBuffer[];
double HighBuffer[];
double LowBuffer[];
double CloseBuffer[];
double ColorBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexBuffer(0, OpenBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, HighBuffer, INDICATOR_DATA);
   SetIndexBuffer(2, LowBuffer, INDICATOR_DATA);
   SetIndexBuffer(3, CloseBuffer, INDICATOR_DATA);
   SetIndexBuffer(4, ColorBuffer, INDICATOR_COLOR_INDEX);
   IndicatorSetInteger(INDICATOR_DIGITS, _Digits);
   IndicatorSetString(INDICATOR_SHORTNAME, "Small candle");
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   int start;

   if(prev_calculated == 0)
     {
      OpenBuffer[0] = open[0];
      HighBuffer[0] = high[0];
      LowBuffer[0] = low[0];
      CloseBuffer[0] = close[0];
      start=1;
     }
   else
     {
      start = prev_calculated-1;
     }

   for(int i=start; i<rates_total && !IsStopped(); i++)
     {
      bool isSmallCandle = high[i] - low[i] > 0 &&
                           MathAbs(open[i] - close[i]) / (high[i] - low[i]) <= SmallCandleMaxBodyRangeRatio;

      OpenBuffer[i] = isSmallCandle ? open[i] : 0.0;
      HighBuffer[i] = isSmallCandle ? high[i] : 0.0;
      LowBuffer[i] = isSmallCandle ? low[i] : 0.0;
      CloseBuffer[i] = isSmallCandle ? close[i] : 0.0;

      if(isSmallCandle)
        {
         ColorBuffer[i] = 0.0;
        }
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
