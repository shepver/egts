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

%% API
-export([]).
-define(EGTS_AUTH_SERVICE,1).
-define(EGTS_TELEDATA_SERVICE,2).
-define(EGTS_COMMANDS_SERVICE,4).
-define(EGTS_FIRMWARE_SERVICE,9).
-define(EGTS_ECALL_SERVICE, 10).