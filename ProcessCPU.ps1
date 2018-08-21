# Log location
$logpath = "C:\Temp\RunningProcesses.txt"

# CPU threshold
$cpuThreshold = 1;

Do {

    $datetime =  Get-Date
    $datetime | Out-File $logpath -Append

    # Get processes
    $ProcessData = (Get-CimInstance win32_process) | select ProcessId,Name,commandline
    $NumberOfProcesses = $ProcessData.Count

    "Total processes running:  $NumberOfProcesses"  | Out-file $logpath -Append

    # Get number of cores
    $CpuCores = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors

    # Iterate over each process
    $output = ForEach($NamedProcess in $ProcessData)
    {
        # Get process name
        $proc = (Get-Process -Id $NamedProcess.ProcessId -ErrorAction SilentlyContinue).Name 

        # Get counter for CPU
        $Samples = (Get-Counter -Counter "\Process($proc*)\% Processor Time" -ErrorAction SilentlyContinue).CounterSamples | where {$_.InstanceName -notin "_total", "idle"} | sort CookedValue -Descending

        # Filter processes where CPU > $cpuThreshold
        $Samples | Select `
        InstanceName,@{Name="CPU%";Expression={[Decimal]::Round(($_.CookedValue / $CpuCores), 2)}} |
        Where 'CPU%' -gt $cpuThreshold |

        # Add PID
        add-member noteproperty PID $NamedProcess.ProcessId -PassThru |

        # Add Command line 
        add-member noteproperty ProcessPath $NamedProcess.commandline -PassThru
}

$output | Format-Table -Wrap -AutoSize | Out-String -Width 4096 | Out-File $logpath -Append
"---------------" | Add-Content $logpath

}

While($true)