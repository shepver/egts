%%%-------------------------------------------------------------------
%%% @author shepver
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Дек. 2014 16:30
%%%-------------------------------------------------------------------
-module(egts).
-author("shepver").

%% API
-export([encode_pos_data/1]).


encode_pos_data(Data) when is_tuple(Data) ->
  {Time, Lon, Lat} = Data,
  Packet = get_pos_data_packet(Data);
encode_pos_data(Data) when is_list(Data) ->
  [Data1 | T] = Data,
  Packet = get_pos_data_packet(Data1)
.

get_pos_data_packet({Time, Lon, Lat}) ->
  packet.

