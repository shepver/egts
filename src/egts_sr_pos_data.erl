%%%-------------------------------------------------------------------
%%% @author shepver
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Дек. 2014 2:34
%%%-------------------------------------------------------------------
-module(egts_sr_pos_data).
-author("shepver").

%% API
-export([]).


packet()->
  << NTM:32/integer,
     LAT:32/integer,
     LONG:32/integer,
     ALTH:1,  LOHS:1,  LAHS:1,  MV:1,  BB:1,  CS:1,  FIX:1,  VLD:1,
     DIRH:1
  ALTS
  SPD (Speed) старшие биты


  >>