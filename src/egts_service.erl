%%%-------------------------------------------------------------------
%%% @author shepver
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Дек. 2014 14:56
%%%-------------------------------------------------------------------
-module(egts_service).
-author("shepver").

-include("../include/egts_types.hrl").

-export([pack/1, auth_pack/1]).
%% API
-export([]).
-define(EGTS_AUTH_SERVICE, 1).
-define(EGTS_TELEDATA_SERVICE, 2).
-define(EGTS_COMMANDS_SERVICE, 4).
-define(EGTS_FIRMWARE_SERVICE, 9).
-define(EGTS_ECALL_SERVICE, 10).

auth_pack([Data, Number, SubType]) ->
  pack([Data, Number, ?EGTS_AUTH_SERVICE, SubType]).
pack([Data, Number, Type, SubType]) ->
  {ok, SubData} = sub_record_pack([Data, SubType]),
  RL = byte_size(SubData),
  RN = Number,
  SSOD = 0, RSOD = 0, GRP = 0, RPP = 2#01, TMFE = 0, EVFE = 0, OBFE = 1,
  OID = 1,
%%   EVID,
%%   TM,
  SST = Type,
  RST = Type,
  NewData =
    <<RL:?USHORT,
    RN:?USHORT,
    SSOD:1, RSOD:1, GRP:1, RPP:2, TMFE:1, EVFE:1, OBFE:1,
    OID:?UINT,
%%   EVID,
%%   TM,
    SST:?BYTE,
    RST:?BYTE,
    SubData/binary>>,
  {ok, NewData}.

sub_record_pack([Data, Type]) ->
  SRL = byte_size(Data),
  {ok, <<Type:?BYTE, SRL:?USHORT, Data/binary>>}.
