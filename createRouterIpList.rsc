#Useless vu qu'on doit de toutes façons update la liste des secrets et que ça ajoute l'ip public et pas celle du tunnel SSTP

:foreach s in=[/interface sstp-server find where disabled=no and running=yes] do={
    :local sstpsrvr $s
    :local clip [/interface sstp-server get $s client-address]
        :if ([/ip firewall address-list find (list=ROUTERLIST && address=$clip)] = "") do={
        /ip firewall address-list add list=ROUTERLIST address=$clip
        };
};
