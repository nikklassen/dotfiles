on run argv
    tell application "Skim"
        set d to first window's document
        if item 1 of argv equals "+" then
            set new_page to item ((d's current page's index) + 1) of d's pages
        else
            set new_page to item ((d's current page's index) - 1) of d's pages
        end if
        set d's current page to new_page
    end tell
end run
