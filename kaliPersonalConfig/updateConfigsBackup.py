import os, tkinter.messagebox

def execute_zsh_command():

    # Execute the command
    result = os.system(
        """
        wsl zsh -c "cd ~ && ls -a | grep ".zshrc" | xargs cp -t /mnt/d/repos/zsh-pwsh-wt/kaliPersonalConfig/debian/Home && apt list --installed | cut -d/ -f1 > /mnt/d/repos/zsh-pwsh-wt/kaliPersonalConfig/debian/installed_packages.txt&&echo "Configurations from zsh UPDATED!\n"Press any key to continue..."; read -k1 -s"
        
        """
                
    )

    # Print the result
    if result == 0:
        print("Command executed successfully.")
        tkinter.messagebox.showwarning(title="Succes", message="""Configurations from zsh UPDATED!.""")
    else:
        tkinter.messagebox.showerror(title="Fail", message="""Command failed with exit code {result}""")
        print(f"Command failed with exit code {result}")

if __name__ == "__main__":
    execute_zsh_command()
