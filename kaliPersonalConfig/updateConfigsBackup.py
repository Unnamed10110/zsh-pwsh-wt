import os, tkinter.messagebox

def execute_zsh_command():

    # Execute the command
    result2= os.system(
        """
         pwsh -Command "cd c:/ && copy c:/users/$($env:username)/Documents/PowerShell/Microsoft.PowerShell_profile.ps1 D:/repos/zsh-pwsh-wt/windows-pws-posh/PROFILE.txt && copy c:/users/$($env:username)/Documents/PowerShell/Microsoft.PowerShell_profile.ps1 D:/repos/zsh-pwsh-wt/windows-pws-posh"                 
                       
        """)
    result = os.system(
        """
        wsl zsh -c "cd ~ && ls -a | grep ".zshrc" | xargs cp -t /mnt/d/repos/zsh-pwsh-wt/kaliPersonalConfig/debian/Home && apt list --installed | cut -d/ -f1 > /mnt/d/repos/zsh-pwsh-wt/kaliPersonalConfig/debian/installed_packages.txt && cp ~/zsh-pwsh-wt/kaliPersonalConfig/debian/installed_packages /mnt/d/repos/zsh-pwsh-wt/kaliPersonalConfig/debian/ &&echo "Configurations from zsh UPDATED!\n"Press any key to continue..."; read -k1 -s"
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
