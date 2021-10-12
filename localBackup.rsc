#Crée un backup local avec le nom du fichier + la date puis l'upload sur le CHR uniwan-dude
#/!\ /!\ /!\ Mot de passe en clair et impossible de créer des dossiers


:log info "STARTING BACKUP";

:local filename;

:local date [/system clock get date];
:local time [/system clock get time];
:local name [/system identity get name];

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



/system backup save name=$filename;

:log info "DELAY 3S"
:delay 3s;

:log info "GENERATING RSC";
:global rsc $filename;

/export file=$rsc;

:log info "BACKUP FINISHED";

:local url;
:local src;

:set url ("sftp://10.13.0.1/".$filename.".backup");
:set src ("/".$filename.".backup")
:log info $url

:log info "UPLOADING TO SERVER";
/tool fetch upload=yes url="$url" src-path="$src"  user="rle" password="Uniwan@MikroTik!2021"
:log info "BACKUP UPLOADED";