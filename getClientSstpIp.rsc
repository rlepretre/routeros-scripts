:global getCustomerSstpIp do={
    :foreach c in=[/ppp secret find where name~"$customer"] do={
        :local ip [/ppp secret get $c remote-address];
        :put $ip
    }
}
