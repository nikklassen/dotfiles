iex "&{$(irm 'https://get.chezmoi.io/ps1')} -b '~/.local/bin'"
~\.local\bin\chezmoi init --apply --source "$(pwd)" nikklassen
