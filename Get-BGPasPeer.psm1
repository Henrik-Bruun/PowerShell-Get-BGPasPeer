Function Get-BGPasPeer {
    <#
    .SYNOPSIS
        Extracts BGP AS Peer, Announcement, Country, Registry, date. Using an external API.
    .DESCRIPTION
        This function extracts BGP information
        using https://www.team-cymru.com/ip-asn-mapping
    .PARAMETER ip
        The IP address to look up.
    .PARAMETER DNSserver
        The DNS server to use for the lookup.
    .EXAMPLE
        Get-BGPasPeer -ip '92.246.24.228'
    .EXAMPLE
        Get-BGPasPeer -ip '5.206.192.0'
    .EXAMPLE
        foreach ($line in ((Get-BGPasPeer -ip '5.206.192.0').asn -split ' ')){Write-Host "DNS peer $line"}      
    .EXAMPLE
        Get-BGPasPeer -ip '92.246.24.228' -DNSserver 1.1.1.1
    .NOTES
        Author: Henrik Bruun  Github.com @Henrik-Bruun
        Version: 1.0 2023 December.
        Version: 0.9 2023 January - Not public.
    #>

    Param (
        [String]$ip = '92.246.24.228',
        [String]$DNSserver = '1.1.1.1'
    )

    $HopRev = $ip.Split(".")[3] + "." + $ip.Split(".")[2] + "." + $ip.Split(".")[1] + "." + $ip.Split(".")[0]
    $WHOIS = ".peer.asn.cymru.com"
    $lookup = Resolve-DnsName -Server $DNSserver -Type TXT -Name $HopRev$WHOIS -ErrorAction SilentlyContinue
    $PeerAS = $lookup.Strings.Split('|')[0].Trim()
    $Announcement = $lookup.Strings.Split('|')[1].Trim()
    $ASNCountryCode = $lookup.Strings.Split('|')[2].Trim()
    $ASNRegistry = $lookup.Strings.Split('|')[3].Trim()
    $ASNAllocationDate = $lookup.Strings.Split('|')[4].Trim()

    $data = [PSCustomObject]@{
        asn = $PeerAS
        announcement = $Announcement
        asnCountryCode = $ASNCountryCode
        asnRegistry = $ASNRegistry
        asnAllocationDate = $ASNAllocationDate
    }

    $data
}
