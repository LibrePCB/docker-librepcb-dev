FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Install Chocolatey
RUN powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command \
  "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" \
  && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

# Install Chocolatey Packages
# Note: Funq requires to install x86 Python since Qt is also x86!
ENV PYTHONIOENCODING "UTF-8"
RUN choco install -y 7zip ccache vcredist2017 \
  && choco install -y git --params "/GitAndUnixToolsOnPath /NoAutoCrlf" \
  && choco install --forcex86 -y python3 --version 3.10.0 \
  && choco install -y cmake --version 3.21.3 --installargs "ADD_CMAKE_TO_PATH=System"

# Extract all files to C:/
ADD files.tar.gz C:/

# Add tools to PATH
RUN setx PATH "%PATH%;C:\Qt\Tools\mingw810_32\bin" \
  && setx PATH "%PATH%;C:\Qt\5.15.2\mingw81_32\bin" \
  && setx PATH "%PATH%;C:\Qt\QtIFW\bin"
