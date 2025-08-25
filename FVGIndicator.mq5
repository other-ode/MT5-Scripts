#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0
#property strict

input int    LookBackBars   = 500;   // Number of bars to scan for FVGs
input color  BullishColor   = clrGreen;
input color  BearishColor   = clrRed;
input uchar  Transparency   = 80;    // 0..255 transparency for rectangles

int OnInit()
  {
   IndicatorSetString(INDICATOR_SHORTNAME,"FVG Indicator");
   ObjectsDeleteAll(0,"FVG");
   return(INIT_SUCCEEDED);
  }

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
   int bars=MathMin(rates_total,LookBackBars);

   if(prev_calculated==0)
      ObjectsDeleteAll(0,"FVG");

   for(int i=2; i<bars; i++)
     {
      // Candle sequence: i (first), i-1 (second), i-2 (third / most recent)
      if(low[i] > high[i-2])        // Bullish FVG
        {
         string name="FVG_Bull_"+IntegerToString(i);
         if(ObjectFind(0,name)==-1)
           {
            ObjectCreate(0,name,OBJ_RECTANGLE,0,time[i],high[i-2],time[i-2],low[i]);
            ObjectSetInteger(0,name,OBJPROP_COLOR,BullishColor);
            ObjectSetInteger(0,name,OBJPROP_BACK,true);
            ObjectSetInteger(0,name,OBJPROP_FILL,true);
            ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);
            ObjectSetInteger(0,name,OBJPROP_WIDTH,1);
            ObjectSetInteger(0,name,OBJPROP_TRANSPARENCY,Transparency);
           }
        }
      else if(high[i] < low[i-2])  // Bearish FVG
        {
         string name="FVG_Bear_"+IntegerToString(i);
         if(ObjectFind(0,name)==-1)
           {
            ObjectCreate(0,name,OBJ_RECTANGLE,0,time[i],low[i-2],time[i-2],high[i]);
            ObjectSetInteger(0,name,OBJPROP_COLOR,BearishColor);
            ObjectSetInteger(0,name,OBJPROP_BACK,true);
            ObjectSetInteger(0,name,OBJPROP_FILL,true);
            ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);
            ObjectSetInteger(0,name,OBJPROP_WIDTH,1);
            ObjectSetInteger(0,name,OBJPROP_TRANSPARENCY,Transparency);
           }
        }
     }
   return(rates_total);
  }
