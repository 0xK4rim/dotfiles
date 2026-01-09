import QtQuick 2.15
import QtQuick.Controls 2.15
import Quickshell

Item {
    id: root
    width: 600
    height: 400

    property var keymapsArray: []

    Component.onCompleted: {
        // Example shortcuts to demonstrate different options
        keymapsArray = [
            // Basic insert mode exit
            { "lhs": "jj", "rhs": "<Esc>", "desc": "Example" },

            { "lhs": ".", "rhs": "Repeat last change" },
            { "lhs": "u", "rhs": "Undo last change" },
            { "lhs": "<C-R>", "rhs": "Redo last change" },
            { "lhs": ">G", "rhs": "Increase identation from the current line to the EOF" },
            { "lhs": "a", "rhs": "Append at the end of the cursor position (i.e. after the cursos)" },
            { "lhs": "A", "rhs": "Append at the end of the line" },
            { "lhs": "I", "rhs": "Append at the start of the line" },
            { "lhs": "o/O", "rhs": "Add line below/above the cursor and go to insert mode" },
            { "lhs": "p/P", "rhs": "Paste before/after the cursor position" },
            { "lhs": "<leader>p/d", "rhs": "Paste/Delete without losing the paste buffer" },
            { "lhs": "<leader>y", "rhs": "Yank to the clipboard (Y for the entire line)" },
            { "lhs": "<leader>c", "rhs": "Copy the whole file to the clipboard" },
            { "lhs": "K/J", "rhs": "[VISUAL MODE] Move the selected text up/down" },
            { "lhs": "J", "rhs": "Append the line below to the current line" },
            { "lhs": "<C-u/d>", "rhs": "Navigate page up/down" },

            // Visual mode yank
            { "lhs": "y", "rhs": "y$", "desc": "Yank to end of line" },

            // Motion + text object
            { "lhs": "daw", "rhs": "Delete a word", "desc": "Delete word under cursor" },

            // Mapping with description but no rhs
            { "lhs": "gd", "desc": "Jump to definition" },

            // Mapping with rhs but no description
            { "lhs": "<C-^>", "rhs": ":b#<CR>" },

            // Complex leader sequence
            { "lhs": "<leader>fg", "rhs": ":Telescope live_grep<CR>", "desc": "Search text in project" },

            // Command with multiple keys
            { "lhs": "<leader>fb", "rhs": ":Telescope buffers<CR>", "desc": "Switch buffer" },

            // Shortcut with special keys
            { "lhs": "<Tab>", "rhs": "Next completion item", "desc": "Tab in insert mode completion" },

            // Shortcut with multiple modifiers
            { "lhs": "<C-S-Tab>", "rhs": "Previous completion item", "desc": "Shift+Ctrl+Tab" },

            { "lhs": "<C-w> w", "rhs": "Move to the next window (in the order of creation)"},
            { "desc": "Extension Shortcuts" },
            { "lhs": "<C-p>", "rhs": "Telescope: Search files inside the current working directory" },
            { "lhs": "<leader>fg", "rhs": "Telescope: Search in the files in the project (live_grep)"},
            { "lhs": "K", "rhs": "LSP: Hover"},
            { "lhs": "<leader>gd", "rhs": "LSP: Go to the definition"},
            { "lhs": "<leader>gr", "rhs": "LSP: Go to the reference"},
            { "lhs": "<leader>ta", "rhs": "LSP: Take action"},
            { "lhs": "<leader>suba", "rhs": "LSP: Rename all occurences (the whole workspace)"},
            { "lhs": "<leader>subw", "rhs": "[None]: Rename all occurences (the whole file)"},
            { "lhs": "<leader>x", "rhs": "[None]: Make the current file executable"},
            { "lhs": "<leader>gf", "rhs": "None-ls: Fix formatting for the whole file"},
            { "lhs": "<C-n>", "rhs": "Neotree: Show Neotree"},
            { "lhs": ".", "rhs": "Neotree: Make the current folder the workspace"},
            { "lhs": "H", "rhs": "Neotree: Show hidden files"},
            { "lhs": "<leader>u", "rhs": "Undotree: Open undotree"},
            { "lhs": "<C-e>", "rhs": "Harpoon: Toggle list"},
            { "lhs": "<leader>a", "rhs": "Harpoon: add (to the end)"},
            { "lhs": "<leader>A", "rhs": "Harpoon: prepend (to the beginning)"},
            { "lhs": "<C-[F1-F4]>", "rhs": "Harpoon: Select file [1-4]"},
        ]
    }

    Flickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.implicitHeight
        clip: true

        Column {
            id: column
            width: parent.width
            spacing: 6
            padding: 8

            Repeater {
                model: keymapsArray
                delegate: Row {
                    spacing: 8
                    width: parent.width

                    // Key combination
                    Text { text: modelData.lhs || ""; font.bold: true; color: "white"; width: 120; elide: Text.ElideRight }

                    // Description
                    Text { text: modelData.desc ? ("— " + modelData.desc) : ""; color: "white"; width: 300; elide: Text.ElideRight }

                    // Command executed
                    Text { text: modelData.rhs ? ("— " + modelData.rhs) : ""; color: "white"; width: 180; horizontalAlignment: Text.AlignRight }
                }
            }
        }
    }
}
