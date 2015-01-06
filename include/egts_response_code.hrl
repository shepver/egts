%%%-------------------------------------------------------------------
%%% @author shepver
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Янв. 2015 1:22
%%%-------------------------------------------------------------------
-author("shepver").

-define(EGTS_PC_OK, 0).  %%	успешно обработано
-define(EGTS_PC_IN_PROGRESS, 1).  %%	в процессе обработки
-define(EGTS_PC_UNS_PROTOCOL, 128).  %%	неподдерживаемый протокол
-define(EGTS_PC_DECRYPT_ERROR, 129).  %%	ошибка декодирования
-define(EGTS_PC_PROC_DENIED, 130).  %%	обработка запрещена
-define(EGTS_PC_INC_HEADERFORM, 131).  %%	неверный формат заголовка
-define(EGTS_PC_INC_DATAFORM, 132).  %%	неверный формат данных
-define(EGTS_PC_UNS_TYPE, 133).  %%	неподдерживаемый тип
-define(EGTS_PC_NOTEN_PARAMS, 134).  %%	неверное количество параметров
-define(EGTS_PC_DBL_PROC, 135).  %%	попытка повторной обработки
-define(EGTS_PC_PROC_SRC_DENIED, 136).  %%	обработка данных от источника запрещена
-define(EGTS_PC_HEADERCRC_ERROR, 137).  %%	ошибка контрольной суммы заголовка
-define(EGTS_PC_DATACRC_ERROR, 138).  %%	ошибка контрольной суммы данных
-define(EGTS_PC_INVDATALEN, 139).  %%	некорректная длина данных
-define(EGTS_PC_ROUTE_NFOUND, 140).  %%	маршрут не найден
-define(EGTS_PC_ROUTE_CLOSED, 141).  %%	маршрут закрыт
-define(EGTS_PC_ROUTE_DENIED, 142).  %%	маршрутизация запрещена
-define(EGTS_PC_INVADDR, 143).  %%	неверный адрес
-define(EGTS_PC_TTLEXPIRED, 144).  %%	превышено количество ретрансляции данных
-define(EGTS_PC_NO_ACK, 145).  %%	нет подтверждения
-define(EGTS_PC_OBJ_NFOUND, 146).  %%	объект не найден
-define(EGTS_PC_EVNT_NFOUND, 147).  %%	событие не найдено
-define(EGTS_PC_SRVC_NFOUND, 148).  %%	сервис не найден
-define(EGTS_PC_SRVC_DENIED, 149).  %%	сервис запрещён
-define(EGTS_PC_SRVC_UNKN, 150).  %%	неизвестный тип сервиса
-define(EGTS_PC_AUTH_DENIED, 151).  %%	авторизация запрещена
-define(EGTS_PC_ALREADY_EXISTS, 152).  %%	объект уже существует
-define(EGTS_PC_ID_NFOUND, 153).  %%	идентификатор не найден
-define(EGTS_PC_INC_DATETIME, 154).  %%	неправильная дата и время
-define(EGTS_PC_IO_ERROR, 155).  %%	ошибка ввода/вывода
-define(EGTS_PC_NO_RES_AVAIL, 156).  %%	недостаточно ресурсов
-define(EGTS_PC_MODULE_FAULT, 157).  %%	внутренний сбой модуля
-define(EGTS_PC_MODULE_PWR_FLT, 158).  %%	сбой в работе цепи питания модуля
-define(EGTS_PC_MODULE_PROC_FLT, 159).  %%	сбой в работе микроконтроллера модуля
-define(EGTS_PC_MODULE_SW_FLT, 160).  %%	сбой в работе программы модуля
-define(EGTS_PC_MODULE_FW_FLT, 161).  %%	сбой в работе внутреннего ПО модуля
-define(EGTS_PC_MODULE_IO_FLT, 162).  %%	сбой в работе блока ввода/вывода модуля
-define(EGTS_PC_MODULE_MEM_FLT, 163).  %%	сбой в работе внутренней памяти модуля
-define(EGTS_PC_TEST_FAILED, 164).  %%	тест не пройден
