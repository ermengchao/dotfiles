function sync_brew_cache
    rsync -rtv --exclude='*.incomplete' (brew --cache)/downloads/ mac-mini:(brew --cache)/downloads/
end
