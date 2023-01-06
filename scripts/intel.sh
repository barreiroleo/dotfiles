#!/bin/bash

# Intel graphics drivers support VA-API
$(install-pac) libva-intel-driver

# Translation layers. VDPAU-based backend for VA-API
$(install-pac) libva-vdpau-driver
# Translation layers. VDPAU driver with OpenGL/VAAPI backend H.264 only
$(install-pac) libvdpau-va-gl
# VDPAU driver needed to be in environment
sudo echo VDPAU_DRIVER=va_gl >> /etc/environment

# Verification
$(install-pac) intel-gpu-tools
sudo intel_gpu_top
# Verifying VA-API
$(install-pac) libva-utils
vainfo
# Verifying VDPAU
$(install-pac) vdpauinfo
vdpauinfo

