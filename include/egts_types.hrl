%%%-------------------------------------------------------------------
%%% @author shepver
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Дек. 2014 1:57
%%%-------------------------------------------------------------------
%%% описание типов
-author("shepver").
-define(BOLLEAN, 8 / unsigned - integer).
-define(BYTE, 8 / unsigned - integer).
-define(USHORT, 16 / unsigned - integer - little).
-define(UINT, 32 / unsigned - integer - little).
-define(ULONG, 64 / unsigned - integer - little).
-define(SHORT, 8 / signed - integer).
-define(INT, 32 / signed - integer).
-define(FLOAT, 32 / signed - float - little).
-define(DOUBLE, 64 / signed - float - little).
-define(STRING, bitstring).
-define(BINARY, binary).


-define(BOLLEAN_SIZE, 8).
-define(BYTE_SIZE, 8).
-define(USHORT_SIZE, 16).
-define(UINT_SIZE, 32).
-define(ULONG_SIZE, 64).
-define(SHORT_SIZE, 8).
-define(INT_SIZE, 32).
-define(FLOAT_SIZE, 32).
-define(DOUBLE_SIZE, 64).

-record(auth, {tid = null, imei = null, imsi = null, hdid = null, msisdn = null, mcc = 1, mnc = 1, lngc = "rus", bs = 1024}).
