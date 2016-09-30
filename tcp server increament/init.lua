IPADR = "192.168.1.120" 
IPROUTER = "192.168.1.1"
wifi.setmode(wifi.STATION)
wifi.sta.setip({ip=IPADR,netmask="255.255.255.0",gateway=IPROUTER})


srv=net.createServer(net.TCP)
local count = 0
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        count = count + 1;
        print(count);
        local buf = "";
        buf = buf.."<h2> ESP8266 Web Server</h2>";
        buf = buf.."<h1> Total Visitors:";
        buf = buf..count;
        buf = buf.."</h1>";
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)