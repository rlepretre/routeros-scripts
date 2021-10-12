#Ordonne à tous les routers connectés en SSTP de faire un backup
:foreach c in=[/ppp secret find where service=sstp] do={
    :local client $c
    :local clip [/ppp secret get $c remote-address]
    :log info $clip
    :local Status ([/system ssh-exec address=$clip user=admin command=":put ([/system backup save]->\"status\")" as-value]->"output")
    :log info $Status
};


#Ordonne à tous les routers connectés en SSTP de faire un backup et l'uploader sur le CHR The Dude dans un folder => crash si un des routers est offline
:foreach c in=[/ppp secret find where service=sstp] do={
    :log info hello2
    :local datetime [/system clock get date]
    :local client $c
    :log info hello2
    :local clip [/ppp secret get $c remote-address]
    :log info $clip
    :local Status ([/system ssh-exec address=$clip user=admin command=":put ([/system backup save name=$datetime]->\"status\")" as-value]->"output")
    :log info $Status
    :local Status2 ([/system ssh-exec address=$clip user=admin command=":put ([/tool fetch upload=yes url="sftp://10.13.0.1/$datetime.backup" src-path="/$c_$datetime.backup" user="rle" password="Uniwan@MikroTik!2021"]->\"status\")" as-value]->"output")
    :log info $Status2
};