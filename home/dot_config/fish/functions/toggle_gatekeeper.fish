function gatekeeper
    if test (count $argv) -ne 1
        set argv[1] help
    end

    switch $argv[1]
        case help
            echo ''
            echo 'Gatekeeper is a security feature in macOS designed to protect users from running potentially malicious software.'
            echo ''
            echo 'Disable gatekeeper:'
            echo '  sudo spctl --master-disable'
            echo ''
            echo 'Allow unauthorized application:'
            echo '  xattr -cr /path/to/application'
            echo ''
            echo 'Enable gatekeeper:'
            echo '  sudo spctl --master-enable'
            echo ''
    end
end
