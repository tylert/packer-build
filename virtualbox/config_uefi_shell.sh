#!/usr/bin/env bash

# http://ubuntuforums.org/showthread.php?t=2172199&p=13104689#post13104689

# > edit startup.nsh
#FS0:\EFI\debian\grubx64.efi
# ^S
# ^Q

# # hexdump /boot/efi/startup.nsh
#0000000 feff 0046 0053 0030 003a 005c 0045 0046
#0000010 0049 005c 0064 0065 0062 0069 0061 006e
#0000020 005c 0067 0072 0075 0062 0078 0036 0034
#0000030 002e 0065 0066 0069                    
#0000038

echo 'FS0:\EFI\debian\grubx64.efi' > /boot/efi/startup.nsh

#0000000 5346 3a30 455c 4946 645c 6265 6169 5c6e
#0000010 7267 6275 3678 2e34 6665 0a69          
#000001c
