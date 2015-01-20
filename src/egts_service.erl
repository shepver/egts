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
-include("../include/egts_record.hrl").
-include("../include/egts_code.hrl").

-export([pack/1, auth_pack/1, posdata_pack/1, parse/1, response_rd/2, pars_for_info/1, pars_for_responce/1]).
%% API
-export([]).

-define(EGTS_AUTH_SERVICE, 1).

%% service(1) -> egts_service_auth.



-define(EGTS_TELEDATA_SERVICE, 2).
-define(EGTS_COMMANDS_SERVICE, 4).
-define(EGTS_FIRMWARE_SERVICE, 9).
-define(EGTS_ECALL_SERVICE, 10).


-define(EGTS_SR_RECORD_RESPONSE, 0).

response_rd(Number, Status) ->
  CRN = Number,
  RST = Status,
  <<CRN:?USHORT, RST:?BYTE>>.


auth_pack([Data, Number, SubType, OID]) ->
  pack([Data, Number, ?EGTS_AUTH_SERVICE, SubType, OID]).


posdata_pack([Data, Number, SubType, OID]) ->
  pack([Data, Number, ?EGTS_TELEDATA_SERVICE, SubType, OID]).

%% pack([Data, Number, Type, SubType]) ->
%%   pack([Data, Number, Type, SubType, 1]);
pack([Data, Number, Type, SubType, Oid]) ->
  {ok, SubData} = sub_record_pack([Data, SubType]),
  RL = byte_size(SubData),
%%   error_logger:error_msg(" size ~p ~p ~p", [RL, SubData, Oid]),
  RN = Number,
  SSOD = 0, RSOD = 0, GRP = 0, RPP = 2#01, TMFE = 0, EVFE = 0, OBFE = 1,
  OID = Oid,
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parse(<<>>) ->
  [];
parse(Data) ->
  parse(Data, []).
parse(Data, List) ->
  <<RL:?USHORT
  , RN:?USHORT
  , SSOD:1, RSOD:1, GRP:1, RPP:2, TMFE:1, EVFE:1, OBFE:1
  , Other/binary>> = Data,
  Record = #service_record{rl = RL, rn = RN, ssod = SSOD, rsod = RSOD, grp = GRP, rpp = RPP},
  {Other11, Record1} = if
                         OBFE =:= 1 ->
                           <<OID:?UINT, Other1/binary>> = Other,
                           {Other1, Record#service_record{obfe = 1, oid = OID}};
                         true ->
                           {Other, Record#service_record{obfe = 0, oid = null}}
                       end,
  {Other22, Record2} = if
                         EVFE =:= 1 ->
                           <<EVID:?UINT, Other2/binary>> = Other11,
                           {Other2, Record1#service_record{evfe = 1, evid = EVID}};
                         true ->
                           {Other11, Record1#service_record{evfe = 0, evid = null}}
                       end,
  {Other33, Record3} = if
                         TMFE =:= 1 ->
                           <<TM:?UINT, Other3/binary>> = Other22,
                           {Other3, Record2#service_record{tmfe = 1, tm = TM}};
                         true ->
                           {Other22, Record2#service_record{tmfe = 0, tm = null}}
                       end,

  if
    (2 + RL) == byte_size(Other33) ->
      <<SST:?BYTE, RST:?BYTE, RD:RL/binary-unit:8>> = Other33,
      Record4 = Record3#service_record{sst = SST, rst = RST, rd = sub_record_parse(RD, [])},
      [Record4 | List]
  ;
    true ->
      <<SST:?BYTE, RST:?BYTE, RD:RL/binary-unit:8, Tail/binary>> = Other33,
      Record4 = Record3#service_record{sst = SST, rst = RST, rd = sub_record_parse(RD, [])},
      parse(Tail, [Record4 | List])
  end
.


sub_record_parse(<<SRT:?BYTE, SRL:?USHORT>> = _Data, List) ->
  [#service_sub_record{srt = SRT, srl = SRL} | List];
sub_record_parse(<<SRT:?BYTE, SRL:?USHORT, SRD:SRL/binary-unit:8>> = _Data, List) ->
  [#service_sub_record{srt = SRT, srl = SRL, srd = SRD} | List];
sub_record_parse(<<SRT:?BYTE, SRL:?USHORT, SRD:SRL/binary-unit:8, Other/binary>> = _Data, List) ->
  sub_record_parse(Other, [#service_sub_record{srt = SRT, srl = SRL, srd = SRD} | List]).


pars_for_info(<<>>) ->
  [];
pars_for_info(Data) ->
  ListRecord = parse(Data),
  check(ListRecord, [])
.

check([], List) ->
  List;
check([ListR | T], List) ->
  S = sub_check(ListR#service_record.rst, ListR#service_record.rd, []),
  check(T, [S | List]).

sub_check(_, [], List) ->
  List;
sub_check(Service, [Record | T], List) ->
  Data = case Service of
           ?EGTS_AUTH_SERVICE ->
             egts_service_auth:response(Record#service_sub_record.srt, Record#service_sub_record.srd);
           ?EGTS_TELEDATA_SERVICE ->
             egts_service_teledata:response(Record#service_sub_record.srt, Record#service_sub_record.srd)
         end,
  R = {egts_utils:service(Service), egts_utils:erecord(Service, Record#service_sub_record.srt), Data},
  sub_check(Service, T, [R | List]).


pars_for_responce({Data, OID}) ->
  ListRecord = parse(Data),
  {ok, checkr(ListRecord, <<>>, 1, OID)}.


checkr([], Data, _, _) ->
  Data;
checkr([ListR | T], Data, Number, OID) ->
  RN = ListR#service_record.rn,
  Status = ?EGTS_PC_OK,
  {ok, DataN} = pack([<<RN:?USHORT, Status:?BYTE>>, Number, ListR#service_record.rst, ?EGTS_SR_RECORD_RESPONSE, OID]),
  checkr(T, <<Data/binary, DataN/binary>>, Number + 1, OID).

