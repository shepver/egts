%%%-------------------------------------------------------------------
%%% @author shepver
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Дек. 2014 13:06
%%%-------------------------------------------------------------------
-module(egts_utils).
-author("shepver").

%% API
-export([data_to_bin/2]).

data_to_bin(Data, _Size) when (Data == null) ->
  {empty, "Data is null."};
data_to_bin(Data, _Size) when (is_list(Data) and (length(Data) == 0)) ->
  {empty, "Data is null."};
data_to_bin(Data, _Size) when (is_integer(Data) and (Data == 0)) ->
  {empty, "Data is null."};
data_to_bin(Data, Size) when (is_integer(Data) and is_integer(Size) and (Size > 0)) ->

  data_to_bin(<<Data:Size>>, Size);
data_to_bin(Data, Size) when (is_list(Data) and is_integer(Size) and (Size > 0)) ->
  data_to_bin(list_to_binary(Data), Size);
data_to_bin(Data, Size) when is_binary(Data) ->
  BSize = bit_size(Data),
  Result = if
             Size == BSize ->
               {ok, Data};
             Size > BSize ->
               P = Size - BSize,
               {ok, <<0:P, Data/binary>>};
             true ->
               {error, "Size incorrect: data size exceeds a predetermined data size."}
           end,
  Result;
data_to_bin(_Data, _Size) ->
  {error, "Data or Size incorrect."}
.
