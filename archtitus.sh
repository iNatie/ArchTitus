<<<<<<< Updated upstream
#!/usr/bin/env bash

    bash 0-preinstall.sh
    arch-chroot /mnt /root/ArchTitus/1-setup.sh
    source /mnt/root/ArchTitus/install.conf
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchTitus/2-user.sh
=======
#!/usr/bin/env bash

    bash 0-preinstall.sh
    arch-chroot /mnt /root/ArchTitus/1-setup.sh
    source /mnt/root/ArchTitus/install.conf
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchTitus/2-user.sh
>>>>>>> Stashed changes
    arch-chroot /mnt /root/ArchTitus/3-post-setup.sh