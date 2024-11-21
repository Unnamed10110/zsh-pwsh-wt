import tkinter as tk
from tkinter import ttk
import ctypes
from screeninfo import get_monitors
import threading
import time

# Structure for RECT, used for getting taskbar height
class RECT(ctypes.Structure):
    _fields_ = [("left", ctypes.c_long), ("top", ctypes.c_long), 
                ("right", ctypes.c_long), ("bottom", ctypes.c_long)]


class ResizableTextWindow:
    def __init__(self, text, screen_width, screen_height, taskbar_height, x_position, y_position, monitor_index):
        self.text = text
        self.monitor_index = monitor_index
        self.font_name = "Arial"
        self.font_size = 12

        # Initialize the Tkinter root window
        self.root = tk.Tk()
        self.root.title(f"Desktop Overlay Window - Monitor {monitor_index + 1}")
        self.root.config(bg="black")

        # Calculate window width (25% of screen width)
        self.custom_width = int(screen_width * 0.25)

        # Get window decorations height (title bar, borders, etc.)
        self.root.geometry(f"{self.custom_width}x100+{x_position}+{y_position}")
        self.root.update_idletasks()
        decoration_height = self.root.winfo_rooty() - self.root.winfo_y()

        # Calculate usable height based on taskbar height
        usable_height = screen_height - taskbar_height - decoration_height
        self.root.geometry(f"{self.custom_width}x{usable_height}+{x_position}+{y_position}")

        # Dropdown list (ComboBox) for monitor selection
        self.monitor_label = tk.Label(self.root, text="Current Monitor", fg="white", bg="black")
        self.monitor_label.pack(side="top", pady=5)

        self.monitor_combobox = ttk.Combobox(self.root, state="readonly")
        self.monitor_combobox.pack(side="top", fill="x", padx=10)

        # Populate ComboBox with monitor names
        self.update_monitors()
        self.monitor_combobox.current(self.monitor_index)

        # Bind the combobox selection event to a handler
        self.monitor_combobox.bind("<<ComboboxSelected>>", self.on_monitor_select)

        # Frame for the content (sliders, text box, etc.)
        self.content_frame = tk.Frame(self.root, bg="black")
        self.content_frame.pack(side="top", fill="both", expand=True)

        # Text box for displaying text
        self.textbox = tk.Text(
            self.content_frame,
            wrap="word",
            font=(self.font_name, self.font_size, "bold"),
            fg="white",
            bg="black",
            padx=20,
            pady=20,
            bd=0,
            state=tk.NORMAL
        )
        self.textbox.pack(side="top", fill="both", expand=True, padx=10, pady=10)
        self.textbox.insert("1.0", self.text)
        self.textbox.config(state=tk.DISABLED)

        # Buttons at the bottom
        self.button_frame = tk.Frame(self.root, bg="black", height=60)
        self.button_frame.pack(side="bottom", fill="x", pady=10)

        edit_button = tk.Button(
            self.button_frame,
            text="Edit Text",
            command=self.edit_text,
            font=("Arial", 10),
            fg="white",
            bg="green",
            relief="raised",
            height=1,
            width=15
        )
        edit_button.pack(side="left", padx=10)

        refresh_button = tk.Button(
            self.button_frame,
            text="Refresh",
            command=self.refresh_label,
            font=("Arial", 10),
            fg="white",
            bg="blue",
            relief="raised",
            height=1,
            width=15
        )
        refresh_button.pack(side="left", padx=10)

        close_button = tk.Button(
            self.button_frame,
            text="Close",
            command=self.close_window,
            font=("Arial", 10),
            fg="white",
            bg="red",
            relief="raised",
            height=1,
            width=15
        )
        close_button.pack(side="left", padx=10)

        # Allow resizing
        self.root.resizable(True, True)

        # Start the monitor check thread to detect window movement
        self.monitor_check_thread = threading.Thread(target=self.monitor_check_loop, daemon=True)
        self.monitor_check_thread.start()

    def update_monitors(self):
        """Update the monitor list dynamically."""
        self.monitors = get_monitors()
        self.monitor_combobox["values"] = [f"Monitor {i+1} - {m.x}, {m.y}" for i, m in enumerate(self.monitors)]

    def on_monitor_select(self, event):
        """Handle monitor selection from the combobox."""
        selected_index = self.monitor_combobox.current()
        selected_monitor = self.monitors[selected_index]

        screen_width = selected_monitor.width
        screen_height = selected_monitor.height
        x_position = selected_monitor.x
        y_position = selected_monitor.y
        taskbar_height = get_taskbar_height_for_monitor(x_position, y_position)

        # Move the window to the selected monitor
        self.update_window_position(screen_width, screen_height, taskbar_height, x_position, y_position)

    def update_window_position(self, screen_width, screen_height, taskbar_height, x_position, y_position):
        """Update the window size and position when a monitor is selected."""
        decoration_height = self.root.winfo_rooty() - self.root.winfo_y()
        usable_height = screen_height - taskbar_height - decoration_height
        self.root.geometry(f"{self.custom_width}x{usable_height}+{x_position}+{y_position}")

    def monitor_check_loop(self):
        """Periodically check if the window has moved to a different monitor and update the dropdown."""
        while True:
            time.sleep(1)  # Check every second
            current_x = self.root.winfo_x()
            current_y = self.root.winfo_y()

            # Check which monitor the window is currently on
            for i, monitor in enumerate(self.monitors):
                if monitor.x <= current_x < monitor.x + monitor.width and monitor.y <= current_y < monitor.y + monitor.height:
                    if self.monitor_index != i:
                        self.monitor_index = i
                        # Update the dropdown to reflect the current monitor
                        self.monitor_combobox.current(self.monitor_index)
                    break

    def close_window(self):
        """Close only the current window."""
        self.root.destroy()

    def edit_text(self):
        """Edit the displayed text in a pop-up window."""
        edit_window = tk.Toplevel(self.root)
        edit_window.title("Edit Text")
        screen_width = self.root.winfo_screenwidth()
        screen_height = self.root.winfo_screenheight()
        window_width = 400
        window_height = 200
        position_right = int(screen_width / 2 - window_width / 2)
        position_down = int(screen_height / 2 - window_height / 2)
        edit_window.geometry(f"{window_width}x{window_height}+{position_right}+{position_down}")

        button_frame = tk.Frame(edit_window)
        button_frame.pack(side="top", pady=10, fill="x")

        # Read the content from the file
        try:
            with open("content.txt", "r", encoding="utf-8") as file:
                file_content = file.read()
        except FileNotFoundError:
            with open("content.txt", "w", encoding="utf-8",errors="ignore") as file:
                file.write("""
-> FILE JUST CREATED! ..\n
This is a text with Arial bold white font. 
It will word-wrap to fit inside the window as the window resizes.
alt + 96   = \`

alt + 0180 = \´

alt + 39   = \'

alt + 168  = \¿

alt + 47   = \/

alt + 92   = \\

alt + 173  = \¡

alt + 179  = \│

alt + 60   = \<

alt + 62   = \>

alt + 126  = \~

alt + 0176 = \°

alt + 39 = \'

            """)
            file_content = open('content.txt', 'r', encoding='utf-8-sig', errors='ignore').read()

        # Text input box
        text_input = tk.Text(edit_window, wrap="word")
        text_input.insert("1.0", file_content)  # Insert content of the file
        text_input.pack(expand=True, fill="both")

        def save_text():
            new_text = text_input.get("1.0", "end-1c")
            self.textbox.config(state=tk.NORMAL)
            self.textbox.delete("1.0", "end")
            self.textbox.insert("1.0", new_text)
            self.text = new_text
            self.textbox.config(state=tk.DISABLED)
            
            # Save the edited text back to 'content.txt'
            with open("content.txt", "w", encoding="utf-8") as file:
                file.write(new_text)

            edit_window.destroy()

        save_button = tk.Button(
            button_frame, text="Save", command=save_text, font=("Arial", 10), fg="white", bg="green", relief="raised"
        )
        save_button.pack(side="right", padx=10)

        cancel_button = tk.Button(
            button_frame, text="Cancel", command=edit_window.destroy, font=("Arial", 10), fg="white", bg="red", relief="raised"
        )
        cancel_button.pack(side="left", padx=10)

        edit_window.mainloop()

    def refresh_label(self):
        """Refresh the label with the current text."""
        new_text = open('content.txt', 'r', encoding='utf-8-sig', errors='ignore').read()
        self.textbox.config(state=tk.NORMAL)
        self.textbox.delete("1.0", "end")
        self.textbox.insert("1.0", new_text)
        self.textbox.config(state=tk.DISABLED)
        self.text = new_text
        self.textbox.update_idletasks()

    def run(self):
        """Run the tkinter event loop."""
        self.root.mainloop()


def get_taskbar_height_for_monitor(x_position, y_position):
    """Get the height of the taskbar for a specific monitor."""
    taskbar_hwnd = ctypes.windll.user32.FindWindowW("Shell_TrayWnd", None)
    rect = RECT()
    ctypes.windll.user32.GetWindowRect(taskbar_hwnd, ctypes.byref(rect))
    return rect.bottom - rect.top


def create_and_run_windows(text):
    """Create and run a window only on the second monitor if multiple monitors exist."""
    monitors = get_monitors()
    if len(monitors) > 1:  # Check if there's more than one monitor
        monitor = monitors[1]  # Select the second monitor
        screen_width = monitor.width
        screen_height = monitor.height
        x_position = monitor.x
        y_position = monitor.y
        taskbar_height = get_taskbar_height_for_monitor(x_position, y_position)
        window = ResizableTextWindow(text, screen_width, screen_height, taskbar_height, x_position, y_position, 1)
        window.run()
    else:  # Fall back to the primary monitor if only one exists
        monitor = monitors[0]
        screen_width = monitor.width
        screen_height = monitor.height
        x_position = monitor.x
        y_position = monitor.y
        taskbar_height = get_taskbar_height_for_monitor(x_position, y_position)
        window = ResizableTextWindow(text, screen_width, screen_height, taskbar_height, x_position, y_position, 0)
        window.run()


if __name__ == "__main__":
    try:
        text = open('content.txt', 'r', encoding='utf-8-sig', errors='ignore').read()
    except FileNotFoundError:
        text = (
            "This is a text with Arial bold white font. "
            "It will word-wrap to fit inside the window as the window resizes."
        )
        with open("content.txt", "w", encoding="utf-8",errors="ignore") as file:
            file.write("""
-> FILE JUST CREATED! ..\n
DEFAULT TEXT!

alt + 96   = `

alt + 0180 = ´

alt + 39   = '

alt + 168  = ¿

alt + 47   = /

alt + 92   = \\

alt + 173  = ¡

alt + 124  = |

alt + 60   = <

alt + 62   = >

alt + 126  = ~

alt + 0176 = °

alt + 39 = '

            """)
        text = open('content.txt', 'r', encoding='utf-8-sig', errors='ignore').read()

    create_and_run_windows(text)
