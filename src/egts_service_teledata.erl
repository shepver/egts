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

%% API
-export([]).


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