%%%-------------------------------------------------------------------
%%% @author shepver
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Дек. 2014 15:01
%%%-------------------------------------------------------------------
-module(egts_service_teledata).
-author("shepver").
-include("../include/egts_types.hrl").
-include("../include/egts_record.hrl").
%% API
-export([pos_data/1, response/2, packet_data/1]).

-define(EGTS_SR_RECORD_RESPONSE, 0).
-define(EGTS_SR_RESULT_CODE, 9).
-define(EGTS_SR_POS_DATA, 16).

%% -spec(pos_data(PosData :: #pos_data{}) ->
%%   {ok, Data :: binary} | {error, Reason :: term()}).

pos_data(PosData) ->
  try packet_data(PosData) of
    {ok, Data} -> {ok, ?EGTS_SR_POS_DATA, Data};
    {error, Reason} -> {error, Reason}
  catch
    throw:Error -> {throw, Error};
    error:Reason ->
      error_logger:info_msg("Catch ~p ~p ~n", [Reason, erlang:get_stacktrace()])
  end.

packet_data(PosData) ->
  NTM = egts_utils:get_time(PosData#pos_data.ntm),
  LAT = trunc(abs(PosData#pos_data.lat) / 90 * 16#FFFFFFF),
  LON = trunc(abs(PosData#pos_data.long) / 180 * 16#FFFFFFF),
  LOHS = egts_utils:sign(PosData#pos_data.long),
  LAHS = egts_utils:sign(PosData#pos_data.lat),
  ALTE = 0,
  ALTS = 0,
  SRC = PosData#pos_data.src,
  MV = PosData#pos_data.mv,
  DIN = 0,
  ODM = 0,
  CS = 0,
  VLD = 0,
  BB = 0,
  FIX = 0,
  Speed = trunc(PosData#pos_data.spd * 10),
  <<SPDH:6, SPDL:8>> = <<Speed:14>>,
  Direction = PosData#pos_data.dir,
  <<DIRH:1, DIR:8>> = <<Direction:9>>,
  Data = <<NTM:?UINT,
  LAT:?UINT,
  LON:?UINT,
  ALTE:1, LOHS:1, LAHS:1, MV:1, BB:1, CS:1, FIX:1, VLD:1,
  SPDL:8,
  DIRH:1, ALTS:1, SPDH:6,
  DIR:?BYTE,
  ODM:24,
  DIN:?BYTE,
  SRC:?BYTE>>,
  {ok, Data}.


response(?EGTS_SR_RECORD_RESPONSE, Data) ->
  <<CRN:?USHORT, RST:?BYTE>> = Data,
  {CRN, RST, egts_utils:result(RST)};
response(?EGTS_SR_RESULT_CODE, Data) ->
  <<RCD:?BYTE>> = Data,
  {result_code, egts_utils:result(RCD)};
response(_, Data) ->
  {Data}.