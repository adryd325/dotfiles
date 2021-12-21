Colored logging through gnome-terminal for launched minecraft clients
This is too cursed for me to want to automate it, at least the library part lol

How to:

add this to your fabric json (this makes the class_jlkhfljshfdlj stuff turn to simply "Minecraft")
```
{
    "name": "net.minecrell:terminalconsoleappender:1.2.0",
    "url": "https://repo1.maven.org/maven2/"
}
```

add these launch args
`-Dlog4j.configurationFile=/home/adryd/.adryd/systems/personal/multimc/log4j.xml -Dlog4j2.formatMsgNoLookups=true`

make your wrapper command `cursed-mc-run`