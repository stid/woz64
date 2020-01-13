# VSCODE

``` json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "build -> C64 -> VICE",
            "type": "shell",
            "osx": {
                "command": "java -jar /opt/develop/stid/c64/KickAssembler/KickAss.jar -odir bin -log /opt/develop/stid/c64/woz64/bin/buildlog.txt -showmem /opt/develop/stid/c64/woz64/main.asm && /usr/local/bin/x64 bin/main.prg 2> /dev/null"
            },
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "presentation": {
                "clear": true
            },
            "problemMatcher": {
                "owner": "acme",
                "fileLocation": [
                    "relative",
                    "${workspaceFolder}"
                ],
                "pattern": {
                    "regexp": "^(Error - File\\s+(.*), line (\\d+) (\\(Zone .*\\))?:\\s+(.*))$",
                    "file": 2,
                    "location": 3,
                    "message": 1
                }
            }
        }
    ]
}
```


# Compile to Cart (Vice)

``` bash
cartconv -t normal -name "woz" -i main.prg -o woz.crt
x64 woz.crt
cartconv -i woz.crt -o woz.bin
```
