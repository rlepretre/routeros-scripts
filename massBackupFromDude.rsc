:log info "STARTING MASS BACKUP";
:foreach c in=[/ppp secret find where service=sstp] do={

    :local filename;

#Cree le nom du fichier
    :local date [/system clock get date];
    :local time [/system clock get time];
    :local name [/ppp secret get $c name];

    :local months ("jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec");
    :local varHour [:pick $time 0 2];
    :local varMin [:pick $time 3 5];
    :local varSec [:pick $time 6 8];
    :local varMonth [:pick $date 0 3];
    :set varMonth ([ :find $months $varMonth -1 ] + 1);

    :if ($varMonth < 10) do={ :set varMonth ("0" . $varMonth); }

    :local varDay [:pick $date 4 6];
    :local varYear [:pick $date 7 11];
    :set filename ($name. "-" .$varYear."-".$varMonth."-".$varDay."-".$varHour.$varMin.$varSec);

    :log info ("BACKING UP " . $name);

#Recupere l'adresse SSTP du client
    :local address [/ppp secret get $c remote-address]
    :log info $address

    :local flag 0
#Ordonne au client d'effectuer un backup 
#( :do{} on-error={} est l'equivalent d'un try catch)
    :do {
        :local Status ([/system ssh-exec address=$address user=backup command=":put ([/system backup save name=$filename]->\"status\")" as-value]->"output")
        :log info ($name . " BACK UP DONE");
        :log info $Status
    } on-error={ 
        :set flag 1
        :log info ("BACKUP FAILED FOR " . $name)
#       TO DO remplir les infos du serveur smtp et destinataire
#        /tool e-mail send to=destination_mail@mail.com \
#            server=[:resolve smtp.server.com] port=25 start-tls=no \
#            user="" password=RCqhNsya7s8YsM5fcmK8LypNifyb  from="thedude@uniwan.be" \
#            subject="Backup failed for $name" body="Backup failed for $name (at $address) on $date"
        }




#Ordonne au client d'effectuer un backup config

#    :log info "GENERATING RSC";
#    :global rsc $filename;
#    /export file=$rsc;

#Lance le download du backup en SFTP
    :if ($flag = 0) do {
            :log info "FECTHING BACK UP";
    :local url;
    :set url ("sftp://".$address."/".$filename.".backup");
    :log info $url
    :do {
        /tool fetch url="$url" user=backup password=RCqhNsya7s8YsM5fcmK8LypNifyb 
        :log info "BACK UP FETCHED";
    } on-error={ 
        :log info ("BACKUP FETCH FAILED FOR " . $name)
#       TO DO remplir les infos du serveur smtp et destinataire
#        /tool e-mail send to=destination_mail@mail.com \
#            server=[:resolve smtp.server.com] port=25 start-tls=no \
#            user="" password=RCqhNsya7s8YsM5fcmK8LypNifyb  from="thedude@uniwan.be" \
#            subject="Backup failed for $name" body="Backup fetch failed for $name (at $address) on $date"
        }
    }


#Lance le download du de la config en SFTP
    :log info "FECTHING CONFIG";
    :local url;
    :set url ("sftp://".$address."/".$filename.".rsc");
    :do {
        /tool fetch url="$url" user=backup password=RCqhNsya7s8YsM5fcmK8LypNifyb 
        :log info "CONFIG FETCHED";
    } on-error={ :log info ("CONFIG FETCH FAILED FOR " . $name)}

};
:log info "MASS BACKUP FINISHED";