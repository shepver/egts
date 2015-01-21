%%%-------------------------------------------------------------------
%%% @author shepver
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Янв. 2015 13:38
%%%-------------------------------------------------------------------
-author("shepver").


-record(transport, {prv, skid,
  prf, rte, ena, cmp, pr
%%     ,HL,
%%     HE,
%%     FDL,
%%     PID,
%%     PT,
%%     PRA,
%%     RCA,
%%     TTL,
%%     HCS,
%%     SFRD,
%%     SFRCS
}).

-record(egts_pt_appdata, {record_list = [], response = null}).
-record(egts_pt_response, {rpid, pr, record_list = []}).

-record(service_record, {rl, rn, ssod, rsod, grp, rpp, tmfe, evfe, obfe, oid, evid, tm, sst, rst, rd}).
-record(service_sub_record, {srt, srl, srd}).


%%  EGTS_AUTH_SERVICE
-record(auth, {tid = null, imei = null, imsi = null, hdid = null, msisdn = null, mcc = 1, mnc = 1, lngc = "rus", bs = 1024}).
-record(auth_disp, {dt = null, did = null, dscr = null}).

%%  EGTS_TELEDATA_SERVICE
-record(pos_data, {ntm, lat, long, alth, lons, lans, mv = 0, bb, cs, fix, vld, dirh, alts, spd, dir, odm, din, src = 1, alt, srcd}).