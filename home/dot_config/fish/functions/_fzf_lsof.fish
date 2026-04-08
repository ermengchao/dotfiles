function _fzf_lsof
    lsof | fzf
    commandline -f repaint
end
