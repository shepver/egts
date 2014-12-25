%%%-------------------------------------------------------------------
%%% @author shepver
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Дек. 2014 11:59
%%%-------------------------------------------------------------------
-module(test).
-author("shepver").

%% API
-export([test/2]).



test(In,Size) ->
 egts_utils:data_to_bin(In,Size)
.
