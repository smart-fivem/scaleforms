# Multiplayer Chat Resource

> [!NOTE]
> The default `MULTIPLAYER_CHAT` scaleform has a known bug with message scrolling. Messages may appear in the wrong order when scrolling through chat history. This is a limitation of the scaleform itself and not an issue with this resource implementation.

## Features

- Scaleform-based chat interface
- Multiple chat scopes (All, Team, Friends, Crew)
- Configurable chat visibility duration
- Player name and color customization
- Chat history navigation
- Input handling with NUI integration

## Technical Details

### API Reference

#### MultiplayerChat Class

The MultiplayerChat class provides a complete interface for managing the chat system. Here are the available methods:

##### Core Methods

- `New(options)`
  - Parameters: `options` (table) - Optional configuration table with the following fields:
    - `sfName` (string) - Scaleform movie name (default: 'MULTIPLAYER_CHAT')
    - `hideAfter` (number) - Auto-hide delay in milliseconds (default: 10000)
    - `playerName` (string) - Default player name (default: 'Unknown')
    - `playerColor` (number) - Default player color (default: 0)
  - Returns: A new MultiplayerChat instance
  - Description: Initializes a new chat instance with the specified or default options.
  - Note: All options except `sfName` can be modified after initialization.

- `Load()`
  - Description: Loads the required scaleform movie for the chat interface. Must be called before using other methods.

- `IsLoaded()`
  - Returns: `boolean` - true if the scaleform is loaded, false otherwise
  - Description: Verifies if the scaleform movie has been successfully loaded

- `Reset()`
  - Description: Resets the chat interface to its initial state. Only works when the scaleform is loaded.

- `Dispose()`
  - Description: Properly unloads the scaleform movie and cleans up any resources. Should be called when the chat is no longer needed.

##### Display Methods

- `Show()`
  - Description: Makes the chat interface visible on screen and sets focus

- `Hide()`
  - Description: Hides the chat interface from view and clears focus

- `IsShowing()`
  - Returns: `boolean` - true if chat is visible, false otherwise
  - Description: Returns the current visibility state of the chat interface

- `Update()`
  - Description: Should be called in your game loop to handle chat visibility timing and state updates

##### Input Methods

- `StartTyping(scopeText)`
  - Parameters: `scopeText` (string) - The scope indicator text (e.g., "All", "Team", etc.)
  - Description: Opens the chat input interface with the specified scope indicator

- `EndTyping(send)`
  - Parameters: `send` (boolean) - Whether to send the current message
  - Description: Closes the chat input and optionally sends the current message

- `IsTyping()`
  - Returns: `boolean` - true if chat input is active, false otherwise
  - Description: Returns the current typing state of the chat interface

- `AddText(text)`
  - Parameters: `text` (string) - The text to add to the current input
  - Description: Appends text to the current chat input

- `DeleteText()`
  - Description: Removes the last character from the current chat input

- `ClearText()`
  - Description: Clears all text from the current chat input

##### Message Methods

- `AddMessage(playerName, message, scopeText, playerColor)`
  - Parameters:
    - `playerName` (string) - Name of the player sending the message
    - `message` (string) - The message content
    - `scopeText` (string) - The scope indicator text
    - `playerColor` (number) - Color code for the player's name
  - Description: Adds a new message to the chat history with the specified formatting

- `PageUp()`
  - Description: Navigates to previous messages in the chat history

- `PageDown()`
  - Description: Navigates to newer messages in the chat history

##### Mode Methods

- `SetMode(mode)`
  - Parameters: `mode` (number) - Either `MultiplayerChat.MODE_LOBBY` (0) or `MultiplayerChat.MODE_GAME` (1)
  - Description: Changes the chat mode between lobby and game modes, affecting the chat's appearance and behavior

### NUI Integration

The resource uses a minimal HTML interface for text input handling, with the following features:

- Hidden input field for text entry
- Character filtering
- Keyboard event handling
- Automatic focus management

### Demo Implementation

The resource includes a demo implementation in `client/main.lua` that showcases the basic functionality of the chat system. Here's what the demo includes:

1. **Basic Setup**
   - Creates a new chat instance with default options
   - Defines chat scopes (All, Team, Friends, Crew)
   - Loads the scaleform on resource start

2. **Input Handling**
   - Implements NUI callbacks for keyboard input
   - Handles special keys (Backspace, Enter, Escape, PageUp/Down)
   - Filters input characters for security

3. **Chat Controls**
   - `T` (245) - Open chat for all players
   - `Y` (246) - Open team chat
   - `U` (247) - Open friends chat
   - `O` (248) - Open crew chat
   - `Page Up/Down` - Navigate chat history
   - `Enter` - Send message
   - `Escape` - Close chat
   - `Backspace` - Delete character

4. **Demo Messages**
   - Simulates random messages from other players
   - Messages are sent at random intervals (1-19 seconds)
   - Each message includes a counter to demonstrate chat history

To try the demo:
1. Start the resource
2. Use the chat keys (T, Y, U, O) to open different chat scopes
3. Type messages and press Enter to send
4. Use Page Up/Down to navigate through chat history
5. Watch for simulated messages from "Random" player
