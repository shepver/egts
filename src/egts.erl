%%%-------------------------------------------------------------------
%%% @author shepver
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Дек. 2014 16:30
%%%-------------------------------------------------------------------
-module(egts).
-author("shepver").
-include("../include/egts_types.hrl").
-include("../include/egts_record.hrl").
-include("../include/egts_code.hrl").
%% API
%% -export([encode_pos_data/1]).
-export([start/0, stop/0]).

-export([auth/1]).
-export([auth_disp/1]).
-export([response/1]).

-export([pos_data/1]).


-export([test/0]).

%% encode_pos_data(Data) when is_tuple(Data) ->
%%   {Time, Lon, Lat} = Data,
%%   Packet = get_pos_data_packet(Data);
%% encode_pos_data(Data) when is_list(Data) ->
%%   [Data1 | T] = Data,
%%   Packet = get_pos_data_packet(Data1)
%% .

%% get_pos_data_packet({Time, Lon, Lat}) ->
%%   packet.

start() ->
  application:start(egts).

stop() ->
  application:stop(egts).



auth([Login, IMEI]) ->
  {ok, SubType, Data} = egts_service_auth:term_identity(#auth{tid = Login, imei = IMEI,hdid = 1}),
  NumberRecord = 1, %% порядковый номер строки
  {ok, RecordData} = egts_service:auth_pack([Data, NumberRecord, SubType]),
  PID = 1, %% идентификатор пакета или просто номео пакета в сессии (для аутентификации он всегда 1)
  {ok, TransportData} = egts_transport:pack([RecordData, PID]),

%%     gen_server:call(egts_work,{egts_auth,#auth{tid = Login, imei = IMEI}}),
%%   RecordData.
  TransportData.

auth_disp([]) ->
  ok.

pos_data([]) ->
%%   {ok, SubType, Data} = egts_service_teledata:term_identity(#auth{tid = Login, imei = IMEI}),
%%   NumberRecord = 1, %% порядковый номер строки
%%   {ok, RecordData} = egts_service:auth_pack([Data, NumberRecord, SubType]),
%%   PID = 2, %% идентификатор пакета или просто номео пакета в сессии (для аутентификации он всегда 1)
%%   {ok, TransportData} = egts_transport:pack([RecordData, PID])
ok.


%%  получили товет от сервера и обрабатываем
response(Data) ->
  case egts_transport:response(Data) of
    {error, Code} -> {error, egts_utils:result(Code)};
    {ok, Record} ->
      if
        is_record(Record, egts_pt_response) ->
%%           пришел ответ на транспортный пакет
%%           помечаем где надо что пакет они приняли и ждем результата обработки
          {Record#egts_pt_response.rpid, Record#egts_pt_response.pr}
%%             zaglushka
      ;
        is_record(Record, egts_pt_appdata) ->
%%           пришел пакет данных с сервера надо им ответить что мы пакет приняли и обработать пакет (скорее всего с ответами)
%%           данные для ответа на сервер
%%           RecordData = Record#egts_pt_appdata.response,
%%           PID = 2, %% порядковй номер пакета для данной сессии PID_old + 1
%%           {ok, TransportDataResponse} = egts_transport:pack([RecordData, PID,?EGTS_PT_RESPONSE]),
%%           данные для обработки  Record#egts_pt_appdata.record_list,
          %% получаем список строк записей
          egts_service:pars_for_info(Record#egts_pt_appdata.record_list)
%%          , zaglushka
      ;
        true -> zaglushka
      end
  end.

test() ->
  Data = auth([11, 111111]),
  {response(Data), Data}.

