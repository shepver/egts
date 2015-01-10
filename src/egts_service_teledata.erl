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
-export([pos_data/1]).


%% packet(TIME) ->
%%   <<NTM:32/integer>> = integer_to_binary(TIME),
%%   <<LAT:32/integer>> = integer_to_binary(1) ,
%%
%% Packet =
%% <<NTM/binary,
%% LAT/binary,
%% LONG:32/integer,
%% ALTH:1, LOHS:1, LAHS:1, MV:1, BB:1, CS:1, FIX:1, VLD:1,
%% DIRH:1,
%% ALTS,
%% SPD:14/integer

%%
%% >>.


-spec(pos_data(PosData :: #pos_data{}) ->
  {ok, Data :: binary} | {error, Reason :: term()}).

pos_data(_PosData) ->
  ok.