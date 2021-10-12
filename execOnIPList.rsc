#Useless vu que ça utilise les ips public et pas SSTP

:foreach r in=[/ip firewall address-list find where list=ROUTERLIST] do={
    :local router $r
    :local clip [/ip firewall address-list get $r address]
    /system ssh-exec address=$clip user=admin command="/system backup save")        
};