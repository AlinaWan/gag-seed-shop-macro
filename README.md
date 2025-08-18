<div align="center">
  <h1>Grow A Garden Seed Shop Macro by Riri</h1>
</div>

This program automates UI navigation and seed purchasing in the [Roblox](https://corp.roblox.com) game [**Grow A Garden**](https://www.roblox.com/games/126884695634066/Grow-a-Garden).

---

## Installation

1. **Clone the repository**  
```bash
git clone https://github.com/AlinaWan/gag-seed-shop-macro.git
````

2. **Navigate into the project folder**

```bash
cd gag-seed-shop-macro
```

3. **Run the macro**

```powershell
.\main.ahk
```

> [!IMPORTANT]
> Make sure you have [AutoHotkey](https://www.autohotkey.com/) installed on your system before running the script.

---

## How to Use

### 1. Open the Seed Shop GUI
- First, open the seed shop in the game so the macro has the correct interface to interact with.  
- Make sure the seed shop is **freshly opened**:  
  - The list should be **scrolled all the way to the top**.  
  - **No seeds** should have their purchase options opened.  
  - This ensures the macro starts from a predictable state and highlights the correct items.

### 2. Activate UI Navigation
Press the `\` key **once**.  
- This enables UI navigation.  
- **If it doesn’t work**, make sure UI navigation is enabled in your game settings.

### 3. Adjust Object Count (if needed)
- The field labeled **Object Count** determines the number of **unique seeds** expected in the shop.  
- Example: With the Beanstalk event update (which adds Romanesco), there are **26 seeds**.  
- Setting a lower number will limit purchases to that number.  
  - Example: Setting it to `20` will only buy seeds 1–20.  

### 4. Start or Stop the Program
- Press `F6` to **activate** the macro.  
- Press `F6` again to **stop** it.  

---

## How It Works (Technical Explanation)

The macro follows a structured sequence using loops and key presses:

1. **Initial sequence (once per cycle)**  
   - Sends the `\` key **twice** to deactivate and reactivate UI navigation (the program assumes that UI navigation is already enabled to begin with). This highlights the first item in the hotbar.  
   - Waits a short delay (`pressDelay`).  
   - Moves **up 10 times** to highlight the `Sell` teleportation button at the top of the screen.  
   - Sends one `Down` key to highlight the `Close` button in the seed shop GUI.  

2. **Main loop sequence** (repeated `loopCount` times)  
   - Sends `Down` to highlight the next seed object.  
   - Sends `Enter` to open the currently highlighted seed's `purchase` options.  
   - Sends `Down` which highlights the `purchase with Robux` option.  
   - Sends `Left` to switch the highlighter to the `purchase with Sheckles` option.  
   - Waits a small delay (`pressDelay`) between each key.  
   - Presses `Enter` **50 times at 1ms intervals** to rapidly buy the selected seed, without regard to the press delay.  
   - This loop ensures all seeds up to the configured **Object Count** are purchased automatically.  

3. **Return sequence after completion**  
   - Sends `Up` **50 times** to return the highlighter back to the `Sell` teleportation button at the top of the screen.

4. **Loop control**  
   - The macro continuously repeats the cycle while `running` is `true`.  
   - Pressing `F6` toggles `running` to start or stop the macro.  
   - After the loop finishes, the status text updates to indicate the macro is suspended.

> [!NOTE]
> UI navigation keys may differ for some players. The script is simple, so you can easily change the key sequence if needed.

---

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.
