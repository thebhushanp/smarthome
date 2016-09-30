-- One time ESP Setup --
wifi.setmode(wifi.STATION)
wifi.sta.config ( "R.J.D" , "04078454" ) 
print(wifi.sta.getip())

-- Constants
light = 5
fan = 6
gpio.mode(light, gpio.OUTPUT)
gpio.mode(fan, gpio.OUTPUT) 

Broker="192.168.1.109"

 function reconnect()
    print ("Waiting for Wifi")
    if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil then 
        print ("Wifi Up!")
        tmr.stop(1) 
        m:connect(Broker, 1883, 0, function(conn) 
            print("Mqtt Connected to:" .. Broker) 
            mqtt_sub() --run the subscripion function 
        end)
    end
 end
 
 m = mqtt.Client("nodemcu", 180) 
 --m:lwt("/lwt", "ESP8266", 0, 0) 
 m:on("offline", function(con) 
    print ("Mqtt Reconnecting...") 
    tmr.alarm(1, 80000, 1, function() 
    reconnect()
    end) 
 end)
 
 -- on publish message receive event 
-- m:on("message", function(conn, topic, data) 
--    print("Recieved:" .. topic .. ":" .. data) 
-- end)

 m:on("message", function(client, topic, data) 
  print(topic .. ":" ) 
  if topic == '/room/bhushan/light' then
    if data == 'on' then
        print('kara re chalu light')
        gpio.write(light, gpio.HIGH);
    end
    if data == 'off' then
        print('kara re band light')
        gpio.write(light, gpio.LOW);
    end
  end
  
  if topic == '/room/bhushan/fan' then
    if data == 'on' then
        print('kara re chalu fan')
        gpio.write(fan, gpio.HIGH);
    end
    if data == 'off' then
        print('kara re band fan')
        gpio.write(fan, gpio.LOW);
    end
  end
  
  if data ~= nil then
    print(data) 
  end
end)
 
 
 function mqtt_sub() 
    m:subscribe("/room/bhushan/#",0, function(conn) 
    print("Mqtt Subscribed to Raspberry Pi") 
    end) 
 end 
 
 tmr.alarm(0, 1000, 1, function() 
    print ("Connecting to Wifi... ")
    if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil then 
        print ("Wifi connected")
        tmr.stop(0) 
        m:connect(Broker, 1883, 0, function(conn) 
            print("Mqtt Connected to:" .. Broker) 
            mqtt_sub() --run the subscription function 
        end) 
    end
 end)
