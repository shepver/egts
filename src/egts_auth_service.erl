%%%-------------------------------------------------------------------
%%% @author shepver
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Дек. 2014 15:00
%%%-------------------------------------------------------------------
-module(egts_auth_service).
-author("shepver").
-include("../include/egts_types.hrl").
%% API
-export([term_identity/1]).
-export([response/1]).

%% --------------------------------------------------------------------
-define(EGTS_SR_RECORD_RESPONSE, 0).

%% Подзапись применяется для
%% осуществления подтверждения
%% процесса обработки записи
%% протокола уровня поддержки
%% услуг. Данный тип подзаписи
%% должен поддерживаться всеми
%% сервисами

response(Data) ->
  <<_CRN:?USHORT, _RST:?BYTE>> = Data,
  ok.

%%   - CRN - номер подтверждаемой записи (значение поля RN из
%%   обрабатываемой записи);
%% - RST - статус обработки записи.


%% ---------------------------------------------------------------------

-define(EGTS_SR_TERM_IDENTITY, 1).

%% Подзапись используется АС при
%% запросе авторизации на
%% телематическую платформу и
%% содержит учетные данные АС

-spec(term_identity(Auth :: #auth{}) ->
  {ok, Data :: binary} | {error, Reason :: term()}).

term_identity(Auth) ->
  try packet_data(Auth) of
    {ok, Data} -> {ok, Data};
    {error, Reason} -> {error, Reason}
  catch
    throw:Error -> {throw, Error};
    error:Reason ->
      error_logger:info_msg("Catch ~p ~p ~n", [Reason, erlang:get_stacktrace()])
  end


.


packet_data(Auth) ->
  TID = Auth#auth.tid,
  packet_data(Auth, 1, <<TID:?UINT>>, <<>>).

packet_data(Auth, 1, Header, Option) ->
  Data = Auth#auth.msisdn,
  case egts_utils:data_to_bin(Data, 120) of
    {ok, NewData} -> packet_data(Auth, 2, <<Header/binary, 1:1>>, NewData);
    {empty, _Reason} -> packet_data(Auth, 2, <<Header/binary, 1:0>>, Option);
    {error, Reason} -> {error, {Reason, "1"}}
  end;
packet_data(Auth, 2, Header, Option) ->
  Data = Auth#auth.bs,
  case egts_utils:data_to_bin(Data, ?USHORT_SIZE) of
    {ok, NewData} -> packet_data(Auth, 3, <<Header/binary, 1:1>>, <<NewData/binary, Option/binary>>);
    {empty, _Reason} -> packet_data(Auth, 3, <<Header/binary, 1:0>>, Option);
    {error, Reason} -> {error, {Reason, "2"}}
  end;
packet_data(Auth, 3, Header, Option) ->
  Data0 = Auth#auth.mcc,
  Data1 = Auth#auth.mnc,
  {NewHeader, NewOptions} = if
                              is_integer(Data0) and is_integer(Data1) ->
                                NID = <<0:4, Data0:10, Data1:10>>,
                                {<<Header/binary, 1:1>>, <<NID/binary, Option/binary>>};
                              true ->
                                {<<Header/binary, 0:1>>, Option}
                            end,
  packet_data(Auth, 4, NewHeader, NewOptions);
packet_data(Auth, 4, Header, Option) ->
%%   SSRA - битовый флаг, предназначенный для определения алгоритма
%%   использования сервисов (если бит равен 1, то используется простой
%%   алгоритм, если 0, то алгоритм запросов на использование сервисов);
  packet_data(Auth, 5, <<Header/binary, 0:1>>, Option);
packet_data(Auth, 5, Header, Option) ->
  Data = Auth#auth.lngc,
  case egts_utils:data_to_bin(Data, 24) of
    {ok, NewData} -> packet_data(Auth, 6, <<Header/binary, 1:1>>, <<NewData/binary, Option/binary>>);
    {empty, _Reason} -> packet_data(Auth, 6, <<Header/binary, 1:0>>, Option);
    {error, Reason} -> {error, {Reason, "5"}}
  end;
packet_data(Auth, 6, Header, Option) ->
  Data = Auth#auth.imsi,
  case egts_utils:data_to_bin(Data, 128) of
    {ok, NewData} -> packet_data(Auth, 7, <<Header/binary, 1:1>>, <<NewData/binary, Option/binary>>);
    {empty, _Reason} -> packet_data(Auth, 7, <<Header/binary, 1:0>>, Option);
    {error, Reason} -> {error, {Reason, "6"}}
  end;
packet_data(Auth, 7, Header, Option) ->
  Data = Auth#auth.imei,
  case egts_utils:data_to_bin(Data, 120) of
    {ok, NewData} -> packet_data(Auth, 8, <<Header/binary, 1:1>>, <<NewData/binary, Option/binary>>);
    {empty, _Reason} -> packet_data(Auth, 8, <<Header/binary, 1:0>>, Option);
    {error, Reason} -> {error, {Reason, "7"}}
  end;
packet_data(Auth, 8, Header, Option) ->
  Data = Auth#auth.hdid,
  case egts_utils:data_to_bin(Data, ?USHORT_SIZE) of
    {ok, NewData} -> {ok, <<Header/binary, 1:1, NewData/binary, Option/binary>>};
    {empty, _Reason} -> {ok, <<Header/binary, 1:0, Option/binary>>};
    {error, Reason} -> {error, {Reason, "8"}}
  end.

%% data(Data) ->
%%   <<
%%   TDI:?UINT,
%%   MNE:1, BSE:1, NIDE:1, SSRA:1, LNGSE:1, IMSIE:1, IMEIE:1, HDIDE:1,
%%   HDID:?USHORT,
%%   IMEI:120/?STRING,
%%   IMSI:128/?STRING,
%%   LNGC:24/?STRING,
%%   NID:24/?BINARY,
%%   BS:?USHORT,
%%   MSISDN:120/?STRING
%%   >> = Data,
%%
%%   <<_:4, MCC:10, MNC:10>> = NID,
%%   ok.