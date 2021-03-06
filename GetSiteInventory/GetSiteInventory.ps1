if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) 
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

function GetAllSitesWithModifiedDate($siteUrl)
{
    $webApp = Get-SPWebApplication $siteUrl
   
    $SiteDetail = @();

    foreach ($web in $webApp | Get-SPSite -Limit All | Get-SPWeb -Limit All)
    {     
             $row = new-object PSObject
                Add-member -inputObject $row -memberType NoteProperty -Name "Site Name" -value $web.Name
                Add-member -inputObject $row -memberType NoteProperty -Name "URL" -value $web.Url
                Add-member -inputObject $row -memberType NoteProperty -Name "Last Modified Date" -value $web.LastItemModifiedDate
                $SiteDetail += $row;
    }
    $SiteDetail 
}

function GetRecentlyModifiedSites($siteUrl)
{
    $webApp = Get-SPWebApplication $siteUrl
    $daysInActive = Read-Host "Enter in number of days to check since last modified"
    $date = (Get-Date).AddDays(-$daysInActive).ToString(“MM/dd/yyyy”)

    $SiteDetail = @();

    foreach ($web in $webApp | Get-SPSite -Limit All | Get-SPWeb -Limit All)
    {     
        if ($web.LastItemModifiedDate -ge $date)
        {

             $row = new-object PSObject
                Add-member -inputObject $row -memberType NoteProperty -Name "Site Name" -value $web.Name
                Add-member -inputObject $row -memberType NoteProperty -Name "URL" -value $web.Url
                Add-member -inputObject $row -memberType NoteProperty -Name "Last Modified Date" -value $web.LastItemModifiedDate
                $SiteDetail += $row;
        }
    }
    $SiteDetail 
}

function GetNotModifiedSince($siteUrl)
{
    $webApp = Get-SPWebApplication $siteUrl
    $daysInActive = Read-Host "Enter in number of days to check since last modified"
    $date = (Get-Date).AddDays(-$daysInActive).ToString(“MM/dd/yyyy”)

    $SiteDetail = @();

    foreach ($web in $webApp | Get-SPSite -Limit All | Get-SPWeb -Limit All)
    {     
        if ($web.LastItemModifiedDate -le $date)
        {

             $row = new-object PSObject
                Add-member -inputObject $row -memberType NoteProperty -Name "Site Name" -value $web.Name
                Add-member -inputObject $row -memberType NoteProperty -Name "URL" -value $web.Url
                Add-member -inputObject $row -memberType NoteProperty -Name "Last Modified Date" -value $web.LastItemModifiedDate
                $SiteDetail += $row;
        }
    }
    $SiteDetail 
}

GetAllSitesWithModifiedDate "http://SP2016Farm" | Out-GridView 
GetRecentlyModifiedSites "http://SP2010Farm" | Out-GridView
GetNotModifiedSince "http://SP2013Farm" | Out-GridView 