# egts
Приложение для ретрансляции данных по протоколу EGTS.
Протокол был реализован частично(очень частично) и по мере надобности будет дополняться.

### Котороко об использовании

 >make
 
 >./start.sh
 
 >egts:connect(host,port,dispatcher_id).
 
 >egts:send_pos_data({IMEI,[{Event, Time, Lat, Lon, Speed, Cource, Mv},..]}).
 
 Time это простой timestamp 
