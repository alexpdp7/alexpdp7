When using a laptop with display through USB-C and Debian Bookworm, you can get black screens sometimes.
`dmesg` shows errors when this happens.
Using the kernel from backports addresses the issue.
(However, note that firmware packages are different in backports, so you might need to pull more firmware packages from backports to keep wireless networking.)
