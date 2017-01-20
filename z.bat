@Echo Off
For %%P in (x86 x64) Do (
For %%C in (Debug Release) Do (
Set Platform=%%P
Set Configuration= %%C
Echo %%C:%%P
))
