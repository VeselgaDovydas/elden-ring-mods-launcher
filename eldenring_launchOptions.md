PROTON_NO_FSYNC=1 gamemoderun  VKD3D_FEATURE_LEVEL=12_0  %command% 

Current - gamemoderun PROTON_NO_FSYNC=1 VKD3D_FEATURE_LEVEL=12_0 %command%


cmd=(%command%); cmd[-1]="eldenring.exe"; WINEDLLOVERRIDES="dinput8=n,b;dxgi=n,b" "${cmd[@]}"


If Dlls needed-  ~/Desktop/launch_eldenring.sh %command%

PROTON_NO_FSYNC=1 gamemoderun  VKD3D_FEATURE_LEVEL=12_0  %command% 
