import os, tkinter.messagebox

def execute_zsh_command():

    # Execute the command
    result2= os.system(
        """
         pwsh -Command "pwsh -command Get-Content "C:/Users/$($env:username)/AppData/Roaming/Microsoft/Windows/PowerShell/PSReadLine/ConsoleHost_history.txt" | Select-Object -Unique | ForEach-Object {$_} | Set-Content "C:/Users/$($env:username)/AppData/Roaming/Microsoft/Windows/PowerShell/PSReadLine/ConsoleHost_history.txt" && cd c:/ && copy C:/Users/$($env:username)/Documents/PowerShell/Microsoft.PowerShell_profile.ps1 D:/repos/zsh-pwsh-wt/windows-pws-posh/PROFILE.txt && cp C:/Users/$($env:username)/AppData/Roaming/Microsoft/Windows/PowerShell/PSReadLine/ConsoleHost_history.txt D:/repos/zsh-pwsh-wt/windows-pws-posh/ConsoleHost_history.txt && copy C:/Users/$($env:username)/Documents/PowerShell/Microsoft.PowerShell_profile.ps1 D:/repos/zsh-pwsh-wt/windows-pws-posh/Microsoft.PowerShell_profile.ps1 && cd d:/repos/zsh-pwsh-wt && winget list >> installed_programs.txt"                 
                       
        """)
    result = os.system(
        """
        wsl.exe zsh -c "cd ~ && ls -a | grep ".zshrc" | xargs cp -t /mnt/d/repos/zsh-pwsh-wt/kaliPersonalConfig/debian/Home && apt list --installed | cut -d/ -f1 > /mnt/d/repos/zsh-pwsh-wt/kaliPersonalConfig/debian/installed_packages.txt && cp /mnt/d/repos/zsh-pwsh-wt/kaliPersonalConfig/configZSHINIT.sh ."
        """
                
    )

    # Print the result
    if result == 0 and result2==0:
        print("Command executed successfully.")
        tkinter.messagebox.showwarning(title="Succes", message="""Configurations FOR ZSH AND KALI AND PWSH UPDATED!.""")
    else:
        tkinter.messagebox.showerror(title="Fail", message="""Command failed with exit code {result}""")
        print(f"Command failed with exit code {result}")

if __name__ == "__main__":
    execute_zsh_command()
