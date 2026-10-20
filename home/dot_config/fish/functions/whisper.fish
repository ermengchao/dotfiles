function whisper --description 'Whisper with a custom model directory'
    set -l data_home "$HOME/.local/share"
    if set -q XDG_DATA_HOME; and test -n "$XDG_DATA_HOME"
        set data_home "$XDG_DATA_HOME"
    end

    command whisper --model_dir "$data_home/whisper/models" $argv
end
