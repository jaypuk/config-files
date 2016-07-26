for /f "tokens=1-3 delims=/ " %%u in ('date /t') do for /f "tokens=1,2 delims=:" %%a in ('time /t') do mkdir %%w-%%v-%%u-%%a.%%b.00
