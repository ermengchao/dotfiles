function _fzf_lsof
    lsof -i -sTCP:LISTEN -n -P | fzf
    commandline -f repaint
end
