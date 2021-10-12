:foreach c in=[/ppp secret find where service=sstp] do={
    :local client $c
    :local clip [/ppp secret get $c remote-address]
    :log info $clip

#Plus d'info sur Netwatch => https://wiki.mikrotik.com/wiki/Manual:Tools/Netwatch

    /tool netwatch add host=$clip down-script=hostDown

};