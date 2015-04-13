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

-export([connect/3]).
-export([send_pos_data/1]).


-export([pos_data/1]).


-export([test/0]).
-export([valid/1]).
-export([valid2/1]).

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


%% did - dispatcher ID
connect(Host, Port, Did) ->
  gen_server:cast(egts_work, {connect, Host, Port, Did}),
  ok.
%% {IMEI,[{Action, Time, Lat, Lon, Speed, Cource, Mv},..]}
send_pos_data({Imei, List}) ->
  gen_server:cast(egts_work, {pos_data, {Imei, List}}),
  ok.


auth({Pid, [Login, IMEI, Disp]}) ->
  {ok, SubType, Data} = egts_service_auth:term_identity(#auth{tid = Login, imei = IMEI, hdid = Disp}),
  NumberRecord = 1, %% порядковый номер строки
  {ok, RecordData} = egts_service:auth_pack([Data, NumberRecord, SubType]),
  PID = Pid, %% идентификатор пакета или просто номео пакета в сессии (для аутентификации он всегда 1)
  {ok, TransportData} = egts_transport:pack([RecordData, PID]),
%%     gen_server:call(egts_work,{egts_auth,#auth{tid = Login, imei = IMEI}}),
%%   RecordData.
  TransportData.

auth_disp({PID, OID, Did}) ->
  {ok, SubType, Data} = egts_service_auth:dispatcher_identity({0, Did}),
  NumberRecord = 1, %% порядковый номер строки
  {ok, RecordData} = egts_service:auth_pack([Data, NumberRecord, SubType, OID]),
%%   PID = Pid, %% идентификатор пакета или просто номео пакета в сессии (для аутентификации он всегда 1)
  {ok, TransportData} = egts_transport:pack([RecordData, PID]),
%%     gen_server:call(egts_work,{egts_auth,#auth{tid = Login, imei = IMEI}}),
%%   RecordData.
  TransportData.

pos_data({Pid, OID, [Time, Lat, Lon, Speed, Dir]}) ->
  {ok, SubType, Data} = egts_service_teledata:pos_data(#pos_data{ntm = Time, lat = Lat, long = Lon, spd = Speed, dir = Dir}),
  NumberRecord = 1, %% порядковый номер строки
  {ok, RecordData} = egts_service:posdata_pack([Data, NumberRecord, SubType, OID]),
  PID = Pid, %% идентификатор пакета или просто номео пакета в сессии (для аутентификации он всегда 1)
  {ok, TransportData} = egts_transport:pack([RecordData, PID]),
  TransportData.


%%  получили товет от сервера и обрабатываем
response({list, OID, Data}) ->
  egts_transport:response({Data, OID});

response({responce, Pid, SendData}) ->
  case SendData of
    {error, Code} -> {error, egts_utils:result(Code)};
    {ok, Record} ->
      if
        is_record(Record, egts_pt_response) ->
%%           пришел ответ на транспортный пакет
%%           помечаем где надо что пакет они приняли и ждем результата обработки
          {response, Record#egts_pt_response.rpid, Record#egts_pt_response.pr, Record#egts_pt_response.record_list}
%%             zaglushka
      ;
        is_record(Record, egts_pt_appdata) ->
%%           пришел пакет данных с сервера надо им ответить что мы пакет приняли и обработать пакет (скорее всего с ответами)
%%           данные для ответа на сервер
          RecordData = Record#egts_pt_appdata.response,
          PID = Pid, %% порядковй номер пакета для данной сессии PID_old + 1
          {ok, TransportDataResponse} = egts_transport:pack([RecordData, PID, ?EGTS_PT_RESPONSE]),
%%           данные для обработки  Record#egts_pt_appdata.record_list,
          %% получаем список строк записей
          {app_data, TransportDataResponse, Record#egts_pt_appdata.record_list}
%%          , zaglushka
      ;
        true -> {un, SendData}
      end
  end.

test() ->
  Data = pos_data([1416635639, 52.252659, 104.343803, 50.00, 100]),
  Data
%%   egts_service_teledata:packet_data(#pos_data{ntm = 1416635639, lat = 52.252659, long = 104.343803, spd =  50.00, dir = 100})
.

valid(Data) ->
  case egts_transport:response({Data, 1}) of
    {error, Code} -> {error, egts_utils:result(Code)};
    {ok, Record} ->
      if
        is_record(Record, egts_pt_response) ->
%%           пришел ответ на транспортный пакет
%%           помечаем где надо что пакет они приняли и ждем результата обработки
          {response, Record#egts_pt_response.rpid, Record#egts_pt_response.pr, Record#egts_pt_response.record_list}
%%             zaglushka
      ;
        is_record(Record, egts_pt_appdata) ->
%%           пришел пакет данных с сервера надо им ответить что мы пакет приняли и обработать пакет (скорее всего с ответами)
%%           данные для ответа на сервер
%%           RecordData = Record#egts_pt_appdata.response,
%%           PID = 1, %% порядковй номер пакета для данной сессии PID_old + 1
%%           {ok, TransportDataResponse} = egts_transport:pack([RecordData, PID, ?EGTS_PT_RESPONSE]),
%%           данные для обработки  Record#egts_pt_appdata.record_list,
          %% получаем список строк записей
%%           _d = {app_data, TransportDataResponse, Record#egts_pt_appdata.record_list},
          D = egts_service:pars_for_info(Record#egts_pt_appdata.record_list),
          error_logger:error_msg("pars list ~p ", [D])
%%          , zaglushka
      ;
        true -> {un, Data}
      end
  end.


valid2(Data) ->
  resend(egts_transport:response({Data, 1})).



resend([]) -> ok;
resend([Data | Tail]) ->
  case egts:response({responce, 1, Data}) of
    {response, RPID, STATUS, SRD_LIST} ->
      error_logger:info_msg("Respone rpid ~p status ~p  r_list ~p.~n", [RPID, STATUS, egts_service:pars_for_info(SRD_LIST)]),
      resend(Tail)
  ;
    {app_data, _TransportDataResponse, DataList} ->
      error_logger:info_msg("Result list ~p .~n", [egts_service:pars_for_info(DataList)]),
      resend(Tail);
    {un, Data} ->
      error_logger:info_msg("UNResult ~p .~n", [Data]),
      resend(Tail)
  end.