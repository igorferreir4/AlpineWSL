# to other machines (besides the Windows machine running WSL2 running the service) on
# the local network.  It can be set up to run on startup of Windows through Task Scheduler Triggers,
# as described here: https://github.com/microsoft/WSL/issues/4150
# This script must be run with administrator priveledges.

$lines_with_IP_addresses = bash.exe -c "ip addr | grep -Ee 'inet.*eth0'"
$regex = [regex] "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"
$potential_IP_addresses = $regex.Matches($lines_with_IP_addresses) | % { $_.value }

if ( $potential_IP_addresses ) {
  $wsl2_IP_address = $potential_IP_addresses[0];
  echo "Using WSL2 IP Address of $wsl2_IP_address
";
}
else {
  echo "The Script Exited, the IP address of WSL 2 cannot be found";
  exit;
}

#[Ports]

#All the ports you want to forward separated by comma
$ports = @(80, 443, 27001, 8096);


#[Static ip]
#You can change the addr to your ip config to listen to a specific address
$addr = '0.0.0.0';
$ports_as_string = $ports -join ",";


#Remove Firewall Exception Rules
iex "Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' ";

#adding Exception Rules for inbound and outbound Rules
echo "Opening Ports: $ports";
iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $ports_as_string -Action Allow -Protocol TCP";
iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $ports_as_string -Action Allow -Protocol TCP";

foreach ($port in $ports) {
  echo "deleting v4tov4 rule with listenport=$port listenaddress=$addr";
  iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr";
  echo "adding v4tov4 rule with listenport=$port listenaddress=$addr connectport=$port connectaddress=$wsl2_IP_address";
  iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$port connectaddress=$wsl2_IP_address";
}


$windows_ipv4 = (Get-NetIPAddress | Where-Object { $_.AddressState -eq "Preferred" -and $_.PrefixOrigin -eq "DHCP" }).IPAddress
echo "Use $windows_ipv4 & port # to connect to site from other devices on local network."

pause