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
-include("../include/egts_types.hrl").
%% API
-export([data_to_bin/2]).

-export([to_byte/1]).
-export([to_ushort/1]).
-export([to_uint/1]).
-export([to_ulong/1]).
-export([to_short/1]).
-export([to_int/1]).
-export([to_float/1]).
-export([to_double/1]).



data_to_bin(Data, _Size) when (Data == null) ->
  {empty, "Data is null."};
data_to_bin(Data, _Size) when (is_list(Data) and (length(Data) == 0)) ->
  {empty, "Data is null."};
data_to_bin(Data, _Size) when (is_integer(Data) and (Data == 0)) ->
  {empty, "Data is null."};
data_to_bin(Data, Size) when (is_integer(Data) and is_integer(Size) and (Size > 0)) ->
  data_to_bin(list_to_binary(integer_to_list(Data)), Size);
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


to_byte(Data) ->
  if
    is_integer(Data) and (Data >= 0) and (Data =< 255) ->
      {ok, <<Data:?BYTE>>};
    true ->
      {error, "Error invalid data"}
  end.

to_ushort(Data) ->
  if
    is_integer(Data) and (Data >= 0) and (Data =< 65535) ->
      {ok, <<Data:?USHORT>>};
    true ->
      {error, "Error invalid data"}
  end.

to_uint(Data) ->
  if
    is_integer(Data) and (Data >= 0) and (Data =< 4294967295) ->
      {ok, <<Data:?UINT>>};
    true ->
      {error, "Error invalid data"}
  end.

to_ulong(Data) ->
  if
    is_integer(Data) and (Data >= 0) and (Data =< 18446744073709551615) ->
      {ok, <<Data:?ULONG>>};
    true ->
      {error, "Error invalid data"}
  end.

to_short(Data) ->
  if
    is_integer(Data) and (Data >= -32768) and (Data =< 32767) ->
      {ok, <<Data:?SHORT>>};
    true ->
      {error, "Error invalid data"}
  end.

to_int(Data) ->
  if
    is_integer(Data) and (Data >= -2147483648) and (Data =< 2147483647) ->
      {ok, <<Data:?INT>>};
    true ->
      {error, "Error invalid data"}
  end.

to_float(Data) ->
  if
    is_float(Data) ->
      {ok, <<Data:?FLOAT>>};
    true ->
      {error, "Error invalid data"}
  end.

to_double(Data) ->
  if
    is_float(Data) ->
      {ok, <<Data:?DOUBLE>>};
    true ->
      {error, "Error invalid data"}
  end.