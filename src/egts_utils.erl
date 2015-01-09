%%%-------------------------------------------------------------------
%%% @author shepver
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Дек. 2014 13:06
%%%-------------------------------------------------------------------
-module(egts_utils).
-author("shepver").
-include("../include/egts_types.hrl").
%% API
-export([data_to_bin/2]).

-export([to_byte/1]).
-export([to_ushort/1]).
-export([to_uint/1]).
-export([to_ulong/1]).
-export([to_short/1]).
-export([to_int/1]).
-export([to_float/1]).
-export([to_double/1]).
-export([result/1]).

-export([service/1]).
-export([erecord/2]).
-export([get_time/0, get_time/1]).
%% -export([sub_erecord/1]).

-export([
  crc8/1,
  crc16/1,
  check_crc8/2,
  check_crc16/2
]).


service(1) -> egts_auth_service;
service(2) -> egts_teledata_service.
erecord(_, 0) -> egts_sr_record_responce;
erecord(1, 1) -> egts_sr_term_identity;
erecord(_, _) -> netu.


result(0) -> 'EGTS_PC_OK'; %%  успешно обработано
result(1) -> 'EGTS_PC_IN_PROGRESS'; %%  в процессе обработки
result(128) -> 'EGTS_PC_UNS_PROTOCOL'; %%  неподдерживаемый протокол
result(129) -> 'EGTS_PC_DECRYPT_ERROR'; %%  ошибка декодирования
result(130) -> 'EGTS_PC_PROC_DENIED'; %%  обработка запрещена
result(131) -> 'EGTS_PC_INC_HEADERFORM'; %%  неверный формат заголовка
result(132) -> 'EGTS_PC_INC_DATAFORM'; %%  неверный формат данных
result(133) -> 'EGTS_PC_UNS TYPE'; %%  неподдерживаемый тип
result(134) -> 'EGTS_PC_NOTEN_PARAMS'; %%  неверное количество параметров
result(135) -> 'EGTS_PC_DBL_PROC'; %%  попытка повторной обработки
result(136) -> 'EGTS_PC_PROC_SRC_DENIED'; %%  обработка данных от источника запрещена
result(137) -> 'EGTS_PC_HEADERCRC_ERROR'; %%  ошибка контрольной суммы заголовка
result(138) -> 'EGTS_PC_DATACRC_ERROR'; %%  ошибка контрольной суммы данных
result(139) -> 'EGTS_PC_INVDATALEN'; %%  некорректная длина данных
result(140) -> 'EGTS_PC_ROUTE_NFOUND'; %%  маршрут не найден
result(141) -> 'EGTS_PC_ROUTE_CLOSED'; %%  маршрут закрыт
result(142) -> 'EGTS_PC_ROUTE_DENIED'; %%  маршрутизация запрещена
result(143) -> 'EGTS_PC_INVADDR'; %%  неверный адрес
result(144) -> 'EGTS_PC_TTLEXPIRED'; %%  превышено количество ретрансляции данных
result(145) -> 'EGTS_PC_NO_ACK'; %%  нет подтверждения
result(146) -> 'EGTS_PC_OBJ_NFOUND'; %%  объект не найден
result(147) -> 'EGTS_PC_EVNT_NFOUND'; %%  событие не найдено
result(148) -> 'EGTS_PC_SRVC_NFOUND'; %%  сервис не найден
result(149) -> 'EGTS_PC_SRVC_DENIED'; %%  сервис запрещён
result(150) -> 'EGTS_PC_SRVC_UNKN'; %%  неизвестный тип сервиса
result(151) -> 'EGTS_PC_AUTH_DENIED'; %%  авторизация запрещена
result(152) -> 'EGTS_PC_ALREADY_EXISTS'; %%  объект уже существует
result(153) -> 'EGTS_PC_ID_NFOUND'; %%  идентификатор не найден
result(154) -> 'EGTS_PC_INC_DATETIME'; %%  неправильная дата и время
result(155) -> 'EGTS_PC_IO_ERROR'; %%  ошибка ввода/вывода
result(156) -> 'EGTS_PC_NO_RES_AVAIL'; %%  недостаточно ресурсов
result(157) -> 'EGTS_PC_MODULE_FAULT'; %%  внутренний сбой модуля
result(158) -> 'EGTS_PC_MODULE_PWR_FLT'; %%  сбой в работе цепи питания модуля
result(159) -> 'EGTS_PC_MODULE_PROC_FLT'; %%  сбой в работе микроконтроллера модуля
result(160) -> 'EGTS_PC_MODULE_SW_FLT'; %%  сбой в работе программы модуля
result(161) -> 'EGTS_PC_MODULE_FW_FLT'; %%  сбой в работе внутреннего ПО модуля
result(162) -> 'EGTS_PC_MODULE_IO_FLT'; %%  сбой в работе блока ввода/вывода модуля
result(163) -> 'EGTS_PC_MODULE_MEM_FLT'; %%  сбой в работе внутренней памяти модуля
result(164) -> 'EGTS_PC_TEST_FAILED'; %%  тест не пройден
result(_) -> 'unknown_code'. %%  тест не пройден


get_time() ->
  {Mega, Sec, _} = now(),
  Mega * 1000000 + Sec - 63429523200
.
get_time(Time) ->
  Time - 63429523200
.

data_to_bin(Data, _Size) when (Data == null) ->
  {empty, "Data is null."};
data_to_bin(Data, _Size) when (is_list(Data) and (length(Data) == 0)) ->
  {empty, "Data is null."};
data_to_bin(Data, _Size) when (is_integer(Data) and (Data == 0)) ->
  {empty, "Data is null."};
data_to_bin(Data, Size) when (is_integer(Data) and is_integer(Size) and (Size > 0)) ->
  data_to_bin(list_to_binary(integer_to_list(Data)), Size);
data_to_bin(Data, Size) when (is_list(Data) and is_integer(Size) and (Size > 0)) ->
  data_to_bin(list_to_binary(Data), Size);
data_to_bin(Data, Size) when is_binary(Data) ->
  BSize = bit_size(Data),
  Result = if
             Size == BSize ->
               {ok, Data};
             Size > BSize ->
               P = Size - BSize,
               {ok, <<0:P, Data/binary>>};
             true ->
               {error, "Size incorrect: data size exceeds a predetermined data size."}
           end,
  Result;
data_to_bin(_Data, _Size) ->
  {error, "Data or Size incorrect."}
.


to_byte(Data) ->
  if
    is_integer(Data) and (Data >= 0) and (Data =< 255) ->
      {ok, <<Data:?BYTE>>};
    true ->
      {error, "Error invalid data"}
  end.

to_ushort(Data) ->
  if
    is_integer(Data) and (Data >= 0) and (Data =< 65535) ->
      {ok, <<Data:?USHORT>>};
    true ->
      {error, "Error invalid data"}
  end.

to_uint(Data) ->
  if
    is_integer(Data) and (Data >= 0) and (Data =< 4294967295) ->
      {ok, <<Data:?UINT>>};
    true ->
      {error, "Error invalid data"}
  end.

to_ulong(Data) ->
  if
    is_integer(Data) and (Data >= 0) and (Data =< 18446744073709551615) ->
      {ok, <<Data:?ULONG>>};
    true ->
      {error, "Error invalid data"}
  end.

to_short(Data) ->
  if
    is_integer(Data) and (Data >= -32768) and (Data =< 32767) ->
      {ok, <<Data:?SHORT>>};
    true ->
      {error, "Error invalid data"}
  end.

to_int(Data) ->
  if
    is_integer(Data) and (Data >= -2147483648) and (Data =< 2147483647) ->
      {ok, <<Data:?INT>>};
    true ->
      {error, "Error invalid data"}
  end.

to_float(Data) ->
  if
    is_float(Data) ->
      {ok, <<Data:?FLOAT>>};
    true ->
      {error, "Error invalid data"}
  end.

to_double(Data) ->
  if
    is_float(Data) ->
      {ok, <<Data:?DOUBLE>>};
    true ->
      {error, "Error invalid data"}
  end.


%% код временно взят от сюда
%% https://github.com/skuapso/egts/blob/master/src/egts.erl
%%
%%

-define(CRC16Table, {
  16#0000, 16#1021, 16#2042, 16#3063, 16#4084, 16#50A5, 16#60C6, 16#70E7,
  16#8108, 16#9129, 16#A14A, 16#B16B, 16#C18C, 16#D1AD, 16#E1CE, 16#F1EF,
  16#1231, 16#0210, 16#3273, 16#2252, 16#52B5, 16#4294, 16#72F7, 16#62D6,
  16#9339, 16#8318, 16#B37B, 16#A35A, 16#D3BD, 16#C39C, 16#F3FF, 16#E3DE,
  16#2462, 16#3443, 16#0420, 16#1401, 16#64E6, 16#74C7, 16#44A4, 16#5485,
  16#A56A, 16#B54B, 16#8528, 16#9509, 16#E5EE, 16#F5CF, 16#C5AC, 16#D58D,
  16#3653, 16#2672, 16#1611, 16#0630, 16#76D7, 16#66F6, 16#5695, 16#46B4,
  16#B75B, 16#A77A, 16#9719, 16#8738, 16#F7DF, 16#E7FE, 16#D79D, 16#C7BC,
  16#48C4, 16#58E5, 16#6886, 16#78A7, 16#0840, 16#1861, 16#2802, 16#3823,
  16#C9CC, 16#D9ED, 16#E98E, 16#F9AF, 16#8948, 16#9969, 16#A90A, 16#B92B,
  16#5AF5, 16#4AD4, 16#7AB7, 16#6A96, 16#1A71, 16#0A50, 16#3A33, 16#2A12,
  16#DBFD, 16#CBDC, 16#FBBF, 16#EB9E, 16#9B79, 16#8B58, 16#BB3B, 16#AB1A,
  16#6CA6, 16#7C87, 16#4CE4, 16#5CC5, 16#2C22, 16#3C03, 16#0C60, 16#1C41,
  16#EDAE, 16#FD8F, 16#CDEC, 16#DDCD, 16#AD2A, 16#BD0B, 16#8D68, 16#9D49,
  16#7E97, 16#6EB6, 16#5ED5, 16#4EF4, 16#3E13, 16#2E32, 16#1E51, 16#0E70,
  16#FF9F, 16#EFBE, 16#DFDD, 16#CFFC, 16#BF1B, 16#AF3A, 16#9F59, 16#8F78,
  16#9188, 16#81A9, 16#B1CA, 16#A1EB, 16#D10C, 16#C12D, 16#F14E, 16#E16F,
  16#1080, 16#00A1, 16#30C2, 16#20E3, 16#5004, 16#4025, 16#7046, 16#6067,
  16#83B9, 16#9398, 16#A3FB, 16#B3DA, 16#C33D, 16#D31C, 16#E37F, 16#F35E,
  16#02B1, 16#1290, 16#22F3, 16#32D2, 16#4235, 16#5214, 16#6277, 16#7256,
  16#B5EA, 16#A5CB, 16#95A8, 16#8589, 16#F56E, 16#E54F, 16#D52C, 16#C50D,
  16#34E2, 16#24C3, 16#14A0, 16#0481, 16#7466, 16#6447, 16#5424, 16#4405,
  16#A7DB, 16#B7FA, 16#8799, 16#97B8, 16#E75F, 16#F77E, 16#C71D, 16#D73C,
  16#26D3, 16#36F2, 16#0691, 16#16B0, 16#6657, 16#7676, 16#4615, 16#5634,
  16#D94C, 16#C96D, 16#F90E, 16#E92F, 16#99C8, 16#89E9, 16#B98A, 16#A9AB,
  16#5844, 16#4865, 16#7806, 16#6827, 16#18C0, 16#08E1, 16#3882, 16#28A3,
  16#CB7D, 16#DB5C, 16#EB3F, 16#FB1E, 16#8BF9, 16#9BD8, 16#ABBB, 16#BB9A,
  16#4A75, 16#5A54, 16#6A37, 16#7A16, 16#0AF1, 16#1AD0, 16#2AB3, 16#3A92,
  16#FD2E, 16#ED0F, 16#DD6C, 16#CD4D, 16#BDAA, 16#AD8B, 16#9DE8, 16#8DC9,
  16#7C26, 16#6C07, 16#5C64, 16#4C45, 16#3CA2, 16#2C83, 16#1CE0, 16#0CC1,
  16#EF1F, 16#FF3E, 16#CF5D, 16#DF7C, 16#AF9B, 16#BFBA, 16#8FD9, 16#9FF8,
  16#6E17, 16#7E36, 16#4E55, 16#5E74, 16#2E93, 16#3EB2, 16#0ED1, 16#1EF0
}).

-define(CRC8Table, {
  16#00, 16#31, 16#62, 16#53, 16#C4, 16#F5, 16#A6, 16#97,
  16#B9, 16#88, 16#DB, 16#EA, 16#7D, 16#4C, 16#1F, 16#2E,
  16#43, 16#72, 16#21, 16#10, 16#87, 16#B6, 16#E5, 16#D4,
  16#FA, 16#CB, 16#98, 16#A9, 16#3E, 16#0F, 16#5C, 16#6D,
  16#86, 16#B7, 16#E4, 16#D5, 16#42, 16#73, 16#20, 16#11,
  16#3F, 16#0E, 16#5D, 16#6C, 16#FB, 16#CA, 16#99, 16#A8,
  16#C5, 16#F4, 16#A7, 16#96, 16#01, 16#30, 16#63, 16#52,
  16#7C, 16#4D, 16#1E, 16#2F, 16#B8, 16#89, 16#DA, 16#EB,
  16#3D, 16#0C, 16#5F, 16#6E, 16#F9, 16#C8, 16#9B, 16#AA,
  16#84, 16#B5, 16#E6, 16#D7, 16#40, 16#71, 16#22, 16#13,
  16#7E, 16#4F, 16#1C, 16#2D, 16#BA, 16#8B, 16#D8, 16#E9,
  16#C7, 16#F6, 16#A5, 16#94, 16#03, 16#32, 16#61, 16#50,
  16#BB, 16#8A, 16#D9, 16#E8, 16#7F, 16#4E, 16#1D, 16#2C,
  16#02, 16#33, 16#60, 16#51, 16#C6, 16#F7, 16#A4, 16#95,
  16#F8, 16#C9, 16#9A, 16#AB, 16#3C, 16#0D, 16#5E, 16#6F,
  16#41, 16#70, 16#23, 16#12, 16#85, 16#B4, 16#E7, 16#D6,
  16#7A, 16#4B, 16#18, 16#29, 16#BE, 16#8F, 16#DC, 16#ED,
  16#C3, 16#F2, 16#A1, 16#90, 16#07, 16#36, 16#65, 16#54,
  16#39, 16#08, 16#5B, 16#6A, 16#FD, 16#CC, 16#9F, 16#AE,
  16#80, 16#B1, 16#E2, 16#D3, 16#44, 16#75, 16#26, 16#17,
  16#FC, 16#CD, 16#9E, 16#AF, 16#38, 16#09, 16#5A, 16#6B,
  16#45, 16#74, 16#27, 16#16, 16#81, 16#B0, 16#E3, 16#D2,
  16#BF, 16#8E, 16#DD, 16#EC, 16#7B, 16#4A, 16#19, 16#28,
  16#06, 16#37, 16#64, 16#55, 16#C2, 16#F3, 16#A0, 16#91,
  16#47, 16#76, 16#25, 16#14, 16#83, 16#B2, 16#E1, 16#D0,
  16#FE, 16#CF, 16#9C, 16#AD, 16#3A, 16#0B, 16#58, 16#69,
  16#04, 16#35, 16#66, 16#57, 16#C0, 16#F1, 16#A2, 16#93,
  16#BD, 16#8C, 16#DF, 16#EE, 16#79, 16#48, 16#1B, 16#2A,
  16#C1, 16#F0, 16#A3, 16#92, 16#05, 16#34, 16#67, 16#56,
  16#78, 16#49, 16#1A, 16#2B, 16#BC, 16#8D, 16#DE, 16#EF,
  16#82, 16#B3, 16#E0, 16#D1, 16#46, 16#77, 16#24, 16#15,
  16#3B, 16#0A, 16#59, 16#68, 16#FF, 16#CE, 16#9D, 16#AC
}).

check_crc8(CRC, Bin) ->
  case crc8(Bin) of
    CRC -> true;
    _ -> false
  end.

crc8(Data) ->
  crc8(Data, 16#ff).

crc8(<<>>, CRC) ->
  CRC;
crc8(<<B:8, Else/binary>>, CRC) ->
  crc8(Else, element((CRC bxor B) + 1, ?CRC8Table)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Name : CRC-16 CCITT
%%  Poly : 0x1021 x^16 + x^12 + x^5 + 1
%%  Init : 0xFFFF
%%  Revert: false
%%  XorOut: 0x0000
%%  Check : 0x29B1 ("123456789")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
check_crc16(CRC, Bin) ->
  case crc16(Bin, 16#FFFF) of
    CRC -> true;
    _ -> false
  end.

crc16(Data) ->
  crc16(Data, 16#ffff).

crc16(<<>>, CRC) ->
  CRC;
crc16(<<B:8, Else/binary>>, CRC) ->
  crc16(Else, ((CRC bsl 8) band 16#ffff) bxor
    element(((CRC bsr 8) bxor B) + 1, ?CRC16Table)).