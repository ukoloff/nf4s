@Echo off
set Configuration=Debug
:set Configuration=Release
set Platform=x86
:set Platform=x64
"C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe" nf4s.sln /m /t:build /verbosity:minimal
