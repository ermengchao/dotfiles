function convert
    if test (count $argv) -eq 0
        echo "Usage: convert .crx or dict"
        exit 1
    end

    set item $argv[1]

    if test -f $item
        set extension (string split "." $item)[-1]
        if test $extension = crx
            set crx_file $item
            set zip_file (string replace -r '\.crx$' '.zip' $crx_file)
            set extracted_dir (string replace -r '\.crx$' '_extracted' $crx_file)

            python3 ~/Library/Mobile\ Documents/com~apple~CloudDocs/bin/CRX-Extractor.py $crx_file $zip_file
            unzip -q $zip_file -d $extracted_dir
            rm $zip_file

            xcrun /Applications/Xcode.app/Contents/Developer/usr/bin/safari-web-extension-converter $extracted_dir
            return
        else
            echo "Invalid .crx file."
            exit 1
        end
    end

    if test -d $item
        xcrun /Applications/Xcode.app/Contents/Developer/usr/bin/safari-web-extension-converter $item
        return
    end

    echo "Invalid Parameter."
    exit 1
end
